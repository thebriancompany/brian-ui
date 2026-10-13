import 'package:brian_ui/brian_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget host(
  Widget child, {
  BrianThemeData? theme,
  TextDirection direction = TextDirection.ltr,
}) => Directionality(
  textDirection: direction,
  child: BrianTheme(
    data: theme ?? BrianThemeData.light,
    child: Center(child: SizedBox(width: 240, child: child)),
  ),
);

void main() {
  testWidgets('가로선은 너비를 채우며 추가 여백 없이 1 논리 픽셀이다', (tester) async {
    await tester.pumpWidget(host(const BrianDivider()));
    expect(tester.getSize(find.byType(BrianDivider)), const Size(240, 1));
  });

  testWidgets('세로선은 제한된 높이와 콘텐츠의 고유 높이를 따른다', (tester) async {
    await tester.pumpWidget(
      host(
        const SizedBox(
          height: 48,
          child: Row(children: [BrianDivider(axis: Axis.vertical)]),
        ),
      ),
    );
    expect(tester.getSize(find.byType(BrianDivider)), const Size(1, 48));
    await tester.pumpWidget(
      host(
        const IntrinsicHeight(
          child: Row(
            children: [
              SizedBox(width: 80, height: 72),
              BrianDivider(axis: Axis.vertical),
            ],
          ),
        ),
      ),
    );
    expect(tester.getSize(find.byType(BrianDivider)), const Size(1, 72));
    expect(tester.takeException(), isNull);
  });

  testWidgets('같은 위젯의 두 톤이 테마 변경과 사용자 정의 역할 색상을 구독한다', (tester) async {
    for (final tone in BrianDividerTone.values) {
      final divider = BrianDivider(tone: tone);
      final custom = BrianThemeData.light.copyWith(
        colors: BrianThemeData.light.colors.copyWith(
          stroke: BrianThemeData.light.colors.stroke.copyWith(
            neutralMuted: const Color(0xFF112233),
            neutralSubtle: const Color(0xFF445566),
          ),
        ),
      );
      for (final theme in [BrianThemeData.light, BrianThemeData.dark, custom]) {
        await tester.pumpWidget(host(divider, theme: theme));
        final line = tester.widget<ColoredBox>(
          find.descendant(
            of: find.byType(BrianDivider),
            matching: find.byType(ColoredBox),
          ),
        );
        expect(
          line.color,
          tone == BrianDividerTone.neutralMuted
              ? theme.colors.stroke.neutralMuted
              : theme.colors.stroke.neutralSubtle,
        );
      }
    }
  });

  testWidgets('명시한 색상은 톤과 테마보다 우선한다', (tester) async {
    for (final theme in [BrianThemeData.light, BrianThemeData.dark]) {
      await tester.pumpWidget(
        host(
          const BrianDivider(
            tone: BrianDividerTone.neutralSubtle,
            color: Color(0xFF123456),
          ),
          theme: theme,
        ),
      );
      expect(
        tester.widget<ColoredBox>(find.byType(ColoredBox)).color,
        const Color(0xFF123456),
      );
    }
  });

  testWidgets('방향성 들여쓰기는 RTL에서 반전된다', (tester) async {
    const frame = ValueKey('frame');
    for (final direction in TextDirection.values) {
      await tester.pumpWidget(
        host(
          const SizedBox(
            key: frame,
            child: Padding(
              padding: EdgeInsetsDirectional.only(start: 56, end: 16),
              child: BrianDivider(),
            ),
          ),
          direction: direction,
        ),
      );
      expect(tester.getSize(find.byType(BrianDivider)), const Size(168, 1));
      expect(
        tester.getTopLeft(find.byType(BrianDivider)).dx -
            tester.getTopLeft(find.byKey(frame)).dx,
        direction == TextDirection.ltr ? 56 : 16,
      );
    }
  });

  testWidgets('선 뒤의 입력을 막거나 접근성 노드를 추가하지 않는다', (tester) async {
    final semantics = tester.ensureSemantics();
    var tapped = false;
    await tester.pumpWidget(
      host(
        SizedBox(
          height: 48,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => tapped = true,
                  child: Semantics(label: '배경 동작'),
                ),
              ),
              const BrianDivider(),
            ],
          ),
        ),
      ),
    );
    await tester.tapAt(tester.getCenter(find.byType(BrianDivider)));
    expect(tapped, isTrue);
    expect(find.bySemanticsLabel('배경 동작'), findsOneWidget);
    await tester.pumpWidget(host(const BrianDivider()));
    expect(tester.getSemantics(find.byType(BrianDivider)), matchesSemantics());
    expect(
      find.descendant(
        of: find.byType(BrianDivider),
        matching: find.byType(Focus),
      ),
      findsNothing,
    );
    semantics.dispose();
  });
}
