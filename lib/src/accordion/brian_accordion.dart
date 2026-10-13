import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../radius/brian_radius.dart';
import '../spacing/brian_spacing.dart';
import '../theme/brian_theme.dart';

/// 항목을 연속된 구분선 또는 개별 테두리로 배치합니다.
///
/// {@category Accordion}
enum BrianAccordionVariant { inline, separated }

/// 헤더의 세로 여백은 16·20, 표시 아이콘 크기는 20·24 논리 픽셀입니다.
///
/// {@category Accordion}
enum BrianAccordionSize { medium, large }

/// single은 하나만, multiple은 여러 항목을 동시에 펼칠 수 있습니다.
/// 두 모드 모두 열린 항목을 다시 눌러 모두 접을 수 있습니다.
///
/// {@category Accordion}
enum BrianAccordionExpansionMode { single, multiple }

/// 펼침 상태에 따라 표시 UI 전체를 만듭니다. 회전은 자동 적용하지 않습니다.
///
/// IconTheme과 DefaultTextStyle로 크기·상태 색상을 전달합니다.
/// 반환한 위젯은 장식용이며 포커스·탭·접근성 설명은 헤더가 담당합니다.
/// 사용자 정의 애니메이션은 기기의 모션 감소 설정을 직접 반영해야 합니다.
///
/// {@category Accordion}
typedef BrianAccordionIndicatorBuilder = Widget Function(
  BuildContext context,
  bool isExpanded,
);

/// 관련 정보를 접고 펼치는 목록입니다. [BrianTheme] 아래에서 사용합니다.
///
/// [children]에는 서로 다른 value를 가진 항목을 두 개 이상 지정합니다.
/// 기본값은 medium·inline·single이며 모든 항목이 접혀 있습니다.
/// [expandedValues]가 null이면 내부에서 상태를 관리하고, 지정하면 부모가
/// [onExpandedChanged]의 결과를 다시 전달해야 화면 상태가 바뀝니다.
/// 펼침 값은 목록에 있는 value만 포함하며 single에서는 최대 하나입니다.
/// 자동 스크롤이나 펼침 시 포커스 이동은 수행하지 않습니다.
///
/// {@category Accordion}
class BrianAccordion extends StatefulWidget {
  const BrianAccordion({
    super.key,
    required this.children,
    this.variant = BrianAccordionVariant.inline,
    this.size = BrianAccordionSize.medium,
    this.expansionMode = BrianAccordionExpansionMode.single,
    this.initialExpandedValues = const {},
    this.expandedValues,
    this.onExpandedChanged,
  });

  final List<BrianAccordionItem> children;
  final BrianAccordionVariant variant;
  final BrianAccordionSize size;
  final BrianAccordionExpansionMode expansionMode;

  /// 내부 상태의 최초 값입니다. 이후 변경은 반영하지 않습니다.
  final Set<String> initialExpandedValues;
  final Set<String>? expandedValues;

  /// 사용자 조작으로 요청된 변경 불가능한 집합을 전달합니다.
  /// 항목 제거나 모드 변경에 따른 내부 정리에는 호출하지 않습니다.
  final ValueChanged<Set<String>>? onExpandedChanged;

  @override
  State<BrianAccordion> createState() => _BrianAccordionState();
}

class _BrianAccordionState extends State<BrianAccordion> {
  late Set<String> _expanded = Set.of(widget.initialExpandedValues);

  Set<String> get _values => widget.expandedValues ?? _expanded;

  @override
  void didUpdateWidget(BrianAccordion oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.expandedValues != null && widget.expandedValues == null) {
      _expanded = Set.of(oldWidget.expandedValues!);
    }
    final available = widget.children.map((item) => item.value).toSet();
    _expanded = _expanded.intersection(available);
    if (widget.expansionMode == BrianAccordionExpansionMode.single &&
        _expanded.length > 1) {
      _expanded = {
        widget.children
            .firstWhere((item) => _expanded.contains(item.value))
            .value,
      };
    }
  }

  void _toggle(String value) {
    final next = Set<String>.of(_values);
    if (!next.remove(value)) {
      if (widget.expansionMode == BrianAccordionExpansionMode.single) {
        next.clear();
      }
      next.add(value);
    }
    if (widget.expandedValues == null) setState(() => _expanded = next);
    widget.onExpandedChanged?.call(Set.unmodifiable(next));
  }

  @override
  Widget build(BuildContext context) {
    final ids = widget.children.map((item) => item.value).toSet();
    assert(widget.children.length >= 2, '아코디언에는 항목이 두 개 이상 필요합니다.');
    assert(ids.length == widget.children.length, '항목의 value는 중복될 수 없습니다.');
    assert(_values.every(ids.contains), '펼침 값은 목록에 있는 value여야 합니다.');
    assert(
      widget.expansionMode != BrianAccordionExpansionMode.single ||
          _values.length <= 1,
      'single에서는 하나의 항목만 펼칠 수 있습니다.',
    );
    final separated = widget.variant == BrianAccordionVariant.separated;
    final colors = BrianTheme.of(context).colors;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var index = 0; index < widget.children.length; index++) ...[
          if (index > 0)
            if (separated)
              SizedBox(
                height: widget.size == BrianAccordionSize.medium
                    ? BrianSpacing.x3
                    : BrianSpacing.x4,
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: BrianSpacing.x3,
                ),
                child: ColoredBox(
                  color: colors.stroke.neutralSubtle,
                  child: const SizedBox(height: 1),
                ),
              ),
          _AccordionScope(
            key: ValueKey(widget.children[index].value),
            isExpanded: _values.contains(widget.children[index].value),
            size: widget.size,
            onToggle: () => _toggle(widget.children[index].value),
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: separated
                    ? Border.all(color: colors.stroke.neutralWeak)
                    : null,
                borderRadius: BorderRadius.circular(BrianRadius.r3),
              ),
              child: widget.children[index],
            ),
          ),
        ],
      ],
    );
  }
}

class _AccordionScope extends InheritedWidget {
  const _AccordionScope({
    super.key,
    required this.isExpanded,
    required this.size,
    required this.onToggle,
    required super.child,
  });
  final bool isExpanded;
  final BrianAccordionSize size;
  final VoidCallback onToggle;

  static _AccordionScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_AccordionScope>();
    if (scope == null) {
      throw FlutterError(
        'BrianAccordionItem은 BrianAccordion.children에 배치해야 합니다.',
      );
    }
    return scope;
  }

  @override
  bool updateShouldNotify(_AccordionScope oldWidget) =>
      isExpanded != oldWidget.isExpanded ||
      size != oldWidget.size ||
      onToggle != oldWidget.onToggle;
}

/// [BrianAccordion.children]에 배치하는 항목입니다.
///
/// 헤더 전체를 탭하거나 Tab으로 이동 후 Enter·Space로 펼침을 전환합니다.
/// 제목·설명·prefix에는 별도 버튼이나 입력 필드를 배치하지 않습니다.
/// 본문 안에는 상호작용 위젯을 배치할 수 있습니다.
///
/// {@category Accordion}
class BrianAccordionItem extends StatefulWidget {
  const BrianAccordionItem({
    super.key,
    required this.value,
    required this.title,
    required this.child,
    this.description,
    this.prefix,
    this.prefixSpacing = BrianSpacing.x3,
    this.enabled = true,
    this.indicatorBuilder,
    this.maintainState = false,
    this.focusNode,
    this.autofocus = false,
  }) : assert(prefixSpacing >= 0);

  /// 순서가 바뀌어도 같은 항목에 유지하는 고유 식별자입니다.
  final String value;
  final Widget title;
  final Widget child;
  final Widget? description;
  final Widget? prefix;
  final double prefixSpacing;

  /// false이면 사용자 입력을 막습니다. 외부 상태에 따른 펼침은 가능합니다.
  final bool enabled;

  /// 생략하면 내부 chevron이 아래에서 위로 180도 회전합니다.
  /// 지정하면 builder의 결과로 표시 전체를 대체합니다.
  final BrianAccordionIndicatorBuilder? indicatorBuilder;

  /// true이면 접혀도 본문 상태를 유지합니다. 접힌 본문은 포커스·탭·
  /// 접근성 탐색에서 제외하고 내부 ticker를 중지합니다.
  /// false이면 접힘 애니메이션이 끝난 뒤 본문을 제거합니다.
  final bool maintainState;
  final FocusNode? focusNode;
  final bool autofocus;

  @override
  State<BrianAccordionItem> createState() => _BrianAccordionItemState();
}

class _BrianAccordionItemState extends State<BrianAccordionItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animation = AnimationController(vsync: this);
  late final Animation<double> _progress = _animation.drive(
    CurveTween(curve: Curves.ease),
  );
  bool? _expanded;
  bool _pressed = false;
  bool _focused = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final expanded = _AccordionScope.of(context).isExpanded;
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    _animation.duration = reduceMotion
        ? Duration.zero
        : const Duration(milliseconds: 300);
    if (_expanded == null || reduceMotion) {
      _animation.value = expanded ? 1 : 0;
    } else if (_expanded != expanded) {
      expanded ? _animation.forward() : _animation.reverse();
    }
    _expanded = expanded;
  }

  @override
  void didUpdateWidget(BrianAccordionItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.enabled) _pressed = false;
  }

  @override
  void dispose() {
    _animation.dispose();
    super.dispose();
  }

  void _setPressed(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final scope = _AccordionScope.of(context);
    final theme = BrianTheme.of(context);
    final colors = theme.colors;
    final large = scope.size == BrianAccordionSize.large;
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final foreground = widget.enabled
        ? colors.foreground.neutral
        : colors.foreground.disabled;
    final subtle = widget.enabled
        ? colors.foreground.neutralSubtle
        : colors.foreground.disabled;
    final iconSize = large ? BrianSpacing.x6 : BrianSpacing.x5;
    void activate() {
      if (widget.enabled) scope.onToggle();
    }

    final header = MergeSemantics(
      child: Semantics(
        button: true,
        enabled: widget.enabled,
        expanded: scope.isExpanded,
        onTap: widget.enabled ? activate : null,
        child: Focus(
          canRequestFocus: false,
          skipTraversal: true,
          onKeyEvent: (_, event) {
            final activation =
                event.logicalKey == LogicalKeyboardKey.enter ||
                event.logicalKey == LogicalKeyboardKey.space;
            if (activation && event is KeyUpEvent) _setPressed(false);
            if (activation && event is KeyRepeatEvent) {
              return KeyEventResult.handled;
            }
            return KeyEventResult.ignored;
          },
          child: FocusableActionDetector(
            enabled: widget.enabled,
            focusNode: widget.focusNode,
            autofocus: widget.autofocus,
            mouseCursor: widget.enabled
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
                  _setPressed(widget.enabled);
                  activate();
                  return null;
                },
              ),
            },
            onShowFocusHighlight: (value) => setState(() => _focused = value),
            onFocusChange: (value) {
              if (!value) _setPressed(false);
            },
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              excludeFromSemantics: true,
              onTap: widget.enabled ? activate : null,
              onTapDown: widget.enabled ? (_) => _setPressed(true) : null,
              onTapUp: widget.enabled ? (_) => _setPressed(false) : null,
              onTapCancel: () => _setPressed(false),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: BrianSpacing.x1Point5,
                ),
                child: AnimatedContainer(
                  duration: reduceMotion
                      ? Duration.zero
                      : const Duration(milliseconds: 150),
                  decoration: BoxDecoration(
                    color: _pressed && widget.enabled
                        ? colors.background.transparentPressed
                        : const Color(0x00000000),
                    borderRadius: BorderRadius.circular(BrianRadius.r2Point5),
                  ),
                  foregroundDecoration: _focused && widget.enabled
                      ? BoxDecoration(
                          border: Border.all(
                            color: colors.stroke.focusRing,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(
                            BrianRadius.r2Point5,
                          ),
                        )
                      : null,
                  padding: EdgeInsets.symmetric(
                    horizontal: BrianSpacing.x2Point5,
                    vertical: large ? BrianSpacing.x5 : BrianSpacing.x4,
                  ),
                  child: AnimatedScale(
                    scale: _pressed && widget.enabled && !reduceMotion
                        ? 0.98
                        : 1,
                    duration: reduceMotion
                        ? Duration.zero
                        : const Duration(milliseconds: 150),
                    child: Row(
                      children: [
                        if (widget.prefix != null) ...[
                          IconTheme(
                            data: IconThemeData(color: foreground, size: 22),
                            child: widget.prefix!,
                          ),
                          SizedBox(width: widget.prefixSpacing),
                        ],
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              DefaultTextStyle.merge(
                                style:
                                    (large
                                            ? theme.typography.t7Medium
                                            : theme.typography.t5Medium)
                                        .copyWith(color: foreground),
                                child: widget.title,
                              ),
                              if (widget.description != null) ...[
                                const SizedBox(height: BrianSpacing.x0Point5),
                                DefaultTextStyle.merge(
                                  style:
                                      (large
                                              ? theme.typography.t5Regular
                                              : theme.typography.t3Regular)
                                          .copyWith(color: subtle),
                                  child: widget.description!,
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(width: BrianSpacing.x3),
                        ExcludeSemantics(
                          child: ExcludeFocus(
                            child: IgnorePointer(
                              child: IconTheme(
                                data: IconThemeData(
                                  color: subtle,
                                  size: iconSize,
                                ),
                                child: DefaultTextStyle.merge(
                                  style: theme.typography.t5Regular.copyWith(
                                    color: subtle,
                                  ),
                                  child: Builder(
                                    builder: (context) =>
                                        widget.indicatorBuilder?.call(
                                          context,
                                          scope.isExpanded,
                                        ) ??
                                        AnimatedBuilder(
                                          animation: _progress,
                                          builder: (context, _) =>
                                              Transform.rotate(
                                                angle:
                                                    _progress.value * math.pi,
                                                child: CustomPaint(
                                                  size: Size.square(iconSize),
                                                  painter: _ChevronPainter(
                                                    subtle,
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
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        header,
        AnimatedBuilder(
          animation: _animation,
          builder: (context, _) {
            final hidden = _animation.isDismissed && !scope.isExpanded;
            if (hidden && !widget.maintainState) return const SizedBox.shrink();
            return Offstage(
              offstage: hidden,
              child: TickerMode(
                enabled: scope.isExpanded,
                child: ExcludeFocus(
                  excluding: !scope.isExpanded,
                  child: ExcludeSemantics(
                    excluding: !scope.isExpanded,
                    child: IgnorePointer(
                      ignoring: !scope.isExpanded,
                      child: ClipRect(
                        child: Align(
                          alignment: AlignmentDirectional.topStart,
                          heightFactor: _progress.value,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                              BrianSpacing.x4,
                              0,
                              BrianSpacing.x4,
                              BrianSpacing.x4,
                            ),
                            child: DefaultTextStyle.merge(
                              style: theme.typography.t4Regular.copyWith(
                                color: colors.foreground.neutral,
                              ),
                              child: widget.child,
                            ),
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
      ],
    );
  }
}

class _ChevronPainter extends CustomPainter {
  const _ChevronPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(size.width * 0.25, size.height * 0.375)
      ..lineTo(size.width * 0.5, size.height * 0.625)
      ..lineTo(size.width * 0.75, size.height * 0.375);
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
  bool shouldRepaint(_ChevronPainter oldDelegate) => color != oldDelegate.color;
}
