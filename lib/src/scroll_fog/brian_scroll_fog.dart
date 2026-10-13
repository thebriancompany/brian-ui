import 'package:flutter/widgets.dart';

import '../theme/brian_theme.dart';

/// 그라디언트의 불투명한 끝이 닿는 물리적 가장자리입니다.
///
/// 좌우는 텍스트 방향이나 스크롤의 reverse 설정과 관계없이 유지됩니다.
///
/// {@category ScrollFog}
enum BrianScrollFogPlacement { top, bottom, left, right }

/// 스크롤 영역의 가장자리에 겹쳐 놓는 장식용 그라디언트입니다.
///
/// Stack의 Positioned로 배치하고 가로 Fog에는 유한한 너비, 세로 Fog에는
/// 유한한 높이를 제공하세요. 스크롤 상태와 무관하게 항상 표시되며 포인터와
/// 접근성 탐색을 가로채지 않습니다. 스크롤 콘텐츠에는 [extent] 이상의
/// 가장자리 패딩을 두어 끝에 도달했을 때 내용을 온전히 읽을 수 있게 하세요.
///
/// {@category ScrollFog}
class BrianScrollFog extends StatelessWidget {
  const BrianScrollFog({
    super.key,
    this.placement = BrianScrollFogPlacement.bottom,
    this.extent,
    this.color,
  }) : assert(extent == null || (extent >= 0 && extent < double.infinity));

  final BrianScrollFogPlacement placement;

  /// 논리 픽셀 단위의 깊이. 생략하면 하단은 80, 나머지는 20입니다.
  /// 부모 제약보다 클 경우 부모가 허용하는 크기로 제한됩니다.
  final double? extent;

  /// 맞닿는 표면의 색상. 생략하면 테마의 background.layerDefault입니다.
  /// 투명한 끝에도 같은 RGB를 사용하며 알파만 0으로 바꿉니다.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final surface =
        color ?? BrianTheme.of(context).colors.background.layerDefault;
    final edge = switch (placement) {
      BrianScrollFogPlacement.top => Alignment.topCenter,
      BrianScrollFogPlacement.bottom => Alignment.bottomCenter,
      BrianScrollFogPlacement.left => Alignment.centerLeft,
      BrianScrollFogPlacement.right => Alignment.centerRight,
    };
    final vertical =
        placement == BrianScrollFogPlacement.top ||
        placement == BrianScrollFogPlacement.bottom;
    final depth =
        extent ?? (placement == BrianScrollFogPlacement.bottom ? 80.0 : 20.0);
    return IgnorePointer(
      child: ExcludeSemantics(
        child: SizedBox(
          width: vertical ? double.infinity : depth,
          height: vertical ? depth : double.infinity,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: edge,
                end: -edge,
                colors: [surface, surface.withValues(alpha: 0)],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
