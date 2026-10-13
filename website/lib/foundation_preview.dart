import 'package:brian_ui/brian_ui.dart';
import 'package:flutter/widgets.dart';

import 'site_widgets.dart';

class FoundationPreview extends StatelessWidget {
  const FoundationPreview({super.key, required this.path});
  final String path;

  @override
  Widget build(BuildContext context) {
    final theme = BrianTheme.of(context);
    final colors = theme.colors;
    final content = switch (path) {
      '/foundations/color' => Wrap(
        spacing: BrianSpacing.x4,
        runSpacing: BrianSpacing.x4,
        children: [
          for (final (name, color) in [
            ('brand', colors.background.brandSolid),
            ('neutral', colors.background.neutralSolid),
            ('positive', colors.background.positiveSolid),
            ('critical', colors.background.criticalSolid),
            ('warning', colors.background.warningSolid),
            ('informative', colors.background.informativeSolid),
          ])
            SizedBox(
              width: 130,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 72,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(BrianRadius.r3),
                    ),
                  ),
                  const SizedBox(height: BrianSpacing.x3),
                  Text(name, style: theme.typography.t3Bold),
                  Text(
                    '#${color.toARGB32().toRadixString(16).substring(2).toUpperCase()}',
                    style: theme.typography.t2Regular,
                  ),
                ],
              ),
            ),
        ],
      ),
      '/foundations/typography' => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final (label, style) in [
            ('screenTitle', theme.typography.screenTitle),
            ('articleBody', theme.typography.articleBody),
            ('t4Regular', theme.typography.t4Regular),
            ('t2Bold', theme.typography.t2Bold),
          ])
            Padding(
              padding: const EdgeInsets.only(bottom: BrianSpacing.x5),
              child: Text('$label · 더 나은 일상의 시작', style: style),
            ),
        ],
      ),
      '/foundations/spacing' => Column(
        children: [
          for (final (name, value) in [
            ('x1', BrianSpacing.x1),
            ('x2', BrianSpacing.x2),
            ('x4', BrianSpacing.x4),
            ('x6', BrianSpacing.x6),
            ('x8', BrianSpacing.x8),
            ('x16', BrianSpacing.x16),
          ])
            Padding(
              padding: const EdgeInsets.symmetric(vertical: BrianSpacing.x2),
              child: Row(
                children: [
                  SizedBox(
                    width: 120,
                    child: Text('$name · ${value.toInt()} px'),
                  ),
                  Container(
                    width: value,
                    height: BrianSpacing.x4,
                    color: colors.background.brandSolid,
                  ),
                ],
              ),
            ),
        ],
      ),
      '/foundations/radius' => Wrap(
        spacing: BrianSpacing.x6,
        runSpacing: BrianSpacing.x6,
        children: [
          for (final (name, value) in [
            ('r1', BrianRadius.r1),
            ('r2', BrianRadius.r2),
            ('r3', BrianRadius.r3),
            ('r4', BrianRadius.r4),
            ('r6', BrianRadius.r6),
          ])
            Container(
              width: 100,
              height: 88,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colors.background.neutralWeak,
                border: Border.all(color: colors.stroke.neutralMuted),
                borderRadius: BorderRadius.circular(value),
              ),
              child: Text(
                '$name\n${value.toInt()} px',
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
      '/foundations/elevation' => Wrap(
        spacing: BrianSpacing.x8,
        runSpacing: BrianSpacing.x8,
        children: [
          for (final (name, shadow) in [
            ('s1', theme.shadows.s1),
            ('s2', theme.shadows.s2),
            ('s3', theme.shadows.s3),
          ])
            Container(
              width: 132,
              height: 96,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colors.background.layerFloating,
                border: Border.all(color: colors.stroke.neutralWeak),
                borderRadius: BorderRadius.circular(BrianRadius.r3),
                boxShadow: [shadow],
              ),
              child: Text(name),
            ),
        ],
      ),
      '/theming' => Wrap(
        spacing: BrianSpacing.x4,
        runSpacing: BrianSpacing.x4,
        children: [
          for (final data in [BrianThemeData.light, BrianThemeData.dark])
            BrianTheme(
              data: data,
              child: Builder(
                builder: (context) => Container(
                  width: 230,
                  padding: const EdgeInsets.all(BrianSpacing.x6),
                  decoration: BoxDecoration(
                    color: data.colors.background.layerDefault,
                    border: Border.all(color: data.colors.stroke.neutralWeak),
                    borderRadius: BorderRadius.circular(BrianRadius.r3),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.brightness == Brightness.light ? 'Light' : 'Dark',
                        style: data.typography.t6Bold.copyWith(
                          color: data.colors.foreground.neutral,
                        ),
                      ),
                      const SizedBox(height: BrianSpacing.x5),
                      BrianButton(
                        onPressed: () {},
                        child: const Text('같은 BrianButton'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      _ => null,
    };
    if (content == null) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeading('실제 토큰 미리보기'),
        Surface(child: content),
      ],
    );
  }
}
