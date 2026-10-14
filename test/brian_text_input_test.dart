import 'package:brian_ui/brian_ui.dart';
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform;
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
        child: Overlay.wrap(
          child: Center(child: SizedBox(width: 280, child: child)),
        ),
      ),
    ),
  ),
);

BoxDecoration decoration(WidgetTester tester) =>
    tester
            .widgetList<Container>(
              find.descendant(
                of: find.byType(BrianTextInput),
                matching: find.byType(Container),
              ),
            )
            .first
            .decoration!
        as BoxDecoration;

void main() {
  for (final multiline in [false, true]) {
    final component = multiline ? 'TextArea' : 'TextInput';
    testWidgets('$component 자동 완성 기본 참여와 명시적 제외를 구분한다', (tester) async {
      final inputs = multiline
          ? <Widget>[
              const BrianTextArea(),
              const BrianTextArea(autofillHints: null),
              const BrianTextArea(
                autofillHints: [AutofillHints.fullStreetAddress],
              ),
            ]
          : <Widget>[
              const BrianTextInput(),
              const BrianTextInput(autofillHints: null),
              const BrianTextInput(
                autofillHints: [AutofillHints.fullStreetAddress],
              ),
            ];
      for (var index = 0; index < inputs.length; index++) {
        await tester.pumpWidget(host(inputs[index]));
        final state = tester.state<EditableTextState>(
          find.byType(EditableText),
        );
        final configuration =
            state.textInputConfiguration.autofillConfiguration;
        expect(configuration.enabled, index != 1);
        if (index != 1) {
          expect(
            configuration.autofillHints,
            index == 0 ? <String>[] : [AutofillHints.fullStreetAddress],
          );
        }
      }
    });

    testWidgets('$component placeholder 접근성 안내는 빈 값일 때만 제공한다', (tester) async {
      final semantics = tester.ensureSemantics();
      final controller = TextEditingController(text: '기존 값');
      await tester.pumpWidget(
        host(
          multiline
              ? BrianTextArea(
                  controller: controller,
                  semanticLabel: '주소',
                  placeholder: '주소 입력',
                )
              : BrianTextInput(
                  controller: controller,
                  semanticLabel: '주소',
                  placeholder: '주소 입력',
                ),
        ),
      );
      String hint() => tester
          .getSemantics(find.byType(EditableText))
          .getSemanticsData()
          .hint;
      expect(hint(), isEmpty);
      controller.clear();
      await tester.pump();
      expect(hint(), '주소 입력');
      await tester.enterText(find.byType(EditableText), '새 주소');
      await tester.pump();
      expect(hint(), isEmpty);
      await tester.enterText(find.byType(EditableText), '');
      await tester.pump();
      expect(hint(), '주소 입력');
      await tester.pumpWidget(const SizedBox());
      controller.dispose();
      semantics.dispose();
    });
  }

  testWidgets('입력과 지우기는 값을 통지하고 외부 변경은 통지하지 않는다', (tester) async {
    final controller = TextEditingController();
    final focus = FocusNode();
    final values = <String>[];
    await tester.pumpWidget(
      host(
        BrianTextInput(
          controller: controller,
          focusNode: focus,
          placeholder: '검색',
          showClearButton: true,
          onChanged: values.add,
        ),
      ),
    );
    expect(find.text('검색'), findsOneWidget);
    await tester.enterText(find.byType(EditableText), '안녕');
    await tester.pump();
    expect(values, ['안녕']);
    expect(find.text('검색'), findsNothing);
    await tester.tap(find.byType(BrianButton));
    await tester.pump();
    expect(controller.text, isEmpty);
    expect(values, ['안녕', '']);
    expect(focus.hasFocus, isTrue);
    expect(find.byType(BrianButton), findsNothing);
    controller.text = '외부 변경';
    await tester.pump();
    expect(find.byType(BrianButton), findsOneWidget);
    expect(values, ['안녕', '']);
    await tester.pumpWidget(const SizedBox());
    controller.text = '호출자 소유';
    controller.dispose();
    focus.dispose();
  });

  testWidgets('컨트롤러와 포커스 노드를 교체하고 내부 값으로 이어받는다', (tester) async {
    final first = TextEditingController(text: '첫 값');
    final second = TextEditingController(text: '둘째 값');
    final focus = FocusNode();
    await tester.pumpWidget(
      host(BrianTextInput(controller: first, focusNode: focus)),
    );
    await tester.pumpWidget(host(BrianTextInput(controller: second)));
    first.text = '분리된 값';
    await tester.pump();
    expect(
      tester.widget<EditableText>(find.byType(EditableText)).controller.text,
      '둘째 값',
    );
    await tester.pumpWidget(host(const BrianTextInput()));
    expect(
      tester.widget<EditableText>(find.byType(EditableText)).controller.text,
      '둘째 값',
    );
    await tester.enterText(find.byType(EditableText), '내부 값');
    expect(second.text, '둘째 값');
    await tester.pumpWidget(
      host(BrianTextInput(controller: first, focusNode: focus)),
    );
    expect(
      tester.widget<EditableText>(find.byType(EditableText)).controller.text,
      '분리된 값',
    );
    await tester.pumpWidget(const SizedBox());
    first.dispose();
    second.dispose();
    focus.dispose();
    expect(tester.takeException(), isNull);
  });

  testWidgets('포매터와 제출을 전달하고 한 줄 입력의 줄바꿈을 제거한다', (tester) async {
    String? submitted;
    await tester.pumpWidget(
      host(
        BrianTextInput(
          onSubmitted: (value) => submitted = value,
          textInputAction: TextInputAction.done,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
      ),
    );
    await tester.enterText(find.byType(EditableText), '12a\n34');
    expect(
      tester.widget<EditableText>(find.byType(EditableText)).controller.text,
      '1234',
    );
    await tester.testTextInput.receiveAction(TextInputAction.done);
    expect(submitted, '1234');
  });

  testWidgets('읽기 전용은 선택을 허용하고 비활성화는 포커스를 제거한다', (tester) async {
    final focus = FocusNode();
    final controller = TextEditingController(text: '복사할 내용');
    await tester.pumpWidget(
      host(
        BrianTextInput(
          controller: controller,
          focusNode: focus,
          readOnly: true,
          showClearButton: true,
        ),
      ),
    );
    await tester.tap(find.byType(EditableText));
    await tester.pump();
    expect(focus.hasFocus, isTrue);
    expect(
      tester
          .widget<EditableText>(find.byType(EditableText))
          .enableInteractiveSelection,
      isTrue,
    );
    expect(find.byType(BrianButton), findsNothing);
    await tester.pumpWidget(
      host(
        BrianTextInput(
          controller: controller,
          focusNode: focus,
          enabled: false,
        ),
      ),
    );
    await tester.pump();
    expect(focus.hasFocus, isFalse);
    focus.requestFocus();
    await tester.pump();
    expect(focus.hasFocus, isFalse);
    expect(
      tester.widget<EditableText>(find.byType(EditableText)).readOnly,
      isTrue,
    );
    await tester.pumpWidget(const SizedBox());
    focus.dispose();
    controller.dispose();
  });

  testWidgets('라이트·다크의 오류는 포커스 중에도 유지되고 비활성 색상을 적용한다', (tester) async {
    for (final theme in [BrianThemeData.light, BrianThemeData.dark]) {
      final focus = FocusNode();
      await tester.pumpWidget(
        host(BrianTextInput(focusNode: focus, isInvalid: true), theme: theme),
      );
      final border = decoration(tester).border! as Border;
      expect(border.top.color, theme.colors.foreground.criticalContrast);
      focus.requestFocus();
      await tester.pump();
      expect(
        (decoration(tester).border! as Border).top.color,
        theme.colors.foreground.criticalContrast,
      );
      await tester.pumpWidget(
        host(BrianTextInput(focusNode: focus, enabled: false), theme: theme),
      );
      expect(
        tester.widget<EditableText>(find.byType(EditableText)).style.color,
        theme.colors.foreground.disabled,
      );
      await tester.pumpWidget(const SizedBox());
      focus.dispose();
    }
  });

  testWidgets('입력 중 테마 전환과 포커스 강조가 값과 크기를 유지한다', (tester) async {
    final controller = TextEditingController(text: '편집 중');
    final focus = FocusNode();
    await tester.pumpWidget(
      host(BrianTextInput(controller: controller, focusNode: focus)),
    );
    final size = tester.getSize(find.byType(BrianTextInput));
    await tester.tap(find.byType(EditableText));
    await tester.pump();
    expect(tester.getSize(find.byType(BrianTextInput)), size);
    await tester.pumpWidget(
      host(
        BrianTextInput(controller: controller, focusNode: focus),
        theme: BrianThemeData.dark,
      ),
    );
    await tester.pump();
    expect(focus.hasFocus, isTrue);
    expect(controller.text, '편집 중');
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    controller.dispose();
    focus.dispose();
  });

  testWidgets('접근성 이름과 오류 상태를 제공하고 숨김 입력의 자동 수정을 막는다', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      host(
        const BrianTextInput(
          semanticLabel: '비밀번호',
          obscureText: true,
          isInvalid: true,
        ),
      ),
    );
    expect(find.bySemanticsLabel('비밀번호'), findsOneWidget);
    final editor = tester.widget<EditableText>(find.byType(EditableText));
    expect(editor.obscureText, isTrue);
    expect(editor.enableInteractiveSelection, isTrue);
    expect(editor.autocorrect, isFalse);
    handle.dispose();
  });

  testWidgets(
    '숨김 입력에서도 Ctrl/Cmd+A로 전체 선택하고 복사·잘라내기는 막는다',
    (tester) async {
      final controller = TextEditingController(text: 'password');
      await tester.pumpWidget(
        host(BrianTextInput(controller: controller, obscureText: true)),
      );
      await tester.tap(find.byType(EditableText));
      await tester.pump();
      final modifier = defaultTargetPlatform == TargetPlatform.macOS
          ? LogicalKeyboardKey.metaLeft
          : LogicalKeyboardKey.controlLeft;
      await tester.sendKeyDownEvent(modifier);
      await tester.sendKeyEvent(LogicalKeyboardKey.keyA);
      await tester.sendKeyUpEvent(modifier);
      await tester.pump();
      expect(
        controller.selection,
        const TextSelection(baseOffset: 0, extentOffset: 8),
      );
      final state = tester.state<EditableTextState>(find.byType(EditableText));
      expect(state.copyEnabled, isFalse);
      expect(state.cutEnabled, isFalse);
      expect(
        state.contextMenuButtonItems.map((item) => item.type),
        isNot(contains(ContextMenuButtonType.copy)),
      );
      expect(
        state.contextMenuButtonItems.map((item) => item.type),
        isNot(contains(ContextMenuButtonType.cut)),
      );
      await tester.pumpWidget(const SizedBox());
      controller.dispose();
    },
    variant: TargetPlatformVariant({
      TargetPlatform.linux,
      TargetPlatform.windows,
      TargetPlatform.macOS,
    }),
  );

  testWidgets('숨김 입력을 길게 누르면 붙여넣기 메뉴로 값을 입력할 수 있다', (tester) async {
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        return switch (call.method) {
          'Clipboard.hasStrings' => <String, Object>{'value': true},
          'Clipboard.getData' => <String, Object>{'text': 'pasted-password'},
          _ => null,
        };
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );
    final values = <String>[];
    final controller = TextEditingController();
    await tester.pumpWidget(
      host(
        BrianTextInput(
          controller: controller,
          obscureText: true,
          onChanged: values.add,
        ),
      ),
    );
    await tester.tap(find.byType(EditableText));
    await tester.pumpAndSettle();
    await tester.longPress(find.byType(EditableText));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(BrianButton, 'Paste'), findsOneWidget);
    expect(find.widgetWithText(BrianButton, 'Copy'), findsNothing);
    expect(find.widgetWithText(BrianButton, 'Cut'), findsNothing);
    await tester.tap(find.widgetWithText(BrianButton, 'Paste'));
    await tester.pumpAndSettle();
    expect(controller.text, 'pasted-password');
    expect(values, ['pasted-password']);
    await tester.pumpWidget(const SizedBox());
    controller.dispose();
  });

  testWidgets('여러 줄 입력은 최소 높이에서 늘어나고 최대 높이에서 스크롤한다', (tester) async {
    final controller = TextEditingController();
    await tester.pumpWidget(
      host(BrianTextArea(controller: controller, minLines: 2, maxLines: 4)),
    );
    final min = tester.getSize(find.byType(BrianTextArea)).height;
    controller.text = '1\n2\n3';
    await tester.pump();
    final grown = tester.getSize(find.byType(BrianTextArea)).height;
    expect(grown, greaterThan(min));
    controller.text = List.generate(12, (i) => '$i').join('\n');
    await tester.pump();
    final capped = tester.getSize(find.byType(BrianTextArea)).height;
    expect(capped, greaterThan(grown));
    controller.text += '\n추가';
    await tester.pump();
    expect(tester.getSize(find.byType(BrianTextArea)).height, capped);
    final scrollable = tester.state<ScrollableState>(
      find
          .descendant(
            of: find.byType(EditableText),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    expect(scrollable.position.maxScrollExtent, greaterThan(0));
    await tester.pumpWidget(
      host(BrianTextArea(controller: controller, minLines: 2, maxLines: 2)),
    );
    expect(tester.getSize(find.byType(BrianTextArea)).height, min);
    await tester.pumpWidget(host(BrianTextArea(controller: controller)));
    expect(
      tester.getSize(find.byType(BrianTextArea)).height,
      greaterThan(capped),
    );
    await tester.pumpWidget(const SizedBox());
    controller.dispose();
  });

  testWidgets('편집 메뉴가 지역 테마 아래에서 열리고 읽기 전용 복사를 제공한다', (tester) async {
    final controller = TextEditingController(text: '복사할 내용');
    await tester.pumpWidget(
      host(
        BrianTextInput(controller: controller, readOnly: true),
        theme: BrianThemeData.dark,
      ),
    );
    await tester.tap(find.byType(EditableText));
    await tester.pump();
    controller.selection = TextSelection(
      baseOffset: 0,
      extentOffset: controller.text.length,
    );
    await tester.pump();
    tester.state<EditableTextState>(find.byType(EditableText)).showToolbar();
    await tester.pumpAndSettle();
    expect(find.text('Copy'), findsOneWidget);
    expect(find.text('Cut'), findsNothing);
    await tester.tap(find.widgetWithText(BrianButton, 'Copy'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    controller.dispose();
  });

  testWidgets('밑줄·앞뒤 슬롯·큰 글자·RTL을 함께 배치한다', (tester) async {
    await tester.pumpWidget(
      host(
        const BrianTextInput(
          variant: BrianTextInputVariant.underline,
          prefix: Text('₩'),
          suffix: Text('원'),
          placeholder: '금액',
        ),
        scale: 2,
        direction: TextDirection.rtl,
      ),
    );
    final border = decoration(tester).border! as Border;
    expect(border.top, BorderSide.none);
    expect(border.bottom.width, greaterThan(0));
    expect(tester.takeException(), isNull);
  });
}
