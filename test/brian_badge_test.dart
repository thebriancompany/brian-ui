import 'package:brian_ui/brian_ui.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget host(Widget child, {BrianThemeData? theme, double scale = 1}) =>
    Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: MediaQueryData(textScaler: TextScaler.linear(scale)),
        child: BrianTheme(
          data: theme ?? BrianThemeData.light,
          child: DefaultTextStyle(
            style: const TextStyle(fontFamily: 'Test'),
            child: Center(child: child),
          ),
        ),
      ),
    );

void main() {
  testWidgets('말줄임과 무관하게 전체 라벨을 읽고 액션을 노출하지 않는다', (tester) async {
    final semantics = tester.ensureSemantics();
    const label = '관리자의 최종 승인을 기다리는 중';
    await tester.pumpWidget(host(const BrianBadge(label: label, maxWidth: 80)));
    final text = tester.widget<Text>(find.text(label));
    expect(text.overflow, TextOverflow.ellipsis);
    expect(text.maxLines, 1);
    expect(tester.getSize(find.byType(BrianBadge)).width, 80);
    final node = tester.getSemantics(find.byType(BrianBadge));
    expect(node.label, label);
    expect(node.getSemanticsData().hasAction(SemanticsAction.tap), isFalse);
    expect(node.flagsCollection.isButton, isFalse);
    expect(
      find.descendant(
        of: find.byType(BrianBadge),
        matching: find.byType(Focus),
      ),
      findsNothing,
    );
    semantics.dispose();
  });

  testWidgets('크기와 스타일에 맞추며 글자 확대 시 높이가 늘어난다', (tester) async {
    for (final size in BrianBadgeSize.values) {
      for (final variant in BrianBadgeVariant.values) {
        final badge = BrianBadge(label: '완료', size: size, variant: variant);
        await tester.pumpWidget(host(badge));
        final normal = tester.getSize(find.byType(BrianBadge));
        expect(normal.height, size == BrianBadgeSize.medium ? 20 : 24);
        await tester.pumpWidget(host(badge, scale: 2));
        expect(
          tester.getSize(find.byType(BrianBadge)).height,
          greaterThan(normal.height),
        );
        expect(tester.takeException(), isNull);
      }
    }
  });

  testWidgets('라이트·다크의 모든 의미 색상과 스타일이 테마를 따른다', (tester) async {
    for (final theme in [BrianThemeData.light, BrianThemeData.dark]) {
      final bg = theme.colors.background;
      final fg = theme.colors.foreground;
      final stroke = theme.colors.stroke;
      final expected = [
        (
          bg.neutralSolid,
          bg.neutralWeak,
          fg.onNeutralSolid,
          fg.neutral,
          stroke.neutralMuted,
        ),
        (
          bg.brandSolid,
          bg.brandWeak,
          fg.onBrandSolid,
          fg.brandContrast,
          stroke.brandWeak,
        ),
        (
          bg.informativeSolid,
          bg.informativeWeak,
          fg.onInformativeSolid,
          fg.informativeContrast,
          stroke.informativeWeak,
        ),
        (
          bg.positiveSolid,
          bg.positiveWeak,
          fg.onPositiveSolid,
          fg.positiveContrast,
          stroke.positiveWeak,
        ),
        (
          bg.warningSolid,
          bg.warningWeak,
          fg.onWarningSolid,
          fg.warningContrast,
          stroke.warningWeak,
        ),
        (
          bg.criticalSolid,
          bg.criticalWeak,
          fg.onCriticalSolid,
          fg.criticalContrast,
          stroke.criticalWeak,
        ),
      ];
      for (final tone in BrianBadgeTone.values) {
        final (solid, weak, onSolid, foreground, border) = expected[tone.index];
        for (final variant in BrianBadgeVariant.values) {
          await tester.pumpWidget(
            host(
              BrianBadge(label: '상태', tone: tone, variant: variant),
              theme: theme,
            ),
          );
          final container = tester.widget<DecoratedBox>(
            find.descendant(
              of: find.byType(BrianBadge),
              matching: find.byType(DecoratedBox),
            ),
          );
          final decoration = container.decoration as ShapeDecoration;
          expect(decoration.color, switch (variant) {
            BrianBadgeVariant.solid => solid,
            BrianBadgeVariant.weak => weak,
            BrianBadgeVariant.outline => bg.transparent,
          });
          expect(
            tester.widget<Text>(find.text('상태')).style!.color,
            variant == BrianBadgeVariant.solid ? onSolid : foreground,
          );
          if (variant == BrianBadgeVariant.outline) {
            expect(
              (decoration.shape as RoundedRectangleBorder).side.color,
              border,
            );
          }
        }
      }
    }
  });

  testWidgets('사용자 정의 테마와 부모 너비 제약을 따른다', (tester) async {
    final theme = BrianThemeData.light;
    const custom = Color(0xFF123456);
    await tester.pumpWidget(
      host(
        const SizedBox(
          width: 60,
          child: BrianBadge(label: '전체 라벨 확인', maxWidth: double.infinity),
        ),
        theme: theme.copyWith(
          colors: theme.colors.copyWith(
            foreground: theme.colors.foreground.copyWith(neutral: custom),
          ),
          typography: theme.typography.copyWith(
            t2Bold: const TextStyle(fontSize: 24, height: 1.5),
          ),
        ),
      ),
    );
    expect(tester.getSize(find.byType(BrianBadge)).width, 60);
    final style = tester.widget<Text>(find.text('전체 라벨 확인')).style!;
    expect(style.color, custom);
    expect(style.fontSize, 24);
    expect(style.fontFamily, 'Test');
    expect(tester.takeException(), isNull);
  });
}
