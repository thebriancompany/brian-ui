# 칩

`BrianChip`은 선택 항목, 필터, 추천 동작, 입력값을 표현합니다.
`BrianTheme` 아래에서 사용하며 상태는 부모가 관리합니다.

## 표현 선택

| 속성 | 값 | 용도 |
| --- | --- | --- |
| tone | neutral / brand | 중립 톤(기본값) / 브랜드 선택 톤 |
| variant | solid | 채움으로 선택을 강조 |
| variant | outlineStrong | 강한 외곽선으로 경계를 강조 |
| variant | outlineWeak | 여러 선택 항목을 차분하게 표시, 기본값 |
| size | small / medium / large | 최소 높이 32 / 36 / 40 논리 픽셀 |
| leadingStyle | icon / avatar / image | 아이콘 / 원형 이미지 / 둥근 사각 이미지 |

글자 확대 시 높이는 늘어납니다. 작은 칩을 터치 화면에 배치할 때는 항목 사이
간격과 실제 터치 영역을 제품 환경에서 확인하세요. 긴 라벨은 주어진 너비에서
줄바꿈합니다. 앞뒤 슬롯은 장식이며 별도의 포커스나 접근성 설명을 만들지 않습니다.
장식이 전달하는 정보는 라벨에도 포함하세요.

## 단일·다중 선택

`selected`에 bool을 전달하면 접근성 트리에 선택 상태를 전달합니다.
단일 선택은 현재 값 하나를 교체하고, 다중 선택은 집합에서 항목을 추가·제거합니다.
칩은 상태를 내부에서 변경하지 않습니다.

```dart
BrianChip(
  tone: BrianChipTone.brand,
  selected: interests.contains(item),
  onPressed: () => setState(() {
    if (!interests.add(item)) interests.remove(item);
  }),
  child: Text(item),
)
```

여러 항목은 `Wrap(spacing: 8, runSpacing: 8, children: ...)`으로 줄바꿈하거나,
`SingleChildScrollView`의 가로 스크롤 안에 `Row`로 배치합니다.
페이지를 전환하는 탭 역할과는 구분해서 사용하세요.

## 필터와 추천

필터는 선택 상태와 실제 결과 조건을 함께 갱신합니다. 활성 조건이 있을 때
별도 초기화 버튼을 제공하고, 초기화하면 조건 집합을 비웁니다.
추천 검색어처럼 즉시 실행하는 동작에는 `selected`를 생략합니다.

```dart
BrianChip(
  onPressed: () => search('캠핑 의자'),
  child: const Text('캠핑 의자'),
)
```

## 입력값 삭제

삭제 전용 입력값은 `onPressed: null`과 `onDeleted`를 지정합니다.
본문 동작과 삭제를 함께 제공할 수도 있으며 두 동작은 별도 포커스를 가집니다.
`trailing`과 삭제 버튼은 동시에 사용할 수 없습니다.
삭제 버튼 이름에는 항목을 구별할 수 있는 내용을 포함하세요.

```dart
BrianChip(
  onPressed: null,
  onDeleted: () => setState(() => people.remove('민지')),
  deleteLabel: '민지 삭제',
  child: const Text('민지'),
)
```

삭제 후 포커스를 다음 항목이나 입력창으로 옮길 필요가 있는 경우 부모에서
목록과 포커스를 함께 관리하세요. `enabled: false`는 본문과 삭제를 모두 막습니다.
콜백이 모두 null이면 비활성 칩으로 표시합니다.

## 상호작용과 테마

Tab으로 본문과 삭제 버튼을 탐색하고 Enter·Space로 실행합니다. 키 반복은
중복 실행하지 않습니다. 누름·호버·키보드 포커스를 표시하며, 선택 상태는
색상 표현과 접근성 상태로 전달합니다.

기본 neutral 톤은 중립 역할 색상을 사용하며, 선택된 solid는
`onNeutralSolid`와 `neutralSolid`를 조합합니다. 사용자 정의 테마와 실제
화면 배경에서는 대비와 포커스 식별성을 별도로 확인하세요.

## 브랜드 선택 톤

`tone: BrianChipTone.brand`는 variant에 관계없이 선택 시 다음 역할을 사용합니다.

| 역할 | 토큰 |
| --- | --- |
| 배경 / 눌림·호버 | `background.brandWeak` / `background.brandWeakPressed` |
| 전경 / 선택선 | `foreground.brandContrast` / `stroke.brandSolid` |

선택 전에는 기존 variant 표현을 사용합니다. 선택 시 장식용 체크를 추가하며
체크는 접근성 트리에서 제외하고 selected 상태로 전달합니다.
비활성 역할과 `stroke.focusRing`은 neutral 톤과 같습니다.

## 크기 설정

`BrianThemeData.chips`에서 크기별 `BrianControlStyle`을 설정합니다.
삭제 버튼은 별도 `iconButtons.xsmall` 설정을 따릅니다.
