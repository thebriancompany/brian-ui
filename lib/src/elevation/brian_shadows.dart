import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

/// 표면의 시각적 깊이를 표현하는 세 단계의 그림자입니다.
///
/// 기본값은 라이트·다크에서 같으며, 모든 길이는 logical pixel입니다.
/// 단계는 실제 쌓임 순서나 Global·Local 계층 번호를 의미하지 않습니다.
/// 다크 모드에서는 표면색과 경계색을 함께 고려합니다.
///
/// {@category Elevation}
@immutable
class BrianShadows {
  /// 기본값의 이동/흐림/확장과 색상은 다음과 같습니다.
  ///
  /// - s1: (0, 1)/4/0, HEX `#00000014`, ARGB `0x14000000`.
  /// - s2: (0, 2)/10/0, HEX `#0000001A`, ARGB `0x1A000000`.
  /// - s3: (0, 4)/16/0, HEX `#0000001F`, ARGB `0x1F000000`.
  const BrianShadows({
    this.s1 = const BoxShadow(
      color: Color(0x14000000),
      offset: Offset(0, 1),
      blurRadius: 4,
    ),
    this.s2 = const BoxShadow(
      color: Color(0x1A000000),
      offset: Offset(0, 2),
      blurRadius: 10,
    ),
    this.s3 = const BoxShadow(
      color: Color(0x1F000000),
      offset: Offset(0, 4),
      blurRadius: 16,
    ),
  });

  final BoxShadow s1;

  final BoxShadow s2;

  final BoxShadow s3;

  BrianShadows copyWith({BoxShadow? s1, BoxShadow? s2, BoxShadow? s3}) =>
      BrianShadows(s1: s1 ?? this.s1, s2: s2 ?? this.s2, s3: s3 ?? this.s3);

  /// 각 단계를 [BoxShadow.lerp]의 규칙으로 보간합니다.
  ///
  /// [t]가 0이면 현재 값, 1이면 대상 값입니다.
  BrianShadows lerp(BrianShadows other, double t) {
    if (t == 0) return this;
    if (t == 1) return other;
    return BrianShadows(
      s1: BoxShadow.lerp(s1, other.s1, t)!,
      s2: BoxShadow.lerp(s2, other.s2, t)!,
      s3: BoxShadow.lerp(s3, other.s3, t)!,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BrianShadows &&
          s1 == other.s1 &&
          s2 == other.s2 &&
          s3 == other.s3;

  @override
  int get hashCode => Object.hash(s1, s2, s3);
}
