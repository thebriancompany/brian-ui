# Divider

`BrianDivider`는 콘텐츠 사이에 1 논리 픽셀의 시각적 경계를 만듭니다.
`BrianTheme` 아래에서 사용하며 Material·Cupertino에 의존하지 않습니다.

## 경계의 강도

| 톤 | 역할 색상 | 사용 위치 |
| --- | --- | --- |
| `neutralMuted` (기본) | `stroke.neutralMuted` | 섹션, 헤더와 본문, 본문과 액션 영역 |
| `neutralSubtle` | `stroke.neutralSubtle` | 반복되는 목록·설정 항목 |

라이트·다크 전환과 사용자 정의 테마의 역할 색상을 따릅니다.
다른 경계 색상이 필요하면 `color`로 덮어쓸 수 있습니다.

```dart
const Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: [
    Text('주문 상품'),
    SizedBox(height: BrianSpacing.x4),
    BrianDivider(),
    SizedBox(height: BrianSpacing.x4),
    Text('배송 정보'),
  ],
)
```

## 들여쓰기와 반복 목록

선 자체는 여백을 만들지 않습니다. `Padding`으로 콘텐츠의 시작점에 맞춥니다.
방향을 고려하는 들여쓰기는 `EdgeInsetsDirectional`로 지정합니다.
목록에서는 항목 **사이**에만 넣고 마지막 항목 뒤에는 추가하지 않습니다.

```dart
ListView.separated(
  itemCount: items.length,
  itemBuilder: (context, index) => Text(items[index]),
  separatorBuilder: (context, index) => const Padding(
    padding: EdgeInsetsDirectional.only(start: 56, end: 16),
    child: BrianDivider(tone: BrianDividerTone.neutralSubtle),
  ),
)
```

## 세로 구분선과 크기 제약

가로선은 부모가 허용하는 최대 너비, 세로선은 최대 높이를 채웁니다.
해당 방향이 무한한 스크롤 영역에서는 `SizedBox` 등으로 길이를 제한해야 합니다.
특히 높이가 정해지지 않은 `Row`에 세로선을 바로 넣지 않습니다.
내용 높이에 맞춰야 한다면 작은 레이아웃에 `IntrinsicHeight`를 사용할 수 있지만,
긴 목록 전체에 적용하면 추가 레이아웃 비용이 생깁니다.

```dart
const SizedBox(
  height: 24,
  child: Row(
    children: [
      Text('조회 128'),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: BrianSpacing.x3),
        child: BrianDivider(axis: Axis.vertical),
      ),
      Text('관심 12'),
    ],
  ),
)
```

## 구분선이 필요하지 않은 경우

- 간격이나 타이포그래피만으로 관계가 명확하면 선을 추가하지 않습니다.
- 같은 그룹 안에서는 들여쓴 선, 그룹이나 액션 영역 사이에서는 전체 너비의 선을 사용합니다.
- 크게 다른 영역은 `background.layerBasement` 위에 `background.layerDefault` 표면을
  놓고 `BrianSpacing.x2`(8 논리 픽셀) 간격으로 구분합니다. 굵은 구분선으로 표현하지 않습니다.

## 상호작용과 접근성

구분선은 장식용이며 포인터 입력·키보드 포커스·접근성 탐색에 참여하지 않습니다.
섹션의 의미는 제목이나 목록 구조로 전달하세요. 선의 색상만으로 중요한 상태를
전달하지 않으며 사용자 정의 색상은 주변 표면에서 직접 확인합니다.
