import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../radius/brian_radius.dart';
import '../scroll_fog/brian_scroll_fog.dart';
import '../spacing/brian_spacing.dart';
import '../theme/brian_theme.dart';

/// 콘텐츠 크기에 맞추고 화면 높이가 부족하면 내부를 스크롤하는 모달입니다.
///
/// [builder]에는 별도 세로 ScrollView나 Expanded 대신 Column 등 일반 콘텐츠를
/// 반환하세요. [headerBuilder]·[footerBuilder]는 고정 영역이며 [builder]의
/// 콘텐츠만 스크롤합니다. 콘텐츠 최상단에서 아래로 드래그하면
/// 핸들 표시 여부와 관계없이 전체 시트가 따라 내려옵니다. 휠은 닫지 않습니다.
/// [enableDrag]는 드래그 닫기만, [barrierDismissible]은 바깥 터치만 제어합니다.
/// Esc·시스템 뒤로가기로 닫을 수 있고 Navigator.pop의 결과를 반환합니다.
/// [context]의 테마를 전달하며 키보드와 안전 영역을 피합니다.
///
/// {@category BottomSheet}
Future<T?> showBrianBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  WidgetBuilder? headerBuilder,
  WidgetBuilder? footerBuilder,
  bool showHandle = true,
  bool enableDrag = true,
  bool barrierDismissible = true,
  bool useRootNavigator = true,
  String semanticLabel = '바텀 시트',
}) {
  final theme = BrianTheme.of(context);
  final navigator = Navigator.of(context, rootNavigator: useRootNavigator);
  final themes = InheritedTheme.capture(from: context, to: navigator.context);
  final reduceMotion = MediaQuery.disableAnimationsOf(context);
  return navigator.push<T>(
    RawDialogRoute<T>(
      barrierDismissible: barrierDismissible,
      barrierLabel: '닫기',
      barrierColor: theme.colors.background.overlay,
      requestFocus: true,
      traversalEdgeBehavior: TraversalEdgeBehavior.closedLoop,
      transitionDuration: reduceMotion
          ? Duration.zero
          : const Duration(milliseconds: 250),
      transitionBuilder: (context, animation, secondaryAnimation, child) =>
          child,
      pageBuilder: (context, animation, secondaryAnimation) => themes.wrap(
        Builder(
          builder: (context) {
            final media = MediaQuery.of(context);
            return Shortcuts(
              shortcuts: const {
                SingleActivator(LogicalKeyboardKey.escape): DismissIntent(),
              },
              child: Actions(
                actions: {
                  DismissIntent: CallbackAction<DismissIntent>(
                    onInvoke: (_) {
                      Navigator.maybeOf(context)?.maybePop();
                      return null;
                    },
                  ),
                },
                child: Focus(
                  autofocus: true,
                  child: Padding(
                    padding: media.viewInsets,
                    child: SafeArea(
                      bottom: false,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: SlideTransition(
                          position: animation.drive(
                            Tween(
                              begin: const Offset(0, 1),
                              end: Offset.zero,
                            ).chain(CurveTween(curve: Curves.easeOutCubic)),
                          ),
                          child: BrianBottomSheet(
                            showHandle: showHandle,
                            onDismiss: enableDrag
                                ? () => Navigator.of(context).maybePop()
                                : null,
                            semanticLabel: semanticLabel,
                            header: headerBuilder == null
                                ? null
                                : Builder(builder: headerBuilder),
                            footer: footerBuilder == null
                                ? null
                                : Builder(builder: footerBuilder),
                            child: Builder(builder: builder),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ),
  );
}

/// 자체 스크롤과 선택적 드래그 닫기를 제공하는 시트 표면입니다.
///
/// 유한한 높이 제약 안에 배치하세요. [header]·[footer]는 고정하고 [child]만
/// 스크롤합니다. [child]는 별도 세로 스크롤 없이 구성합니다.
/// [footer]가 있으면 본문 하단에 80px ScrollFog와 같은 깊이의 스크롤
/// 패딩을 제공합니다. Fog는 끝에서도 유지되며 패딩이 마지막 내용을 보호합니다.
/// 고정 영역은 화면에 들어가는 간결한 콘텐츠로 구성하세요.
/// 헤더·푸터·여백에서의 드래그는 본문이 최상단일 때만 시트를 움직입니다.
/// [onDismiss]가 없으면 드래그로 움직이지 않습니다. 핸들은 시각적 단서입니다.
/// 모달·포커스·키보드 처리는 [showBrianBottomSheet]를 사용하세요.
///
/// {@category BottomSheet}
class BrianBottomSheet extends StatefulWidget {
  const BrianBottomSheet({
    super.key,
    required this.child,
    this.header,
    this.footer,
    this.showHandle = true,
    this.onDismiss,
    this.semanticLabel = '바텀 시트',
  });

  final Widget child;
  final Widget? header;
  final Widget? footer;
  final bool showHandle;
  final VoidCallback? onDismiss;
  final String semanticLabel;

  @override
  State<BrianBottomSheet> createState() => _BrianBottomSheetState();
}

class _BrianBottomSheetState extends State<BrianBottomSheet>
    with SingleTickerProviderStateMixin {
  late final _offset = AnimationController.unbounded(vsync: this);
  late final _scroll = _SheetScrollController(this);
  final _surface = GlobalKey();
  bool _closing = false;
  bool _draggingSurface = false;
  bool _pointerCancelled = false;

  double _consume(double delta, double pixels) {
    if (widget.onDismiss == null || _closing) return delta;
    _offset.stop();
    if (_offset.value > 0 || (delta > 0 && pixels <= 0)) {
      final next = _offset.value + delta;
      _offset.value = math.max(0, next);
      return math.min(0, next);
    }
    // 한 번의 이동으로 최상단에 도달하면 남은 거리를 시트에 전달합니다.
    if (delta > pixels && pixels > 0) {
      _offset.value = delta - pixels;
      return pixels;
    }
    return delta;
  }

  void _release(double velocity) {
    if (_offset.value <= 0 || _closing) return;
    if (_pointerCancelled) {
      _restore();
      return;
    }
    final height = _surface.currentContext?.size?.height ?? 400;
    if (velocity <= 0 && (_offset.value > height * .25 || velocity < -700)) {
      _closing = true;
      widget.onDismiss?.call();
      // 닫히는 동안에는 드래그 위치를 유지해 위로 되튀지 않게 합니다.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && ModalRoute.of(context)?.isCurrent != false) {
          _restore();
        }
      });
      return;
    }
    _restore();
  }

  void _restore() {
    _offset
        .animateTo(
          0,
          duration: MediaQuery.disableAnimationsOf(context)
              ? Duration.zero
              : const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
        )
        .whenComplete(() => _closing = false);
  }

  @override
  void dispose() {
    _scroll.dispose();
    _offset.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = BrianTheme.of(context);
    return Listener(
      onPointerDown: (_) => _pointerCancelled = false,
      // 인식된 드래그는 PointerCancel도 onEnd로 전달되므로 원본 취소를 기록합니다.
      onPointerCancel: (_) => _pointerCancelled = true,
      child: AnimatedBuilder(
        animation: _offset,
        builder: (context, child) =>
            Transform.translate(offset: Offset(0, _offset.value), child: child),
        child: SizedBox(
          width: 640,
          child: Semantics(
            scopesRoute: true,
            explicitChildNodes: true,
            namesRoute: true,
            label: widget.semanticLabel,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(BrianRadius.r6),
              ),
              child: ColoredBox(
                key: _surface,
                color: theme.colors.background.layerDefault,
                child: DefaultTextStyle(
                  style: theme.typography.t4Regular.copyWith(
                    color: theme.colors.foreground.neutral,
                  ),
                  child: GestureDetector(
                    dragStartBehavior: DragStartBehavior.down,
                    behavior: HitTestBehavior.opaque,
                    onVerticalDragStart: widget.onDismiss == null
                        ? null
                        : (_) {
                            _draggingSurface = true;
                            _scroll.position.goIdle();
                            _offset.stop();
                          },
                    onVerticalDragUpdate: widget.onDismiss == null
                        ? null
                        : (details) {
                            // 본문 Scrollable이 제스처를 소유하면 이 콜백은 호출되지 않습니다.
                            // 고정 영역에서는 본문을 스크롤하지 않고 최상단 여부만 확인합니다.
                            if (_scroll.position.pixels <=
                                _scroll.position.minScrollExtent) {
                              _consume(details.primaryDelta!, 0);
                            }
                          },
                    onVerticalDragEnd: widget.onDismiss == null
                        ? null
                        : (details) {
                            _draggingSurface = false;
                            _release(-details.primaryVelocity!);
                          },
                    onVerticalDragCancel: widget.onDismiss == null
                        ? null
                        : () {
                            // 본문에 제스처를 넘긴 경우 복귀 애니메이션을 시작하지 않습니다.
                            if (!_draggingSurface) return;
                            _draggingSurface = false;
                            _restore();
                          },
                    child: SafeArea(
                      top: false,
                      child: Padding(
                        padding: const EdgeInsets.all(BrianSpacing.x6),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (widget.showHandle) ...[
                              Center(
                                child: Container(
                                  width: 36,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: theme.colors.stroke.neutralWeak,
                                    borderRadius: BorderRadius.circular(
                                      BrianRadius.r1,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: BrianSpacing.x5),
                            ],
                            if (widget.header != null) ...[
                              Semantics(
                                container: true,
                                explicitChildNodes: true,
                                child: widget.header!,
                              ),
                              const SizedBox(height: BrianSpacing.x5),
                            ],
                            Flexible(
                              child: Stack(
                                fit: StackFit.passthrough,
                                children: [
                                  ScrollConfiguration(
                                    behavior: const ScrollBehavior().copyWith(
                                      dragDevices: PointerDeviceKind.values
                                          .toSet(),
                                      overscroll: false,
                                      scrollbars: false,
                                    ),
                                    child: SingleChildScrollView(
                                      dragStartBehavior: DragStartBehavior.down,
                                      controller: _scroll,
                                      physics:
                                          const AlwaysScrollableScrollPhysics(
                                            parent: ClampingScrollPhysics(),
                                          ),
                                      padding: widget.footer == null
                                          ? EdgeInsets.zero
                                          : const EdgeInsets.only(bottom: 80),
                                      child: widget.child,
                                    ),
                                  ),
                                  if (widget.footer != null)
                                    const Positioned.fill(
                                      child: Align(
                                        alignment: Alignment.bottomCenter,
                                        child: BrianScrollFog(),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            if (widget.footer != null) ...[
                              Semantics(
                                container: true,
                                explicitChildNodes: true,
                                child: widget.footer!,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SheetScrollController extends ScrollController {
  _SheetScrollController(this.sheet);
  final _BrianBottomSheetState sheet;

  @override
  _SheetScrollPosition get position => super.position as _SheetScrollPosition;

  @override
  ScrollPosition createScrollPosition(
    ScrollPhysics physics,
    ScrollContext context,
    ScrollPosition? oldPosition,
  ) => _SheetScrollPosition(
    physics: physics,
    context: context,
    oldPosition: oldPosition,
    sheet: sheet,
  );
}

class _SheetScrollPosition extends ScrollPositionWithSingleContext {
  _SheetScrollPosition({
    required super.physics,
    required super.context,
    super.oldPosition,
    required this.sheet,
  });
  final _BrianBottomSheetState sheet;

  @override
  Drag drag(DragStartDetails details, VoidCallback dragCancelCallback) =>
      _SheetDrag(super.drag(details, dragCancelCallback), sheet);

  @override
  void applyUserOffset(double delta) {
    super.applyUserOffset(sheet._consume(delta, pixels));
  }

  @override
  void goBallistic(double velocity) {
    final draggingSheet = sheet._offset.value > 0;
    super.goBallistic(draggingSheet ? 0 : velocity);
  }
}

class _SheetDrag implements Drag {
  _SheetDrag(this.delegate, this.sheet);
  final Drag delegate;
  final _BrianBottomSheetState sheet;

  @override
  void update(DragUpdateDetails details) => delegate.update(details);

  @override
  void end(DragEndDetails details) {
    delegate.end(details);
    sheet._release(-(details.primaryVelocity ?? 0));
  }

  @override
  void cancel() {
    delegate.cancel();
    sheet._restore();
  }
}
