import 'dart:ui' show lerpDouble;

import 'package:flutter/widgets.dart';

/// 테마별 논리 픽셀 스케일입니다. 기본값은 기존 정적 상수와 같습니다.
///
/// {@category Theme}
@immutable
class BrianRadiusTokens {
  const BrianRadiusTokens({
    this.r0Point5 = 2,
    this.r1 = 4,
    this.r1Point5 = 6,
    this.r2 = 8,
    this.r2Point5 = 10,
    this.r3 = 12,
    this.r3Point5 = 14,
    this.r4 = 16,
    this.r5 = 20,
    this.r6 = 24,
  });
  final double r0Point5;
  final double r1;
  final double r1Point5;
  final double r2;
  final double r2Point5;
  final double r3;
  final double r3Point5;
  final double r4;
  final double r5;
  final double r6;
  BrianRadiusTokens copyWith({
    double? r0Point5,
    double? r1,
    double? r1Point5,
    double? r2,
    double? r2Point5,
    double? r3,
    double? r3Point5,
    double? r4,
    double? r5,
    double? r6,
  }) => BrianRadiusTokens(
    r0Point5: r0Point5 ?? this.r0Point5,
    r1: r1 ?? this.r1,
    r1Point5: r1Point5 ?? this.r1Point5,
    r2: r2 ?? this.r2,
    r2Point5: r2Point5 ?? this.r2Point5,
    r3: r3 ?? this.r3,
    r3Point5: r3Point5 ?? this.r3Point5,
    r4: r4 ?? this.r4,
    r5: r5 ?? this.r5,
    r6: r6 ?? this.r6,
  );
  BrianRadiusTokens lerp(BrianRadiusTokens other, double t) =>
      BrianRadiusTokens(
        r0Point5: lerpDouble(r0Point5, other.r0Point5, t)!,
        r1: lerpDouble(r1, other.r1, t)!,
        r1Point5: lerpDouble(r1Point5, other.r1Point5, t)!,
        r2: lerpDouble(r2, other.r2, t)!,
        r2Point5: lerpDouble(r2Point5, other.r2Point5, t)!,
        r3: lerpDouble(r3, other.r3, t)!,
        r3Point5: lerpDouble(r3Point5, other.r3Point5, t)!,
        r4: lerpDouble(r4, other.r4, t)!,
        r5: lerpDouble(r5, other.r5, t)!,
        r6: lerpDouble(r6, other.r6, t)!,
      );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BrianRadiusTokens &&
          r0Point5 == other.r0Point5 &&
          r1 == other.r1 &&
          r1Point5 == other.r1Point5 &&
          r2 == other.r2 &&
          r2Point5 == other.r2Point5 &&
          r3 == other.r3 &&
          r3Point5 == other.r3Point5 &&
          r4 == other.r4 &&
          r5 == other.r5 &&
          r6 == other.r6;
  @override
  int get hashCode => Object.hashAll([
    r0Point5,
    r1,
    r1Point5,
    r2,
    r2Point5,
    r3,
    r3Point5,
    r4,
    r5,
    r6,
  ]);
}
