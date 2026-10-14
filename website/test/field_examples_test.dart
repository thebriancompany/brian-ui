import 'package:brian_ui/brian_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'website_test.dart' show openPage, tapButton;

void main() {
  testWidgets('입력·검증·글자 수·그룹·도움말 사례가 동작한다', (tester) async {
    await openPage(tester, '/components/field');
    expect(find.byType(BrianField), findsNWidgets(6));
    expect(find.byType(BrianTextInput), findsNWidgets(4));
    expect(find.byType(BrianTextArea), findsOneWidget);
    await tapButton(tester, '닉네임 저장');
    await tester.pumpAndSettle();
    expect(find.text('닉네임을 입력해 주세요.'), findsOneWidget);
    final nickname = find.descendant(
      of: find.byType(BrianField).at(1),
      matching: find.byType(EditableText),
    );
    await tester.ensureVisible(nickname);
    await tester.enterText(nickname, '브라이언');
    await tapButton(tester, '닉네임 저장');
    await tester.pumpAndSettle();
    expect(find.text('닉네임을 입력해 주세요.'), findsNothing);
    expect(find.text('닉네임을 저장했습니다.'), findsOneWidget);
    final bio = find.descendant(
      of: find.byType(BrianField).at(2),
      matching: find.byType(EditableText),
    );
    await tester.ensureVisible(bio);
    await tester.enterText(bio, '👨‍👩‍👧‍👦');
    await tester.pump();
    expect(find.text('1 / 100'), findsOneWidget);
    await tester.enterText(bio, '가' * 101);
    await tester.pump();
    expect(find.text('100자 이내로 줄여 주세요.'), findsOneWidget);
    final checkbox = find.byType(BrianCheckbox).first;
    await tester.ensureVisible(checkbox);
    await tester.tap(checkbox);
    await tester.pump();
    expect(
      tester.widget<BrianCheckbox>(find.byType(BrianCheckbox).first).value,
      isTrue,
    );
    await tapButton(tester, '작성 도움말');
    await tester.pumpAndSettle();
    expect(find.text('공동 현관 출입 방법을 적어 주세요.'), findsOneWidget);
    await tapButton(tester, '도움말 접기');
    await tester.pumpAndSettle();
    expect(find.text('공동 현관 출입 방법을 적어 주세요.'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('모바일 너비에서 모든 사례를 표시한다', (tester) async {
    await openPage(tester, '/components/field', size: const Size(390, 844));
    expect(find.byType(BrianField), findsNWidgets(6));
    expect(find.byType(BrianTextInput), findsNWidgets(4));
    expect(find.byType(BrianTextArea), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
