import 'package:flutter/widgets.dart';

import '../radius/brian_radius.dart';
import '../spacing/brian_spacing.dart';
import '../theme/brian_theme.dart';

/// 상태나 정보의 의미에 따라 선택하는 배지 색상입니다.
///
/// {@category Badge}
enum BrianBadgeTone { neutral, brand, informative, positive, warning, critical }

/// 채운 배경, 테두리, 옅은 배경 순서로 표현합니다.
///
/// {@category Badge}
enum BrianBadgeVariant { solid, outline, weak }

/// 기본 테마에서 높이는 medium 20, large 24 논리 픽셀입니다.
/// 글자 확대나 사용자 정의 타이포그래피에 따라 높이가 늘어납니다.
///
/// {@category Badge}
enum BrianBadgeSize { medium, large }

/// 콘텐츠의 상태나 부가 정보를 짧은 라벨로 표시합니다.
///
/// 상위에 BrianTheme이 필요합니다. 클릭·선택 동작을 제공하지 않습니다.
/// 라벨은 한 줄로 표시하고 [maxWidth]를 넘으면 말줄임합니다.
/// 접근성 트리에는 말줄임 전의 전체 [label]이 유지됩니다.
///
/// {@category Badge}
class BrianBadge extends StatelessWidget {
  const BrianBadge({
    super.key,
    required this.label,
    this.tone = BrianBadgeTone.neutral,
    this.variant = BrianBadgeVariant.weak,
    this.size = BrianBadgeSize.medium,
    this.maxWidth = 120,
  }) : assert(maxWidth > 0);

  final String label;
  final BrianBadgeTone tone;
  final BrianBadgeVariant variant;
  final BrianBadgeSize size;

  /// 패딩을 포함한 최대 너비이며 단위는 논리 픽셀입니다.
  /// 부모의 제약이 우선합니다. 제한을 없애려면 double.infinity를 지정합니다.
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final theme = BrianTheme.of(context);
    final bg = theme.colors.background;
    final palette = theme.colors.palette;
    final dark = theme.brightness == Brightness.dark;
    final fg = theme.colors.foreground;
    final stroke = theme.colors.stroke;
    // 작은 상태 라벨에는 공통 solid 배경보다 대비가 높은 팔레트 단계를 씁니다.
    final (solid, weak, onSolid, foreground, border) = switch (tone) {
      BrianBadgeTone.neutral => (
        bg.neutralSolid,
        bg.neutralWeak,
        fg.onNeutralSolid,
        fg.neutral,
        stroke.neutralMuted,
      ),
      BrianBadgeTone.brand => (
        bg.brandSolid,
        bg.brandWeak,
        fg.onBrandSolid,
        fg.brandContrast,
        stroke.brandWeak,
      ),
      BrianBadgeTone.informative => (
        dark ? palette.blue.step500 : palette.blue.step800,
        bg.informativeWeak,
        fg.onInformativeSolid,
        fg.informativeContrast,
        stroke.informativeWeak,
      ),
      BrianBadgeTone.positive => (
        dark ? palette.green.step500 : palette.green.step800,
        bg.positiveWeak,
        fg.onPositiveSolid,
        fg.positiveContrast,
        stroke.positiveWeak,
      ),
      BrianBadgeTone.warning => (
        bg.warningSolid,
        bg.warningWeak,
        fg.onWarningSolid,
        fg.warningContrast,
        stroke.warningWeak,
      ),
      BrianBadgeTone.critical => (
        dark ? palette.red.step500 : palette.red.step800,
        bg.criticalWeak,
        fg.onCriticalSolid,
        fg.criticalContrast,
        stroke.criticalWeak,
      ),
    };
    final large = size == BrianBadgeSize.large;
    final style = large ? theme.typography.t3Bold : theme.typography.t2Bold;
    return Semantics(
      label: label,
      excludeSemantics: true,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: DecoratedBox(
          // 테두리가 패딩에 더해지지 않아 스타일을 바꿔도 크기가 같습니다.
          decoration: ShapeDecoration(
            color: switch (variant) {
              BrianBadgeVariant.solid => solid,
              BrianBadgeVariant.weak => weak,
              BrianBadgeVariant.outline => bg.transparent,
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(BrianRadius.r1),
              side: variant == BrianBadgeVariant.outline
                  ? BorderSide(color: border)
                  : BorderSide.none,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: large ? BrianSpacing.x1Point5 : BrianSpacing.x1,
              vertical: large ? 3 : BrianSpacing.x0Point5,
            ),
            child: Text(
              label,
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.ellipsis,
              style: DefaultTextStyle.of(context).style.merge(
                style.copyWith(
                  color: variant == BrianBadgeVariant.solid
                      ? onSolid
                      : foreground,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
