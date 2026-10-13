import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../button/brian_button.dart';
import '../button_group/brian_button_group.dart';
import '../radius/brian_radius.dart';
import '../spacing/brian_spacing.dart';
import '../theme/brian_theme.dart';

/// 선택할 때 반환할 값과 버튼 표현을 묶습니다.
///
/// [label]은 비어 있지 않은 문구를 사용합니다. 취소 액션에는
/// [BrianButtonVariant.neutralWeak], 삭제에는
/// [BrianButtonVariant.criticalSolid]를 지정할 수 있습니다.
///
/// {@category AlertDialog}
@immutable
class BrianAlertDialogAction<T> {
  const BrianAlertDialogAction({
    required this.label,
    required this.value,
    this.variant = BrianButtonVariant.neutralSolid,
    this.onPressed,
  }) : assert(label.length > 0);

  final String label;
  final T value;
  final BrianButtonVariant variant;

  /// 완료 후 선택을 전달합니다. 대기 중에는 선택한 버튼에 로딩을 표시하고
  /// 모든 액션을 잠급니다. 실패하면 FlutterError로 보고하고 다시 선택할 수
  /// 있도록 유지합니다. 생략하면 즉시 선택합니다.
  final Future<void> Function()? onPressed;
}

/// 제목·설명과 하나 또는 두 개의 액션으로 확인을 요청합니다.
///
/// [description]은 필수이며 [title]은 생략할 수 있습니다. 가로 배치에서
/// 어느 버튼의 라벨이든 두 줄 이상이면 두 버튼을 세로로 배치합니다.
/// 순서는 가로에서 읽기 방향 기준 보조→주요, 세로에서 위부터 주요→보조입니다.
/// 첫 포커스는 보조 액션, 없으면 주요 액션에 놓입니다.
///
/// 이 위젯은 본문만 구성하고 선택을 [onSelected]로 전달합니다.
/// 모달 표시와 닫기 정책은 [showBrianAlertDialog]를 사용하세요.
///
/// {@category AlertDialog}
class BrianAlertDialog<T> extends StatefulWidget {
  const BrianAlertDialog({
    super.key,
    required this.description,
    required this.primaryAction,
    required this.onSelected,
    this.title,
    this.secondaryAction,
  }) : assert(description.length > 0),
       assert(title == null || title.length > 0);

  final String? title;
  final String description;
  final BrianAlertDialogAction<T> primaryAction;
  final BrianAlertDialogAction<T>? secondaryAction;
  final ValueChanged<T> onSelected;

  @override
  State<BrianAlertDialog<T>> createState() => _BrianAlertDialogState<T>();
}

class _BrianAlertDialogState<T> extends State<BrianAlertDialog<T>> {
  BrianAlertDialogAction<T>? _pending;

  Future<void> _select(BrianAlertDialogAction<T> action) async {
    if (_pending != null) return;
    if (action.onPressed == null) {
      widget.onSelected(action.value);
      return;
    }
    setState(() => _pending = action);
    try {
      await action.onPressed!();
    } catch (error, stack) {
      if (mounted) setState(() => _pending = null);
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stack,
          library: 'brian_ui',
          context: ErrorDescription('알림 다이얼로그 액션 처리 중'),
        ),
      );
      return;
    }
    if (!mounted) return;
    widget.onSelected(action.value);
    if (mounted) setState(() => _pending = null);
  }

  @override
  Widget build(BuildContext context) {
    final theme = BrianTheme.of(context);
    final textStyle = theme.typography.t5Regular.copyWith(
      color: theme.colors.foreground.neutral,
    );
    return Semantics(
      scopesRoute: true,
      namesRoute: true,
      explicitChildNodes: true,
      label: widget.title ?? widget.description,
      child: DefaultTextStyle(
        style: textStyle,
        textAlign: TextAlign.center,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 272),
          decoration: BoxDecoration(
            color: theme.colors.background.layerFloating,
            borderRadius: BorderRadius.circular(BrianRadius.r5),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(BrianSpacing.x5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (widget.title != null) ...[
                  Semantics(
                    header: true,
                    child: Text(widget.title!, style: theme.typography.t7Bold),
                  ),
                  const SizedBox(height: BrianSpacing.x1Point5),
                ],
                Text(widget.description),
                const SizedBox(height: BrianSpacing.x4),
                _AlertDialogFooter<T>(
                  primary: widget.primaryAction,
                  secondary: widget.secondaryAction,
                  onSelected: _select,
                  pending: _pending,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 명시적인 버튼 선택으로만 닫히는 모달을 표시합니다.
///
/// [context]의 [BrianTheme]을 표시할 라우트에 전달하고 선택한 액션의 값을
/// 반환합니다. 바깥 터치·시스템 뒤로가기·Esc로는 닫히지 않습니다.
/// 다른 라우트에 가려진 동안 선택이 완료되어도 이 다이얼로그만 닫습니다.
/// 앱이 직접 라우트를 제거하거나 pop하면 null이 반환될 수 있습니다.
/// [useRootNavigator]가 true이면 최상위 Navigator에 표시합니다.
/// 상태 복원은 지원하지 않습니다.
///
/// {@category AlertDialog}
Future<T?> showBrianAlertDialog<T>({
  required BuildContext context,
  required String description,
  required BrianAlertDialogAction<T> primaryAction,
  String? title,
  BrianAlertDialogAction<T>? secondaryAction,
  bool useRootNavigator = true,
}) {
  final theme = BrianTheme.of(context);
  final navigator = Navigator.of(context, rootNavigator: useRootNavigator);
  final themes = InheritedTheme.capture(from: context, to: navigator.context);
  final reduceMotion = MediaQuery.disableAnimationsOf(context);
  var selected = false;
  return navigator.push<T>(
    RawDialogRoute<T>(
      barrierDismissible: false,
      barrierColor: theme.colors.background.overlay,
      requestFocus: true,
      traversalEdgeBehavior: TraversalEdgeBehavior.closedLoop,
      directionalTraversalEdgeBehavior: TraversalEdgeBehavior.closedLoop,
      transitionDuration: reduceMotion
          ? Duration.zero
          : const Duration(milliseconds: 150),
      pageBuilder: (routeContext, animation, secondaryAnimation) {
        final media = MediaQuery.of(routeContext);
        final verticalInset = math.max(media.padding.top, media.padding.bottom);
        final availableHeight =
            media.size.height - media.viewInsets.vertical - verticalInset * 2;
        // 짧은 화면에서는 고정 여백보다 스크롤할 본문 영역을 우선합니다.
        final verticalSpacing = ((availableHeight - 128) / 2).clamp(
          0.0,
          BrianSpacing.x16,
        );
        return themes.wrap(
          PopScope<T>(
            canPop: false,
            child: Shortcuts(
              shortcuts: const {
                SingleActivator(LogicalKeyboardKey.escape): DoNothingIntent(),
              },
              child: Padding(
                padding:
                    media.viewInsets +
                    EdgeInsets.fromLTRB(
                      media.padding.left + BrianSpacing.x8,
                      verticalInset + verticalSpacing,
                      media.padding.right + BrianSpacing.x8,
                      verticalInset + verticalSpacing,
                    ),
                child: Center(
                  child: BrianAlertDialog<T>(
                    title: title,
                    description: description,
                    primaryAction: primaryAction,
                    secondaryAction: secondaryAction,
                    onSelected: (value) {
                      // 종료 애니메이션 중 중복 입력이 아래 라우트를 닫지 않게 합니다.
                      final route = ModalRoute.of<T>(routeContext)!;
                      if (selected || !route.isActive) return;
                      selected = true;
                      if (route.isCurrent) {
                        navigator.pop<T>(value);
                      } else {
                        navigator.removeRoute<T>(route, value);
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
}

class _AlertDialogFooter<T> extends StatelessWidget {
  const _AlertDialogFooter({
    required this.primary,
    required this.secondary,
    required this.onSelected,
    required this.pending,
  });

  final BrianAlertDialogAction<T> primary;
  final BrianAlertDialogAction<T>? secondary;
  final ValueChanged<BrianAlertDialogAction<T>> onSelected;
  final BrianAlertDialogAction<T>? pending;

  @override
  Widget build(BuildContext context) {
    BrianButtonGroupAction action(
      BrianAlertDialogAction<T> value, {
      required bool autofocus,
    }) => BrianButtonGroupAction(
      label: value.label,
      variant: value.variant,
      autofocus: autofocus,
      onPressed: pending == null ? () => onSelected(value) : null,
      isLoading: identical(pending, value),
    );
    return BrianButtonGroup(
      primaryAction: action(primary, autofocus: secondary == null),
      secondaryAction: secondary == null
          ? null
          : action(secondary!, autofocus: true),
    );
  }
}
