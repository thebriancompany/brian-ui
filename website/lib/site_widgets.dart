import 'package:brian_ui/brian_ui.dart';
import 'package:flutter/widgets.dart';

export 'code_example.dart';

class SiteHeader extends StatelessWidget {
  const SiteHeader({super.key, required this.onBrightnessChanged});
  final ValueChanged<Brightness> onBrightnessChanged;

  @override
  Widget build(BuildContext context) {
    final theme = BrianTheme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: BrianSpacing.x6,
        vertical: BrianSpacing.x4,
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: BrianSpacing.x6,
        runSpacing: BrianSpacing.x3,
        children: [
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(text: 'Brian'),
                TextSpan(
                  text: ' UI',
                  style: TextStyle(color: theme.colors.foreground.brand),
                ),
              ],
            ),
            style: theme.typography.t8Bold,
          ),
          Text('문서 · develop', style: theme.typography.t2Regular),
          BrianButton(
            onPressed: () => onBrightnessChanged(
              theme.brightness == Brightness.light
                  ? Brightness.dark
                  : Brightness.light,
            ),
            variant: BrianButtonVariant.neutralWeak,
            size: BrianButtonSize.small,
            child: Text(
              theme.brightness == Brightness.light ? '다크 모드' : '라이트 모드',
            ),
          ),
        ],
      ),
    );
  }
}

class SectionHeading extends StatelessWidget {
  const SectionHeading(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(
      top: BrianSpacing.x8,
      bottom: BrianSpacing.x4,
    ),
    child: Semantics(
      header: true,
      child: Text(text, style: BrianTheme.of(context).typography.t7Bold),
    ),
  );
}

class Surface extends StatelessWidget {
  const Surface({
    super.key,
    required this.child,
    this.padding = BrianSpacing.x6,
  });
  final Widget child;
  final double padding;

  @override
  Widget build(BuildContext context) {
    final colors = BrianTheme.of(context).colors;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: colors.background.layerDefault,
        border: Border.all(color: colors.stroke.neutralWeak),
        borderRadius: BorderRadius.circular(BrianRadius.r4),
      ),
      child: child,
    );
  }
}

class Choices<T> extends StatelessWidget {
  const Choices({
    super.key,
    required this.label,
    required this.values,
    required this.selected,
    required this.name,
    required this.onChanged,
  });
  final String label;
  final List<T> values;
  final T selected;
  final String Function(T) name;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: BrianTheme.of(context).typography.t3Bold),
      const SizedBox(height: BrianSpacing.x3),
      Wrap(
        spacing: BrianSpacing.x2,
        runSpacing: BrianSpacing.x2,
        children: [
          for (final value in values)
            Semantics(
              selected: value == selected,
              child: BrianButton(
                onPressed: () => onChanged(value),
                size: BrianButtonSize.small,
                variant: value == selected
                    ? BrianButtonVariant.neutralSolid
                    : BrianButtonVariant.neutralWeak,
                child: Text(name(value)),
              ),
            ),
        ],
      ),
    ],
  );
}
