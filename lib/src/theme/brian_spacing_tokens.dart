import 'dart:ui' show lerpDouble;

import 'package:flutter/widgets.dart';

/// 테마별 논리 픽셀 스케일입니다. 기본값은 기존 정적 상수와 같습니다.
///
/// {@category Theme}
@immutable
class BrianSpacingTokens {
  const BrianSpacingTokens({
    this.x0Point5 = 2,
    this.x1 = 4,
    this.x1Point5 = 6,
    this.x2 = 8,
    this.x2Point5 = 10,
    this.x3 = 12,
    this.x3Point5 = 14,
    this.x4 = 16,
    this.x4Point5 = 18,
    this.x5 = 20,
    this.x6 = 24,
    this.x7 = 28,
    this.x8 = 32,
    this.x9 = 36,
    this.x10 = 40,
    this.x12 = 48,
    this.x13 = 52,
    this.x14 = 56,
    this.x16 = 64,
  });
  final double x0Point5;
  final double x1;
  final double x1Point5;
  final double x2;
  final double x2Point5;
  final double x3;
  final double x3Point5;
  final double x4;
  final double x4Point5;
  final double x5;
  final double x6;
  final double x7;
  final double x8;
  final double x9;
  final double x10;
  final double x12;
  final double x13;
  final double x14;
  final double x16;
  BrianSpacingTokens copyWith({
    double? x0Point5,
    double? x1,
    double? x1Point5,
    double? x2,
    double? x2Point5,
    double? x3,
    double? x3Point5,
    double? x4,
    double? x4Point5,
    double? x5,
    double? x6,
    double? x7,
    double? x8,
    double? x9,
    double? x10,
    double? x12,
    double? x13,
    double? x14,
    double? x16,
  }) => BrianSpacingTokens(
    x0Point5: x0Point5 ?? this.x0Point5,
    x1: x1 ?? this.x1,
    x1Point5: x1Point5 ?? this.x1Point5,
    x2: x2 ?? this.x2,
    x2Point5: x2Point5 ?? this.x2Point5,
    x3: x3 ?? this.x3,
    x3Point5: x3Point5 ?? this.x3Point5,
    x4: x4 ?? this.x4,
    x4Point5: x4Point5 ?? this.x4Point5,
    x5: x5 ?? this.x5,
    x6: x6 ?? this.x6,
    x7: x7 ?? this.x7,
    x8: x8 ?? this.x8,
    x9: x9 ?? this.x9,
    x10: x10 ?? this.x10,
    x12: x12 ?? this.x12,
    x13: x13 ?? this.x13,
    x14: x14 ?? this.x14,
    x16: x16 ?? this.x16,
  );
  BrianSpacingTokens lerp(BrianSpacingTokens other, double t) =>
      BrianSpacingTokens(
        x0Point5: lerpDouble(x0Point5, other.x0Point5, t)!,
        x1: lerpDouble(x1, other.x1, t)!,
        x1Point5: lerpDouble(x1Point5, other.x1Point5, t)!,
        x2: lerpDouble(x2, other.x2, t)!,
        x2Point5: lerpDouble(x2Point5, other.x2Point5, t)!,
        x3: lerpDouble(x3, other.x3, t)!,
        x3Point5: lerpDouble(x3Point5, other.x3Point5, t)!,
        x4: lerpDouble(x4, other.x4, t)!,
        x4Point5: lerpDouble(x4Point5, other.x4Point5, t)!,
        x5: lerpDouble(x5, other.x5, t)!,
        x6: lerpDouble(x6, other.x6, t)!,
        x7: lerpDouble(x7, other.x7, t)!,
        x8: lerpDouble(x8, other.x8, t)!,
        x9: lerpDouble(x9, other.x9, t)!,
        x10: lerpDouble(x10, other.x10, t)!,
        x12: lerpDouble(x12, other.x12, t)!,
        x13: lerpDouble(x13, other.x13, t)!,
        x14: lerpDouble(x14, other.x14, t)!,
        x16: lerpDouble(x16, other.x16, t)!,
      );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BrianSpacingTokens &&
          x0Point5 == other.x0Point5 &&
          x1 == other.x1 &&
          x1Point5 == other.x1Point5 &&
          x2 == other.x2 &&
          x2Point5 == other.x2Point5 &&
          x3 == other.x3 &&
          x3Point5 == other.x3Point5 &&
          x4 == other.x4 &&
          x4Point5 == other.x4Point5 &&
          x5 == other.x5 &&
          x6 == other.x6 &&
          x7 == other.x7 &&
          x8 == other.x8 &&
          x9 == other.x9 &&
          x10 == other.x10 &&
          x12 == other.x12 &&
          x13 == other.x13 &&
          x14 == other.x14 &&
          x16 == other.x16;
  @override
  int get hashCode => Object.hashAll([
    x0Point5,
    x1,
    x1Point5,
    x2,
    x2Point5,
    x3,
    x3Point5,
    x4,
    x4Point5,
    x5,
    x6,
    x7,
    x8,
    x9,
    x10,
    x12,
    x13,
    x14,
    x16,
  ]);
}
