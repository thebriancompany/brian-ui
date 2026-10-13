import 'package:flutter/foundation.dart';

import '../color/brian_colors.dart';

/// Brian UI의 시각적 설정을 담는 불변 값입니다.
///
/// 현재는 색상을 제공하며, 이후 타이포그래피 등 공통 설정을 확장할 수 있습니다.
///
/// {@category Theme}
@immutable
class BrianThemeData {
  const BrianThemeData({required this.colors});

  static final light = BrianThemeData(colors: BrianColors.light);

  static final dark = BrianThemeData(colors: BrianColors.dark);

  /// [brightness]에 해당하는 기본 테마를 반환합니다.
  ///
  /// 시스템 모드를 따르려면 위젯의 build 안에서
  /// `MediaQuery.platformBrightnessOf(context)` 결과를 전달합니다.
  factory BrianThemeData.forBrightness(Brightness brightness) =>
      brightness == Brightness.dark ? dark : light;

  final BrianColors colors;

  /// 색상에 지정된 화면 모드입니다.
  Brightness get brightness => colors.brightness;

  BrianThemeData copyWith({BrianColors? colors}) =>
      BrianThemeData(colors: colors ?? this.colors);

  /// 색상을 [other]까지 보간합니다.
  ///
  /// [t]가 0이면 현재 테마, 1이면 대상 테마입니다. 화면 모드는 0.5에서
  /// 전환됩니다. 이 메서드 자체가 애니메이션을 실행하지는 않습니다.
  BrianThemeData lerp(BrianThemeData other, double t) =>
      BrianThemeData(colors: colors.lerp(other.colors, t));

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BrianThemeData && colors == other.colors;

  @override
  int get hashCode => colors.hashCode;
}
