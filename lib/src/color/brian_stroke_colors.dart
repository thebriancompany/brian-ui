import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

/// 외곽선·구분선·포커스의 역할 색상입니다.
///
/// Solid는 강한 경계, Weak는 약한 경계에 사용합니다. 섹션 구분에는
/// [neutralMuted], 반복 항목 구분에는 [neutralSubtle]을 사용합니다.
///
/// {@category Color}
@immutable
class BrianStrokeColors {
  const BrianStrokeColors({
    required this.brandSolid,
    required this.brandWeak,
    required this.criticalSolid,
    required this.criticalWeak,
    required this.focusRing,
    required this.informativeSolid,
    required this.informativeWeak,
    required this.neutralContrast,
    required this.neutralMuted,
    required this.neutralSolid,
    required this.neutralSubtle,
    required this.neutralWeak,
    required this.positiveSolid,
    required this.positiveWeak,
    required this.warningSolid,
    required this.warningWeak,
  });

  final Color brandSolid;

  final Color brandWeak;

  final Color criticalSolid;

  final Color criticalWeak;

  /// 키보드 포커스를 표시하는 윤곽선입니다. 주변 배경에서도 식별 가능한지 확인합니다.
  final Color focusRing;

  final Color informativeSolid;

  final Color informativeWeak;

  /// 중립 외곽선 중 가장 높은 강조도가 필요한 경계에 사용합니다.
  final Color neutralContrast;

  /// 섹션·헤더 등 의미가 달라지는 영역 사이의 구분선입니다.
  final Color neutralMuted;

  final Color neutralSolid;

  /// 리스트처럼 동일한 종류의 항목 사이에 반복되는 구분선입니다.
  final Color neutralSubtle;

  /// 카드·입력창·버튼의 외곽 경계를 그리는 선입니다. 본문 구분선과 구별합니다.
  final Color neutralWeak;

  final Color positiveSolid;

  final Color positiveWeak;

  final Color warningSolid;

  final Color warningWeak;

  BrianStrokeColors copyWith({
    Color? brandSolid,
    Color? brandWeak,
    Color? criticalSolid,
    Color? criticalWeak,
    Color? focusRing,
    Color? informativeSolid,
    Color? informativeWeak,
    Color? neutralContrast,
    Color? neutralMuted,
    Color? neutralSolid,
    Color? neutralSubtle,
    Color? neutralWeak,
    Color? positiveSolid,
    Color? positiveWeak,
    Color? warningSolid,
    Color? warningWeak,
  }) => BrianStrokeColors(
    brandSolid: brandSolid ?? this.brandSolid,
    brandWeak: brandWeak ?? this.brandWeak,
    criticalSolid: criticalSolid ?? this.criticalSolid,
    criticalWeak: criticalWeak ?? this.criticalWeak,
    focusRing: focusRing ?? this.focusRing,
    informativeSolid: informativeSolid ?? this.informativeSolid,
    informativeWeak: informativeWeak ?? this.informativeWeak,
    neutralContrast: neutralContrast ?? this.neutralContrast,
    neutralMuted: neutralMuted ?? this.neutralMuted,
    neutralSolid: neutralSolid ?? this.neutralSolid,
    neutralSubtle: neutralSubtle ?? this.neutralSubtle,
    neutralWeak: neutralWeak ?? this.neutralWeak,
    positiveSolid: positiveSolid ?? this.positiveSolid,
    positiveWeak: positiveWeak ?? this.positiveWeak,
    warningSolid: warningSolid ?? this.warningSolid,
    warningWeak: warningWeak ?? this.warningWeak,
  );

  /// [t]가 0이면 이 값, 1이면 [other]의 색상입니다.
  BrianStrokeColors lerp(BrianStrokeColors other, double t) {
    if (t == 0) return this;
    if (t == 1) return other;
    return BrianStrokeColors(
      brandSolid: Color.lerp(brandSolid, other.brandSolid, t)!,
      brandWeak: Color.lerp(brandWeak, other.brandWeak, t)!,
      criticalSolid: Color.lerp(criticalSolid, other.criticalSolid, t)!,
      criticalWeak: Color.lerp(criticalWeak, other.criticalWeak, t)!,
      focusRing: Color.lerp(focusRing, other.focusRing, t)!,
      informativeSolid: Color.lerp(
        informativeSolid,
        other.informativeSolid,
        t,
      )!,
      informativeWeak: Color.lerp(informativeWeak, other.informativeWeak, t)!,
      neutralContrast: Color.lerp(neutralContrast, other.neutralContrast, t)!,
      neutralMuted: Color.lerp(neutralMuted, other.neutralMuted, t)!,
      neutralSolid: Color.lerp(neutralSolid, other.neutralSolid, t)!,
      neutralSubtle: Color.lerp(neutralSubtle, other.neutralSubtle, t)!,
      neutralWeak: Color.lerp(neutralWeak, other.neutralWeak, t)!,
      positiveSolid: Color.lerp(positiveSolid, other.positiveSolid, t)!,
      positiveWeak: Color.lerp(positiveWeak, other.positiveWeak, t)!,
      warningSolid: Color.lerp(warningSolid, other.warningSolid, t)!,
      warningWeak: Color.lerp(warningWeak, other.warningWeak, t)!,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BrianStrokeColors &&
          brandSolid == other.brandSolid &&
          brandWeak == other.brandWeak &&
          criticalSolid == other.criticalSolid &&
          criticalWeak == other.criticalWeak &&
          focusRing == other.focusRing &&
          informativeSolid == other.informativeSolid &&
          informativeWeak == other.informativeWeak &&
          neutralContrast == other.neutralContrast &&
          neutralMuted == other.neutralMuted &&
          neutralSolid == other.neutralSolid &&
          neutralSubtle == other.neutralSubtle &&
          neutralWeak == other.neutralWeak &&
          positiveSolid == other.positiveSolid &&
          positiveWeak == other.positiveWeak &&
          warningSolid == other.warningSolid &&
          warningWeak == other.warningWeak;

  @override
  int get hashCode => Object.hashAll([
    brandSolid,
    brandWeak,
    criticalSolid,
    criticalWeak,
    focusRing,
    informativeSolid,
    informativeWeak,
    neutralContrast,
    neutralMuted,
    neutralSolid,
    neutralSubtle,
    neutralWeak,
    positiveSolid,
    positiveWeak,
    warningSolid,
    warningWeak,
  ]);
}
