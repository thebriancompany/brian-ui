import 'package:brian_ui/brian_ui.dart';
import 'package:flutter/widgets.dart';

import 'site_widgets.dart';

class BadgeExamples extends StatelessWidget {
  const BadgeExamples({super.key});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const _BadgeExample(
        heading: '콘텐츠 분류',
        explanation: '제목 옆의 짧은 분류는 옅은 배경으로 표시해 본문과 위계를 나눕니다.',
        code: "const BrianBadge(label: '인터뷰')",
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text('제품을 만드는 사람들의 이야기'),
            BrianBadge(label: '인터뷰'),
          ],
        ),
      ),
      const _BadgeExample(
        heading: '혜택과 부가 정보',
        explanation: '하나의 항목에는 중요한 정보 한두 개만 덧붙입니다.',
        code: """const Wrap(
  spacing: 8,
  runSpacing: 8,
  children: [
    BrianBadge(label: '무료 배송', tone: BrianBadgeTone.informative),
    BrianBadge(label: '쿠폰 적용', tone: BrianBadgeTone.positive),
  ],
)""",
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('매일 쓰는 데스크 오거나이저'),
            SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                BrianBadge(label: '무료 배송', tone: BrianBadgeTone.informative),
                BrianBadge(label: '쿠폰 적용', tone: BrianBadgeTone.positive),
              ],
            ),
          ],
        ),
      ),
      const _BadgeExample(
        heading: '처리 상태',
        explanation: '완료·대기·문제 상태는 색상과 구체적인 문구를 함께 사용합니다.',
        code: """const Column(
  children: [
    SizedBox(
      width: double.infinity,
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 16,
        runSpacing: 8,
        children: [
          Text('프로필 검토'),
          BrianBadge(label: '승인됨', tone: BrianBadgeTone.positive),
        ],
      ),
    ),
    SizedBox(height: 16),
    SizedBox(
      width: double.infinity,
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 16,
        runSpacing: 8,
        children: [
          Text('이용권 갱신'),
          BrianBadge(label: '만료 임박', tone: BrianBadgeTone.warning),
        ],
      ),
    ),
    SizedBox(height: 16),
    SizedBox(
      width: double.infinity,
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 16,
        runSpacing: 8,
        children: [
          Text('서류 제출'),
          BrianBadge(label: '보완 필요', tone: BrianBadgeTone.critical),
        ],
      ),
    ),
  ],
)""",
        child: Column(
          children: [
            _StatusRow(
              '프로필 검토',
              BrianBadge(label: '승인됨', tone: BrianBadgeTone.positive),
            ),
            SizedBox(height: 16),
            _StatusRow(
              '이용권 갱신',
              BrianBadge(label: '만료 임박', tone: BrianBadgeTone.warning),
            ),
            SizedBox(height: 16),
            _StatusRow(
              '서류 제출',
              BrianBadge(label: '보완 필요', tone: BrianBadgeTone.critical),
            ),
          ],
        ),
      ),
      const _BadgeExample(
        heading: '상세 정보의 테두리 배지',
        explanation: '배경을 채우지 않고 기능의 제공 상태를 알립니다.',
        code: """const BrianBadge(
  label: '베타',
  tone: BrianBadgeTone.informative,
  variant: BrianBadgeVariant.outline,
)""",
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text('팀별 이용 현황'),
            BrianBadge(
              label: '베타',
              tone: BrianBadgeTone.informative,
              variant: BrianBadgeVariant.outline,
            ),
          ],
        ),
      ),
      _BadgeExample(
        heading: '주요 안내 강조',
        explanation: '핵심 안내에는 채운 배경과 큰 크기를 조합합니다.',
        code: """const BrianBadge(
  label: '새로운 소식',
  tone: BrianBadgeTone.brand,
  variant: BrianBadgeVariant.solid,
  size: BrianBadgeSize.large,
)""",
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: BrianTheme.of(context).colors.background.neutralWeak,
            borderRadius: BorderRadius.circular(BrianRadius.r3),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BrianBadge(
                label: '새로운 소식',
                tone: BrianBadgeTone.brand,
                variant: BrianBadgeVariant.solid,
                size: BrianBadgeSize.large,
              ),
              SizedBox(height: 16),
              Text('더 편리해진 팀 공간을 만나보세요.'),
            ],
          ),
        ),
      ),
      const _BadgeExample(
        heading: '긴 라벨과 너비 제한',
        explanation: '공간이 좁으면 말줄임하고, 보조 기술에는 전체 라벨을 전달합니다.',
        code: """const BrianBadge(
  label: '관리자의 최종 승인을 기다리는 중',
  maxWidth: 140,
)""",
        child: BrianBadge(label: '관리자의 최종 승인을 기다리는 중', maxWidth: 140),
      ),
      _BadgeExample(
        heading: '크기와 스타일 비교',
        explanation: '각 크기의 세 가지 스타일과 여섯 가지 의미 색상을 비교합니다.',
        code: """const BrianBadge(
  label: '안내',
  tone: BrianBadgeTone.informative,
  variant: BrianBadgeVariant.weak,
  size: BrianBadgeSize.large,
)""",
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final size in BrianBadgeSize.values)
              for (final variant in BrianBadgeVariant.values) ...[
                Text('${size.name} · ${variant.name}'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final tone in BrianBadgeTone.values)
                      BrianBadge(
                        label: tone.name,
                        tone: tone,
                        variant: variant,
                        size: size,
                      ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
          ],
        ),
      ),
    ],
  );
}

class _StatusRow extends StatelessWidget {
  const _StatusRow(this.title, this.badge);
  final String title;
  final BrianBadge badge;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    child: Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 16,
      runSpacing: 8,
      children: [Text(title), badge],
    ),
  );
}

class _BadgeExample extends StatelessWidget {
  const _BadgeExample({
    required this.heading,
    required this.explanation,
    required this.child,
    required this.code,
  });
  final String heading;
  final String explanation;
  final Widget child;
  final String code;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SectionHeading(heading),
      Text(explanation),
      const SizedBox(height: BrianSpacing.x4),
      Surface(
        child: Align(alignment: AlignmentDirectional.centerStart, child: child),
      ),
      const SizedBox(height: BrianSpacing.x4),
      CodeExample(code),
    ],
  );
}
