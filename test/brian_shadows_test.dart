import 'package:brian_ui/brian_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('기본 그림자는 정의된 수치와 두 모드의 공통값을 유지한다', () {
    const shadows = BrianShadows();
    final cases = [
      (shadows.s1, 1.0, 4.0, 0x14000000),
      (shadows.s2, 2.0, 10.0, 0x1A000000),
      (shadows.s3, 4.0, 16.0, 0x1F000000),
    ];
    for (final (shadow, dy, blur, argb) in cases) {
      expect(shadow.offset, Offset(0, dy));
      expect(shadow.blurRadius, blur);
      expect(shadow.spreadRadius, 0);
      expect(shadow.color.toARGB32(), argb);
      expect(shadow.blurStyle, BlurStyle.normal);
    }
    expect(BrianThemeData.light.shadows, shadows);
    expect(BrianThemeData.dark.shadows, shadows);
    expect(BrianThemeData(colors: BrianColors.light).shadows, shadows);
  });

  test('각 단계의 사용자 정의는 원본을 보존하고 값으로 비교된다', () {
    const base = BrianShadows();
    const replacement = BoxShadow(blurRadius: 20);
    final variants = [
      base.copyWith(s1: replacement),
      base.copyWith(s2: replacement),
      base.copyWith(s3: replacement),
    ];
    for (var i = 0; i < variants.length; i++) {
      final changed = variants[i];
      expect(changed, isNot(base));
      expect([changed.s1, changed.s2, changed.s3][i], replacement);
      expect(changed.copyWith(), changed);
      expect(changed.copyWith().hashCode, changed.hashCode);
      for (var j = 0; j < 3; j++) {
        if (j != i) {
          expect(
            [changed.s1, changed.s2, changed.s3][j],
            [base.s1, base.s2, base.s3][j],
          );
        }
      }
    }
    expect(base.s1.blurRadius, 4);
    expect(base.s2.blurRadius, 10);
    expect(base.s3.blurRadius, 16);
  });

  test('테마 보간은 모든 그림자 단계와 사용자 정의를 전달한다', () {
    const start = BrianShadows();
    const end = BrianShadows(
      s1: BoxShadow(
        color: Color(0x14000000),
        offset: Offset(4, 5),
        blurRadius: 8,
        spreadRadius: 4,
      ),
      s2: BoxShadow(
        color: Color(0x1A000000),
        offset: Offset(4, 6),
        blurRadius: 14,
        spreadRadius: 4,
      ),
      s3: BoxShadow(
        color: Color(0x1F000000),
        offset: Offset(4, 8),
        blurRadius: 20,
        spreadRadius: 4,
      ),
    );
    final a = BrianThemeData.light;
    final b = a.copyWith(shadows: end);
    expect(b.colors, same(a.colors));
    expect(b.typography, same(a.typography));
    expect(b.copyWith().shadows, end);
    expect(b.copyWith().hashCode, b.hashCode);
    expect(b, isNot(a));
    expect(start.lerp(end, 0), same(start));
    expect(start.lerp(end, 1), same(end));
    expect(a.lerp(b, 0), a);
    expect(a.lerp(b, 1), b);
    final mid = a.lerp(b, 0.5).shadows;
    final cases = [
      (mid.s1, const Offset(2, 3), 6.0, start.s1.color),
      (mid.s2, const Offset(2, 4), 12.0, start.s2.color),
      (mid.s3, const Offset(2, 6), 18.0, start.s3.color),
    ];
    for (final (shadow, offset, blur, color) in cases) {
      expect(shadow.offset, offset);
      expect(shadow.blurRadius, blur);
      expect(shadow.spreadRadius, 2);
      expect(shadow.color, color);
    }
  });

  testWidgets('그림자만 변경해도 구독 위젯의 장식이 갱신된다', (tester) async {
    var builds = 0;
    final child = Builder(
      builder: (context) {
        builds++;
        final theme = BrianTheme.of(context);
        return DecoratedBox(
          decoration: BoxDecoration(
            color: theme.colors.background.layerFloating,
            boxShadow: [theme.shadows.s2],
          ),
          child: const SizedBox(width: 160, height: 80),
        );
      },
    );
    final base = BrianThemeData.light;
    final custom = base.copyWith(
      shadows: base.shadows.copyWith(
        s2: base.shadows.s2.copyWith(blurRadius: 12),
      ),
    );
    await tester.pumpWidget(BrianTheme(data: base, child: child));
    await tester.pumpWidget(BrianTheme(data: custom, child: child));
    expect(builds, 2);
    final box = tester.widget<DecoratedBox>(find.byType(DecoratedBox));
    expect((box.decoration as BoxDecoration).boxShadow, [custom.shadows.s2]);
    await tester.pumpWidget(
      BrianTheme(
        data: custom.copyWith(shadows: custom.shadows.copyWith()),
        child: child,
      ),
    );
    expect(builds, 2);
    expect(tester.takeException(), isNull);
  });
}
