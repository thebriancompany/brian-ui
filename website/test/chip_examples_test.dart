import 'package:brian_ui/brian_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'website_test.dart' show openPage, tapButton;

Future<void> tapChip(WidgetTester tester, String label) async {
  final chip = find.widgetWithText(BrianChip, label);
  await tester.ensureVisible(chip);
  await tester.pumpAndSettle();
  await tester.tap(chip);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('선택·필터 초기화·추천·입력값 삭제와 복원을 실행한다', (tester) async {
    await openPage(tester, '/components/chip');
    await tapChip(tester, '가구');
    expect(
      tester.widget<BrianChip>(find.widgetWithText(BrianChip, '가구')).selected,
      isTrue,
    );
    expect(
      tester.widget<BrianChip>(find.widgetWithText(BrianChip, '전체')).selected,
      isFalse,
    );
    await tapChip(tester, '요리');
    expect(
      tester.widget<BrianChip>(find.widgetWithText(BrianChip, '요리')).selected,
      isTrue,
    );
    await tapChip(tester, '무료 배송');
    expect(find.text('적용 조건: 무료 배송'), findsOneWidget);
    await tapButton(tester, '필터 초기화');
    await tester.pumpAndSettle();
    expect(find.text('모든 상품을 표시합니다.'), findsOneWidget);
    await tapChip(tester, '캠핑 의자');
    expect(find.text('검색: 캠핑 의자'), findsOneWidget);
    final delete = find.byWidgetPredicate(
      (w) => w is BrianButton && w.semanticLabel == '민지 삭제',
    );
    await tester.ensureVisible(delete);
    await tester.pumpAndSettle();
    await tester.tap(delete);
    await tester.pumpAndSettle();
    expect(find.widgetWithText(BrianChip, '민지'), findsNothing);
    await tapButton(tester, '수신자 복원');
    await tester.pumpAndSettle();
    expect(find.widgetWithText(BrianChip, '민지'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('스타일 예시 라벨은 선택 변경을 반영한다', (tester) async {
    await openPage(tester, '/components/chip');
    for (final variant in BrianChipVariant.values) {
      final chip = find.widgetWithText(BrianChip, '${variant.name} · 기본');
      await tester.ensureVisible(chip);
      await tester.tap(chip);
      await tester.pumpAndSettle();
      expect(
        find.widgetWithText(BrianChip, '${variant.name} · 기본'),
        findsNothing,
      );
      final selected = find.widgetWithText(BrianChip, '${variant.name} · 선택');
      expect(selected, findsNWidgets(2));
      expect(
        tester
            .widgetList<BrianChip>(selected)
            .every((chip) => chip.selected == true),
        isTrue,
      );
    }
  });

  testWidgets('390px 화면에서도 예시 페이지에 overflow가 없다', (tester) async {
    await openPage(tester, '/components/chip', size: const Size(390, 844));
    expect(find.byType(BrianChip), findsWidgets);
    expect(tester.takeException(), isNull);
  });
}
