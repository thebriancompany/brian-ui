import 'package:brian_ui/brian_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget host(
  Widget child, {
  BrianThemeData? theme,
  double scale = 1,
  TextDirection direction = TextDirection.ltr,
}) => WidgetsApp(
  color: const Color(0xFFFFFFFF),
  builder: (context, _) => BrianTheme(
    data: theme ?? BrianThemeData.light,
    child: MediaQuery(
      data: MediaQueryData(textScaler: TextScaler.linear(scale)),
      child: Directionality(
        textDirection: direction,
        child: Center(child: SizedBox(width: 320, child: child)),
      ),
    ),
  ),
);

BoxDecoration decoration(WidgetTester tester) =>
    tester
            .widgetList<Container>(
              find.descendant(
                of: find.byType(BrianCallout),
                matching: find.byType(Container),
              ),
            )
            .first
            .decoration!
        as BoxDecoration;

void main() {
  testWidgets('모든 톤은 모드별 역할 색상을 사용하고 눌림을 복원한다', (tester) async {
    for (final theme in [BrianThemeData.light, BrianThemeData.dark]) {
      final f = theme.colors.foreground;
      final b = theme.colors.background;
      final pairs = [
        (f.neutral, b.neutralWeak, b.neutralWeakPressed),
        (f.informativeContrast, b.informativeWeak, b.informativeWeakPressed),
        (f.criticalContrast, b.criticalWeak, b.criticalWeakPressed),
        (f.positiveContrast, b.positiveWeak, b.positiveWeakPressed),
        (f.warningContrast, b.warningWeak, b.warningWeakPressed),
      ];
      for (final tone in BrianCalloutTone.values) {
        await tester.pumpWidget(
          host(
            BrianCallout(
              tone: tone,
              description: const Text('안내'),
              onPressed: () {},
            ),
            theme: theme,
          ),
        );
        final (foreground, background, pressed) = pairs[tone.index];
        expect(decoration(tester).color, background);
        final style = DefaultTextStyle.of(tester.element(find.text('안내')))
            .style;
        expect(style.color, foreground);
        for (final surface in [background, pressed]) {
          final a = foreground.computeLuminance();
          final b = surface.computeLuminance();
          final ratio = a > b ? (a + .05) / (b + .05) : (b + .05) / (a + .05);
          expect(
            ratio,
            greaterThanOrEqualTo(4.5),
            reason: '${theme.brightness} $tone',
          );
        }
        final gesture = await tester.startGesture(
          tester.getCenter(find.text('안내')),
        );
        await tester.pump(const Duration(milliseconds: 150));
        expect(decoration(tester).color, pressed);
        await gesture.cancel();
        await tester.pump();
        expect(decoration(tester).color, background);
      }
    }
  });

  testWidgets('전체 버튼은 탭과 Enter·Space를 한 번씩 실행한다', (tester) async {
    var calls = 0;
    final focus = FocusNode();
    addTearDown(focus.dispose);
    await tester.pumpWidget(
      host(
        BrianCallout(
          description: const Text('배송 확인'),
          focusNode: focus,
          onPressed: () => calls++,
        ),
      ),
    );
    await tester.tap(find.text('배송 확인'));
    expect(calls, 1);
    focus.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    expect(calls, 3);
    final semantics = tester.ensureSemantics();
    expect(
      tester.getSemantics(find.byType(BrianCallout)),
      matchesSemantics(
        label: '배송 확인',
        isButton: true,
        hasTapAction: true,
        hasFocusAction: true,
        isFocusable: true,
        isFocused: true,
      ),
    );
    semantics.dispose();
  });

  testWidgets('닫기는 요청만 전달하고 보조 동작은 독립적으로 실행된다', (tester) async {
    var dismissed = 0;
    var action = 0;
    await tester.pumpWidget(
      host(
        BrianCallout(
          description: const Text('안내'),
          onDismiss: () => dismissed++,
          dismissLabel: '공지 닫기',
          action: BrianButton(
            onPressed: () => action++,
            child: const Text('자세히'),
          ),
        ),
      ),
    );
    await tester.tap(find.bySemanticsLabel('공지 닫기'));
    expect(dismissed, 1);
    expect(find.text('안내'), findsOneWidget);
    await tester.tap(find.text('자세히'));
    expect(action, 1);
    expect(dismissed, 1);
  });

  testWidgets('커스텀 아이콘은 테마를 상속하고 입력·접근성에서 제외된다', (tester) async {
    var tapped = false;
    const key = ValueKey('custom');
    await tester.pumpWidget(
      host(
        BrianCallout(
          tone: BrianCalloutTone.warning,
          icon: GestureDetector(
            onTap: () => tapped = true,
            child: const Text('장식', key: key),
          ),
          description: const Text('주의'),
        ),
      ),
    );
    expect(IconTheme.of(tester.element(find.byKey(key))).size, 20);
    expect(
      IconTheme.of(tester.element(find.byKey(key))).color,
      BrianThemeData.light.colors.foreground.warningContrast,
    );
    await tester.tap(find.byKey(key), warnIfMissed: false);
    expect(tapped, isFalse);
    final semantics = tester.ensureSemantics();
    expect(find.bySemanticsLabel('장식'), findsNothing);
    semantics.dispose();
    await tester.pumpWidget(
      host(
        const BrianCallout(
          showIcon: false,
          icon: Text('장식', key: key),
          description: Text('주의'),
        ),
      ),
    );
    expect(find.byKey(key), findsNothing);
  });

  testWidgets('좁은 영역의 확대된 긴 본문은 RTL에서도 잘리지 않는다', (tester) async {
    for (final direction in TextDirection.values) {
      await tester.pumpWidget(
        host(
          BrianCallout(
            title: const Text('안내'),
            description: const Text(
              '긴 안내 문장을 여러 줄에 걸쳐 표시합니다. 내용을 끝까지 확인해 주세요.',
            ),
            onDismiss: () {},
          ),
          scale: 2,
          direction: direction,
        ),
      );
      expect(tester.takeException(), isNull);
      expect(
        tester.getSize(find.byType(BrianCallout)).height,
        greaterThan(100),
      );
    }
  });

  testWidgets('앱의 글꼴을 상속하면서 본문 줄 수 제한은 상속하지 않는다', (tester) async {
    await tester.pumpWidget(
      host(
        const DefaultTextStyle(
          style: TextStyle(
            fontFamily: 'AppFont',
            fontFamilyFallback: ['FallbackFont'],
          ),
          maxLines: 1,
          child: BrianCallout(title: Text('제목'), description: Text('본문')),
        ),
      ),
    );
    for (final label in ['제목', '본문']) {
      final defaults = DefaultTextStyle.of(tester.element(find.text(label)));
      expect(defaults.style.fontFamily, 'AppFont');
      expect(defaults.style.fontFamilyFallback, ['FallbackFont']);
      expect(defaults.maxLines, isNull);
    }
  });

  testWidgets('본문과 닫기 버튼은 별개의 접근성 노드로 읽힌다', (tester) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      host(
        BrianCallout(
          description: const Text('새 기능 안내'),
          onDismiss: () {},
          dismissLabel: '안내 닫기',
        ),
      ),
    );
    expect(
      tester.getSemantics(find.text('새 기능 안내')),
      matchesSemantics(label: '새 기능 안내'),
    );
    expect(find.bySemanticsLabel('안내 닫기'), findsOneWidget);
    semantics.dispose();
  });

  test('전체 버튼 안에 다른 동작을 중첩할 수 없다', () {
    expect(
      () => BrianCallout(
        description: const Text('안내'),
        onPressed: () {},
        onDismiss: () {},
      ),
      throwsAssertionError,
    );
    expect(
      () => BrianCallout(
        description: const Text('안내'),
        onPressed: () {},
        action: const Text('링크'),
      ),
      throwsAssertionError,
    );
  });
}
