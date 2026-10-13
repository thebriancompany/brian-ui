import 'package:brian_ui/brian_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'website_test.dart' show openPage, tapButton;

void main() {
  for (final width in [390.0, 1280.0]) {
    testWidgets('ScrollFog 사례와 고정 액션을 조작한다: $width', (tester) async {
      await openPage(tester, '/components/scroll-fog', size: Size(width, 900));
      expect(find.byType(BrianScrollFog), findsNWidgets(7));
      final fog = find.byType(BrianScrollFog).first;
      await tester.ensureVisible(fog);
      await tester.pumpAndSettle();
      final view = find
          .byType(SingleChildScrollView)
          .evaluate()
          .map((element) => element.widget)
          .whereType<SingleChildScrollView>()
          .firstWhere(
            (view) => view.padding == const EdgeInsets.only(bottom: 80),
          );
      final scroll = find.descendant(
        of: find.byWidget(view),
        matching: find.byType(Scrollable),
      );
      final position = tester.state<ScrollableState>(scroll).position;
      await tester.dragFrom(tester.getCenter(fog), const Offset(0, -140));
      await tester.pumpAndSettle();
      expect(position.pixels, greaterThan(0));
      await tapButton(tester, '고정 액션 예제 열기');
      await tester.pumpAndSettle();
      expect(find.byType(BrianBottomSheet), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(BrianBottomSheet),
          matching: find.byType(BrianScrollFog),
        ),
        findsOneWidget,
      );
      await tester.tap(find.text('확인'));
      await tester.pumpAndSettle();
      expect(find.byType(BrianBottomSheet), findsNothing);
      expect(tester.takeException(), isNull);
    });
  }
}
