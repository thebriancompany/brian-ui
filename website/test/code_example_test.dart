import 'package:brian_ui/brian_ui.dart';
import 'package:brian_ui_website/code_example.dart';
import 'package:brian_ui_website/markdown_code_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('문법 강조는 코드 원문을 보존하고 문자열과 키워드에 색상을 적용한다', () {
    const source = "final label = '안녕하세요';\n// 주석\nconst count = 42;";
    final nodes = parseCode(source, 'dart');
    final light = codeSpan(nodes, Brightness.light);
    final dark = codeSpan(nodes, Brightness.dark);
    expect(light.toPlainText(), source);
    expect(dark.toPlainText(), source);
    final lightColors = <Color>{};
    final darkColors = <Color>{};
    void collect(TextSpan span, Set<Color> colors) {
      if (span.style?.color != null) colors.add(span.style!.color!);
      for (final child in span.children ?? <InlineSpan>[]) {
        if (child is TextSpan) collect(child, colors);
      }
    }

    collect(light, lightColors);
    collect(dark, darkColors);
    expect(lightColors.length, greaterThanOrEqualTo(3));
    expect(darkColors.intersection(lightColors), isEmpty);
    expect(
      codeSpan(
        parseCode('<unknown>&', 'custom'),
        Brightness.dark,
      ).toPlainText(),
      '<unknown>&',
    );
  });

  test('코드 메타데이터는 범위를 제한하고 잘못된 줄 지정은 무시한다', () {
    final options = CodeBlockOptions.parse(
      'title="lib/theme.dart" highlight="2-4,8,999999999" numbers=false',
      lineCount: 6,
    );
    expect(options.filename, 'lib/theme.dart');
    expect(options.highlightedLines, {2, 3, 4});
    expect(options.showLineNumbers, isFalse);
    expect(
      CodeBlockOptions.parse('highlight="4-2"', lineCount: 6).highlightedLines,
      isEmpty,
    );
  });

  testWidgets('Markdown 코드에 파일명·강조 줄을 적용하고 원문만 복사한다', (tester) async {
    const markdown = '''본문의 `BrianTheme` 설명.

```json title="settings.json" highlight="2"
{
  "theme": "dark"
}
```

```text numbers=false
first
second
```
''';
    String? copied;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.setData') {
          copied = (call.arguments as Map)['text'] as String;
        }
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: BrianTheme(
          data: BrianThemeData.dark,
          child: SingleChildScrollView(
            child: MarkdownBody(
              data: markdown,
              builders: {'pre': MarkdownCodeBuilder()},
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final blocks = tester
        .widgetList<CodeExample>(find.byType(CodeExample))
        .toList();
    expect(blocks.length, 2);
    expect(blocks.first.filename, 'settings.json');
    expect(blocks.first.highlightedLines, {2});
    expect(blocks.last.showLineNumbers, isFalse);
    expect(blocks.first.code, '{\n  "theme": "dark"\n}');
    await tester.tap(find.text('코드 복사').first);
    await tester.pumpAndSettle();
    expect(copied, blocks.first.code);
    expect(tester.takeException(), isNull);
  });
}
