import 'package:brian_ui/brian_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

import 'browser.dart';
import 'catalog.dart';
import 'site_widgets.dart';
import 'markdown_code_builder.dart';

class Guide extends StatefulWidget {
  const Guide({super.key, required this.page, required this.onNavigate});
  final DocPage page;
  final ValueChanged<String> onNavigate;

  @override
  State<Guide> createState() => _GuideState();
}

class _GuideState extends State<Guide> {
  late Future<String> _content;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(Guide oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.page.asset != widget.page.asset) _load();
  }

  void _load() {
    _content = rootBundle.loadString(widget.page.asset!);
  }

  void _openLink(String text, String? href, String title) {
    if (href == null) return;
    final resolved = Uri.parse(widget.page.source!).resolve(href).path;
    for (final page in pages) {
      if (page.source == resolved) {
        widget.onNavigate(page.path);
        return;
      }
    }
    final uri = Uri.tryParse(href);
    if (uri != null && (uri.scheme == 'https' || uri.scheme == 'http')) {
      openSiteLink(href);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = BrianTheme.of(context);
    final body = theme.typography.t5Regular.copyWith(
      color: theme.colors.foreground.neutral,
      height: 1.8,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeading('사용 가이드'),
        FutureBuilder<String>(
          future: _content,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('가이드를 불러오지 못했습니다. 페이지를 새로고침해 주세요.');
            }
            if (!snapshot.hasData) return const Text('가이드를 불러오는 중…');
            return MarkdownBody(
              data: snapshot.data!.replaceFirst(RegExp(r'^# [^\n]+\n+'), ''),
              selectable: true,
              builders: {'pre': MarkdownCodeBuilder()},
              onTapLink: _openLink,
              styleSheet: MarkdownStyleSheet(
                p: body,
                h1: theme.typography.t9Bold,
                h2: theme.typography.t9Bold.copyWith(
                  color: theme.colors.foreground.neutral,
                ),
                h3: theme.typography.t7Bold.copyWith(
                  color: theme.colors.foreground.neutral,
                ),
                h2Padding: const EdgeInsets.only(
                  top: BrianSpacing.x8,
                  bottom: BrianSpacing.x4,
                ),
                h3Padding: const EdgeInsets.only(
                  top: BrianSpacing.x4,
                  bottom: BrianSpacing.x2,
                ),
                a: body.copyWith(decoration: TextDecoration.underline),
                code: theme.typography.t4Regular.copyWith(
                  fontFamily: 'BrianCode',
                  color: theme.colors.foreground.neutral,
                  backgroundColor: theme.colors.background.neutralWeak,
                ),
                // pre 빌더가 전체 코드 표면을 담당하므로 기본 표면을 겹치지 않습니다.
                codeblockPadding: EdgeInsets.zero,
                codeblockDecoration: const BoxDecoration(),
                tableColumnWidth: const IntrinsicColumnWidth(),
                tableHead: theme.typography.t3Bold,
                tableBody: theme.typography.t3Regular,
                tableBorder: TableBorder.all(
                  color: theme.colors.stroke.neutralWeak,
                ),
                tableCellsPadding: const EdgeInsets.all(BrianSpacing.x3),
                blockSpacing: BrianSpacing.x6,
                listBullet: body,
                blockquoteDecoration: BoxDecoration(
                  color: theme.colors.background.neutralWeak,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
