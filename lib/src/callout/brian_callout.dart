import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../button/brian_button.dart';
import '../radius/brian_radius.dart';
import '../spacing/brian_spacing.dart';
import '../theme/brian_theme.dart';

/// 메시지의 의미에 맞는 전경과 약한 배경을 함께 선택합니다.
///
/// {@category Callout}
enum BrianCalloutTone { neutral, informative, critical, positive, warning }

/// 화면 흐름 안에서 안내와 상태를 강조합니다. [BrianTheme] 아래에서 사용합니다.
///
/// [onPressed]는 전체 영역을 버튼으로 만들며 [onDismiss]·[action]과 함께
/// 사용할 수 없습니다. 닫기 요청 후 실제 제거와 재표시 여부는 부모가 관리합니다.
/// 제목과 본문에는 상호작용 위젯을 넣지 않습니다. 보조 동작은 [action]에 둡니다.
///
/// {@category Callout}
class BrianCallout extends StatefulWidget {
  const BrianCallout({
    super.key,
    required this.description,
    this.title,
    this.tone = BrianCalloutTone.neutral,
    this.icon,
    this.showIcon = true,
    this.action,
    this.onPressed,
    this.onDismiss,
    this.dismissLabel = '안내 닫기',
    this.liveRegion = false,
    this.focusNode,
    this.autofocus = false,
  }) : assert(onPressed == null || (onDismiss == null && action == null)),
       assert(dismissLabel.length > 0);

  final Widget description;
  final Widget? title;
  final BrianCalloutTone tone;

  /// 생략하면 원형 느낌표를 그립니다. IconTheme으로 20 논리 픽셀과 톤 색상을
  /// 전달합니다. 장식용이므로 포커스·포인터·접근성 탐색에서 제외합니다.
  final Widget? icon;

  /// false이면 사용자 정의 아이콘도 숨깁니다.
  final bool showIcon;

  /// 본문 아래에 배치하는 보조 링크나 버튼입니다.
  final Widget? action;
  final VoidCallback? onPressed;
  final VoidCallback? onDismiss;
  final String dismissLabel;

  /// 동적으로 바뀌는 중요한 메시지를 알릴 때만 true로 지정합니다.
  final bool liveRegion;

  /// 전체 영역을 누르는 모드에서만 사용합니다.
  final FocusNode? focusNode;
  final bool autofocus;

  @override
  State<BrianCallout> createState() => _BrianCalloutState();
}

class _BrianCalloutState extends State<BrianCallout> {
  bool _pressed = false;
  bool _focused = false;

  void _setPressed(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  void didUpdateWidget(BrianCallout oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.onPressed == null) _pressed = false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = BrianTheme.of(context);
    final fg = theme.colors.foreground;
    final bg = theme.colors.background;
    final (foreground, background, pressedBackground) = switch (widget.tone) {
      BrianCalloutTone.neutral => (
        fg.neutral,
        bg.neutralWeak,
        bg.neutralWeakPressed,
      ),
      BrianCalloutTone.informative => (
        fg.informativeContrast,
        bg.informativeWeak,
        bg.informativeWeakPressed,
      ),
      BrianCalloutTone.critical => (
        fg.criticalContrast,
        bg.criticalWeak,
        bg.criticalWeakPressed,
      ),
      BrianCalloutTone.positive => (
        fg.positiveContrast,
        bg.positiveWeak,
        bg.positiveWeakPressed,
      ),
      BrianCalloutTone.warning => (
        fg.warningContrast,
        bg.warningWeak,
        bg.warningWeakPressed,
      ),
    };
    final actionable = widget.onPressed != null;
    final content = Container(
      decoration: BoxDecoration(
        color: actionable && _pressed ? pressedBackground : background,
        borderRadius: BorderRadius.circular(BrianRadius.r3),
      ),
      foregroundDecoration: actionable && _focused
          ? BoxDecoration(
              border: Border.all(
                color: theme.colors.stroke.focusRing,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(BrianRadius.r3),
            )
          : null,
      padding: const EdgeInsets.all(BrianSpacing.x4),
      child: IconTheme(
        data: IconThemeData(color: foreground, size: 20),
        child: DefaultTextStyle(
          style: DefaultTextStyle.of(context).style
              .merge(theme.typography.t5Regular.copyWith(color: foreground)),
          // 추가 행간을 위아래에 균등하게 나눠 아이콘과 본문의 시각 중심을 맞춥니다.
          textHeightBehavior: const TextHeightBehavior(
            leadingDistribution: TextLeadingDistribution.even,
          ),
          child: Row(
            children: [
              if (widget.showIcon) ...[
                ExcludeSemantics(
                  child: ExcludeFocus(
                    child: IgnorePointer(
                      child:
                          widget.icon ??
                          CustomPaint(
                            size: const Size.square(20),
                            painter: _CalloutIconPainter(foreground),
                          ),
                    ),
                  ),
                ),
                const SizedBox(width: BrianSpacing.x3),
              ],
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.title != null) ...[
                      DefaultTextStyle.merge(
                        style: theme.typography.t5Bold.copyWith(
                          color: foreground,
                        ),
                        child: widget.title!,
                      ),
                      const SizedBox(height: BrianSpacing.x1),
                    ],
                    widget.description,
                    if (widget.action != null) ...[
                      const SizedBox(height: BrianSpacing.x2),
                      widget.action!,
                    ],
                  ],
                ),
              ),
              if (actionable || widget.onDismiss != null) ...[
                const SizedBox(width: BrianSpacing.x2),
                if (actionable)
                  ExcludeSemantics(
                    child: CustomPaint(
                      size: const Size.square(20),
                      painter: _CalloutTrailingPainter(
                        foreground,
                        close: false,
                        rtl: Directionality.of(context) == TextDirection.rtl,
                      ),
                    ),
                  )
                else
                  BrianButton.icon(
                    onPressed: widget.onDismiss,
                    semanticLabel: widget.dismissLabel,
                    variant: BrianButtonVariant.ghost,
                    size: BrianButtonSize.large,
                    icon: CustomPaint(
                      size: const Size.square(20),
                      painter: _CalloutTrailingPainter(foreground, close: true),
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
    if (!actionable) {
      return Semantics(
        container: true,
        explicitChildNodes: true,
        liveRegion: widget.liveRegion,
        child: content,
      );
    }
    return MergeSemantics(
      child: Semantics(
        button: true,
        liveRegion: widget.liveRegion,
        onTap: widget.onPressed,
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
            focusNode: widget.focusNode,
            autofocus: widget.autofocus,
            mouseCursor: SystemMouseCursors.click,
            onShowFocusHighlight: (value) => setState(() => _focused = value),
            onFocusChange: (value) {
              if (!value) _setPressed(false);
            },
            shortcuts: const {
              SingleActivator(LogicalKeyboardKey.enter, includeRepeats: false):
                  ActivateIntent(),
              SingleActivator(LogicalKeyboardKey.space, includeRepeats: false):
                  ActivateIntent(),
            },
            actions: {
              ActivateIntent: CallbackAction<ActivateIntent>(
                onInvoke: (_) {
                  _setPressed(true);
                  widget.onPressed!();
                  return null;
                },
              ),
            },
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              excludeFromSemantics: true,
              onTap: widget.onPressed,
              onTapDown: (_) => _setPressed(true),
              onTapUp: (_) => _setPressed(false),
              onTapCancel: () => _setPressed(false),
              child: content,
            ),
          ),
        ),
      ),
    );
  }
}

class _CalloutIconPainter extends CustomPainter {
  const _CalloutIconPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    // 느낌표를 투명하게 뚫어 눌림 상태에서도 현재 배경이 보이게 합니다.
    final path = Path()
      ..fillType = PathFillType.evenOdd
      ..addOval(Offset.zero & size)
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            size.width * .45,
            size.height * .23,
            size.width * .1,
            size.height * .34,
          ),
          Radius.circular(size.width * .05),
        ),
      )
      ..addOval(
        Rect.fromCircle(
          center: Offset(size.width * .5, size.height * .72),
          radius: size.width * .06,
        ),
      );
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_CalloutIconPainter oldDelegate) =>
      color != oldDelegate.color;
}

class _CalloutTrailingPainter extends CustomPainter {
  const _CalloutTrailingPainter(
    this.color, {
    required this.close,
    this.rtl = false,
  });
  final Color color;
  final bool close;
  final bool rtl;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    if (close) {
      path
        ..moveTo(size.width * .3, size.height * .3)
        ..lineTo(size.width * .7, size.height * .7)
        ..moveTo(size.width * .7, size.height * .3)
        ..lineTo(size.width * .3, size.height * .7);
    } else {
      path
        ..moveTo(size.width * (rtl ? .6 : .4), size.height * .25)
        ..lineTo(size.width * (rtl ? .35 : .65), size.height * .5)
        ..lineTo(size.width * (rtl ? .6 : .4), size.height * .75);
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(_CalloutTrailingPainter oldDelegate) =>
      color != oldDelegate.color ||
      close != oldDelegate.close ||
      rtl != oldDelegate.rtl;
}
