import 'package:flutter/widgets.dart';

import '../spacing/brian_spacing.dart';
import '../theme/brian_theme.dart';

/// 한 폼에서는 필수 표시 또는 선택 표시 중 하나의 방식을 사용합니다.
///
/// {@category Field}
enum BrianFieldRequirement { none, required, optional }

/// 라벨의 강조 정도를 선택합니다.
///
/// {@category Field}
enum BrianFieldLabelWeight { medium, bold }

/// 라벨, 입력 위젯, 안내 메시지를 묶습니다. [BrianTheme] 아래에서 사용합니다.
///
/// 유한한 가로 너비가 필요합니다. 값·포커스·검증·입력 제한은 부모와 [child]가
/// 관리합니다. Flutter의 FormField builder에서 errorText를 전달할 수 있습니다.
/// 입력 위젯의 접근성 이름과 오류 상태는 해당 위젯에도 지정해야 합니다.
/// 여러 입력의 의미 노드를 합치지 않으므로 그룹 안의 각 입력을 탐색할 수 있습니다.
///
/// {@category Field}
class BrianField extends StatelessWidget {
  const BrianField({
    super.key,
    required this.label,
    required this.child,
    this.requirement = BrianFieldRequirement.none,
    this.labelWeight = BrianFieldLabelWeight.medium,
    this.trailing,
    this.helperText,
    this.errorText,
    this.counterText,
    this.requiredLabel = '필수',
    this.optionalLabel = '선택',
  }) : assert(label.length > 0),
       assert(requiredLabel.length > 0),
       assert(optionalLabel.length > 0);

  final String label;
  final Widget child;
  final BrianFieldRequirement requirement;
  final BrianFieldLabelWeight labelWeight;

  /// 라벨 옆의 보조 동작입니다. 공간이 부족하면 다음 줄로 이동합니다.
  final Widget? trailing;
  final String? helperText;

  /// null이 아니면 도움말 대신 표시하고 live region으로 알립니다.
  /// 빈 문자열도 오류로 취급하므로 오류가 없으면 null을 전달합니다.
  final String? errorText;

  /// 예: '12 / 100'. 표시만 하며 글자 수 계산과 입력 제한은 호출자가 맡습니다.
  final String? counterText;

  /// 필수 별표를 대신 읽는 접근성 문구입니다.
  final String requiredLabel;
  final String optionalLabel;

  @override
  Widget build(BuildContext context) {
    final theme = BrianTheme.of(context);
    final foreground = theme.colors.foreground;
    final labelStyle = switch (labelWeight) {
      BrianFieldLabelWeight.medium => theme.typography.t4Medium,
      BrianFieldLabelWeight.bold => theme.typography.t4Bold,
    };
    final message = errorText ?? helperText;
    return Semantics(
      container: true,
      explicitChildNodes: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: BrianSpacing.x3,
            runSpacing: BrianSpacing.x2,
            children: [
              Text.rich(
                TextSpan(
                  text: label,
                  children: [
                    if (requirement == BrianFieldRequirement.required)
                      TextSpan(
                        text: ' *',
                        semanticsLabel: ' $requiredLabel',
                        style: TextStyle(color: foreground.criticalContrast),
                      ),
                    if (requirement == BrianFieldRequirement.optional)
                      TextSpan(
                        text: ' ($optionalLabel)',
                        style: theme.typography.t3Regular.copyWith(
                          color: foreground.neutralMuted,
                        ),
                      ),
                  ],
                ),
                style: labelStyle.copyWith(color: foreground.neutral),
              ),
              ?trailing,
            ],
          ),
          const SizedBox(height: BrianSpacing.x2),
          child,
          if (message != null || counterText != null) ...[
            const SizedBox(height: BrianSpacing.x2),
            DefaultTextStyle.merge(
              style: theme.typography.t3Regular.copyWith(
                color: foreground.neutralMuted,
              ),
              child: Wrap(
                alignment: message == null
                    ? WrapAlignment.end
                    : WrapAlignment.spaceBetween,
                spacing: BrianSpacing.x3,
                runSpacing: BrianSpacing.x1,
                children: [
                  if (message != null)
                    Semantics(
                      liveRegion: errorText != null,
                      child: Text(
                        message,
                        style: TextStyle(
                          color: errorText != null
                              ? foreground.criticalContrast
                              : foreground.neutralMuted,
                        ),
                      ),
                    ),
                  if (counterText != null)
                    Text(counterText!, textDirection: TextDirection.ltr),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
