import 'package:brian_ui/brian_ui.dart';
import 'package:flutter/widgets.dart';

import 'site_widgets.dart';

class ButtonGroupExamples extends StatelessWidget {
  const ButtonGroupExamples({super.key});

  @override
  Widget build(BuildContext context) => const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _GroupExample(title: '단일 버튼', description: '주요 버튼 하나가 전체 너비를 채웁니다.'),
      _GroupExample(
        title: '두 버튼',
        description: '보조·주요 순서로 같은 너비를 사용합니다.',
        secondary: '취소',
      ),
      _GroupExample(
        title: '긴 라벨',
        description: '한 줄에 들어가지 않으면 주요·보조 순서로 세로 배치합니다.',
        primary: '변경 사항을 모두 저장하고 계속 진행하기',
        secondary: '이전 화면으로 돌아가기',
      ),
    ],
  );
}

class _GroupExample extends StatefulWidget {
  const _GroupExample({
    required this.title,
    required this.description,
    this.primary = '확인',
    this.secondary,
  });
  final String title;
  final String description;
  final String primary;
  final String? secondary;

  @override
  State<_GroupExample> createState() => _GroupExampleState();
}

class _GroupExampleState extends State<_GroupExample> {
  String? _selected;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SectionHeading(widget.title),
      Text(widget.description),
      const SizedBox(height: BrianSpacing.x4),
      Surface(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: Column(
              children: [
                BrianButtonGroup(
                  primaryAction: BrianButtonGroupAction(
                    label: widget.primary,
                    onPressed: () => setState(() => _selected = widget.primary),
                  ),
                  secondaryAction: widget.secondary == null
                      ? null
                      : BrianButtonGroupAction(
                          label: widget.secondary!,
                          onPressed: () =>
                              setState(() => _selected = widget.secondary),
                        ),
                ),
                if (_selected != null) ...[
                  const SizedBox(height: BrianSpacing.x4),
                  Semantics(liveRegion: true, child: Text('$_selected 선택')),
                ],
              ],
            ),
          ),
        ),
      ),
      const SizedBox(height: BrianSpacing.x4),
      CodeExample('''BrianButtonGroup(
  primaryAction: BrianButtonGroupAction(
    label: '${widget.primary}',
    onPressed: onConfirm,
  ),${widget.secondary == null ? '' : "\n  secondaryAction: BrianButtonGroupAction(\n    label: '${widget.secondary}',\n    onPressed: onCancel,\n  ),"}
)'''),
    ],
  );
}
