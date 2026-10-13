import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:brian_ui/brian_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget host(
  Widget child, {
  BrianThemeData? theme,
  bool reduceMotion = false,
  double scale = 1,
  TextDirection direction = TextDirection.ltr,
}) => WidgetsApp(
  color: const Color(0xFFFFFFFF),
  builder: (context, _) => MediaQuery(
    data: MediaQueryData(
      disableAnimations: reduceMotion,
      textScaler: TextScaler.linear(scale),
    ),
    child: Directionality(
      textDirection: direction,
      child: BrianTheme(
        data: theme ?? BrianThemeData.light,
        child: FocusScope(
          autofocus: true,
          child: Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: 320,
              child: SingleChildScrollView(child: child),
            ),
          ),
        ),
      ),
    ),
  ),
);

List<BrianAccordionItem> items({
  bool enabled = true,
  bool maintainState = false,
  BrianAccordionIndicatorBuilder? indicator,
  FocusNode? focusNode,
  Widget? body,
}) => [
  BrianAccordionItem(
    value: 'a',
    title: const Text('첫 제목'),
    description: const Text('설명'),
    enabled: enabled,
    maintainState: maintainState,
    focusNode: focusNode,
    indicatorBuilder: indicator,
    child: body ?? const Text('첫 본문'),
  ),
  const BrianAccordionItem(
    value: 'b',
    title: Text('둘째 제목'),
    child: Text('둘째 본문'),
  ),
];

Future<void> toggle(WidgetTester tester, String title) async {
  await tester.tap(find.text(title));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('기본 접힘과 single 전환 및 재접기', (tester) async {
    final changes = <Set<String>>[];
    await tester.pumpWidget(
      host(BrianAccordion(onExpandedChanged: changes.add, children: items())),
    );
    expect(find.text('첫 본문'), findsNothing);
    await toggle(tester, '첫 제목');
    expect(find.text('첫 본문'), findsOneWidget);
    await toggle(tester, '둘째 제목');
    expect(find.text('첫 본문'), findsNothing);
    expect(find.text('둘째 본문'), findsOneWidget);
    await toggle(tester, '둘째 제목');
    expect(find.text('둘째 본문'), findsNothing);
    expect(changes, [
      {'a'},
      {'b'},
      <String>{},
    ]);
    expect(() => changes.first.add('other'), throwsUnsupportedError);
  });

  testWidgets('multiple 초기값과 독립 전환', (tester) async {
    await tester.pumpWidget(
      host(
        BrianAccordion(
          expansionMode: BrianAccordionExpansionMode.multiple,
          initialExpandedValues: const {'a'},
          children: items(),
        ),
      ),
    );
    expect(find.text('첫 본문'), findsOneWidget);
    await toggle(tester, '둘째 제목');
    expect(find.text('첫 본문'), findsOneWidget);
    expect(find.text('둘째 본문'), findsOneWidget);
    await toggle(tester, '첫 제목');
    expect(find.text('첫 본문'), findsNothing);
    expect(find.text('둘째 본문'), findsOneWidget);
  });

  testWidgets('제어 상태는 부모가 반영하며 외부 변경은 콜백을 발생시키지 않는다', (tester) async {
    final changes = <Set<String>>[];
    Widget build(Set<String>? values) => host(
      BrianAccordion(
        expandedValues: values,
        onExpandedChanged: changes.add,
        children: items(),
      ),
    );
    await tester.pumpWidget(build({}));
    await toggle(tester, '첫 제목');
    expect(changes, [
      {'a'},
    ]);
    expect(find.text('첫 본문'), findsNothing);
    await tester.pumpWidget(build({'b'}));
    await tester.pumpAndSettle();
    expect(find.text('둘째 본문'), findsOneWidget);
    expect(changes.length, 1);
    await tester.pumpWidget(build(null));
    await tester.pumpAndSettle();
    expect(find.text('둘째 본문'), findsOneWidget);
  });

  testWidgets('비활성 헤더는 탭과 키보드 입력을 막고 외부 펼침은 반영한다', (tester) async {
    final focus = FocusNode();
    addTearDown(focus.dispose);
    var calls = 0;
    Widget build(Set<String> values) => host(
      BrianAccordion(
        expandedValues: values,
        onExpandedChanged: (_) => calls++,
        children: items(enabled: false, focusNode: focus),
      ),
    );
    await tester.pumpWidget(build({}));
    await toggle(tester, '첫 제목');
    focus.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    expect(calls, 0);
    expect(focus.hasFocus, isFalse);
    await tester.pumpWidget(build({'a'}));
    await tester.pumpAndSettle();
    expect(find.text('첫 본문'), findsOneWidget);
  });

  testWidgets('Tab Enter Space와 반복 키를 처리한다', (tester) async {
    final focus = FocusNode();
    addTearDown(focus.dispose);
    var calls = 0;
    await tester.pumpWidget(
      host(
        BrianAccordion(
          onExpandedChanged: (_) => calls++,
          children: items(focusNode: focus),
        ),
      ),
    );
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    expect(focus.hasFocus, isTrue);
    await tester.sendKeyDownEvent(LogicalKeyboardKey.enter);
    await tester.sendKeyRepeatEvent(LogicalKeyboardKey.enter);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(calls, 1);
    expect(find.text('첫 본문'), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pumpAndSettle();
    expect(calls, 2);
    expect(find.text('첫 본문'), findsNothing);
  });

  testWidgets('기본 chevron은 중간 각도를 거쳐 180도 회전하고 모션 감소를 따른다', (tester) async {
    Finder chevron() => find.descendant(
      of: find.byType(BrianAccordionItem).first,
      matching: find.byWidgetPredicate(
        (w) => w is Transform && w.child is CustomPaint,
      ),
    );
    double rotation() {
      final m = tester.widget<Transform>(chevron()).transform;
      return math.atan2(m.entry(1, 0), m.entry(0, 0));
    }

    Widget build(bool reduce) =>
        host(BrianAccordion(children: items()), reduceMotion: reduce);
    await tester.pumpWidget(build(false));
    expect(rotation(), 0);
    await tester.tap(find.text('첫 제목'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(rotation(), inExclusiveRange(0, math.pi));
    await tester.pumpAndSettle();
    expect(rotation().abs(), closeTo(math.pi, 0.001));
    await tester.pumpWidget(build(true));
    await tester.tap(find.text('첫 제목'));
    await tester.pump();
    expect(rotation(), closeTo(0, 0.001));
    expect(find.text('첫 본문'), findsNothing);
  });

  testWidgets('builder는 상태와 테마 스타일을 받고 자동 회전과 semantics를 제외한다', (tester) async {
    final semantics = tester.ensureSemantics();
    IconThemeData? style;
    await tester.pumpWidget(
      host(
        BrianAccordion(
          children: items(
            indicator: (context, expanded) {
              style = IconTheme.of(context);
              return Text(expanded ? '접기 표시' : '펼치기 표시');
            },
          ),
        ),
      ),
    );
    expect(style!.size, 20);
    expect(style!.color, BrianColors.light.foreground.neutralSubtle);
    expect(
      find.descendant(
        of: find.byType(BrianAccordionItem).first,
        matching: find.byType(CustomPaint),
      ),
      findsNothing,
    );
    expect(find.bySemanticsLabel('펼치기 표시'), findsNothing);
    await toggle(tester, '첫 제목');
    expect(find.text('접기 표시'), findsOneWidget);
    final data = tester.getSemantics(find.text('첫 제목')).getSemanticsData();
    expect(data.flagsCollection.isExpanded, ui.Tristate.isTrue);
    expect(data.flagsCollection.isButton, isTrue);
    semantics.dispose();
  });

  testWidgets('maintainState 본문은 상태를 유지하지만 접으면 포커스와 semantics에서 빠진다', (
    tester,
  ) async {
    final focus = FocusNode();
    addTearDown(focus.dispose);
    final semantics = tester.ensureSemantics();
    final body = Focus(focusNode: focus, child: const _Counter());
    await tester.pumpWidget(
      host(
        BrianAccordion(
          initialExpandedValues: const {'a'},
          children: items(maintainState: true, body: body),
        ),
      ),
    );
    await tester.tap(find.text('횟수 0'));
    await tester.pump();
    focus.requestFocus();
    await tester.pump();
    expect(focus.hasFocus, isTrue);
    await toggle(tester, '첫 제목');
    expect(focus.hasFocus, isFalse);
    expect(find.text('횟수 1'), findsNothing);
    expect(find.text('횟수 1', skipOffstage: false), findsOneWidget);
    expect(find.bySemanticsLabel('횟수 1'), findsNothing);
    await toggle(tester, '첫 제목');
    expect(find.text('횟수 1'), findsOneWidget);
    semantics.dispose();
  });

  testWidgets('기본 본문은 접힘 완료 후 제거하고 재생성한다', (tester) async {
    await tester.pumpWidget(
      host(BrianAccordion(children: items(body: const _Counter()))),
    );
    await toggle(tester, '첫 제목');
    await tester.tap(find.text('횟수 0'));
    await tester.pump();
    await toggle(tester, '첫 제목');
    expect(find.byType(_Counter, skipOffstage: false), findsNothing);
    await toggle(tester, '첫 제목');
    expect(find.text('횟수 0'), findsOneWidget);
  });

  testWidgets('순서 변경은 value의 본문 상태를 보존하고 항목 제거와 모드 전환을 정리한다', (tester) async {
    final a = items(maintainState: true, body: const _Counter()).first;
    final b = items().last;
    const c = BrianAccordionItem(
      value: 'c',
      title: Text('셋째 제목'),
      child: Text('셋째 본문'),
    );
    Widget build(
      List<BrianAccordionItem> children,
      BrianAccordionExpansionMode mode,
    ) => host(
      BrianAccordion(
        initialExpandedValues: const {'a', 'b'},
        expansionMode: mode,
        children: children,
      ),
    );
    await tester.pumpWidget(
      build([a, b, c], BrianAccordionExpansionMode.multiple),
    );
    await tester.tap(find.text('횟수 0'));
    await tester.pump();
    await tester.pumpWidget(
      build([b, a, c], BrianAccordionExpansionMode.multiple),
    );
    expect(find.text('횟수 1'), findsOneWidget);
    await tester.pumpWidget(
      build([b, a, c], BrianAccordionExpansionMode.single),
    );
    await tester.pumpAndSettle();
    expect(find.text('횟수 1'), findsNothing);
    expect(find.text('둘째 본문'), findsOneWidget);
    await tester.pumpWidget(build([a, c], BrianAccordionExpansionMode.single));
    await tester.pumpAndSettle();
    await toggle(tester, '셋째 제목');
    expect(find.text('셋째 본문'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('두 테마와 크기·배치에서 확대 및 RTL을 지원하고 상태 색상을 사용한다', (tester) async {
    for (final theme in [BrianThemeData.light, BrianThemeData.dark]) {
      for (final size in BrianAccordionSize.values) {
        for (final variant in BrianAccordionVariant.values) {
          IconThemeData? style;
          await tester.pumpWidget(
            host(
              BrianAccordion(
                size: size,
                variant: variant,
                children: items(
                  enabled: false,
                  indicator: (context, _) {
                    style = IconTheme.of(context);
                    return const Text('+');
                  },
                ),
              ),
              theme: theme,
              scale: 2,
              direction: TextDirection.rtl,
            ),
          );
          await tester.pumpAndSettle();
          expect(style!.color, theme.colors.foreground.disabled);
          expect(style!.size, size == BrianAccordionSize.medium ? 20 : 24);
          expect(tester.takeException(), isNull);
          await tester.pumpWidget(const SizedBox.shrink());
        }
      }
    }
  });
}

class _Counter extends StatefulWidget {
  const _Counter();
  @override
  State<_Counter> createState() => _CounterState();
}

class _CounterState extends State<_Counter> {
  int count = 0;
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => setState(() => count++),
    child: Text('횟수 $count'),
  );
}
