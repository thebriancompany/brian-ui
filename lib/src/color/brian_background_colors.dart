import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

/// 표면·상태·계층을 표현하는 배경 색상입니다.
///
/// Solid는 강한 강조, Weak는 약한 강조에 사용합니다. Pressed는 누르는 동안,
/// Selected는 선택 상태의 색상입니다. 상태 이벤트를 처리하거나 원래 색으로
/// 복귀하는 동작은 컴포넌트에서 구현합니다.
///
/// {@category Color}
@immutable
class BrianBackgroundColors {
  const BrianBackgroundColors({
    required this.brandSolid,
    required this.brandSolidPressed,
    required this.brandWeak,
    required this.brandWeakPressed,
    required this.criticalSolid,
    required this.criticalSolidPressed,
    required this.criticalWeak,
    required this.criticalWeakPressed,
    required this.disabled,
    required this.informativeSolid,
    required this.informativeSolidPressed,
    required this.informativeWeak,
    required this.informativeWeakPressed,
    required this.layerBasement,
    required this.layerDefault,
    required this.layerDefaultPressed,
    required this.layerFloating,
    required this.layerFloatingPressed,
    required this.neutralMuted,
    required this.neutralSolid,
    required this.neutralSolidPressed,
    required this.neutralSubtle,
    required this.neutralWeak,
    required this.neutralWeakAlpha,
    required this.neutralWeakAlphaPressed,
    required this.neutralWeakPressed,
    required this.overlay,
    required this.overlayMuted,
    required this.positiveSolid,
    required this.positiveSolidPressed,
    required this.positiveWeak,
    required this.positiveWeakPressed,
    required this.transparent,
    required this.transparentPressed,
    required this.transparentSelected,
    required this.transparentSelectedPressed,
    required this.warningSolid,
    required this.warningSolidPressed,
    required this.warningWeak,
    required this.warningWeakPressed,
  });

  final Color brandSolid;

  final Color brandSolidPressed;

  final Color brandWeak;

  final Color brandWeakPressed;

  final Color criticalSolid;

  final Color criticalSolidPressed;

  final Color criticalWeak;

  final Color criticalWeakPressed;

  /// 사용할 수 없는 요소의 배경입니다. 일반 콘텐츠의 강조도를 낮추는 용도로 사용하지 않습니다.
  final Color disabled;

  final Color informativeSolid;

  final Color informativeSolidPressed;

  final Color informativeWeak;

  final Color informativeWeakPressed;

  /// 화면 가장 아래에 놓이는 바탕입니다. 카드나 기본 콘텐츠 표면 아래에 사용합니다.
  final Color layerBasement;

  /// 본문과 일반 콘텐츠를 배치하는 기본 표면입니다.
  final Color layerDefault;

  final Color layerDefaultPressed;

  /// 팝업과 모달 등 떠 있는 콘텐츠의 표면입니다.
  final Color layerFloating;

  final Color layerFloatingPressed;

  /// 기본 표면 위에서 섹션을 구분하는 배경입니다.
  final Color neutralMuted;

  final Color neutralSolid;

  final Color neutralSolidPressed;

  /// 주변 회색 영역과 구분되는 기본 표면색 배경입니다.
  final Color neutralSubtle;

  final Color neutralWeak;

  /// 아래 표면이 비치는 약한 중립 배경입니다. 최종 합성된 색상으로 대비를 확인합니다.
  final Color neutralWeakAlpha;

  final Color neutralWeakAlphaPressed;

  final Color neutralWeakPressed;

  /// 모달 뒤 콘텐츠를 어둡게 가리는 반투명 배경입니다. 모달 자체의 표면과 구분합니다.
  final Color overlay;

  /// 주변을 약하게 어둡게 가리는 반투명 배경입니다.
  final Color overlayMuted;

  final Color positiveSolid;

  final Color positiveSolidPressed;

  final Color positiveWeak;

  final Color positiveWeakPressed;

  /// 색을 칠하지 않는 투명 배경입니다.
  final Color transparent;

  final Color transparentPressed;

  /// 투명 표면에서 선택됨을 나타내는 반투명 배경입니다.
  final Color transparentSelected;

  final Color transparentSelectedPressed;

  final Color warningSolid;

  final Color warningSolidPressed;

  final Color warningWeak;

  final Color warningWeakPressed;

  BrianBackgroundColors copyWith({
    Color? brandSolid,
    Color? brandSolidPressed,
    Color? brandWeak,
    Color? brandWeakPressed,
    Color? criticalSolid,
    Color? criticalSolidPressed,
    Color? criticalWeak,
    Color? criticalWeakPressed,
    Color? disabled,
    Color? informativeSolid,
    Color? informativeSolidPressed,
    Color? informativeWeak,
    Color? informativeWeakPressed,
    Color? layerBasement,
    Color? layerDefault,
    Color? layerDefaultPressed,
    Color? layerFloating,
    Color? layerFloatingPressed,
    Color? neutralMuted,
    Color? neutralSolid,
    Color? neutralSolidPressed,
    Color? neutralSubtle,
    Color? neutralWeak,
    Color? neutralWeakAlpha,
    Color? neutralWeakAlphaPressed,
    Color? neutralWeakPressed,
    Color? overlay,
    Color? overlayMuted,
    Color? positiveSolid,
    Color? positiveSolidPressed,
    Color? positiveWeak,
    Color? positiveWeakPressed,
    Color? transparent,
    Color? transparentPressed,
    Color? transparentSelected,
    Color? transparentSelectedPressed,
    Color? warningSolid,
    Color? warningSolidPressed,
    Color? warningWeak,
    Color? warningWeakPressed,
  }) => BrianBackgroundColors(
    brandSolid: brandSolid ?? this.brandSolid,
    brandSolidPressed: brandSolidPressed ?? this.brandSolidPressed,
    brandWeak: brandWeak ?? this.brandWeak,
    brandWeakPressed: brandWeakPressed ?? this.brandWeakPressed,
    criticalSolid: criticalSolid ?? this.criticalSolid,
    criticalSolidPressed: criticalSolidPressed ?? this.criticalSolidPressed,
    criticalWeak: criticalWeak ?? this.criticalWeak,
    criticalWeakPressed: criticalWeakPressed ?? this.criticalWeakPressed,
    disabled: disabled ?? this.disabled,
    informativeSolid: informativeSolid ?? this.informativeSolid,
    informativeSolidPressed:
        informativeSolidPressed ?? this.informativeSolidPressed,
    informativeWeak: informativeWeak ?? this.informativeWeak,
    informativeWeakPressed:
        informativeWeakPressed ?? this.informativeWeakPressed,
    layerBasement: layerBasement ?? this.layerBasement,
    layerDefault: layerDefault ?? this.layerDefault,
    layerDefaultPressed: layerDefaultPressed ?? this.layerDefaultPressed,
    layerFloating: layerFloating ?? this.layerFloating,
    layerFloatingPressed: layerFloatingPressed ?? this.layerFloatingPressed,
    neutralMuted: neutralMuted ?? this.neutralMuted,
    neutralSolid: neutralSolid ?? this.neutralSolid,
    neutralSolidPressed: neutralSolidPressed ?? this.neutralSolidPressed,
    neutralSubtle: neutralSubtle ?? this.neutralSubtle,
    neutralWeak: neutralWeak ?? this.neutralWeak,
    neutralWeakAlpha: neutralWeakAlpha ?? this.neutralWeakAlpha,
    neutralWeakAlphaPressed:
        neutralWeakAlphaPressed ?? this.neutralWeakAlphaPressed,
    neutralWeakPressed: neutralWeakPressed ?? this.neutralWeakPressed,
    overlay: overlay ?? this.overlay,
    overlayMuted: overlayMuted ?? this.overlayMuted,
    positiveSolid: positiveSolid ?? this.positiveSolid,
    positiveSolidPressed: positiveSolidPressed ?? this.positiveSolidPressed,
    positiveWeak: positiveWeak ?? this.positiveWeak,
    positiveWeakPressed: positiveWeakPressed ?? this.positiveWeakPressed,
    transparent: transparent ?? this.transparent,
    transparentPressed: transparentPressed ?? this.transparentPressed,
    transparentSelected: transparentSelected ?? this.transparentSelected,
    transparentSelectedPressed:
        transparentSelectedPressed ?? this.transparentSelectedPressed,
    warningSolid: warningSolid ?? this.warningSolid,
    warningSolidPressed: warningSolidPressed ?? this.warningSolidPressed,
    warningWeak: warningWeak ?? this.warningWeak,
    warningWeakPressed: warningWeakPressed ?? this.warningWeakPressed,
  );

  /// [t]가 0이면 이 값, 1이면 [other]의 색상입니다.
  BrianBackgroundColors lerp(BrianBackgroundColors other, double t) {
    if (t == 0) return this;
    if (t == 1) return other;
    return BrianBackgroundColors(
      brandSolid: Color.lerp(brandSolid, other.brandSolid, t)!,
      brandSolidPressed: Color.lerp(
        brandSolidPressed,
        other.brandSolidPressed,
        t,
      )!,
      brandWeak: Color.lerp(brandWeak, other.brandWeak, t)!,
      brandWeakPressed: Color.lerp(
        brandWeakPressed,
        other.brandWeakPressed,
        t,
      )!,
      criticalSolid: Color.lerp(criticalSolid, other.criticalSolid, t)!,
      criticalSolidPressed: Color.lerp(
        criticalSolidPressed,
        other.criticalSolidPressed,
        t,
      )!,
      criticalWeak: Color.lerp(criticalWeak, other.criticalWeak, t)!,
      criticalWeakPressed: Color.lerp(
        criticalWeakPressed,
        other.criticalWeakPressed,
        t,
      )!,
      disabled: Color.lerp(disabled, other.disabled, t)!,
      informativeSolid: Color.lerp(
        informativeSolid,
        other.informativeSolid,
        t,
      )!,
      informativeSolidPressed: Color.lerp(
        informativeSolidPressed,
        other.informativeSolidPressed,
        t,
      )!,
      informativeWeak: Color.lerp(informativeWeak, other.informativeWeak, t)!,
      informativeWeakPressed: Color.lerp(
        informativeWeakPressed,
        other.informativeWeakPressed,
        t,
      )!,
      layerBasement: Color.lerp(layerBasement, other.layerBasement, t)!,
      layerDefault: Color.lerp(layerDefault, other.layerDefault, t)!,
      layerDefaultPressed: Color.lerp(
        layerDefaultPressed,
        other.layerDefaultPressed,
        t,
      )!,
      layerFloating: Color.lerp(layerFloating, other.layerFloating, t)!,
      layerFloatingPressed: Color.lerp(
        layerFloatingPressed,
        other.layerFloatingPressed,
        t,
      )!,
      neutralMuted: Color.lerp(neutralMuted, other.neutralMuted, t)!,
      neutralSolid: Color.lerp(neutralSolid, other.neutralSolid, t)!,
      neutralSolidPressed: Color.lerp(
        neutralSolidPressed,
        other.neutralSolidPressed,
        t,
      )!,
      neutralSubtle: Color.lerp(neutralSubtle, other.neutralSubtle, t)!,
      neutralWeak: Color.lerp(neutralWeak, other.neutralWeak, t)!,
      neutralWeakAlpha: Color.lerp(
        neutralWeakAlpha,
        other.neutralWeakAlpha,
        t,
      )!,
      neutralWeakAlphaPressed: Color.lerp(
        neutralWeakAlphaPressed,
        other.neutralWeakAlphaPressed,
        t,
      )!,
      neutralWeakPressed: Color.lerp(
        neutralWeakPressed,
        other.neutralWeakPressed,
        t,
      )!,
      overlay: Color.lerp(overlay, other.overlay, t)!,
      overlayMuted: Color.lerp(overlayMuted, other.overlayMuted, t)!,
      positiveSolid: Color.lerp(positiveSolid, other.positiveSolid, t)!,
      positiveSolidPressed: Color.lerp(
        positiveSolidPressed,
        other.positiveSolidPressed,
        t,
      )!,
      positiveWeak: Color.lerp(positiveWeak, other.positiveWeak, t)!,
      positiveWeakPressed: Color.lerp(
        positiveWeakPressed,
        other.positiveWeakPressed,
        t,
      )!,
      transparent: Color.lerp(transparent, other.transparent, t)!,
      transparentPressed: Color.lerp(
        transparentPressed,
        other.transparentPressed,
        t,
      )!,
      transparentSelected: Color.lerp(
        transparentSelected,
        other.transparentSelected,
        t,
      )!,
      transparentSelectedPressed: Color.lerp(
        transparentSelectedPressed,
        other.transparentSelectedPressed,
        t,
      )!,
      warningSolid: Color.lerp(warningSolid, other.warningSolid, t)!,
      warningSolidPressed: Color.lerp(
        warningSolidPressed,
        other.warningSolidPressed,
        t,
      )!,
      warningWeak: Color.lerp(warningWeak, other.warningWeak, t)!,
      warningWeakPressed: Color.lerp(
        warningWeakPressed,
        other.warningWeakPressed,
        t,
      )!,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BrianBackgroundColors &&
          brandSolid == other.brandSolid &&
          brandSolidPressed == other.brandSolidPressed &&
          brandWeak == other.brandWeak &&
          brandWeakPressed == other.brandWeakPressed &&
          criticalSolid == other.criticalSolid &&
          criticalSolidPressed == other.criticalSolidPressed &&
          criticalWeak == other.criticalWeak &&
          criticalWeakPressed == other.criticalWeakPressed &&
          disabled == other.disabled &&
          informativeSolid == other.informativeSolid &&
          informativeSolidPressed == other.informativeSolidPressed &&
          informativeWeak == other.informativeWeak &&
          informativeWeakPressed == other.informativeWeakPressed &&
          layerBasement == other.layerBasement &&
          layerDefault == other.layerDefault &&
          layerDefaultPressed == other.layerDefaultPressed &&
          layerFloating == other.layerFloating &&
          layerFloatingPressed == other.layerFloatingPressed &&
          neutralMuted == other.neutralMuted &&
          neutralSolid == other.neutralSolid &&
          neutralSolidPressed == other.neutralSolidPressed &&
          neutralSubtle == other.neutralSubtle &&
          neutralWeak == other.neutralWeak &&
          neutralWeakAlpha == other.neutralWeakAlpha &&
          neutralWeakAlphaPressed == other.neutralWeakAlphaPressed &&
          neutralWeakPressed == other.neutralWeakPressed &&
          overlay == other.overlay &&
          overlayMuted == other.overlayMuted &&
          positiveSolid == other.positiveSolid &&
          positiveSolidPressed == other.positiveSolidPressed &&
          positiveWeak == other.positiveWeak &&
          positiveWeakPressed == other.positiveWeakPressed &&
          transparent == other.transparent &&
          transparentPressed == other.transparentPressed &&
          transparentSelected == other.transparentSelected &&
          transparentSelectedPressed == other.transparentSelectedPressed &&
          warningSolid == other.warningSolid &&
          warningSolidPressed == other.warningSolidPressed &&
          warningWeak == other.warningWeak &&
          warningWeakPressed == other.warningWeakPressed;

  @override
  int get hashCode => Object.hashAll([
    brandSolid,
    brandSolidPressed,
    brandWeak,
    brandWeakPressed,
    criticalSolid,
    criticalSolidPressed,
    criticalWeak,
    criticalWeakPressed,
    disabled,
    informativeSolid,
    informativeSolidPressed,
    informativeWeak,
    informativeWeakPressed,
    layerBasement,
    layerDefault,
    layerDefaultPressed,
    layerFloating,
    layerFloatingPressed,
    neutralMuted,
    neutralSolid,
    neutralSolidPressed,
    neutralSubtle,
    neutralWeak,
    neutralWeakAlpha,
    neutralWeakAlphaPressed,
    neutralWeakPressed,
    overlay,
    overlayMuted,
    positiveSolid,
    positiveSolidPressed,
    positiveWeak,
    positiveWeakPressed,
    transparent,
    transparentPressed,
    transparentSelected,
    transparentSelectedPressed,
    warningSolid,
    warningSolidPressed,
    warningWeak,
    warningWeakPressed,
  ]);
}
