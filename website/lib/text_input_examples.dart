import 'package:brian_ui/brian_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'site_widgets.dart';

class TextInputExamples extends StatefulWidget {
  const TextInputExamples({super.key});

  @override
  State<TextInputExamples> createState() => _TextInputExamplesState();
}

class _TextInputExamplesState extends State<TextInputExamples> {
  bool _hidden = true;
  String? _submitted;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const _Example(
        title: '기본 입력과 지우기',
        description: '입력하면 지우기 버튼이 나타납니다. 지운 뒤에도 입력을 이어갈 수 있습니다.',
        code: "BrianTextInput(\n  semanticLabel: '검색어',\n  placeholder: '검색어를 입력하세요',\n  showClearButton: true,\n)",
        child: BrianTextInput(
          semanticLabel: '검색어',
          placeholder: '검색어를 입력하세요',
          showClearButton: true,
        ),
      ),
      _Example(
        title: '밑줄 입력과 제출',
        description: '화면의 주요 입력을 간결하게 강조합니다. 입력 후 Enter를 눌러 보세요.',
        code: "BrianTextInput(\n  semanticLabel: '프로젝트 이름',\n  variant: BrianTextInputVariant.underline,\n  textInputAction: TextInputAction.done,\n  onSubmitted: (value) => setState(() => submitted = value),\n)",
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BrianTextInput(
              semanticLabel: '프로젝트 이름',
              placeholder: '새 프로젝트 이름',
              variant: BrianTextInputVariant.underline,
              textInputAction: TextInputAction.done,
              onSubmitted: (value) => setState(() => _submitted = value),
            ),
            if (_submitted != null)
              Semantics(liveRegion: true, child: Text('입력한 프로젝트: $_submitted')),
          ],
        ),
      ),
      _Example(
        title: '앞뒤 슬롯과 숫자 입력',
        description:
            '금액의 단위를 입력 양옆에 표시합니다. 숫자 키보드와 포매터를 함께 사용해 붙여넣기에도 같은 규칙을 적용합니다.',
        code: "BrianTextInput(\n  semanticLabel: '금액',\n  prefix: Text('₩'),\n  suffix: Text('원'),\n  keyboardType: TextInputType.number,\n  inputFormatters: [FilteringTextInputFormatter.digitsOnly],\n)",
        child: BrianTextInput(
          semanticLabel: '금액',
          placeholder: '0',
          prefix: const Text('₩'),
          suffix: const Text('원'),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
      ),
      _Example(
        title: '비밀번호 표시 전환',
        description: '뒤쪽 슬롯에 표시 전환 버튼을 조합합니다. 숨김 상태에서도 전체 선택과 붙여넣기가 가능합니다. 자동 수정·복사·잘라내기는 차단합니다.',
        code: "BrianTextInput(\n  semanticLabel: '비밀번호',\n  obscureText: hidden,\n  suffix: BrianButton(\n    variant: BrianButtonVariant.ghost,\n    onPressed: () => setState(() => hidden = !hidden),\n    child: Text(hidden ? '표시' : '숨기기'),\n  ),\n)",
        child: BrianTextInput(
          semanticLabel: '비밀번호',
          placeholder: '비밀번호 입력',
          obscureText: _hidden,
          suffix: BrianButton(
            variant: BrianButtonVariant.ghost,
            size: BrianButtonSize.small,
            onPressed: () => setState(() => _hidden = !_hidden),
            child: Text(_hidden ? '표시' : '숨기기'),
          ),
        ),
      ),
      const _Example(
        title: '오류와 포커스',
        description: '오류 입력에 포커스해 보세요. 오류 색상을 유지하면서 테두리를 강조합니다. 해결 방법은 Field의 오류 문구로 안내합니다.',
        code: "BrianField(\n  label: '이메일',\n  errorText: '이메일 주소를 확인해 주세요.',\n  child: BrianTextInput(\n    semanticLabel: '이메일',\n    initialValue: 'brian@',\n    isInvalid: true,\n  ),\n)",
        child: BrianField(
          label: '이메일',
          errorText: '이메일 주소를 확인해 주세요.',
          child: BrianTextInput(
            semanticLabel: '이메일',
            initialValue: 'brian@',
            isInvalid: true,
          ),
        ),
      ),
      const _Example(
        title: '읽기 전용과 비활성화',
        description: '읽기 전용은 선택·복사가 가능하고, 비활성화는 포커스와 편집을 받지 않습니다.',
        code: "BrianTextInput(semanticLabel: '회원 번호', initialValue: 'BR-001', readOnly: true)\nBrianTextInput(semanticLabel: '연동 계정', initialValue: '연동 준비 중', enabled: false)",
        child: Column(
          children: [
            BrianTextInput(
              semanticLabel: '회원 번호',
              initialValue: 'BR-001',
              readOnly: true,
            ),
            SizedBox(height: BrianSpacing.x3),
            BrianTextInput(
              semanticLabel: '연동 계정',
              initialValue: '연동 준비 중',
              enabled: false,
            ),
          ],
        ),
      ),
    ],
  );
}

class TextAreaExamples extends StatelessWidget {
  const TextAreaExamples({super.key});

  @override
  Widget build(BuildContext context) => const Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      _Example(
        title: '내용에 맞춰 늘어나는 입력',
        description: '기본 세 줄에서 시작합니다. 여러 줄을 입력하면 높이가 자연스럽게 늘어납니다.',
        code: "BrianTextArea(\n  semanticLabel: '메모',\n  placeholder: '생각을 자유롭게 적어 보세요',\n)",
        child: BrianTextArea(
          semanticLabel: '메모',
          placeholder: '생각을 자유롭게 적어 보세요',
        ),
      ),
      _Example(
        title: '최대 높이가 있는 입력',
        description: '세 줄에서 여섯 줄까지 늘어난 뒤에는 입력 영역 안에서 스크롤합니다.',
        code: "BrianTextArea(\n  semanticLabel: '상세 설명',\n  minLines: 3,\n  maxLines: 6,\n)",
        child: BrianTextArea(
          semanticLabel: '상세 설명',
          placeholder: '상세 설명을 입력하세요',
          minLines: 3,
          maxLines: 6,
        ),
      ),
      _Example(
        title: '고정 높이와 내부 스크롤',
        description: '최소·최대 줄 수를 같게 지정합니다. 내용을 추가해도 주변 버튼의 위치가 바뀌지 않습니다.',
        code: "BrianTextArea(\n  semanticLabel: '배송 메모',\n  minLines: 3,\n  maxLines: 3,\n)",
        child: BrianTextArea(
          semanticLabel: '배송 메모',
          minLines: 3,
          maxLines: 3,
          initialValue:
              '도착 전 연락해 주세요.\n문 앞에 놓아 주세요.\n감사합니다.\n추가 메모를 입력할 수 있습니다.',
        ),
      ),
      _Example(
        title: '오류 안내와 조합',
        description: '입력 영역은 오류 상태를, Field는 수정 방법을 전달합니다.',
        code: "BrianField(\n  label: '문의 내용',\n  errorText: '문의 내용을 조금 더 자세히 적어 주세요.',\n  child: BrianTextArea(semanticLabel: '문의 내용', isInvalid: true),\n)",
        child: BrianField(
          label: '문의 내용',
          errorText: '문의 내용을 조금 더 자세히 적어 주세요.',
          child: BrianTextArea(
            semanticLabel: '문의 내용',
            isInvalid: true,
            initialValue: '문의합니다.',
          ),
        ),
      ),
      _Example(
        title: '읽기 전용과 비활성화',
        description: '읽기 전용 내용은 선택하고 복사할 수 있습니다. 비활성 입력은 키보드 탐색에서도 제외됩니다.',
        code: "BrianTextArea(semanticLabel: '접수 내용', initialValue: '접수된 문의입니다.', readOnly: true)\nBrianTextArea(semanticLabel: '답변', placeholder: '답변 준비 중', enabled: false)",
        child: Column(
          children: [
            BrianTextArea(
              semanticLabel: '접수 내용',
              initialValue: '접수된 문의입니다.',
              readOnly: true,
            ),
            SizedBox(height: BrianSpacing.x3),
            BrianTextArea(
              semanticLabel: '답변',
              placeholder: '답변 준비 중',
              enabled: false,
            ),
          ],
        ),
      ),
    ],
  );
}

class _Example extends StatelessWidget {
  const _Example({
    required this.title,
    required this.description,
    required this.code,
    required this.child,
  });
  final String title;
  final String description;
  final String code;
  final Widget child;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      SectionHeading(title),
      Text(description),
      const SizedBox(height: BrianSpacing.x4),
      Surface(child: child),
      const SizedBox(height: BrianSpacing.x4),
      CodeExample(code),
    ],
  );
}
