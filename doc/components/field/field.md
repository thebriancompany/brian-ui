# Field

`BrianField`는 라벨, 입력 영역, 도움말 또는 오류, 글자 수를 묶습니다.
`BrianTheme` 아래에서 유한한 너비를 제공해 사용합니다.

## 역할과 이름

Field는 입력 항목의 공통 구성을 뜻합니다. 실제 텍스트 편집, 포커스, 선택,
키보드 처리는 자식 입력 위젯이 담당합니다. 체크박스 그룹이나 선택 버튼도
`child`로 넣을 수 있습니다.

Flutter의 `FormField<T>`는 값과 검증 상태를 관리합니다. `BrianField`는
그 상태를 표시하는 구성 요소이므로 `FormField`의 builder 안에서 조합합니다.
Material의 `TextField`처럼 텍스트 입력 기능을 자체 제공하지 않습니다.

## 기본 사용

```dart
BrianField(
  label: '이름',
  helperText: '다른 사람에게 표시할 이름을 입력하세요.',
  child: BrianTextInput(semanticLabel: '이름'),
)
```

`BrianTextInput`은 한 줄 입력, `BrianTextArea`는 여러 줄 입력을 담당합니다. 라벨은 간결한 명사로 쓰고
입력 기준은 도움말로 설명합니다. 긴 텍스트는 잘라내지 않고 줄바꿈합니다.

## 라벨과 보조 동작

- `labelWeight`: `medium` 또는 `bold`로 라벨을 강조합니다.
- `requirement`: `none`, `required`, `optional`을 선택합니다.
- 필수는 별표, 선택은 괄호 안의 텍스트로 표시합니다. 한 폼에서는 한 가지
  표시 방식을 선택합니다. 필수 여부 표시는 실제 검증을 수행하지 않습니다.
- `requiredLabel`은 별표의 접근성 문구, `optionalLabel`은 선택 표시입니다.
  다른 언어를 지원하면 앱의 번역 문자열을 전달합니다.
- `trailing`에는 도움말 버튼 등 보조 동작을 넣습니다. 너비가 부족하면
  라벨 아래로 줄바꿈됩니다. 큰 고정 너비를 가진 자식은 피합니다.

## 안내와 검증

`errorText`가 null이 아니면 `helperText` 대신 오류를 표시합니다.
오류가 없으면 null을 전달합니다. 빈 문자열도 오류로 취급합니다.
오류 메시지는 live region으로 제공하며 수정 방법을 구체적으로 설명합니다.

```dart
FormField<String>(
  validator: (value) => value == null || value.trim().isEmpty
      ? '이름을 입력해 주세요.'
      : null,
  builder: (state) => BrianField(
    label: '이름',
    requirement: BrianFieldRequirement.required,
    errorText: state.errorText,
    child: BrianTextInput(
      semanticLabel: '이름, 필수',
      isInvalid: state.hasError,
      onChanged: state.didChange,
    ),
  ),
)
```

`BrianTextInput.onChanged`를 `state.didChange`에 연결합니다. `Form`과 함께 사용하면
`FormState.validate()`로 제출 시 검증할 수 있습니다. 수정 중 검증은
`FormField.autovalidateMode` 또는 앱 상태로 제어합니다. 읽기 전용·비활성화·오류
테두리·포커스는 자식 입력에 별도로 적용합니다.

## 글자 수와 여러 줄 입력

`counterText`는 `'12 / 100'`처럼 호출자가 계산한 문자열을 표시합니다.
오류가 있어도 중립 색상을 유지합니다. 입력 제한과 길이 초과 검증은 수행하지
않습니다. 사용자에게 보이는 글자 수는 `text.characters.length`로 계산하면
이모지와 결합 문자를 한 글자로 셀 수 있습니다. 여러 줄 편집과 높이도 자식의
설정으로 제어합니다.

## 접근성과 배치

Field는 여러 입력의 의미 노드를 하나로 합치지 않습니다. 체크박스 그룹과
보조 버튼은 독립적으로 탐색할 수 있습니다. 라벨을 자식 입력의 접근성 이름으로
자동 연결하지 않으므로 입력 위젯에도 이름·필수 여부·오류 상태를 지정합니다.
라벨 클릭에 의한 포커스 이동은 제공하지 않습니다.

도움말과 오류는 같은 위치를 사용하며, 좁은 너비에서는 글자 수가 다음 줄로
이동할 수 있습니다. 오류는 `foreground.criticalContrast`, 도움말과 글자 수는
`foreground.neutralMuted`, 라벨은 `foreground.neutral`을 사용합니다.
배경은 상속하므로 사용자 정의 배경에서는 전경과의 대비를 확인합니다.

예시 페이지에서는 기본 입력, 필수 검증, 여러 줄과 글자 수, 체크박스 그룹,
라벨 옆 보조 동작, 읽기 전용 입력을 각각 체험할 수 있습니다.

Field 예시의 한 줄 입력에는 `BrianTextInput`, 자기소개에는 `BrianTextArea`를
사용합니다. 입력의 `isInvalid`와 Field의 `errorText`는 같은 검증 결과를 사용합니다.
