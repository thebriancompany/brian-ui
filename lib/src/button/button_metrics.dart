import 'package:flutter/widgets.dart';

import '../spacing/brian_spacing.dart';
import '../typography/brian_typography.dart';
import 'brian_button.dart';

class ButtonMetrics {
  ButtonMetrics(this.size, this.typography);
  final BrianButtonSize size;
  final BrianTypography typography;

  double get borderWidth => 1;

  double get height => switch (size) {
    BrianButtonSize.xsmall => BrianSpacing.x8,
    BrianButtonSize.small => BrianSpacing.x9,
    BrianButtonSize.medium => BrianSpacing.x10,
    BrianButtonSize.large => BrianSpacing.x13,
  };
  double get paddingX => switch (size) {
    BrianButtonSize.xsmall || BrianButtonSize.small => BrianSpacing.x3Point5,
    BrianButtonSize.medium => BrianSpacing.x4,
    BrianButtonSize.large => BrianSpacing.x5,
  };
  double get paddingY => switch (size) {
    BrianButtonSize.xsmall => BrianSpacing.x1Point5,
    BrianButtonSize.small => BrianSpacing.x2,
    BrianButtonSize.medium => BrianSpacing.x2Point5,
    BrianButtonSize.large => BrianSpacing.x3Point5,
  };
  double get gap => switch (size) {
    BrianButtonSize.xsmall || BrianButtonSize.small => BrianSpacing.x1,
    BrianButtonSize.medium => BrianSpacing.x1Point5,
    BrianButtonSize.large => BrianSpacing.x2,
  };
  double get iconSize => switch (size) {
    BrianButtonSize.xsmall || BrianButtonSize.small => BrianSpacing.x3Point5,
    BrianButtonSize.medium => BrianSpacing.x4,
    BrianButtonSize.large => 22,
  };
  double get progressSize => switch (size) {
    BrianButtonSize.xsmall || BrianButtonSize.small => 14,
    BrianButtonSize.medium => 16,
    BrianButtonSize.large => 18,
  };
  TextStyle get textStyle => switch (size) {
    BrianButtonSize.xsmall => typography.t3Bold,
    BrianButtonSize.small || BrianButtonSize.medium => typography.t4Bold,
    BrianButtonSize.large => typography.t6Bold,
  };
}
