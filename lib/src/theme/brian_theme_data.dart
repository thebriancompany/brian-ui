import 'package:flutter/foundation.dart';

import '../color/brian_colors.dart';
import '../elevation/brian_shadows.dart';
import '../typography/brian_typography.dart';
import 'brian_bottom_sheet_style.dart';
import 'brian_button_styles.dart';
import 'brian_chip_styles.dart';
import 'brian_radius_tokens.dart';
import 'brian_spacing_tokens.dart';

/// Brian UI의 시각적 설정을 담는 불변 값입니다.
///
/// 색상·타이포그래피·그림자·레이아웃 설정을 함께 전달합니다.
///
/// {@category Theme}
@immutable
class BrianThemeData {
  const BrianThemeData({
    required this.colors,
    this.typography = const BrianTypography(),
    this.shadows = const BrianShadows(),
    this.spacing = const BrianSpacingTokens(),
    this.radius = const BrianRadiusTokens(),
    this.buttons = const BrianButtonStyles(),
    this.iconButtons = const BrianButtonStyles(),
    this.chips = const BrianChipStyles(),
    this.bottomSheet = const BrianBottomSheetStyle(),
  });

  static final light = BrianThemeData(colors: BrianColors.light);

  static final dark = BrianThemeData(colors: BrianColors.dark);

  /// [brightness]에 해당하는 기본 테마를 반환합니다.
  ///
  /// 시스템 모드를 따르려면 위젯의 build 안에서
  /// `MediaQuery.platformBrightnessOf(context)` 결과를 전달합니다.
  factory BrianThemeData.forBrightness(Brightness brightness) =>
      brightness == Brightness.dark ? dark : light;

  final BrianColors colors;

  final BrianTypography typography;

  final BrianShadows shadows;
  final BrianSpacingTokens spacing;
  final BrianRadiusTokens radius;
  final BrianButtonStyles buttons;
  final BrianButtonStyles iconButtons;
  final BrianChipStyles chips;
  final BrianBottomSheetStyle bottomSheet;

  /// 색상에 지정된 화면 모드입니다.
  Brightness get brightness => colors.brightness;

  BrianThemeData copyWith({
    BrianColors? colors,
    BrianTypography? typography,
    BrianShadows? shadows,
    BrianSpacingTokens? spacing,
    BrianRadiusTokens? radius,
    BrianButtonStyles? buttons,
    BrianButtonStyles? iconButtons,
    BrianChipStyles? chips,
    BrianBottomSheetStyle? bottomSheet,
  }) => BrianThemeData(
    colors: colors ?? this.colors,
    typography: typography ?? this.typography,
    shadows: shadows ?? this.shadows,
    spacing: spacing ?? this.spacing,
    radius: radius ?? this.radius,
    buttons: buttons ?? this.buttons,
    iconButtons: iconButtons ?? this.iconButtons,
    chips: chips ?? this.chips,
    bottomSheet: bottomSheet ?? this.bottomSheet,
  );

  /// 색상·타이포그래피·그림자·레이아웃 설정을 [other]까지 보간합니다.
  ///
  /// 텍스트 보간은 [BrianTypography.lerp]를 따릅니다. 컴포넌트 스타일에서
  /// 한쪽 필드가 null이면 0.5에서 상속 여부를 전환합니다.
  ///
  /// [t]가 0이면 현재 테마, 1이면 대상 테마입니다. 화면 모드는 0.5에서
  /// 전환됩니다. 이 메서드 자체가 애니메이션을 실행하지는 않습니다.
  BrianThemeData lerp(BrianThemeData other, double t) => BrianThemeData(
    colors: colors.lerp(other.colors, t),
    typography: typography.lerp(other.typography, t),
    shadows: shadows.lerp(other.shadows, t),
    spacing: spacing.lerp(other.spacing, t),
    radius: radius.lerp(other.radius, t),
    buttons: buttons.lerp(other.buttons, t),
    iconButtons: iconButtons.lerp(other.iconButtons, t),
    chips: chips.lerp(other.chips, t),
    bottomSheet: bottomSheet.lerp(other.bottomSheet, t),
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BrianThemeData &&
          colors == other.colors &&
          typography == other.typography &&
          shadows == other.shadows &&
          spacing == other.spacing &&
          radius == other.radius &&
          buttons == other.buttons &&
          iconButtons == other.iconButtons &&
          chips == other.chips &&
          bottomSheet == other.bottomSheet;

  @override
  int get hashCode => Object.hash(
    colors,
    typography,
    shadows,
    spacing,
    radius,
    buttons,
    iconButtons,
    chips,
    bottomSheet,
  );
}
