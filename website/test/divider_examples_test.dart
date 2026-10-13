import 'package:brian_ui/brian_ui.dart';
import 'package:brian_ui_website/divider_examples.dart';
import 'package:brian_ui_website/site_widgets.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'website_test.dart' show openPage, tapButton;

void main() {
  testWidgets('메뉴 경로에서 사용 사례와 가이드를 열고 액션을 실행한다', (tester) async {
    await openPage(tester, '/components/divider');
    expect(find.byType(DividerExamples), findsOneWidget);
    expect(find.byType(BrianDivider), findsNWidgets(7));
    expect(find.byType(CodeExample), findsWidgets);
    expect(find.text('Playground'), findsNothing);
    await tapButton(tester, '다음 단계');
    await tester.pumpAndSettle();
    expect(find.text('다음 단계를 선택했습니다.'), findsOneWidget);
    await tapButton(tester, '다시 확인');
    await tester.pumpAndSettle();
    expect(find.text('다음 단계를 선택했습니다.'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('좁은 화면·글자 확대·양방향·라이트와 다크에서 배치한다', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    for (final theme in [BrianThemeData.light, BrianThemeData.dark]) {
      for (final direction in TextDirection.values) {
        await tester.pumpWidget(
          Directionality(
            textDirection: direction,
            child: MediaQuery(
              data: const MediaQueryData(textScaler: TextScaler.linear(2)),
              child: BrianTheme(
                data: theme,
                child: DefaultTextStyle(
                  style: theme.typography.t4Regular,
                  child: const SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: DividerExamples(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        expect(tester.takeException(), isNull);
      }
    }
  });
}
