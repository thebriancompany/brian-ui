import 'package:brian_ui/brian_ui.dart';
import 'package:flutter/material.dart'
    show MaterialApp, MaterialPage, ThemeData, ThemeMode;
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'accordion_playground.dart';
import 'alert_dialog_examples.dart';
import 'badge_examples.dart';
import 'browser.dart';
import 'bottom_sheet_examples.dart';
import 'button_playground.dart';
import 'button_group_examples.dart';
import 'callout_examples.dart';
import 'checkbox_examples.dart';
import 'chip_examples.dart';
import 'divider_examples.dart';
import 'scroll_fog_examples.dart';
import 'catalog.dart';
import 'foundation_preview.dart';
import 'guide.dart';
import 'site_widgets.dart';

void main() => runApp(const BrianDocsApp());

class BrianDocsApp extends StatefulWidget {
  const BrianDocsApp({super.key});

  @override
  State<BrianDocsApp> createState() => _BrianDocsAppState();
}

class _BrianDocsAppState extends State<BrianDocsApp> {
  late final DocsRouter _router = DocsRouter(
    onBrightnessChanged: (value) => setState(() => _brightness = value),
  );
  Brightness? _brightness;

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Brian UI · 문서',
      debugShowCheckedModeBanner: false,
      // Markdown의 텍스트 선택 메뉴와 지역화에만 Material 기반을 사용합니다.
      // 사이트의 색상·타이포그래피·버튼은 BrianTheme과 Brian UI를 사용합니다.
      theme: ThemeData(fontFamily: 'sans-serif'),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'sans-serif',
      ),
      themeMode: _brightness == null
          ? ThemeMode.system
          : _brightness == Brightness.dark
          ? ThemeMode.dark
          : ThemeMode.light,
      routerDelegate: _router,
      routeInformationParser: const DocsRouteParser(),
      builder: (context, child) {
        final brightness =
            _brightness ?? MediaQuery.platformBrightnessOf(context);
        final data = BrianThemeData.forBrightness(brightness);
        return BrianTheme(
          data: data,
          child: DefaultTextStyle(
            style: data.typography.t4Regular.copyWith(
              color: data.colors.foreground.neutral,
              fontFamily: 'sans-serif',
            ),
            child: ColoredBox(
              color: data.colors.background.layerDefault,
              child: SafeArea(child: child!),
            ),
          ),
        );
      },
    );
  }
}

class DocsRouteParser extends RouteInformationParser<String> {
  const DocsRouteParser();

  @override
  Future<String> parseRouteInformation(
    RouteInformation routeInformation,
  ) async => routeInformation.uri.path;

  @override
  RouteInformation restoreRouteInformation(String configuration) =>
      RouteInformation(uri: Uri(path: configuration));
}

class DocsRouter extends RouterDelegate<String>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<String> {
  DocsRouter({required this.onBrightnessChanged});

  final ValueChanged<Brightness> onBrightnessChanged;
  String _path = '/';

  @override
  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  String get currentConfiguration => _path;

  @override
  Future<void> setNewRoutePath(String configuration) async {
    _path = configuration;
    notifyListeners();
  }

  @override
  Future<bool> popRoute() async => false;

  @override
  Widget build(BuildContext context) => Navigator(
    key: navigatorKey,
    pages: [
      MaterialPage<void>(
        key: const ValueKey('docs'),
        child: DocsShell(
          path: _path,
          onBrightnessChanged: onBrightnessChanged,
          onNavigate: (path) {
            if (_path == path) return;
            Router.navigate(context, () {
              _path = path;
              notifyListeners();
            });
          },
        ),
      ),
    ],
    onDidRemovePage: (_) {},
  );
}

class DocsShell extends StatefulWidget {
  const DocsShell({
    super.key,
    required this.path,
    required this.onNavigate,
    required this.onBrightnessChanged,
  });
  final ValueChanged<Brightness> onBrightnessChanged;
  final String path;
  final ValueChanged<String> onNavigate;

  @override
  State<DocsShell> createState() => _DocsShellState();
}

class _DocsShellState extends State<DocsShell> {
  bool _menuOpen = false;

  void _navigate(String path) {
    setState(() => _menuOpen = false);
    widget.onNavigate(path);
  }

  @override
  Widget build(BuildContext context) {
    final theme = BrianTheme.of(context);
    final page = pageForPath(widget.path);
    final content = SingleChildScrollView(
      key: ValueKey(widget.path),
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 960),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: BrianSpacing.x6,
              vertical: BrianSpacing.x10,
            ),
            child: page == null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionHeading('페이지를 찾을 수 없습니다'),
                      const Text('주소를 확인하거나 시작 페이지로 이동해 주세요.'),
                      const SizedBox(height: BrianSpacing.x6),
                      BrianButton(
                        onPressed: () => _navigate('/'),
                        child: const Text('시작하기로 이동'),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        page.group,
                        style: theme.typography.t2Bold.copyWith(
                          color: theme.colors.foreground.neutralMuted,
                          letterSpacing: 1.8,
                        ),
                      ),
                      const SizedBox(height: BrianSpacing.x4),
                      Semantics(
                        header: true,
                        child: Text(
                          page.path == '/'
                              ? '일관된 경험을 만드는\n작은 기준들.'
                              : page.title,
                          style: theme.typography.t12Bold,
                        ),
                      ),
                      const SizedBox(height: BrianSpacing.x4),
                      Text(
                        page.description,
                        style: theme.typography.t5Regular.copyWith(
                          color: theme.colors.foreground.neutralMuted,
                        ),
                      ),
                      if (page.path == '/') _Overview(onNavigate: _navigate),
                      if (page.path == '/components/accordion')
                        const AccordionPlayground(),
                      if (page.path == '/components/alert-dialog')
                        const AlertDialogExamples(),
                      if (page.path == '/components/badge')
                        const BadgeExamples(),
                      if (page.path == '/components/bottom-sheet')
                        const BottomSheetExamples(),
                      if (page.path == '/components/button-group')
                        const ButtonGroupExamples(),
                      if (page.path == '/components/button')
                        const ButtonPlayground(),
                      if (page.path == '/components/scroll-fog')
                        const ScrollFogExamples(),
                      if (page.path == '/components/callout')
                        const CalloutExamples(),
                      if (page.path == '/components/checkbox')
                        const CheckboxExamples(),
                      if (page.path == '/components/chip') const ChipExamples(),
                      if (page.path == '/components/divider')
                        const DividerExamples(),
                      FoundationPreview(path: page.path),
                      if (page.asset != null)
                        Guide(page: page, onNavigate: _navigate),
                      const SizedBox(height: BrianSpacing.x12),
                      Container(
                        height: 1,
                        color: theme.colors.stroke.neutralWeak,
                      ),
                      const SizedBox(height: BrianSpacing.x5),
                      Wrap(
                        spacing: BrianSpacing.x4,
                        runSpacing: BrianSpacing.x4,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            'Brian UI · develop 최신 개발 문서',
                            style: theme.typography.t2Regular,
                          ),
                          BrianButton(
                            onPressed: () => openSiteLink('api/index.html'),
                            variant: BrianButtonVariant.ghost,
                            size: BrianButtonSize.small,
                            child: const Text('API 참조 ↗'),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
    return Title(
      title: '${page?.title ?? '페이지 없음'} · Brian UI',
      color: theme.colors.background.layerDefault,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SiteHeader(onBrightnessChanged: widget.onBrightnessChanged),
          Container(height: 1, color: theme.colors.stroke.neutralWeak),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth >= 1000) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 244,
                        child: _Navigation(
                          path: widget.path,
                          onNavigate: _navigate,
                        ),
                      ),
                      Container(
                        width: 1,
                        color: theme.colors.stroke.neutralWeak,
                      ),
                      Expanded(child: content),
                    ],
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: BrianSpacing.x6,
                        vertical: BrianSpacing.x3,
                      ),
                      child: BrianButton(
                        onPressed: () => setState(() => _menuOpen = !_menuOpen),
                        variant: BrianButtonVariant.neutralWeak,
                        child: Text(
                          _menuOpen
                              ? '메뉴 닫기'
                              : '메뉴 · ${page?.title ?? '페이지 없음'}',
                        ),
                      ),
                    ),
                    Expanded(
                      child: _menuOpen
                          ? _Navigation(
                              path: widget.path,
                              onNavigate: _navigate,
                            )
                          : content,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Navigation extends StatelessWidget {
  const _Navigation({required this.path, required this.onNavigate});
  final String path;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    final theme = BrianTheme.of(context);
    return ListView(
      padding: const EdgeInsets.all(BrianSpacing.x5),
      children: [
        for (final group in pages.map((page) => page.group).toSet()) ...[
          Padding(
            padding: const EdgeInsets.only(
              top: BrianSpacing.x5,
              bottom: BrianSpacing.x3,
              left: BrianSpacing.x3,
            ),
            child: Text(
              group,
              style: theme.typography.t1Bold.copyWith(
                color: theme.colors.foreground.neutralMuted,
                letterSpacing: 1.4,
              ),
            ),
          ),
          for (final page in pages.where((page) => page.group == group))
            Padding(
              padding: const EdgeInsets.only(bottom: BrianSpacing.x1),
              child: Semantics(
                selected: page.path == path,
                child: BrianButton(
                  onPressed: () => onNavigate(page.path),
                  variant: page.path == path
                      ? BrianButtonVariant.neutralWeak
                      : BrianButtonVariant.ghost,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(page.title),
                  ),
                ),
              ),
            ),
        ],
        const SizedBox(height: BrianSpacing.x5),
        BrianButton(
          onPressed: () => openSiteLink('api/index.html'),
          variant: BrianButtonVariant.neutralOutline,
          child: const Text('API 참조 ↗'),
        ),
      ],
    );
  }
}

class _Overview extends StatefulWidget {
  const _Overview({required this.onNavigate});
  final ValueChanged<String> onNavigate;

  @override
  State<_Overview> createState() => _OverviewState();
}

class _OverviewState extends State<_Overview> {
  // 분석·실행 테스트를 받는 Dart 파일을 그대로 표시해 예제와 구현의 차이를 막습니다.
  late final _source = rootBundle.loadString(
    'lib/examples/getting_started.dart',
  );

  @override
  Widget build(BuildContext context) {
    final theme = BrianTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: BrianSpacing.x8),
        Surface(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('실제 컴포넌트로 확인하세요.', style: theme.typography.t7Bold),
              const SizedBox(height: BrianSpacing.x3),
              const Text(
                '이 사이트의 버튼, 색상, 글자와 간격은 Brian UI를 사용합니다. 테마를 전환하고 버튼을 눌러 제품에 적용할 모습을 확인하세요.',
              ),
              const SizedBox(height: BrianSpacing.x6),
              Wrap(
                spacing: BrianSpacing.x3,
                runSpacing: BrianSpacing.x3,
                children: [
                  BrianButton(
                    onPressed: () => widget.onNavigate('/components/button'),
                    child: const Text('Button 체험하기 →'),
                  ),
                  BrianButton(
                    onPressed: () => widget.onNavigate('/foundations/color'),
                    variant: BrianButtonVariant.neutralOutline,
                    child: const Text('기반 값 살펴보기'),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SectionHeading('패키지 연결'),
        const Text(
          '아래는 이 저장소의 website/에서 사용하는 로컬 의존성입니다. 다른 프로젝트에서는 brian_ui의 실제 경로에 맞게 변경하세요.',
        ),
        const SizedBox(height: BrianSpacing.x4),
        const CodeExample(
          'dependencies:\n  brian_ui:\n    path: ../',
          language: 'YAML',
        ),
        const SectionHeading('테마로 시작하기'),
        const Text(
          'BrianTheme을 상위에 제공하고 공개 진입점에서 컴포넌트를 가져옵니다. 아래는 앱에서 실행할 수 있는 최소 예제입니다.',
        ),
        const SizedBox(height: BrianSpacing.x4),
        FutureBuilder<String>(
          future: _source,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('예제를 불러오지 못했습니다. 페이지를 새로고침해 주세요.');
            }
            if (!snapshot.hasData) return const Text('예제를 불러오고 있습니다.');
            return CodeExample(snapshot.data!, filename: 'lib/main.dart');
          },
        ),
        const SectionHeading('문서를 읽는 순서'),
        const Text(
          '기반 값에서 선택 기준을 확인하고, 테마 가이드에서 앱에 연결하세요. 컴포넌트 페이지에서는 실제 상태와 사용법을, API 참조에서는 생성자·속성·타입의 정확한 계약을 확인할 수 있습니다.',
        ),
        const SizedBox(height: BrianSpacing.x5),
        BrianButton(
          onPressed: () => widget.onNavigate('/contributing/website'),
          variant: BrianButtonVariant.neutralWeak,
          child: const Text('컴포넌트 개발과 웹 배포 →'),
        ),
      ],
    );
  }
}
