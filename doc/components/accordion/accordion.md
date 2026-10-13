# 아코디언

`BrianAccordion`은 관련 정보 여러 개를 접고 펼치는 목록입니다.
FAQ나 상세 안내처럼 사용자가 필요한 내용만 열어볼 때 사용합니다.
항상 읽어야 하는 핵심 정보는 접힌 본문에 숨기지 않습니다.

## 기본 사용

`BrianTheme` 아래에 배치하고 서로 다른 `value`를 가진 항목을 두 개 이상
지정합니다. `value`는 항목 순서가 바뀌어도 유지하는 식별자입니다.
기본값은 medium, inline, single이며 모든 항목이 접혀 있습니다.

```dart
BrianAccordion(
  children: const [
    BrianAccordionItem(
      value: 'delivery',
      title: Text('배송 안내'),
      description: Text('배송 기간과 방법을 확인하세요.'),
      child: Text('배송에는 2~3일이 걸립니다.'),
    ),
    BrianAccordionItem(
      value: 'returns',
      title: Text('반품 안내'),
      child: Text('주문 내역에서 반품을 신청하세요.'),
    ),
  ],
)
```

## 배치와 크기

| 옵션 | 표현 |
| --- | --- |
| `inline` | 항목 사이에 구분선을 표시하는 연속 목록 |
| `separated` | 각 항목에 테두리와 12픽셀 모서리를 적용한 개별 카드 |
| `medium` | 헤더 세로 여백 16, 제목 t5Medium, 설명 t3Regular, 표시 아이콘 20 |
| `large` | 헤더 세로 여백 20, 제목 t7Medium, 설명 t5Regular, 표시 아이콘 24 |

수치는 논리 픽셀입니다. separated의 항목 간격은 medium 12, large 16입니다.
제목과 설명은 글자 확대에 따라 줄바꿈하며, 크기는 화면 너비에 따라 자동으로
바뀌지 않습니다. 본문은 좌우와 아래에 16픽셀 여백을 제공합니다.

`prefix`에는 아이콘이나 장식 위젯을 전달합니다. 아이콘 기본 크기는 22이며
`prefixSpacing`으로 제목과의 간격을 바꿀 수 있습니다. 제목·설명·prefix에는
별도 버튼이나 입력 필드를 넣지 않습니다. 상호작용 위젯은 본문에 배치합니다.

## 펼침 상태

- `single`: 최대 하나를 펼칩니다. 다른 항목을 열면 기존 항목이 닫힙니다.
- `multiple`: 항목을 독립적으로 펼칩니다.
- 두 모드 모두 열린 헤더를 다시 누르면 닫히며, 전부 접을 수 있습니다.
- `initialExpandedValues`는 내부 상태의 최초 값입니다. 이후 변경은 무시합니다.
- `expandedValues`를 지정하면 부모가 상태를 소유합니다. 콜백 결과를 다시
  전달해야 화면이 바뀝니다. 외부 변경 자체는 콜백을 발생시키지 않습니다.

```dart
// StatefulWidget의 State 안에서 사용합니다.
Set<String> _expanded = {};

Widget buildAccordion() => BrianAccordion(
  expansionMode: BrianAccordionExpansionMode.multiple,
  expandedValues: _expanded,
  onExpandedChanged: (values) => setState(() => _expanded = values),
  children: const [
    BrianAccordionItem(
      value: 'delivery',
      title: Text('배송 안내'),
      child: Text('배송에는 2~3일이 걸립니다.'),
    ),
    BrianAccordionItem(
      value: 'returns',
      title: Text('반품 안내'),
      child: Text('주문 내역에서 반품을 신청하세요.'),
    ),
  ],
);
```

펼침 집합에는 현재 목록의 value만 넣습니다. single에서는 최대 하나만
지정합니다. 전달하는 목록·집합은 제자리에서 수정하지 않고 새 값으로 교체합니다.
내부 상태 사용 시 삭제한 항목은 펼침 집합에서도 제거합니다. multiple에서
single로 바꾸면 목록 순서상 첫 번째 열린 항목을 유지합니다. 제어 상태에서
내부 상태로 전환하면 직전 외부 값을 이어받습니다. 이 정리는 콜백을 호출하지 않습니다.

`enabled: false`는 해당 헤더의 탭·키보드 입력을 막고 비활성 색상을 적용합니다.
이미 열린 항목을 자동으로 닫지는 않으며 외부 상태 변경은 반영합니다.
기본적으로 접힘 애니메이션이 끝나면 본문을 제거합니다. 폼 입력 등을 보존하려면
항목에 `maintainState: true`를 지정합니다.

## 펼침 표시 교체

기본 chevron은 내부에서 직접 그리며 펼칠 때 아래에서 위로 180도 회전합니다.
본문 높이와 회전은 300ms에 걸쳐 전환됩니다. 전역 아이콘 설정은 필요하지 않습니다.

```dart
BrianAccordionItem(
  value: 'delivery',
  title: const Text('배송 안내'),
  indicatorBuilder: (context, isExpanded) => Text(isExpanded ? '−' : '+'),
  child: const Text('배송에는 2~3일이 걸립니다.'),
)
```

이 항목을 `BrianAccordion.children`에 넣습니다. builder는 상태 표시 UI 전체를
교체하며 자동 회전하지 않습니다. `IconTheme`과 `DefaultTextStyle`로 상태 색상과
스타일을 전달합니다. SVG나 직접 그리는 위젯은 필요하면 `IconTheme.of(context)`를
읽어 색상·크기를 적용하세요. 명시적으로 지정한 색상은 사용처에서 관리합니다.

표시는 장식용입니다. 별도 탭 처리, 포커스, 접근성 설명은 헤더가 담당합니다.
기본 모션은 `MediaQuery.disableAnimations`를 따릅니다. builder 안에서 추가하는
애니메이션은 해당 설정을 직접 반영합니다.

## 상호작용과 접근성

- 헤더 전체를 탭하거나 Tab으로 이동한 뒤 Enter·Space로 전환합니다.
- 포커스 링을 표시하고 헤더에 버튼·활성 여부·펼침 상태 semantics를 제공합니다.
- 접힌 본문은 탭·포커스·접근성 탐색에서 제외합니다. 유지되는 본문의 ticker도 중지합니다.
- 펼칠 때 자동 스크롤이나 본문으로의 자동 포커스 이동을 수행하지 않습니다.
- 본문마다 스크롤 영역을 만들기보다 전체 페이지가 스크롤되게 구성합니다.
- 기본 제목은 foreground.neutral, 설명·표시는 foreground.neutralSubtle,
  비활성 헤더는 foreground.disabled를 사용합니다. 배경은 부모 표면을 사용합니다.
- 사용자 정의 배경·아이콘·콘텐츠의 대비와 실제 스크린 리더 동작은 적용 화면에서 확인합니다.
