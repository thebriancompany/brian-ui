import 'package:flutter/foundation.dart';

import 'brian_control_style.dart';

/// 크기별 컴포넌트 스타일입니다.
///
/// {@category Theme}
@immutable
class BrianChipStyles {
  const BrianChipStyles({
    this.small = const BrianControlStyle(),
    this.medium = const BrianControlStyle(),
    this.large = const BrianControlStyle(),
  });
  final BrianControlStyle small;
  final BrianControlStyle medium;
  final BrianControlStyle large;
  BrianChipStyles copyWith({
    BrianControlStyle? small,
    BrianControlStyle? medium,
    BrianControlStyle? large,
  }) => BrianChipStyles(
    small: small ?? this.small,
    medium: medium ?? this.medium,
    large: large ?? this.large,
  );
  BrianChipStyles lerp(BrianChipStyles other, double t) => BrianChipStyles(
    small: small.lerp(other.small, t),
    medium: medium.lerp(other.medium, t),
    large: large.lerp(other.large, t),
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BrianChipStyles &&
          small == other.small &&
          medium == other.medium &&
          large == other.large;
  @override
  int get hashCode => Object.hashAll([small, medium, large]);
}
