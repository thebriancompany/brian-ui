import 'package:brian_ui/brian_ui.dart';
import 'package:flutter/material.dart' show Icons;
import 'package:flutter/widgets.dart';

import 'site_widgets.dart';

class ChipExamples extends StatefulWidget {
  const ChipExamples({super.key});

  @override
  State<ChipExamples> createState() => _ChipExamplesState();
}

class _ChipExamplesState extends State<ChipExamples> {
  String _category = '전체';
  final _interests = <String>{'산책'};
  final _filters = <String>{};
  final _people = <String>['민지', '준호', '수빈'];
  String? _query;
  final _styles = <String>{};

  Widget _wrap(List<Widget> children) => Wrap(
    spacing: 8,
    runSpacing: 8,
    crossAxisAlignment: WrapCrossAlignment.center,
    children: children,
  );

  void _toggle(Set<String> values, String value) => setState(() {
    if (!values.add(value)) values.remove(value);
  });

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _Example(
        heading: '스타일과 선택 상태',
        explanation: '채움은 선택을 강하게, 약한 외곽선은 여러 선택 항목을 차분하게 표현합니다.',
        code: "BrianChip(\n  variant: BrianChipVariant.solid,\n  selected: selected,\n  onPressed: () => setState(() => selected = !selected),\n  child: Text('선택 항목'),\n)",
        child: _wrap([
          for (final variant in BrianChipVariant.values)
            for (final selected in [false, true])
              BrianChip(
                variant: variant,
                selected:
                    selected != _styles.contains('${variant.name}/$selected'),
                onPressed: () => _toggle(_styles, '${variant.name}/$selected'),
                child: Text(
                  '${variant.name} · ${selected != _styles.contains('${variant.name}/$selected') ? '선택' : '기본'}',
                ),
              ),
        ]),
      ),
      _Example(
        heading: '크기와 비활성 상태',
        explanation: '작은 보조 항목부터 주요 필터까지 크기를 선택합니다. 비활성 항목은 실행되지 않습니다.',
        code: "BrianChip(\n  size: BrianChipSize.small,\n  onPressed: null,\n  child: Text('이용 불가'),\n)",
        child: _wrap([
          for (final size in BrianChipSize.values)
            BrianChip(size: size, onPressed: () {}, child: Text(size.name)),
          const BrianChip(onPressed: null, child: Text('이용 불가')),
          const BrianChip(
            selected: true,
            onPressed: null,
            child: Text('선택 후 비활성'),
          ),
        ]),
      ),
      _Example(
        heading: '단일 선택',
        explanation: '한 번에 하나의 카테고리를 선택합니다. 선택된 항목을 다시 눌러도 선택을 유지합니다.',
        code: "Wrap(\n  spacing: 8, runSpacing: 8,\n  children: [\n    for (final item in ['전체', '가구', '생활', '도서'])\n      BrianChip(\n        selected: category == item,\n        onPressed: () => setState(() => category = item),\n        child: Text(item),\n      ),\n  ],\n)",
        child: _wrap([
          for (final item in ['전체', '가구', '생활', '도서'])
            BrianChip(
              selected: _category == item,
              onPressed: () => setState(() => _category = item),
              child: Text(item),
            ),
        ]),
      ),
      _Example(
        heading: '다중 선택',
        explanation: '관심사를 여러 개 선택하거나 다시 눌러 해제합니다. 줄바꿈으로 모든 항목을 보여줍니다.',
        code: "BrianChip(\n  selected: interests.contains(item),\n  onPressed: () => setState(() {\n    if (!interests.add(item)) interests.remove(item);\n  }),\n  child: Text(item),\n)",
        child: _wrap([
          for (final item in ['산책', '요리', '사진', '운동', '음악', '여행'])
            BrianChip(
              selected: _interests.contains(item),
              onPressed: () => _toggle(_interests, item),
              child: Text(item),
            ),
        ]),
      ),
      _Example(
        heading: '필터와 초기화',
        explanation: '적용한 조건이 있을 때만 초기화를 표시합니다. 결과에도 현재 조건을 반영합니다.',
        code: "BrianChip(\n  selected: filters.contains('무료 배송'),\n  leading: Icon(Icons.local_shipping_outlined),\n  onPressed: () => toggleFilter('무료 배송'),\n  child: Text('무료 배송'),\n)\n// 활성 필터가 있으면 별도 버튼으로 filters.clear()를 실행합니다.",
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _wrap([
              for (final item in ['무료 배송', '할인 중', '오늘 도착'])
                BrianChip(
                  selected: _filters.contains(item),
                  leading: item == '무료 배송'
                      ? const Icon(Icons.local_shipping_outlined)
                      : null,
                  onPressed: () => _toggle(_filters, item),
                  child: Text(item),
                ),
              if (_filters.isNotEmpty)
                BrianButton(
                  variant: BrianButtonVariant.ghost,
                  onPressed: () => setState(_filters.clear),
                  child: const Text('필터 초기화'),
                ),
            ]),
            const SizedBox(height: 12),
            Semantics(
              liveRegion: true,
              child: Text(
                _filters.isEmpty
                    ? '모든 상품을 표시합니다.'
                    : '적용 조건: ${_filters.join(', ')}',
              ),
            ),
          ],
        ),
      ),
      _Example(
        heading: '추천 검색어 · 가로 스크롤',
        explanation: '추천어는 선택 상태 없이 검색을 실행합니다. 좁은 영역에서는 가로로 스크롤해 탐색합니다.',
        code: "SingleChildScrollView(\n  scrollDirection: Axis.horizontal,\n  child: Row(children: [\n    BrianChip(\n      onPressed: () => search('캠핑 의자'),\n      child: Text('캠핑 의자'),\n    ),\n  ]),\n)",
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final item in [
                    '캠핑 의자',
                    '원목 책상',
                    '무선 헤드폰',
                    '러닝화',
                    '작은 화분',
                  ])
                    Padding(
                      padding: const EdgeInsetsDirectional.only(end: 8),
                      child: BrianChip(
                        onPressed: () => setState(() => _query = item),
                        child: Text(item),
                      ),
                    ),
                ],
              ),
            ),
            if (_query != null) ...[
              const SizedBox(height: 12),
              Semantics(liveRegion: true, child: Text('검색: $_query')),
            ],
          ],
        ),
      ),
      _Example(
        heading: '입력값과 삭제',
        explanation: '추가한 수신자를 독립된 삭제 버튼으로 제거합니다. Tab으로 삭제 버튼에 이동해 Enter·Space로 실행할 수도 있습니다.',
        code: "BrianChip(\n  onPressed: null,\n  leadingStyle: BrianChipLeadingStyle.avatar,\n  leading: ColoredBox(color: avatarColor, child: Center(child: Text('민'))),\n  onDeleted: () => setState(() => people.remove('민지')),\n  deleteLabel: '민지 삭제',\n  child: Text('민지'),\n)",
        child: _wrap([
          for (final person in _people)
            BrianChip(
              onPressed: null,
              leadingStyle: BrianChipLeadingStyle.avatar,
              leading: ColoredBox(
                color: BrianTheme.of(context).colors.background.neutralWeak,
                child: Center(child: Text(person.substring(0, 1))),
              ),
              onDeleted: () => setState(() => _people.remove(person)),
              deleteLabel: '$person 삭제',
              child: Text(person),
            ),
          if (_people.length < 3)
            BrianButton(
              variant: BrianButtonVariant.ghost,
              onPressed: () => setState(() {
                _people.clear();
                _people.addAll(['민지', '준호', '수빈']);
              }),
              child: const Text('수신자 복원'),
            ),
        ]),
      ),
      _Example(
        heading: '아이콘과 보조 표시',
        explanation: '앞쪽 아이콘은 항목의 의미를 보완합니다. 뒤쪽 아이콘은 본문과 같은 동작을 설명합니다.',
        code: "BrianChip(\n  leading: Icon(Icons.place_outlined),\n  trailing: Icon(Icons.expand_more),\n  onPressed: openLocation,\n  child: Text('내 동네'),\n)",
        child: _wrap([
          BrianChip(
            leading: const Icon(Icons.place_outlined),
            trailing: const Icon(Icons.expand_more),
            onPressed: () => setState(() => _query = '내 동네'),
            child: const Text('내 동네'),
          ),
          BrianChip(
            leading: const Icon(Icons.park_outlined),
            onPressed: () => setState(() => _query = '공원'),
            child: const Text('공원'),
          ),
        ]),
      ),
    ],
  );
}

class _Example extends StatelessWidget {
  const _Example({
    required this.heading,
    required this.explanation,
    required this.code,
    required this.child,
  });
  final String heading;
  final String explanation;
  final String code;
  final Widget child;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SectionHeading(heading),
      Text(explanation),
      const SizedBox(height: BrianSpacing.x4),
      Surface(child: child),
      const SizedBox(height: BrianSpacing.x4),
      CodeExample(code),
    ],
  );
}
