# Badge

`BrianBadge`는 항목의 분류, 처리 상태, 부가 정보를 표시하는 정적인 라벨입니다.
상위에 `BrianTheme`을 두고 짧고 구체적인 문구를 사용합니다.

```dart
const BrianBadge(
  label: '승인됨',
  tone: BrianBadgeTone.positive,
)
```

## 표현 선택

| 속성 | 값 | 기본값 |
| --- | --- | --- |
| `tone` | neutral, brand, informative, positive, warning, critical | neutral |
| `variant` | solid, outline, weak | weak |
| `size` | medium, large | medium |
| `maxWidth` | 패딩을 포함한 최대 너비(논리 픽셀) | 120 |

`weak`는 반복되는 목록의 부가 정보에, `outline`은 상세 정보의 구분에,
`solid`는 주목해야 할 안내에 사용합니다. `brand`는 핵심 안내에 제한해서 사용합니다.
`informative`는 정보, `positive`는 완료, `warning`은 주의가 필요한 상태,
`critical`은 오류를 나타냅니다. 색상만으로 의미를 전달하지 않습니다.

## 크기와 긴 라벨

기본 테마의 medium은 12픽셀 글자와 20픽셀 높이,
large는 13픽셀 글자와 24픽셀 높이를 사용합니다.
글자 확대나 테마의 타이포그래피 변경에 따라 높이가 늘어납니다.
스타일을 바꿔도 테두리 때문에 크기가 달라지지 않습니다.

라벨은 한 줄이며 너비를 넘으면 말줄임합니다. 글자 수가 아닌 실제 표시 너비로
결정되므로 글꼴과 확대 설정에 따라 보이는 길이가 달라집니다.
`maxWidth`를 늘리거나 `double.infinity`로 제한을 없앨 수 있지만 부모 제약이
우선합니다. Row 안의 남은 공간을 사용하려면 `Flexible`로 감싸세요.
여러 배지는 `Wrap`으로 배치해 좁은 화면에서 줄을 바꿉니다.

## 테마와 접근성

배경·전경·테두리는 `BrianTheme`의 색상을 사용합니다.
작은 글자의 대비를 위해 informative·positive·critical의 solid 배경은
`background.informativeSolidContrast`·`positiveSolidContrast`·`criticalSolidContrast`를 사용합니다.
이 역할은 해당 팔레트의 라이트 step800, 다크 step500에서 만들어지며,
테마 전환 중에는 두 역할의 끝점 색상을 연속적으로 보간합니다.
다른 solid 배경과 전경·테두리는 기존 역할 색상을 사용합니다.
기본 테마의 모든 solid 조합은 일반 텍스트 대비 4.5:1 이상인지 테스트합니다.
이는 사용자 정의 팔레트·전경이나 완성된 화면의 접근성을 보장하지 않습니다.
solid는 각 색상의 `on…Solid` 전경을, weak와 outline은 neutral 또는
각 의미 색상의 `…Contrast` 전경을 사용합니다. outline은 배경이 투명하므로
실제 배경과의 대비를 확인해야 합니다. 사용자 정의 테마에서도 조합을 검토하세요.

전경과 배경을 독립적으로 보간하면 밝기가 교차할 수 있으므로, 모든 스타일에서
전경을 배경에 합성한 대비가 4.5:1 미만이면 검정·흰색 중 대비가 큰 전경으로
즉시 전환합니다. 대비가 충분한 역할 전경은 그대로 사용합니다. 이 보정은 사용자
정의 전경에도 적용되며 전환 중 전경색이 불연속적으로 바뀔 수 있습니다.
투명 배경은 `background.layerDefault`에 합성해 계산합니다. 다른 표면이나 이미지,
반투명 기본 표면에서는 실제 합성 배경의 대비를 별도로 검증해야 합니다.
기본 테마의 6개 색상·3개 스타일은 양방향 전환을 0.01 간격으로 테스트합니다.

화면에서 말줄임한 경우에도 접근성 트리에는 전체 라벨을 한 번 전달합니다.
버튼 역할, 탭 동작, 키보드 포커스는 제공하지 않습니다.
조작이 필요하면 `BrianButton`을 사용합니다. 상태 변화의 즉시 낭독이 필요하면
호출하는 화면에서 `Semantics(liveRegion: true)`로 알림 범위를 정합니다.
