import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../button/brian_button.dart';
import '../layout/control_touch_target.dart';
import '../theme/brian_theme.dart';

/// 채움, 강한 외곽선, 약한 외곽선으로 강조도를 조절합니다.
///
/// {@category Chip}
enum BrianChipVariant { solid, outlineStrong, outlineWeak }

/// 선택 상태의 역할 색상을 결정합니다. brand는 약한 브랜드 배경과 체크를 사용합니다.
///
/// {@category Chip}
enum BrianChipTone { neutral, brand }

/// 최소 높이는 각각 32, 36, 40 논리 픽셀입니다. 글자 확대 시 늘어납니다.
///
/// {@category Chip}
enum BrianChipSize { small, medium, large }

/// 앞쪽 장식의 크기·클리핑·시작 여백을 결정합니다.
///
/// {@category Chip}
enum BrianChipLeadingStyle { icon, avatar, image }

/// 선택 항목, 추천 동작, 입력값을 간결하게 표시합니다.
///
/// [BrianTheme] 아래에서 사용합니다. [selected]가 null이면 일반 동작이고,
/// bool이면 부모가 선택 상태를 관리합니다. [onPressed]가 null이면 본문
/// 동작은 비활성화됩니다. 삭제 전용 입력값은 [onDeleted]만 지정합니다.
/// [enabled]가 false이면 본문과 삭제 모두 비활성화됩니다.
/// [child], [leading], [trailing]에는 상호작용 위젯을 넣지 않습니다.
/// 삭제는 독립된 버튼이며 실제 목록에서의 제거는 부모가 처리합니다.
///
/// {@category Chip}
class BrianChip extends StatefulWidget {
  const BrianChip({
    super.key,
    required this.child,
    required this.onPressed,
    this.selected,
    this.tone = BrianChipTone.neutral,
    this.variant = BrianChipVariant.outlineWeak,
    this.size = BrianChipSize.medium,
    this.leading,
    this.leadingStyle = BrianChipLeadingStyle.icon,
    this.trailing,
    this.onDeleted,
    this.deleteLabel = '항목 삭제',
    this.enabled = true,
    this.focusNode,
    this.autofocus = false,
  }) : assert(trailing == null || onDeleted == null),
       assert(deleteLabel.length > 0);

  final Widget child;
  final VoidCallback? onPressed;
  final bool? selected;
  final BrianChipTone tone;
  final BrianChipVariant variant;
  final BrianChipSize size;

  /// 장식용으로 취급하며 접근성 트리와 포커스에서 제외합니다.
  final Widget? leading;
  final BrianChipLeadingStyle leadingStyle;

  /// 삭제 버튼과 동시에 지정할 수 없는 장식용 슬롯입니다.
  final Widget? trailing;
  final VoidCallback? onDeleted;

  /// 여러 입력값을 구별할 수 있도록 항목 이름을 포함합니다.
  final String deleteLabel;
  final bool enabled;
  final FocusNode? focusNode;
  final bool autofocus;

  @override
  State<BrianChip> createState() => _BrianChipState();
}

class _BrianChipState extends State<BrianChip> {
  bool _pressed = false;
  bool _hovered = false;
  bool _focused = false;
  bool get _actionable => widget.enabled && widget.onPressed != null;

  void _setPressed(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  void didUpdateWidget(BrianChip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_actionable) {
      _pressed = false;
      _hovered = false;
      _focused = false;
    }
  }

  Widget _decoration(Widget child) => ExcludeSemantics(
    child: ExcludeFocus(child: IgnorePointer(child: child)),
  );

  @override
  Widget build(BuildContext context) {
    final theme = BrianTheme.of(context);
    final control = switch (widget.size) {
      BrianChipSize.small => theme.chips.small,
      BrianChipSize.medium => theme.chips.medium,
      BrianChipSize.large => theme.chips.large,
    };
    final bg = theme.colors.background;
    final fg = theme.colors.foreground;
    final stroke = theme.colors.stroke;
    final selected = widget.selected == true;
    final disabled =
        !widget.enabled ||
        (widget.onPressed == null && widget.onDeleted == null);
    final active = _actionable && (_pressed || _hovered);
    final solid = widget.variant == BrianChipVariant.solid;
    final strong = widget.variant == BrianChipVariant.outlineStrong;
    final brandSelected = widget.tone == BrianChipTone.brand && selected;
    final background = disabled
        ? (solid ? bg.disabled : bg.transparent)
        : brandSelected
        ? (active ? bg.brandWeakPressed : bg.brandWeak)
        : solid && selected
        ? (active ? bg.neutralSolidPressed : bg.neutralSolid)
        : solid || selected
        ? (active ? bg.neutralWeakPressed : bg.neutralWeak)
        : (active ? bg.transparentPressed : bg.transparent);
    final foreground = disabled
        ? fg.disabled
        : brandSelected
        ? fg.brandContrast
        : solid && selected
        ? fg.onNeutralSolid
        : fg.neutral;
    final border = brandSelected && !disabled
        ? stroke.brandSolid
        : solid
        ? bg.transparent
        : selected && strong
        ? stroke.neutralContrast
        : strong
        ? stroke.neutralSolid
        : stroke.neutralWeak;
    final height =
        control.minimumSize?.height ??
        switch (widget.size) {
          BrianChipSize.small => theme.spacing.x8,
          BrianChipSize.medium => theme.spacing.x9,
          BrianChipSize.large => theme.spacing.x10,
        };
    final padding = widget.size == BrianChipSize.small
        ? theme.spacing.x2Point5
        : theme.spacing.x3;
    final style = widget.size == BrianChipSize.small
        ? theme.typography.t4Medium
        : theme.typography.t5Medium;
    Widget? leading = widget.leading;
    if (leading != null) {
      leading = SizedBox.square(
        dimension: widget.leadingStyle == BrianChipLeadingStyle.icon
            ? (control.iconSize ?? 16)
            : 24,
        child: switch (widget.leadingStyle) {
          BrianChipLeadingStyle.icon => leading,
          BrianChipLeadingStyle.avatar => ClipOval(child: leading),
          BrianChipLeadingStyle.image => ClipRRect(
            borderRadius: BorderRadius.circular(theme.radius.r1),
            child: leading,
          ),
        },
      );
    }
    final body = Padding(
      padding:
          control.padding ??
          EdgeInsetsDirectional.fromSTEB(
            leading != null && widget.leadingStyle != BrianChipLeadingStyle.icon
                ? theme.spacing.x1
                : padding,
            theme.spacing.x1Point5,
            widget.onDeleted != null ? theme.spacing.x0Point5 : padding,
            theme.spacing.x1Point5,
          ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leading != null) ...[
            _decoration(leading),
            SizedBox(width: control.gap ?? theme.spacing.x1Point5),
          ],
          if (brandSelected) ...[
            _decoration(
              CustomPaint(
                size: const Size.square(16),
                painter: _CheckPainter(foreground),
              ),
            ),
            SizedBox(width: control.gap ?? theme.spacing.x1Point5),
          ],
          Flexible(child: widget.child),
          if (widget.trailing != null) ...[
            SizedBox(width: control.gap ?? theme.spacing.x1Point5),
            _decoration(widget.trailing!),
          ],
        ],
      ),
    );
    final inputOnly = widget.onPressed == null && widget.onDeleted != null;
    final surface = Container(
      constraints: BoxConstraints(
        minHeight: height,
        minWidth: control.minimumSize?.width ?? 0,
      ),
      decoration: control.shape != null
          ? ShapeDecoration(
              color: background,
              shape: control.shape!.copyWith(side: BorderSide(color: border)),
            )
          : BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: border),
            ),
      foregroundDecoration: _focused
          ? (control.shape != null
                ? ShapeDecoration(
                    shape: control.shape!.copyWith(
                      side: BorderSide(color: stroke.focusRing, width: 2),
                    ),
                  )
                : BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: stroke.focusRing, width: 2),
                  ))
          : null,
      child: IconTheme(
        data: IconThemeData(color: foreground, size: control.iconSize ?? 16),
        child: DefaultTextStyle.merge(
          style: style.copyWith(color: foreground),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: inputOnly
                    ? body
                    : Focus(
                        canRequestFocus: false,
                        skipTraversal: true,
                        onKeyEvent: (_, event) {
                          final activation =
                              event.logicalKey == LogicalKeyboardKey.enter ||
                              event.logicalKey == LogicalKeyboardKey.space;
                          if (activation && event is KeyUpEvent) {
                            _setPressed(false);
                          }
                          if (activation && event is KeyRepeatEvent) {
                            return KeyEventResult.handled;
                          }
                          return KeyEventResult.ignored;
                        },
                        child: FocusableActionDetector(
                          enabled: _actionable,
                          focusNode: widget.focusNode,
                          autofocus: widget.autofocus,
                          mouseCursor: _actionable
                              ? SystemMouseCursors.click
                              : SystemMouseCursors.basic,
                          onShowFocusHighlight: (value) =>
                              setState(() => _focused = value),
                          onShowHoverHighlight: (value) =>
                              setState(() => _hovered = value),
                          onFocusChange: (value) {
                            if (!value) _setPressed(false);
                          },
                          shortcuts: const {
                            SingleActivator(
                              LogicalKeyboardKey.enter,
                              includeRepeats: false,
                            ): ActivateIntent(),
                            SingleActivator(
                              LogicalKeyboardKey.space,
                              includeRepeats: false,
                            ): ActivateIntent(),
                          },
                          actions: {
                            ActivateIntent: CallbackAction<ActivateIntent>(
                              onInvoke: (_) {
                                if (_actionable) {
                                  final keys = HardwareKeyboard
                                      .instance
                                      .logicalKeysPressed;
                                  if (keys.contains(LogicalKeyboardKey.enter) ||
                                      keys.contains(LogicalKeyboardKey.space)) {
                                    _setPressed(true);
                                  }
                                  widget.onPressed!();
                                }
                                return null;
                              },
                            ),
                          },
                          child: ConstrainedBox(
                            constraints: BoxConstraints(minHeight: height),
                            child: body,
                          ),
                        ),
                      ),
              ),
              if (widget.onDeleted != null)
                Semantics(
                  container: true,
                  child: BrianButton.icon(
                    onPressed: widget.enabled ? widget.onDeleted : null,
                    semanticLabel: widget.deleteLabel,
                    variant: BrianButtonVariant.ghost,
                    size: BrianButtonSize.xsmall,
                    icon: CustomPaint(
                      size: const Size.square(16),
                      painter: _DeletePainter(foreground),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
    final target = GestureDetector(
      behavior: HitTestBehavior.opaque,
      excludeFromSemantics: true,
      onTap: _actionable ? widget.onPressed : null,
      onTapDown: _actionable ? (_) => _setPressed(true) : null,
      onTapUp: _actionable ? (_) => _setPressed(false) : null,
      onTapCancel: () => _setPressed(false),
      child: ControlTouchTarget(
        minimumSize: control.minimumTouchTarget,
        child: surface,
      ),
    );
    // 삭제 버튼은 독립 노드로 남기고 본문 액션의 접근성 영역도 함께 확장합니다.
    return inputOnly
        ? target
        : Semantics(
            button: true,
            enabled: _actionable,
            selected: widget.selected,
            onTap: _actionable ? widget.onPressed : null,
            child: target,
          );
  }
}

class _CheckPainter extends CustomPainter {
  const _CheckPainter(this.color);
  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
      Path()
        ..moveTo(size.width * .2, size.height * .5)
        ..lineTo(size.width * .42, size.height * .72)
        ..lineTo(size.width * .8, size.height * .28),
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(_CheckPainter oldDelegate) => color != oldDelegate.color;
}

class _DeletePainter extends CustomPainter {
  const _DeletePainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(size.width * .3, size.height * .3),
      Offset(size.width * .7, size.height * .7),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * .7, size.height * .3),
      Offset(size.width * .3, size.height * .7),
      paint,
    );
  }

  @override
  bool shouldRepaint(_DeletePainter oldDelegate) => color != oldDelegate.color;
}
