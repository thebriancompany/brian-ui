import 'package:brian_ui/brian_ui.dart';
import 'package:flutter/material.dart' show SelectableText;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:highlight/highlight_core.dart' as syntax;
import 'package:highlight/languages/bash.dart';
import 'package:highlight/languages/dart.dart';
import 'package:highlight/languages/json.dart';
import 'package:highlight/languages/yaml.dart';

// 문법 분석만 외부 라이브러리에 맡기고 레이아웃·복사는 문서 앱에서 관리합니다.
// TODO(brian-ui): BrianCodeBlock과 코드 역할 색상이 생기면 이 어댑터와
// 임시 구문 색상표를 옮기고, 문서 앱은 공개 컴포넌트만 사용하도록 전환합니다.
final _highlighter = syntax.Highlight()
  ..registerLanguage('dart', dart)
  ..registerLanguage('yaml', yaml)
  ..registerLanguage('json', json)
  ..registerLanguage('bash', bash);

List<syntax.Node> parseCode(String code, String language) {
  final normalized = switch (language.toLowerCase()) {
    'sh' || 'shell' => 'bash',
    'yml' => 'yaml',
    final value => value,
  };
  if (!const {'dart', 'yaml', 'json', 'bash'}.contains(normalized)) {
    return [syntax.Node(value: code)];
  }
  return _highlighter.parse(code, language: normalized).nodes ??
      [syntax.Node(value: code)];
}

TextSpan codeSpan(List<syntax.Node> nodes, Brightness brightness) {
  final dark = brightness == Brightness.dark;
  // 일반 역할 색상과 구문 색상의 의미는 다르므로 임시 매핑을 격리합니다.
  final colors = <String, Color>{
    'keyword': dark ? const Color(0xFFC4A7FF) : const Color(0xFF6B35A8),
    'built_in': dark ? const Color(0xFF8DC9FF) : const Color(0xFF155A91),
    'type': dark ? const Color(0xFF8DC9FF) : const Color(0xFF155A91),
    'title': dark ? const Color(0xFF8DC9FF) : const Color(0xFF155A91),
    'string': dark ? const Color(0xFF99EAD4) : const Color(0xFF11694F),
    'attr': dark ? const Color(0xFFFFC18D) : const Color(0xFF9D4A13),
    'attribute': dark ? const Color(0xFFFFC18D) : const Color(0xFF9D4A13),
    'number': dark ? const Color(0xFFFFC18D) : const Color(0xFF9D4A13),
    'literal': dark ? const Color(0xFFC4A7FF) : const Color(0xFF6B35A8),
    'comment': dark ? const Color(0xFF9DA4AE) : const Color(0xFF626A73),
    'meta': dark ? const Color(0xFF8DC9FF) : const Color(0xFF155A91),
  };
  TextSpan convert(syntax.Node node) => TextSpan(
    text: node.value,
    style: node.className == null
        ? null
        : TextStyle(color: colors[node.className]),
    children: node.children?.map(convert).toList(),
  );
  return TextSpan(children: nodes.map(convert).toList());
}

class CodeExample extends StatefulWidget {
  const CodeExample(
    this.code, {
    super.key,
    this.language = 'dart',
    this.filename,
    this.showLineNumbers = true,
    this.highlightedLines = const {},
  });

  final String code;
  final String language;
  final String? filename;
  final bool showLineNumbers;

  /// 강조할 줄은 1부터 셉니다. 원문 범위 밖의 번호는 표시하지 않습니다.
  final Set<int> highlightedLines;

  @override
  State<CodeExample> createState() => _CodeExampleState();
}

class _CodeExampleState extends State<CodeExample> {
  late List<syntax.Node> _nodes;
  final _scroll = ScrollController();
  String _status = '코드 복사';

  @override
  void initState() {
    super.initState();
    _nodes = parseCode(widget.code, widget.language);
  }

  @override
  void didUpdateWidget(CodeExample oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.code != widget.code ||
        oldWidget.language != widget.language) {
      _nodes = parseCode(widget.code, widget.language);
      _status = '코드 복사';
    }
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _copy() async {
    try {
      await Clipboard.setData(ClipboardData(text: widget.code));
      if (mounted) setState(() => _status = '복사 완료');
    } catch (_) {
      if (mounted) setState(() => _status = '복사 실패 · 직접 선택해 주세요');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = BrianTheme.of(context);
    final colors = theme.colors;
    final style = theme.typography.t4Regular.copyWith(
      color: colors.foreground.neutral,
      fontFamily: 'BrianCode',
      height: 1.8,
    );
    final scaler = MediaQuery.textScalerOf(context);
    final strut = StrutStyle.fromTextStyle(style, forceStrutHeight: true);
    final metrics = TextPainter(
      text: TextSpan(text: 'M', style: style),
      textDirection: TextDirection.ltr,
      textScaler: scaler,
      strutStyle: strut,
    )..layout();
    final lineHeight = metrics.height;
    metrics.dispose();
    final lineCount = '\n'.allMatches(widget.code).length + 1;
    final showNumbers = widget.showLineNumbers && lineCount > 1;
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colors.background.neutralWeak,
        borderRadius: BorderRadius.circular(BrianRadius.r4),
        border: Border.all(color: colors.stroke.neutralWeak),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: BrianSpacing.x4,
              vertical: BrianSpacing.x3,
            ),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: BrianSpacing.x4,
              runSpacing: BrianSpacing.x2,
              children: [
                Text(
                  widget.filename ?? widget.language.toUpperCase(),
                  style: theme.typography.t3Regular.copyWith(
                    fontFamily: 'BrianCode',
                    color: colors.foreground.neutralMuted,
                  ),
                ),
                BrianButton(
                  onPressed: _copy,
                  variant: BrianButtonVariant.ghost,
                  size: BrianButtonSize.small,
                  leading: const _CopyIcon(),
                  child: Text(_status),
                ),
              ],
            ),
          ),
          Container(height: 1, color: colors.stroke.neutralWeak),
          LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              controller: _scroll,
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: constraints.maxWidth),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _LineHighlights(
                          lines: widget.highlightedLines,
                          lineCount: lineCount,
                          lineHeight: lineHeight,
                          fill: colors.foreground.neutral.withValues(
                            alpha: 0.06,
                          ),
                          border: colors.foreground.neutralMuted,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: BrianSpacing.x5,
                        vertical: BrianSpacing.x5,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (showNumbers)
                            ExcludeSemantics(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  right: BrianSpacing.x6,
                                ),
                                child: Text(
                                  List.generate(
                                    lineCount,
                                    (index) => '${index + 1}',
                                  ).join('\n'),
                                  textAlign: TextAlign.right,
                                  style: style.copyWith(
                                    color: colors.foreground.neutralMuted,
                                  ),
                                  strutStyle: strut,
                                ),
                              ),
                            ),
                          // 한 TextSpan으로 유지해 여러 줄을 선택해도 줄 번호가 섞이지 않습니다.
                          SelectableText.rich(
                            codeSpan(_nodes, theme.brightness),
                            style: style,
                            strutStyle: strut,
                            textDirection: TextDirection.ltr,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CopyIcon extends StatelessWidget {
  const _CopyIcon();

  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: 16,
    child: CustomPaint(painter: _CopyPainter(IconTheme.of(context).color!)),
  );
}

class _CopyPainter extends CustomPainter {
  const _CopyPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(5, 5, 9, 9),
        const Radius.circular(2),
      ),
      paint,
    );
    canvas.drawPath(
      Path()
        ..moveTo(3, 11)
        ..lineTo(2, 11)
        ..lineTo(2, 2)
        ..lineTo(11, 2)
        ..lineTo(11, 3),
      paint,
    );
  }

  @override
  bool shouldRepaint(_CopyPainter oldDelegate) => color != oldDelegate.color;
}

class _LineHighlights extends CustomPainter {
  const _LineHighlights({
    required this.lines,
    required this.lineCount,
    required this.lineHeight,
    required this.fill,
    required this.border,
  });
  final Set<int> lines;
  final int lineCount;
  final double lineHeight;
  final Color fill;
  final Color border;

  @override
  void paint(Canvas canvas, Size size) {
    for (final line in lines) {
      if (line < 1 || line > lineCount) continue;
      final top = BrianSpacing.x5 + (line - 1) * lineHeight;
      canvas.drawRect(
        Rect.fromLTWH(0, top, size.width, lineHeight),
        Paint()..color = fill,
      );
      canvas.drawRect(
        Rect.fromLTWH(0, top, 3, lineHeight),
        Paint()..color = border,
      );
    }
  }

  @override
  bool shouldRepaint(_LineHighlights oldDelegate) =>
      lines != oldDelegate.lines ||
      lineCount != oldDelegate.lineCount ||
      lineHeight != oldDelegate.lineHeight ||
      fill != oldDelegate.fill ||
      border != oldDelegate.border;
}
