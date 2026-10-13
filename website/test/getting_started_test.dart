import 'package:brian_ui/brian_ui.dart';
import 'package:brian_ui_website/examples/getting_started.dart' as example;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('시작 예제가 실행되고 시스템 테마 변경을 반영한다', (tester) async {
    final platform = tester.binding.platformDispatcher;
    addTearDown(platform.clearPlatformBrightnessTestValue);
    platform.platformBrightnessTestValue = Brightness.light;

    example.main();
    await tester.pumpAndSettle();
    final button = find.byType(BrianButton);
    expect(button, findsOneWidget);
    expect(find.text('시작하기'), findsOneWidget);
    expect(BrianTheme.of(tester.element(button)).brightness, Brightness.light);
    await tester.tap(button);
    await tester.pumpAndSettle();

    platform.platformBrightnessTestValue = Brightness.dark;
    await tester.pumpAndSettle();
    expect(BrianTheme.of(tester.element(button)).brightness, Brightness.dark);
    expect(tester.takeException(), isNull);
  });
}
