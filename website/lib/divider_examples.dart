import 'package:brian_ui/brian_ui.dart';
import 'package:flutter/widgets.dart';

import 'site_widgets.dart';

class DividerExamples extends StatelessWidget {
  const DividerExamples({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = BrianTheme.of(context).colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _Example(
          heading: '섹션 사이의 경계',
          explanation: '의미가 달라지는 주문 정보와 배송 정보를 기본 neutralMuted 톤으로 나눕니다.',
          code: '''Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: [
    Padding(padding: EdgeInsets.all(16), child: Text('주문 상품 · 데스크 조명')),
    BrianDivider(),
    Padding(padding: EdgeInsets.all(16), child: Text('배송 정보 · 문 앞에 놓아주세요')),
  ],
)''',
          child: Column(
            children: [
              _Content(title: '주문 상품', detail: '데스크 조명 · 1개'),
              BrianDivider(),
              _Content(title: '배송 정보', detail: '문 앞에 놓아주세요'),
            ],
          ),
        ),
        const _Example(
          heading: '반복되는 설정 항목',
          explanation:
              '동일한 성격의 항목은 neutralSubtle 톤으로 가볍게 구분합니다. 마지막 항목 뒤에는 선을 넣지 않습니다.',
          code: '''Column(
  children: [
    Padding(padding: EdgeInsets.all(16), child: Text('주문 알림')),
    BrianDivider(tone: BrianDividerTone.neutralSubtle),
    Padding(padding: EdgeInsets.all(16), child: Text('배송 알림')),
    BrianDivider(tone: BrianDividerTone.neutralSubtle),
    Padding(padding: EdgeInsets.all(16), child: Text('혜택 알림')),
  ],
)''',
          child: Column(
            children: [
              _Content(title: '주문 알림', detail: '결제와 취소 소식을 받아요'),
              BrianDivider(tone: BrianDividerTone.neutralSubtle),
              _Content(title: '배송 알림', detail: '배송의 시작과 도착을 알려드려요'),
              BrianDivider(tone: BrianDividerTone.neutralSubtle),
              _Content(title: '혜택 알림', detail: '쿠폰과 할인 소식을 받아요'),
            ],
          ),
        ),
        const _Example(
          heading: '콘텐츠에 맞춘 들여쓰기',
          explanation:
              '번호 영역은 하나의 그룹으로 묶고 선의 시작점을 본문에 맞춥니다. 방향성 여백은 RTL에서도 반전됩니다.',
          code: '''Padding(
  padding: EdgeInsetsDirectional.only(start: 56, end: 16),
  child: BrianDivider(tone: BrianDividerTone.neutralSubtle),
)''',
          child: Column(
            children: [
              _Content(title: '상품 선택', detail: '원하는 상품을 담아주세요', number: '01'),
              Padding(
                padding: EdgeInsetsDirectional.only(start: 56, end: 16),
                child: BrianDivider(tone: BrianDividerTone.neutralSubtle),
              ),
              _Content(
                title: '주문 확인',
                detail: '배송지와 결제 수단을 확인하세요',
                number: '02',
              ),
            ],
          ),
        ),
        const _Example(
          heading: '가로로 나열한 정보',
          explanation:
              '세로선으로 서로 다른 지표를 구분합니다. IntrinsicHeight가 텍스트 확대에 맞춰 선의 높이도 정합니다.',
          code: '''IntrinsicHeight(
  child: Row(
    children: [
      Expanded(child: Text('조회 128')),
      BrianDivider(axis: Axis.vertical),
      Expanded(child: Text('관심 12')),
    ],
  ),
)''',
          child: Padding(
            padding: EdgeInsets.all(BrianSpacing.x4),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: _Content(title: '128', detail: '조회'),
                  ),
                  BrianDivider(axis: Axis.vertical),
                  Expanded(
                    child: _Content(title: '12', detail: '관심'),
                  ),
                ],
              ),
            ),
          ),
        ),
        const _Example(
          heading: '본문과 액션 영역',
          explanation: '전체 너비의 선으로 설명과 다음 동작을 분리합니다. 예제 버튼을 누르면 선택 결과가 표시됩니다.',
          code: '''Column(
  children: [
    Text('주문 내용을 확인한 뒤 다음 단계로 진행하세요.'),
    BrianDivider(),
    Padding(
      padding: EdgeInsets.all(16),
      child: BrianButton(onPressed: onContinue, child: Text('다음 단계')),
    ),
  ],
)''',
          child: _ActionExample(),
        ),
        _Example(
          heading: '역할 색상으로 경계 강조',
          explanation:
              '특별한 맥락에서는 color로 다른 stroke 색상을 적용합니다. 상태의 의미는 제목과 본문에서도 전달합니다.',
          code: '''BrianDivider(
  color: BrianTheme.of(context).colors.stroke.brandWeak,
)''',
          child: Column(
            children: [
              const _Content(title: '멤버십 혜택', detail: '이번 달 받을 수 있는 혜택이에요'),
              BrianDivider(color: colors.stroke.brandWeak),
              const _Content(title: '무료 배송', detail: '금액에 관계없이 배송비가 없어요'),
            ],
          ),
        ),
        _Example(
          heading: '선 대신 표면 사이의 간격',
          explanation: '맥락이 크게 달라지는 영역은 바탕 위에 표면을 올리고 8 논리 픽셀 간격을 둡니다.',
          code: '''ColoredBox(
  color: colors.background.layerBasement,
  child: Column(
    children: [
      ColoredBox(color: colors.background.layerDefault, child: orderSummary),
      SizedBox(height: BrianSpacing.x2),
      ColoredBox(color: colors.background.layerDefault, child: recommendations),
    ],
  ),
)''',
          child: ColoredBox(
            color: colors.background.layerBasement,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ColoredBox(
                  color: colors.background.layerDefault,
                  child: const _Content(title: '주문 완료', detail: '상품을 준비하고 있어요'),
                ),
                const SizedBox(height: BrianSpacing.x2),
                ColoredBox(
                  color: colors.background.layerDefault,
                  child: const _Content(
                    title: '함께 둘러보기',
                    detail: '책상에 어울리는 소품을 만나보세요',
                  ),
                ),
              ],
            ),
          ),
        ),
        const _Example(
          heading: '간격만으로 충분한 목록',
          explanation: '각 항목의 제목과 여백으로 구분이 명확하면 선을 생략합니다.',
          code: '''Column(
  children: [
    Text('취향에 맞는 상품 찾기'),
    SizedBox(height: BrianSpacing.x6),
    Text('마음에 드는 상품 저장하기'),
  ],
)''',
          child: Column(
            children: [
              _Content(title: '취향에 맞는 상품 찾기', detail: '추천 목록에서 둘러보세요'),
              SizedBox(height: BrianSpacing.x6),
              _Content(title: '마음에 드는 상품 저장하기', detail: '관심 목록에서 다시 만날 수 있어요'),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionExample extends StatefulWidget {
  const _ActionExample();

  @override
  State<_ActionExample> createState() => _ActionExampleState();
}

class _ActionExampleState extends State<_ActionExample> {
  bool _continued = false;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const _Content(title: '주문 확인', detail: '주문 내용을 확인한 뒤 다음 단계로 진행하세요.'),
      const BrianDivider(),
      Padding(
        padding: const EdgeInsets.all(BrianSpacing.x4),
        child: BrianButton(
          onPressed: () => setState(() => _continued = !_continued),
          child: Text(_continued ? '다시 확인' : '다음 단계'),
        ),
      ),
      if (_continued)
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Semantics(
            liveRegion: true,
            child: const Text('다음 단계를 선택했습니다.'),
          ),
        ),
    ],
  );
}

class _Content extends StatelessWidget {
  const _Content({required this.title, required this.detail, this.number});
  final String title;
  final String detail;
  final String? number;

  @override
  Widget build(BuildContext context) {
    final theme = BrianTheme.of(context);
    return Padding(
      padding: const EdgeInsets.all(BrianSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (number != null) SizedBox(width: 40, child: Text(number!)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.typography.t5Bold),
                const SizedBox(height: BrianSpacing.x2),
                Text(
                  detail,
                  style: theme.typography.t4Regular.copyWith(
                    color: theme.colors.foreground.neutralMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
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
      Surface(padding: 0, child: child),
      const SizedBox(height: BrianSpacing.x4),
      CodeExample(code),
    ],
  );
}
