import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import 'brian_font_size.dart';
import 'brian_font_weight.dart';
import 'brian_line_height.dart';

/// 스케일과 역할별 텍스트 스타일을 담는 불변 값입니다.
///
/// 기본 스타일은 색상과 글꼴을 지정하지 않고 상위 DefaultTextStyle을
/// 상속합니다. 앱에서 글꼴을 등록하고 상위 스타일 또는 개별 스타일에
/// 지정합니다. 라이트·다크의 기본값은 같으며, 확대는 위젯에 맡깁니다.
///
/// {@category Typography}
@immutable
class BrianTypography {
  const BrianTypography({
    this.t1Regular = const TextStyle(
      fontSize: BrianFontSize.t1,
      height: BrianLineHeight.t1 / BrianFontSize.t1,
      fontWeight: BrianFontWeight.regular,
    ),
    this.t1Medium = const TextStyle(
      fontSize: BrianFontSize.t1,
      height: BrianLineHeight.t1 / BrianFontSize.t1,
      fontWeight: BrianFontWeight.medium,
    ),
    this.t1Bold = const TextStyle(
      fontSize: BrianFontSize.t1,
      height: BrianLineHeight.t1 / BrianFontSize.t1,
      fontWeight: BrianFontWeight.bold,
    ),
    this.t2Regular = const TextStyle(
      fontSize: BrianFontSize.t2,
      height: BrianLineHeight.t2 / BrianFontSize.t2,
      fontWeight: BrianFontWeight.regular,
    ),
    this.t2Medium = const TextStyle(
      fontSize: BrianFontSize.t2,
      height: BrianLineHeight.t2 / BrianFontSize.t2,
      fontWeight: BrianFontWeight.medium,
    ),
    this.t2Bold = const TextStyle(
      fontSize: BrianFontSize.t2,
      height: BrianLineHeight.t2 / BrianFontSize.t2,
      fontWeight: BrianFontWeight.bold,
    ),
    this.t3Regular = const TextStyle(
      fontSize: BrianFontSize.t3,
      height: BrianLineHeight.t3 / BrianFontSize.t3,
      fontWeight: BrianFontWeight.regular,
    ),
    this.t3Medium = const TextStyle(
      fontSize: BrianFontSize.t3,
      height: BrianLineHeight.t3 / BrianFontSize.t3,
      fontWeight: BrianFontWeight.medium,
    ),
    this.t3Bold = const TextStyle(
      fontSize: BrianFontSize.t3,
      height: BrianLineHeight.t3 / BrianFontSize.t3,
      fontWeight: BrianFontWeight.bold,
    ),
    this.t4Regular = const TextStyle(
      fontSize: BrianFontSize.t4,
      height: BrianLineHeight.t4 / BrianFontSize.t4,
      fontWeight: BrianFontWeight.regular,
    ),
    this.t4Medium = const TextStyle(
      fontSize: BrianFontSize.t4,
      height: BrianLineHeight.t4 / BrianFontSize.t4,
      fontWeight: BrianFontWeight.medium,
    ),
    this.t4Bold = const TextStyle(
      fontSize: BrianFontSize.t4,
      height: BrianLineHeight.t4 / BrianFontSize.t4,
      fontWeight: BrianFontWeight.bold,
    ),
    this.t5Regular = const TextStyle(
      fontSize: BrianFontSize.t5,
      height: BrianLineHeight.t5 / BrianFontSize.t5,
      fontWeight: BrianFontWeight.regular,
    ),
    this.t5Medium = const TextStyle(
      fontSize: BrianFontSize.t5,
      height: BrianLineHeight.t5 / BrianFontSize.t5,
      fontWeight: BrianFontWeight.medium,
    ),
    this.t5Bold = const TextStyle(
      fontSize: BrianFontSize.t5,
      height: BrianLineHeight.t5 / BrianFontSize.t5,
      fontWeight: BrianFontWeight.bold,
    ),
    this.t6Regular = const TextStyle(
      fontSize: BrianFontSize.t6,
      height: BrianLineHeight.t6 / BrianFontSize.t6,
      fontWeight: BrianFontWeight.regular,
    ),
    this.t6Medium = const TextStyle(
      fontSize: BrianFontSize.t6,
      height: BrianLineHeight.t6 / BrianFontSize.t6,
      fontWeight: BrianFontWeight.medium,
    ),
    this.t6Bold = const TextStyle(
      fontSize: BrianFontSize.t6,
      height: BrianLineHeight.t6 / BrianFontSize.t6,
      fontWeight: BrianFontWeight.bold,
    ),
    this.t7Regular = const TextStyle(
      fontSize: BrianFontSize.t7,
      height: BrianLineHeight.t7 / BrianFontSize.t7,
      fontWeight: BrianFontWeight.regular,
    ),
    this.t7Medium = const TextStyle(
      fontSize: BrianFontSize.t7,
      height: BrianLineHeight.t7 / BrianFontSize.t7,
      fontWeight: BrianFontWeight.medium,
    ),
    this.t7Bold = const TextStyle(
      fontSize: BrianFontSize.t7,
      height: BrianLineHeight.t7 / BrianFontSize.t7,
      fontWeight: BrianFontWeight.bold,
    ),
    this.t8Regular = const TextStyle(
      fontSize: BrianFontSize.t8,
      height: BrianLineHeight.t8 / BrianFontSize.t8,
      fontWeight: BrianFontWeight.regular,
    ),
    this.t8Medium = const TextStyle(
      fontSize: BrianFontSize.t8,
      height: BrianLineHeight.t8 / BrianFontSize.t8,
      fontWeight: BrianFontWeight.medium,
    ),
    this.t8Bold = const TextStyle(
      fontSize: BrianFontSize.t8,
      height: BrianLineHeight.t8 / BrianFontSize.t8,
      fontWeight: BrianFontWeight.bold,
    ),
    this.t9Regular = const TextStyle(
      fontSize: BrianFontSize.t9,
      height: BrianLineHeight.t9 / BrianFontSize.t9,
      fontWeight: BrianFontWeight.regular,
    ),
    this.t9Medium = const TextStyle(
      fontSize: BrianFontSize.t9,
      height: BrianLineHeight.t9 / BrianFontSize.t9,
      fontWeight: BrianFontWeight.medium,
    ),
    this.t9Bold = const TextStyle(
      fontSize: BrianFontSize.t9,
      height: BrianLineHeight.t9 / BrianFontSize.t9,
      fontWeight: BrianFontWeight.bold,
    ),
    this.t10Regular = const TextStyle(
      fontSize: BrianFontSize.t10,
      height: BrianLineHeight.t10 / BrianFontSize.t10,
      fontWeight: BrianFontWeight.regular,
    ),
    this.t10Medium = const TextStyle(
      fontSize: BrianFontSize.t10,
      height: BrianLineHeight.t10 / BrianFontSize.t10,
      fontWeight: BrianFontWeight.medium,
    ),
    this.t10Bold = const TextStyle(
      fontSize: BrianFontSize.t10,
      height: BrianLineHeight.t10 / BrianFontSize.t10,
      fontWeight: BrianFontWeight.bold,
    ),
    this.t11Regular = const TextStyle(
      fontSize: BrianFontSize.t11,
      height: BrianLineHeight.t11 / BrianFontSize.t11,
      fontWeight: BrianFontWeight.regular,
    ),
    this.t11Medium = const TextStyle(
      fontSize: BrianFontSize.t11,
      height: BrianLineHeight.t11 / BrianFontSize.t11,
      fontWeight: BrianFontWeight.medium,
    ),
    this.t11Bold = const TextStyle(
      fontSize: BrianFontSize.t11,
      height: BrianLineHeight.t11 / BrianFontSize.t11,
      fontWeight: BrianFontWeight.bold,
    ),
    this.t12Regular = const TextStyle(
      fontSize: BrianFontSize.t12,
      height: BrianLineHeight.t12 / BrianFontSize.t12,
      fontWeight: BrianFontWeight.regular,
    ),
    this.t12Medium = const TextStyle(
      fontSize: BrianFontSize.t12,
      height: BrianLineHeight.t12 / BrianFontSize.t12,
      fontWeight: BrianFontWeight.medium,
    ),
    this.t12Bold = const TextStyle(
      fontSize: BrianFontSize.t12,
      height: BrianLineHeight.t12 / BrianFontSize.t12,
      fontWeight: BrianFontWeight.bold,
    ),
    this.t13Regular = const TextStyle(
      fontSize: BrianFontSize.t13,
      height: BrianLineHeight.t13 / BrianFontSize.t13,
      fontWeight: BrianFontWeight.regular,
    ),
    this.t13Medium = const TextStyle(
      fontSize: BrianFontSize.t13,
      height: BrianLineHeight.t13 / BrianFontSize.t13,
      fontWeight: BrianFontWeight.medium,
    ),
    this.t13Bold = const TextStyle(
      fontSize: BrianFontSize.t13,
      height: BrianLineHeight.t13 / BrianFontSize.t13,
      fontWeight: BrianFontWeight.bold,
    ),
    this.t14Regular = const TextStyle(
      fontSize: BrianFontSize.t14,
      height: BrianLineHeight.t14 / BrianFontSize.t14,
      fontWeight: BrianFontWeight.regular,
    ),
    this.t14Medium = const TextStyle(
      fontSize: BrianFontSize.t14,
      height: BrianLineHeight.t14 / BrianFontSize.t14,
      fontWeight: BrianFontWeight.medium,
    ),
    this.t14Bold = const TextStyle(
      fontSize: BrianFontSize.t14,
      height: BrianLineHeight.t14 / BrianFontSize.t14,
      fontWeight: BrianFontWeight.bold,
    ),
    this.screenTitle = const TextStyle(
      fontSize: BrianFontSize.t10,
      height: BrianLineHeight.t10 / BrianFontSize.t10,
      fontWeight: BrianFontWeight.bold,
    ),
    this.articleBody = const TextStyle(
      fontSize: BrianFontSize.t5,
      height: BrianLineHeight.t6 / BrianFontSize.t5,
      fontWeight: BrianFontWeight.regular,
    ),
  });

  final TextStyle t1Regular;

  final TextStyle t1Medium;

  final TextStyle t1Bold;

  final TextStyle t2Regular;

  final TextStyle t2Medium;

  final TextStyle t2Bold;

  final TextStyle t3Regular;

  final TextStyle t3Medium;

  final TextStyle t3Bold;

  final TextStyle t4Regular;

  final TextStyle t4Medium;

  final TextStyle t4Bold;

  final TextStyle t5Regular;

  final TextStyle t5Medium;

  final TextStyle t5Bold;

  final TextStyle t6Regular;

  final TextStyle t6Medium;

  final TextStyle t6Bold;

  final TextStyle t7Regular;

  final TextStyle t7Medium;

  final TextStyle t7Bold;

  final TextStyle t8Regular;

  final TextStyle t8Medium;

  final TextStyle t8Bold;

  final TextStyle t9Regular;

  final TextStyle t9Medium;

  final TextStyle t9Bold;

  final TextStyle t10Regular;

  final TextStyle t10Medium;

  final TextStyle t10Bold;

  final TextStyle t11Regular;

  final TextStyle t11Medium;

  final TextStyle t11Bold;

  final TextStyle t12Regular;

  final TextStyle t12Medium;

  final TextStyle t12Bold;

  final TextStyle t13Regular;

  final TextStyle t13Medium;

  final TextStyle t13Bold;

  final TextStyle t14Regular;

  final TextStyle t14Medium;

  final TextStyle t14Bold;

  /// 화면의 주요 제목에 사용합니다.
  final TextStyle screenTitle;

  /// 게시물 본문에 사용하며, 같은 크기의 스케일 스타일보다 줄 간격이 넓습니다.
  final TextStyle articleBody;

  /// 스케일 스타일을 교체해도 역할 스타일은 다시 계산하지 않습니다.
  BrianTypography copyWith({
    TextStyle? t1Regular,
    TextStyle? t1Medium,
    TextStyle? t1Bold,
    TextStyle? t2Regular,
    TextStyle? t2Medium,
    TextStyle? t2Bold,
    TextStyle? t3Regular,
    TextStyle? t3Medium,
    TextStyle? t3Bold,
    TextStyle? t4Regular,
    TextStyle? t4Medium,
    TextStyle? t4Bold,
    TextStyle? t5Regular,
    TextStyle? t5Medium,
    TextStyle? t5Bold,
    TextStyle? t6Regular,
    TextStyle? t6Medium,
    TextStyle? t6Bold,
    TextStyle? t7Regular,
    TextStyle? t7Medium,
    TextStyle? t7Bold,
    TextStyle? t8Regular,
    TextStyle? t8Medium,
    TextStyle? t8Bold,
    TextStyle? t9Regular,
    TextStyle? t9Medium,
    TextStyle? t9Bold,
    TextStyle? t10Regular,
    TextStyle? t10Medium,
    TextStyle? t10Bold,
    TextStyle? t11Regular,
    TextStyle? t11Medium,
    TextStyle? t11Bold,
    TextStyle? t12Regular,
    TextStyle? t12Medium,
    TextStyle? t12Bold,
    TextStyle? t13Regular,
    TextStyle? t13Medium,
    TextStyle? t13Bold,
    TextStyle? t14Regular,
    TextStyle? t14Medium,
    TextStyle? t14Bold,
    TextStyle? screenTitle,
    TextStyle? articleBody,
  }) => BrianTypography(
    t1Regular: t1Regular ?? this.t1Regular,
    t1Medium: t1Medium ?? this.t1Medium,
    t1Bold: t1Bold ?? this.t1Bold,
    t2Regular: t2Regular ?? this.t2Regular,
    t2Medium: t2Medium ?? this.t2Medium,
    t2Bold: t2Bold ?? this.t2Bold,
    t3Regular: t3Regular ?? this.t3Regular,
    t3Medium: t3Medium ?? this.t3Medium,
    t3Bold: t3Bold ?? this.t3Bold,
    t4Regular: t4Regular ?? this.t4Regular,
    t4Medium: t4Medium ?? this.t4Medium,
    t4Bold: t4Bold ?? this.t4Bold,
    t5Regular: t5Regular ?? this.t5Regular,
    t5Medium: t5Medium ?? this.t5Medium,
    t5Bold: t5Bold ?? this.t5Bold,
    t6Regular: t6Regular ?? this.t6Regular,
    t6Medium: t6Medium ?? this.t6Medium,
    t6Bold: t6Bold ?? this.t6Bold,
    t7Regular: t7Regular ?? this.t7Regular,
    t7Medium: t7Medium ?? this.t7Medium,
    t7Bold: t7Bold ?? this.t7Bold,
    t8Regular: t8Regular ?? this.t8Regular,
    t8Medium: t8Medium ?? this.t8Medium,
    t8Bold: t8Bold ?? this.t8Bold,
    t9Regular: t9Regular ?? this.t9Regular,
    t9Medium: t9Medium ?? this.t9Medium,
    t9Bold: t9Bold ?? this.t9Bold,
    t10Regular: t10Regular ?? this.t10Regular,
    t10Medium: t10Medium ?? this.t10Medium,
    t10Bold: t10Bold ?? this.t10Bold,
    t11Regular: t11Regular ?? this.t11Regular,
    t11Medium: t11Medium ?? this.t11Medium,
    t11Bold: t11Bold ?? this.t11Bold,
    t12Regular: t12Regular ?? this.t12Regular,
    t12Medium: t12Medium ?? this.t12Medium,
    t12Bold: t12Bold ?? this.t12Bold,
    t13Regular: t13Regular ?? this.t13Regular,
    t13Medium: t13Medium ?? this.t13Medium,
    t13Bold: t13Bold ?? this.t13Bold,
    t14Regular: t14Regular ?? this.t14Regular,
    t14Medium: t14Medium ?? this.t14Medium,
    t14Bold: t14Bold ?? this.t14Bold,
    screenTitle: screenTitle ?? this.screenTitle,
    articleBody: articleBody ?? this.articleBody,
  );

  /// 각 스타일을 TextStyle.lerp의 규칙으로 보간합니다.
  ///
  /// [t]가 0이면 현재 값, 1이면 대상 값입니다. 중간값에서 보간하는
  /// 두 스타일의 inherit 값은 같아야 합니다. 글꼴처럼 연속적으로
  /// 보간할 수 없는 속성은 Flutter의 전환 규칙을 따릅니다.
  BrianTypography lerp(BrianTypography other, double t) {
    if (t == 0) return this;
    if (t == 1) return other;
    return BrianTypography(
      t1Regular: TextStyle.lerp(t1Regular, other.t1Regular, t)!,
      t1Medium: TextStyle.lerp(t1Medium, other.t1Medium, t)!,
      t1Bold: TextStyle.lerp(t1Bold, other.t1Bold, t)!,
      t2Regular: TextStyle.lerp(t2Regular, other.t2Regular, t)!,
      t2Medium: TextStyle.lerp(t2Medium, other.t2Medium, t)!,
      t2Bold: TextStyle.lerp(t2Bold, other.t2Bold, t)!,
      t3Regular: TextStyle.lerp(t3Regular, other.t3Regular, t)!,
      t3Medium: TextStyle.lerp(t3Medium, other.t3Medium, t)!,
      t3Bold: TextStyle.lerp(t3Bold, other.t3Bold, t)!,
      t4Regular: TextStyle.lerp(t4Regular, other.t4Regular, t)!,
      t4Medium: TextStyle.lerp(t4Medium, other.t4Medium, t)!,
      t4Bold: TextStyle.lerp(t4Bold, other.t4Bold, t)!,
      t5Regular: TextStyle.lerp(t5Regular, other.t5Regular, t)!,
      t5Medium: TextStyle.lerp(t5Medium, other.t5Medium, t)!,
      t5Bold: TextStyle.lerp(t5Bold, other.t5Bold, t)!,
      t6Regular: TextStyle.lerp(t6Regular, other.t6Regular, t)!,
      t6Medium: TextStyle.lerp(t6Medium, other.t6Medium, t)!,
      t6Bold: TextStyle.lerp(t6Bold, other.t6Bold, t)!,
      t7Regular: TextStyle.lerp(t7Regular, other.t7Regular, t)!,
      t7Medium: TextStyle.lerp(t7Medium, other.t7Medium, t)!,
      t7Bold: TextStyle.lerp(t7Bold, other.t7Bold, t)!,
      t8Regular: TextStyle.lerp(t8Regular, other.t8Regular, t)!,
      t8Medium: TextStyle.lerp(t8Medium, other.t8Medium, t)!,
      t8Bold: TextStyle.lerp(t8Bold, other.t8Bold, t)!,
      t9Regular: TextStyle.lerp(t9Regular, other.t9Regular, t)!,
      t9Medium: TextStyle.lerp(t9Medium, other.t9Medium, t)!,
      t9Bold: TextStyle.lerp(t9Bold, other.t9Bold, t)!,
      t10Regular: TextStyle.lerp(t10Regular, other.t10Regular, t)!,
      t10Medium: TextStyle.lerp(t10Medium, other.t10Medium, t)!,
      t10Bold: TextStyle.lerp(t10Bold, other.t10Bold, t)!,
      t11Regular: TextStyle.lerp(t11Regular, other.t11Regular, t)!,
      t11Medium: TextStyle.lerp(t11Medium, other.t11Medium, t)!,
      t11Bold: TextStyle.lerp(t11Bold, other.t11Bold, t)!,
      t12Regular: TextStyle.lerp(t12Regular, other.t12Regular, t)!,
      t12Medium: TextStyle.lerp(t12Medium, other.t12Medium, t)!,
      t12Bold: TextStyle.lerp(t12Bold, other.t12Bold, t)!,
      t13Regular: TextStyle.lerp(t13Regular, other.t13Regular, t)!,
      t13Medium: TextStyle.lerp(t13Medium, other.t13Medium, t)!,
      t13Bold: TextStyle.lerp(t13Bold, other.t13Bold, t)!,
      t14Regular: TextStyle.lerp(t14Regular, other.t14Regular, t)!,
      t14Medium: TextStyle.lerp(t14Medium, other.t14Medium, t)!,
      t14Bold: TextStyle.lerp(t14Bold, other.t14Bold, t)!,
      screenTitle: TextStyle.lerp(screenTitle, other.screenTitle, t)!,
      articleBody: TextStyle.lerp(articleBody, other.articleBody, t)!,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BrianTypography &&
          t1Regular == other.t1Regular &&
          t1Medium == other.t1Medium &&
          t1Bold == other.t1Bold &&
          t2Regular == other.t2Regular &&
          t2Medium == other.t2Medium &&
          t2Bold == other.t2Bold &&
          t3Regular == other.t3Regular &&
          t3Medium == other.t3Medium &&
          t3Bold == other.t3Bold &&
          t4Regular == other.t4Regular &&
          t4Medium == other.t4Medium &&
          t4Bold == other.t4Bold &&
          t5Regular == other.t5Regular &&
          t5Medium == other.t5Medium &&
          t5Bold == other.t5Bold &&
          t6Regular == other.t6Regular &&
          t6Medium == other.t6Medium &&
          t6Bold == other.t6Bold &&
          t7Regular == other.t7Regular &&
          t7Medium == other.t7Medium &&
          t7Bold == other.t7Bold &&
          t8Regular == other.t8Regular &&
          t8Medium == other.t8Medium &&
          t8Bold == other.t8Bold &&
          t9Regular == other.t9Regular &&
          t9Medium == other.t9Medium &&
          t9Bold == other.t9Bold &&
          t10Regular == other.t10Regular &&
          t10Medium == other.t10Medium &&
          t10Bold == other.t10Bold &&
          t11Regular == other.t11Regular &&
          t11Medium == other.t11Medium &&
          t11Bold == other.t11Bold &&
          t12Regular == other.t12Regular &&
          t12Medium == other.t12Medium &&
          t12Bold == other.t12Bold &&
          t13Regular == other.t13Regular &&
          t13Medium == other.t13Medium &&
          t13Bold == other.t13Bold &&
          t14Regular == other.t14Regular &&
          t14Medium == other.t14Medium &&
          t14Bold == other.t14Bold &&
          screenTitle == other.screenTitle &&
          articleBody == other.articleBody;

  @override
  int get hashCode => Object.hashAll([
    t1Regular,
    t1Medium,
    t1Bold,
    t2Regular,
    t2Medium,
    t2Bold,
    t3Regular,
    t3Medium,
    t3Bold,
    t4Regular,
    t4Medium,
    t4Bold,
    t5Regular,
    t5Medium,
    t5Bold,
    t6Regular,
    t6Medium,
    t6Bold,
    t7Regular,
    t7Medium,
    t7Bold,
    t8Regular,
    t8Medium,
    t8Bold,
    t9Regular,
    t9Medium,
    t9Bold,
    t10Regular,
    t10Medium,
    t10Bold,
    t11Regular,
    t11Medium,
    t11Bold,
    t12Regular,
    t12Medium,
    t12Bold,
    t13Regular,
    t13Medium,
    t13Bold,
    t14Regular,
    t14Medium,
    t14Bold,
    screenTitle,
    articleBody,
  ]);
}
