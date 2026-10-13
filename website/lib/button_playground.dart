import 'package:brian_ui/brian_ui.dart';
import 'package:flutter/widgets.dart';

import 'site_widgets.dart';

enum ButtonState { enabled, disabled, loading }

class ButtonPlayground extends StatefulWidget {
  const ButtonPlayground({super.key});

  @override
  State<ButtonPlayground> createState() => _ButtonPlaygroundState();
}

class _ButtonPlaygroundState extends State<ButtonPlayground> {
  BrianButtonVariant _variant = BrianButtonVariant.neutralSolid;
  BrianButtonSize _size = BrianButtonSize.medium;
  ButtonState _state = ButtonState.enabled;
  int _presses = 0;

  String get _code =>
      '''BrianButton(
  variant: BrianButtonVariant.${_variant.name},
  size: BrianButtonSize.${_size.name},
  onPressed: ${_state == ButtonState.disabled ? 'null' : '() { /* 액션 실행 */ }'},
  isLoading: ${_state == ButtonState.loading},
  child: const Text('저장하기'),
)''';

  @override
  Widget build(BuildContext context) {
    final theme = BrianTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeading('Playground'),
        Surface(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: BrianSpacing.x12),
                child: BrianButton(
                  key: const ValueKey('button-preview'),
                  variant: _variant,
                  size: _size,
                  onPressed: _state == ButtonState.disabled
                      ? null
                      : () => setState(() => _presses++),
                  isLoading: _state == ButtonState.loading,
                  child: const Text('저장하기'),
                ),
              ),
              Semantics(
                liveRegion: true,
                child: Text(
                  '실행 횟수: $_presses',
                  style: theme.typography.t3Regular.copyWith(
                    color: theme.colors.foreground.neutralMuted,
                  ),
                ),
              ),
              const SizedBox(height: BrianSpacing.x8),
              Choices(
                label: 'Variant',
                values: BrianButtonVariant.values,
                selected: _variant,
                name: (value) => value.name,
                onChanged: (value) => setState(() => _variant = value),
              ),
              const SizedBox(height: BrianSpacing.x6),
              Choices(
                label: 'Size',
                values: BrianButtonSize.values,
                selected: _size,
                name: (value) => value.name,
                onChanged: (value) => setState(() => _size = value),
              ),
              const SizedBox(height: BrianSpacing.x6),
              Choices(
                label: 'State',
                values: ButtonState.values,
                selected: _state,
                name: (value) => switch (value) {
                  ButtonState.enabled => '기본',
                  ButtonState.disabled => '비활성화',
                  ButtonState.loading => '로딩',
                },
                onChanged: (value) => setState(() => _state = value),
              ),
            ],
          ),
        ),
        const SizedBox(height: BrianSpacing.x4),
        CodeExample(_code),
        const SizedBox(height: BrianSpacing.x4),
        const Text(
          'BrianTheme 아래에 위 코드를 배치하세요. Tab으로 포커스를 옮기고 Enter·Space로 실행할 수 있습니다. 로딩·비활성화 상태에서는 실행되지 않습니다.',
        ),
      ],
    );
  }
}
