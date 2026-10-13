# 간격

`BrianSpacing`은 여백과 요소 사이 간격에 사용하는 고정 `double` 상수입니다.
단위는 논리 픽셀이며 기기 픽셀 비율을 곱하지 않습니다.
라이트·다크에서 같은 값을 사용하고 `BrianThemeData`에는 포함하지 않습니다.

## 기본 스케일

`x1`은 4 논리 픽셀이고,
`x0Point5`처럼 `Point5`가 붙은 이름은 0.5 단계를 뜻합니다.

| 단계 | 논리 픽셀 |
| --- | --- |
| x0Point5 | 2 |
| x1 | 4 |
| x1Point5 | 6 |
| x2 | 8 |
| x2Point5 | 10 |
| x3 | 12 |
| x3Point5 | 14 |
| x4 | 16 |
| x4Point5 | 18 |
| x5 | 20 |
| x6 | 24 |
| x7 | 28 |
| x8 | 32 |
| x9 | 36 |
| x10 | 40 |
| x12 | 48 |
| x13 | 52 |
| x14 | 56 |
| x16 | 64 |

## 적용과 선택

관련된 요소는 작은 간격으로 묶고, 서로 다른 그룹은 더 큰 간격으로 구분합니다.
화면 크기와 콘텐츠에 맞는 단계 선택은 사용 위치에서 담당합니다.
수평·수직은 별도 스케일로 나누지 않고 같은 값을 사용합니다.

```dart
import 'package:brian_ui/brian_ui.dart';
import 'package:flutter/widgets.dart';

const padding = EdgeInsets.symmetric(horizontal: BrianSpacing.x4);
const verticalGap = SizedBox(height: BrianSpacing.x3);
const horizontalGap = SizedBox(width: BrianSpacing.x2);
const leadingPadding = EdgeInsetsDirectional.only(start: BrianSpacing.x4);
```

시작·끝 방향이 중요한 여백은 `EdgeInsetsDirectional`로 표현합니다.
기본 스케일은 화면 너비나 텍스트 확대에 따라 자동 변경되지 않습니다.
콘텐츠가 커질 때 필요한 공간은 레이아웃에서 확보합니다.

## 안전 영역과 화면 여백

안전 영역과 디자인 여백은 별도로 적용합니다. 안전 영역 경계 안쪽에
간격을 더하려면 `SafeArea` 안에 `Padding`을 배치합니다.

```dart
Widget insetContent(Widget content) => SafeArea(
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: BrianSpacing.x4),
    child: content,
  ),
);
```

`SafeArea.minimum`은 안전 영역 여백과 지정한 값 중 큰 값을 선택하므로
두 여백을 더하는 위 예제와 다릅니다. 상위 레이아웃의 여백을 함께 확인해
디자인 여백이 중복되지 않도록 합니다.

## 참고

- [Flutter EdgeInsetsDirectional](https://api.flutter.dev/flutter/painting/EdgeInsetsDirectional-class.html)
- [Flutter SafeArea](https://api.flutter.dev/flutter/widgets/SafeArea-class.html)
