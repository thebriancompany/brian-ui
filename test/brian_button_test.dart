import 'dart:ui' as ui;

import 'package:brian_ui/brian_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget host(Widget child, {BrianThemeData? theme, double scale = 1}) =>
    WidgetsApp(
      color: const Color(0xFFFFFFFF),
      builder: (context, _) => MediaQuery(
        data: MediaQueryData(textScaler: TextScaler.linear(scale)),
        child: BrianTheme(
          data: theme ?? BrianThemeData.light,
          child: FocusScope(autofocus: true, child: Center(child: child)),
        ),
      ),
    );

Finder get surface => find.descendant(
  of: find.byType(BrianButton),
  matching: find.byWidgetPredicate(
    (widget) => widget is Container && widget.decoration is ShapeDecoration,
  ),
);

Color background(WidgetTester tester) =>
    (tester.widget<Container>(surface).decoration! as ShapeDecoration).color!;

void main() {
  testWidgets('기본 neutralSolid 라벨은 모든 크기와 활성 상태에서 4.5:1 이상이다', (tester) async {
    for (final theme in [BrianThemeData.light, BrianThemeData.dark]) {
      for (final size in BrianButtonSize.values) {
        Widget button({bool loading = false}) => host(
          BrianButton(
            onPressed: () {},
            size: size,
            isLoading: loading,
            child: const Text('저장'),
          ),
          theme: theme,
        );
        void checkContrast() {
          final label = tester.widget<RichText>(find.byType(RichText));
          expect(
            contrast(label.text.style!.color!, background(tester)),
            greaterThanOrEqualTo(4.5),
            reason: '${theme.colors.brightness.name} / ${size.name}',
          );
        }

        await tester.pumpWidget(button());
        await tester.pumpAndSettle();
        checkContrast();
        final gesture = await tester.startGesture(tester.getCenter(surface));
        await tester.pump(const Duration(milliseconds: 150));
        await tester.pumpAndSettle();
        checkContrast();
        await gesture.up();
        final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
        await mouse.addPointer(location: Offset.zero);
        await mouse.moveTo(tester.getCenter(surface));
        await tester.pumpAndSettle();
        checkContrast();
        await mouse.removePointer();
        await tester.pumpWidget(button(loading: true));
        await tester.pump(const Duration(milliseconds: 200));
        checkContrast();
        await tester.pumpWidget(const SizedBox.shrink());
      }
    }
  });

  testWidgets('solid 버튼 포커스 링은 표면과 대비되며 버튼 밖에 간격을 두고 그려진다', (tester) async {
    for (final theme in [BrianThemeData.light, BrianThemeData.dark]) {
      final bg = theme.colors.background;
      for (final layer in [
        bg.layerDefault,
        bg.layerBasement,
        bg.layerFloating,
        bg.layerDefaultPressed,
        bg.layerFloatingPressed,
      ]) {
        expect(
          contrast(theme.colors.stroke.focusRing, layer),
          greaterThanOrEqualTo(3),
        );
      }
      for (final variant in [
        BrianButtonVariant.brandSolid,
        BrianButtonVariant.criticalSolid,
      ]) {
        for (final size in [BrianButtonSize.xsmall, BrianButtonSize.medium]) {
          final boundaryKey = GlobalKey();
          final focus = FocusNode();
          addTearDown(focus.dispose);
          await tester.pumpWidget(
            host(
              RepaintBoundary(
                key: boundaryKey,
                child: ColoredBox(
                  color: bg.layerDefault,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: BrianButton(
                      focusNode: focus,
                      onPressed: () {},
                      variant: variant,
                      size: size,
                      child: const Text('실행'),
                    ),
                  ),
                ),
              ),
              theme: theme,
            ),
          );
          await tester.pumpAndSettle();
          final before = tester.getSize(surface);
          await tester.sendKeyEvent(LogicalKeyboardKey.tab);
          await tester.pumpAndSettle();
          expect(focus.hasFocus, isTrue);
          expect(tester.getSize(surface), before);
          final bounds = tester
              .getRect(surface)
              .shift(-tester.getTopLeft(find.byKey(boundaryKey)));
          final boundary = tester.renderObject<RenderRepaintBoundary>(
            find.byKey(boundaryKey),
          );
          await tester.runAsync(() async {
            final image = await boundary.toImage();
            try {
              final data = (await image.toByteData(
                format: ui.ImageByteFormat.rawRgba,
              ))!;
              Color pixel(int x, int y) {
                final offset = (y * image.width + x) * 4;
                return Color.fromARGB(
                  data.getUint8(offset + 3),
                  data.getUint8(offset),
                  data.getUint8(offset + 1),
                  data.getUint8(offset + 2),
                );
              }

              final left = bounds.left.round();
              final centerY = bounds.center.dy.floor();
              expect(pixel(left - 5, centerY), bg.layerDefault);
              expect(pixel(left - 3, centerY), theme.colors.stroke.focusRing);
              expect(pixel(left - 1, centerY), bg.layerDefault);
              expect(pixel(left + 2, centerY), background(tester));
            } finally {
              image.dispose();
            }
          });
          await tester.pumpWidget(const SizedBox.shrink());
        }
      }
    }
  });

  testWidgets('상위 앱 글꼴을 상속하며 크기·굵기·전경은 버튼 스타일을 따른다', (tester) async {
    for (final theme in [BrianThemeData.light, BrianThemeData.dark]) {
      for (final size in BrianButtonSize.values) {
        await tester.pumpWidget(
          host(
            DefaultTextStyle(
              style: const TextStyle(
                fontFamily: 'AppFont',
                fontFamilyFallback: ['AppFallback'],
                fontSize: 30,
                fontWeight: FontWeight.w400,
                color: Color(0xFF123456),
              ),
              child: BrianButton(
                onPressed: () {},
                size: size,
                child: const Text('저장'),
              ),
            ),
            theme: theme,
          ),
        );
        await tester.pumpAndSettle();
        final style = tester
            .widget<RichText>(find.byType(RichText))
            .text
            .style!;
        expect(style.fontFamily, 'AppFont');
        expect(style.fontFamilyFallback, ['AppFallback']);
        expect(style.fontSize, [13.0, 14.0, 14.0, 18.0][size.index]);
        expect(style.fontWeight, FontWeight.w700);
        expect(style.color, theme.colors.foreground.onNeutralSolid);
      }
    }
  });

  testWidgets('모든 variant와 size가 라이트·다크에서 렌더링된다', (tester) async {
    for (final theme in [BrianThemeData.light, BrianThemeData.dark]) {
      for (final variant in BrianButtonVariant.values) {
        for (final size in BrianButtonSize.values) {
          await tester.pumpWidget(
            host(
              BrianButton(
                onPressed: () {},
                variant: variant,
                size: size,
                child: const Text('저장하기'),
              ),
              theme: theme,
            ),
          );
          await tester.pump(const Duration(milliseconds: 200));
          expect(tester.takeException(), isNull);
          final text = tester.widget<RichText>(find.byType(RichText));
          expect(text.text.style!.color, switch (variant) {
            BrianButtonVariant.brandSolid =>
              theme.colors.foreground.onBrandSolid,
            BrianButtonVariant.neutralSolid =>
              theme.colors.foreground.onNeutralSolid,
            BrianButtonVariant.criticalSolid =>
              theme.colors.foreground.onCriticalSolid,
            BrianButtonVariant.brandOutline => theme.colors.foreground.brand,
            _ => theme.colors.foreground.neutral,
          });
          expect(
            tester.getSize(surface).height,
            greaterThanOrEqualTo([32.0, 36.0, 40.0, 52.0][size.index]),
          );
        }
      }
    }
  });

  testWidgets('누름·취소·실행 및 비활성화 전환을 처리한다', (tester) async {
    var calls = 0;
    Widget button(VoidCallback? callback) =>
        host(BrianButton(onPressed: callback, child: const Text('저장')));
    await tester.pumpWidget(button(() => calls++));
    await tester.pump(const Duration(milliseconds: 200));
    expect(background(tester), BrianColors.light.background.neutralSolid);
    final gesture = await tester.startGesture(tester.getCenter(surface));
    await tester.pump(const Duration(milliseconds: 150));
    await tester.pump(const Duration(milliseconds: 200));
    expect(
      background(tester),
      BrianColors.light.background.neutralSolidPressed,
    );
    await gesture.cancel();
    await tester.pump();
    expect(calls, 0);
    await tester.pump(const Duration(milliseconds: 200));
    expect(background(tester), BrianColors.light.background.neutralSolid);
    await tester.tap(surface);
    expect(calls, 1);
    final pending = await tester.startGesture(tester.getCenter(surface));
    await tester.pump(const Duration(milliseconds: 150));
    await tester.pumpWidget(button(null));
    await pending.up();
    await tester.pump();
    expect(calls, 1);
    await tester.pump(const Duration(milliseconds: 200));
    expect(background(tester), BrianColors.light.background.disabled);
    await tester.tap(surface);
    expect(calls, 1);
  });

  testWidgets('Tab 포커스와 Enter·Space 실행, hover를 지원한다', (tester) async {
    var calls = 0;
    final node = FocusNode();
    addTearDown(node.dispose);
    await tester.pumpWidget(
      host(
        BrianButton(
          focusNode: node,
          onPressed: () => calls++,
          child: const Text('실행'),
        ),
      ),
    );
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    expect(node.hasFocus, isTrue);
    expect(tester.widget<Container>(surface).foregroundDecoration, isNotNull);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    expect(calls, 2);
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(tester.getCenter(surface));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    expect(
      background(tester),
      BrianColors.light.background.neutralSolidPressed,
    );
    await mouse.removePointer();
  });

  testWidgets('로딩 시 크기와 의미를 유지하고 실행을 막는다', (tester) async {
    final semantics = tester.ensureSemantics();
    var calls = 0;
    Widget button(bool loading) => host(
      BrianButton(
        onPressed: () => calls++,
        isLoading: loading,
        child: const Text('변경 사항 저장하기'),
      ),
    );
    await tester.pumpWidget(button(false));
    final before = tester.getSize(surface);
    await tester.pumpWidget(button(true));
    expect(tester.getSize(surface), before);
    await tester.tap(surface);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    expect(calls, 0);
    final node = tester.getSemantics(find.byType(BrianButton));
    expect(node.label, contains('변경 사항 저장하기'));
    expect(node.value, '처리 중');
    expect(node.getSemanticsData().hasAction(SemanticsAction.tap), isFalse);
    await tester.pumpWidget(button(false));
    await tester.tap(surface);
    expect(calls, 1);
    semantics.dispose();
  });

  testWidgets('아이콘 버튼에 접근성 이름과 버튼 역할을 제공한다', (tester) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      host(
        BrianButton.icon(
          onPressed: () {},
          semanticLabel: '닫기',
          icon: const SizedBox(key: ValueKey('icon'), width: 16, height: 16),
        ),
      ),
    );
    final node = tester.getSemantics(find.byType(BrianButton));
    expect(node.label, '닫기');
    expect(node.getSemanticsData().flagsCollection.isButton, isTrue);
    expect(node.getSemanticsData().hasAction(SemanticsAction.tap), isTrue);
    expect(background(tester), BrianColors.light.background.neutralSolid);
    expect(
      IconTheme.of(tester.element(find.byKey(const ValueKey('icon')))).color,
      BrianColors.light.foreground.onNeutralSolid,
    );
    semantics.dispose();
  });

  testWidgets('제한된 너비와 큰 글자, RTL에서 줄바꿈하며 높이가 늘어난다', (tester) async {
    await tester.pumpWidget(
      host(
        Directionality(
          textDirection: TextDirection.rtl,
          child: SizedBox(
            width: 180,
            child: BrianButton(
              onPressed: () {},
              leading: const SizedBox(width: 14, height: 14),
              child: const Text('변경 사항을 모두 저장하기'),
            ),
          ),
        ),
        scale: 2,
      ),
    );
    expect(tester.takeException(), isNull);
    expect(tester.getSize(surface).width, 180);
    expect(tester.getSize(surface).height, greaterThan(40));
  });

  testWidgets('테마 전환과 사용자 정의 역할 색상을 반영한다', (tester) async {
    final child = BrianButton(
      onPressed: () {},
      variant: BrianButtonVariant.brandSolid,
      child: const Text('저장'),
    );
    await tester.pumpWidget(host(child));
    final custom = BrianThemeData.dark.copyWith(
      colors: BrianColors.dark.copyWith(
        foreground: BrianColors.dark.foreground.copyWith(
          onBrandSolid: const Color(0xFFFEDCBA),
        ),
        background: BrianColors.dark.background.copyWith(
          brandSolid: const Color(0xFF123456),
        ),
      ),
    );
    await tester.pumpWidget(host(child, theme: custom));
    await tester.pump(const Duration(milliseconds: 200));
    expect(background(tester), const Color(0xFF123456));
    final label = tester.widget<RichText>(find.byType(RichText));
    expect(label.text.style!.color, const Color(0xFFFEDCBA));
  });
  testWidgets('모든 variant는 비활성·로딩 색상을 라이트·다크에서 구분한다', (tester) async {
    for (final theme in [BrianThemeData.light, BrianThemeData.dark]) {
      final bg = theme.colors.background;
      for (final variant in BrianButtonVariant.values) {
        final outline =
            variant == BrianButtonVariant.brandOutline ||
            variant == BrianButtonVariant.neutralOutline;
        await tester.pumpWidget(
          host(
            BrianButton(
              onPressed: null,
              variant: variant,
              child: const Text('저장'),
            ),
            theme: theme,
          ),
        );
        await tester.pump(const Duration(milliseconds: 200));
        expect(
          background(tester),
          outline || variant == BrianButtonVariant.ghost
              ? bg.transparent
              : bg.disabled,
        );
        final text = tester.widget<RichText>(find.byType(RichText));
        expect(text.text.style!.color, theme.colors.foreground.disabled);
        await tester.pumpWidget(
          host(
            BrianButton(
              onPressed: null,
              variant: variant,
              isLoading: true,
              child: const Text('저장'),
            ),
            theme: theme,
          ),
        );
        await tester.pump(const Duration(milliseconds: 200));
        expect(background(tester), switch (variant) {
          BrianButtonVariant.brandSolid => bg.brandSolidPressed,
          BrianButtonVariant.neutralSolid => bg.neutralSolidPressed,
          BrianButtonVariant.neutralWeak => bg.neutralWeakPressed,
          BrianButtonVariant.criticalSolid => bg.criticalSolidPressed,
          BrianButtonVariant.ghost => bg.transparentPressed,
          _ => bg.transparent,
        });
      }
    }
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('포커스 중 비활성화·로딩으로 바뀌면 키보드 실행을 막는다', (tester) async {
    var calls = 0;
    final focus = FocusNode();
    addTearDown(focus.dispose);
    Widget button({bool disabled = false, bool loading = false}) => host(
      BrianButton(
        focusNode: focus,
        onPressed: disabled ? null : () => calls++,
        isLoading: loading,
        child: const Text('실행'),
      ),
    );
    await tester.pumpWidget(button());
    focus.requestFocus();
    await tester.pump();
    await tester.sendKeyDownEvent(LogicalKeyboardKey.space);
    await tester.sendKeyRepeatEvent(LogicalKeyboardKey.space);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.space);
    expect(calls, 1);
    await tester.pumpWidget(button(loading: true));
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    expect(calls, 1);
    await tester.pumpWidget(button());
    focus.requestFocus();
    await tester.pump();
    await tester.pumpWidget(button(disabled: true));
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    expect(calls, 1);
  });

  testWidgets('모션 감소에서는 로딩 표시가 회전하지 않는다', (tester) async {
    await tester.pumpWidget(
      host(
        MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: BrianButton(
            onPressed: () {},
            isLoading: true,
            child: const Text('저장'),
          ),
        ),
      ),
    );
    final rotation = tester.widget<RotationTransition>(
      find.byType(RotationTransition),
    );
    final before = rotation.turns.value;
    await tester.pump(const Duration(milliseconds: 300));
    expect(rotation.turns.value, before);
    expect(tester.binding.hasScheduledFrame, isFalse);
  });
  testWidgets('누름 전환은 중간 색상·축소를 거치며 취소 시 복원된다', (tester) async {
    await tester.pumpWidget(
      host(BrianButton(onPressed: () {}, child: const Text('저장'))),
    );
    final before = tester.getSize(surface);
    final gesture = await tester.startGesture(tester.getCenter(surface));
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 50));
    final scale = tester
        .widget<ScaleTransition>(find.byType(ScaleTransition))
        .scale
        .value;
    expect(scale, greaterThan(0.97));
    expect(scale, lessThan(1));
    expect(
      background(tester),
      isNot(BrianColors.light.background.neutralSolid),
    );
    expect(
      background(tester),
      isNot(BrianColors.light.background.neutralSolidPressed),
    );
    expect(tester.getSize(surface), before);
    await gesture.cancel();
    await tester.pumpAndSettle();
    expect(
      tester.widget<ScaleTransition>(find.byType(ScaleTransition)).scale.value,
      1,
    );
    expect(background(tester), BrianColors.light.background.neutralSolid);
  });

  testWidgets('모션 감소를 켜면 진행 중인 축소를 복원하고 색상을 즉시 적용한다', (tester) async {
    Widget button(bool reduce) => host(
      MediaQuery(
        data: MediaQueryData(disableAnimations: reduce),
        child: BrianButton(onPressed: () {}, child: const Text('저장')),
      ),
    );
    await tester.pumpWidget(button(false));
    final gesture = await tester.startGesture(tester.getCenter(surface));
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pumpWidget(button(true));
    await tester.pump();
    expect(
      tester.widget<ScaleTransition>(find.byType(ScaleTransition)).scale.value,
      1,
    );
    expect(
      background(tester),
      BrianColors.light.background.neutralSolidPressed,
    );
    await gesture.up();
    await tester.pump();
    await tester.pump();
    expect(background(tester), BrianColors.light.background.neutralSolid);
    expect(tester.binding.hasScheduledFrame, isFalse);
  });

  testWidgets('키보드를 누르는 동안 축소하고 키를 놓으면 복원한다', (tester) async {
    final node = FocusNode();
    addTearDown(node.dispose);
    await tester.pumpWidget(
      host(
        BrianButton(focusNode: node, onPressed: () {}, child: const Text('저장')),
      ),
    );
    node.requestFocus();
    await tester.pump();
    await tester.sendKeyDownEvent(LogicalKeyboardKey.space);
    await tester.pumpAndSettle();
    expect(
      tester.widget<ScaleTransition>(find.byType(ScaleTransition)).scale.value,
      0.97,
    );
    await tester.sendKeyUpEvent(LogicalKeyboardKey.space);
    await tester.pumpAndSettle();
    expect(
      tester.widget<ScaleTransition>(find.byType(ScaleTransition)).scale.value,
      1,
    );
  });
}

double contrast(Color foreground, Color background) {
  final a = Color.alphaBlend(foreground, background).computeLuminance();
  final b = background.computeLuminance();
  return a > b ? (a + 0.05) / (b + 0.05) : (b + 0.05) / (a + 0.05);
}
