import 'package:brian_ui/brian_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('테마 변경은 같은 자식 인스턴스의 구독 위젯도 갱신한다', (tester) async {
    var builds = 0;
    final seen = <BrianThemeData>[];
    final child = Builder(
      builder: (context) {
        builds++;
        seen.add(BrianTheme.of(context));
        return const SizedBox.shrink();
      },
    );
    await tester.pumpWidget(
      BrianTheme(data: BrianThemeData.light, child: child),
    );
    expect(builds, 1);
    await tester.pumpWidget(
      BrianTheme(
        data: BrianThemeData.light.copyWith(
          colors: BrianColors.light.copyWith(),
        ),
        child: child,
      ),
    );
    expect(builds, 1);
    await tester.pumpWidget(
      BrianTheme(data: BrianThemeData.dark, child: child),
    );
    expect(builds, 2);
    expect(seen.last, BrianThemeData.dark);
  });

  testWidgets('지역 테마는 해당 하위에만 적용된다', (tester) async {
    final seen = <BrianThemeData>[];
    Widget reader() => Builder(
      builder: (context) {
        seen.add(BrianTheme.of(context));
        return const SizedBox.shrink();
      },
    );
    await tester.pumpWidget(
      BrianTheme(
        data: BrianThemeData.light,
        child: Column(
          children: [
            reader(),
            BrianTheme(data: BrianThemeData.dark, child: reader()),
            reader(),
          ],
        ),
      ),
    );
    expect(seen, [
      BrianThemeData.light,
      BrianThemeData.dark,
      BrianThemeData.light,
    ]);
  });

  testWidgets('테마가 없으면 nullable 조회와 오류 조회를 구분한다', (tester) async {
    await tester.pumpWidget(
      Builder(
        builder: (context) {
          expect(BrianTheme.maybeOf(context), isNull);
          expect(() => BrianTheme.of(context), throwsA(isA<FlutterError>()));
          return const SizedBox.shrink();
        },
      ),
    );
  });

  testWidgets('캡처한 지역 테마는 다른 트리 위치에도 전달된다', (tester) async {
    late Widget captured;
    BrianThemeData? seen;
    await tester.pumpWidget(
      BrianTheme(
        data: BrianThemeData.dark,
        child: Builder(
          builder: (context) {
            captured = InheritedTheme.captureAll(
              context,
              Builder(
                builder: (context) {
                  seen = BrianTheme.of(context);
                  return const SizedBox.shrink();
                },
              ),
            );
            return const SizedBox.shrink();
          },
        ),
      ),
    );
    await tester.pumpWidget(
      BrianTheme(data: BrianThemeData.light, child: captured),
    );
    expect(seen, BrianThemeData.dark);
  });

  testWidgets('WidgetsApp에서 시스템 모드 변경을 구독한다', (tester) async {
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.light;
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
    BrianThemeData? seen;
    await tester.pumpWidget(
      WidgetsApp(
        color: BrianStaticColors.white,
        builder: (context, child) => BrianTheme(
          data: BrianThemeData.forBrightness(
            MediaQuery.platformBrightnessOf(context),
          ),
          child: Builder(
            builder: (context) {
              seen = BrianTheme.of(context);
              return ColoredBox(color: seen!.colors.background.layerDefault);
            },
          ),
        ),
      ),
    );
    expect(seen, BrianThemeData.light);
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
    await tester.pump();
    expect(seen, BrianThemeData.dark);
    expect(tester.takeException(), isNull);
  });

  test('테마 데이터는 색상 보간과 밝기를 함께 전달한다', () {
    final a = BrianThemeData.light;
    final b = BrianThemeData.dark;
    expect(a.lerp(b, 0), a);
    expect(a.lerp(b, 1), b);
    expect(a.lerp(b, 0.5).brightness, Brightness.dark);
    expect(a.copyWith().hashCode, a.hashCode);
  });
}
