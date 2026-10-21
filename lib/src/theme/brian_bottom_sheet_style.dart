import 'dart:ui' show lerpDouble;

import 'package:flutter/widgets.dart';

/// 시트의 너비 상한·패딩·영역 간격·모서리를 덮어씁니다.
///
/// null은 토큰 기본값을 사용합니다. copyWith의 null은 기존 값을 유지합니다.
/// 양쪽 값이 있으면 보간하고, 한쪽이 null이면 0.5에서 전환합니다.
///
/// {@category Theme}
@immutable
class BrianBottomSheetStyle {
  const BrianBottomSheetStyle({
    this.maxWidth,
    this.padding,
    this.sectionGap,
    this.borderRadius,
  });
  final double? maxWidth;
  final EdgeInsetsGeometry? padding;
  final double? sectionGap;
  final BorderRadiusGeometry? borderRadius;
  BrianBottomSheetStyle copyWith({
    double? maxWidth,
    EdgeInsetsGeometry? padding,
    double? sectionGap,
    BorderRadiusGeometry? borderRadius,
  }) => BrianBottomSheetStyle(
    maxWidth: maxWidth ?? this.maxWidth,
    padding: padding ?? this.padding,
    sectionGap: sectionGap ?? this.sectionGap,
    borderRadius: borderRadius ?? this.borderRadius,
  );
  BrianBottomSheetStyle lerp(BrianBottomSheetStyle other, double t) =>
      BrianBottomSheetStyle(
        maxWidth: maxWidth == null || other.maxWidth == null
            ? (t < .5 ? maxWidth : other.maxWidth)
            : lerpDouble(maxWidth, other.maxWidth, t),
        padding: padding == null || other.padding == null
            ? (t < .5 ? padding : other.padding)
            : EdgeInsetsGeometry.lerp(padding, other.padding, t),
        sectionGap: sectionGap == null || other.sectionGap == null
            ? (t < .5 ? sectionGap : other.sectionGap)
            : lerpDouble(sectionGap, other.sectionGap, t),
        borderRadius: borderRadius == null || other.borderRadius == null
            ? (t < .5 ? borderRadius : other.borderRadius)
            : BorderRadiusGeometry.lerp(borderRadius, other.borderRadius, t),
      );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BrianBottomSheetStyle &&
          maxWidth == other.maxWidth &&
          padding == other.padding &&
          sectionGap == other.sectionGap &&
          borderRadius == other.borderRadius;
  @override
  int get hashCode =>
      Object.hashAll([maxWidth, padding, sectionGap, borderRadius]);
}
