import 'package:brian_ui/brian_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import 'site_widgets.dart';

class ScrollFogExamples extends StatelessWidget {
  const ScrollFogExamples({super.key});

  @override
  Widget build(BuildContext context) => const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _FogExample(
        title: '하단 · 긴 목록',
        description:
            '하단 80px을 부드럽게 가립니다. 끝까지 내리면 같은 깊이의 패딩 덕분에 마지막 항목을 온전히 볼 수 있습니다.',
      ),
      _FogExample(
        title: '상단과 하단 · 양방향 탐색',
        description: '상단 20px과 하단 80px을 함께 사용합니다. Fog는 스크롤을 시작하거나 멈춰도 유지됩니다.',
        both: true,
      ),
      _FogExample(
        title: '좌우 · 가로 목록',
        description: '양쪽 20px을 겹쳐 놓습니다. 터치나 마우스 드래그로 목록을 탐색해 보세요.',
        horizontal: true,
        both: true,
      ),
      _FogExample(
        title: '다른 표면 · 깊이 조절',
        description:
            '표면색을 직접 전달하고 깊이를 40px로 줄입니다. 사이트 테마를 바꾸면 표면과 Fog가 함께 바뀝니다.',
        custom: true,
      ),
      _FogExample(
        title: '짧은 콘텐츠',
        description: '스크롤할 내용이 없어도 Fog는 유지됩니다. 콘텐츠 뒤의 패딩과 겹치므로 내용은 가려지지 않습니다.',
        short: true,
      ),
      SectionHeading('고정 액션 · BottomSheet'),
      Text('BottomSheet에 footer를 제공하면 본문 하단에 Fog와 끝 여백이 자동으로 적용됩니다.'),
      SizedBox(height: BrianSpacing.x4),
      _SheetDemo(),
      SizedBox(height: BrianSpacing.x4),
      CodeExample(r'''showBrianBottomSheet<void>(
  context: context,
  footerBuilder: (context) => BrianButton(
    onPressed: () => Navigator.of(context).pop(),
    child: const Text('확인'),
  ),
  builder: (_) => Column(
    children: [
      for (var i = 1; i <= 20; i++)
        SizedBox(height: 56, child: Text('배송 안내 $i')),
    ],
  ),
);'''),
    ],
  );
}

class _FogExample extends StatelessWidget {
  const _FogExample({
    required this.title,
    required this.description,
    this.both = false,
    this.horizontal = false,
    this.custom = false,
    this.short = false,
  });
  final String title;
  final String description;
  final bool both;
  final bool horizontal;
  final bool custom;
  final bool short;

  @override
  Widget build(BuildContext context) {
    final colors = BrianTheme.of(context).colors;
    final color = custom
        ? colors.background.layerBasement
        : colors.background.layerDefault;
    final depth = horizontal ? 20.0 : (custom ? 40.0 : 80.0);
    final padding = horizontal
        ? const EdgeInsets.symmetric(horizontal: 20)
        : EdgeInsets.only(top: both ? 20 : 0, bottom: depth);
    final items = [
      for (var i = 1; i <= (short ? 1 : 12); i++)
        SizedBox(
          width: horizontal ? 150 : null,
          height: horizontal ? 100 : 56,
          child: Center(child: Text(horizontal ? '추천 컬렉션 $i' : '배송 안내 $i')),
        ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeading(title),
        Text(description),
        const SizedBox(height: BrianSpacing.x4),
        Surface(
          child: ColoredBox(
            color: color,
            child: SizedBox(
              height: horizontal ? 120 : (short ? 136 : 240),
              child: Stack(
                children: [
                  ScrollConfiguration(
                    behavior: const ScrollBehavior().copyWith(
                      dragDevices: PointerDeviceKind.values.toSet(),
                      scrollbars: false,
                    ),
                    child: SingleChildScrollView(
                      primary: false,
                      scrollDirection: horizontal
                          ? Axis.horizontal
                          : Axis.vertical,
                      padding: padding,
                      child: horizontal
                          ? Row(children: items)
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: items,
                            ),
                    ),
                  ),
                  if (both)
                    Positioned.fill(
                      child: Align(
                        alignment: horizontal
                            ? Alignment.centerLeft
                            : Alignment.topCenter,
                        child: BrianScrollFog(
                          placement: horizontal
                              ? BrianScrollFogPlacement.left
                              : BrianScrollFogPlacement.top,
                          color: color,
                        ),
                      ),
                    ),
                  Positioned.fill(
                    child: Align(
                      alignment: horizontal
                          ? Alignment.centerRight
                          : Alignment.bottomCenter,
                      child: BrianScrollFog(
                        placement: horizontal
                            ? BrianScrollFogPlacement.right
                            : BrianScrollFogPlacement.bottom,
                        extent: depth,
                        color: color,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: BrianSpacing.x4),
        CodeExample('''SizedBox(
  height: ${horizontal ? 120 : (short ? 136 : 240)},
  child: Stack(
    children: [
      SingleChildScrollView(
        scrollDirection: Axis.${horizontal ? 'horizontal' : 'vertical'},
        padding: ${horizontal ? 'const EdgeInsets.symmetric(horizontal: 20)' : 'const EdgeInsets.only(top: ${both ? 20 : 0}, bottom: ${depth.toInt()})'},
        child: ${horizontal ? 'Row(children: items)' : 'Column(children: items)'},
      ),${both ? '''
      Positioned.fill(
        child: Align(
          alignment: Alignment.${horizontal ? 'centerLeft' : 'topCenter'},
          child: BrianScrollFog(
            placement: BrianScrollFogPlacement.${horizontal ? 'left' : 'top'},
          ),
        ),
      ),''' : ''}
      Positioned.fill(
        child: Align(
          alignment: Alignment.${horizontal ? 'centerRight' : 'bottomCenter'},
          child: BrianScrollFog(
            placement: BrianScrollFogPlacement.${horizontal ? 'right' : 'bottom'},
            extent: ${depth.toInt()},${custom ? '\n            color: BrianTheme.of(context).colors.background.layerBasement,' : ''}
          ),
        ),
      ),
    ],
  ),
)'''),
      ],
    );
  }
}

class _SheetDemo extends StatelessWidget {
  const _SheetDemo();

  @override
  Widget build(BuildContext context) => Surface(
    child: BrianButton(
      onPressed: () => showBrianBottomSheet<void>(
        context: context,
        headerBuilder: (_) => const Text('배송 안내'),
        footerBuilder: (context) => BrianButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('확인'),
        ),
        builder: (_) => Column(
          children: [
            for (var i = 1; i <= 20; i++)
              SizedBox(height: 56, child: Text('배송 안내 $i')),
          ],
        ),
      ),
      child: const Text('고정 액션 예제 열기'),
    ),
  );
}
