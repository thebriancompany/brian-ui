import 'dart:ui' show CheckedState, ImageByteFormat, Tristate;

import 'package:brian_ui/brian_ui.dart';
import 'package:flutter/rendering.dart';
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
        child: Center(child: SizedBox(width: 240, child: child)),
      ),
    ),
  ),
);

void main() {
  testWidgets('클릭한 체크박스로 포커스를 옮겨 이후 키 입력을 전달한다', (tester) async {
    for (final externalFocus in [false, true]) {
      final firstFocus = FocusNode();
      final secondFocus = FocusNode();
      addTearDown(firstFocus.dispose);
      addTearDown(secondFocus.dispose);
      final calls = <String>[];
      await tester.pumpWidget(
        host(
          Column(
            children: [
              BrianCheckbox(
                value: false,
                focusNode: firstFocus,
                onChanged: (_) => calls.add('첫 번째'),
                label: const Text('첫 번째'),
              ),
              BrianCheckbox(
                value: false,
                focusNode: externalFocus ? secondFocus : null,
                onChanged: (_) => calls.add('두 번째'),
                label: const Text('두 번째'),
              ),
              const BrianCheckbox(
                value: false,
                onChanged: null,
                label: Text('비활성'),
              ),
            ],
          ),
        ),
      );
      firstFocus.requestFocus();
      await tester.pump();
      await tester.tapAt(tester.getCenter(find.text('두 번째')));
      await tester.pump();
      expect(firstFocus.hasFocus, isFalse);
      if (externalFocus) expect(secondFocus.hasFocus, isTrue);
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      expect(calls, ['두 번째', '두 번째', '두 번째']);
      await tester.tapAt(tester.getCenter(find.text('비활성')));
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      expect(calls, ['두 번째', '두 번째', '두 번째', '두 번째']);
    }
  });

  testWidgets('보조키 조합은 선택을 바꾸지 않고 상위 단축키에 전달한다', (tester) async {
    final focus = FocusNode();
    addTearDown(focus.dispose);
    var calls = 0;
    var shortcuts = 0;
    for (final modifier in [
      LogicalKeyboardKey.controlLeft,
      LogicalKeyboardKey.altLeft,
      LogicalKeyboardKey.shiftLeft,
      LogicalKeyboardKey.metaLeft,
    ]) {
      for (final key in [LogicalKeyboardKey.space, LogicalKeyboardKey.enter]) {
        await tester.pumpWidget(
          host(
            CallbackShortcuts(
              bindings: {
                SingleActivator(
                  key,
                  control: modifier == LogicalKeyboardKey.controlLeft,
                  alt: modifier == LogicalKeyboardKey.altLeft,
                  shift: modifier == LogicalKeyboardKey.shiftLeft,
                  meta: modifier == LogicalKeyboardKey.metaLeft,
                  includeRepeats: false,
                ): () =>
                    shortcuts++,
              },
              child: BrianCheckbox(
                value: false,
                onChanged: (_) => calls++,
                focusNode: focus,
                label: const Text('선택'),
              ),
            ),
          ),
        );
        focus.requestFocus();
        await tester.pump();
        final before = shortcuts;
        await tester.sendKeyDownEvent(modifier);
        await tester.sendKeyDownEvent(key);
        await tester.sendKeyRepeatEvent(key);
        await tester.sendKeyUpEvent(key);
        await tester.sendKeyUpEvent(modifier);
        expect(calls, 0);
        expect(shortcuts, before + 1);
      }
    }
    await tester.sendKeyDownEvent(LogicalKeyboardKey.space);
    await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.space);
    await tester.pump();
    expect(
      tester.widget<BrianCheckmark>(find.byType(BrianCheckmark)).pressed,
      isFalse,
    );
    await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
    expect(calls, 1);
  });

  testWidgets('라벨과 행 여백이 새 값을 요청하며 값은 부모가 관리한다', (tester) async {
    for (final value in <bool?>[false, true, null]) {
      final changes = <bool>[];
      await tester.pumpWidget(
        host(
          BrianCheckbox(
            value: value,
            onChanged: changes.add,
            label: const Text('선택'),
          ),
        ),
      );
      await tester.tapAt(tester.getCenter(find.text('선택')));
      await tester.pump();
      expect(changes, [value != true]);
      expect(
        tester.widget<BrianCheckbox>(find.byType(BrianCheckbox)).value,
        value,
      );
      final rect = tester.getRect(find.byType(BrianCheckbox));
      expect(rect.height, greaterThanOrEqualTo(44));
      await tester.tapAt(rect.centerRight - const Offset(5, 0));
      expect(changes, [value != true, value != true]);
    }
  });

  testWidgets('Space와 Enter 반복 입력을 막고 포커스와 눌림을 복원한다', (tester) async {
    final focus = FocusNode();
    addTearDown(focus.dispose);
    var calls = 0;
    await tester.pumpWidget(
      host(
        BrianCheckbox(
          value: false,
          onChanged: (_) => calls++,
          focusNode: focus,
          label: const Text('선택'),
        ),
      ),
    );
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    focus.requestFocus();
    await tester.pumpAndSettle();
    Container surface() => tester.widget<Container>(
      find
          .descendant(
            of: find.byType(BrianCheckbox),
            matching: find.byType(Container),
          )
          .first,
    );
    expect(surface().foregroundDecoration, isNotNull);
    for (final key in [LogicalKeyboardKey.space, LogicalKeyboardKey.enter]) {
      final before = calls;
      await tester.sendKeyDownEvent(key);
      await tester.pump();
      expect(
        (surface().decoration! as BoxDecoration).color,
        BrianThemeData.light.colors.background.transparentPressed,
      );
      await tester.sendKeyRepeatEvent(key);
      await tester.sendKeyRepeatEvent(key);
      await tester.sendKeyUpEvent(key);
      await tester.pump();
      expect(calls, before + 1);
      expect((surface().decoration! as BoxDecoration).color, isNull);
    }
    await tester.pumpWidget(
      host(
        BrianCheckbox(
          value: true,
          onChanged: null,
          focusNode: focus,
          label: const Text('선택'),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(focus.hasFocus, isFalse);
    expect(surface().foregroundDecoration, isNull);
    await tester.tapAt(tester.getCenter(find.text('선택')));
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    expect(calls, 2);
  });

  testWidgets('접근성에 라벨과 선택·부분 선택·비활성 상태를 전달한다', (tester) async {
    final handle = tester.ensureSemantics();
    for (final value in <bool?>[false, true, null]) {
      for (final enabled in [true, false]) {
        var calls = 0;
        await tester.pumpWidget(
          host(
            BrianCheckbox(
              value: value,
              onChanged: enabled ? (_) => calls++ : null,
              label: const Text('동의'),
            ),
          ),
        );
        final node = tester.getSemantics(find.byType(BrianCheckbox));
        final data = node.getSemanticsData();
        expect(data.label, '동의');
        expect(
          data.flagsCollection.isChecked,
          value == null
              ? CheckedState.mixed
              : value
              ? CheckedState.isTrue
              : CheckedState.isFalse,
        );
        expect(
          data.flagsCollection.isEnabled,
          enabled ? Tristate.isTrue : Tristate.isFalse,
        );
        expect(data.hasAction(SemanticsAction.tap), enabled);
        if (enabled) {
          node.owner!.performAction(node.id, SemanticsAction.tap);
          expect(calls, 1);
        }
      }
    }
    handle.dispose();
  });

  testWidgets('테마·형태·크기·상태 조합과 취소된 누름을 표시한다', (tester) async {
    for (final theme in [BrianThemeData.light, BrianThemeData.dark]) {
      for (final shape in BrianCheckboxShape.values) {
        for (final size in BrianCheckboxSize.values) {
          for (final value in <bool?>[false, true, null]) {
            await tester.pumpWidget(
              host(
                BrianCheckbox(
                  value: value,
                  onChanged: (_) {},
                  shape: shape,
                  size: size,
                  label: const Text('선택'),
                ),
                theme: theme,
              ),
            );
            expect(
              tester.getSize(find.byType(BrianCheckmark)),
              Size.square(size == BrianCheckboxSize.medium ? 20 : 24),
            );
            BoxDecoration mark() =>
                tester
                        .widget<DecoratedBox>(
                          find.descendant(
                            of: find.byType(BrianCheckmark),
                            matching: find.byType(DecoratedBox),
                          ),
                        )
                        .decoration
                    as BoxDecoration;
            expect(
              mark().color,
              shape == BrianCheckboxShape.square && value != false
                  ? theme.colors.background.neutralSolid
                  : theme.colors.background.transparent,
            );
            final gesture = await tester.startGesture(
              tester.getCenter(find.text('선택')),
            );
            await tester.pump(const Duration(milliseconds: 150));
            expect(
              tester
                  .widget<BrianCheckmark>(find.byType(BrianCheckmark))
                  .pressed,
              isTrue,
            );
            if (shape == BrianCheckboxShape.square && value != false) {
              expect(mark().color, theme.colors.background.neutralSolidPressed);
            }
            await gesture.cancel();
            await tester.pump();
            expect(
              tester
                  .widget<BrianCheckmark>(find.byType(BrianCheckmark))
                  .pressed,
              isFalse,
            );
          }
        }
      }
    }
  });

  testWidgets('비활성 ghost의 선택·미선택·부분 선택을 두 테마에서 구분한다', (tester) async {
    for (final theme in [BrianThemeData.light, BrianThemeData.dark]) {
      for (final size in BrianCheckboxSize.values) {
        final boundaryKey = GlobalKey();
        Future<List<int>> pixels(bool? value) async {
          await tester.pumpWidget(
            host(
              RepaintBoundary(
                key: boundaryKey,
                child: ColoredBox(
                  color: theme.colors.background.layerDefault,
                  child: BrianCheckmark(
                    value: value,
                    enabled: false,
                    shape: BrianCheckboxShape.ghost,
                    size: size,
                  ),
                ),
              ),
              theme: theme,
            ),
          );
          await tester.pumpAndSettle();
          final boundary = tester.renderObject<RenderRepaintBoundary>(
            find.byKey(boundaryKey),
          );
          return (await tester.runAsync(() async {
            final image = await boundary.toImage();
            try {
              final data = (await image.toByteData(
                format: ImageByteFormat.rawRgba,
              ))!;
              return data.buffer.asUint8List().toList();
            } finally {
              image.dispose();
            }
          }))!;
        }

        final unchecked = await pixels(false);
        final checked = await pixels(true);
        final mixed = await pixels(null);
        expect(unchecked, isNot(orderedEquals(checked)));
        expect(mixed, isNot(orderedEquals(checked)));
        expect(mixed, isNot(orderedEquals(unchecked)));
      }
    }
  });

  testWidgets('RTL과 확대된 긴 라벨은 넘침 없이 여러 줄로 배치한다', (tester) async {
    await tester.pumpWidget(
      host(
        BrianCheckbox(
          value: false,
          onChanged: (_) {},
          label: const Text('배송 일정과 수령 장소를 확인했으며 지정한 장소에 보관하는 것에 동의합니다.'),
        ),
        scale: 2.5,
        direction: TextDirection.rtl,
      ),
    );
    expect(tester.takeException(), isNull);
    expect(tester.getSize(find.byType(BrianCheckbox)).height, greaterThan(44));
    expect(
      tester.getCenter(find.byType(BrianCheckmark)).dx,
      greaterThan(tester.getCenter(find.byType(Text)).dx),
    );
  });
}
