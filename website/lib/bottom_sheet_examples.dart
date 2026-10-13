import 'package:brian_ui/brian_ui.dart';
import 'package:flutter/widgets.dart';

import 'site_widgets.dart';

class BottomSheetExamples extends StatelessWidget {
  const BottomSheetExamples({super.key});

  @override
  Widget build(BuildContext context) => const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _SheetExample(
        title: '빠른 선택',
        description: '필요한 만큼만 열리는 시트에서 정렬 순서를 선택합니다.',
      ),
      _SheetExample(
        title: '버튼 2개',
        description: '고정된 푸터에 보조 액션과 주요 액션을 같은 너비로 배치합니다.',
        primaryLabel: '확인',
        secondaryLabel: '취소',
      ),
      _SheetExample(
        title: '버튼 2개 길게',
        description:
            '어느 라벨이든 한 줄에 들어가지 않으면 주요·보조 순서로 세로 배치됩니다. 본문 스크롤과 푸터 고정은 유지됩니다.',
        long: true,
        primaryLabel: '변경 사항을 모두 저장하고 다음 단계로 계속 진행하기',
        secondaryLabel: '변경 사항을 저장하지 않고 이전 화면으로 돌아가기',
      ),
      _SheetExample(
        title: '긴 콘텐츠',
        description: '제목과 닫기 버튼은 고정되고 목록은 하단 Fog 아래로 스크롤됩니다. 끝까지 내려 마지막 항목의 여백을 확인하세요. 맨 위에서 아래로 더 끌면 시트가 따라옵니다.',
        long: true,
      ),
      _SheetExample(
        title: '핸들 없이',
        description: '핸들이 없어도 헤더·본문·푸터·여백에서 아래로 끌어 닫을 수 있습니다.',
        handle: false,
      ),
      _SheetExample(
        title: '긴 콘텐츠 · 핸들 없이',
        description: '핸들 없이도 내부 스크롤과 닫기 제스처가 동일하게 연결됩니다.',
        long: true,
        handle: false,
      ),
      _SheetExample(
        title: '배경 탭 닫기 끄기',
        description: '배경을 눌러도 유지됩니다. 고정된 닫기 버튼이나 아래로 드래그하여 닫아보세요.',
        barrierDismissible: false,
      ),
      _SheetExample(
        title: '드래그 닫기 끄기',
        description: '목록 스크롤은 유지하면서 드래그 닫기만 끕니다. 닫기 버튼이나 바깥 영역으로 닫을 수 있습니다.',
        long: true,
        drag: false,
      ),
    ],
  );
}

class _SheetExample extends StatefulWidget {
  const _SheetExample({
    required this.title,
    required this.description,
    this.primaryLabel = '닫기',
    this.secondaryLabel,
    this.long = false,
    this.handle = true,
    this.drag = true,
    this.barrierDismissible = true,
  });
  final String title;
  final String description;
  final String primaryLabel;
  final String? secondaryLabel;
  final bool long;
  final bool handle;
  final bool drag;
  final bool barrierDismissible;

  @override
  State<_SheetExample> createState() => _SheetExampleState();
}

class _SheetExampleState extends State<_SheetExample> {
  String? _result;

  Future<void> _show() async {
    final result = await showBrianBottomSheet<String>(
      context: context,
      showHandle: widget.handle,
      enableDrag: widget.drag,
      barrierDismissible: widget.barrierDismissible,
      semanticLabel: widget.long ? '배송지 선택' : '정렬 순서',
      headerBuilder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.long ? '어디로 보내드릴까요?' : '어떤 순서로 볼까요?',
            style: BrianTheme.of(context).typography.t7Bold,
          ),
          const SizedBox(height: BrianSpacing.x3),
          Text(widget.long ? '저장된 배송지를 확인하고 선택하세요.' : '원하는 정렬 순서를 선택하세요.'),
        ],
      ),
      footerBuilder: (context) => BrianButtonGroup(
        primaryAction: BrianButtonGroupAction(
          label: widget.primaryLabel,
          onPressed: () => Navigator.of(context).pop(widget.primaryLabel),
        ),
        secondaryAction: widget.secondaryLabel == null
            ? null
            : BrianButtonGroupAction(
                label: widget.secondaryLabel!,
                onPressed: () => Navigator.of(context).pop(),
              ),
      ),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final label
              in widget.long
                  ? List.generate(
                      25,
                      (index) => '배송지 ${index + 1} · 서울시 중구 세종대로 ${index + 1}',
                    )
                  : ['추천순', '최신순', '낮은 가격순'])
            Padding(
              padding: const EdgeInsets.only(bottom: BrianSpacing.x3),
              child: BrianButton(
                variant: BrianButtonVariant.neutralWeak,
                onPressed: () => Navigator.of(context).pop(label),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(label),
                ),
              ),
            ),
        ],
      ),
    );
    if (mounted) setState(() => _result = result ?? '선택 없이 닫혔습니다.');
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SectionHeading(widget.title),
      Text(widget.description),
      const SizedBox(height: BrianSpacing.x4),
      Surface(
        child: Column(
          children: [
            BrianButton(onPressed: _show, child: Text('${widget.title} 예제 열기')),
            if (_result != null) ...[
              const SizedBox(height: BrianSpacing.x4),
              Semantics(liveRegion: true, child: Text(_result!)),
            ],
          ],
        ),
      ),
      const SizedBox(height: BrianSpacing.x4),
      CodeExample('''final result = await showBrianBottomSheet<String>(
  context: context,
  showHandle: ${widget.handle},
  enableDrag: ${widget.drag},
  barrierDismissible: ${widget.barrierDismissible},
  headerBuilder: (context) => const Text('${widget.long ? '배송지 선택' : '정렬 순서'}'),
  footerBuilder: (context) => BrianButtonGroup(
    primaryAction: BrianButtonGroupAction(
      label: '${widget.primaryLabel}',
      onPressed: () => Navigator.of(context).pop('${widget.primaryLabel}'),
    ),${widget.secondaryLabel == null ? '' : "\n    secondaryAction: BrianButtonGroupAction(\n      label: '${widget.secondaryLabel}',\n      onPressed: () => Navigator.of(context).pop(),\n    ),"}
  ),
  builder: (context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      for (final label in ${widget.long ? "List.generate(25, (i) => '배송지 \${i + 1}')" : "['추천순', '최신순', '낮은 가격순']"})
        BrianButton(
          onPressed: () => Navigator.of(context).pop(label),
          child: Text(label),
        ),
    ],
  ),
);'''),
    ],
  );
}
