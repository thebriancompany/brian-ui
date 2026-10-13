import 'package:brian_ui/brian_ui.dart';
import 'package:brian_ui_website/site_widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'website_test.dart' show openPage, tapButton;

void main() {
  testWidgets('사용 사례별 설명·버튼·코드는 실행 결과와 일치한다', (tester) async {
    await openPage(tester, '/components/alert-dialog');
    expect(find.text('Playground'), findsNothing);
    for (final heading in ['기본', '버튼 2개', '버튼 2개 길게', '브랜드 솔리드 버튼']) {
      final button = find.widgetWithText(BrianButton, '$heading 예제 열기');
      final section = find.ancestor(
        of: button,
        matching: find.byWidgetPredicate(
          (widget) => widget.runtimeType.toString() == '_DialogExample',
        ),
      );
      final code = tester
          .widget<CodeExample>(
            find.descendant(of: section, matching: find.byType(CodeExample)),
          )
          .code;
      await tapButton(tester, '$heading 예제 열기');
      await tester.pumpAndSettle();
      final dialog = tester.widget<BrianAlertDialog<bool>>(
        find.byType(BrianAlertDialog<bool>),
      );
      expect(code, contains("title: '${dialog.title}'"));
      expect(code, contains("label: '${dialog.primaryAction.label}'"));
      if (heading == '기본') {
        expect(dialog.secondaryAction, isNull);
        expect(code, isNot(contains('secondaryAction:')));
      } else {
        expect(dialog.secondaryAction, isNotNull);
        expect(code, contains("label: '${dialog.secondaryAction!.label}'"));
      }
      if (heading == '버튼 2개 길게') {
        final primary = find.widgetWithText(
          BrianButton,
          dialog.primaryAction.label,
        );
        final secondary = find.widgetWithText(
          BrianButton,
          dialog.secondaryAction!.label,
        );
        expect(
          tester.getRect(primary).bottom,
          lessThan(tester.getRect(secondary).top),
        );
      }
      if (heading == '브랜드 솔리드 버튼') {
        expect(dialog.primaryAction.variant, BrianButtonVariant.brandSolid);
        expect(code, contains('variant: BrianButtonVariant.brandSolid'));
      }
      await tester.tap(
        find.descendant(
          of: find.byType(BrianAlertDialog<bool>),
          matching: find.widgetWithText(
            BrianButton,
            dialog.primaryAction.label,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(BrianAlertDialog<bool>), findsNothing);
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('확인과 취소는 각각 3초 동안 로딩한 뒤 닫힌다', (tester) async {
    await openPage(tester, '/components/alert-dialog');
    for (final label in ['확인', '취소']) {
      await tapButton(tester, '로딩 후 닫기 예제 열기');
      await tester.pumpAndSettle();
      final button = find.widgetWithText(BrianButton, label);
      await tester.tap(button);
      await tester.pump();
      expect(tester.widget<BrianButton>(button).isLoading, isTrue);
      await tester.pump(const Duration(milliseconds: 2999));
      expect(find.byType(BrianAlertDialog<bool>), findsOneWidget);
      expect(tester.widget<BrianButton>(button).isLoading, isTrue);
      await tester.pump(const Duration(milliseconds: 1));
      await tester.pumpAndSettle();
      expect(find.byType(BrianAlertDialog<bool>), findsNothing);
      expect(find.text('$label 선택'), findsOneWidget);
    }
  });
}
