/// Brian UI의 독립적인 색상·타이포그래피·그림자·테마 시스템입니다.
///
/// [BrianTheme]으로 테마를 제공하고 `BrianTheme.of(context).colors`로
/// 역할 색상을 읽습니다. 일반 콘텐츠는 팔레트 값보다 역할 색상을 우선합니다.
/// 라이트·다크 설정, 대비 제한, 사용자 정의 방법은 패키지 색상 가이드를
/// 참고하세요. API 주석은 `dart doc`으로 HTML 문서를 생성할 수 있습니다.
///
/// {@category ColorReference}
/// {@category Contrast}
library;

export 'src/color/brian_banner_colors.dart';
export 'src/color/brian_background_colors.dart';
export 'src/color/brian_color_scale.dart';
export 'src/color/brian_colors.dart';
export 'src/color/brian_foreground_colors.dart';
export 'src/color/brian_palette.dart';
export 'src/color/brian_static_colors.dart';
export 'src/color/brian_stroke_colors.dart';
export 'src/elevation/brian_shadows.dart';
export 'src/theme/brian_theme.dart';
export 'src/theme/brian_theme_data.dart';
export 'src/typography/brian_font_size.dart';
export 'src/typography/brian_font_weight.dart';
export 'src/typography/brian_line_height.dart';
export 'src/typography/brian_typography.dart';
