import 'package:brian_ui/brian_ui.dart';
import 'package:flutter/widgets.dart';

import 'site_widgets.dart';

class AlertDialogExamples extends StatelessWidget {
  const AlertDialogExamples({super.key});

  @override
  Widget build(BuildContext context) => const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _DialogExample(
        heading: '기본',
        explanation: '안내를 읽고 확인만 하면 되는 상황에 사용합니다. 버튼 하나가 전체 너비를 채웁니다.',
        title: '저장했습니다',
        description: '변경 사항이 안전하게 저장되었습니다.',
      ),
      _DialogExample(
        heading: '버튼 2개',
        explanation: '진행 여부를 선택해야 할 때 확인과 취소를 함께 제공합니다.',
        title: '변경 사항을 저장할까요?',
        description: '확인을 누르면 변경 사항을 저장합니다.',
        secondaryLabel: '취소',
      ),
      _DialogExample(
        heading: '버튼 2개 길게',
        explanation: '한쪽 라벨이라도 두 줄이 되면 세로로 전환합니다. 주요 액션은 위에, 보조 액션은 아래에 놓입니다.',
        title: '이어서 진행할까요?',
        description: '변경 사항을 저장한 후 다음 단계로 이동합니다.',
        primaryLabel: '변경 사항을 저장하고 계속 진행하기',
        secondaryLabel: '취소하고 이전 화면으로 돌아가기',
      ),
      _DialogExample(
        heading: '로딩 후 닫기',
        explanation:
            '확인 또는 취소를 누르면 선택한 버튼에 로딩이 표시됩니다. 다른 입력은 잠기고 3초 뒤 선택 결과와 함께 닫힙니다.',
        title: '변경 사항을 처리할까요?',
        description: '확인과 취소 모두 처리에 3초가 걸립니다.',
        secondaryLabel: '취소',
        delayed: true,
      ),
      _DialogExample(
        heading: '브랜드 솔리드 버튼',
        explanation: '브랜드를 강조할 주요 액션에 brandSolid를 지정합니다.',
        title: '새로운 여정을 시작할까요?',
        description: '지금 시작하고 새로운 기능을 만나보세요.',
        primaryLabel: '시작하기',
        secondaryLabel: '닫기',
        variant: BrianButtonVariant.brandSolid,
      ),
    ],
  );
}

class _DialogExample extends StatefulWidget {
  const _DialogExample({
    required this.heading,
    required this.explanation,
    required this.title,
    required this.description,
    this.primaryLabel = '확인',
    this.secondaryLabel,
    this.delayed = false,
    this.variant = BrianButtonVariant.neutralSolid,
  });

  final String heading;
  final String explanation;
  final String title;
  final String description;
  final String primaryLabel;
  final String? secondaryLabel;
  final bool delayed;
  final BrianButtonVariant variant;

  @override
  State<_DialogExample> createState() => _DialogExampleState();
}

class _DialogExampleState extends State<_DialogExample> {
  String? _result;

  Future<void> _wait() => Future<void>.delayed(const Duration(seconds: 3));

  String get _code {
    final callback = [
      if (widget.delayed) ...[
        '    onPressed: () async {',
        '      await Future<void>.delayed(const Duration(seconds: 3));',
        '    },',
      ],
    ];
    final constant = widget.delayed ? '' : 'const ';
    return [
      'final result = await showBrianAlertDialog<bool>(',
      '  context: context,',
      "  title: '${widget.title}',",
      "  description: '${widget.description}',",
      '  primaryAction: ${constant}BrianAlertDialogAction(',
      "    label: '${widget.primaryLabel}',",
      '    value: true,',
      if (widget.variant != BrianButtonVariant.neutralSolid)
        '    variant: BrianButtonVariant.${widget.variant.name},',
      ...callback,
      '  ),',
      if (widget.secondaryLabel != null) ...[
        '  secondaryAction: ${constant}BrianAlertDialogAction(',
        "    label: '${widget.secondaryLabel}',",
        '    value: false,',
        '    variant: BrianButtonVariant.neutralWeak,',
        ...callback,
        '  ),',
      ],
      ');',
    ].join('\n');
  }

  Future<void> _show() async {
    final result = await showBrianAlertDialog<bool>(
      context: context,
      title: widget.title,
      description: widget.description,
      primaryAction: BrianAlertDialogAction(
        label: widget.primaryLabel,
        value: true,
        variant: widget.variant,
        onPressed: widget.delayed ? _wait : null,
      ),
      secondaryAction: widget.secondaryLabel == null
          ? null
          : BrianAlertDialogAction(
              label: widget.secondaryLabel!,
              value: false,
              variant: BrianButtonVariant.neutralWeak,
              onPressed: widget.delayed ? _wait : null,
            ),
    );
    if (!mounted) return;
    setState(
      () => _result = switch (result) {
        true => '${widget.primaryLabel} 선택',
        false => '${widget.secondaryLabel} 선택',
        null => '선택 없이 닫혔습니다.',
      },
    );
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SectionHeading(widget.heading),
      Text(widget.explanation),
      const SizedBox(height: BrianSpacing.x4),
      Surface(
        child: Column(
          children: [
            BrianButton(
              onPressed: _show,
              child: Text('${widget.heading} 예제 열기'),
            ),
            if (_result != null) ...[
              const SizedBox(height: BrianSpacing.x4),
              Semantics(liveRegion: true, child: Text(_result!)),
            ],
          ],
        ),
      ),
      const SizedBox(height: BrianSpacing.x4),
      CodeExample(_code),
    ],
  );
}
