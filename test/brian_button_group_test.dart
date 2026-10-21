import 'package:brian_ui/brian_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget host(
  BrianButtonGroup group, {
  BrianThemeData? theme,
  double width = 320,
  double scale = 1,
  TextDirection direction = TextDirection.ltr,
}) => WidgetsApp(
  color: const Color(0xFFFFFFFF),
  builder: (context, _) => BrianTheme(
    data: theme ?? BrianThemeData.light,
    child: MediaQuery(
      data: MediaQueryData(textScaler: TextScaler.linear(scale)),
      child: Directionality(
        textDirection: direction,
        child: Center(
          child: SizedBox(width: width, child: group),
        ),
      ),
    ),
  ),
);

BrianButtonGroup group({
  String primary = '확인',
  String? secondary = '취소',
  BrianButtonSize size = BrianButtonSize.medium,
}) => BrianButtonGroup(
  size: size,
  primaryAction: BrianButtonGroupAction(label: primary, onPressed: () {}),
  secondaryAction: secondary == null
      ? null
      : BrianButtonGroupAction(label: secondary, onPressed: () {}),
);

Rect rect(WidgetTester tester, String label) =>
    tester.getRect(find.widgetWithText(BrianButton, label));

void main() {
  for (final customPadding in [false, true]) {
    testWidgets('테마 ${customPadding ? "패딩" : "간격 토큰"}으로 줄바꿈을 판정한다', (
      tester,
    ) async {
      const control = BrianControlStyle(
        padding: EdgeInsetsDirectional.fromSTEB(90, 8, 50, 8),
      );
      final base = BrianThemeData.light;
      final themed = customPadding
          ? base.copyWith(
              buttons: const BrianButtonStyles(
                xsmall: control,
                small: control,
                medium: control,
                large: control,
              ),
            )
          : base.copyWith(
              spacing: base.spacing.copyWith(x3Point5: 70, x4: 70, x5: 70),
            );
      for (final size in BrianButtonSize.values) {
        for (final direction in TextDirection.values) {
          final item = group(primary: 'ABCD', secondary: 'EFGH', size: size);
          await tester.pumpWidget(
            host(item, theme: base, direction: direction),
          );
          expect(rect(tester, 'ABCD').top, rect(tester, 'EFGH').top);
          await tester.pumpWidget(
            host(item, theme: themed, direction: direction),
          );
          expect(rect(tester, 'ABCD').bottom + 8, rect(tester, 'EFGH').top);
          expect(rect(tester, 'ABCD').width, 320);
          await tester.pumpWidget(
            host(item, theme: themed, direction: direction, width: 600),
          );
          expect(rect(tester, 'ABCD').top, rect(tester, 'EFGH').top);
          expect(tester.takeException(), isNull);
        }
      }
    });
  }

  testWidgets('명시 패딩이 넓은 간격 토큰보다 우선한다', (tester) async {
    final base = BrianThemeData.light;
    final theme = base.copyWith(
      spacing: base.spacing.copyWith(x4: 70),
      buttons: const BrianButtonStyles(
        medium: BrianControlStyle(
          padding: EdgeInsetsDirectional.fromSTEB(6, 8, 10, 8),
        ),
      ),
    );
    await tester.pumpWidget(
      host(
        group(primary: 'ABCD', secondary: 'EFGH'),
        theme: theme,
      ),
    );
    expect(rect(tester, 'ABCD').top, rect(tester, 'EFGH').top);
    expect(tester.takeException(), isNull);
  });

  testWidgets('단일 액션은 전체 너비의 neutralSolid, 두 액션은 보조 weak와 주요 solid', (
    tester,
  ) async {
    await tester.pumpWidget(host(group(secondary: null)));
    expect(rect(tester, '확인').width, 320);
    expect(
      tester.widget<BrianButton>(find.byType(BrianButton)).variant,
      BrianButtonVariant.neutralSolid,
    );
    await tester.pumpWidget(host(group()));
    expect(rect(tester, '확인').width, 156);
    expect(rect(tester, '취소').width, 156);
    expect(rect(tester, '취소').right + 8, rect(tester, '확인').left);
    expect(
      tester
          .widget<BrianButton>(find.widgetWithText(BrianButton, '취소'))
          .variant,
      BrianButtonVariant.neutralWeak,
    );
  });

  testWidgets('어느 라벨이 길어도 세로로 바뀌고 너비가 늘어나면 가로로 돌아온다', (tester) async {
    const label = '변경 사항을 저장하고 계속 진행하기';
    for (final primaryLong in [true, false]) {
      final item = group(
        primary: primaryLong ? label : '확인',
        secondary: primaryLong ? '취소' : label,
      );
      await tester.pumpWidget(host(item));
      final primary = rect(tester, item.primaryAction.label);
      final secondary = rect(tester, item.secondaryAction!.label);
      expect(primary.bottom + 8, secondary.top);
      expect(primary.width, 320);
      expect(secondary.width, 320);
      await tester.pumpWidget(host(item, width: 800));
      expect(
        rect(tester, item.primaryAction.label).top,
        rect(tester, item.secondaryAction!.label).top,
      );
    }
  });

  testWidgets('줄바꿈·글자 확대·모든 크기·RTL을 판정한다', (tester) async {
    for (final size in BrianButtonSize.values) {
      await tester.pumpWidget(host(group(primary: '확인\n하기', size: size)));
      expect(rect(tester, '확인\n하기').bottom + 8, rect(tester, '취소').top);
      await tester.pumpWidget(host(group(size: size), width: 232, scale: 4));
      expect(rect(tester, '확인').bottom + 8, rect(tester, '취소').top);
      await tester.pumpWidget(
        host(group(size: size), direction: TextDirection.rtl),
      );
      expect(rect(tester, '확인').right + 8, rect(tester, '취소').left);
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('로딩은 크기를 유지하며 해당 버튼만 잠그고 variant를 재정의할 수 있다', (tester) async {
    var primaryCount = 0;
    var secondaryCount = 0;
    BrianButtonGroup item(bool loading) => BrianButtonGroup(
      primaryAction: BrianButtonGroupAction(
        label: '삭제',
        variant: BrianButtonVariant.criticalSolid,
        isLoading: loading,
        onPressed: () => primaryCount++,
      ),
      secondaryAction: BrianButtonGroupAction(
        label: '취소',
        onPressed: () => secondaryCount++,
      ),
    );
    await tester.pumpWidget(host(item(false)));
    final before = rect(tester, '삭제');
    await tester.pumpWidget(host(item(true)));
    expect(rect(tester, '삭제'), before);
    await tester.tap(find.text('삭제'));
    await tester.tap(find.text('취소'));
    expect(primaryCount, 0);
    expect(secondaryCount, 1);
    expect(
      tester
          .widget<BrianButton>(find.widgetWithText(BrianButton, '삭제'))
          .variant,
      BrianButtonVariant.criticalSolid,
    );
    await tester.pumpWidget(host(item(false)));
    await tester.tap(find.text('삭제'));
    expect(primaryCount, 1);
  });
}
