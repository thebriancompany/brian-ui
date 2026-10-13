# Checkbox

여러 항목을 선택하거나 약관에 동의할 때 `BrianCheckbox`를 사용합니다.
`BrianTheme` 아래에서 사용하며 선택값은 부모가 관리합니다.

## 기본 사용

```dart
BrianCheckbox(
  value: agreed,
  onChanged: (value) => setState(() => agreed = value),
  label: const Text('이용약관에 동의합니다 (필수)'),
)
```

`value`는 `false`(미선택), `true`(선택), `null`(부분 선택)입니다.
누르면 미선택과 부분 선택은 `true`, 선택은 `false`를 `onChanged`로 전달합니다.
부분 선택은 사용자가 순환하는 값이 아니라 하위 항목에서 계산하는 상태입니다.
콜백에서 새 값을 반영하지 않으면 화면의 선택 상태도 바뀌지 않습니다.
`onChanged: null`은 비활성화입니다.

## 전체 선택

```dart
final bool? all = values.every((value) => value)
    ? true
    : values.any((value) => value) ? null : false;

BrianCheckbox(
  value: all,
  weight: BrianCheckboxWeight.bold,
  label: const Text('전체 선택'),
  onChanged: (value) => setState(() {
    values.fillRange(0, values.length, value);
  }),
)
```

부모 체크박스를 누르면 자식 항목에 같은 값을 적용합니다. 선택할 수 없는 자식이
있다면 앱에서 전체 선택의 대상과 집계 기준을 정하고 사용자에게 설명합니다.
빈 그룹에는 전체 선택을 표시하지 않습니다. 그룹 상태를 위한 별도 컨트롤러는 필요하지 않습니다.

## 크기·형태·강조

| 속성 | 선택 기준 |
| --- | --- |
| `size: medium` | 20 논리 픽셀 표시와 t4 라벨. 일반 목록에 사용합니다. |
| `size: large` | 24 논리 픽셀 표시와 t5 라벨. 더 강조할 행에 사용합니다. |
| `shape: square` | 경계가 명확한 상자. 기본 형태이며 필수 동의에 적합합니다. |
| `shape: ghost` | 상자 없는 체크 표시. 소수의 선택적 항목에 사용합니다. |
| `weight: regular` | 일반 항목의 기본 굵기입니다. |
| `weight: bold` | 부모 항목이나 중요한 라벨을 강조합니다. |

중립 역할 색상을 사용하며 선택된 상자는 `background.neutralSolid`와
`foreground.onNeutralSolid`, 눌림은 `background.neutralSolidPressed`를 사용합니다.
비활성 상태는 `background.disabled`와 `foreground.disabled`를 사용합니다.
라이트·다크와 사용자 정의 테마의 역할 토큰을 따릅니다. 사용자 정의 색상에서는
표시와 주변 표면의 대비를 다시 확인해야 합니다.

## 상호작용과 접근성

- 라벨과 여백을 포함한 전체 영역을 누를 수 있습니다. 최소 영역은 44×44 논리 픽셀입니다.
- `SizedBox(width: double.infinity)`나 늘어나는 Column 안에 두면 행 전체를 선택 영역으로 사용할 수 있습니다.
- Tab으로 포커스를 이동하고 Space·Enter로 선택합니다. 키를 길게 눌러도 반복 전환하지 않습니다.
- 키보드 포커스에는 `stroke.focusRing`으로 외곽선을 표시합니다. `focusNode`와 `autofocus`를 지원합니다.
- 접근성 트리에 라벨·선택·부분 선택·비활성 정보를 하나의 노드로 전달합니다.
- 라벨은 너비에 맞게 줄바꿈하고 글자 확대와 RTL 배치를 따릅니다. 고정 높이로 감싸지 않습니다.
- 라벨 안에 버튼이나 링크를 넣지 않습니다. 약관 보기와 같은 독립 동작은 체크박스 밖에 배치합니다.

`BrianCheckmark`는 선택 상태만 그리는 장식용 위젯입니다. 사용자 정의 행에서
사용할 때 부모가 전체 행의 터치, 키보드, 포커스, 접근성 의미 정보를 구현해야 합니다.
일반적인 선택 행은 이 책임을 이미 제공하는 `BrianCheckbox`를 우선 사용합니다.

복수 선택 후 저장하는 화면에서는 편집 중인 값과 저장한 값을 구분합니다.
필수 동의로 다음 동작을 제한할 때는 이유를 함께 표시하고, 선택 항목을 필수처럼 처리하지 않습니다.
