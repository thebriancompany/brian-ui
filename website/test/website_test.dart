import 'package:brian_ui/brian_ui.dart';
import 'package:brian_ui_website/catalog.dart';
import 'package:brian_ui_website/main.dart';
import 'package:brian_ui_website/site_widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> openPage(
  WidgetTester tester,
  String path, {
  Size size = const Size(1280, 1000),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  tester.binding.platformDispatcher.defaultRouteNameTestValue = path;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.binding.platformDispatcher.clearDefaultRouteNameTestValue);
  await tester.runAsync(() async {
    if (path == '/') {
      await rootBundle.loadString('lib/examples/getting_started.dart');
    }
    final asset = pageForPath(path)?.asset;
    if (asset != null) {
      rootBundle.evict(asset);
      await rootBundle.loadString(asset);
    }
  });
  await tester.pumpWidget(const BrianDocsApp());
  await tester.pumpAndSettle();
  await tester.runAsync(() async {
    final asset = pageForPath(path)?.asset;
    if (asset != null) await rootBundle.loadString(asset);
  });
  await tester.pumpAndSettle();
}

Future<void> tapButton(WidgetTester tester, String label) async {
  final button = find.widgetWithText(BrianButton, label).first;
  await tester.ensureVisible(button);
  await tester.pumpAndSettle();
  await tester.tap(button);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('시작 페이지는 실행 테스트를 받는 예제 원문을 표시한다', (tester) async {
    await openPage(tester, '/');
    final source = await tester.runAsync(
      () => rootBundle.loadString('lib/examples/getting_started.dart'),
    );
    final example = tester
        .widgetList<CodeExample>(find.byType(CodeExample))
        .singleWhere((block) => block.filename == 'lib/main.dart');
    expect(example.code, source);
  });

  testWidgets('아코디언 옵션과 코드 및 실제 펼침이 일치한다', (tester) async {
    await openPage(tester, '/components/accordion');
    await tapButton(tester, 'separated');
    await tapButton(tester, 'large');
    await tapButton(tester, 'multiple');
    await tapButton(tester, '+ / −');
    await tester.pumpAndSettle();
    final accordion = tester.widget<BrianAccordion>(
      find.byType(BrianAccordion),
    );
    expect(accordion.variant, BrianAccordionVariant.separated);
    expect(accordion.size, BrianAccordionSize.large);
    expect(accordion.expansionMode, BrianAccordionExpansionMode.multiple);
    expect(accordion.children.first.indicatorBuilder, isNotNull);
    final code = tester
        .widget<CodeExample>(find.byType(CodeExample).first)
        .code;
    expect(code, contains('BrianAccordionVariant.separated'));
    expect(code, contains('BrianAccordionSize.large'));
    expect(code, contains('BrianAccordionExpansionMode.multiple'));
    expect(code, contains('indicatorBuilder:'));
    final title = find.text('배송 안내').first;
    await tester.ensureVisible(title);
    await tester.pumpAndSettle();
    await tester.tap(title);
    await tester.pumpAndSettle();
    expect(find.text('배송에는 2~3일이 걸립니다.'), findsOneWidget);
    expect(find.text('−'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('버튼 상태와 복사 코드가 실제 BrianButton에 함께 반영된다', (tester) async {
    await openPage(tester, '/components/button');
    final preview = find.byKey(const ValueKey('button-preview'));
    await tester.ensureVisible(preview);
    await tester.pump();
    await tester.tap(preview);
    await tester.pump();
    expect(find.text('실행 횟수: 1'), findsOneWidget);

    await tapButton(tester, 'brandOutline');
    await tapButton(tester, 'large');
    await tester.pumpAndSettle();
    final button = tester.widget<BrianButton>(preview);
    expect(button.variant, BrianButtonVariant.brandOutline);
    expect(button.size, BrianButtonSize.large);
    expect(
      tester.widget<CodeExample>(find.byType(CodeExample).first).code,
      contains('BrianButtonVariant.brandOutline'),
    );

    await tapButton(tester, '비활성화');
    await tester.pumpAndSettle();
    expect(tester.widget<BrianButton>(preview).onPressed, isNull);
    await tester.ensureVisible(preview);
    await tester.pump();
    await tester.tap(preview);
    await tester.pump();
    expect(find.text('실행 횟수: 1'), findsOneWidget);

    await tapButton(tester, '로딩');
    await tester.pump();
    expect(tester.widget<BrianButton>(preview).isLoading, isTrue);
    expect(
      tester.widget<CodeExample>(find.byType(CodeExample).first).code,
      contains('isLoading: true'),
    );
    await tester.ensureVisible(preview);
    await tester.pump();
    await tester.tap(preview);
    await tester.pump();
    expect(find.text('실행 횟수: 1'), findsOneWidget);
    await tester.ensureVisible(find.widgetWithText(BrianButton, '기본'));
    await tester.pump();
    await tester.tap(find.widgetWithText(BrianButton, '기본'));
    await tester.pumpAndSettle();

    String? copied;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.setData') {
          copied = (call.arguments as Map)['text'] as String;
        }
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );
    await tester.ensureVisible(find.text('코드 복사').first);
    await tester.tap(find.text('코드 복사').first);
    await tester.pumpAndSettle();
    expect(
      copied,
      tester.widget<CodeExample>(find.byType(CodeExample).first).code,
    );
    expect(find.text('복사 완료'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('메뉴 탐색과 테마 전환이 문서와 실제 토큰에 반영된다', (tester) async {
    await openPage(tester, '/');
    await tester.tap(find.text('Button 체험하기 →'));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('button-preview')), findsOneWidget);
    await tester.tap(find.text('다크 모드'));
    await tester.pumpAndSettle();
    final context = tester.element(
      find.byKey(const ValueKey('button-preview')),
    );
    expect(BrianTheme.of(context).brightness, Brightness.dark);
    expect(find.text('라이트 모드'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('좁은 화면에서 글자를 두 배로 확대해도 조작할 수 있다', (tester) async {
    tester.binding.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(
      tester.binding.platformDispatcher.clearTextScaleFactorTestValue,
    );
    await openPage(tester, '/components/button', size: const Size(360, 1000));
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('메뉴 · Button'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('다크 모드'));
    await tester.pumpAndSettle();
    expect(find.text('라이트 모드'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  for (final width in [360.0, 1280.0]) {
    for (final page in pages) {
      testWidgets('${page.path} · ${width.toInt()}px에서 문서와 예제가 표시된다', (
        tester,
      ) async {
        await openPage(tester, page.path, size: Size(width, 1000));
        expect(find.text('가이드를 불러오지 못했습니다. 페이지를 새로고침해 주세요.'), findsNothing);
        expect(find.text('가이드를 불러오는 중…'), findsNothing);
        expect(tester.takeException(), isNull);
      });
    }
  }

  testWidgets('좁은 화면 메뉴에서 이동하고 잘못된 URL에서 복구한다', (tester) async {
    await openPage(tester, '/missing', size: const Size(360, 800));
    expect(find.text('페이지를 찾을 수 없습니다'), findsOneWidget);
    await tester.tap(find.text('시작하기로 이동'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('메뉴 · Getting Started'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Button'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.ensureVisible(find.widgetWithText(BrianButton, 'Button'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(BrianButton, 'Button'));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('button-preview')), findsOneWidget);
    expect(find.text('메뉴 · Button'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
