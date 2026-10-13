import 'package:brian_ui/brian_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('다크 팔레트는 단순 반전이 아니며 역할별로 다른 단계를 사용한다', () {
    final light = BrianColors.light;
    final dark = BrianColors.dark;
    expect(light.palette.gray.step0, const Color(0xFFFFFFFF));
    expect(dark.palette.gray.step0, const Color(0xFF000000));
    expect(dark.palette.gray.step100, const Color(0xFF16171B));
    expect(dark.palette.orange.step600, const Color(0xFFE65200));
    expect(light.foreground.brand, const Color(0xFFFF6600));
    expect(dark.foreground.brand, const Color(0xFFFF6600));
    expect(dark.background.positiveSolid, const Color(0xFF117956));
    expect(dark.foreground.positive, const Color(0xFF22B27F));
    expect(dark.background.warningSolid, const Color(0xFFDAB156));
  });

  test('동일한 라이트 표면도 다크에서는 계층을 구분한다', () {
    final light = BrianColors.light.background;
    final dark = BrianColors.dark.background;
    expect(light.layerDefault, light.layerFloating);
    expect(dark.layerBasement, const Color(0xFF000000));
    expect(dark.layerDefault, const Color(0xFF16171B));
    expect(dark.layerFloating, const Color(0xFF1D2025));
  });

  test('고정 알파는 ARGB로 변환하며 적응형 알파는 모드별로 바뀐다', () {
    expect(BrianStaticColors.blackAlpha700.toARGB32(), 0x74000000);
    expect(BrianStaticColors.whiteAlpha50.toARGB32(), 0x0DFFFFFF);
    expect(
      BrianColors.light.background.overlay,
      BrianColors.dark.background.overlay,
    );
    expect(
      BrianColors.light.background.transparentPressed.toARGB32(),
      0x07000000,
    );
    expect(
      BrianColors.dark.background.transparentPressed.toARGB32(),
      0x0DFFFFFF,
    );
    expect(
      BrianColors.dark.background.transparentSelectedPressed.toARGB32(),
      0x20FFFFFF,
    );
    expect(BrianColors.dark.background.transparent.a, 0);
  });

  for (final base in [BrianColors.light, BrianColors.dark]) {
    test('${base.brightness.name}: 브랜드 교체는 일반 색상 팔레트를 보존한다', () {
      final palette = base.palette;
      final brand = palette.purple;
      final isDark = base.brightness == Brightness.dark;
      final colors = BrianColors.fromPalette(
        palette: palette,
        brightness: base.brightness,
        brandScale: brand,
      );
      expect(colors.palette, same(palette));
      expect(colors.palette.orange, base.palette.orange);
      expect(colors.foreground.brand, isDark ? brand.step700 : brand.step600);
      expect(colors.foreground.brandContrast, brand.step700);
      expect(colors.foreground.onBrandSolid, base.foreground.onBrandSolid);
      expect(colors.background.brandSolid, colors.foreground.brand);
      expect(
        colors.background.brandSolidPressed,
        isDark ? brand.step800 : brand.step700,
      );
      expect(colors.background.brandWeak, brand.step100);
      expect(colors.background.brandWeakPressed, brand.step200);
      expect(colors.stroke.brandSolid, brand.step700);
      expect(colors.stroke.brandWeak, brand.step300);
      expect(colors.foreground.neutral, base.foreground.neutral);
      expect(
        colors.background.informativeSolid,
        base.background.informativeSolid,
      );
      expect(colors.stroke.focusRing, base.stroke.focusRing);
    });
  }

  test('같은 값을 갖는 서로 다른 역할은 독립적으로 교체된다', () {
    final base = BrianColors.light;
    expect(base.background.layerDefault, base.background.layerFloating);
    final changed = base.copyWith(
      background: base.background.copyWith(
        layerFloating: const Color(0xFF123456),
      ),
    );
    expect(changed.background.layerDefault, base.background.layerDefault);
    expect(changed.background.layerFloating, const Color(0xFF123456));
    expect(base.background.layerFloating, const Color(0xFFFFFFFF));
    expect(changed.foreground, base.foreground);
  });

  test('값 동등성과 해시는 내용으로 결정된다', () {
    final base = BrianColors.light;
    final same = base.copyWith(
      palette: base.palette.copyWith(gray: base.palette.gray.copyWith()),
      foreground: base.foreground.copyWith(),
      background: base.background.copyWith(),
      stroke: base.stroke.copyWith(),
      banner: base.banner.copyWith(),
    );
    expect(same, base);
    expect(same.hashCode, base.hashCode);
    expect({base, same}, hasLength(1));
    expect(base, isNot(BrianColors.dark));
  });

  test('보간은 끝점과 모든 색상 그룹을 보존한다', () {
    final a = BrianColors.light;
    final b = BrianColors.dark;
    expect(a.lerp(b, 0), a);
    expect(a.lerp(b, 1), b);
    final middle = a.lerp(b, 0.5);
    expect(middle.palette.gray.step0.toARGB32(), 0xFF808080);
    expect(
      middle.foreground.neutral,
      Color.lerp(a.foreground.neutral, b.foreground.neutral, 0.5),
    );
    expect(
      middle.background.layerFloating,
      Color.lerp(a.background.layerFloating, b.background.layerFloating, 0.5),
    );
    expect(
      middle.stroke.neutralSubtle,
      Color.lerp(a.stroke.neutralSubtle, b.stroke.neutralSubtle, 0.5),
    );
    expect(middle.banner.blue, Color.lerp(a.banner.blue, b.banner.blue, 0.5));
    expect(a.lerp(b, 0.49).brightness, Brightness.light);
    expect(middle.brightness, Brightness.dark);
  });

  for (final colors in [BrianColors.light, BrianColors.dark]) {
    test('${colors.brightness.name}: 포커스 링은 기본 표면에서 3:1 이상이다', () {
      final bg = colors.background;
      for (final surface in [
        bg.layerDefault,
        bg.layerBasement,
        bg.layerFloating,
        bg.layerDefaultPressed,
        bg.layerFloatingPressed,
      ]) {
        expect(
          _contrast(colors.stroke.focusRing, surface),
          greaterThanOrEqualTo(3),
          reason: '${colors.stroke.focusRing} / $surface',
        );
      }
    });

    test('${colors.brightness.name}: 권장 본문과 안내 조합은 4.5:1 이상이다', () {
      final fg = colors.foreground;
      final bg = colors.background;
      final pairs = [
        (fg.neutral, bg.layerDefault),
        (fg.neutralMuted, bg.layerDefault),
        (fg.neutral, bg.layerFloating),
        (fg.neutralMuted, bg.layerFloating),
        (fg.positiveContrast, bg.positiveWeak),
        (fg.criticalContrast, bg.criticalWeak),
        (fg.informativeContrast, bg.informativeWeak),
        (fg.warningContrast, bg.warningWeak),
        (fg.onWarningSolid, bg.warningSolid),
        (fg.onNeutralSolid, bg.neutralSolid),
      ];
      for (final (foreground, background) in pairs) {
        expect(
          _contrast(foreground, background),
          greaterThanOrEqualTo(4.5),
          reason: '$foreground / $background',
        );
      }
    });

    test('${colors.brightness.name}: 기본 브랜드 대비 제한과 대체 조합을 기록한다', () {
      final bg = colors.background;
      expect(
        _contrast(colors.foreground.onBrandSolid, bg.brandSolid),
        closeTo(2.94, 0.01),
      );
      // 기본 흰색 글자를 작은 버튼에 무심코 적용하지 않도록 제한을 명시한다.
      expect(
        _contrast(BrianStaticColors.black, bg.brandSolid),
        greaterThanOrEqualTo(4.5),
      );
      expect(
        _contrast(BrianStaticColors.black, bg.brandSolidPressed),
        greaterThanOrEqualTo(4.5),
      );
    });
  }

  test('대비 측정은 반투명 전경을 배경 위에 합성한다', () {
    expect(_contrast(BrianStaticColors.black, BrianStaticColors.white), 21);
    expect(_contrast(const Color(0x00000000), BrianStaticColors.white), 1);
    expect(
      _contrast(
        BrianStaticColors.blackAlpha900,
        BrianColors.light.background.warningSolid,
      ),
      closeTo(10.80, 0.01),
    );
  });
}

double _contrast(Color foreground, Color background) {
  assert(background.a == 1);
  final a = Color.alphaBlend(foreground, background).computeLuminance();
  final b = background.computeLuminance();
  return a > b ? (a + 0.05) / (b + 0.05) : (b + 0.05) / (a + 0.05);
}
