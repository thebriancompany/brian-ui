# 모서리 반지름

`BrianRadius`는 모서리의 둥글기를 정하는 고정 `double` 상수입니다.
단위는 논리 픽셀이며 기기 픽셀 비율을 곱하지 않습니다.
라이트·다크에서 같은 값을 사용하고 `BrianThemeData`에는 포함하지 않습니다.

## 기본 스케일

`r1`은 4 논리 픽셀이고,
`r0Point5`처럼 `Point5`가 붙은 이름은 0.5 단계를 뜻합니다.

| 단계 | 논리 픽셀 |
| --- | --- |
| r0Point5 | 2 |
| r1 | 4 |
| r1Point5 | 6 |
| r2 | 8 |
| r2Point5 | 10 |
| r3 | 12 |
| r3Point5 | 14 |
| r4 | 16 |
| r5 | 20 |
| r6 | 24 |

## 적용과 선택

작은 값은 각진 형태를 유지하고 큰 값은 모서리를 더 둥글게 만듭니다.
요소 크기와 형태에 맞춰 선택하며 특정 컴포넌트에 대한 역할은 고정하지 않습니다.
전체 모서리 또는 일부 모서리에 같은 기본 수치를 적용할 수 있습니다.

```dart
import 'package:brian_ui/brian_ui.dart';
import 'package:flutter/widgets.dart';

final rounded = BorderRadius.circular(BrianRadius.r2);
const roundedTop = BorderRadius.vertical(
  top: Radius.circular(BrianRadius.r3),
);
```

`BoxDecoration.borderRadius`는 배경·테두리의 형태를 지정합니다.
자식 콘텐츠까지 잘라야 한다면 `ClipRRect` 등을 별도로 적용합니다.

## 완전한 원과 캡슐

큰 반지름 수치로 형태를 대신하는 `full` 토큰은 제공하지 않습니다.
원과 캡슐은 Flutter의 형태 API를 사용합니다. 아래 API는 Material·Cupertino에
의존하지 않고 `package:flutter/widgets.dart`에서 사용할 수 있습니다.

| 목적 | Flutter API | 적용 기준 |
| --- | --- | --- |
| 원형 배경·테두리 | `BoxDecoration(shape: BoxShape.circle)` | 짧은 변을 지름으로 하는 원 |
| 원형 ShapeBorder | `CircleBorder` | `ShapeDecoration` 등에 적용 |
| 원형 이미지 클리핑 | `ClipOval` | 정사각형 크기를 지정해야 원이 됨 |
| 양끝이 둥근 캡슐 | `StadiumBorder` | 주어진 영역의 짧은 변에 맞춰 양끝을 반원으로 표현 |

```dart
const circle = BoxDecoration(
  color: BrianStaticColors.white,
  shape: BoxShape.circle,
);
const capsule = ShapeDecoration(
  color: BrianStaticColors.white,
  shape: StadiumBorder(),
);

Widget circularImage(ImageProvider image) => ClipOval(
  child: Image(image: image, width: 48, height: 48, fit: BoxFit.cover),
);
```

배경을 원형으로 그리는 것과 자식을 원형으로 자르는 것은 별개입니다.
`ClipOval`에 가로·세로가 다른 크기를 주면 원이 아닌 타원으로 잘립니다.

## 참고

- [Flutter BorderRadius](https://api.flutter.dev/flutter/painting/BorderRadius-class.html)
- [Flutter BoxDecoration](https://api.flutter.dev/flutter/painting/BoxDecoration-class.html)
- [Flutter BoxShape](https://api.flutter.dev/flutter/painting/BoxShape.html)
- [Flutter ClipOval](https://api.flutter.dev/flutter/widgets/ClipOval-class.html)
- [Flutter StadiumBorder](https://api.flutter.dev/flutter/painting/StadiumBorder-class.html)
