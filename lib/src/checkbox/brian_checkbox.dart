import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../radius/brian_radius.dart';
import '../spacing/brian_spacing.dart';
import '../theme/brian_theme.dart';

/// 표시 크기이며 터치 영역은 두 크기 모두 최소 44 논리 픽셀입니다.
///
/// {@category Checkbox}
enum BrianCheckboxSize { medium, large }

/// square는 경계가 있는 상자, ghost는 체크 표시만 사용합니다.
///
/// {@category Checkbox}
enum BrianCheckboxShape { square, ghost }

/// 라벨의 강조 정도를 선택합니다.
///
/// {@category Checkbox}
enum BrianCheckboxWeight { regular, bold }

/// 라벨을 포함한 영역 전체로 선택을 변경합니다. [BrianTheme] 아래에서 사용합니다.
///
/// 값은 부모가 관리합니다. [value]가 null이면 부분 선택을 표시하며 누르면
/// true를 요청합니다. true는 false로, false는 true로 전환을 요청합니다.
/// [onChanged]가 null이면 비활성화되어 포커스와 입력을 받지 않습니다.
/// [label]에는 링크나 버튼 등 별도의 상호작용 위젯을 넣지 않습니다.
///
/// {@category Checkbox}
class BrianCheckbox extends StatefulWidget {
  const BrianCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
    this.size = BrianCheckboxSize.medium,
    this.shape = BrianCheckboxShape.square,
    this.weight = BrianCheckboxWeight.regular,
    this.focusNode,
    this.autofocus = false,
  });

  final bool? value;
  final ValueChanged<bool>? onChanged;
  final Widget label;
  final BrianCheckboxSize size;
  final BrianCheckboxShape shape;
  final BrianCheckboxWeight weight;
  final FocusNode? focusNode;
  final bool autofocus;

  @override
  State<BrianCheckbox> createState() => _BrianCheckboxState();
}

class _BrianCheckboxState extends State<BrianCheckbox> {
  bool _pressed = false;
  bool _focusHighlight = false;

  bool get _enabled => widget.onChanged != null;

  void _setPressed(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  void _activate() {
    widget.onChanged?.call(widget.value != true);
  }

  @override
  void didUpdateWidget(BrianCheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_enabled) {
      _pressed = false;
      _focusHighlight = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = BrianTheme.of(context);
    final typography = theme.typography;
    final style = switch ((widget.size, widget.weight)) {
      (BrianCheckboxSize.medium, BrianCheckboxWeight.regular) =>
        typography.t4Regular,
      (BrianCheckboxSize.medium, BrianCheckboxWeight.bold) => typography.t4Bold,
      (BrianCheckboxSize.large, BrianCheckboxWeight.regular) =>
        typography.t5Regular,
      (BrianCheckboxSize.large, BrianCheckboxWeight.bold) => typography.t5Bold,
    };
    return MergeSemantics(
      child: Semantics(
        checked: widget.value == true,
        mixed: widget.value == null,
        enabled: _enabled,
        onTap: _enabled ? _activate : null,
        child: Focus(
          canRequestFocus: false,
          skipTraversal: true,
          onKeyEvent: (_, event) {
            if (!_enabled ||
                (event.logicalKey != LogicalKeyboardKey.space &&
                    event.logicalKey != LogicalKeyboardKey.enter)) {
              return KeyEventResult.ignored;
            }
            if (event is KeyDownEvent) {
              _setPressed(true);
              _activate();
            } else if (event is KeyUpEvent) {
              _setPressed(false);
            }
            return KeyEventResult.handled;
          },
          child: FocusableActionDetector(
            enabled: _enabled,
            focusNode: widget.focusNode,
            autofocus: widget.autofocus,
            mouseCursor: _enabled
                ? SystemMouseCursors.click
                : SystemMouseCursors.basic,
            onShowFocusHighlight: (value) =>
                setState(() => _focusHighlight = value),
            onFocusChange: (value) {
              if (!value) _setPressed(false);
            },
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              excludeFromSemantics: true,
              onTap: _enabled ? _activate : null,
              onTapDown: _enabled ? (_) => _setPressed(true) : null,
              onTapUp: _enabled ? (_) => _setPressed(false) : null,
              onTapCancel: _enabled ? () => _setPressed(false) : null,
              child: Container(
                constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
                padding: const EdgeInsets.symmetric(
                  vertical: BrianSpacing.x2,
                  horizontal: BrianSpacing.x1,
                ),
                decoration: BoxDecoration(
                  color: _pressed
                      ? theme.colors.background.transparentPressed
                      : null,
                  borderRadius: BorderRadius.circular(BrianRadius.r2),
                ),
                foregroundDecoration: _enabled && _focusHighlight
                    ? BoxDecoration(
                        border: Border.all(
                          color: theme.colors.stroke.focusRing,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(BrianRadius.r2),
                      )
                    : null,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BrianCheckmark(
                      value: widget.value,
                      size: widget.size,
                      shape: widget.shape,
                      enabled: _enabled,
                      pressed: _pressed,
                    ),
                    const SizedBox(width: BrianSpacing.x2),
                    Flexible(
                      child: ExcludeFocus(
                        child: IgnorePointer(
                          child: DefaultTextStyle.merge(
                            style: style.copyWith(
                              color: _enabled
                                  ? theme.colors.foreground.neutral
                                  : theme.colors.foreground.disabled,
                            ),
                            child: widget.label,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 선택 상태만 그리는 장식용 표시입니다. 입력과 접근성 노드는 만들지 않습니다.
///
/// 사용자 정의 행에 조합할 때 부모가 행 전체의 터치·키보드·포커스와
/// checked·mixed·enabled 의미 정보를 제공해야 합니다.
/// [value]가 null이면 부분 선택을 표시합니다.
///
/// {@category Checkbox}
class BrianCheckmark extends StatelessWidget {
  const BrianCheckmark({
    super.key,
    required this.value,
    this.size = BrianCheckboxSize.medium,
    this.shape = BrianCheckboxShape.square,
    this.enabled = true,
    this.pressed = false,
  });

  final bool? value;
  final BrianCheckboxSize size;
  final BrianCheckboxShape shape;
  final bool enabled;
  final bool pressed;

  @override
  Widget build(BuildContext context) {
    final colors = BrianTheme.of(context).colors;
    final selected = value != false;
    final square = shape == BrianCheckboxShape.square;
    final fill = !enabled
        ? colors.background.disabled
        : pressed
        ? colors.background.neutralSolidPressed
        : colors.background.neutralSolid;
    final mark = !enabled
        ? colors.foreground.disabled
        : square && selected
        ? colors.foreground.onNeutralSolid
        : selected
        ? colors.foreground.neutral
        : colors.foreground.neutralSubtle;
    return ExcludeSemantics(
      child: SizedBox.square(
        dimension: size == BrianCheckboxSize.medium ? 20 : 24,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: square && selected ? fill : colors.background.transparent,
            border: square && !selected
                ? Border.all(
                    color: enabled
                        ? colors.stroke.neutralContrast
                        : colors.stroke.neutralWeak,
                    width: 1.5,
                  )
                : null,
            borderRadius: BorderRadius.circular(BrianRadius.r1),
          ),
          child: CustomPaint(
            painter: _CheckmarkPainter(
              color: mark,
              mixed: value == null,
              visible: selected || !square,
            ),
          ),
        ),
      ),
    );
  }
}

class _CheckmarkPainter extends CustomPainter {
  const _CheckmarkPainter({
    required this.color,
    required this.mixed,
    required this.visible,
  });
  final Color color;
  final bool mixed;
  final bool visible;

  @override
  void paint(Canvas canvas, Size size) {
    if (!visible) return;
    final path = Path();
    if (mixed) {
      path.moveTo(size.width * .25, size.height * .5);
      path.lineTo(size.width * .75, size.height * .5);
    } else {
      path.moveTo(size.width * .23, size.height * .5);
      path.lineTo(size.width * .43, size.height * .7);
      path.lineTo(size.width * .77, size.height * .3);
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(_CheckmarkPainter oldDelegate) =>
      color != oldDelegate.color ||
      mixed != oldDelegate.mixed ||
      visible != oldDelegate.visible;
}
