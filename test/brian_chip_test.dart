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
        child: Center(child: child),
      ),
    ),
  ),
);

BoxDecoration decoration(WidgetTester tester) =>
    tester
            .widget<Container>(
              find
                  .descendant(
                    of: find.byType(BrianChip),
                    matching: find.byType(Container),
                  )
                  .first,
            )
            .decoration!
        as BoxDecoration;

void main() {
  testWidgets('선택은 부모가 갱신하며 키 반복은 실행하지 않는다', (tester) async {
    var calls = 0;
    var selected = false;
    final focus = FocusNode();
    addTearDown(focus.dispose);
    final semantics = tester.ensureSemantics();

    await tester.pumpWidget(
      host(
        StatefulBuilder(
          builder: (context, setState) => BrianChip(
            focusNode: focus,
            selected: selected,
            onPressed: () => setState(() {
              calls++;
              selected = !selected;
            }),
            child: const Text('관심사'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('관심사'));
    await tester.pump();
    expect(selected, isTrue);
    expect(
      tester.getSemantics(find.text('관심사')),
      matchesSemantics(
        label: '관심사',
        isButton: true,
        hasEnabledState: true,
        isEnabled: true,
        hasSelectedState: true,
        isSelected: true,
        isFocusable: true,
        hasTapAction: true,
        hasFocusAction: true,
      ),
    );
    focus.requestFocus();
    await tester.pump();
    for (final key in [LogicalKeyboardKey.enter, LogicalKeyboardKey.space]) {
      await tester.sendKeyDownEvent(key);
      await tester.sendKeyRepeatEvent(key);
      await tester.sendKeyUpEvent(key);
      await tester.pump();
    }
    expect(calls, 3);
    semantics.dispose();
  });

  testWidgets('삭제와 본문은 독립적이고 비활성 시 둘 다 차단한다', (tester) async {
    var presses = 0;
    var deletes = 0;
    for (final enabled in [true, false]) {
      await tester.pumpWidget(
        host(
          BrianChip(
            enabled: enabled,
            onPressed: () => presses++,
            onDeleted: () => deletes++,
            deleteLabel: '민지 삭제',
            child: const Text('민지'),
          ),
        ),
      );
      await tester.tap(find.text('민지'));
      await tester.tap(find.byType(BrianButton));
      await tester.pump();
      expect(presses, 1);
      expect(deletes, 1);
    }
    await tester.pumpWidget(
      host(
        BrianChip(
          onPressed: null,
          onDeleted: () => deletes++,
          child: const Text('입력값'),
        ),
      ),
    );
    await tester.tap(find.byType(BrianButton));
    expect(deletes, 2);
  });

  testWidgets('라이트·다크의 모든 스타일과 선택 상태는 누름 취소를 복원한다', (tester) async {
    for (final theme in [BrianThemeData.light, BrianThemeData.dark]) {
      for (final variant in BrianChipVariant.values) {
        for (final selected in [false, true]) {
          await tester.pumpWidget(
            host(
              BrianChip(
                variant: variant,
                selected: selected,
                onPressed: () {},
                child: const Text('항목'),
              ),
              theme: theme,
            ),
          );
          final original = decoration(tester).color;
          final foreground = DefaultTextStyle.of(
            tester.element(find.text('항목')),
          ).style.color;
          expect(
            foreground,
            variant == BrianChipVariant.solid && selected
                ? theme.colors.foreground.onNeutralSolid
                : theme.colors.foreground.neutral,
          );
          final gesture = await tester.startGesture(
            tester.getCenter(find.text('항목')),
          );
          await tester.pump(const Duration(milliseconds: 150));
          expect(decoration(tester).color, isNot(original));
          await gesture.cancel();
          await tester.pump();
          expect(decoration(tester).color, original);
        }
      }
    }
  });

  testWidgets('outlineStrong은 선택 시 배경과 외곽선을 함께 변경한다', (tester) async {
    for (final theme in [BrianThemeData.light, BrianThemeData.dark]) {
      var selected = false;
      await tester.pumpWidget(
        host(
          StatefulBuilder(
            builder: (context, setState) => BrianChip(
              variant: BrianChipVariant.outlineStrong,
              selected: selected,
              onPressed: () => setState(() => selected = !selected),
              child: const Text('필터'),
            ),
          ),
          theme: theme,
        ),
      );
      expect(decoration(tester).color, theme.colors.background.transparent);
      expect(
        (decoration(tester).border! as Border).top.color,
        theme.colors.stroke.neutralSolid,
      );
      await tester.tap(find.text('필터'));
      await tester.pump();
      expect(decoration(tester).color, theme.colors.background.neutralWeak);
      expect(
        (decoration(tester).border! as Border).top.color,
        theme.colors.stroke.neutralContrast,
      );
      await tester.tap(find.text('필터'));
      await tester.pump();
      expect(decoration(tester).color, theme.colors.background.transparent);
    }
  });

  testWidgets('좁은 너비·글자 확대·RTL에서도 라벨과 삭제 버튼을 배치한다', (tester) async {
    for (final size in BrianChipSize.values) {
      await tester.pumpWidget(
        host(
          SizedBox(
            width: 180,
            child: BrianChip(
              size: size,
              onPressed: null,
              onDeleted: () {},
              leadingStyle: BrianChipLeadingStyle.avatar,
              leading: const ColoredBox(color: Color(0xFFEEEEEE)),
              child: const Text('길이가 긴 수신자 이름을 표시합니다'),
            ),
          ),
          scale: 2,
          direction: TextDirection.rtl,
        ),
      );
      expect(tester.takeException(), isNull);
      expect(tester.getSize(find.byType(BrianChip)).height, greaterThan(40));
    }
  });
}
