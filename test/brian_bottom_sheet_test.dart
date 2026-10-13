import 'package:brian_ui/brian_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> openSheet(
  WidgetTester tester, {
  WidgetBuilder? builder,
  bool long = false,
  bool handle = true,
  bool drag = true,
  bool slots = false,
  BrianThemeData? theme,
  bool barrierDismissible = true,
  ValueChanged<String?>? result,
}) async {
  await tester.pumpWidget(
    WidgetsApp(
      color: const Color(0xFFFFFFFF),
      builder: (context, child) =>
          BrianTheme(data: theme ?? BrianThemeData.light, child: child!),
      onGenerateRoute: (_) => PageRouteBuilder<void>(
        pageBuilder: (context, _, _) => Center(
          child: BrianButton(
            onPressed: () async {
              final value = await showBrianBottomSheet<String>(
                context: context,
                showHandle: handle,
                enableDrag: drag,
                barrierDismissible: barrierDismissible,
                headerBuilder: slots ? (_) => const Text('고정 헤더') : null,
                footerBuilder: slots
                    ? (context) => BrianButton(
                        onPressed: () => Navigator.of(context).pop('푸터'),
                        child: const Text('고정 푸터'),
                      )
                    : null,
                builder:
                    builder ??
                    (context) => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('시트 제목'),
                        if (long)
                          for (var i = 0; i < 40; i++)
                            SizedBox(height: 60, child: Text('항목 $i')),
                        BrianButton(
                          onPressed: () => Navigator.of(context).pop('선택'),
                          child: const Text('선택'),
                        ),
                      ],
                    ),
              );
              result?.call(value);
            },
            child: const Text('열기'),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('열기'));
  await tester.pumpAndSettle();
}

Finder get scroll => find.descendant(
  of: find.byType(BrianBottomSheet),
  matching: find.byType(Scrollable),
);

void main() {
  for (final long in [false, true]) {
    testWidgets('푸터 Fog는 짧은 본문과 스크롤 끝에서도 마지막 항목을 가리지 않는다: $long', (
      tester,
    ) async {
      await openSheet(tester, long: long, slots: true);
      expect(find.byType(BrianScrollFog), findsOneWidget);
      final position = tester.state<ScrollableState>(scroll).position;
      final footer = tester.getRect(find.text('고정 푸터'));
      position.jumpTo(position.maxScrollExtent);
      await tester.pumpAndSettle();
      final fog = tester.getRect(find.byType(BrianScrollFog));
      expect(
        tester.getRect(find.text('선택')).bottom,
        lessThanOrEqualTo(fog.top),
      );
      expect(fog.bottom, lessThanOrEqualTo(footer.top));
      expect(tester.getRect(find.text('고정 푸터')), footer);
      await tester.tap(find.text('선택'));
      await tester.pumpAndSettle();
      expect(find.byType(BrianBottomSheet), findsNothing);
    });
  }

  testWidgets('푸터가 없으면 Fog를 추가하지 않는다', (tester) async {
    await openSheet(tester, long: true);
    expect(find.byType(BrianScrollFog), findsNothing);
  });

  for (final width in [390.0, 800.0]) {
    for (final slots in [false, true]) {
      testWidgets('짧은 콘텐츠와 고정 영역 $slots: 화면 너비 $width에서 가용 너비를 채운다', (
        tester,
      ) async {
        tester.view.physicalSize = Size(width, 600);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        await openSheet(
          tester,
          handle: false,
          slots: slots,
          builder: (_) => const Text('내용'),
        );
        final rect = tester.getRect(find.byType(BrianBottomSheet));
        expect(rect.width, width < 640 ? width : 640);
        expect(rect.center.dx, width / 2);
        expect(rect.bottom, 600);
        expect(rect.height, lessThan(300));
        expect(tester.takeException(), isNull);
      });
    }
  }

  for (final handle in [true, false]) {
    testWidgets('핸들 $handle: 본문 드래그로 닫기', (tester) async {
      await openSheet(tester, handle: handle);
      await tester.drag(find.text('시트 제목'), const Offset(0, 180));
      await tester.pumpAndSettle();
      expect(find.byType(BrianBottomSheet), findsNothing);
    });
  }

  for (final slots in [false, true]) {
    testWidgets('고정 영역 $slots: 본문 스크롤에서 시트 드래그로 이어진다', (tester) async {
      await openSheet(tester, long: true, slots: slots);
      final state = tester.state<ScrollableState>(scroll);
      state.position.jumpTo(150);
      await tester.pump();
      final gesture = await tester.startGesture(const Offset(400, 120));
      await gesture.moveBy(const Offset(0, 100));
      await tester.pump();
      expect(state.position.pixels, greaterThan(0));
      expect(tester.getTopLeft(find.byType(BrianBottomSheet)).dy, 0);
      await gesture.moveBy(const Offset(0, 260));
      await tester.pump();
      expect(state.position.pixels, 0);
      // 내부 표면의 실제 이동으로 동일 제스처의 인계를 확인합니다.
      expect(tester.getTopLeft(find.text('시트 제목')).dy, greaterThan(150));
      await gesture.up();
      await tester.pumpAndSettle();
      expect(find.byType(BrianBottomSheet), findsNothing);
    });
  }

  testWidgets('짧은 드래그는 복귀하고 방향을 되돌리면 콘텐츠가 스크롤된다', (tester) async {
    await openSheet(tester, long: true);
    final gesture = await tester.startGesture(const Offset(400, 100));
    await gesture.moveBy(const Offset(0, 80));
    await tester.pump();
    await gesture.moveBy(const Offset(0, -180));
    await tester.pump();
    expect(
      tester.state<ScrollableState>(scroll).position.pixels,
      greaterThan(0),
    );
    await gesture.up();
    await tester.pumpAndSettle();
    expect(find.byType(BrianBottomSheet), findsOneWidget);
    tester.state<ScrollableState>(scroll).position.jumpTo(0);
    await tester.dragFrom(const Offset(400, 100), const Offset(0, 50));
    await tester.pumpAndSettle();
    expect(find.byType(BrianBottomSheet), findsOneWidget);
    expect(tester.getTopLeft(find.text('시트 제목')).dy, lessThan(100));
  });

  testWidgets('드래그 비활성화와 휠은 시트를 닫지 않는다', (tester) async {
    await openSheet(tester, long: true, drag: false);
    await tester.dragFrom(const Offset(400, 100), const Offset(0, 400));
    await tester.pumpAndSettle();
    expect(find.byType(BrianBottomSheet), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.byType(BrianBottomSheet), findsNothing);
    await tester.tap(find.text('열기'));
    await tester.pumpAndSettle();
    await tester.sendEventToBinding(
      const PointerScrollEvent(
        position: Offset(400, 100),
        scrollDelta: Offset(0, -500),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(BrianBottomSheet), findsOneWidget);
  });

  testWidgets('마우스로 버튼 영역을 드래그해도 선택 없이 닫힌다', (tester) async {
    String? result;
    await openSheet(tester, result: (value) => result = value);
    await tester.drag(
      find.text('선택'),
      const Offset(0, 180),
      kind: PointerDeviceKind.mouse,
    );
    await tester.pumpAndSettle();
    expect(find.byType(BrianBottomSheet), findsNothing);
    expect(result, isNull);
  });

  testWidgets('드래그가 활성화되어도 휠은 닫지 않는다', (tester) async {
    await openSheet(tester, long: true);
    await tester.sendEventToBinding(
      const PointerScrollEvent(
        position: Offset(400, 100),
        scrollDelta: Offset(0, -500),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(BrianBottomSheet), findsOneWidget);
  });

  testWidgets('헤더와 푸터는 고정되고 본문만 스크롤된다', (tester) async {
    final semantics = tester.ensureSemantics();
    await openSheet(tester, long: true, slots: true);
    final header = tester.getRect(find.text('고정 헤더'));
    final footer = tester.getRect(find.text('고정 푸터'));
    expect(tester.getSemantics(find.text('고정 푸터')).label, '고정 푸터');
    semantics.dispose();
    final body = tester.getRect(scroll);
    expect(body.top, greaterThan(header.bottom));
    expect(body.bottom, lessThan(footer.top));
    await tester.dragFrom(body.center, const Offset(0, -220));
    await tester.pumpAndSettle();
    expect(
      tester.state<ScrollableState>(scroll).position.pixels,
      greaterThan(0),
    );
    expect(tester.getRect(find.text('고정 헤더')), header);
    expect(tester.getRect(find.text('고정 푸터')), footer);
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('고정 푸터'));
    await tester.pumpAndSettle();
    expect(find.byType(BrianBottomSheet), findsNothing);
  });

  for (final target in ['고정 헤더', '고정 푸터']) {
    testWidgets('$target 드래그는 본문 최상단에서만 시트를 움직인다', (tester) async {
      await openSheet(tester, long: true, slots: true, handle: false);
      final position = tester.state<ScrollableState>(scroll).position;
      position.jumpTo(180);
      await tester.pump();
      final before = tester.getRect(find.text('고정 헤더'));
      final gesture = await tester.startGesture(
        tester.getCenter(find.text(target)),
      );
      await gesture.moveBy(const Offset(0, 220));
      await tester.pump();
      expect(position.pixels, 180);
      expect(tester.getRect(find.text('고정 헤더')), before);
      await gesture.up();
      await tester.pumpAndSettle();
      expect(find.byType(BrianBottomSheet), findsOneWidget);
      position.jumpTo(0);
      await tester.pump();
      await tester.drag(find.text(target), const Offset(0, 220));
      await tester.pumpAndSettle();
      expect(find.byType(BrianBottomSheet), findsNothing);
    });
  }

  testWidgets('배경 탭 차단은 드래그 및 푸터 버튼 닫기와 독립적이다', (tester) async {
    String? result;
    await openSheet(
      tester,
      slots: true,
      barrierDismissible: false,
      result: (value) => result = value,
    );
    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();
    expect(find.byType(BrianBottomSheet), findsOneWidget);
    await tester.drag(find.text('고정 헤더'), const Offset(0, 180));
    await tester.pumpAndSettle();
    expect(find.byType(BrianBottomSheet), findsNothing);
    await tester.tap(find.text('열기'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('고정 푸터'));
    await tester.pumpAndSettle();
    expect(result, '푸터');
    await tester.tap(find.text('열기'));
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(10, 10));
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.byType(BrianBottomSheet), findsNothing);
  });

  testWidgets('좁은 화면과 키보드에서도 고정 영역과 본문이 화면 안에 들어간다', (tester) async {
    tester.view.physicalSize = const Size(390, 600);
    tester.view.devicePixelRatio = 1;
    tester.view.viewInsets = const FakeViewPadding(bottom: 160);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetViewInsets);
    for (final theme in [BrianThemeData.light, BrianThemeData.dark]) {
      await openSheet(tester, long: true, slots: true, theme: theme);
      final header = tester.getRect(find.text('고정 헤더'));
      final footer = tester.getRect(find.text('고정 푸터'));
      expect(header.top, greaterThanOrEqualTo(0));
      expect(footer.bottom, lessThanOrEqualTo(440));
      expect(tester.getSize(scroll).height, greaterThan(0));
      await tester.drag(scroll, const Offset(0, -120));
      await tester.pumpAndSettle();
      expect(tester.getRect(find.text('고정 헤더')), header);
      expect(tester.getRect(find.text('고정 푸터')), footer);
      expect(tester.takeException(), isNull);
      await tester.tap(find.text('고정 푸터'));
      await tester.pumpAndSettle();
    }
  });

  testWidgets('본문 드래그가 취소되면 닫기 임계값을 넘어도 복귀한다', (tester) async {
    await openSheet(tester, long: true);
    final before = tester.getTopLeft(find.text('시트 제목'));
    final gesture = await tester.startGesture(const Offset(400, 120));
    await gesture.moveBy(const Offset(0, 250));
    await tester.pump();
    await gesture.cancel();
    await tester.pumpAndSettle();
    expect(find.byType(BrianBottomSheet), findsOneWidget);
    expect(tester.getTopLeft(find.text('시트 제목')), before);
  });

  testWidgets('표면만 사용하면 Esc가 호스트 페이지를 닫지 않는다', (tester) async {
    final navigator = GlobalKey<NavigatorState>();
    await tester.pumpWidget(
      WidgetsApp(
        navigatorKey: navigator,
        color: const Color(0xFFFFFFFF),
        builder: (context, child) =>
            BrianTheme(data: BrianThemeData.light, child: child!),
        onGenerateRoute: (_) =>
            PageRouteBuilder<void>(pageBuilder: (_, _, _) => const Text('시작')),
      ),
    );
    navigator.currentState!.push(
      PageRouteBuilder<void>(
        pageBuilder: (_, _, _) => const Center(
          child: BrianBottomSheet(
            child: Focus(autofocus: true, child: Text('독립 표면')),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.text('독립 표면'), findsOneWidget);
  });

  testWidgets('선택 결과 반환 및 바깥 터치 닫기', (tester) async {
    String? result;
    await openSheet(tester, result: (value) => result = value);
    await tester.tap(find.text('선택'));
    await tester.pumpAndSettle();
    expect(result, '선택');
    await tester.tap(find.text('열기'));
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();
    expect(find.byType(BrianBottomSheet), findsNothing);
    expect(result, isNull);
  });
}
