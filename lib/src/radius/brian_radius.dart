/// 논리 픽셀 단위의 모서리 반지름 기본 스케일입니다.
///
/// 테마와 관계없이 같은 값을 사용하며 기기 픽셀 비율을 곱하지 않습니다.
/// 전체 또는 일부 모서리에 Radius·BorderRadius로 변환해 적용합니다.
/// 완전한 원·캡슐은 Flutter의 형태 API로 표현합니다.
///
/// {@category Radius}
abstract final class BrianRadius {
  /// 2 논리 픽셀.
  static const double r0Point5 = 2;

  /// 4 논리 픽셀.
  static const double r1 = 4;

  /// 6 논리 픽셀.
  static const double r1Point5 = 6;

  /// 8 논리 픽셀.
  static const double r2 = 8;

  /// 10 논리 픽셀.
  static const double r2Point5 = 10;

  /// 12 논리 픽셀.
  static const double r3 = 12;

  /// 14 논리 픽셀.
  static const double r3Point5 = 14;

  /// 16 논리 픽셀.
  static const double r4 = 16;

  /// 20 논리 픽셀.
  static const double r5 = 20;

  /// 24 논리 픽셀.
  static const double r6 = 24;
}
