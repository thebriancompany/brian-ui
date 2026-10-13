import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

/// 텍스트·아이콘의 역할 색상입니다.
///
/// {@category Color}
@immutable
class BrianForegroundColors {
  const BrianForegroundColors({
    required this.brand,
    required this.brandContrast,
    required this.critical,
    required this.criticalContrast,
    required this.disabled,
    required this.informative,
    required this.informativeContrast,
    required this.neutral,
    required this.neutralMuted,
    required this.neutralSubtle,
    required this.onBrandSolid,
    required this.onCriticalSolid,
    required this.onInformativeSolid,
    required this.onNeutralSolid,
    required this.onPositiveSolid,
    required this.onWarningSolid,
    required this.placeholder,
    required this.positive,
    required this.positiveContrast,
    required this.warning,
    required this.warningContrast,
  });

  /// 제품의 주요 행동을 강조하는 전경입니다.
  final Color brand;

  /// 제품의 주요 행동을 강조하는 전경입니다. 전경 대비를 강화한 변형으로, 본문용 조합의 후보입니다.
  final Color brandContrast;

  /// 오류·위험 상태를 전달하는 전경입니다.
  final Color critical;

  /// 오류·위험 상태를 전달하는 전경입니다. 전경 대비를 강화한 변형으로, 본문용 조합의 후보입니다.
  final Color criticalContrast;

  /// 사용할 수 없는 요소의 전경입니다. 일반 콘텐츠의 강조도를 낮추는 용도로 사용하지 않습니다.
  final Color disabled;

  /// 안내·정보를 전달하는 전경입니다.
  final Color informative;

  /// 안내·정보를 전달하는 전경입니다. 전경 대비를 강화한 변형으로, 본문용 조합의 후보입니다.
  final Color informativeContrast;

  /// 일반 콘텐츠를 표현하는 전경입니다.
  final Color neutral;

  /// 본문보다 낮은 강조도의 전경입니다. 작은 글자는 배경과 대비를 확인합니다.
  final Color neutralMuted;

  /// 낮은 강조도의 전경입니다. 작은 본문 글자에 사용하기 전 대비를 검증합니다.
  final Color neutralSubtle;

  /// `background.brandSolid` 위에 놓는 전경입니다.
  ///
  /// 기본 짝도 작은 글자의 4.5:1 대비를 항상 만족하지는 않습니다. 색상 가이드의 대비표를 확인합니다.
  final Color onBrandSolid;

  /// `background.criticalSolid` 위에 놓는 전경입니다.
  ///
  /// 기본 짝도 작은 글자의 4.5:1 대비를 항상 만족하지는 않습니다. 색상 가이드의 대비표를 확인합니다.
  final Color onCriticalSolid;

  /// `background.informativeSolid` 위에 놓는 전경입니다.
  ///
  /// 기본 짝도 작은 글자의 4.5:1 대비를 항상 만족하지는 않습니다. 색상 가이드의 대비표를 확인합니다.
  final Color onInformativeSolid;

  /// `background.neutralSolid` 위에 놓는 전경입니다.
  ///
  /// 기본 짝도 작은 글자의 4.5:1 대비를 항상 만족하지는 않습니다. 색상 가이드의 대비표를 확인합니다.
  final Color onNeutralSolid;

  /// `background.positiveSolid` 위에 놓는 전경입니다.
  ///
  /// 기본 짝도 작은 글자의 4.5:1 대비를 항상 만족하지는 않습니다. 색상 가이드의 대비표를 확인합니다.
  final Color onPositiveSolid;

  /// `background.warningSolid` 위에 놓는 전경입니다.
  ///
  /// 기본 짝도 작은 글자의 4.5:1 대비를 항상 만족하지는 않습니다. 색상 가이드의 대비표를 확인합니다.
  final Color onWarningSolid;

  /// 입력 전 힌트를 표시하는 전경입니다. 입력값이나 필수 안내 본문에 사용하지 않습니다.
  final Color placeholder;

  /// 성공·완료 상태를 전달하는 전경입니다.
  final Color positive;

  /// 성공·완료 상태를 전달하는 전경입니다. 전경 대비를 강화한 변형으로, 본문용 조합의 후보입니다.
  final Color positiveContrast;

  /// 주의가 필요한 상태를 전달하는 전경입니다.
  final Color warning;

  /// 주의가 필요한 상태를 전달하는 전경입니다. 전경 대비를 강화한 변형으로, 본문용 조합의 후보입니다.
  final Color warningContrast;

  BrianForegroundColors copyWith({
    Color? brand,
    Color? brandContrast,
    Color? critical,
    Color? criticalContrast,
    Color? disabled,
    Color? informative,
    Color? informativeContrast,
    Color? neutral,
    Color? neutralMuted,
    Color? neutralSubtle,
    Color? onBrandSolid,
    Color? onCriticalSolid,
    Color? onInformativeSolid,
    Color? onNeutralSolid,
    Color? onPositiveSolid,
    Color? onWarningSolid,
    Color? placeholder,
    Color? positive,
    Color? positiveContrast,
    Color? warning,
    Color? warningContrast,
  }) => BrianForegroundColors(
    brand: brand ?? this.brand,
    brandContrast: brandContrast ?? this.brandContrast,
    critical: critical ?? this.critical,
    criticalContrast: criticalContrast ?? this.criticalContrast,
    disabled: disabled ?? this.disabled,
    informative: informative ?? this.informative,
    informativeContrast: informativeContrast ?? this.informativeContrast,
    neutral: neutral ?? this.neutral,
    neutralMuted: neutralMuted ?? this.neutralMuted,
    neutralSubtle: neutralSubtle ?? this.neutralSubtle,
    onBrandSolid: onBrandSolid ?? this.onBrandSolid,
    onCriticalSolid: onCriticalSolid ?? this.onCriticalSolid,
    onInformativeSolid: onInformativeSolid ?? this.onInformativeSolid,
    onNeutralSolid: onNeutralSolid ?? this.onNeutralSolid,
    onPositiveSolid: onPositiveSolid ?? this.onPositiveSolid,
    onWarningSolid: onWarningSolid ?? this.onWarningSolid,
    placeholder: placeholder ?? this.placeholder,
    positive: positive ?? this.positive,
    positiveContrast: positiveContrast ?? this.positiveContrast,
    warning: warning ?? this.warning,
    warningContrast: warningContrast ?? this.warningContrast,
  );

  /// [t]가 0이면 이 값, 1이면 [other]의 색상입니다.
  BrianForegroundColors lerp(BrianForegroundColors other, double t) {
    if (t == 0) return this;
    if (t == 1) return other;
    return BrianForegroundColors(
      brand: Color.lerp(brand, other.brand, t)!,
      brandContrast: Color.lerp(brandContrast, other.brandContrast, t)!,
      critical: Color.lerp(critical, other.critical, t)!,
      criticalContrast: Color.lerp(
        criticalContrast,
        other.criticalContrast,
        t,
      )!,
      disabled: Color.lerp(disabled, other.disabled, t)!,
      informative: Color.lerp(informative, other.informative, t)!,
      informativeContrast: Color.lerp(
        informativeContrast,
        other.informativeContrast,
        t,
      )!,
      neutral: Color.lerp(neutral, other.neutral, t)!,
      neutralMuted: Color.lerp(neutralMuted, other.neutralMuted, t)!,
      neutralSubtle: Color.lerp(neutralSubtle, other.neutralSubtle, t)!,
      onBrandSolid: Color.lerp(onBrandSolid, other.onBrandSolid, t)!,
      onCriticalSolid: Color.lerp(onCriticalSolid, other.onCriticalSolid, t)!,
      onInformativeSolid: Color.lerp(
        onInformativeSolid,
        other.onInformativeSolid,
        t,
      )!,
      onNeutralSolid: Color.lerp(onNeutralSolid, other.onNeutralSolid, t)!,
      onPositiveSolid: Color.lerp(onPositiveSolid, other.onPositiveSolid, t)!,
      onWarningSolid: Color.lerp(onWarningSolid, other.onWarningSolid, t)!,
      placeholder: Color.lerp(placeholder, other.placeholder, t)!,
      positive: Color.lerp(positive, other.positive, t)!,
      positiveContrast: Color.lerp(
        positiveContrast,
        other.positiveContrast,
        t,
      )!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningContrast: Color.lerp(warningContrast, other.warningContrast, t)!,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BrianForegroundColors &&
          brand == other.brand &&
          brandContrast == other.brandContrast &&
          critical == other.critical &&
          criticalContrast == other.criticalContrast &&
          disabled == other.disabled &&
          informative == other.informative &&
          informativeContrast == other.informativeContrast &&
          neutral == other.neutral &&
          neutralMuted == other.neutralMuted &&
          neutralSubtle == other.neutralSubtle &&
          onBrandSolid == other.onBrandSolid &&
          onCriticalSolid == other.onCriticalSolid &&
          onInformativeSolid == other.onInformativeSolid &&
          onNeutralSolid == other.onNeutralSolid &&
          onPositiveSolid == other.onPositiveSolid &&
          onWarningSolid == other.onWarningSolid &&
          placeholder == other.placeholder &&
          positive == other.positive &&
          positiveContrast == other.positiveContrast &&
          warning == other.warning &&
          warningContrast == other.warningContrast;

  @override
  int get hashCode => Object.hashAll([
    brand,
    brandContrast,
    critical,
    criticalContrast,
    disabled,
    informative,
    informativeContrast,
    neutral,
    neutralMuted,
    neutralSubtle,
    onBrandSolid,
    onCriticalSolid,
    onInformativeSolid,
    onNeutralSolid,
    onPositiveSolid,
    onWarningSolid,
    placeholder,
    positive,
    positiveContrast,
    warning,
    warningContrast,
  ]);
}
