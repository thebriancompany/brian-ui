import 'package:brian_ui/brian_ui.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const typography = BrianTypography();

  test('모든 스케일은 정의된 크기와 줄 높이 및 세 굵기를 제공한다', () {
    const sizes = [11, 12, 13, 14, 16, 18, 20, 22, 24, 26, 28, 32, 40, 48];
    const heights = [15, 16, 18, 19, 22, 24, 27, 30, 32, 35, 38, 42, 52, 60];
    const weights = [FontWeight.w400, FontWeight.w500, FontWeight.w700];
    final scales = [
      [typography.t1Regular, typography.t1Medium, typography.t1Bold],
      [typography.t2Regular, typography.t2Medium, typography.t2Bold],
      [typography.t3Regular, typography.t3Medium, typography.t3Bold],
      [typography.t4Regular, typography.t4Medium, typography.t4Bold],
      [typography.t5Regular, typography.t5Medium, typography.t5Bold],
      [typography.t6Regular, typography.t6Medium, typography.t6Bold],
      [typography.t7Regular, typography.t7Medium, typography.t7Bold],
      [typography.t8Regular, typography.t8Medium, typography.t8Bold],
      [typography.t9Regular, typography.t9Medium, typography.t9Bold],
      [typography.t10Regular, typography.t10Medium, typography.t10Bold],
      [typography.t11Regular, typography.t11Medium, typography.t11Bold],
      [typography.t12Regular, typography.t12Medium, typography.t12Bold],
      [typography.t13Regular, typography.t13Medium, typography.t13Bold],
      [typography.t14Regular, typography.t14Medium, typography.t14Bold],
    ];
    for (var i = 0; i < scales.length; i++) {
      for (var w = 0; w < weights.length; w++) {
        final style = scales[i][w];
        expect(style.fontSize, sizes[i]);
        expect(style.height, heights[i] / sizes[i]);
        expect(style.fontWeight, weights[w]);
        expect(style.fontFamily, isNull);
        expect(style.color, isNull);
        expect(style.inherit, isTrue);
      }
    }
  });

  test('역할별 스타일은 제목과 긴 본문의 기본 계약을 따른다', () {
    expect(typography.screenTitle, typography.t10Bold);
    expect(typography.articleBody.fontSize, 16);
    expect(typography.articleBody.height, 24 / 16);
    expect(typography.articleBody.fontWeight, FontWeight.w400);
    expect(typography.t5Regular.height, 22 / 16);
    expect(BrianThemeData.light.typography, BrianThemeData.dark.typography);
  });

  test('스타일 교체는 다른 스타일을 보존하며 값 비교와 보간에 반영된다', () {
    final changed = typography.copyWith(
      t5Regular: typography.t5Regular.copyWith(fontSize: 20),
      articleBody: typography.articleBody.copyWith(fontSize: 20),
    );
    expect(changed.screenTitle, typography.screenTitle);
    expect(
      typography.copyWith(t5Regular: changed.t5Regular).articleBody,
      typography.articleBody,
    );
    expect(changed, isNot(typography));
    expect(changed.copyWith(), changed);
    expect(changed.copyWith().hashCode, changed.hashCode);
    expect(identical(typography.lerp(changed, 0), typography), isTrue);
    expect(identical(typography.lerp(changed, 1), changed), isTrue);
    expect(typography.lerp(changed, 0.5).articleBody.fontSize, 18);
    final base = BrianThemeData.light;
    final theme = base.copyWith(typography: changed);
    expect(theme.colors, base.colors);
    expect(theme, isNot(base));
    expect(base.lerp(theme, 0.5).typography.articleBody.fontSize, 18);
  });

  testWidgets('타이포그래피만 바뀌어도 구독 위젯을 갱신하고 같은 값이면 유지한다', (tester) async {
    var builds = 0;
    final seen = <BrianTypography>[];
    final child = Builder(
      builder: (context) {
        builds++;
        seen.add(BrianTheme.of(context).typography);
        return const SizedBox.shrink();
      },
    );
    final base = BrianThemeData.light;
    await tester.pumpWidget(BrianTheme(data: base, child: child));
    await tester.pumpWidget(
      BrianTheme(
        data: base.copyWith(typography: base.typography.copyWith()),
        child: child,
      ),
    );
    expect(builds, 1);
    final changed = base.typography.copyWith(
      screenTitle: base.typography.screenTitle.copyWith(fontSize: 30),
    );
    await tester.pumpWidget(
      BrianTheme(
        data: base.copyWith(typography: changed),
        child: child,
      ),
    );
    expect(builds, 2);
    expect(seen.last, changed);
  });

  testWidgets('Text는 앱의 글꼴과 색상을 상속하고 MediaQuery 확대를 따른다', (tester) async {
    Widget content(double scale) => Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: MediaQueryData(textScaler: TextScaler.linear(scale)),
        child: DefaultTextStyle(
          style: const TextStyle(
            fontFamily: 'AppFont',
            color: Color(0xFF123456),
          ),
          child: Center(child: Text('본문', style: typography.articleBody)),
        ),
      ),
    );
    await tester.pumpWidget(content(1));
    final normal = tester.getSize(find.byType(RichText));
    await tester.pumpWidget(content(2));
    final paragraph = tester.renderObject<RenderParagraph>(
      find.byType(RichText),
    );
    expect(paragraph.text.style!.fontFamily, 'AppFont');
    expect(paragraph.text.style!.color, const Color(0xFF123456));
    expect(paragraph.text.style!.fontSize, 16);
    expect(paragraph.textScaler.scale(16), 32);
    expect(
      tester.getSize(find.byType(RichText)).height,
      greaterThan(normal.height),
    );
  });
}
