import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../button/brian_button.dart';
import '../theme/brian_theme.dart';

/// 채움, 강한 외곽선, 약한 외곽선으로 강조도를 조절합니다.
///
/// {@category Chip}
enum BrianChipVariant { solid, outlineStrong, outlineWeak }

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
    final background = disabled
        ? (solid ? bg.disabled : bg.transparent)
        : solid && selected
        ? (active ? bg.neutralSolidPressed : bg.neutralSolid)
        : solid || selected
        ? (active ? bg.neutralWeakPressed : bg.neutralWeak)
        : (active ? bg.transparentPressed : bg.transparent);
    final foreground = disabled
        ? fg.disabled
        : solid && selected
        ? fg.onNeutralSolid
        : fg.neutral;
    final border = solid
        ? bg.transparent
        : selected && strong
        ? stroke.neutralContrast
        : strong
        ? stroke.neutralSolid
        : stroke.neutralWeak;
    final height = switch (widget.size) {
      BrianChipSize.small => 32.0,
      BrianChipSize.medium => 36.0,
      BrianChipSize.large => 40.0,
    };
    final padding = widget.size == BrianChipSize.small ? 10.0 : 12.0;
    final style = widget.size == BrianChipSize.small
        ? theme.typography.t4Medium
        : theme.typography.t5Medium;
    Widget? leading = widget.leading;
    if (leading != null) {
      leading = SizedBox.square(
        dimension: widget.leadingStyle == BrianChipLeadingStyle.icon ? 16 : 24,
        child: switch (widget.leadingStyle) {
          BrianChipLeadingStyle.icon => leading,
          BrianChipLeadingStyle.avatar => ClipOval(child: leading),
          BrianChipLeadingStyle.image => ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: leading,
          ),
        },
      );
    }
    final body = Padding(
      padding: EdgeInsetsDirectional.fromSTEB(
        leading != null && widget.leadingStyle != BrianChipLeadingStyle.icon
            ? 4
            : padding,
        6,
        widget.onDeleted != null ? 2 : padding,
        6,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leading != null) ...[
            _decoration(leading),
            const SizedBox(width: 6),
          ],
          Flexible(child: widget.child),
          if (widget.trailing != null) ...[
            const SizedBox(width: 6),
            _decoration(widget.trailing!),
          ],
        ],
      ),
    );
    final inputOnly = widget.onPressed == null && widget.onDeleted != null;
    return Container(
      constraints: BoxConstraints(minHeight: height),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: border),
      ),
      foregroundDecoration: _focused
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: stroke.focusRing, width: 2),
            )
          : null,
      child: IconTheme(
        data: IconThemeData(color: foreground, size: 16),
        child: DefaultTextStyle.merge(
          style: style.copyWith(color: foreground),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: inputOnly
                    ? body
                    : Semantics(
                        button: true,
                        enabled: _actionable,
                        selected: widget.selected,
                        onTap: _actionable ? widget.onPressed : null,
                        child: Focus(
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
                                    if (keys.contains(
                                          LogicalKeyboardKey.enter,
                                        ) ||
                                        keys.contains(
                                          LogicalKeyboardKey.space,
                                        )) {
                                      _setPressed(true);
                                    }
                                    widget.onPressed!();
                                  }
                                  return null;
                                },
                              ),
                            },
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              excludeFromSemantics: true,
                              onTap: _actionable ? widget.onPressed : null,
                              onTapDown: _actionable
                                  ? (_) => _setPressed(true)
                                  : null,
                              onTapUp: _actionable
                                  ? (_) => _setPressed(false)
                                  : null,
                              onTapCancel: _actionable
                                  ? () => _setPressed(false)
                                  : null,
                              child: ConstrainedBox(
                                constraints: BoxConstraints(minHeight: height),
                                child: body,
                              ),
                            ),
                          ),
                        ),
                      ),
              ),
              if (widget.onDeleted != null)
                BrianButton.icon(
                  onPressed: widget.enabled ? widget.onDeleted : null,
                  semanticLabel: widget.deleteLabel,
                  variant: BrianButtonVariant.ghost,
                  size: BrianButtonSize.xsmall,
                  icon: CustomPaint(
                    size: const Size.square(16),
                    painter: _DeletePainter(foreground),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
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
