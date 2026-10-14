import 'package:brian_ui/brian_ui.dart';
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
  testWidgets('오류가 도움말을 대체하고 해제되면 도움말을 복원한다', (tester) async {
    for (final error in [null, '이름을 입력하세요.', null]) {
      await tester.pumpWidget(
        host(
          BrianField(
            label: '이름',
            helperText: '도움말',
            errorText: error,
            counterText: '0 / 20',
            child: const SizedBox(height: 44),
          ),
        ),
      );
      expect(find.text('도움말'), error == null ? findsOneWidget : findsNothing);
      expect(
        find.text('이름을 입력하세요.'),
        error == null ? findsNothing : findsOneWidget,
      );
      expect(find.text('0 / 20'), findsOneWidget);
      if (error != null) {
        final semantics = tester.widget<Semantics>(
          find
              .ancestor(of: find.text(error), matching: find.byType(Semantics))
              .first,
        );
        expect(semantics.properties.liveRegion, isTrue);
      }
    }
  });

  testWidgets('라이트와 다크에서 라벨·오류·카운터의 역할 색상을 사용한다', (tester) async {
    for (final theme in [BrianThemeData.light, BrianThemeData.dark]) {
      await tester.pumpWidget(
        host(
          const BrianField(
            label: '이름',
            errorText: '오류',
            counterText: '2 / 20',
            child: SizedBox(),
          ),
          theme: theme,
        ),
      );
      expect(
        tester.widget<Text>(find.text('이름')).style!.color,
        theme.colors.foreground.neutral,
      );
      expect(
        tester.widget<Text>(find.text('오류')).style!.color,
        theme.colors.foreground.criticalContrast,
      );
      expect(
        DefaultTextStyle.of(tester.element(find.text('2 / 20'))).style.color,
        theme.colors.foreground.neutralMuted,
      );
    }
  });

  testWidgets('필수 표시는 접근성 문구를 제공하고 그룹의 동작을 보존한다', (tester) async {
    final handle = tester.ensureSemantics();
    var selected = false;
    await tester.pumpWidget(
      host(
        BrianField(
          label: '소식',
          requirement: BrianFieldRequirement.required,
          child: BrianCheckbox(
            value: false,
            onChanged: (value) => selected = value,
            label: const Text('업데이트'),
          ),
        ),
      ),
    );
    expect(find.bySemanticsLabel('소식 필수'), findsOneWidget);
    await tester.tap(find.byType(BrianCheckbox));
    expect(selected, isTrue);
    handle.dispose();
  });

  testWidgets('좁은 너비·큰 글자·RTL에서 긴 라벨과 보조 동작이 넘치지 않는다', (tester) async {
    for (final direction in TextDirection.values) {
      await tester.pumpWidget(
        host(
          BrianField(
            label: '아주 긴 입력 항목의 이름과 설명',
            requirement: BrianFieldRequirement.optional,
            trailing: BrianButton(onPressed: () {}, child: const Text('도움말')),
            helperText: '입력 기준에 맞춰 내용을 작성해 주세요.',
            counterText: '100 / 100',
            child: const SizedBox(height: 44),
          ),
          scale: 2,
          direction: direction,
        ),
      );
      expect(tester.takeException(), isNull);
      expect(find.text('100 / 100'), findsOneWidget);
    }
  });
}
