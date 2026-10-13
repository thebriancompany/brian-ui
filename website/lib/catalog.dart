class DocPage {
  const DocPage(
    this.path,
    this.title,
    this.group,
    this.description, {
    this.source,
  });

  final String path;
  final String title;
  final String group;
  final String description;
  final String? source;

  String? get asset =>
      source == null ? null : 'assets/guides/${source!.replaceAll('/', '__')}';
}

const pages = [
  DocPage('/', '시작하기', 'OVERVIEW', '직접 살펴보고, 조합하고, 제품에 적용하세요.'),
  DocPage(
    '/foundations/color',
    '색상',
    'FOUNDATIONS',
    '의미를 전달하는 색상, 모드에 적응하는 역할 토큰.',
    source: 'doc/foundations/color/color.md',
  ),
  DocPage(
    '/foundations/typography',
    '타이포그래피',
    'FOUNDATIONS',
    '읽기 편한 위계를 만드는 크기와 역할.',
    source: 'doc/foundations/typography/typography.md',
  ),
  DocPage(
    '/foundations/spacing',
    '간격',
    'FOUNDATIONS',
    '요소 사이의 관계를 표현하는 일관된 여백.',
    source: 'doc/foundations/spacing/spacing.md',
  ),
  DocPage(
    '/foundations/radius',
    '모서리',
    'FOUNDATIONS',
    '표면과 컴포넌트의 형태를 만드는 기본 값.',
    source: 'doc/foundations/radius/radius.md',
  ),
  DocPage(
    '/foundations/elevation',
    '고도',
    'FOUNDATIONS',
    '표면색, 경계선, 그림자를 함께 사용하세요.',
    source: 'doc/foundations/elevation/elevation.md',
  ),
  DocPage(
    '/theming',
    '테마',
    'GUIDES',
    '하나의 BrianTheme으로 색상과 타이포그래피를 연결합니다.',
    source: 'doc/theming/overview.md',
  ),
  DocPage(
    '/components/button',
    'Button',
    'COMPONENTS',
    '사용자의 의도를 실제 액션으로 연결하는 버튼.',
    source: 'doc/components/button/button.md',
  ),
  DocPage(
    '/foundations/color-reference',
    '전체 색상값',
    'REFERENCE',
    '라이트·다크 팔레트와 역할 색상 참조표.',
    source: 'doc/foundations/color/color_reference.md',
  ),
  DocPage(
    '/foundations/contrast',
    '색상 대비',
    'REFERENCE',
    '측정된 전경·배경 조합과 사용 제한.',
    source: 'doc/foundations/color/color_contrast.md',
  ),
  DocPage(
    '/contributing/website',
    '개발과 웹 배포',
    'CONTRIBUTING',
    '컴포넌트 개발부터 웹 검증, 문서 작성과 자동 배포까지.',
    source: 'doc/contributing/website.md',
  ),
];

DocPage? pageForPath(String path) {
  for (final page in pages) {
    if (page.path == path) return page;
  }
  return null;
}
