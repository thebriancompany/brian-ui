import 'package:flutter/widgets.dart';

import '../theme/brian_theme.dart';

/// 구분할 콘텐츠의 관계에 맞는 경계 강도입니다.
///
/// {@category Divider}
enum BrianDividerTone {
  /// 섹션·헤더처럼 의미가 달라지는 영역 사이에 사용합니다.
  neutralMuted,

  /// 같은 종류의 항목이 반복되는 목록에 사용합니다.
  neutralSubtle,
}

/// 콘텐츠 사이에 1 논리 픽셀의 장식용 구분선을 그립니다.
///
/// [BrianTheme] 아래에서 사용합니다. 가로선은 부모의 최대 너비, 세로선은
/// 최대 높이를 채우므로 해당 방향에 유한한 제약이 필요합니다.
/// Row의 세로선은 SizedBox로 높이를 정하거나 IntrinsicHeight 안에 둡니다.
/// 들여쓰기와 주변 간격은 Padding으로 지정합니다. 포인터 입력과
/// 접근성 탐색에 참여하지 않으며 콘텐츠의 의미는 제목·목록에서 전달합니다.
///
/// {@category Divider}
class BrianDivider extends StatelessWidget {
  const BrianDivider({
    super.key,
    this.axis = Axis.horizontal,
    this.tone = BrianDividerTone.neutralMuted,
    this.color,
  });

  final Axis axis;
  final BrianDividerTone tone;

  /// 지정하면 [tone] 대신 사용합니다. 생략하면 현재 테마의 stroke를 따릅니다.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final stroke = BrianTheme.of(context).colors.stroke;
    final resolvedColor =
        color ??
        switch (tone) {
          BrianDividerTone.neutralMuted => stroke.neutralMuted,
          BrianDividerTone.neutralSubtle => stroke.neutralSubtle,
        };
    return ExcludeSemantics(
      child: IgnorePointer(
        child: SizedBox(
          width: axis == Axis.horizontal ? double.infinity : 1,
          height: axis == Axis.horizontal ? 1 : double.infinity,
          child: ColoredBox(color: resolvedColor),
        ),
      ),
    );
  }
}
