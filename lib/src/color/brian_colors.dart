import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import 'brian_background_colors.dart';
import 'brian_banner_colors.dart';
import 'brian_foreground_colors.dart';
import 'brian_palette.dart';
import 'brian_static_colors.dart';
import 'brian_stroke_colors.dart';

/// Brian UI의 팔레트와 역할 색상을 묶은 불변 값입니다.
///
/// 테마 전달 방식에 의존하지 않으며, 위젯 밖에서도 사용할 수 있습니다.
///
/// {@category Color}
@immutable
class BrianColors {
  const BrianColors({
    required this.brightness,
    required this.palette,
    required this.banner,
    required this.foreground,
    required this.background,
    required this.stroke,
  });

  /// 이 색상 묶음의 화면 모드입니다. 보간 중에는 중간 지점에서 전환됩니다.
  final Brightness brightness;

  /// 현재 모드의 팔레트입니다. 일반 UI에는 역할 색상을 우선 사용합니다.
  final BrianPalette palette;

  final BrianBannerColors banner;

  final BrianForegroundColors foreground;

  final BrianBackgroundColors background;

  final BrianStrokeColors stroke;

  /// 팔레트만 교체해도 기존 역할 색상은 재계산하지 않습니다.
  ///
  /// 역할을 다시 연결하려면 [BrianColors.fromPalette]을 사용합니다.
  BrianColors copyWith({
    Brightness? brightness,
    BrianPalette? palette,
    BrianBannerColors? banner,
    BrianForegroundColors? foreground,
    BrianBackgroundColors? background,
    BrianStrokeColors? stroke,
  }) => BrianColors(
    brightness: brightness ?? this.brightness,
    palette: palette ?? this.palette,
    banner: banner ?? this.banner,
    foreground: foreground ?? this.foreground,
    background: background ?? this.background,
    stroke: stroke ?? this.stroke,
  );

  /// [t]가 0이면 이 값, 1이면 [other]의 색상입니다.
  ///
  /// [brightness]는 [t]가 0.5인 지점에서 전환됩니다.
  BrianColors lerp(BrianColors other, double t) {
    if (t == 0) return this;
    if (t == 1) return other;
    return BrianColors(
      brightness: t < 0.5 ? brightness : other.brightness,
      palette: palette.lerp(other.palette, t),
      banner: banner.lerp(other.banner, t),
      foreground: foreground.lerp(other.foreground, t),
      background: background.lerp(other.background, t),
      stroke: stroke.lerp(other.stroke, t),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BrianColors &&
          brightness == other.brightness &&
          palette == other.palette &&
          banner == other.banner &&
          foreground == other.foreground &&
          background == other.background &&
          stroke == other.stroke;

  @override
  int get hashCode => Object.hashAll([
    brightness,
    palette,
    banner,
    foreground,
    background,
    stroke,
  ]);

  static final light = BrianColors.fromPalette(
    palette: BrianPalette.light,
    brightness: Brightness.light,
  );

  static final dark = BrianColors.fromPalette(
    palette: BrianPalette.dark,
    brightness: Brightness.dark,
  );

  /// [brightness]에 맞는 역할 매핑을 [palette]에 적용합니다.
  ///
  /// 팔레트는 전달한 화면 모드에 맞게 준비해야 합니다. 상태 색상은 임의의
  /// 투명도 계산 대신 명시된 단계에 연결합니다. 배너는 별도 값입니다.
  factory BrianColors.fromPalette({
    required BrianPalette palette,
    required Brightness brightness,
  }) {
    final isDark = brightness == Brightness.dark;
    return BrianColors(
      brightness: brightness,
      palette: palette,
      banner: isDark ? BrianBannerColors.dark : BrianBannerColors.light,
      foreground: BrianForegroundColors(
        brand: isDark ? palette.orange.step700 : palette.orange.step600,
        brandContrast: palette.orange.step700,
        critical: palette.red.step700,
        criticalContrast: palette.red.step900,
        disabled: palette.gray.step500,
        informative: palette.blue.step700,
        informativeContrast: palette.blue.step900,
        neutral: palette.gray.step1000,
        neutralMuted: palette.gray.step800,
        neutralSubtle: palette.gray.step700,
        onBrandSolid: BrianStaticColors.white,
        onCriticalSolid: BrianStaticColors.white,
        onInformativeSolid: BrianStaticColors.white,
        onNeutralSolid: isDark ? palette.gray.step100 : palette.gray.step0,
        onPositiveSolid: BrianStaticColors.white,
        onWarningSolid: BrianStaticColors.blackAlpha900,
        placeholder: palette.gray.step600,
        positive: palette.green.step700,
        positiveContrast: palette.green.step900,
        warning: palette.yellow.step700,
        warningContrast: palette.yellow.step900,
      ),
      background: BrianBackgroundColors(
        brandSolid: isDark ? palette.orange.step700 : palette.orange.step600,
        brandSolidPressed: isDark
            ? palette.orange.step800
            : palette.orange.step700,
        brandWeak: palette.orange.step100,
        brandWeakPressed: palette.orange.step200,
        criticalSolid: isDark ? palette.red.step600 : palette.red.step700,
        criticalSolidPressed: isDark
            ? palette.red.step700
            : palette.red.step800,
        criticalWeak: palette.red.step100,
        criticalWeakPressed: palette.red.step200,
        disabled: isDark ? palette.gray.step300 : palette.gray.step200,
        informativeSolid: isDark ? palette.blue.step600 : palette.blue.step700,
        informativeSolidPressed: isDark
            ? palette.blue.step700
            : palette.blue.step800,
        informativeWeak: palette.blue.step100,
        informativeWeakPressed: palette.blue.step200,
        layerBasement: isDark ? palette.gray.step0 : palette.gray.step200,
        layerDefault: isDark ? palette.gray.step100 : palette.gray.step0,
        layerDefaultPressed: isDark
            ? palette.gray.step300
            : palette.gray.step100,
        layerFloating: isDark ? palette.gray.step200 : palette.gray.step0,
        layerFloatingPressed: isDark
            ? palette.gray.step300
            : palette.gray.step100,
        neutralMuted: isDark ? palette.gray.step200 : palette.gray.step100,
        neutralSolid: isDark ? palette.gray.step1000 : palette.gray.step900,
        neutralSolidPressed: palette.gray.step800,
        neutralSubtle: isDark ? palette.gray.step100 : palette.gray.step0,
        neutralWeak: isDark ? palette.gray.step300 : palette.gray.step200,
        neutralWeakAlpha: isDark
            ? BrianStaticColors.whiteAlpha200
            : BrianStaticColors.blackAlpha200,
        neutralWeakAlphaPressed: isDark
            ? BrianStaticColors.whiteAlpha300
            : BrianStaticColors.blackAlpha300,
        neutralWeakPressed: isDark
            ? palette.gray.step400
            : palette.gray.step300,
        overlay: BrianStaticColors.blackAlpha700,
        overlayMuted: BrianStaticColors.blackAlpha500,
        positiveSolid: isDark ? palette.green.step500 : palette.green.step700,
        positiveSolidPressed: isDark
            ? palette.green.step600
            : palette.green.step800,
        positiveWeak: palette.green.step100,
        positiveWeakPressed: palette.green.step200,
        transparent: isDark ? Color(0x00FFFFFF) : Color(0x00000000),
        transparentPressed: isDark
            ? BrianStaticColors.whiteAlpha50
            : BrianStaticColors.blackAlpha100,
        transparentSelected: isDark
            ? BrianStaticColors.whiteAlpha100
            : BrianStaticColors.blackAlpha200,
        transparentSelectedPressed: isDark
            ? BrianStaticColors.whiteAlpha200
            : BrianStaticColors.blackAlpha300,
        warningSolid: isDark ? palette.yellow.step800 : palette.yellow.step300,
        warningSolidPressed: isDark
            ? palette.yellow.step900
            : palette.yellow.step400,
        warningWeak: palette.yellow.step100,
        warningWeakPressed: palette.yellow.step200,
      ),
      stroke: BrianStrokeColors(
        brandSolid: palette.orange.step700,
        brandWeak: palette.orange.step300,
        criticalSolid: palette.red.step700,
        criticalWeak: palette.red.step300,
        focusRing: palette.blue.step600,
        informativeSolid: palette.blue.step700,
        informativeWeak: palette.blue.step300,
        neutralContrast: palette.gray.step1000,
        neutralMuted: isDark
            ? BrianStaticColors.whiteAlpha100
            : BrianStaticColors.blackAlpha300,
        neutralSolid: palette.gray.step800,
        neutralSubtle: isDark
            ? BrianStaticColors.whiteAlpha50
            : BrianStaticColors.blackAlpha200,
        neutralWeak: palette.gray.step400,
        positiveSolid: palette.green.step700,
        positiveWeak: palette.green.step300,
        warningSolid: palette.yellow.step700,
        warningWeak: palette.yellow.step300,
      ),
    );
  }
}
