import 'package:brian_ui/brian_ui.dart';
import 'package:flutter/widgets.dart';

import 'site_widgets.dart';

class CheckboxExamples extends StatefulWidget {
  const CheckboxExamples({super.key});

  @override
  State<CheckboxExamples> createState() => _CheckboxExamplesState();
}

class _CheckboxExamplesState extends State<CheckboxExamples> {
  bool _agreed = false;
  bool _continued = false;
  final _channels = [true, false, false];
  final _interests = [false, true, false];
  final _sizes = [false, true, false, true];
  bool _optional = false;
  bool _longLabel = false;
  String _saved = '아직 저장하지 않았습니다.';

  bool? get _all => _channels.every((value) => value)
      ? true
      : _channels.any((value) => value)
      ? null
      : false;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _Example(
        heading: '필수 약관 동의',
        explanation: '명확한 상자 형태로 필수 동의를 받습니다. 동의한 뒤 다음 단계로 진행할 수 있습니다.',
        code: '''BrianCheckbox(
  value: agreed,
  onChanged: (value) => setState(() => agreed = value),
  label: Text('이용약관에 동의합니다 (필수)'),
)
BrianButton(
  onPressed: agreed ? onContinue : null,
  child: Text('계속하기'),
)''',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BrianCheckbox(
              value: _agreed,
              onChanged: (value) => setState(() {
                _agreed = value;
                _continued = false;
              }),
              label: const Text('이용약관에 동의합니다 (필수)'),
            ),
            const SizedBox(height: BrianSpacing.x3),
            BrianButton(
              onPressed: _agreed
                  ? () => setState(() => _continued = true)
                  : null,
              child: const Text('계속하기'),
            ),
            if (_continued)
              Semantics(liveRegion: true, child: const Text('동의를 확인했습니다.')),
          ],
        ),
      ),
      _Example(
        heading: '전체 선택과 부분 선택',
        explanation: '일부 채널만 선택하면 부모에 가로선이 표시됩니다. 부분 선택 상태에서 부모를 누르면 모두 선택합니다.',
        code: '''final bool? all = channels.every((v) => v)
    ? true : channels.any((v) => v) ? null : false;
BrianCheckbox(
  value: all,
  weight: BrianCheckboxWeight.bold,
  label: Text('알림 채널 전체 선택'),
  onChanged: (value) => setState(() {
    channels.fillRange(0, channels.length, value);
  }),
)''',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BrianCheckbox(
              value: _all,
              weight: BrianCheckboxWeight.bold,
              label: const Text('알림 채널 전체 선택'),
              onChanged: (value) => setState(
                () => _channels.fillRange(0, _channels.length, value),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.only(start: BrianSpacing.x6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final (index, label) in [
                    '앱 알림',
                    '이메일',
                    '문자 메시지',
                  ].indexed)
                    BrianCheckbox(
                      value: _channels[index],
                      onChanged: (value) =>
                          setState(() => _channels[index] = value),
                      label: Text(label),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      _Example(
        heading: '관심 항목 선택 후 저장',
        explanation: '각 항목을 독립적으로 선택합니다. 선택 중인 값과 마지막으로 저장한 값을 구분합니다.',
        code: '''BrianCheckbox(
  value: interests[index],
  label: Text(labels[index]),
  onChanged: (value) => setState(() => interests[index] = value),
)
BrianButton(onPressed: saveInterests, child: Text('관심 항목 저장'))''',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final (index, label) in ['디자인', '개발', '제품 소식'].indexed)
              BrianCheckbox(
                value: _interests[index],
                onChanged: (value) => setState(() => _interests[index] = value),
                label: Text(label),
              ),
            const SizedBox(height: BrianSpacing.x3),
            BrianButton(
              onPressed: () => setState(() {
                final selected = [
                  for (final (index, label) in ['디자인', '개발', '제품 소식'].indexed)
                    if (_interests[index]) label,
                ];
                _saved =
                    '저장한 관심 항목: ${selected.isEmpty ? '없음' : selected.join(', ')}';
              }),
              child: const Text('관심 항목 저장'),
            ),
            const SizedBox(height: BrianSpacing.x3),
            Semantics(liveRegion: true, child: Text(_saved)),
          ],
        ),
      ),
      _Example(
        heading: '가벼운 선택 항목',
        explanation: '필수가 아닌 간단한 선택에는 ghost 형태를 사용합니다.',
        code: '''BrianCheckbox(
  value: optional,
  shape: BrianCheckboxShape.ghost,
  onChanged: (value) => setState(() => optional = value),
  label: Text('새로운 기능 소식을 받아볼게요 (선택)'),
)''',
        child: BrianCheckbox(
          value: _optional,
          shape: BrianCheckboxShape.ghost,
          onChanged: (value) => setState(() => _optional = value),
          label: const Text('새로운 기능 소식을 받아볼게요 (선택)'),
        ),
      ),
      _Example(
        heading: '크기와 강조',
        explanation: '일반 목록은 medium, 더 눈에 띄는 행은 large를 사용합니다. 부모 항목이나 중요한 라벨은 bold로 강조합니다.',
        code: '''BrianCheckbox(
  value: selected,
  size: BrianCheckboxSize.large,
  weight: BrianCheckboxWeight.bold,
  onChanged: onChanged,
  label: Text('Large · Bold'),
)''',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final size in BrianCheckboxSize.values)
              for (final weight in BrianCheckboxWeight.values)
                BrianCheckbox(
                  value: _sizes[size.index * 2 + weight.index],
                  size: size,
                  weight: weight,
                  onChanged: (value) => setState(
                    () => _sizes[size.index * 2 + weight.index] = value,
                  ),
                  label: Text('${size.name} · ${weight.name}'),
                ),
          ],
        ),
      ),
      _Example(
        heading: '긴 라벨과 행 전체 선택',
        explanation: '라벨은 여러 줄로 늘어납니다. 행을 넓게 배치하면 빈 공간도 선택 영역에 포함됩니다. Tab으로 이동한 뒤 Space 또는 Enter로 조작할 수 있습니다.',
        code: '''SizedBox(
  width: double.infinity,
  child: BrianCheckbox(
    value: selected,
    onChanged: onChanged,
    label: Text('배송 일정과 수령 장소를 확인했으며, 부재 시 지정한 장소에 보관하는 것에 동의합니다.'),
  ),
)''',
        child: SizedBox(
          width: double.infinity,
          child: BrianCheckbox(
            value: _longLabel,
            onChanged: (value) => setState(() => _longLabel = value),
            label: const Text(
              '배송 일정과 수령 장소를 확인했으며, 부재 시 지정한 장소에 보관하는 것에 동의합니다.',
            ),
          ),
        ),
      ),
      const _Example(
        heading: '변경할 수 없는 상태',
        explanation: 'onChanged가 null이면 입력과 키보드 탐색에서 제외됩니다. 선택 여부는 그대로 표시합니다.',
        code: '''BrianCheckbox(
  value: true,
  onChanged: null,
  label: Text('이미 적용된 필수 항목'),
)''',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BrianCheckbox(
              value: false,
              onChanged: null,
              label: Text('현재 선택할 수 없는 항목'),
            ),
            BrianCheckbox(
              value: true,
              onChanged: null,
              label: Text('이미 적용된 필수 항목'),
            ),
            BrianCheckbox(
              value: null,
              onChanged: null,
              label: Text('일부 항목이 적용된 그룹'),
            ),
            BrianCheckbox(
              value: true,
              shape: BrianCheckboxShape.ghost,
              onChanged: null,
              label: Text('변경할 수 없는 선택 항목'),
            ),
          ],
        ),
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
