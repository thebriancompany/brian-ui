import 'package:brian_ui/brian_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'website_test.dart' show openPage, tapButton;

void main() {
  testWidgets('Callout 사례에서 전체 클릭·보조 동작·닫기·복원을 실행한다', (tester) async {
    await openPage(tester, '/components/callout');
    expect(find.text('Playground'), findsNothing);
    expect(find.byType(BrianCallout), findsNWidgets(11));
    final actionable = find.text('주문한 상품이 출발했어요. 배송 현황을 확인하세요.');
    await tester.ensureVisible(actionable);
    await tester.tap(actionable);
    await tester.pumpAndSettle();
    expect(find.text('배송 현황을 선택했습니다.'), findsOneWidget);
    await tapButton(tester, '보관 정책 알아보기');
    await tester.pumpAndSettle();
    expect(find.text('보관 정책을 선택했습니다.'), findsOneWidget);
    final close = find.byWidgetPredicate(
      (widget) => widget is BrianButton && widget.semanticLabel == '새 기능 안내 닫기',
    );
    await tester.ensureVisible(close);
    await tester.tap(close);
    await tester.pumpAndSettle();
    expect(find.text('새로운 검색 기능을 만나보세요.'), findsNothing);
    await tapButton(tester, '안내 다시 표시');
    await tester.pumpAndSettle();
    expect(find.text('새로운 검색 기능을 만나보세요.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('모바일 너비에서도 사례 페이지가 표시된다', (tester) async {
    await openPage(tester, '/components/callout', size: const Size(390, 844));
    expect(find.byType(BrianCallout), findsNWidgets(11));
    expect(tester.takeException(), isNull);
  });
}
