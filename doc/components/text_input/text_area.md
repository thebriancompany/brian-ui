# Text Area

`BrianTextArea`는 여러 줄 텍스트 입력입니다. `BrianTheme` 아래에서 유한한 너비를
제공합니다. 선택 메뉴를 위해 `Overlay`가 필요하며 일반적인 `WidgetsApp`의
Navigator 아래에서는 자동으로 제공됩니다. 한 줄의 검색·이름·이메일은 `BrianTextInput`을 사용합니다.

## 자동 높이와 내부 스크롤

```dart
BrianTextArea(
  semanticLabel: '문의 내용',
  placeholder: '궁금한 내용을 적어 주세요',
  minLines: 3,
  maxLines: 6,
)
```

| 설정 | 동작 |
| --- | --- |
| 기본 `minLines: 3`, `maxLines: null` | 최소 세 줄에서 내용에 따라 계속 늘어남 |
| `minLines: 3`, `maxLines: 6` | 여섯 줄까지 늘어나고 이후 내부 스크롤 |
| `minLines: 3`, `maxLines: 3` | 세 줄 높이를 유지하며 내부 스크롤 |

줄 수는 글자 크기와 행간에 따라 논리 픽셀 높이로 계산됩니다. 고정 픽셀 높이를
강제하지 않아 글자 확대에도 대응합니다. `minLines`는 양수이며, `maxLines`를
지정하면 최소 줄 수 이상이어야 합니다. 기본 키보드는 여러 줄 입력용입니다.
줄 수 제한은 글자 수 제한이 아닙니다.

## Field와 글자 수

```dart
BrianField(
  label: '자기소개',
  helperText: '100자 이내로 소개해 주세요.',
  errorText: bio.characters.length > 100 ? '100자 이내로 줄여 주세요.' : null,
  counterText: '${bio.characters.length} / 100',
  child: BrianTextArea(
    semanticLabel: '자기소개',
    maxLines: 6,
    isInvalid: bio.characters.length > 100,
    onChanged: (value) => setState(() => bio = value),
  ),
)
```

`characters.length`는 이모지·결합 문자를 사용자에게 보이는 글자 단위로 셉니다.
위 예제는 초과 입력을 허용하고 오류를 표시합니다. 입력 자체를 제한하려면
`inputFormatters`에 `LengthLimitingTextInputFormatter`를 전달합니다.

## 상태와 수명

`enabled`, `readOnly`, `isInvalid`, `controller`, `initialValue`, `focusNode`,
`onChanged`, `onSubmitted`는 한 줄 입력과 같은 계약입니다. 읽기 전용은 복사를
허용하고, 비활성화는 포커스와 편집을 차단합니다. 오류 문구는 Field에서 제공합니다.
컨트롤러를 생략하면 내부에서 생성·해제하며 외부 컨트롤러와 포커스 노드는
호출자가 해제합니다. `initialValue`는 최초 생성 때만 사용합니다.

텍스트 선택과 편집 메뉴를 제공하며 `contextMenuBuilder`로 메뉴를 교체할 수
있습니다. 접근성 이름은 `semanticLabel`로 지정합니다. Field 라벨을 입력에
자동 연결하지 않으므로 같은 이름을 전달합니다.

여러 줄 입력은 외곽선 형태만 제공하며 앞뒤 슬롯·지우기 버튼·비밀번호 숨김은
제공하지 않습니다. 긴 내용을 한 번에 지우는 동작이 필요하면 앱에서 의도와
복구 방법을 고려해 별도의 액션으로 구성합니다.
