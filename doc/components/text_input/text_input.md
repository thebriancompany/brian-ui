# Text Input

`BrianTextInput`은 한 줄 텍스트 입력입니다. `BrianTheme` 아래에서 유한한 너비를
제공합니다. 선택 메뉴를 위해 `Overlay`가 필요하며 일반적인 `WidgetsApp`의
Navigator 아래에서는 자동으로 제공됩니다. Flutter 기본 위젯의 편집·선택·키보드 동작에 Brian UI의 역할 색상을
적용합니다. 여러 줄은 `BrianTextArea`, 라벨과 안내는 `BrianField`를 사용합니다.

## 기본 사용

```dart
BrianTextInput(
  semanticLabel: '검색어',
  placeholder: '검색어를 입력하세요',
  showClearButton: true,
  onChanged: (value) => setState(() => query = value),
)
```

`placeholder`는 빈 값일 때만 보이며 라벨을 대신하지 않습니다. 접근성 이름은
`semanticLabel`로 제공합니다. `variant`는 `outline`과 `underline`을 지원합니다.
둘 다 기본 최소 높이는 52 논리 픽셀이며 글자 확대에 따라 높이가 늘어납니다.

## 값과 포커스

- `controller`를 생략하면 내부에서 컨트롤러를 만들고 해제합니다.
- `initialValue`는 내부 컨트롤러의 최초 값입니다. 이후 변경해도 값을 덮어쓰지
  않습니다. 외부에서 변경하거나 초기화하려면 `controller`를 사용합니다.
- `controller`와 `initialValue`는 동시에 지정할 수 없습니다.
- 외부 컨트롤러를 제거하면 마지막 편집 값을 내부 컨트롤러로 이어받습니다.
- 외부 `controller`·`focusNode`는 호출자가 해제합니다.
- `onChanged`는 사용자 편집과 지우기 버튼에서 호출됩니다. 컨트롤러에 직접
  설정한 변경은 통지하지 않습니다. `onSubmitted`는 키보드 완료 동작을 받습니다.

지우기 버튼은 값이 있고 편집 가능한 경우에만 표시합니다. 지우면 빈 문자열을
한 번 통지하고 입력에 포커스를 돌려줍니다. `clearButtonLabel`을 번역할 수 있습니다.

## 상태

| 상태 | 동작 |
| --- | --- |
| 기본 | 편집·선택·키보드 포커스 가능 |
| 포커스 | 역할 색상과 굵은 테두리로 강조 |
| `isInvalid: true` | 오류 테두리와 접근성 오류 상태, 포커스 중에도 오류 색 유지 |
| `readOnly: true` | 수정·지우기 금지, 포커스·선택·복사 허용 |
| `enabled: false` | 포커스·편집·선택·슬롯 동작 차단, 비활성 색상 적용 |

오류 상태는 자체 검증하지 않습니다. 메시지는 `BrianField.errorText`로 표시합니다.
`isInvalid`와 `errorText`는 동일한 검증 결과에서 계산합니다.

```dart
BrianField(
  label: '이메일',
  errorText: error,
  child: BrianTextInput(
    semanticLabel: '이메일',
    controller: emailController,
    keyboardType: TextInputType.emailAddress,
    isInvalid: error != null,
  ),
)
```

## 슬롯과 입력 규칙

`prefix`·`suffix`에는 단위, 아이콘, 보조 버튼을 넣습니다. 슬롯은 편집 영역
바깥에 배치되며 텍스트 값에 포함되지 않습니다. 좁은 화면을 위해 짧은 내용과
작은 컨트롤을 사용합니다. 슬롯과 편집 메뉴는 입력의 탭 영역에 포함됩니다.

`keyboardType`, `textInputAction`, `textCapitalization`, `autofillHints`를 입력
목적에 맞게 지정합니다. 키보드 종류만으로 값이 제한되지는 않습니다.
`inputFormatters`로 붙여넣기까지 처리합니다. 한 줄 입력은 줄바꿈을 제거합니다.

`obscureText`로 비밀번호를 가릴 수 있습니다. 숨김 입력은 자동 수정·추천·복사·잘라내기를
차단하지만 전체 선택과 붙여넣기는 허용합니다. 표시 전환 버튼은 `suffix`로 조합합니다.

## 선택과 편집 메뉴

탭, 더블 클릭, 드래그, 길게 누르기 처리는 Flutter의 선택 제스처 빌더를 사용합니다.
기본 편집 메뉴는 잘라내기·복사·붙여넣기·전체 선택 중 현재 가능한 동작을 표시하고
`WidgetsLocalizations`의 문구를 사용합니다. 조회·공유 같은 추가 플랫폼 동작이나
앱별 메뉴는 `contextMenuBuilder`로 교체합니다. 브라우저의 기본 메뉴 정책은
Flutter 웹의 동작을 따릅니다.

기본 테마는 `background.layerDefault`와 `foreground.neutral`을 사용합니다.
오류는 `foreground.criticalContrast`, 포커스는 `stroke.focusRing`, 비활성은
`background.neutralWeak`·`foreground.disabled`를 사용합니다. 힌트는
`foreground.placeholder`이며 중요한 입력 기준은 Field의 도움말로 제공합니다.
사용자 정의 테마에서는 배경·전경·경계의 대비를 다시 확인합니다.
