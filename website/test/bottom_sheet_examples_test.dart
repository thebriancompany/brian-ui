import 'package:brian_ui/brian_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'website_test.dart' show openPage, tapButton;

void main() {
  testWidgets('모든 사용 사례를 좁은 화면에서 열고 닫을 수 있다', (tester) async {
    await openPage(
      tester,
      '/components/bottom-sheet',
      size: const Size(390, 844),
    );
    for (final heading in [
      '빠른 선택',
      '버튼 2개',
      '버튼 2개 길게',
      '긴 콘텐츠',
      '핸들 없이',
      '긴 콘텐츠 · 핸들 없이',
      '드래그 닫기 끄기',
      '배경 탭 닫기 끄기',
    ]) {
      await tapButton(tester, '$heading 예제 열기');
      await tester.pumpAndSettle();
      expect(find.byType(BrianBottomSheet), findsOneWidget);
      expect(tester.takeException(), isNull);
      final groupFinder = find.descendant(
        of: find.byType(BrianBottomSheet),
        matching: find.byType(BrianButtonGroup),
      );
      final group = tester.widget<BrianButtonGroup>(groupFinder);
      final primary = find.descendant(
        of: groupFinder,
        matching: find.widgetWithText(BrianButton, group.primaryAction.label),
      );
      expect(
        tester.widget<BrianButton>(primary).variant,
        BrianButtonVariant.neutralSolid,
      );
      if (heading == '버튼 2개' || heading == '버튼 2개 길게') {
        final secondary = find.descendant(
          of: groupFinder,
          matching: find.widgetWithText(
            BrianButton,
            group.secondaryAction!.label,
          ),
        );
        expect(
          tester.widget<BrianButton>(secondary).variant,
          BrianButtonVariant.neutralWeak,
        );
        if (heading == '버튼 2개') {
          expect(tester.getRect(primary).top, tester.getRect(secondary).top);
        } else {
          expect(
            tester.getRect(primary).bottom,
            lessThan(tester.getRect(secondary).top),
          );
        }
        await tester.tap(primary);
        await tester.pumpAndSettle();
        expect(find.byType(BrianBottomSheet), findsNothing);
        expect(find.text(group.primaryAction.label), findsOneWidget);
        continue;
      }
      expect(group.secondaryAction, isNull);
      if (heading == '배경 탭 닫기 끄기') {
        await tester.tapAt(const Offset(5, 5));
        await tester.pumpAndSettle();
        expect(find.byType(BrianBottomSheet), findsOneWidget);
      }
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.byType(BrianBottomSheet), findsNothing);
    }
  });
}
