import 'package:flutter/foundation.dart';

import 'brian_control_style.dart';

/// 크기별 컴포넌트 스타일입니다.
///
/// {@category Theme}
@immutable
class BrianButtonStyles {
  const BrianButtonStyles({
    this.xsmall = const BrianControlStyle(),
    this.small = const BrianControlStyle(),
    this.medium = const BrianControlStyle(),
    this.large = const BrianControlStyle(),
  });
  final BrianControlStyle xsmall;
  final BrianControlStyle small;
  final BrianControlStyle medium;
  final BrianControlStyle large;
  BrianButtonStyles copyWith({
    BrianControlStyle? xsmall,
    BrianControlStyle? small,
    BrianControlStyle? medium,
    BrianControlStyle? large,
  }) => BrianButtonStyles(
    xsmall: xsmall ?? this.xsmall,
    small: small ?? this.small,
    medium: medium ?? this.medium,
    large: large ?? this.large,
  );
  BrianButtonStyles lerp(BrianButtonStyles other, double t) =>
      BrianButtonStyles(
        xsmall: xsmall.lerp(other.xsmall, t),
        small: small.lerp(other.small, t),
        medium: medium.lerp(other.medium, t),
        large: large.lerp(other.large, t),
      );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BrianButtonStyles &&
          xsmall == other.xsmall &&
          small == other.small &&
          medium == other.medium &&
          large == other.large;
  @override
  int get hashCode => Object.hashAll([xsmall, small, medium, large]);
}
