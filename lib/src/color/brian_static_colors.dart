import 'package:flutter/painting.dart';

/// 화면 모드와 관계없이 유지되는 흰색·검은색과 반투명 색상입니다.
///
/// Alpha 뒤의 숫자는 단계 이름이며 불투명도 백분율이 아닙니다.
/// HEX는 RRGGBB 또는 RRGGBBAA, Dart 정수 색상은 AARRGGBB 순서입니다.
///
/// {@category Color}
abstract final class BrianStaticColors {
  /// HEX `#000000` · ARGB `0xFF000000` · 불투명도 100%.
  static const black = Color(0xFF000000);

  /// HEX `#00000007` · ARGB `0x07000000` · 불투명도 2.75%.
  static const blackAlpha100 = Color(0x07000000);

  /// HEX `#0000000C` · ARGB `0x0C000000` · 불투명도 4.71%.
  static const blackAlpha200 = Color(0x0C000000);

  /// HEX `#00000010` · ARGB `0x10000000` · 불투명도 6.27%.
  static const blackAlpha300 = Color(0x10000000);

  /// HEX `#00000021` · ARGB `0x21000000` · 불투명도 12.94%.
  static const blackAlpha400 = Color(0x21000000);

  /// HEX `#0000002C` · ARGB `0x2C000000` · 불투명도 17.25%.
  static const blackAlpha500 = Color(0x2C000000);

  /// HEX `#0000004C` · ARGB `0x4C000000` · 불투명도 29.8%.
  static const blackAlpha600 = Color(0x4C000000);

  /// HEX `#00000074` · ARGB `0x74000000` · 불투명도 45.49%.
  static const blackAlpha700 = Color(0x74000000);

  /// HEX `#000000A2` · ARGB `0xA2000000` · 불투명도 63.53%.
  static const blackAlpha800 = Color(0xA2000000);

  /// HEX `#000000D0` · ARGB `0xD0000000` · 불투명도 81.57%.
  static const blackAlpha900 = Color(0xD0000000);

  /// HEX `#000000E3` · ARGB `0xE3000000` · 불투명도 89.02%.
  static const blackAlpha1000 = Color(0xE3000000);

  /// HEX `#FFFFFF` · ARGB `0xFFFFFFFF` · 불투명도 100%.
  static const white = Color(0xFFFFFFFF);

  /// HEX `#FFFFFF0D` · ARGB `0x0DFFFFFF` · 불투명도 5.1%.
  static const whiteAlpha50 = Color(0x0DFFFFFF);

  /// HEX `#FFFFFF17` · ARGB `0x17FFFFFF` · 불투명도 9.02%.
  static const whiteAlpha100 = Color(0x17FFFFFF);

  /// HEX `#FFFFFF20` · ARGB `0x20FFFFFF` · 불투명도 12.55%.
  static const whiteAlpha200 = Color(0x20FFFFFF);

  /// HEX `#FFFFFF2E` · ARGB `0x2EFFFFFF` · 불투명도 18.04%.
  static const whiteAlpha300 = Color(0x2EFFFFFF);

  /// HEX `#FFFFFF3D` · ARGB `0x3DFFFFFF` · 불투명도 23.92%.
  static const whiteAlpha400 = Color(0x3DFFFFFF);

  /// HEX `#FFFFFF60` · ARGB `0x60FFFFFF` · 불투명도 37.65%.
  static const whiteAlpha500 = Color(0x60FFFFFF);

  /// HEX `#FFFFFF8B` · ARGB `0x8BFFFFFF` · 불투명도 54.51%.
  static const whiteAlpha600 = Color(0x8BFFFFFF);

  /// HEX `#FFFFFFB3` · ARGB `0xB3FFFFFF` · 불투명도 70.2%.
  static const whiteAlpha700 = Color(0xB3FFFFFF);

  /// HEX `#FFFFFFDE` · ARGB `0xDEFFFFFF` · 불투명도 87.06%.
  static const whiteAlpha800 = Color(0xDEFFFFFF);

  /// HEX `#FFFFFFEA` · ARGB `0xEAFFFFFF` · 불투명도 91.76%.
  static const whiteAlpha900 = Color(0xEAFFFFFF);

  /// HEX `#FFFFFFF4` · ARGB `0xF4FFFFFF` · 불투명도 95.69%.
  static const whiteAlpha1000 = Color(0xF4FFFFFF);
}
