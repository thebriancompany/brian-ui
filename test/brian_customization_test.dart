import 'dart:ui' show SemanticsAction, Tristate;

import 'package:brian_ui/brian_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget host(
  Widget child,
  BrianThemeData theme, {
  TextDirection direction = TextDirection.ltr,
  double scale = 1,
}) => WidgetsApp(
  color: const Color(0xffffffff),
  builder: (context, _) => BrianTheme(
    data: theme,
    child: MediaQuery(
      data: MediaQueryData(
        textScaler: TextScaler.linear(scale),
        disableAnimations: true,
      ),
      child: Directionality(
        textDirection: direction,
        child: Center(child: child),
      ),
    ),
  ),
);

Finder surface(Type type) => find
    .descendant(
      of: find.byType(type),
      matching: find.byWidgetPredicate(
        (w) => w is Container && w.decoration != null,
      ),
    )
    .first;
Color fill(WidgetTester tester, Type type) {
  final decoration = tester.widget<Container>(surface(type)).decoration!;
  return decoration is BoxDecoration
      ? decoration.color!
      : (decoration as ShapeDecoration).color!;
}

void main() {
  for (final intrinsicWidth in [true, false]) {
    for (final kind in ['button', 'icon', 'chip']) {
      testWidgets('최소 터치 영역의 intrinsic 배치: $kind / width=$intrinsicWidth', (
        tester,
      ) async {
        const style = BrianControlStyle(minimumTouchTarget: Size.square(48));
        final theme = BrianThemeData.light.copyWith(
          buttons: const BrianButtonStyles(medium: style),
          iconButtons: const BrianButtonStyles(medium: style),
          chips: const BrianChipStyles(medium: style),
        );
        final control = switch (kind) {
          'button' => BrianButton(onPressed: () {}, child: const Text('확인')),
          'icon' => BrianButton.icon(
            onPressed: () {},
            icon: const SizedBox.square(dimension: 16),
            semanticLabel: '열기',
          ),
          _ => BrianChip(onPressed: () {}, child: const Text('선택')),
        };
        await tester.pumpWidget(
          host(
            intrinsicWidth
                ? IntrinsicWidth(child: control)
                : IntrinsicHeight(child: control),
            theme,
          ),
        );
        expect(tester.takeException(), isNull);
        final size = tester.getSize(find.byWidget(control));
        expect(size.width, greaterThanOrEqualTo(48));
        expect(size.height, greaterThanOrEqualTo(48));
      });
    }
  }

  for (final direction in TextDirection.values) {
    for (final deletable in [false, true]) {
      testWidgets('칩 접근성 터치 영역과 삭제 액션 분리: $direction / delete=$deletable', (
        tester,
      ) async {
        final semantics = tester.ensureSemantics();
        var pressed = 0;
        var deleted = 0;
        final theme = BrianThemeData.light.copyWith(
          chips: const BrianChipStyles(
            medium: BrianControlStyle(minimumTouchTarget: Size(160, 60)),
          ),
        );
        final chip = BrianChip(
          selected: true,
          onPressed: () => pressed++,
          onDeleted: deletable ? () => deleted++ : null,
          deleteLabel: '첫 항목 삭제',
          child: const Text('첫 항목'),
        );
        await tester.pumpWidget(
          host(
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                chip,
                BrianChip(onPressed: () {}, child: const Text('다른 항목')),
              ],
            ),
            theme,
            direction: direction,
          ),
        );
        final node = tester.getSemantics(find.text('첫 항목'));
        expect(node.rect.size, const Size(160, 60));
        expect(node.getSemanticsData().label, '첫 항목');
        expect(
          node.getSemanticsData().flagsCollection.isSelected,
          Tristate.isTrue,
        );
        node.owner!.performAction(node.id, SemanticsAction.tap);
        expect(pressed, 1);
        if (deletable) {
          final deleteNode = tester.getSemantics(
            find.bySemanticsLabel('첫 항목 삭제'),
          );
          expect(deleteNode.id, isNot(node.id));
          deleteNode.owner!.performAction(deleteNode.id, SemanticsAction.tap);
          expect(deleted, 1);
          expect(pressed, 1);
          await tester.tap(find.byType(BrianButton));
          expect(deleted, 2);
          expect(pressed, 1);
        }
        await tester.tapAt(
          tester.getTopLeft(find.byWidget(chip)) + const Offset(2, 2),
        );
        expect(pressed, 2);
        semantics.dispose();
      });
    }
  }

  test('테마 값 비교·복사·보간은 레이아웃을 포함한다', () {
    final a = BrianThemeData.light.copyWith(
      buttons: const BrianButtonStyles(
        medium: BrianControlStyle(
          gap: 4,
          minimumSize: Size(40, 32),
          padding: EdgeInsetsDirectional.only(start: 8),
        ),
      ),
    );
    final b = a.copyWith(
      spacing: a.spacing.copyWith(x6: 32),
      radius: a.radius.copyWith(r2: 16),
      buttons: a.buttons.copyWith(
        medium: a.buttons.medium.copyWith(
          gap: 12,
          minimumSize: const Size(60, 48),
          padding: const EdgeInsetsDirectional.only(start: 24),
        ),
      ),
      iconButtons: const BrianButtonStyles(
        small: BrianControlStyle(shape: CircleBorder()),
      ),
      chips: const BrianChipStyles(
        large: BrianControlStyle(minimumTouchTarget: Size.square(48)),
      ),
      bottomSheet: const BrianBottomSheetStyle(maxWidth: 500),
    );
    expect(b.copyWith(), b);
    expect(b.copyWith().hashCode, b.hashCode);
    expect(a, isNot(b));
    expect(a.lerp(b, 0), a);
    expect(a.lerp(b, 1), b);
    final mid = a.lerp(b, .5);
    expect(mid.spacing.x6, 28);
    expect(mid.radius.r2, 12);
    expect(mid.buttons.medium.gap, 8);
    expect(mid.buttons.medium.minimumSize, const Size(50, 40));
    expect(
      mid.buttons.medium.padding,
      const EdgeInsetsDirectional.only(start: 16),
    );
    expect(a.lerp(b, .49).bottomSheet.maxWidth, isNull);
    expect(mid.bottomSheet.maxWidth, 500);
  });

  testWidgets('토큰과 크기별 설정은 갱신되고 명시 스타일이 우선한다', (tester) async {
    final base = BrianThemeData.light;
    final changed = base.copyWith(
      spacing: base.spacing.copyWith(x10: 64, x4: 30),
      radius: base.radius.copyWith(r2: 16),
    );
    final button = BrianButton(onPressed: () {}, child: const Text('확인'));
    await tester.pumpWidget(host(button, base));
    expect(
      tester.widget<Container>(surface(BrianButton)).constraints!.minHeight,
      40,
    );
    await tester.pumpWidget(host(button, changed));
    expect(tester.getSize(surface(BrianButton)).height, 64);
    final shape =
        (tester.widget<Container>(surface(BrianButton)).decoration
                    as ShapeDecoration)
                .shape
            as RoundedRectangleBorder;
    expect(shape.borderRadius, BorderRadius.circular(16));
    final custom = changed.copyWith(
      buttons: const BrianButtonStyles(
        medium: BrianControlStyle(
          minimumSize: Size(100, 80),
          padding: EdgeInsets.all(4),
        ),
      ),
    );
    await tester.pumpWidget(host(button, custom));
    expect(tester.getSize(surface(BrianButton)), const Size(100, 80));
    await tester.pumpWidget(host(SizedBox(width: 250, child: button), custom));
    expect(tester.getSize(surface(BrianButton)).width, 250);
  });

  testWidgets('원형 아이콘 버튼은 32 시각 크기와 48 터치 영역 및 로딩 크기를 유지한다', (tester) async {
    var calls = 0;
    final theme = BrianThemeData.dark.copyWith(
      iconButtons: const BrianButtonStyles(
        medium: BrianControlStyle(
          shape: CircleBorder(),
          minimumSize: Size.square(32),
          minimumTouchTarget: Size.square(48),
          padding: EdgeInsets.zero,
          iconSize: 20,
        ),
      ),
    );
    Widget button({bool loading = false, bool enabled = true}) => host(
      BrianButton.icon(
        onPressed: enabled ? () => calls++ : null,
        icon: const Icon(IconData(0x41)),
        semanticLabel: '열기',
        isLoading: loading,
      ),
      theme,
    );
    await tester.pumpWidget(button());
    expect(tester.getSize(find.byType(BrianButton)), const Size.square(48));
    expect(tester.getSize(surface(BrianButton)), const Size.square(32));
    expect(
      (tester.widget<Container>(surface(BrianButton)).decoration
              as ShapeDecoration)
          .shape,
      isA<CircleBorder>(),
    );
    expect(
      tester
          .widget<IconTheme>(
            find
                .descendant(
                  of: find.byType(BrianButton),
                  matching: find.byType(IconTheme),
                )
                .first,
          )
          .data
          .size,
      20,
    );
    await tester.tapAt(
      tester.getTopLeft(find.byType(BrianButton)) + const Offset(2, 2),
    );
    expect(calls, 1);
    await tester.pumpWidget(button(loading: true));
    expect(tester.getSize(surface(BrianButton)), const Size.square(32));
    await tester.tap(find.byType(BrianButton));
    expect(calls, 1);
    await tester.pumpWidget(button(enabled: false));
    await tester.tap(find.byType(BrianButton));
    expect(calls, 1);
  });

  for (final direction in TextDirection.values) {
    for (final chip in [false, true]) {
      testWidgets('방향 패딩과 큰 글자: $direction / chip=$chip', (tester) async {
        const control = BrianControlStyle(
          padding: EdgeInsetsDirectional.fromSTEB(30, 4, 10, 4),
          minimumTouchTarget: Size.square(48),
        );
        final theme = BrianThemeData.light.copyWith(
          buttons: const BrianButtonStyles(medium: control),
          chips: const BrianChipStyles(medium: control),
        );
        Widget controlWidget() => chip
            ? BrianChip(
                onPressed: () {},
                child: const Text('긴 번역 문장을 줄바꿈하여 표시합니다'),
              )
            : BrianButton(
                onPressed: () {},
                child: const Text('긴 번역 문장을 줄바꿈하여 표시합니다'),
              );
        await tester.pumpWidget(
          host(
            SizedBox(width: 200, child: controlWidget()),
            theme,
            direction: direction,
            scale: 3,
          ),
        );
        expect(tester.takeException(), isNull);
        final rect = tester.getRect(surface(chip ? BrianChip : BrianButton));
        expect(rect.height, greaterThan(48));
        final label = tester.getRect(find.byType(Text));
        final left = label.left - rect.left;
        final right = rect.right - label.right;
        expect(
          direction == TextDirection.ltr ? left - right : right - left,
          closeTo(20, .01),
        );
      });
    }
  }

  for (final base in [BrianThemeData.light, BrianThemeData.dark]) {
    for (final variant in BrianChipVariant.values) {
      testWidgets('브랜드 칩 상태 ${base.brightness} / $variant', (tester) async {
        final palette = base.colors.palette;
        final theme = base.copyWith(
          colors: BrianColors.fromPalette(
            palette: palette,
            brightness: base.brightness,
            brandScale: palette.green,
          ),
          chips: const BrianChipStyles(
            medium: BrianControlStyle(minimumTouchTarget: Size(100, 60)),
          ),
        );
        var calls = 0;
        final focus = FocusNode();
        addTearDown(focus.dispose);
        final semantics = tester.ensureSemantics();
        Widget chip({bool selected = true, bool enabled = true}) => host(
          BrianChip(
            tone: BrianChipTone.brand,
            variant: variant,
            selected: selected,
            enabled: enabled,
            focusNode: focus,
            onPressed: () => calls++,
            child: const Text('선택'),
          ),
          theme,
        );
        await tester.pumpWidget(chip());
        expect(fill(tester, BrianChip), theme.colors.background.brandWeak);
        expect(
          tester.widget<RichText>(find.byType(RichText)).text.style!.color,
          theme.colors.foreground.brandContrast,
        );
        expect(
          tester
              .getSemantics(find.text('선택'))
              .getSemanticsData()
              .flagsCollection
              .isSelected,
          Tristate.isTrue,
        );
        expect(
          find.descendant(
            of: find.byType(BrianChip),
            matching: find.byType(CustomPaint),
          ),
          findsOneWidget,
        );
        final point =
            tester.getTopLeft(find.byType(BrianChip)) + const Offset(2, 2);
        final gesture = await tester.startGesture(point);
        await tester.pump(const Duration(milliseconds: 150));
        expect(
          fill(tester, BrianChip),
          theme.colors.background.brandWeakPressed,
        );
        await gesture.up();
        expect(calls, 1);
        FocusManager.instance.highlightStrategy =
            FocusHighlightStrategy.alwaysTraditional;
        addTearDown(
          () => FocusManager.instance.highlightStrategy =
              FocusHighlightStrategy.automatic,
        );
        focus.requestFocus();
        await tester.pump();
        expect(
          tester.widget<Container>(surface(BrianChip)).foregroundDecoration,
          isNotNull,
        );
        await tester.sendKeyEvent(LogicalKeyboardKey.space);
        expect(calls, 2);
        final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
        await mouse.addPointer(location: Offset.zero);
        await mouse.moveTo(tester.getCenter(find.byType(BrianChip)));
        await tester.pump();
        expect(
          fill(tester, BrianChip),
          theme.colors.background.brandWeakPressed,
        );
        await mouse.removePointer();
        await tester.pumpWidget(chip(enabled: false));
        expect(
          tester.widget<RichText>(find.byType(RichText)).text.style!.color,
          theme.colors.foreground.disabled,
        );
        await tester.tapAt(point);
        expect(calls, 2);
        await tester.pumpWidget(chip(selected: false));
        await tester.pump();
        expect(
          fill(tester, BrianChip),
          isNot(theme.colors.background.brandWeak),
        );
        expect(
          find.descendant(
            of: find.byType(BrianChip),
            matching: find.byType(CustomPaint),
          ),
          findsNothing,
        );
        semantics.dispose();
      });
    }
  }

  testWidgets('시트의 테마 패딩·너비·모서리는 변경을 구독한다', (tester) async {
    final base = BrianThemeData.light;
    const sheet = BrianBottomSheet(
      showHandle: false,
      child: SizedBox(height: 40),
    );
    await tester.pumpWidget(host(sheet, base));
    expect(tester.getSize(find.byType(BrianBottomSheet)).width, 640);
    final custom = base.copyWith(
      bottomSheet: const BrianBottomSheetStyle(
        maxWidth: 400,
        padding: EdgeInsetsDirectional.fromSTEB(12, 8, 24, 8),
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
    );
    await tester.pumpWidget(host(sheet, custom, direction: TextDirection.rtl));
    expect(tester.getSize(find.byType(BrianBottomSheet)).width, 400);
    expect(tester.getSize(find.byType(BrianBottomSheet)).height, 56);
    expect(
      tester.widget<ClipRRect>(find.byType(ClipRRect)).borderRadius,
      const BorderRadius.vertical(top: Radius.circular(32)),
    );
  });
}
