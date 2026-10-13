import 'package:flutter/foundation.dart';

import '../color/brian_colors.dart';
import '../elevation/brian_shadows.dart';
import '../typography/brian_typography.dart';

/// Brian UI의 시각적 설정을 담는 불변 값입니다.
///
/// 색상·타이포그래피·그림자를 함께 전달합니다.
///
/// {@category Theme}
@immutable
class BrianThemeData {
  const BrianThemeData({
    required this.colors,
    this.typography = const BrianTypography(),
    this.shadows = const BrianShadows(),
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

  /// 색상에 지정된 화면 모드입니다.
  Brightness get brightness => colors.brightness;

  BrianThemeData copyWith({
    BrianColors? colors,
    BrianTypography? typography,
    BrianShadows? shadows,
  }) => BrianThemeData(
    colors: colors ?? this.colors,
    typography: typography ?? this.typography,
    shadows: shadows ?? this.shadows,
  );

  /// 색상·타이포그래피·그림자를 [other]까지 보간합니다.
  ///
  /// 스타일 보간의 제약은 [BrianTypography.lerp]를 따릅니다.
  ///
  /// [t]가 0이면 현재 테마, 1이면 대상 테마입니다. 화면 모드는 0.5에서
  /// 전환됩니다. 이 메서드 자체가 애니메이션을 실행하지는 않습니다.
  BrianThemeData lerp(BrianThemeData other, double t) => BrianThemeData(
    colors: colors.lerp(other.colors, t),
    typography: typography.lerp(other.typography, t),
    shadows: shadows.lerp(other.shadows, t),
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BrianThemeData &&
          colors == other.colors &&
          typography == other.typography &&
          shadows == other.shadows;

  @override
  int get hashCode => Object.hash(colors, typography, shadows);
}
