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
  DocPage('/', 'Getting Started', 'Overview', '직접 살펴보고, 조합하고, 제품에 적용하세요.'),
  DocPage(
    '/foundations/color',
    'Color',
    'Foundations',
    '의미를 전달하는 색상, 모드에 적응하는 역할 토큰.',
    source: 'doc/foundations/color/color.md',
  ),
  DocPage(
    '/foundations/typography',
    'Typography',
    'Foundations',
    '읽기 편한 위계를 만드는 크기와 역할.',
    source: 'doc/foundations/typography/typography.md',
  ),
  DocPage(
    '/foundations/spacing',
    'Spacing',
    'Foundations',
    '요소 사이의 관계를 표현하는 일관된 여백.',
    source: 'doc/foundations/spacing/spacing.md',
  ),
  DocPage(
    '/foundations/radius',
    'Radius',
    'Foundations',
    '표면과 컴포넌트의 형태를 만드는 기본 값.',
    source: 'doc/foundations/radius/radius.md',
  ),
  DocPage(
    '/foundations/elevation',
    'Elevation',
    'Foundations',
    '표면색, 경계선, 그림자를 함께 사용하세요.',
    source: 'doc/foundations/elevation/elevation.md',
  ),
  DocPage(
    '/theming',
    'Theming',
    'Guides',
    '하나의 BrianTheme으로 색상과 타이포그래피를 연결합니다.',
    source: 'doc/theming/overview.md',
  ),
  DocPage(
    '/components/accordion',
    'Accordion',
    'Components',
    '관련 정보를 필요한 만큼 접고 펼치는 목록.',
    source: 'doc/components/accordion/accordion.md',
  ),
  DocPage(
    '/components/alert-dialog',
    'Alert Dialog',
    'Components',
    '명시적인 선택과 확인을 요청하는 알림 다이얼로그.',
    source: 'doc/components/alert_dialog/alert_dialog.md',
  ),
  DocPage(
    '/components/badge',
    'Badge',
    'Components',
    '상태와 부가 정보를 간결하게 전달하는 라벨.',
    source: 'doc/components/badge/badge.md',
  ),
  DocPage(
    '/components/bottom-sheet',
    'Bottom Sheet',
    'Components',
    '화면 아래에서 열리는 선택과 탐색의 공간.',
    source: 'doc/components/bottom_sheet/bottom_sheet.md',
  ),
  DocPage(
    '/components/button',
    'Button',
    'Components',
    '사용자의 의도를 실제 액션으로 연결하는 버튼.',
    source: 'doc/components/button/button.md',
  ),
  DocPage(
    '/components/button-group',
    'Button Group',
    'Components',
    '라벨 길이에 맞춰 가로·세로로 전환되는 액션 버튼 묶음.',
    source: 'doc/components/button_group/button_group.md',
  ),
  DocPage(
    '/components/callout',
    'Callout',
    'Components',
    '화면 흐름 안에서 안내와 상태를 강조하는 메시지.',
    source: 'doc/components/callout/callout.md',
  ),
  DocPage(
    '/components/checkbox',
    'Checkbox',
    'Components',
    '여러 항목의 선택과 동의를 명확하게 표현하는 입력.',
    source: 'doc/components/checkbox/checkbox.md',
  ),
  DocPage(
    '/components/chip',
    'Chip',
    'Components',
    '선택과 필터, 추천 동작, 입력값을 표현하는 작은 항목.',
    source: 'doc/components/chip/chip.md',
  ),
  DocPage(
    '/components/divider',
    'Divider',
    'Components',
    '섹션과 반복 항목 사이의 관계를 드러내는 구분선.',
    source: 'doc/components/divider/divider.md',
  ),
  DocPage(
    '/components/side-navigation',
    'Side Navigation',
    'Components',
    '그룹과 하위 메뉴로 서비스의 페이지를 탐색하는 사이드바.',
    source: 'doc/components/side_navigation/side_navigation.md',
  ),
  DocPage(
    '/components/scroll-fog',
    'Scroll Fog',
    'Components',
    '스크롤 경계에서 콘텐츠를 부드럽게 연결하는 그라디언트.',
    source: 'doc/components/scroll_fog/scroll_fog.md',
  ),
  DocPage(
    '/foundations/color-reference',
    'Color Reference',
    'Reference',
    '라이트·다크 팔레트와 역할 색상 참조표.',
    source: 'doc/foundations/color/color_reference.md',
  ),
  DocPage(
    '/foundations/contrast',
    'Color Contrast',
    'Reference',
    '측정된 전경·배경 조합과 사용 제한.',
    source: 'doc/foundations/color/color_contrast.md',
  ),
  DocPage(
    '/contributing/website',
    'Development & Deployment',
    'Contributing',
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
