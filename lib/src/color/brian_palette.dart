import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import 'brian_color_scale.dart';

/// 모드에 적응하는 팔레트입니다.
///
/// 같은 단계라도 라이트·다크의 값은 다르며, 두 팔레트는 단순한 역순이 아닙니다.
///
/// {@category Color}
@immutable
class BrianPalette {
  const BrianPalette({
    required this.gray,
    required this.orange,
    required this.blue,
    required this.red,
    required this.green,
    required this.yellow,
    required this.purple,
  });

  final BrianGrayScale gray;

  final BrianColorScale orange;

  final BrianColorScale blue;

  final BrianColorScale red;

  final BrianColorScale green;

  final BrianColorScale yellow;

  final BrianColorScale purple;

  BrianPalette copyWith({
    BrianGrayScale? gray,
    BrianColorScale? orange,
    BrianColorScale? blue,
    BrianColorScale? red,
    BrianColorScale? green,
    BrianColorScale? yellow,
    BrianColorScale? purple,
  }) => BrianPalette(
    gray: gray ?? this.gray,
    orange: orange ?? this.orange,
    blue: blue ?? this.blue,
    red: red ?? this.red,
    green: green ?? this.green,
    yellow: yellow ?? this.yellow,
    purple: purple ?? this.purple,
  );

  /// [t]가 0이면 이 값, 1이면 [other]의 색상입니다.
  BrianPalette lerp(BrianPalette other, double t) {
    if (t == 0) return this;
    if (t == 1) return other;
    return BrianPalette(
      gray: gray.lerp(other.gray, t),
      orange: orange.lerp(other.orange, t),
      blue: blue.lerp(other.blue, t),
      red: red.lerp(other.red, t),
      green: green.lerp(other.green, t),
      yellow: yellow.lerp(other.yellow, t),
      purple: purple.lerp(other.purple, t),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BrianPalette &&
          gray == other.gray &&
          orange == other.orange &&
          blue == other.blue &&
          red == other.red &&
          green == other.green &&
          yellow == other.yellow &&
          purple == other.purple;

  @override
  int get hashCode =>
      Object.hashAll([gray, orange, blue, red, green, yellow, purple]);

  static const light = BrianPalette(
    gray: BrianGrayScale(
      step0: Color(0xFFFFFFFF),
      step100: Color(0xFFF7F8F9),
      step200: Color(0xFFF3F4F5),
      step300: Color(0xFFEEEFF1),
      step400: Color(0xFFDCDEE3),
      step500: Color(0xFFD1D3D8),
      step600: Color(0xFFB0B3BA),
      step700: Color(0xFF868B94),
      step800: Color(0xFF555D6D),
      step900: Color(0xFF2A3038),
      step1000: Color(0xFF1A1C20),
    ),
    orange: BrianColorScale(
      step100: Color(0xFFFFF2EC),
      step200: Color(0xFFFFE8DB),
      step300: Color(0xFFFFD5C0),
      step400: Color(0xFFFFB999),
      step500: Color(0xFFFF9364),
      step600: Color(0xFFFF6600),
      step700: Color(0xFFE14D00),
      step800: Color(0xFFB93901),
      step900: Color(0xFF862B00),
      step1000: Color(0xFF471601),
    ),
    blue: BrianColorScale(
      step100: Color(0xFFEFF6FF),
      step200: Color(0xFFE2EDFC),
      step300: Color(0xFFCBDFFA),
      step400: Color(0xFFAACEFD),
      step500: Color(0xFF85B8FD),
      step600: Color(0xFF5E98FE),
      step700: Color(0xFF217CF9),
      step800: Color(0xFF135FCD),
      step900: Color(0xFF0B4596),
      step1000: Color(0xFF032451),
    ),
    red: BrianColorScale(
      step100: Color(0xFFFDF0F0),
      step200: Color(0xFFFDE7E7),
      step300: Color(0xFFFED4D2),
      step400: Color(0xFFFEB7B3),
      step500: Color(0xFFFE928D),
      step600: Color(0xFFFC6A66),
      step700: Color(0xFFFA342C),
      step800: Color(0xFFCA1D13),
      step900: Color(0xFF921708),
      step1000: Color(0xFF4A1209),
    ),
    green: BrianColorScale(
      step100: Color(0xFFEDFAF6),
      step200: Color(0xFFD9F6E9),
      step300: Color(0xFFB9E9D2),
      step400: Color(0xFF7DDCB3),
      step500: Color(0xFF42C593),
      step600: Color(0xFF10AB7D),
      step700: Color(0xFF079171),
      step800: Color(0xFF00745F),
      step900: Color(0xFF075445),
      step1000: Color(0xFF0A2B24),
    ),
    yellow: BrianColorScale(
      step100: Color(0xFFFFF7DE),
      step200: Color(0xFFFDEFB9),
      step300: Color(0xFFFBDC65),
      step400: Color(0xFFE9C647),
      step500: Color(0xFFD4AB28),
      step600: Color(0xFFC49725),
      step700: Color(0xFF9B7821),
      step800: Color(0xFF755B22),
      step900: Color(0xFF4F3E1F),
      step1000: Color(0xFF2C2512),
    ),
    purple: BrianColorScale(
      step100: Color(0xFFF5F3FE),
      step200: Color(0xFFEFEAFE),
      step300: Color(0xFFE1D8FF),
      step400: Color(0xFFD0C0FF),
      step500: Color(0xFFB8A1FF),
      step600: Color(0xFF9F84FB),
      step700: Color(0xFF8969EA),
      step800: Color(0xFF6D50CB),
      step900: Color(0xFF50379B),
      step1000: Color(0xFF29175D),
    ),
  );

  static const dark = BrianPalette(
    gray: BrianGrayScale(
      step0: Color(0xFF000000),
      step100: Color(0xFF16171B),
      step200: Color(0xFF1D2025),
      step300: Color(0xFF2B2E35),
      step400: Color(0xFF393D46),
      step500: Color(0xFF5B606A),
      step600: Color(0xFF868B94),
      step700: Color(0xFFB0B3BA),
      step800: Color(0xFFDCDEE3),
      step900: Color(0xFFE9EAEC),
      step1000: Color(0xFFF3F4F5),
    ),
    orange: BrianColorScale(
      step100: Color(0xFF31241F),
      step200: Color(0xFF4B291C),
      step300: Color(0xFF6B311C),
      step400: Color(0xFF923600),
      step500: Color(0xFFBD4201),
      step600: Color(0xFFE65200),
      step700: Color(0xFFFF6600),
      step800: Color(0xFFFF9E65),
      step900: Color(0xFFEECEBC),
      step1000: Color(0xFFF4EEEA),
    ),
    blue: BrianColorScale(
      step100: Color(0xFF202742),
      step200: Color(0xFF1E3352),
      step300: Color(0xFF1A4275),
      step400: Color(0xFF0F559E),
      step500: Color(0xFF1964D8),
      step600: Color(0xFF1E82EB),
      step700: Color(0xFF41A2F9),
      step800: Color(0xFF83BCF9),
      step900: Color(0xFFB9D7FB),
      step1000: Color(0xFFE5F0FE),
    ),
    red: BrianColorScale(
      step100: Color(0xFF322323),
      step200: Color(0xFF4F2624),
      step300: Color(0xFF742826),
      step400: Color(0xFFA12621),
      step500: Color(0xFFCA2319),
      step600: Color(0xFFF73526),
      step700: Color(0xFFFF6E60),
      step800: Color(0xFFFFA299),
      step900: Color(0xFFF8C5C3),
      step1000: Color(0xFFFDF2F2),
    ),
    green: BrianColorScale(
      step100: Color(0xFF202926),
      step200: Color(0xFF20362E),
      step300: Color(0xFF20493B),
      step400: Color(0xFF19604C),
      step500: Color(0xFF117956),
      step600: Color(0xFF1B946D),
      step700: Color(0xFF22B27F),
      step800: Color(0xFF35CE9A),
      step900: Color(0xFF93E5C0),
      step1000: Color(0xFFD4F6EF),
    ),
    yellow: BrianColorScale(
      step100: Color(0xFF302819),
      step200: Color(0xFF413218),
      step300: Color(0xFF543E15),
      step400: Color(0xFF714E15),
      step500: Color(0xFF91601B),
      step600: Color(0xFFB6720D),
      step700: Color(0xFFCA901C),
      step800: Color(0xFFDAB156),
      step900: Color(0xFFE5D49B),
      step1000: Color(0xFFF7F0CD),
    ),
    purple: BrianColorScale(
      step100: Color(0xFF28213B),
      step200: Color(0xFF3B2873),
      step300: Color(0xFF443081),
      step400: Color(0xFF5A3BB1),
      step500: Color(0xFF764FD9),
      step600: Color(0xFF8E6BEE),
      step700: Color(0xFFA78DF0),
      step800: Color(0xFFBEADF2),
      step900: Color(0xFFD9CEFA),
      step1000: Color(0xFFF0EDFC),
    ),
  );
}
