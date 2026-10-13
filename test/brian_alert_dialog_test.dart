import 'dart:async';

import 'package:brian_ui/brian_ui.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

const confirm = BrianAlertDialogAction(label: '확인', value: true);
const cancel = BrianAlertDialogAction(
  label: '취소',
  value: false,
  variant: BrianButtonVariant.neutralWeak,
);

Widget host(
  Widget child, {
  double scale = 1,
  TextDirection direction = TextDirection.ltr,
  BrianThemeData? theme,
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

BrianAlertDialog<bool> dialog({
  BrianAlertDialogAction<bool> primary = confirm,
  BrianAlertDialogAction<bool>? secondary = cancel,
}) => BrianAlertDialog<bool>(
  title: '변경 사항',
  description: '변경 사항을 저장할까요?',
  primaryAction: primary,
  secondaryAction: secondary,
  onSelected: (_) {},
);

Finder get buttons => find.byType(BrianButton);
Rect rect(WidgetTester tester, int index) => tester.getRect(buttons.at(index));

void main() {
  testWidgets('하나의 버튼은 전체 너비, 짧은 두 버튼은 같은 너비의 가로 배치', (tester) async {
    await tester.pumpWidget(host(dialog(secondary: null)));
    expect(buttons, findsOneWidget);
    expect(rect(tester, 0).width, 232);
    await tester.pumpWidget(host(dialog()));
    expect(rect(tester, 0).top, rect(tester, 1).top);
    expect(rect(tester, 0).width, rect(tester, 1).width);
    expect(rect(tester, 0).width, 112);
  });

  testWidgets('어느 한쪽이라도 두 줄이면 주요·보조 순서의 전체 너비 세로 배치로 전환한다', (tester) async {
    const long = BrianAlertDialogAction(
      label: '변경 사항을 저장하고 계속 진행하기',
      value: true,
    );
    for (final item in [dialog(primary: long), dialog(secondary: long)]) {
      await tester.pumpWidget(host(item));
      expect(rect(tester, 0).bottom, lessThan(rect(tester, 1).top));
      expect(
        (tester.widget<BrianButton>(buttons.at(0)).child as Text).data,
        item.primaryAction.label,
      );
      expect(
        (tester.widget<BrianButton>(buttons.at(1)).child as Text).data,
        item.secondaryAction!.label,
      );
      expect(rect(tester, 0).width, 232);
      expect(rect(tester, 1).width, 232);
      expect(tester.takeException(), isNull);
    }
    await tester.pumpWidget(host(dialog()));
    expect(rect(tester, 0).top, rect(tester, 1).top);
  });

  testWidgets('명시적 줄바꿈과 글자 확대도 세로 전환에 반영한다', (tester) async {
    await tester.pumpWidget(
      host(
        dialog(
          primary: const BrianAlertDialogAction(label: '확인\n하기', value: true),
        ),
      ),
    );
    expect(rect(tester, 0).bottom, lessThan(rect(tester, 1).top));
    await tester.pumpWidget(host(dialog(), scale: 4));
    expect(rect(tester, 0).bottom, lessThan(rect(tester, 1).top));
    expect(rect(tester, 0).height, greaterThan(40));
    expect(tester.takeException(), isNull);
  });

  testWidgets('RTL에서는 보조 액션이 오른쪽에 놓인다', (tester) async {
    await tester.pumpWidget(host(dialog(), direction: TextDirection.rtl));
    expect(rect(tester, 0).left, greaterThan(rect(tester, 1).left));
  });

  testWidgets('제목 없이 설명과 버튼을 제공하고 선택 값을 전달한다', (tester) async {
    bool? selected;
    await tester.pumpWidget(
      host(
        BrianAlertDialog<bool>(
          description: '완료했습니다.',
          primaryAction: confirm,
          onSelected: (value) => selected = value,
        ),
      ),
    );
    await tester.tap(find.text('확인'));
    expect(selected, isTrue);
    final semantics = tester.ensureSemantics();
    expect(
      tester.getSemantics(find.text('확인')),
      matchesSemantics(
        label: '확인',
        isButton: true,
        hasEnabledState: true,
        isEnabled: true,
        isFocusable: true,
        hasTapAction: true,
        hasFocusAction: true,
      ),
    );
    semantics.dispose();
  });

  testWidgets('라이트·다크에서 표면과 본문에 역할 색상을 적용한다', (tester) async {
    for (final theme in [BrianThemeData.light, BrianThemeData.dark]) {
      await tester.pumpWidget(host(dialog(), theme: theme));
      final surface = tester.widget<Container>(
        find.descendant(
          of: find.byType(BrianAlertDialog<bool>),
          matching: find.byWidgetPredicate(
            (w) => w is Container && w.decoration is BoxDecoration,
          ),
        ),
      );
      expect(
        (surface.decoration! as BoxDecoration).color,
        theme.colors.background.layerFloating,
      );
      final paragraph = tester.renderObject<RenderParagraph>(
        find.text('변경 사항을 저장할까요?'),
      );
      expect(paragraph.text.style!.color, theme.colors.foreground.neutral);
    }
  });

  testWidgets('바깥 터치·뒤로가기·Esc는 무시하고 버튼 결과로만 닫힌다', (tester) async {
    for (final choice in [false, true]) {
      bool? result;
      var completed = false;
      await tester.pumpWidget(
        routeHost(
          onResult: (value) {
            result = value;
            completed = true;
          },
        ),
      );
      await tester.tap(find.text('열기'));
      await tester.pumpAndSettle();
      await tester.tapAt(const Offset(5, 5));
      await tester.binding.handlePopRoute();
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.byType(BrianAlertDialog<bool>), findsOneWidget);
      expect(completed, isFalse);
      await tester.tap(find.text(choice ? '확인' : '취소'));
      await tester.pumpAndSettle();
      expect(completed, isTrue);
      expect(result, choice);
      expect(find.byType(BrianAlertDialog<bool>), findsNothing);
      await tester.pumpWidget(const SizedBox.shrink());
    }
  });

  testWidgets('포커스는 보조 액션에서 시작하고 순환한 뒤 호출 버튼으로 복귀한다', (tester) async {
    final opener = FocusNode();
    addTearDown(opener.dispose);
    await tester.pumpWidget(routeHost(opener: opener));
    opener.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    String? focusedLabel() {
      final widget = FocusManager.instance.primaryFocus?.context
          ?.findAncestorWidgetOfExactType<BrianButton>();
      return (widget?.child as Text?)?.data;
    }

    expect(focusedLabel(), '취소');
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    expect(focusedLabel(), '확인');
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    expect(focusedLabel(), '취소');
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pumpAndSettle();
    expect(find.byType(BrianAlertDialog<bool>), findsNothing);
    expect(opener.hasFocus, isTrue);
  });

  testWidgets('비동기 액션은 로딩 중 중복 입력을 막고 완료 후 선택한다', (tester) async {
    for (final choice in [true, false]) {
      final work = Completer<void>();
      var calls = 0;
      bool? result;
      Future<void> submit() {
        calls++;
        return work.future;
      }

      await tester.pumpWidget(
        routeHost(
          primary: BrianAlertDialogAction(
            label: '확인',
            value: true,
            onPressed: submit,
          ),
          secondary: BrianAlertDialogAction(
            label: '취소',
            value: false,
            onPressed: submit,
          ),
          onResult: (value) => result = value,
        ),
      );
      await tester.tap(find.text('열기'));
      await tester.pumpAndSettle();
      final selected = find.widgetWithText(BrianButton, choice ? '확인' : '취소');
      final other = find.widgetWithText(BrianButton, choice ? '취소' : '확인');
      await tester.tap(selected);
      await tester.pump();
      expect(tester.widget<BrianButton>(selected).isLoading, isTrue);
      expect(tester.widget<BrianButton>(other).onPressed, isNull);
      await tester.tap(other);
      await tester.tap(selected);
      await tester.binding.handlePopRoute();
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      expect(calls, 1);
      expect(result, isNull);
      expect(find.byType(BrianAlertDialog<bool>), findsOneWidget);
      work.complete();
      await tester.pumpAndSettle();
      expect(result, choice);
      expect(find.byType(BrianAlertDialog<bool>), findsNothing);
      await tester.pumpWidget(const SizedBox.shrink());
    }
  });

  testWidgets('비동기 실패는 닫지 않고 오류를 보고한 뒤 재시도할 수 있다', (tester) async {
    var attempts = 0;
    await tester.pumpWidget(
      routeHost(
        primary: BrianAlertDialogAction(
          label: '확인',
          value: true,
          onPressed: () async {
            if (attempts++ == 0) throw StateError('저장 실패');
          },
        ),
      ),
    );
    await tester.tap(find.text('열기'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('확인'));
    await tester.pump();
    expect(tester.takeException(), isA<StateError>());
    expect(find.byType(BrianAlertDialog<bool>), findsOneWidget);
    expect(
      tester
          .widget<BrianButton>(find.widgetWithText(BrianButton, '확인'))
          .isLoading,
      isFalse,
    );
    await tester.tap(find.text('확인'));
    await tester.pumpAndSettle();
    expect(attempts, 2);
    expect(find.byType(BrianAlertDialog<bool>), findsNothing);
  });

  testWidgets('비동기 작업 중 제거되어도 완료 후 상태나 다른 라우트를 변경하지 않는다', (tester) async {
    final work = Completer<void>();
    var selected = false;
    await tester.pumpWidget(
      host(
        BrianAlertDialog<bool>(
          description: '처리 중',
          primaryAction: BrianAlertDialogAction(
            label: '확인',
            value: true,
            onPressed: () => work.future,
          ),
          onSelected: (_) => selected = true,
        ),
      ),
    );
    await tester.tap(find.text('확인'));
    await tester.pump();
    await tester.pumpWidget(const SizedBox.shrink());
    work.complete();
    await tester.pump();
    expect(selected, isFalse);
    expect(tester.takeException(), isNull);
  });

  testWidgets('가려진 다이얼로그의 작업이 완료되면 해당 라우트만 결과와 함께 닫는다', (tester) async {
    final work = Completer<void>();
    bool? result;
    await tester.pumpWidget(
      routeHost(
        primary: BrianAlertDialogAction(
          label: '확인',
          value: true,
          onPressed: () => work.future,
        ),
        onResult: (value) => result = value,
      ),
    );
    await tester.tap(find.text('열기'));
    await tester.pumpAndSettle();
    final navigator = Navigator.of(
      tester.element(find.byType(BrianAlertDialog<bool>)),
    );
    await tester.tap(find.text('확인'));
    await tester.pump();
    final cover = PageRouteBuilder<void>(
      pageBuilder: (_, _, _) => const Text('다른 화면'),
    );
    navigator.push(cover);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    work.complete();
    await tester.pumpAndSettle();
    expect(result, isTrue);
    expect(cover.isCurrent, isTrue);
    expect(find.text('다른 화면'), findsOneWidget);
    navigator.pop();
    await tester.pumpAndSettle();
    expect(find.text('열기'), findsOneWidget);
    expect(find.byType(BrianAlertDialog<bool>), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('본문을 직접 사용하면 가려진 라우트에서도 비동기 선택을 전달한다', (tester) async {
    final work = Completer<void>();
    var selections = 0;
    await tester.pumpWidget(
      WidgetsApp(
        color: const Color(0xFFFFFFFF),
        onGenerateRoute: (_) => PageRouteBuilder<void>(
          pageBuilder: (_, _, _) => BrianTheme(
            data: BrianThemeData.light,
            child: Center(
              child: BrianAlertDialog<bool>(
                description: '처리 중',
                primaryAction: BrianAlertDialogAction(
                  label: '확인',
                  value: true,
                  onPressed: () => work.future,
                ),
                onSelected: (value) {
                  expect(value, isTrue);
                  selections++;
                },
              ),
            ),
          ),
        ),
      ),
    );
    final navigator = Navigator.of(
      tester.element(find.byType(BrianAlertDialog<bool>)),
    );
    await tester.tap(find.text('확인'));
    await tester.pump();
    navigator.push(
      PageRouteBuilder<void>(pageBuilder: (_, _, _) => const Text('다른 화면')),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    work.complete();
    await tester.pumpAndSettle();
    expect(selections, 1);
    navigator.pop();
    await tester.pumpAndSettle();
    expect(tester.widget<BrianButton>(buttons).isLoading, isFalse);
    expect(tester.takeException(), isNull);
  });

  testWidgets('이미 pop한 다이얼로그의 작업 완료는 아래 라우트를 닫지 않는다', (tester) async {
    final work = Completer<void>();
    var results = 0;
    await tester.pumpWidget(
      routeHost(
        primary: BrianAlertDialogAction(
          label: '확인',
          value: true,
          onPressed: () => work.future,
        ),
        onResult: (value) {
          expect(value, isNull);
          results++;
        },
      ),
    );
    await tester.tap(find.text('열기'));
    await tester.pumpAndSettle();
    final context = tester.element(find.byType(BrianAlertDialog<bool>));
    await tester.tap(find.text('확인'));
    await tester.pump();
    Navigator.of(context).pop();
    // 종료 애니메이션 중에는 본문이 아직 mounted일 수 있습니다.
    work.complete();
    await tester.pumpAndSettle();
    expect(results, 1);
    expect(find.text('열기'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('가로 화면에 키보드가 열려 있어도 내용을 스크롤하고 선택할 수 있다', (tester) async {
    tester.view.physicalSize = const Size(640, 360);
    tester.view.devicePixelRatio = 1;
    tester.view.viewInsets = const FakeViewPadding(bottom: 250);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetViewInsets);
    await tester.pumpWidget(
      routeHost(description: List.filled(25, '긴 설명입니다.').join('\n')),
    );
    await tester.tap(find.text('열기'));
    await tester.pumpAndSettle();
    final viewport = tester.getRect(find.byType(SingleChildScrollView));
    expect(viewport.height, greaterThan(0));
    expect(viewport.top, greaterThanOrEqualTo(0));
    expect(viewport.bottom, lessThanOrEqualTo(110));
    await tester.scrollUntilVisible(find.text('확인'), 100);
    await tester.tap(find.text('확인'));
    await tester.pumpAndSettle();
    expect(find.byType(BrianAlertDialog<bool>), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('지역 테마를 라우트로 전달하고 긴 내용은 작은 화면에서 스크롤한다', (tester) async {
    tester.view.physicalSize = const Size(320, 400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      routeHost(description: List.filled(25, '긴 설명입니다.').join('\n')),
    );
    await tester.tap(find.text('열기'));
    await tester.pumpAndSettle();
    final context = tester.element(find.byType(BrianAlertDialog<bool>));
    expect(BrianTheme.of(context), BrianThemeData.dark);
    expect(tester.takeException(), isNull);
    await tester.scrollUntilVisible(find.text('확인'), 100);
    await tester.tap(find.text('확인'));
    await tester.pumpAndSettle();
    expect(find.byType(BrianAlertDialog<bool>), findsNothing);
  });
}

Widget routeHost({
  ValueChanged<bool?>? onResult,
  FocusNode? opener,
  String description = '변경 사항을 저장할까요?',
  BrianAlertDialogAction<bool> primary = confirm,
  BrianAlertDialogAction<bool> secondary = cancel,
}) => WidgetsApp(
  color: const Color(0xFFFFFFFF),
  onGenerateRoute: (_) => PageRouteBuilder<void>(
    pageBuilder: (context, _, _) => BrianTheme(
      data: BrianThemeData.dark,
      child: Builder(
        builder: (context) => Center(
          child: BrianButton(
            focusNode: opener,
            onPressed: () async {
              final result = await showBrianAlertDialog<bool>(
                context: context,
                title: '변경 사항',
                description: description,
                primaryAction: primary,
                secondaryAction: secondary,
              );
              onResult?.call(result);
            },
            child: const Text('열기'),
          ),
        ),
      ),
    ),
  ),
);
