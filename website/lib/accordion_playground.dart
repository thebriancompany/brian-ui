import 'package:brian_ui/brian_ui.dart';
import 'package:flutter/widgets.dart';

import 'site_widgets.dart';

class AccordionPlayground extends StatefulWidget {
  const AccordionPlayground({super.key});

  @override
  State<AccordionPlayground> createState() => _AccordionPlaygroundState();
}

class _AccordionPlaygroundState extends State<AccordionPlayground> {
  BrianAccordionVariant _variant = BrianAccordionVariant.inline;
  BrianAccordionSize _size = BrianAccordionSize.medium;
  BrianAccordionExpansionMode _mode = BrianAccordionExpansionMode.single;
  bool _custom = false;
  bool _disabled = false;

  String get _code =>
      '''BrianAccordion(
  variant: BrianAccordionVariant.${_variant.name},
  size: BrianAccordionSize.${_size.name},
  expansionMode: BrianAccordionExpansionMode.${_mode.name},
  children: [
    BrianAccordionItem(
      value: 'delivery',
      title: const Text('배송 안내'),
      description: const Text('배송 기간과 방법'),
      enabled: ${!_disabled},${_custom ? "\n      indicatorBuilder: (context, isExpanded) => Text(isExpanded ? '−' : '+')," : ''}
      child: const Text('배송에는 2~3일이 걸립니다.'),
    ),
    const BrianAccordionItem(
      value: 'returns',
      title: Text('반품 안내'),
      child: Text('주문 내역에서 반품을 신청하세요.'),
    ),
  ],
)''';

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SectionHeading('Playground'),
      Surface(
        child: Column(
          children: [
            BrianAccordion(
              variant: _variant,
              size: _size,
              expansionMode: _mode,
              children: [
                BrianAccordionItem(
                  value: 'delivery',
                  title: const Text('배송 안내'),
                  description: const Text('배송 기간과 방법'),
                  enabled: !_disabled,
                  indicatorBuilder: _custom
                      ? (context, isExpanded) => Text(isExpanded ? '−' : '+')
                      : null,
                  child: const Text('배송에는 2~3일이 걸립니다.'),
                ),
                const BrianAccordionItem(
                  value: 'returns',
                  title: Text('반품 안내'),
                  child: Text('주문 내역에서 반품을 신청하세요.'),
                ),
              ],
            ),
            const SizedBox(height: BrianSpacing.x6),
            Choices(
              label: 'Variant',
              values: BrianAccordionVariant.values,
              selected: _variant,
              name: (value) => value.name,
              onChanged: (value) => setState(() => _variant = value),
            ),
            const SizedBox(height: BrianSpacing.x6),
            Choices(
              label: 'Size',
              values: BrianAccordionSize.values,
              selected: _size,
              name: (value) => value.name,
              onChanged: (value) => setState(() => _size = value),
            ),
            const SizedBox(height: BrianSpacing.x6),
            Choices(
              label: 'Expansion',
              values: BrianAccordionExpansionMode.values,
              selected: _mode,
              name: (value) => value.name,
              onChanged: (value) => setState(() => _mode = value),
            ),
            const SizedBox(height: BrianSpacing.x6),
            Choices(
              label: 'Indicator',
              values: const [false, true],
              selected: _custom,
              name: (value) => value ? '+ / −' : 'Chevron',
              onChanged: (value) => setState(() => _custom = value),
            ),
            const SizedBox(height: BrianSpacing.x6),
            Choices(
              label: '첫 항목',
              values: const [false, true],
              selected: _disabled,
              name: (value) => value ? '비활성화' : '기본',
              onChanged: (value) => setState(() => _disabled = value),
            ),
          ],
        ),
      ),
      const SizedBox(height: BrianSpacing.x4),
      CodeExample(_code),
    ],
  );
}
