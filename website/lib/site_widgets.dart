import 'package:brian_ui/brian_ui.dart';
import 'package:flutter/widgets.dart';

export 'code_example.dart';

class SiteServiceName extends StatelessWidget {
  const SiteServiceName({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = BrianTheme.of(context);
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: BrianSpacing.x3,
          vertical: BrianSpacing.x2,
        ),
        decoration: BoxDecoration(
          color: theme.colors.background.neutralWeak,
          borderRadius: BorderRadius.circular(BrianRadius.r2),
        ),
        child: Text(
          'Brian UI',
          style: theme.typography.t3Medium.copyWith(
            color: theme.colors.foreground.neutral,
          ),
        ),
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
