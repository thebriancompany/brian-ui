import 'package:brian_ui/brian_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget host(Widget child, {BrianThemeData? theme}) => BrianTheme(
  data: theme ?? BrianThemeData.light,
  child: Directionality(
    textDirection: TextDirection.rtl,
    child: Center(child: SizedBox(width: 240, height: 200, child: child)),
  ),
);

LinearGradient gradient(WidgetTester tester) =>
    (tester
                    .widget<DecoratedBox>(
                      find.descendant(
                        of: find.byType(BrianScrollFog),
                        matching: find.byType(DecoratedBox),
                      ),
                    )
                    .decoration
                as BoxDecoration)
            .gradient!
        as LinearGradient;

void main() {
  for (final (placement, edge, size) in [
    (BrianScrollFogPlacement.top, Alignment.topCenter, const Size(240, 20)),
    (
      BrianScrollFogPlacement.bottom,
      Alignment.bottomCenter,
      const Size(240, 80),
    ),
    (BrianScrollFogPlacement.left, Alignment.centerLeft, const Size(20, 200)),
    (BrianScrollFogPlacement.right, Alignment.centerRight, const Size(20, 200)),
  ]) {
    testWidgets('$placement: RTL에서도 물리 방향과 기본 깊이를 유지한다', (tester) async {
      await tester.pumpWidget(
        host(Align(child: BrianScrollFog(placement: placement))),
      );
      expect(tester.getSize(find.byType(BrianScrollFog)), size);
      expect(gradient(tester).begin, edge);
      expect(gradient(tester).end, -edge);
    });
  }

  testWidgets('테마 변경과 사용자 색상은 투명한 끝까지 같은 RGB를 유지한다', (tester) async {
    for (final theme in [BrianThemeData.light, BrianThemeData.dark]) {
      await tester.pumpWidget(
        host(const Align(child: BrianScrollFog()), theme: theme),
      );
      final surface = theme.colors.background.layerDefault;
      expect(gradient(tester).colors, [surface, surface.withValues(alpha: 0)]);
    }
    const custom = Color(0xFF125634);
    await tester.pumpWidget(
      host(const Align(child: BrianScrollFog(color: custom, extent: 40))),
    );
    expect(gradient(tester).colors, [custom, custom.withValues(alpha: 0)]);
    expect(tester.getSize(find.byType(BrianScrollFog)).height, 40);
  });

  testWidgets('작은 뷰포트는 깊이를 제한하고 Fog는 터치와 스크롤을 통과시킨다', (tester) async {
    var taps = 0;
    final controller = ScrollController();
    addTearDown(controller.dispose);
    final semantics = tester.ensureSemantics();

    await tester.pumpWidget(
      host(
        SizedBox(
          height: 200,
          child: Stack(
            children: [
              SingleChildScrollView(
                controller: controller,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () => taps++,
                      child: const SizedBox(
                        height: 40,
                        width: 240,
                        child: Text('항목'),
                      ),
                    ),
                    const SizedBox(height: 400),
                  ],
                ),
              ),
              const Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: BrianScrollFog(extent: 400),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    expect(tester.getSize(find.byType(BrianScrollFog)).height, 200);
    await tester.tap(find.text('항목'));
    expect(taps, 1);
    expect(tester.getSemantics(find.text('항목')).label, '항목');
    semantics.dispose();
    await tester.dragFrom(
      tester.getCenter(find.byType(BrianScrollFog)),
      const Offset(0, -100),
    );
    await tester.pumpAndSettle();
    expect(controller.offset, greaterThan(0));
    expect(find.byType(BrianScrollFog), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  test('깊이는 유한한 0 이상의 값이어야 한다', () {
    for (final value in [-1.0, double.infinity, double.nan]) {
      expect(() => BrianScrollFog(extent: value), throwsAssertionError);
    }
    expect(() => const BrianScrollFog(extent: 0), returnsNormally);
  });
}
