import 'package:flutter/widgets.dart';

import '../theme/brian_spacing_tokens.dart';
import '../typography/brian_typography.dart';
import 'brian_button.dart';

class ButtonMetrics {
  ButtonMetrics(
    this.size,
    this.typography, [
    this.spacing = const BrianSpacingTokens(),
  ]);
  final BrianSpacingTokens spacing;
  final BrianButtonSize size;
  final BrianTypography typography;

  double get borderWidth => 1;

  double get height => switch (size) {
    BrianButtonSize.xsmall => spacing.x8,
    BrianButtonSize.small => spacing.x9,
    BrianButtonSize.medium => spacing.x10,
    BrianButtonSize.large => spacing.x13,
  };
  double get paddingX => switch (size) {
    BrianButtonSize.xsmall || BrianButtonSize.small => spacing.x3Point5,
    BrianButtonSize.medium => spacing.x4,
    BrianButtonSize.large => spacing.x5,
  };
  double get paddingY => switch (size) {
    BrianButtonSize.xsmall => spacing.x1Point5,
    BrianButtonSize.small => spacing.x2,
    BrianButtonSize.medium => spacing.x2Point5,
    BrianButtonSize.large => spacing.x3Point5,
  };
  double get gap => switch (size) {
    BrianButtonSize.xsmall || BrianButtonSize.small => spacing.x1,
    BrianButtonSize.medium => spacing.x1Point5,
    BrianButtonSize.large => spacing.x2,
  };
  double get iconSize => switch (size) {
    BrianButtonSize.xsmall || BrianButtonSize.small => spacing.x3Point5,
    BrianButtonSize.medium => spacing.x4,
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
