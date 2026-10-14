import 'package:brian_ui/brian_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'website_test.dart' show openPage, tapButton;

void main() {
  testWidgets('필수 동의·부분 선택·전체 선택·저장을 실제로 조작한다', (tester) async {
    await openPage(tester, '/components/checkbox');
    expect(find.text('Playground'), findsNothing);
    Finder checkbox(String label) => find.widgetWithText(BrianCheckbox, label);
    Future<void> toggle(String label) async {
      final target = checkbox(label);
      await tester.ensureVisible(target);
      await tester.pumpAndSettle();
      await tester.tap(target);
      await tester.pumpAndSettle();
    }

    expect(
      tester
          .widget<BrianButton>(find.widgetWithText(BrianButton, '계속하기'))
          .onPressed,
      isNull,
    );
    await toggle('이용약관에 동의합니다 (필수)');
    await tapButton(tester, '계속하기');
    await tester.pumpAndSettle();
    expect(find.text('동의를 확인했습니다.'), findsOneWidget);
    final parent = checkbox('알림 채널 전체 선택');
    expect(tester.widget<BrianCheckbox>(parent).value, isNull);
    await toggle('알림 채널 전체 선택');
    for (final label in ['앱 알림', '이메일', '문자 메시지']) {
      expect(tester.widget<BrianCheckbox>(checkbox(label)).value, isTrue);
    }
    await toggle('이메일');
    expect(tester.widget<BrianCheckbox>(parent).value, isNull);
    await toggle('알림 채널 전체 선택');
    await toggle('알림 채널 전체 선택');
    expect(tester.widget<BrianCheckbox>(parent).value, isFalse);
    await toggle('디자인');
    expect(find.text('아직 저장하지 않았습니다.'), findsOneWidget);
    await tapButton(tester, '관심 항목 저장');
    await tester.pumpAndSettle();
    expect(find.text('저장한 관심 항목: 디자인, 개발'), findsOneWidget);
    await toggle('개발');
    expect(find.text('저장한 관심 항목: 디자인, 개발'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('모바일에서 모든 사례와 다크 모드를 표시한다', (tester) async {
    await openPage(tester, '/components/checkbox', size: const Size(390, 844));
    expect(find.byType(BrianCheckbox), findsNWidgets(18));
    await tapButton(tester, '메뉴 · Checkbox');
    await tester.pumpAndSettle();
    await tapButton(tester, '다크 모드');
    await tester.pumpAndSettle();
    await tapButton(tester, '메뉴 닫기');
    await tester.pumpAndSettle();
    expect(
      BrianTheme.of(tester.element(find.byType(BrianCheckbox).first))
          .brightness,
      Brightness.dark,
    );
    final last = find.text('변경할 수 없는 선택 항목');
    await tester.ensureVisible(last);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
