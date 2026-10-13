import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../color/brian_colors.dart';
import '../radius/brian_radius.dart';
import '../spacing/brian_spacing.dart';
import '../theme/brian_theme.dart';
import '../typography/brian_typography.dart';

/// 액션의 강조도와 의미에 따라 선택하는 버튼 표현입니다.
///
/// {@category Button}
enum BrianButtonVariant {
  brandSolid,
  neutralSolid,
  neutralWeak,
  brandOutline,
  neutralOutline,
  criticalSolid,
  ghost,
}

/// 최소 높이는 각각 32, 36, 40, 52 논리 픽셀입니다.
/// 글자 크기와 부모 제약에 따라 실제 높이는 늘어날 수 있습니다.
///
/// {@category Button}
enum BrianButtonSize { xsmall, small, medium, large }

/// BrianTheme의 역할 색상과 타이포그래피를 사용하는 액션 버튼입니다.
///
/// [onPressed]가 null이면 비활성화됩니다. [isLoading]이면 기존 크기를
/// 유지하며 진행 표시를 보여주고 실행을 막습니다. 로딩 시에도 라벨은
/// 접근성 트리에 남습니다. [loadingLabel]로 진행 상태 설명을 지정합니다.
/// 너비는 콘텐츠에 맞추며 부모의 tight 제약으로 전체 너비를 채울 수 있습니다.
/// 기본 표현은 [BrianButtonVariant.neutralSolid]입니다. 브랜드를 강조하는
/// 액션에는 [BrianButtonVariant.brandSolid]를 명시합니다.
///
/// {@category Button}
class BrianButton extends StatefulWidget {
  const BrianButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.variant = BrianButtonVariant.neutralSolid,
    this.size = BrianButtonSize.medium,
    this.leading,
    this.trailing,
    this.isLoading = false,
    this.semanticLabel,
    this.loadingLabel = '처리 중',
    this.focusNode,
    this.autofocus = false,
  }) : assert(leading == null || trailing == null),
       _iconOnly = false;

  /// 아이콘의 동작을 설명하는 비어 있지 않은 [semanticLabel]이 필요합니다.
  const BrianButton.icon({
    super.key,
    required this.onPressed,
    required Widget icon,
    required String semanticLabel,
    this.variant = BrianButtonVariant.neutralSolid,
    this.size = BrianButtonSize.medium,
    this.isLoading = false,
    this.loadingLabel = '처리 중',
    this.focusNode,
    this.autofocus = false,
  }) : assert(semanticLabel.length > 0),
       child = icon,
       semanticLabel = semanticLabel,
       leading = null,
       trailing = null,
       _iconOnly = true;

  final VoidCallback? onPressed;
  final Widget child;
  final BrianButtonVariant variant;
  final BrianButtonSize size;

  /// 라벨 앞뒤 아이콘은 동시에 지정할 수 없습니다.
  final Widget? leading;
  final Widget? trailing;
  final bool isLoading;

  /// 지정하면 자식의 접근성 설명을 대체합니다.
  final String? semanticLabel;
  final String loadingLabel;
  final FocusNode? focusNode;
  final bool autofocus;
  final bool _iconOnly;

  @override
  State<BrianButton> createState() => _BrianButtonState();
}

class _BrianButtonState extends State<BrianButton> {
  bool _pressed = false;
  bool _focused = false;
  bool _hovered = false;

  bool get _enabled => widget.onPressed != null && !widget.isLoading;

  void _activate() {
    if (_enabled) widget.onPressed!();
  }

  void _setPressed(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  void didUpdateWidget(BrianButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_enabled) _pressed = false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = BrianTheme.of(context);
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final metrics = _ButtonMetrics(widget.size, theme.typography);
    final colors = _ButtonColors.resolve(
      theme.colors,
      widget.variant,
      disabled: widget.onPressed == null && !widget.isLoading,
      active: _enabled && (_pressed || _hovered),
      loading: widget.isLoading,
    );
    final content = widget._iconOnly
        ? widget.child
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.leading != null) ...[
                widget.leading!,
                SizedBox(width: metrics.gap),
              ],
              Flexible(child: widget.child),
              if (widget.trailing != null) ...[
                SizedBox(width: metrics.gap),
                widget.trailing!,
              ],
            ],
          );
    return Semantics(
      button: true,
      enabled: _enabled,
      label: widget.semanticLabel,
      value: widget.isLoading ? widget.loadingLabel : null,
      liveRegion: widget.isLoading,
      onTap: _enabled ? _activate : null,
      child: Focus(
        canRequestFocus: false,
        skipTraversal: true,
        onKeyEvent: (_, event) {
          if (event is KeyUpEvent &&
              (event.logicalKey == LogicalKeyboardKey.enter ||
                  event.logicalKey == LogicalKeyboardKey.space)) {
            _setPressed(false);
          }
          // 반복 입력이 상위 앱의 기본 shortcut으로 전파되지 않게 합니다.
          if (event is KeyRepeatEvent &&
              (event.logicalKey == LogicalKeyboardKey.enter ||
                  event.logicalKey == LogicalKeyboardKey.space)) {
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        child: FocusableActionDetector(
          enabled: _enabled,
          focusNode: widget.focusNode,
          autofocus: widget.autofocus,
          mouseCursor: _enabled
              ? SystemMouseCursors.click
              : SystemMouseCursors.basic,
          shortcuts: const {
            SingleActivator(LogicalKeyboardKey.enter, includeRepeats: false):
                ActivateIntent(),
            SingleActivator(LogicalKeyboardKey.space, includeRepeats: false):
                ActivateIntent(),
          },
          actions: {
            ActivateIntent: CallbackAction<ActivateIntent>(
              onInvoke: (_) {
                final keys = HardwareKeyboard.instance.logicalKeysPressed;
                if (_enabled &&
                    (keys.contains(LogicalKeyboardKey.enter) ||
                        keys.contains(LogicalKeyboardKey.space))) {
                  _setPressed(true);
                }
                _activate();
                return null;
              },
            ),
          },
          onShowFocusHighlight: (value) => setState(() => _focused = value),
          onShowHoverHighlight: (value) => setState(() => _hovered = value),
          onFocusChange: (value) {
            if (!value) _setPressed(false);
          },
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            excludeFromSemantics: true,
            onTap: _enabled ? _activate : null,
            onTapDown: _enabled ? (_) => _setPressed(true) : null,
            onTapUp: _enabled ? (_) => _setPressed(false) : null,
            onTapCancel: () => _setPressed(false),
            child: AnimatedScale(
              scale: !reduceMotion && _enabled && _pressed ? 0.97 : 1,
              duration: reduceMotion
                  ? Duration.zero
                  : const Duration(milliseconds: 100),
              curve: Curves.easeOutCubic,
              child: TweenAnimationBuilder<_ButtonColors>(
                tween: _ButtonColorsTween(end: colors),
                duration: reduceMotion
                    ? Duration.zero
                    : const Duration(milliseconds: 150),
                curve: Curves.easeOutCubic,
                builder: (context, colors, _) {
                  final border = BorderSide(color: colors.border, width: 1);
                  final OutlinedBorder shape =
                      widget.size == BrianButtonSize.xsmall
                      ? StadiumBorder(side: border)
                      : RoundedRectangleBorder(
                          side: border,
                          borderRadius: BorderRadius.circular(
                            widget.size == BrianButtonSize.large
                                ? BrianRadius.r3
                                : BrianRadius.r2,
                          ),
                        );
                  return Container(
                    constraints: BoxConstraints(
                      minHeight: metrics.height,
                      minWidth: metrics.height,
                    ),
                    decoration: ShapeDecoration(
                      color: colors.background,
                      shape: shape,
                    ),
                    foregroundDecoration: _focused && _enabled
                        ? ShapeDecoration(
                            shape: shape.copyWith(
                              side: BorderSide(
                                color: theme.colors.stroke.focusRing,
                                width: 2,
                                // 2픽셀 간격을 두고 바깥쪽 2~4픽셀에 그립니다.
                                strokeAlign: 3,
                              ),
                            ),
                          )
                        : null,
                    padding: EdgeInsets.symmetric(
                      horizontal: widget._iconOnly
                          ? metrics.paddingY
                          : metrics.paddingX,
                      vertical: metrics.paddingY,
                    ),
                    child: DefaultTextStyle(
                      style: DefaultTextStyle.of(context).style.merge(
                        metrics.textStyle.copyWith(color: colors.foreground),
                      ),
                      textAlign: TextAlign.center,
                      child: IconTheme(
                        data: IconThemeData(
                          color: colors.foreground,
                          size:
                              widget._iconOnly &&
                                  widget.size == BrianButtonSize.small
                              ? BrianSpacing.x4
                              : metrics.iconSize,
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            ExcludeSemantics(
                              excluding: widget.semanticLabel != null,
                              child: Opacity(
                                opacity: widget.isLoading ? 0 : 1,
                                alwaysIncludeSemantics: true,
                                child: content,
                              ),
                            ),
                            if (widget.isLoading)
                              Positioned.fill(
                                child: Center(
                                  child: _ButtonProgress(
                                    color: colors.foreground,
                                    size: metrics.progressSize,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ButtonMetrics {
  _ButtonMetrics(this.size, this.typography);
  final BrianButtonSize size;
  final BrianTypography typography;

  double get height => switch (size) {
    BrianButtonSize.xsmall => BrianSpacing.x8,
    BrianButtonSize.small => BrianSpacing.x9,
    BrianButtonSize.medium => BrianSpacing.x10,
    BrianButtonSize.large => BrianSpacing.x13,
  };
  double get paddingX => switch (size) {
    BrianButtonSize.xsmall || BrianButtonSize.small => BrianSpacing.x3Point5,
    BrianButtonSize.medium => BrianSpacing.x4,
    BrianButtonSize.large => BrianSpacing.x5,
  };
  double get paddingY => switch (size) {
    BrianButtonSize.xsmall => BrianSpacing.x1Point5,
    BrianButtonSize.small => BrianSpacing.x2,
    BrianButtonSize.medium => BrianSpacing.x2Point5,
    BrianButtonSize.large => BrianSpacing.x3Point5,
  };
  double get gap => switch (size) {
    BrianButtonSize.xsmall || BrianButtonSize.small => BrianSpacing.x1,
    BrianButtonSize.medium => BrianSpacing.x1Point5,
    BrianButtonSize.large => BrianSpacing.x2,
  };
  double get iconSize => switch (size) {
    BrianButtonSize.xsmall || BrianButtonSize.small => BrianSpacing.x3Point5,
    BrianButtonSize.medium => BrianSpacing.x4,
    BrianButtonSize.large => 22,
  };
  double get progressSize => switch (size) {
    BrianButtonSize.xsmall || BrianButtonSize.small => 14,
    BrianButtonSize.medium => 16,
    BrianButtonSize.large => 18,
  };
  TextStyle get textStyle => switch (size) {
    BrianButtonSize.xsmall => typography.t3Bold,
    BrianButtonSize.small || BrianButtonSize.medium => typography.t4Bold,
    BrianButtonSize.large => typography.t6Bold,
  };
}

class _ButtonColors {
  const _ButtonColors(this.background, this.foreground, this.border);
  final Color background;
  final Color foreground;
  final Color border;

  static _ButtonColors resolve(
    BrianColors colors,
    BrianButtonVariant variant, {
    required bool disabled,
    required bool active,
    required bool loading,
  }) {
    final bg = colors.background;
    final fg = colors.foreground;
    final outline =
        variant == BrianButtonVariant.brandOutline ||
        variant == BrianButtonVariant.neutralOutline;
    final transparent = outline || variant == BrianButtonVariant.ghost;
    final border = outline ? colors.stroke.neutralMuted : bg.transparent;
    if (disabled) {
      return _ButtonColors(
        transparent ? bg.transparent : bg.disabled,
        fg.disabled,
        border,
      );
    }
    final pressed = active || (loading && !outline);
    final (background, foreground) = switch (variant) {
      BrianButtonVariant.brandSolid => (
        pressed ? bg.brandSolidPressed : bg.brandSolid,
        fg.onBrandSolid,
      ),
      BrianButtonVariant.neutralSolid => (
        pressed ? bg.neutralSolidPressed : bg.neutralSolid,
        fg.onNeutralSolid,
      ),
      BrianButtonVariant.neutralWeak => (
        pressed ? bg.neutralWeakPressed : bg.neutralWeak,
        fg.neutral,
      ),
      BrianButtonVariant.criticalSolid => (
        pressed ? bg.criticalSolidPressed : bg.criticalSolid,
        fg.onCriticalSolid,
      ),
      BrianButtonVariant.brandOutline => (
        pressed ? bg.transparentPressed : bg.transparent,
        fg.brand,
      ),
      BrianButtonVariant.neutralOutline || BrianButtonVariant.ghost => (
        pressed ? bg.transparentPressed : bg.transparent,
        fg.neutral,
      ),
    };
    return _ButtonColors(background, foreground, border);
  }
}

class _ButtonColorsTween extends Tween<_ButtonColors> {
  _ButtonColorsTween({required _ButtonColors end})
    : super(begin: end, end: end);

  @override
  _ButtonColors lerp(double t) => _ButtonColors(
    Color.lerp(begin!.background, end!.background, t)!,
    Color.lerp(begin!.foreground, end!.foreground, t)!,
    Color.lerp(begin!.border, end!.border, t)!,
  );
}

class _ButtonProgress extends StatefulWidget {
  const _ButtonProgress({required this.color, required this.size});
  final Color color;
  final double size;

  @override
  State<_ButtonProgress> createState() => _ButtonProgressState();
}

class _ButtonProgressState extends State<_ButtonProgress>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.stop();
    } else {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: RotationTransition(
      turns: _controller,
      child: CustomPaint(
        size: Size.square(widget.size),
        painter: _ProgressPainter(widget.color),
      ),
    ),
  );
}

class _ProgressPainter extends CustomPainter {
  const _ProgressPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..color = color;
    canvas.drawArc(
      (Offset.zero & size).deflate(1),
      -math.pi / 2,
      math.pi * 1.5,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_ProgressPainter oldDelegate) =>
      color != oldDelegate.color;
}
