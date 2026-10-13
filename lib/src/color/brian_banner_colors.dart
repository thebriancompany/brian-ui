import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

/// 장식용 배너의 배경 색상입니다.
///
/// 오류·성공 같은 의미 전달에는 역할 색상을 사용하고, 배너 전경은 별도로 대비를 검증합니다.
///
/// {@category Color}
@immutable
class BrianBannerColors {
  const BrianBannerColors({
    required this.blue,
    required this.coolGray,
    required this.green,
    required this.orange,
    required this.pink,
    required this.purple,
    required this.red,
    required this.teal,
    required this.warmGray,
    required this.yellow,
  });

  final Color blue;

  final Color coolGray;

  final Color green;

  final Color orange;

  final Color pink;

  final Color purple;

  final Color red;

  final Color teal;

  final Color warmGray;

  final Color yellow;

  BrianBannerColors copyWith({
    Color? blue,
    Color? coolGray,
    Color? green,
    Color? orange,
    Color? pink,
    Color? purple,
    Color? red,
    Color? teal,
    Color? warmGray,
    Color? yellow,
  }) => BrianBannerColors(
    blue: blue ?? this.blue,
    coolGray: coolGray ?? this.coolGray,
    green: green ?? this.green,
    orange: orange ?? this.orange,
    pink: pink ?? this.pink,
    purple: purple ?? this.purple,
    red: red ?? this.red,
    teal: teal ?? this.teal,
    warmGray: warmGray ?? this.warmGray,
    yellow: yellow ?? this.yellow,
  );

  /// [t]가 0이면 이 값, 1이면 [other]의 색상입니다.
  BrianBannerColors lerp(BrianBannerColors other, double t) {
    if (t == 0) return this;
    if (t == 1) return other;
    return BrianBannerColors(
      blue: Color.lerp(blue, other.blue, t)!,
      coolGray: Color.lerp(coolGray, other.coolGray, t)!,
      green: Color.lerp(green, other.green, t)!,
      orange: Color.lerp(orange, other.orange, t)!,
      pink: Color.lerp(pink, other.pink, t)!,
      purple: Color.lerp(purple, other.purple, t)!,
      red: Color.lerp(red, other.red, t)!,
      teal: Color.lerp(teal, other.teal, t)!,
      warmGray: Color.lerp(warmGray, other.warmGray, t)!,
      yellow: Color.lerp(yellow, other.yellow, t)!,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BrianBannerColors &&
          blue == other.blue &&
          coolGray == other.coolGray &&
          green == other.green &&
          orange == other.orange &&
          pink == other.pink &&
          purple == other.purple &&
          red == other.red &&
          teal == other.teal &&
          warmGray == other.warmGray &&
          yellow == other.yellow;

  @override
  int get hashCode => Object.hashAll([
    blue,
    coolGray,
    green,
    orange,
    pink,
    purple,
    red,
    teal,
    warmGray,
    yellow,
  ]);

  static const light = BrianBannerColors(
    blue: Color(0xFFE1F7FF),
    coolGray: Color(0xFFEBF1F5),
    green: Color(0xFFF0FBE5),
    orange: Color(0xFFFFF2E1),
    pink: Color(0xFFFFEBF1),
    purple: Color(0xFFF5ECFF),
    red: Color(0xFFFFECEE),
    teal: Color(0xFFE6FAF6),
    warmGray: Color(0xFFF2F0EE),
    yellow: Color(0xFFFFFAE1),
  );

  static const dark = BrianBannerColors(
    blue: Color(0xFF0D2A3A),
    coolGray: Color(0xFF242C33),
    green: Color(0xFF1E361C),
    orange: Color(0xFF42230A),
    pink: Color(0xFF3B172C),
    purple: Color(0xFF2E1E45),
    red: Color(0xFF3A0F15),
    teal: Color(0xFF143633),
    warmGray: Color(0xFF2F2B27),
    yellow: Color(0xFF3E2B00),
  );
}
