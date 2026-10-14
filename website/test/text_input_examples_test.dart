import 'package:brian_ui/brian_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'website_test.dart' show openPage, tapButton;

Finder input(int index) => find.descendant(
  of: find.byType(BrianTextInput).at(index),
  matching: find.byType(EditableText),
);

void main() {
  testWidgets('입력 페이지의 지우기·금액·비밀번호 전환을 체험한다', (tester) async {
    await openPage(tester, '/components/text-input');
    await tester.ensureVisible(input(0));
    await tester.enterText(input(0), '검색 내용');
    await tester.pump();
    final clear = find.byWidgetPredicate(
      (widget) => widget is BrianButton && widget.semanticLabel == '입력 지우기',
    );
    await tester.ensureVisible(clear);
    await tester.pumpAndSettle();
    await tester.tap(clear);
    await tester.pump();
    expect(tester.widget<EditableText>(input(0)).controller.text, isEmpty);
    await tester.ensureVisible(input(2));
    await tester.enterText(input(2), '12abc34');
    await tester.pump();
    expect(tester.widget<EditableText>(input(2)).controller.text, '1234');
    await tapButton(tester, '표시');
    await tester.pump();
    expect(tester.widget<EditableText>(input(3)).obscureText, isFalse);
    await tapButton(tester, '숨기기');
    await tester.pump();
    expect(tester.widget<EditableText>(input(3)).obscureText, isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('모바일에서 입력과 여러 줄 페이지를 표시한다', (tester) async {
    await openPage(
      tester,
      '/components/text-input',
      size: const Size(390, 844),
    );
    expect(find.byType(BrianTextInput), findsNWidgets(7));
    expect(tester.takeException(), isNull);
  });

  testWidgets('여러 줄 페이지의 자동·제한·고정 높이 입력을 제공한다', (tester) async {
    await openPage(tester, '/components/text-area', size: const Size(390, 844));
    expect(find.byType(BrianTextArea), findsNWidgets(6));
    final editor = find.descendant(
      of: find.byType(BrianTextArea).first,
      matching: find.byType(EditableText),
    );
    await tester.ensureVisible(editor);
    await tester.enterText(editor, '첫 줄\n둘째 줄\n셋째 줄\n넷째 줄');
    await tester.pump();
    expect(
      tester.widget<EditableText>(editor).controller.text,
      contains('넷째 줄'),
    );
    expect(tester.takeException(), isNull);
  });
}
