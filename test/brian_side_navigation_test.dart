import 'dart:ui' show PointerDeviceKind, Tristate;

import 'package:brian_ui/brian_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

const groups = [
  BrianSideNavigationGroup(
    label: '작업',
    items: [
      BrianSideNavigationItem(value: 'home', label: '홈'),
      BrianSideNavigationItem(
        value: 'project',
        label: '프로젝트',
        children: [
          BrianSideNavigationItem(value: 'active', label: '진행 중'),
          BrianSideNavigationItem(value: 'archive', label: '보관함'),
        ],
      ),
      BrianSideNavigationItem(value: 'disabled', label: '준비 중', enabled: false),
    ],
  ),
];

Widget host(
  Widget child, {
  bool dark = false,
  double scale = 1,
  bool reduceMotion = false,
  TextDirection direction = TextDirection.ltr,
}) => WidgetsApp(
  color: const Color(0xFFFFFFFF),
  builder: (context, _) => BrianTheme(
    data: dark ? BrianThemeData.dark : BrianThemeData.light,
    child: MediaQuery(
      data: MediaQueryData(
        size: const Size(800, 600),
        textScaler: TextScaler.linear(scale),
        disableAnimations: reduceMotion,
      ),
      child: Directionality(
        textDirection: direction,
        child: Overlay(
          initialEntries: [
            OverlayEntry(
              builder: (_) => ColoredBox(
                color: const Color(0xFFFFFFFF),
                child: Center(child: SizedBox(height: 400, child: child)),
              ),
            ),
          ],
        ),
      ),
    ),
  ),
);

Finder button(String label) =>
    find.byWidgetPredicate((w) => w is BrianButton && w.semanticLabel == label);

void main() {
  testWidgets('부모는 펼침만 전환하고 선택·비활성 계약을 지킨다', (tester) async {
    final calls = <String>[];
    String? selected;
    await tester.pumpWidget(
      host(
        StatefulBuilder(
          builder: (context, setState) => BrianSideNavigation(
            groups: groups,
            selectedValue: selected,
            onSelected: (value) => setState(() {
              selected = value;
              calls.add(value);
            }),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('진행 중'), findsNothing);
    await tester.tap(button('프로젝트'));
    await tester.pumpAndSettle();
    expect(calls, isEmpty);
    await tester.tap(button('진행 중'));
    await tester.pumpAndSettle();
    expect(calls, ['active']);
    await tester.tap(button('프로젝트'));
    await tester.pumpAndSettle();
    expect(find.text('진행 중'), findsNothing);
    expect(selected, 'active');
    await tester.tap(button('프로젝트'));
    await tester.pumpAndSettle();
    expect(find.text('진행 중'), findsOneWidget);
    await tester.tap(button('준비 중'));
    expect(calls, ['active']);
    expect(tester.takeException(), isNull);
  });

  testWidgets('외부 선택 변경은 자동으로 부모를 연다', (tester) async {
    String? selected;
    late StateSetter update;
    await tester.pumpWidget(
      host(
        StatefulBuilder(
          builder: (context, setState) {
            update = setState;
            return BrianSideNavigation(
              groups: groups,
              selectedValue: selected,
              onSelected: (_) {},
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    update(() => selected = 'archive');
    await tester.pumpAndSettle();
    expect(find.text('보관함'), findsOneWidget);
    final semantics = tester.ensureSemantics();
    expect(
      tester
          .getSemantics(button('보관함'))
          .getSemanticsData()
          .flagsCollection
          .isSelected,
      Tristate.isTrue,
    );
    semantics.dispose();
  });

  testWidgets('선택한 자식의 부모를 접으면 재빌드 후에도 유지하고 새 선택 시 연다', (tester) async {
    var selected = 'active';
    var collapsed = false;
    late StateSetter update;
    await tester.pumpWidget(
      host(
        StatefulBuilder(
          builder: (context, setState) {
            update = setState;
            return BrianSideNavigation(
              groups: groups,
              selectedValue: selected,
              collapsed: collapsed,
              onSelected: (_) {},
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('진행 중'), findsOneWidget);
    await tester.tap(button('프로젝트'));
    await tester.pumpAndSettle();
    expect(find.text('진행 중'), findsNothing);
    update(() {});
    await tester.pumpAndSettle();
    expect(find.text('진행 중'), findsNothing);
    update(() => collapsed = true);
    await tester.pumpAndSettle();
    update(() => collapsed = false);
    await tester.pumpAndSettle();
    expect(find.text('진행 중'), findsNothing);
    update(() => selected = 'archive');
    await tester.pumpAndSettle();
    expect(find.text('보관함'), findsOneWidget);
    final semantics = tester.ensureSemantics();
    expect(
      tester
          .getSemantics(button('보관함'))
          .getSemanticsData()
          .flagsCollection
          .isSelected,
      Tristate.isTrue,
    );
    semantics.dispose();
  });

  for (final dark in [false, true]) {
    testWidgets('선택한 하위 메뉴를 접으면 부모에 선택 강조를 표시한다 ($dark)', (tester) async {
      final calls = <String>[];
      await tester.pumpWidget(
        host(
          BrianSideNavigation(
            groups: groups,
            selectedValue: 'active',
            onSelected: calls.add,
          ),
          dark: dark,
        ),
      );
      await tester.pumpAndSettle();
      final semantics = tester.ensureSemantics();
      expect(
        tester.widget<BrianButton>(button('프로젝트')).variant,
        BrianButtonVariant.ghost,
      );
      expect(
        tester.widget<BrianButton>(button('진행 중')).variant,
        BrianButtonVariant.neutralWeak,
      );
      await tester.tap(button('프로젝트'));
      await tester.pumpAndSettle();
      expect(
        tester.widget<BrianButton>(button('프로젝트')).variant,
        BrianButtonVariant.neutralWeak,
      );
      expect(
        tester
            .getSemantics(button('프로젝트'))
            .getSemanticsData()
            .flagsCollection
            .isSelected,
        Tristate.isTrue,
      );
      expect(
        tester.widget<BrianButton>(button('홈')).variant,
        BrianButtonVariant.ghost,
      );
      await tester.tap(button('프로젝트'));
      await tester.pumpAndSettle();
      expect(
        tester.widget<BrianButton>(button('프로젝트')).variant,
        BrianButtonVariant.ghost,
      );
      expect(
        tester
            .getSemantics(button('프로젝트'))
            .getSemanticsData()
            .flagsCollection
            .isSelected,
        Tristate.isFalse,
      );
      expect(
        tester.widget<BrianButton>(button('진행 중')).variant,
        BrianButtonVariant.neutralWeak,
      );
      expect(calls, isEmpty);
      semantics.dispose();
    });
  }

  testWidgets('접힌 부모는 키보드로 열고 Escape로 포커스를 복원한다', (tester) async {
    final calls = <String>[];
    await tester.pumpWidget(
      host(
        BrianSideNavigation(
          groups: groups,
          collapsed: true,
          onSelected: calls.add,
        ),
      ),
    );
    await tester.pumpAndSettle();
    tester.widget<BrianButton>(button('홈')).focusNode!.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    expect(
      tester.widget<BrianButton>(button('프로젝트')).focusNode!.hasFocus,
      isTrue,
    );
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(find.text('진행 중'), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.text('진행 중'), findsNothing);
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(calls, ['active']);
    expect(find.text('진행 중'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('접힌 메뉴는 호버 이름·팝업과 바깥 클릭 닫기를 제공한다', (tester) async {
    await tester.pumpWidget(
      host(
        BrianSideNavigation(
          groups: groups,
          collapsed: true,
          onSelected: (_) {},
        ),
      ),
    );
    await tester.pumpAndSettle();
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(tester.getCenter(button('홈')));
    await tester.pumpAndSettle();
    expect(find.text('홈'), findsWidgets);
    await mouse.moveTo(tester.getCenter(button('프로젝트')));
    await tester.pumpAndSettle();
    expect(find.text('진행 중'), findsOneWidget);
    await mouse.moveTo(tester.getCenter(button('진행 중')));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('진행 중'), findsOneWidget);
    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();
    expect(find.text('진행 중'), findsNothing);
    await mouse.removePointer();
  });

  testWidgets('다른 접힌 항목으로 이동하면 이전 팝업을 즉시 닫는다', (tester) async {
    await tester.pumpWidget(
      host(
        BrianSideNavigation(
          groups: groups,
          collapsed: true,
          onSelected: (_) {},
        ),
      ),
    );
    await tester.pumpAndSettle();
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(tester.getCenter(button('프로젝트')));
    await tester.pump();
    expect(find.text('진행 중'), findsOneWidget);
    await mouse.moveTo(tester.getCenter(button('홈')));
    await tester.pump();
    expect(find.text('진행 중'), findsNothing);
    expect(find.text('홈'), findsNWidgets(2));
    await mouse.moveTo(tester.getCenter(button('프로젝트')));
    await tester.pump();
    expect(find.text('홈'), findsOneWidget);
    expect(find.text('진행 중'), findsOneWidget);
    // 버튼과 팝업 사이를 건너가는 동안에는 하위 메뉴를 유지합니다.
    final edge = tester.getTopRight(button('프로젝트'));
    await mouse.moveTo(edge + const Offset(8, 10));
    await tester.pump(const Duration(milliseconds: 60));
    expect(find.text('진행 중'), findsOneWidget);
    await mouse.moveTo(tester.getCenter(button('진행 중')));
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('진행 중'), findsOneWidget);
    await mouse.moveTo(const Offset(10, 10));
    await tester.pump(const Duration(milliseconds: 120));
    expect(find.text('진행 중'), findsNothing);
    await mouse.removePointer();
  });

  testWidgets('문서의 상위 스크롤이 움직이면 열린 팝업을 닫는다', (tester) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      host(
        SingleChildScrollView(
          controller: controller,
          child: Column(
            children: [
              SizedBox(
                height: 300,
                child: BrianSideNavigation(
                  groups: groups,
                  collapsed: true,
                  onSelected: (_) {},
                ),
              ),
              const SizedBox(height: 1000),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(button('프로젝트'));
    await tester.pumpAndSettle();
    expect(find.text('진행 중'), findsOneWidget);
    controller.jumpTo(60);
    await tester.pumpAndSettle();
    expect(find.text('진행 중'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('열린 팝업은 외부 선택 변경 시 안전하게 닫힌다', (tester) async {
    String? selected;
    late StateSetter update;
    await tester.pumpWidget(
      host(
        StatefulBuilder(
          builder: (context, setState) {
            update = setState;
            return BrianSideNavigation(
              groups: groups,
              collapsed: true,
              selectedValue: selected,
              onSelected: (_) {},
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(button('프로젝트'));
    await tester.pumpAndSettle();
    expect(find.text('진행 중'), findsOneWidget);
    update(() => selected = 'archive');
    await tester.pumpAndSettle();
    expect(find.text('진행 중'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('접기는 부모가 갱신해야 반영하고 선택한 자식을 복원한다', (tester) async {
    var collapsed = false;
    bool? requested;
    late StateSetter update;
    await tester.pumpWidget(
      host(
        StatefulBuilder(
          builder: (context, setState) {
            update = setState;
            return BrianSideNavigation(
              groups: groups,
              collapsed: collapsed,
              selectedValue: 'active',
              onSelected: (_) {},
              onCollapsedChanged: (value) => requested = value,
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(button('메뉴 접기'));
    await tester.pumpAndSettle();
    expect(requested, isTrue);
    expect(find.text('진행 중'), findsOneWidget);
    update(() => collapsed = requested!);
    await tester.pumpAndSettle();
    expect(find.text('진행 중'), findsNothing);
    await tester.tap(button('메뉴 펼치기'));
    update(() => collapsed = requested!);
    await tester.pumpAndSettle();
    expect(find.text('진행 중'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('내용만 스크롤하고 헤더·푸터 위치는 고정된다', (tester) async {
    await tester.pumpWidget(
      host(
        BrianSideNavigation(
          header: const Text('고정 헤더'),
          footer: const Text('고정 푸터'),
          groups: [
            BrianSideNavigationGroup(
              items: [
                for (var i = 0; i < 30; i++)
                  BrianSideNavigationItem(value: '$i', label: '메뉴 $i'),
              ],
            ),
          ],
          onSelected: (_) {},
        ),
      ),
    );
    await tester.pumpAndSettle();
    final header = tester.getTopLeft(find.text('고정 헤더'));
    final footer = tester.getTopLeft(find.text('고정 푸터'));
    expect(find.byType(BrianScrollFog), findsOneWidget);
    await tester.drag(find.byType(ListView), const Offset(0, -2000));
    await tester.pumpAndSettle();
    expect(tester.getTopLeft(find.text('고정 헤더')), header);
    expect(tester.getTopLeft(find.text('고정 푸터')), footer);
    expect(find.byType(BrianScrollFog), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('초기 펼침은 한 번만 적용하고 사용자 선택을 유지한다', (tester) async {
    late StateSetter rebuild;
    await tester.pumpWidget(
      host(
        StatefulBuilder(
          builder: (context, update) {
            rebuild = update;
            return BrianSideNavigation(
              groups: groups,
              initialExpandedValues: const {'project'},
              onSelected: (_) {},
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('진행 중'), findsOneWidget);
    await tester.tap(button('프로젝트'));
    await tester.pumpAndSettle();
    rebuild(() {});
    await tester.pumpAndSettle();
    expect(find.text('진행 중'), findsNothing);
  });

  for (final dark in [false, true]) {
    testWidgets('팝업은 테두리 없이 테마의 Elevation을 사용한다 ($dark)', (tester) async {
      await tester.pumpWidget(
        host(
          BrianSideNavigation(
            groups: groups,
            collapsed: true,
            onSelected: (_) {},
          ),
          dark: dark,
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(button('프로젝트'));
      await tester.pumpAndSettle();
      final popup = tester.widget<Container>(
        find.byWidgetPredicate(
          (w) =>
              w is Container &&
              w.decoration is BoxDecoration &&
              (w.decoration! as BoxDecoration).boxShadow != null,
        ),
      );
      final decoration = popup.decoration! as BoxDecoration;
      final theme = dark ? BrianThemeData.dark : BrianThemeData.light;
      expect(
        tester.getTopLeft(find.byWidget(popup)).dx -
            tester.getTopRight(button('프로젝트')).dx,
        BrianSpacing.x4,
      );
      expect(decoration.border, isNull);
      expect(decoration.boxShadow, [theme.shadows.s3]);
      expect(decoration.color, theme.colors.background.layerFloating);
    });
  }

  for (final direction in [TextDirection.ltr, TextDirection.rtl]) {
    testWidgets('접힌 아이콘과 접기 버튼은 영역 중앙에 놓인다 ($direction)', (tester) async {
      await tester.pumpWidget(
        host(
          BrianSideNavigation(
            collapsed: true,
            onCollapsedChanged: (_) {},
            groups: const [
              BrianSideNavigationGroup(
                items: [
                  BrianSideNavigationItem(
                    value: 'icon',
                    label: '아이콘',
                    icon: SizedBox.square(
                      key: ValueKey('menu-icon'),
                      dimension: 20,
                    ),
                  ),
                ],
              ),
            ],
            onSelected: (_) {},
          ),
          direction: direction,
        ),
      );
      await tester.pumpAndSettle();
      expect(
        tester.getSize(find.byKey(const ValueKey('menu-icon'))),
        const Size(20, 20),
      );
      expect(
        tester.getCenter(find.byKey(const ValueKey('menu-icon'))),
        tester.getCenter(button('아이콘')),
      );
      final glyph = find.descendant(
        of: button('메뉴 펼치기'),
        matching: find.byType(CustomPaint),
      );
      expect(tester.getCenter(glyph), tester.getCenter(button('메뉴 펼치기')));
      expect(
        tester.getCenter(button('메뉴 펼치기')).dx,
        tester.getCenter(button('아이콘')).dx,
      );
    });
  }

  testWidgets('메뉴는 Regular, 선택 메뉴와 그룹은 Medium을 사용한다', (tester) async {
    await tester.pumpWidget(
      host(
        BrianSideNavigation(
          groups: groups,
          selectedValue: 'home',
          onSelected: (_) {},
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      DefaultTextStyle.of(tester.element(find.text('홈'))).style.fontWeight,
      FontWeight.w500,
    );
    expect(
      DefaultTextStyle.of(tester.element(find.text('프로젝트'))).style.fontWeight,
      FontWeight.w400,
    );
    expect(
      tester.widget<Text>(find.text('작업')).style!.fontWeight,
      FontWeight.w500,
    );
  });

  testWidgets('하위 메뉴 높이와 화살표는 중간 프레임을 거쳐 전환된다', (tester) async {
    await tester.pumpWidget(
      host(BrianSideNavigation(groups: groups, onSelected: (_) {})),
    );
    await tester.pumpAndSettle();
    final before = tester.getTopLeft(button('준비 중')).dy;
    await tester.tap(button('프로젝트'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 90));
    final middle = tester.getTopLeft(button('준비 중')).dy;
    final rotation = find.descendant(
      of: button('프로젝트'),
      matching: find.byType(RotationTransition),
    );
    final turns = tester.widget<RotationTransition>(rotation).turns.value;
    expect(turns, greaterThan(0));
    expect(turns, lessThan(0.5));
    await tester.pumpAndSettle();
    final after = tester.getTopLeft(button('준비 중')).dy;
    expect(middle, greaterThan(before));
    expect(middle, lessThan(after));
    await tester.tap(button('프로젝트'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 90));
    expect(
      tester.getTopLeft(button('준비 중')).dy,
      inExclusiveRange(before, after),
    );
    await tester.pumpAndSettle();
    expect(find.text('진행 중'), findsNothing);
    expect(tester.getTopLeft(button('준비 중')).dy, closeTo(before, 0.01));
  });

  for (final reduceMotion in [false, true]) {
    testWidgets('너비 전환은 모션 감소 설정을 따른다 ($reduceMotion)', (tester) async {
      var collapsed = false;
      await tester.pumpWidget(
        host(
          StatefulBuilder(
            builder: (context, update) => BrianSideNavigation(
              groups: groups,
              collapsed: collapsed,
              onSelected: (_) {},
              onCollapsedChanged: (value) => update(() => collapsed = value),
            ),
          ),
          reduceMotion: reduceMotion,
        ),
      );
      await tester.pumpAndSettle();
      final nav = find.byType(BrianSideNavigation);
      await tester.tap(button('메뉴 접기'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 90));
      expect(
        tester.getSize(nav).width,
        reduceMotion ? 64 : inExclusiveRange(64, 256),
      );
      await tester.pumpAndSettle();
      expect(tester.getSize(nav).width, 64);
      await tester.tap(button('메뉴 펼치기'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 90));
      expect(
        tester.getSize(nav).width,
        reduceMotion ? 256 : inExclusiveRange(64, 256),
      );
      await tester.pumpAndSettle();
      await tester.tap(button('프로젝트'));
      await tester.pump();
      if (reduceMotion) {
        expect(find.text('진행 중'), findsOneWidget);
        expect(tester.binding.transientCallbackCount, 0);
      }
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }

  for (final dark in [false, true]) {
    testWidgets('긴 라벨과 확대 글자·RTL에서 넘치지 않는다 ($dark)', (tester) async {
      await tester.pumpWidget(
        host(
          BrianSideNavigation(
            width: 220,
            groups: const [
              BrianSideNavigationGroup(
                items: [
                  BrianSideNavigationItem(
                    value: 'long',
                    label: '팀 구성원과 함께 관리하는 프로젝트와 공유 문서의 긴 이름',
                  ),
                ],
              ),
            ],
            onSelected: (_) {},
          ),
          dark: dark,
          scale: 2,
          direction: TextDirection.rtl,
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }
}
