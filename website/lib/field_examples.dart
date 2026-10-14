import 'package:brian_ui/brian_ui.dart';
import 'package:flutter/widgets.dart';

import 'site_widgets.dart';

class FieldExamples extends StatefulWidget {
  const FieldExamples({super.key});

  @override
  State<FieldExamples> createState() => _FieldExamplesState();
}

class _FieldExamplesState extends State<FieldExamples> {
  final _formKey = GlobalKey<FormState>();
  String _bio = '';
  bool _news = false;
  bool _events = false;
  bool _showHelp = false;
  bool _saved = false;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const _Example(
        title: '기본 입력과 도움말',
        description: '라벨은 입력 목적을, 도움말은 입력 기준을 설명합니다. BrianTextInput을 Field 안에 넣어 한 줄 입력 항목을 만듭니다.',
        code: "BrianField(\n  label: '이름',\n  helperText: '다른 사람에게 표시할 이름을 입력하세요.',\n  child: BrianTextInput(semanticLabel: '이름'),\n)",
        child: BrianField(
          label: '이름',
          helperText: '다른 사람에게 표시할 이름을 입력하세요.',
          child: BrianTextInput(semanticLabel: '이름'),
        ),
      ),
      _Example(
        title: '필수 입력과 제출 시 검증',
        description: '빈 값으로 저장하면 오류를 표시합니다. 이후 수정하면 다시 검증합니다. FormField가 검증하고 BrianField가 메시지를 표시합니다.',
        code: "FormField<String>(\n  validator: (value) => value == null || value.trim().isEmpty\n      ? '닉네임을 입력해 주세요.' : null,\n  builder: (state) => BrianField(\n    label: '닉네임',\n    requirement: BrianFieldRequirement.required,\n    errorText: state.errorText,\n    child: BrianTextInput(\n      semanticLabel: '닉네임, 필수',\n      isInvalid: state.hasError,\n      onChanged: state.didChange,\n    ),\n  ),\n)",
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FormField<String>(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => value == null || value.trim().isEmpty
                    ? '닉네임을 입력해 주세요.'
                    : null,
                builder: (state) => BrianField(
                  label: '닉네임',
                  requirement: BrianFieldRequirement.required,
                  helperText: '서비스에서 사용할 닉네임입니다.',
                  errorText: state.errorText,
                  child: BrianTextInput(
                    semanticLabel: '닉네임, 필수',
                    isInvalid: state.hasError,
                    onChanged: (value) {
                      state.didChange(value);
                      setState(() => _saved = false);
                    },
                  ),
                ),
              ),
              const SizedBox(height: BrianSpacing.x4),
              BrianButton(
                onPressed: () =>
                    setState(() => _saved = _formKey.currentState!.validate()),
                child: const Text('닉네임 저장'),
              ),
              if (_saved)
                Semantics(liveRegion: true, child: Text('닉네임을 저장했습니다.')),
            ],
          ),
        ),
      ),
      _Example(
        title: '여러 줄 입력과 글자 수',
        description: '선택 항목은 텍스트로 표시합니다. 이 예시는 이모지를 포함한 글자 수를 계산하고, 100자를 넘으면 인라인 오류를 표시합니다. 입력 자체를 차단하지는 않습니다.',
        code: "BrianField(\n  label: '자기소개',\n  requirement: BrianFieldRequirement.optional,\n  helperText: '100자 이내로 소개해 주세요.',\n  errorText: bio.characters.length > 100\n      ? '100자 이내로 줄여 주세요.' : null,\n  counterText: '\${bio.characters.length} / 100',\n  child: BrianTextArea(\n    semanticLabel: '자기소개, 선택',\n    maxLines: 6,\n    isInvalid: bio.characters.length > 100,\n    onChanged: (value) => setState(() => bio = value),\n  ),\n)",
        child: BrianField(
          label: '자기소개',
          requirement: BrianFieldRequirement.optional,
          helperText: '100자 이내로 소개해 주세요.',
          errorText: _bio.characters.length > 100 ? '100자 이내로 줄여 주세요.' : null,
          counterText: '${_bio.characters.length} / 100',
          child: BrianTextArea(
            semanticLabel: '자기소개, 선택',
            maxLines: 6,
            isInvalid: _bio.characters.length > 100,
            onChanged: (value) => setState(() => _bio = value),
          ),
        ),
      ),
      _Example(
        title: '체크박스 그룹',
        description: '공통 질문 아래 여러 입력을 묶습니다. 각 체크박스는 독립적으로 포커스하고 선택할 수 있습니다.',
        code: "BrianField(\n  label: '받고 싶은 소식',\n  labelWeight: BrianFieldLabelWeight.bold,\n  helperText: '여러 항목을 선택할 수 있습니다.',\n  child: Column(children: [newsCheckbox, eventsCheckbox]),\n)",
        child: BrianField(
          label: '받고 싶은 소식',
          labelWeight: BrianFieldLabelWeight.bold,
          helperText: '여러 항목을 선택할 수 있습니다.',
          child: Column(
            children: [
              BrianCheckbox(
                value: _news,
                onChanged: (value) => setState(() => _news = value),
                label: const Text('제품 업데이트'),
              ),
              BrianCheckbox(
                value: _events,
                onChanged: (value) => setState(() => _events = value),
                label: const Text('이벤트 소식'),
              ),
            ],
          ),
        ),
      ),
      _Example(
        title: '라벨 옆 보조 동작',
        description: '입력 기준을 필요할 때 펼쳐 봅니다. 좁은 화면이나 큰 글자에서는 보조 버튼이 다음 줄로 이동합니다.',
        code: "BrianField(\n  label: '배송 요청',\n  trailing: BrianButton(\n    variant: BrianButtonVariant.ghost,\n    onPressed: toggleHelp,\n    child: Text('작성 도움말'),\n  ),\n  helperText: showHelp ? '공동 현관 출입 방법을 적어 주세요.' : null,\n  child: BrianTextInput(semanticLabel: '배송 요청'),\n)",
        child: BrianField(
          label: '배송 요청',
          trailing: BrianButton(
            variant: BrianButtonVariant.ghost,
            onPressed: () => setState(() => _showHelp = !_showHelp),
            child: Text(_showHelp ? '도움말 접기' : '작성 도움말'),
          ),
          helperText: _showHelp ? '공동 현관 출입 방법을 적어 주세요.' : null,
          child: const BrianTextInput(semanticLabel: '배송 요청'),
        ),
      ),
      const _Example(
        title: '읽기 전용 입력',
        description: '입력 상태는 자식 위젯이 관리합니다. 읽기 전용 값은 선택하고 복사할 수 있습니다.',
        code: "BrianField(\n  label: '회원 번호',\n  helperText: '회원 번호는 변경할 수 없습니다.',\n  child: BrianTextInput(\n    semanticLabel: '회원 번호',\n    initialValue: 'BR-2026-001',\n    readOnly: true,\n  ),\n)",
        child: BrianField(
          label: '회원 번호',
          helperText: '회원 번호는 변경할 수 없습니다.',
          child: BrianTextInput(
            semanticLabel: '회원 번호',
            initialValue: 'BR-2026-001',
            readOnly: true,
          ),
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
