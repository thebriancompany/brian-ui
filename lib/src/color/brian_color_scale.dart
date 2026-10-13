import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

/// 라이트 또는 다크 모드의 유채색 10단계입니다.
///
/// 단계 숫자는 고정 밝기가 아니며, 화면 모드에 따라 실제 명도가 달라집니다.
/// 일반 UI에는 단계 값보다 역할 색상을 우선 사용합니다.
///
/// {@category Color}
@immutable
class BrianColorScale {
  const BrianColorScale({
    required this.step100,
    required this.step200,
    required this.step300,
    required this.step400,
    required this.step500,
    required this.step600,
    required this.step700,
    required this.step800,
    required this.step900,
    required this.step1000,
  });

  final Color step100;

  final Color step200;

  final Color step300;

  final Color step400;

  final Color step500;

  final Color step600;

  final Color step700;

  final Color step800;

  final Color step900;

  final Color step1000;

  BrianColorScale copyWith({
    Color? step100,
    Color? step200,
    Color? step300,
    Color? step400,
    Color? step500,
    Color? step600,
    Color? step700,
    Color? step800,
    Color? step900,
    Color? step1000,
  }) => BrianColorScale(
    step100: step100 ?? this.step100,
    step200: step200 ?? this.step200,
    step300: step300 ?? this.step300,
    step400: step400 ?? this.step400,
    step500: step500 ?? this.step500,
    step600: step600 ?? this.step600,
    step700: step700 ?? this.step700,
    step800: step800 ?? this.step800,
    step900: step900 ?? this.step900,
    step1000: step1000 ?? this.step1000,
  );

  /// [t]가 0이면 이 값, 1이면 [other]의 색상입니다.
  BrianColorScale lerp(BrianColorScale other, double t) {
    if (t == 0) return this;
    if (t == 1) return other;
    return BrianColorScale(
      step100: Color.lerp(step100, other.step100, t)!,
      step200: Color.lerp(step200, other.step200, t)!,
      step300: Color.lerp(step300, other.step300, t)!,
      step400: Color.lerp(step400, other.step400, t)!,
      step500: Color.lerp(step500, other.step500, t)!,
      step600: Color.lerp(step600, other.step600, t)!,
      step700: Color.lerp(step700, other.step700, t)!,
      step800: Color.lerp(step800, other.step800, t)!,
      step900: Color.lerp(step900, other.step900, t)!,
      step1000: Color.lerp(step1000, other.step1000, t)!,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BrianColorScale &&
          step100 == other.step100 &&
          step200 == other.step200 &&
          step300 == other.step300 &&
          step400 == other.step400 &&
          step500 == other.step500 &&
          step600 == other.step600 &&
          step700 == other.step700 &&
          step800 == other.step800 &&
          step900 == other.step900 &&
          step1000 == other.step1000;

  @override
  int get hashCode => Object.hashAll([
    step100,
    step200,
    step300,
    step400,
    step500,
    step600,
    step700,
    step800,
    step900,
    step1000,
  ]);
}

/// 라이트 또는 다크 모드의 무채색 11단계입니다.
///
/// 단계 숫자는 고정 밝기가 아니며, 화면 모드에 따라 실제 명도가 달라집니다.
/// 일반 UI에는 단계 값보다 역할 색상을 우선 사용합니다.
///
/// {@category Color}
@immutable
class BrianGrayScale {
  const BrianGrayScale({
    required this.step0,
    required this.step100,
    required this.step200,
    required this.step300,
    required this.step400,
    required this.step500,
    required this.step600,
    required this.step700,
    required this.step800,
    required this.step900,
    required this.step1000,
  });

  final Color step0;

  final Color step100;

  final Color step200;

  final Color step300;

  final Color step400;

  final Color step500;

  final Color step600;

  final Color step700;

  final Color step800;

  final Color step900;

  final Color step1000;

  BrianGrayScale copyWith({
    Color? step0,
    Color? step100,
    Color? step200,
    Color? step300,
    Color? step400,
    Color? step500,
    Color? step600,
    Color? step700,
    Color? step800,
    Color? step900,
    Color? step1000,
  }) => BrianGrayScale(
    step0: step0 ?? this.step0,
    step100: step100 ?? this.step100,
    step200: step200 ?? this.step200,
    step300: step300 ?? this.step300,
    step400: step400 ?? this.step400,
    step500: step500 ?? this.step500,
    step600: step600 ?? this.step600,
    step700: step700 ?? this.step700,
    step800: step800 ?? this.step800,
    step900: step900 ?? this.step900,
    step1000: step1000 ?? this.step1000,
  );

  /// [t]가 0이면 이 값, 1이면 [other]의 색상입니다.
  BrianGrayScale lerp(BrianGrayScale other, double t) {
    if (t == 0) return this;
    if (t == 1) return other;
    return BrianGrayScale(
      step0: Color.lerp(step0, other.step0, t)!,
      step100: Color.lerp(step100, other.step100, t)!,
      step200: Color.lerp(step200, other.step200, t)!,
      step300: Color.lerp(step300, other.step300, t)!,
      step400: Color.lerp(step400, other.step400, t)!,
      step500: Color.lerp(step500, other.step500, t)!,
      step600: Color.lerp(step600, other.step600, t)!,
      step700: Color.lerp(step700, other.step700, t)!,
      step800: Color.lerp(step800, other.step800, t)!,
      step900: Color.lerp(step900, other.step900, t)!,
      step1000: Color.lerp(step1000, other.step1000, t)!,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BrianGrayScale &&
          step0 == other.step0 &&
          step100 == other.step100 &&
          step200 == other.step200 &&
          step300 == other.step300 &&
          step400 == other.step400 &&
          step500 == other.step500 &&
          step600 == other.step600 &&
          step700 == other.step700 &&
          step800 == other.step800 &&
          step900 == other.step900 &&
          step1000 == other.step1000;

  @override
  int get hashCode => Object.hashAll([
    step0,
    step100,
    step200,
    step300,
    step400,
    step500,
    step600,
    step700,
    step800,
    step900,
    step1000,
  ]);
}
