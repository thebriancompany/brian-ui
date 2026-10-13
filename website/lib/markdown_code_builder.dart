import 'package:flutter/widgets.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:markdown/markdown.dart' as md;

import 'code_example.dart';

// Markdown은 가이드 원본을 유지하기 위한 사이트 전용 렌더러입니다.
// TODO(brian-ui): BrianCodeBlock 도입 시 메타데이터 해석만 이곳에 남기고
// 코드 표현은 디자인 시스템의 공개 API로 교체합니다.
class MarkdownCodeBuilder extends MarkdownElementBuilder {
  @override
  bool isBlockElement() => true;

  @override
  Widget visitElementAfterWithContext(
    BuildContext context,
    md.Element element,
    TextStyle? preferredStyle,
    TextStyle? parentStyle,
  ) {
    final code = element.children!.whereType<md.Element>().first;
    final source = code.textContent.replaceFirst(RegExp(r'\n$'), '');
    final options = CodeBlockOptions.parse(
      element.attributes['data-metadata'] ?? '',
      lineCount: '\n'.allMatches(source).length + 1,
    );
    return CodeExample(
      source,
      language: (code.attributes['class'] ?? 'language-text').replaceFirst(
        'language-',
        '',
      ),
      filename: options.filename,
      highlightedLines: options.highlightedLines,
      showLineNumbers: options.showLineNumbers,
    );
  }
}

class CodeBlockOptions {
  const CodeBlockOptions({
    this.filename,
    this.highlightedLines = const {},
    this.showLineNumbers = true,
  });
  final String? filename;
  final Set<int> highlightedLines;
  final bool showLineNumbers;

  factory CodeBlockOptions.parse(String metadata, {required int lineCount}) {
    final title = RegExp(r'title="([^"]+)"').firstMatch(metadata)?.group(1);
    final ranges = RegExp(r'highlight="([0-9,\- ]+)"')
        .firstMatch(metadata)
        ?.group(1);
    final highlighted = <int>{};
    for (final range in ranges?.split(',') ?? <String>[]) {
      final parts = range.trim().split('-');
      final start = int.tryParse(parts.first);
      final end = int.tryParse(parts.last);
      if (start == null || end == null || parts.length > 2) continue;
      for (var line = 1; line <= lineCount; line++) {
        if (line >= start && line <= end) highlighted.add(line);
      }
    }
    return CodeBlockOptions(
      filename: title,
      highlightedLines: highlighted,
      showLineNumbers: !RegExp(r'\bnumbers=false\b').hasMatch(metadata),
    );
  }
}
