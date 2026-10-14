import 'package:brian_ui/brian_ui.dart';
import 'package:flutter/material.dart' show Icons;
import 'package:flutter/widgets.dart';

import 'site_widgets.dart';

class SideNavigationExamples extends StatelessWidget {
  const SideNavigationExamples({super.key});

  @override
  Widget build(BuildContext context) => const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _Example(
        title: '페이지 이동과 상태',
        description: '메뉴를 선택하면 현재 페이지가 바뀝니다. 알림 배지와 비활성 항목을 함께 확인하세요.',
        kind: 0,
      ),
      _Example(
        title: '그룹과 하위 메뉴',
        description: '부모를 누르면 하위 메뉴의 높이와 투명도, 화살표 회전이 함께 전환됩니다. 선택한 하위 메뉴를 접으면 부모에 선택 강조가 표시되고, 다시 펼치면 하위 항목에 표시됩니다.',
        kind: 1,
      ),
      _Example(
        title: '접힌 탐색 메뉴',
        description: '접기 버튼으로 너비를 바꿔 보세요. 아이콘 위에 마우스를 올리면 이름이나 하위 메뉴가 나타납니다. 하위 메뉴는 클릭 또는 Enter로도 열 수 있고 Escape로 닫습니다.',
        kind: 2,
      ),
      _Example(
        title: '배경과 긴 메뉴 이름',
        description: '투명 배경으로 부모 표면을 공유합니다. 긴 이름은 생략하지 않고 줄바꿈합니다.',
        kind: 3,
      ),
      _Example(
        title: '고정 헤더·푸터와 스크롤',
        description:
            '메뉴만 스크롤됩니다. 아래에 메뉴가 더 있으면 그라디언트가, 위로 스크롤한 내용이 있으면 상단 구분선이 표시됩니다.',
        kind: 4,
      ),
    ],
  );
}

class _Example extends StatefulWidget {
  const _Example({
    required this.title,
    required this.description,
    required this.kind,
  });
  final String title;
  final String description;
  final int kind;

  @override
  State<_Example> createState() => _ExampleState();
}

class _ExampleState extends State<_Example> {
  String _selected = 'home';
  late bool _collapsed = widget.kind == 2;

  List<BrianSideNavigationGroup> get _groups => [
    BrianSideNavigationGroup(
      label: '워크스페이스',
      items: [
        const BrianSideNavigationItem(
          value: 'home',
          label: '홈',
          icon: Icon(Icons.home_outlined),
        ),
        if (widget.kind == 1 || widget.kind == 2)
          const BrianSideNavigationItem(
            value: 'projects',
            label: '프로젝트',
            icon: Icon(Icons.folder_outlined),
            children: [
              BrianSideNavigationItem(value: 'ongoing', label: '진행 중'),
              BrianSideNavigationItem(value: 'archive', label: '보관함'),
            ],
          ),
        const BrianSideNavigationItem(
          value: 'inbox',
          label: '받은 편지함',
          icon: Icon(Icons.inbox_outlined),
          trailing: Text('3'),
        ),
        if (widget.kind == 3)
          const BrianSideNavigationItem(
            value: 'long',
            label: '팀 구성원과 함께 관리하는 프로젝트 및 공유 문서',
            icon: Icon(Icons.description_outlined),
          ),
        const BrianSideNavigationItem(
          value: 'reports',
          label: '보고서 (준비 중)',
          icon: Icon(Icons.bar_chart),
          enabled: false,
        ),
      ],
    ),
    if (widget.kind == 4)
      BrianSideNavigationGroup(
        label: '프로젝트',
        items: [
          for (var i = 1; i <= 16; i++)
            BrianSideNavigationItem(
              value: 'project-$i',
              label: '프로젝트 $i',
              icon: const Icon(Icons.folder_outlined),
            ),
        ],
      ),
    const BrianSideNavigationGroup(
      label: '관리',
      items: [
        BrianSideNavigationItem(
          value: 'settings',
          label: '설정',
          icon: Icon(Icons.settings_outlined),
        ),
      ],
    ),
  ];

  String _itemCode(BrianSideNavigationItem item, String indent) {
    final icon = switch (item.value) {
      'home' => 'home_outlined',
      'inbox' => 'inbox_outlined',
      'reports' => 'bar_chart',
      'settings' => 'settings_outlined',
      'long' => 'description_outlined',
      _ => 'folder_outlined',
    };
    return "${indent}BrianSideNavigationItem(\n$indent  value: '${item.value}',\n$indent  label: '${item.label}',\n${item.icon != null ? '$indent  icon: Icon(Icons.$icon),\n' : ''}${item.trailing != null ? "$indent  trailing: Text('3'),\n" : ''}${!item.enabled ? '$indent  enabled: false,\n' : ''}${item.children.isNotEmpty ? '$indent  children: [\n${item.children.map((c) => _itemCode(c, '$indent    ')).join()}$indent  ],\n' : ''}$indent),\n";
  }

  @override
  Widget build(BuildContext context) {
    final groups = _groups;
    final label = groups
        .expand((g) => g.items)
        .expand((i) => [i, ...i.children])
        .firstWhere((i) => i.value == _selected)
        .label;
    final transparent = widget.kind == 3;
    final code =
        "// State의 현재 값: selected = '$_selected', collapsed = $_collapsed\n// 아이콘은 앱의 아이콘 세트를 전달합니다.\nSizedBox(\n  height: 360,\n  child: BrianSideNavigation(\n    selectedValue: selected,\n    onSelected: (value) => setState(() => selected = value),\n${widget.kind == 2 ? '    collapsed: collapsed,\n    onCollapsedChanged: (value) => setState(() => collapsed = value),\n' : ''}${transparent ? '    variant: BrianSideNavigationVariant.transparent,\n' : ''}    header: Text('Brian Workspace'),\n    footer: Text('도움이 필요하면 지원팀에 문의하세요.'),\n    groups: [\n${groups.map((g) => "      BrianSideNavigationGroup(\n        label: '${g.label}',\n        items: [\n${g.items.map((i) => _itemCode(i, '          ')).join()}        ],\n      ),\n").join()}    ],\n  ),\n)";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeading(widget.title),
        Text(widget.description),
        const SizedBox(height: BrianSpacing.x4),
        Surface(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 360,
                child: BrianSideNavigation(
                  groups: groups,
                  selectedValue: _selected,
                  onSelected: (value) => setState(() => _selected = value),
                  collapsed: _collapsed,
                  onCollapsedChanged: widget.kind == 2
                      ? (value) => setState(() => _collapsed = value)
                      : null,
                  variant: transparent
                      ? BrianSideNavigationVariant.transparent
                      : BrianSideNavigationVariant.neutral,
                  header: const Text('Brian Workspace'),
                  footer: const Text('도움이 필요하면 지원팀에 문의하세요.'),
                ),
              ),
              const SizedBox(height: BrianSpacing.x3),
              Semantics(liveRegion: true, child: Text('현재 페이지: $label')),
            ],
          ),
        ),
        const SizedBox(height: BrianSpacing.x4),
        CodeExample(code),
      ],
    );
  }
}
