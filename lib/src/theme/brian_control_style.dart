import 'dart:ui' show lerpDouble;

import 'package:flutter/widgets.dart';

/// 버튼·칩의 크기별 덮어쓰기입니다. null 필드는 전역 토큰과 기본값을 따릅니다.
///
/// 패딩은 Directionality에서 해석합니다. shape의 side는 상태별 색상으로 대체합니다.
/// 최소 크기는 부모 제약 안에서 적용하며 콘텐츠는 더 커질 수 있습니다.
/// copyWith의 null은 유지입니다. 초기화하려면 새 스타일을 지정하세요.
/// 보간 시 양쪽에 값이 있으면 보간하고, 한쪽이 null이면 0.5에서 전환합니다.
///
/// {@category Theme}
@immutable
class BrianControlStyle {
  const BrianControlStyle({
    this.minimumSize,
    this.minimumTouchTarget,
    this.padding,
    this.gap,
    this.iconSize,
    this.shape,
  });
  final Size? minimumSize;
  final Size? minimumTouchTarget;
  final EdgeInsetsGeometry? padding;
  final double? gap;
  final double? iconSize;
  final OutlinedBorder? shape;
  BrianControlStyle copyWith({
    Size? minimumSize,
    Size? minimumTouchTarget,
    EdgeInsetsGeometry? padding,
    double? gap,
    double? iconSize,
    OutlinedBorder? shape,
  }) => BrianControlStyle(
    minimumSize: minimumSize ?? this.minimumSize,
    minimumTouchTarget: minimumTouchTarget ?? this.minimumTouchTarget,
    padding: padding ?? this.padding,
    gap: gap ?? this.gap,
    iconSize: iconSize ?? this.iconSize,
    shape: shape ?? this.shape,
  );
  BrianControlStyle lerp(BrianControlStyle other, double t) =>
      BrianControlStyle(
        minimumSize: minimumSize == null || other.minimumSize == null
            ? (t < .5 ? minimumSize : other.minimumSize)
            : Size.lerp(minimumSize, other.minimumSize, t),
        minimumTouchTarget:
            minimumTouchTarget == null || other.minimumTouchTarget == null
            ? (t < .5 ? minimumTouchTarget : other.minimumTouchTarget)
            : Size.lerp(minimumTouchTarget, other.minimumTouchTarget, t),
        padding: padding == null || other.padding == null
            ? (t < .5 ? padding : other.padding)
            : EdgeInsetsGeometry.lerp(padding, other.padding, t),
        gap: gap == null || other.gap == null
            ? (t < .5 ? gap : other.gap)
            : lerpDouble(gap, other.gap, t),
        iconSize: iconSize == null || other.iconSize == null
            ? (t < .5 ? iconSize : other.iconSize)
            : lerpDouble(iconSize, other.iconSize, t),
        shape: shape == null || other.shape == null
            ? (t < .5 ? shape : other.shape)
            : ShapeBorder.lerp(shape, other.shape, t) as OutlinedBorder?,
      );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BrianControlStyle &&
          minimumSize == other.minimumSize &&
          minimumTouchTarget == other.minimumTouchTarget &&
          padding == other.padding &&
          gap == other.gap &&
          iconSize == other.iconSize &&
          shape == other.shape;
  @override
  int get hashCode => Object.hashAll([
    minimumSize,
    minimumTouchTarget,
    padding,
    gap,
    iconSize,
    shape,
  ]);
}
