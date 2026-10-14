import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../button/brian_button.dart';
import '../radius/brian_radius.dart';
import '../scroll_fog/brian_scroll_fog.dart';
import '../spacing/brian_spacing.dart';
import '../theme/brian_theme.dart';

const _navigationDuration = Duration(milliseconds: 220);

Duration _motionDuration(BuildContext context) =>
    MediaQuery.disableAnimationsOf(context)
    ? Duration.zero
    : _navigationDuration;

/// neutral은 중립 표면, transparent는 부모의 배경을 사용합니다.
///
/// {@category SideNavigation}
enum BrianSideNavigationVariant { neutral, transparent }

/// 이동할 페이지 또는 하위 페이지 묶음입니다.
///
/// [children]은 한 단계만 허용하며 모든 항목의 [value]는 탐색 영역 안에서
/// 고유해야 합니다. 자식이 있는 항목은 페이지 이동 없이 펼침만 전환합니다.
/// [icon]과 [trailing]은 장식용으로, 별도 상호작용을 넣지 않습니다.
/// 아이콘은 IconTheme의 색상과 20 논리 픽셀 크기를 상속합니다.
///
/// {@category SideNavigation}
@immutable
class BrianSideNavigationItem {
  const BrianSideNavigationItem({
    required this.value,
    required this.label,
    this.icon,
    this.trailing,
    this.enabled = true,
    this.children = const [],
  }) : assert(value.length > 0),
       assert(label.length > 0);

  final String value;
  final String label;
  final Widget? icon;
  final Widget? trailing;
  final bool enabled;
  final List<BrianSideNavigationItem> children;
}

/// 관련 메뉴를 묶습니다. 라벨은 선택 사항이며 접힌 상태에서는 숨깁니다.
///
/// {@category SideNavigation}
@immutable
class BrianSideNavigationGroup {
  const BrianSideNavigationGroup({required this.items, this.label});

  final String? label;
  final List<BrianSideNavigationItem> items;
}

/// 고정 헤더·푸터 사이에서 메뉴만 스크롤하는 탐색 영역입니다.
///
/// 유한한 높이와 [BrianTheme]을 제공하세요. 너비는 기본 256, 접히면 64
/// 논리 픽셀이며 부모 제약을 따릅니다. 페이지 이동과 [selectedValue]는
/// 호출자가 관리합니다. 초기 선택과 선택 변경 시 해당 자식의 부모를 펼칩니다.
/// 이후에는 선택 상태를 유지하면서 부모를 직접 접을 수 있습니다.
/// [onCollapsedChanged]가 있으면 접기 버튼을 표시하며, 요청된 값을
/// [collapsed]로 다시 전달해야 합니다. 반응형 전환과 모바일 패널은 앱에서
/// 구성합니다. Tab으로 이동하고 Enter·Space로 실행합니다.
/// 너비·그룹 라벨·하위 메뉴·화살표는 220ms로 전환하며 시스템의
/// 모션 감소 설정이 켜져 있으면 애니메이션을 생략합니다.
///
/// 접힌 항목은 호버 시 이름 또는 하위 메뉴를 보여줍니다. 하위 메뉴는
/// 클릭·키보드로도 열 수 있으며 Escape·바깥 클릭·선택 시 닫힙니다.
/// 아이콘을 생략하면 라벨의 첫 글자를 표시합니다.
///
/// {@category SideNavigation}
class BrianSideNavigation extends StatefulWidget {
  const BrianSideNavigation({
    super.key,
    required this.groups,
    required this.onSelected,
    this.selectedValue,
    this.initialExpandedValues = const {},
    this.header,
    this.collapsedHeader,
    this.footer,
    this.collapsedFooter,
    this.collapsed = false,
    this.onCollapsedChanged,
    this.variant = BrianSideNavigationVariant.neutral,
    this.width = 256,
    this.collapsedWidth = 64,
    this.semanticLabel = '주 탐색',
    this.collapseLabel = '메뉴 접기',
    this.expandLabel = '메뉴 펼치기',
    this.fogColor,
  }) : assert(width > 0 && width < double.infinity),
       assert(collapsedWidth >= 48 && collapsedWidth < double.infinity);

  final List<BrianSideNavigationGroup> groups;
  final ValueChanged<String> onSelected;
  final String? selectedValue;

  /// 처음 표시할 때 펼칠 부모 항목의 value입니다. 이후 변경은 반영하지 않습니다.
  final Set<String> initialExpandedValues;
  final Widget? header;
  final Widget? collapsedHeader;
  final Widget? footer;
  final Widget? collapsedFooter;
  final bool collapsed;
  final ValueChanged<bool>? onCollapsedChanged;
  final BrianSideNavigationVariant variant;
  final double width;
  final double collapsedWidth;
  final String semanticLabel;
  final String collapseLabel;
  final String expandLabel;

  /// transparent일 때 부모 표면과 맞출 하단 그라디언트 색상입니다.
  /// 생략하면 background.layerDefault를 사용합니다.
  final Color? fogColor;

  @override
  State<BrianSideNavigation> createState() => _BrianSideNavigationState();
}

class _BrianSideNavigationState extends State<BrianSideNavigation> {
  final _scroll = ScrollController();
  late final _expanded = Set<String>.of(widget.initialExpandedValues);
  _CollapsedItemState? _activePopup;
  bool _scrolled = false;
  bool _more = false;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_updateScroll);
    final parent = _selectedParent(widget);
    if (parent != null) _expanded.add(parent);
  }

  @override
  void didUpdateWidget(BrianSideNavigation oldWidget) {
    super.didUpdateWidget(oldWidget);
    final parent = _selectedParent(widget);
    if (parent != null &&
        (oldWidget.selectedValue != widget.selectedValue ||
            _selectedParent(oldWidget) != parent)) {
      _expanded.add(parent);
    }
    _expanded.retainAll(
      widget.groups.expand((g) => g.items).map((i) => i.value),
    );
  }

  String? _selectedParent(BrianSideNavigation navigation) {
    for (final group in navigation.groups) {
      for (final item in group.items) {
        if (item.children.any(
          (child) => child.value == navigation.selectedValue,
        )) {
          return item.value;
        }
      }
    }
    return null;
  }

  void _updateScroll() {
    if (!_scroll.hasClients) return;
    final scrolled = _scroll.position.extentBefore > 0;
    final more = _scroll.position.extentAfter > 1;
    if (scrolled != _scrolled || more != _more) {
      setState(() {
        _scrolled = scrolled;
        _more = more;
      });
    }
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  bool _validate() {
    final ids = <String>{};
    for (final group in widget.groups) {
      for (final item in group.items) {
        assert(ids.add(item.value), '항목 value는 고유해야 합니다.');
        for (final child in item.children) {
          assert(child.children.isEmpty, '하위 메뉴는 한 단계만 지원합니다.');
          assert(ids.add(child.value), '항목 value는 고유해야 합니다.');
        }
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    assert(_validate());
    final theme = BrianTheme.of(context);
    final neutral = widget.variant == BrianSideNavigationVariant.neutral;
    final surface = neutral
        ? theme.colors.background.neutralMuted
        : const Color(0x00000000);
    final header = widget.collapsed ? widget.collapsedHeader : widget.header;
    final footer = widget.collapsed ? widget.collapsedFooter : widget.footer;
    return LayoutBuilder(
      builder: (context, constraints) {
        final targetWidth = constraints.constrainWidth(
          widget.collapsed ? widget.collapsedWidth : widget.width,
        );
        return Semantics(
          container: true,
          explicitChildNodes: true,
          label: widget.semanticLabel,
          child: AnimatedContainer(
            duration: _motionDuration(context),
            curve: Curves.easeInOutCubic,
            width: targetWidth,
            color: surface,
            // 줄바꿈은 최종 너비에서 계산하고 전환 중에는 바깥 영역만 자릅니다.
            child: ClipRect(
              child: OverflowBox(
                alignment: AlignmentDirectional.topStart,
                minWidth: targetWidth,
                maxWidth: targetWidth,
                child: ColoredBox(
                  color: surface,
                  child: FocusTraversalGroup(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (widget.collapsed && header != null)
                          Padding(
                            padding: const EdgeInsets.all(BrianSpacing.x3),
                            child: header,
                          ),
                        if ((!widget.collapsed && header != null) ||
                            widget.onCollapsedChanged != null)
                          Padding(
                            padding: const EdgeInsets.all(BrianSpacing.x2),
                            child: Row(
                              mainAxisAlignment: widget.collapsed
                                  ? MainAxisAlignment.center
                                  : MainAxisAlignment.end,
                              children: [
                                if (!widget.collapsed && header != null) ...[
                                  Expanded(child: header),
                                  if (widget.onCollapsedChanged != null)
                                    const SizedBox(width: BrianSpacing.x2),
                                ],
                                if (widget.onCollapsedChanged != null)
                                  BrianButton.icon(
                                    onPressed: () => widget.onCollapsedChanged!(
                                      !widget.collapsed,
                                    ),
                                    variant: BrianButtonVariant.ghost,
                                    semanticLabel: widget.collapsed
                                        ? widget.expandLabel
                                        : widget.collapseLabel,
                                    icon: _NavigationGlyph(
                                      collapsed: widget.collapsed,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        SizedBox(
                          height: 1,
                          child: ColoredBox(
                            color: _scrolled
                                ? theme.colors.stroke.neutralWeak
                                : const Color(0x00000000),
                          ),
                        ),
                        Expanded(
                          child:
                              NotificationListener<ScrollMetricsNotification>(
                                onNotification: (_) {
                                  _updateScroll();
                                  return false;
                                },
                                child: Stack(
                                  children: [
                                    ListView(
                                      controller: _scroll,
                                      padding: const EdgeInsets.fromLTRB(
                                        8,
                                        8,
                                        8,
                                        32,
                                      ),
                                      children: [
                                        for (
                                          var index = 0;
                                          index < widget.groups.length;
                                          index++
                                        ) ...[
                                          if (index > 0)
                                            const SizedBox(
                                              height: BrianSpacing.x4,
                                            ),
                                          if (widget.groups[index].label !=
                                              null)
                                            _NavigationReveal(
                                              expanded: !widget.collapsed,
                                              child: Padding(
                                                padding: const EdgeInsets.all(
                                                  BrianSpacing.x2,
                                                ),
                                                child: Semantics(
                                                  header: true,
                                                  child: Text(
                                                    widget.groups[index].label!,
                                                    maxLines: 1,
                                                    softWrap: false,
                                                    overflow: TextOverflow.clip,
                                                    style: theme
                                                        .typography
                                                        .t2Medium
                                                        .copyWith(
                                                          color: theme
                                                              .colors
                                                              .foreground
                                                              .neutralMuted,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          for (final item
                                              in widget.groups[index].items)
                                            _buildItem(item),
                                        ],
                                      ],
                                    ),
                                    if (_more)
                                      Positioned(
                                        left: 0,
                                        right: 0,
                                        bottom: 0,
                                        child: BrianScrollFog(
                                          extent: 32,
                                          color:
                                              widget.fogColor ??
                                              (neutral
                                                  ? surface
                                                  : theme
                                                        .colors
                                                        .background
                                                        .layerDefault),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                        ),
                        if (footer != null)
                          Padding(
                            padding: const EdgeInsets.all(BrianSpacing.x3),
                            child: footer,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _activatePopup(_CollapsedItemState item) {
    final previous = _activePopup;
    if (previous != item && previous != null && previous.mounted) {
      previous._close();
    }
    _activePopup = item;
  }

  Widget _buildItem(BrianSideNavigationItem item) {
    final expanded = _expanded.contains(item.value);
    return Padding(
      key: ValueKey(item.value),
      padding: const EdgeInsets.only(bottom: BrianSpacing.x1),
      child: widget.collapsed
          ? _CollapsedItem(
              onActivate: _activatePopup,
              item: item,
              selectedValue: widget.selectedValue,
              onSelected: widget.onSelected,
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _NavigationRow(
                  item: item,
                  selected:
                      item.value == widget.selectedValue ||
                      (!expanded &&
                          item.children.any(
                            (child) => child.value == widget.selectedValue,
                          )),
                  expanded: item.children.isEmpty ? null : expanded,
                  onPressed: () {
                    if (item.children.isEmpty) {
                      widget.onSelected(item.value);
                    } else {
                      setState(() {
                        if (!_expanded.remove(item.value)) {
                          _expanded.add(item.value);
                        }
                      });
                    }
                  },
                ),
                if (item.children.isNotEmpty)
                  _NavigationReveal(
                    expanded: expanded,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (final child in item.children)
                          Padding(
                            key: ValueKey(child.value),
                            padding: const EdgeInsetsDirectional.only(
                              start: BrianSpacing.x5,
                              top: BrianSpacing.x1,
                            ),
                            child: _NavigationRow(
                              item: child,
                              enabled: item.enabled,
                              selected: child.value == widget.selectedValue,
                              onPressed: () => widget.onSelected(child.value),
                            ),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
    );
  }
}

class _NavigationRow extends StatelessWidget {
  const _NavigationRow({
    super.key,
    required this.item,
    required this.selected,
    required this.onPressed,
    this.expanded,
    this.enabled = true,
    this.iconOnly = false,
    this.focusNode,
    this.autofocus = false,
  });
  final BrianSideNavigationItem item;
  final bool selected;
  final VoidCallback onPressed;
  final bool? expanded;
  final bool enabled;
  final bool iconOnly;
  final FocusNode? focusNode;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final typography = BrianTheme.of(context).typography;
    final variant = selected
        ? BrianButtonVariant.neutralWeak
        : BrianButtonVariant.ghost;
    final activate = enabled && item.enabled ? onPressed : null;
    final icon = IconTheme.merge(
      data: const IconThemeData(size: 20),
      child: Center(
        child:
            item.icon ??
            Text(
              String.fromCharCode(item.label.runes.first),
              style: typography.t4Medium,
            ),
      ),
    );
    return Semantics(
      selected: selected,
      expanded: expanded,
      child: iconOnly
          ? BrianButton.icon(
              onPressed: activate,
              focusNode: focusNode,
              autofocus: autofocus,
              semanticLabel: item.label,
              variant: variant,
              icon: icon,
            )
          : BrianButton(
              onPressed: activate,
              focusNode: focusNode,
              autofocus: autofocus,
              semanticLabel: item.label,
              variant: variant,
              child: DefaultTextStyle.merge(
                style: selected ? typography.t4Medium : typography.t4Regular,
                child: IconTheme.merge(
                  data: const IconThemeData(size: 20),
                  child: Row(
                    children: [
                      if (item.icon != null) ...[
                        SizedBox.square(dimension: 20, child: icon),
                        const SizedBox(width: BrianSpacing.x2),
                      ],
                      Expanded(
                        child: Text(
                          item.label,
                          softWrap: true,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      if (expanded != null) ...[
                        const SizedBox(width: BrianSpacing.x2),
                        AnimatedRotation(
                          turns: expanded! ? 0.5 : 0,
                          duration: _motionDuration(context),
                          curve: Curves.easeInOutCubic,
                          child: const _NavigationGlyph(
                            down: true,
                            collapsed: true,
                          ),
                        ),
                      ] else if (item.trailing != null) ...[
                        const SizedBox(width: BrianSpacing.x2),
                        item.trailing!,
                      ],
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

class _NavigationReveal extends StatefulWidget {
  const _NavigationReveal({required this.expanded, required this.child});
  final bool expanded;
  final Widget child;

  @override
  State<_NavigationReveal> createState() => _NavigationRevealState();
}

class _NavigationRevealState extends State<_NavigationReveal>
    with SingleTickerProviderStateMixin {
  late final _animation = AnimationController(
    vsync: this,
    value: widget.expanded ? 1 : 0,
  );
  late final _progress = CurvedAnimation(
    parent: _animation,
    curve: Curves.easeInOutCubic,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _animation.duration = _motionDuration(context);
    if (_animation.duration == Duration.zero) {
      _animation.value = widget.expanded ? 1 : 0;
    }
  }

  @override
  void didUpdateWidget(_NavigationReveal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.expanded != widget.expanded) {
      if (_animation.duration == Duration.zero) {
        _animation.value = widget.expanded ? 1 : 0;
      } else {
        widget.expanded ? _animation.forward() : _animation.reverse();
      }
    }
  }

  @override
  void dispose() {
    _progress.dispose();
    _animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _animation,
    builder: (context, _) {
      if (_animation.isDismissed && !widget.expanded) {
        return const SizedBox.shrink();
      }
      return ExcludeFocus(
        excluding: !widget.expanded,
        child: ExcludeSemantics(
          excluding: !widget.expanded,
          child: IgnorePointer(
            ignoring: !widget.expanded,
            child: ClipRect(
              child: Align(
                alignment: AlignmentDirectional.topStart,
                heightFactor: _progress.value,
                child: FadeTransition(opacity: _progress, child: widget.child),
              ),
            ),
          ),
        ),
      );
    },
  );
}

class _CollapsedItem extends StatefulWidget {
  const _CollapsedItem({
    required this.onActivate,
    required this.item,
    required this.selectedValue,
    required this.onSelected,
  });
  final ValueChanged<_CollapsedItemState> onActivate;
  final BrianSideNavigationItem item;
  final String? selectedValue;
  final ValueChanged<String> onSelected;

  @override
  State<_CollapsedItem> createState() => _CollapsedItemState();
}

class _CollapsedItemState extends State<_CollapsedItem> {
  final _portal = OverlayPortalController();
  final _anchor = GlobalKey();
  final _focus = FocusNode();
  Timer? _closeTimer;
  bool _keyboard = false;
  final _positions = <ScrollPosition>{};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (final position in _positions) {
      position.removeListener(_onScroll);
    }
    _positions.clear();
    // 문서 등 바깥 스크롤이 움직여도 팝업이 이전 위치에 남지 않게 합니다.
    context.visitAncestorElements((element) {
      if (element is StatefulElement && element.state is ScrollableState) {
        _positions.add((element.state as ScrollableState).position);
      }
      return true;
    });
    for (final position in _positions) {
      position.addListener(_onScroll);
    }
  }

  void _onScroll() => _close();

  @override
  void didUpdateWidget(_CollapsedItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedValue != widget.selectedValue ||
        !widget.item.enabled) {
      _close();
    }
  }

  void _open({bool keyboard = false}) {
    widget.onActivate(this);
    if (!widget.item.enabled) return;
    if (_portal.isShowing && _keyboard && !keyboard) return;
    _closeTimer?.cancel();
    setState(() => _keyboard = keyboard);
    _portal.show();
  }

  void _close({bool restoreFocus = false}) {
    _closeTimer?.cancel();
    if (_portal.isShowing) {
      // 외부 선택과 스크롤 보정은 레이아웃 중에도 전달될 수 있습니다.
      if (SchedulerBinding.instance.schedulerPhase ==
          SchedulerPhase.persistentCallbacks) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _close(restoreFocus: restoreFocus);
        });
        return;
      }
      _portal.hide();
      setState(() {});
    }
    if (restoreFocus) _focus.requestFocus();
  }

  void _scheduleClose() {
    _closeTimer?.cancel();
    if (!_keyboard) {
      if (widget.item.children.isEmpty) {
        _close();
        return;
      }
      // 하위 메뉴로 건너가는 짧은 간격에서만 닫기를 유예합니다.
      _closeTimer = Timer(const Duration(milliseconds: 120), () {
        if (mounted) _close();
      });
    }
  }

  @override
  void dispose() {
    _closeTimer?.cancel();
    for (final position in _positions) {
      position.removeListener(_onScroll);
    }
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => TapRegion(
    groupId: this,
    onTapOutside: (_) => _close(),
    child: MouseRegion(
      onEnter: (_) => _open(),
      onExit: (_) => _scheduleClose(),
      child: OverlayPortal(
        controller: _portal,
        overlayChildBuilder: _buildPopup,
        child: SizedBox(
          key: _anchor,
          child: _NavigationRow(
            item: widget.item,
            focusNode: _focus,
            selected:
                widget.item.value == widget.selectedValue ||
                widget.item.children.any(
                  (child) => child.value == widget.selectedValue,
                ),
            iconOnly: true,
            expanded: widget.item.children.isEmpty ? null : _portal.isShowing,
            onPressed: () {
              if (widget.item.children.isEmpty) {
                _close();
                widget.onSelected(widget.item.value);
              } else {
                _portal.isShowing && _keyboard
                    ? _close(restoreFocus: true)
                    : _open(keyboard: true);
              }
            },
          ),
        ),
      ),
    ),
  );

  Widget _buildPopup(BuildContext context) {
    final box = _anchor.currentContext!.findRenderObject()! as RenderBox;
    final overlay =
        Overlay.of(context).context.findRenderObject()! as RenderBox;
    final offset = box.localToGlobal(Offset.zero, ancestor: overlay);
    final width = math.min(240.0, math.max(0.0, overlay.size.width - 16));
    final height = math.min(320.0, math.max(0.0, overlay.size.height - 16));
    final rtl = Directionality.of(context) == TextDirection.rtl;
    // 버튼 바깥 여백 8px에 더해 사이드바 경계와 팝업 사이에도 8px을 둡니다.
    final left =
        (rtl
                ? offset.dx - width - BrianSpacing.x4
                : offset.dx + box.size.width + BrianSpacing.x4)
            .clamp(8.0, math.max(8.0, overlay.size.width - width - 8));
    final top = offset.dy.clamp(
      8.0,
      math.max(8.0, overlay.size.height - height - 8),
    );
    final theme = BrianTheme.of(context);
    final enabledChildren = widget.item.children.where(
      (child) => child.enabled,
    );
    return Positioned(
      left: left.toDouble(),
      top: top.toDouble(),
      width: width,
      child: TapRegion(
        groupId: this,
        child: MouseRegion(
          onEnter: (_) => _closeTimer?.cancel(),
          onExit: (_) => _scheduleClose(),
          child: FocusScope(
            onFocusChange: (focused) {
              if (!focused && _keyboard) _close();
            },
            child: Focus(
              autofocus: _keyboard && enabledChildren.isEmpty,
              skipTraversal: true,
              onKeyEvent: (_, event) {
                if (event is KeyDownEvent &&
                    event.logicalKey == LogicalKeyboardKey.escape) {
                  _close(restoreFocus: true);
                  return KeyEventResult.handled;
                }
                return KeyEventResult.ignored;
              },
              child: Container(
                constraints: BoxConstraints(maxHeight: height),
                padding: const EdgeInsets.all(BrianSpacing.x2),
                decoration: BoxDecoration(
                  color: theme.colors.background.layerFloating,
                  boxShadow: [theme.shadows.s3],
                  borderRadius: BorderRadius.circular(BrianRadius.r3),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(BrianSpacing.x2),
                        child: Text(
                          widget.item.label,
                          style: theme.typography.t3Medium.copyWith(
                            color: theme.colors.foreground.neutral,
                          ),
                        ),
                      ),
                      for (final child in widget.item.children)
                        _NavigationRow(
                          key: ValueKey(child.value),
                          item: child,
                          selected: child.value == widget.selectedValue,
                          autofocus:
                              _keyboard &&
                              enabledChildren.isNotEmpty &&
                              child == enabledChildren.first,
                          onPressed: () {
                            _close(restoreFocus: true);
                            widget.onSelected(child.value);
                          },
                        ),
                    ],
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

class _NavigationGlyph extends StatelessWidget {
  const _NavigationGlyph({required this.collapsed, this.down = false});
  final bool collapsed;
  final bool down;

  @override
  Widget build(BuildContext context) => CustomPaint(
    size: const Size(20, 20),
    painter: _NavigationGlyphPainter(
      color:
          IconTheme.of(context).color ??
          BrianTheme.of(context).colors.foreground.neutral,
      collapsed: collapsed,
      down: down,
      rtl: Directionality.of(context) == TextDirection.rtl,
    ),
  );
}

class _NavigationGlyphPainter extends CustomPainter {
  const _NavigationGlyphPainter({
    required this.color,
    required this.collapsed,
    required this.down,
    required this.rtl,
  });
  final Color color;
  final bool collapsed;
  final bool down;
  final bool rtl;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.7
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.scale(size.width / 20, size.height / 20);
    final path = Path();
    if (down) {
      final y = collapsed ? 8.0 : 12.0;
      path.moveTo(6, y);
      path.lineTo(10, 20 - y);
      path.lineTo(14, y);
    } else {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          const Rect.fromLTWH(2, 3, 16, 14),
          const Radius.circular(2),
        ),
        paint,
      );
      final right = collapsed != rtl;
      path.moveTo(right ? 9 : 13, 7);
      path.lineTo(right ? 12 : 10, 10);
      path.lineTo(right ? 9 : 13, 13);
      path.moveTo(6, 3);
      path.lineTo(6, 17);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_NavigationGlyphPainter oldDelegate) =>
      color != oldDelegate.color ||
      collapsed != oldDelegate.collapsed ||
      down != oldDelegate.down ||
      rtl != oldDelegate.rtl;
}
