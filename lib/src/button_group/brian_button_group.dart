import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../button/brian_button.dart';
import '../button/button_metrics.dart';
import '../spacing/brian_spacing.dart';
import '../theme/brian_theme.dart';

/// 버튼 그룹의 텍스트 액션과 표현 상태를 전달합니다.
///
/// [onPressed]가 null이면 비활성화됩니다. [variant]를 생략하면 그룹에서
/// 주요 액션은 neutralSolid, 보조 액션은 neutralWeak로 표시합니다.
/// 로딩과 비동기 작업의 완료·실패 처리는 호출자가 관리합니다.
///
/// {@category ButtonGroup}
@immutable
class BrianButtonGroupAction {
  const BrianButtonGroupAction({
    required this.label,
    required this.onPressed,
    this.variant,
    this.isLoading = false,
    this.autofocus = false,
  }) : assert(label.length > 0);

  final String label;
  final VoidCallback? onPressed;
  final BrianButtonVariant? variant;
  final bool isLoading;
  final bool autofocus;
}

/// 하나 또는 두 개의 텍스트 버튼을 가용 너비에 맞춰 배치합니다.
///
/// 유한한 너비 안에 배치하세요. 단일 버튼은 전체 너비를 채우며, 두 버튼은
/// 같은 너비로 나눕니다. 가로 배치에서 어느 라벨이든 한 줄에 들어가지 않으면
/// 둘 다 세로로 전환합니다. 현재 글꼴·글자 확대·명시적 줄바꿈을 반영합니다.
/// 가로 순서는 읽기 방향 기준 보조→주요, 세로 순서는 위부터 주요→보조입니다.
/// 긴 라벨은 말줄임 없이 표시하며 버튼 사이 간격은 8 논리 픽셀입니다.
///
/// 그룹은 액션을 실행할 뿐 모달을 닫거나 다른 액션을 자동으로 잠그지 않습니다.
///
/// {@category ButtonGroup}
class BrianButtonGroup extends StatelessWidget {
  const BrianButtonGroup({
    super.key,
    required this.primaryAction,
    this.secondaryAction,
    this.size = BrianButtonSize.medium,
  });

  final BrianButtonGroupAction primaryAction;
  final BrianButtonGroupAction? secondaryAction;
  final BrianButtonSize size;

  @override
  Widget build(BuildContext context) {
    final metrics = ButtonMetrics(size, BrianTheme.of(context).typography);
    final style = DefaultTextStyle.of(context).style.merge(metrics.textStyle);
    final secondary = secondaryAction;
    Widget button(BrianButtonGroupAction action, {required bool primary}) =>
        BrianButton(
          key: ValueKey(primary),
          variant:
              action.variant ??
              (primary
                  ? BrianButtonVariant.neutralSolid
                  : BrianButtonVariant.neutralWeak),
          size: size,
          autofocus: action.autofocus,
          onPressed: action.onPressed,
          isLoading: action.isLoading,
          child: Text(action.label),
        );
    if (secondary == null) {
      return SizedBox(
        width: double.infinity,
        child: button(primaryAction, primary: true),
      );
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final labelWidth = math.max(
          0.0,
          (constraints.maxWidth - BrianSpacing.x2) / 2 -
              (metrics.paddingX + metrics.borderWidth) * 2,
        );
        bool wraps(String label) {
          final painter = TextPainter(
            text: TextSpan(text: label, style: style),
            textDirection: Directionality.of(context),
            textScaler: MediaQuery.textScalerOf(context),
            locale: Localizations.maybeLocaleOf(context),
            maxLines: 1,
          )..layout(maxWidth: labelWidth);
          final result =
              painter.didExceedMaxLines || painter.width > labelWidth;
          painter.dispose();
          return result;
        }

        final primaryButton = button(primaryAction, primary: true);
        final secondaryButton = button(secondary, primary: false);
        if (wraps(primaryAction.label) || wraps(secondary.label)) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              primaryButton,
              const SizedBox(height: BrianSpacing.x2),
              secondaryButton,
            ],
          );
        }
        return Row(
          children: [
            Expanded(child: secondaryButton),
            const SizedBox(width: BrianSpacing.x2),
            Expanded(child: primaryButton),
          ],
        );
      },
    );
  }
}
