import 'package:brian_ui/brian_ui.dart';
import 'package:brian_ui_website/side_navigation_examples.dart';
import 'package:brian_ui_website/site_widgets.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'website_test.dart' show openPage;

void main() {
  for (final width in [390.0, 1280.0]) {
    testWidgets('다섯 사례와 페이지 선택을 제공한다: $width', (tester) async {
      await openPage(
        tester,
        '/components/side-navigation',
        size: Size(width, 900),
      );
      final examples = find.byType(SideNavigationExamples);
      expect(
        find.descendant(
          of: examples,
          matching: find.byType(BrianSideNavigation),
        ),
        findsNWidgets(5),
      );
      final inbox = find
          .descendant(of: examples, matching: find.text('받은 편지함'))
          .first;
      await Scrollable.ensureVisible(tester.element(inbox), alignment: 0.5);
      await tester.pumpAndSettle();
      await tester.tap(inbox);
      await tester.pumpAndSettle();
      expect(find.text('현재 페이지: 받은 편지함'), findsOneWidget);
      final codes = tester
          .widgetList<CodeExample>(
            find.descendant(of: examples, matching: find.byType(CodeExample)),
          )
          .map((c) => c.code)
          .toList();
      expect(codes.length, 5);
      expect(codes[1], contains("value: 'archive'"));
      expect(codes[2], contains('onCollapsedChanged:'));
      expect(codes[3], contains('BrianSideNavigationVariant.transparent'));
      expect(codes[4], contains("value: 'project-16'"));
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('중간 너비는 접힌 메뉴로 시작하고 수동으로 펼칠 수 있다', (tester) async {
    await openPage(tester, '/components/button', size: const Size(900, 900));
    expect(
      tester
          .widget<BrianSideNavigation>(find.byType(BrianSideNavigation))
          .collapsed,
      isTrue,
    );
    final expand = find.byWidgetPredicate(
      (w) => w is BrianButton && w.semanticLabel == '메뉴 펼치기',
    );
    await tester.tap(expand);
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<BrianSideNavigation>(find.byType(BrianSideNavigation))
          .collapsed,
      isFalse,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('서비스명·계층 메뉴·테마 전환을 사이드바에 배치한다', (tester) async {
    await openPage(tester, '/components/button');
    final navFinder = find.byType(BrianSideNavigation);
    final nav = tester.widget<BrianSideNavigation>(navFinder);
    for (final group in nav.groups) {
      expect(group.label, isNot(group.label!.toUpperCase()));
      expect(group.items.length, 1);
      final parent = group.items.single;
      expect(parent.label, group.label);
      expect(parent.icon, isNotNull);
      expect(nav.initialExpandedValues, contains(parent.value));
      expect(parent.children.every((child) => child.icon == null), isTrue);
    }
    final brand = find.byType(SiteServiceName);
    final toggle = find.byWidgetPredicate(
      (w) => w is BrianButton && w.semanticLabel == '메뉴 접기',
    );
    expect(tester.getCenter(brand).dy, closeTo(tester.getCenter(toggle).dy, 1));
    final themeButton = find.descendant(
      of: navFinder,
      matching: find.text('다크 모드'),
    );
    final footerY = tester.getCenter(themeButton).dy;
    final foundations = find.byWidgetPredicate(
      (w) => w is BrianButton && w.semanticLabel == 'Foundations',
    );
    await tester.tap(foundations);
    await tester.pumpAndSettle();
    expect(find.text('Color'), findsNothing);
    await tester.tap(themeButton);
    await tester.pumpAndSettle();
    expect(find.text('Color'), findsNothing);
    expect(find.text('라이트 모드'), findsOneWidget);
    expect(tester.getCenter(find.text('라이트 모드')).dy, footerY);
    await tester.tap(toggle);
    await tester.pumpAndSettle();
    expect(find.byType(SiteServiceName), findsNothing);
    final compactTheme = find.byWidgetPredicate(
      (w) => w is BrianButton && w.semanticLabel == '라이트 모드',
    );
    await tester.tap(compactTheme);
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<BrianSideNavigation>(find.byType(BrianSideNavigation))
          .collapsed,
      isTrue,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('실제 사이트 탐색 메뉴가 새 컴포넌트로 페이지를 전환한다', (tester) async {
    await openPage(tester, '/components/button');
    final navigation = find.byType(BrianSideNavigation);
    expect(navigation, findsOneWidget);
    final link = find.descendant(
      of: navigation,
      matching: find.text('Side Navigation'),
    );
    await tester.scrollUntilVisible(
      link,
      200,
      scrollable: find.descendant(
        of: navigation,
        matching: find.byType(Scrollable),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(link);
    await tester.pumpAndSettle();
    expect(find.byType(SideNavigationExamples), findsOneWidget);
    expect(
      tester
          .widget<BrianSideNavigation>(find.byType(BrianSideNavigation).first)
          .selectedValue,
      '/components/side-navigation',
    );
  });
}
