import 'package:brian_ui/brian_ui.dart';
import 'package:flutter/material.dart' show Icons;
import 'package:flutter/widgets.dart';

import 'site_widgets.dart';

class CalloutExamples extends StatefulWidget {
  const CalloutExamples({super.key});

  @override
  State<CalloutExamples> createState() => _CalloutExamplesState();
}

class _CalloutExamplesState extends State<CalloutExamples> {
  bool _dismissed = false;
  String? _result;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      for (final (tone, heading, message) in const [
        (BrianCalloutTone.neutral, '일반 안내', '점검 중에는 일부 기능을 이용할 수 없습니다.'),
        (BrianCalloutTone.informative, '유용한 정보', '알림을 켜면 배송 소식을 바로 받아볼 수 있어요.'),
        (BrianCalloutTone.critical, '오류 안내', '결제하지 못했습니다. 결제 수단을 확인해 주세요.'),
        (BrianCalloutTone.positive, '완료 피드백', '변경 사항을 안전하게 저장했습니다.'),
        (BrianCalloutTone.warning, '주의 사항', '삭제한 파일은 복구할 수 없습니다.'),
      ])
        _Example(
          heading: heading,
          explanation: '${tone.name} 톤으로 메시지의 의미를 전달합니다.',
          code:
              "BrianCallout(\n  tone: BrianCalloutTone.${tone.name},\n  description: Text('$message'),\n)",
          child: BrianCallout(tone: tone, description: Text(message)),
        ),
      const _Example(
        heading: '제목과 긴 본문',
        explanation: '짧은 제목으로 성격을 알립니다. 본문은 너비와 글자 크기에 따라 여러 줄로 늘어납니다.',
        code: "BrianCallout(\n  title: Text('배송 안내'),\n  description: Text('연휴 기간에는 배송이 평소보다 늦어질 수 있습니다. 주문 상세에서 예상 도착일을 확인해 주세요.'),\n)",
        child: BrianCallout(
          title: Text('배송 안내'),
          description: Text(
            '연휴 기간에는 배송이 평소보다 늦어질 수 있습니다. 주문 상세에서 예상 도착일을 확인해 주세요.',
          ),
        ),
      ),
      _Example(
        heading: '전체 영역 누르기',
        explanation: '메시지 전체가 하나의 버튼입니다. 탭하거나 Tab으로 이동한 뒤 Enter·Space를 눌러 보세요.',
        code: "BrianCallout(\n  tone: BrianCalloutTone.informative,\n  description: Text('주문한 상품이 출발했어요. 배송 현황을 확인하세요.'),\n  onPressed: () => setState(() => result = '배송 현황을 선택했습니다.'),\n)",
        child: BrianCallout(
          tone: BrianCalloutTone.informative,
          description: const Text('주문한 상품이 출발했어요. 배송 현황을 확인하세요.'),
          onPressed: () => setState(() => _result = '배송 현황을 선택했습니다.'),
        ),
      ),
      _Example(
        heading: '보조 링크',
        explanation: '추가 설명이 필요하면 본문 아래에 별도 동작을 둡니다.',
        code: "BrianCallout(\n  description: Text('계정 정보를 안전하게 보관하고 있습니다.'),\n  action: BrianButton(\n    variant: BrianButtonVariant.ghost,\n    onPressed: () => setState(() => result = '보관 정책을 선택했습니다.'),\n    child: Text('보관 정책 알아보기'),\n  ),\n)",
        child: BrianCallout(
          description: const Text('계정 정보를 안전하게 보관하고 있습니다.'),
          action: BrianButton(
            variant: BrianButtonVariant.ghost,
            onPressed: () => setState(() => _result = '보관 정책을 선택했습니다.'),
            child: const Text('보관 정책 알아보기'),
          ),
        ),
      ),
      if (_result != null) Semantics(liveRegion: true, child: Text(_result!)),
      _Example(
        heading: '닫을 수 있는 안내',
        explanation:
            '한 번 확인하면 충분한 안내에 사용합니다. 닫힘 상태는 부모가 관리하며, 예제에서는 다시 표시할 수 있습니다.',
        code: "if (!dismissed)\n  BrianCallout(\n    description: Text('새로운 검색 기능을 만나보세요.'),\n    dismissLabel: '새 기능 안내 닫기',\n    onDismiss: () => setState(() => dismissed = true),\n  )",
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!_dismissed)
              BrianCallout(
                description: const Text('새로운 검색 기능을 만나보세요.'),
                dismissLabel: '새 기능 안내 닫기',
                onDismiss: () => setState(() => _dismissed = true),
              )
            else
              BrianButton(
                onPressed: () => setState(() => _dismissed = false),
                child: const Text('안내 다시 표시'),
              ),
          ],
        ),
      ),
      const _Example(
        heading: '커스텀 아이콘',
        explanation: '글자 대신 Icon 위젯을 전달하면 글꼴의 기준선에 영향을 받지 않습니다. 이 예시는 앱의 아이콘 세트를 사용하며 톤의 색상과 크기를 상속합니다.',
        code: "BrianCallout(\n  tone: BrianCalloutTone.positive,\n  icon: Icon(Icons.check),\n  description: Text('프로필 인증이 완료되었습니다.'),\n)",
        child: BrianCallout(
          tone: BrianCalloutTone.positive,
          icon: Icon(Icons.check),
          description: Text('프로필 인증이 완료되었습니다.'),
        ),
      ),
      const _Example(
        heading: '아이콘 없는 안내',
        explanation: '텍스트만으로 충분한 맥락에서는 아이콘을 생략할 수 있습니다.',
        code: "BrianCallout(\n  showIcon: false,\n  description: Text('최근 30일의 내역만 표시합니다.'),\n)",
        child: BrianCallout(
          showIcon: false,
          description: Text('최근 30일의 내역만 표시합니다.'),
        ),
      ),
    ],
  );
}

class _Example extends StatelessWidget {
  const _Example({
    required this.heading,
    required this.explanation,
    required this.code,
    required this.child,
  });
  final String heading;
  final String explanation;
  final String code;
  final Widget child;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SectionHeading(heading),
      Text(explanation),
      const SizedBox(height: BrianSpacing.x4),
      Surface(child: child),
      const SizedBox(height: BrianSpacing.x4),
      CodeExample(code),
    ],
  );
}
