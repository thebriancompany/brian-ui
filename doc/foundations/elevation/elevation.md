# 고도

고도(Elevation)는 UI 요소 사이의 상대적인 깊이와 계층을 표현하는 설계 원칙입니다.
Brian UI는 표면색·그림자·경계색을 조합하며, 그림자 토큰은 `BrianShadows`로 제공합니다.
값은 시각적 표현에 사용하고 실제 쌓임 순서는 위젯을 배치하는 쪽에서 결정합니다.

## 화면과 콘텐츠의 계층

Global은 화면이나 모달처럼 콘텐츠를 담는 구조적 계층이고, Local은 그 표면 안에서의
콘텐츠 계층입니다. 다음은 배치 의도를 설명하는 기준이며 숫자형 API가 아닙니다.

| 범위 | 레벨 | 역할 |
| --- | --- | --- |
| Global | 0 | 화면의 가장 낮은 바탕: `layerBasement` |
| Global | 1 | 기본 페이지 표면: `layerDefault` |
| Global | 2 | 별도의 콘텐츠 맥락을 만드는 시트 등: `layerFloating` |
| Global | 3 | 활성 모달 위에서 집중을 요구하는 경고 대화상자 |
| Local | 1 | 해당 표면의 기본 콘텐츠 |
| Local | 2 | 해당 표면 위에 떠 있는 행동 요소 |
| Local | 3 | 해당 맥락의 일시적인 피드백 |

Local 레벨은 자신이 속한 Global 표면 안에서 해석합니다. 시트 안의 피드백이
별도의 경고 대화상자까지 덮어야 한다는 의미가 아닙니다. Global 3에도 별도의
색상 단계를 추가하지 않고, 표면의 역할에 맞는 기존 색상을 선택합니다.

같은 레벨에서도 콘텐츠와 고정 내비게이션의 겹침 순서를 구분할 수 있습니다.
이때 그림자나 경계선을 추가한다고 반드시 계층 레벨을 올리는 것은 아닙니다.
이번 API는 시트·대화상자·오버레이의 배치나 포커스, 입력 차단을 구현하지 않습니다.

## 표현 선택

- 표면색: `colors.background.layerBasement`, `layerDefault`, `layerFloating`으로
  컨테이너를 구분합니다. 기존 라이트·다크 매핑을 사용합니다.
- 그림자: 표면이 떠 있음을 드러낼 필요가 있을 때 `shadows.s1`부터 `s3`까지 선택합니다.
  기본값은 단계가 높을수록 이동·흐림·불투명도가 커집니다.
- 경계색: `colors.stroke`에서 강조도에 맞는 역할을 골라 경계선에 적용합니다.
  선의 두께와 적용할 변은 사용하는 컴포넌트에서 정합니다.

그림자의 s1~s3는 Global·Local 레벨과 일대일 대응하지 않습니다. 모달이라고
항상 s3를 사용하는 규칙도 없습니다. 주변 표면과 필요한 구분감으로 선택합니다.
다크 모드에서는 그림자가 잘 보이지 않을 수 있으므로 표면색과 경계색을 함께
검토합니다. 그림자 유무만으로 상호작용이나 접근성 충족 여부를 판단하지 않습니다.

## 기본 그림자 값

모든 길이는 Flutter logical pixel입니다.
기본 `blurStyle`은 `BlurStyle.normal`이며 라이트·다크에서 같은 값을 사용합니다.

| 토큰 | Offset(x, y) | blurRadius | spreadRadius | HEX(RRGGBBAA) | Dart ARGB | 불투명도 |
| --- | --- | --- | --- | --- | --- | --- |
| s1 | (0, 1) | 4 | 0 | `#00000014` | `0x14000000` | 7.84% |
| s2 | (0, 2) | 10 | 0 | `#0000001A` | `0x1A000000` | 10.20% |
| s3 | (0, 4) | 16 | 0 | `#0000001F` | `0x1F000000` | 12.16% |

각 토큰은 하나의 불변 `BoxShadow`입니다. Flutter의 `BoxDecoration.boxShadow`에
전달할 때 리스트로 감쌉니다. 그림자가 필요 없으면 해당 속성을 생략합니다.

```dart
final theme = BrianTheme.of(context);

final surface = DecoratedBox(
  decoration: BoxDecoration(
    color: theme.colors.background.layerFloating,
    boxShadow: [theme.shadows.s2],
  ),
  child: const SizedBox(width: 160, height: 80),
);
```

앱에서는 `package:brian_ui/brian_ui.dart`와 `package:flutter/widgets.dart`를
import하여 사용합니다. 테마 교체·사용자 정의는 `doc/theming/overview.md`를 참고합니다.

## Flutter 적용 시 구분할 점

`BoxShadow`는 이동·흐림·확장을 직접 지정할 수 있는 Flutter 기본 painting API입니다.
Material의 elevation 값으로 변환하지 않습니다. CSS px 수치를 logical pixel로
옮긴 것으로, 웹과 Flutter의 렌더링 결과가 픽셀 단위로 같다는 보장은 없습니다.

그림자는 공간을 확보하거나 위젯을 앞으로 이동시키지 않습니다. 주변 여백과
조상 위젯의 클리핑에 따라 그림자가 잘릴 수 있으므로 실제 배치에서 확인합니다.
`Stack`의 자식 순서와 `Overlay`의 배치가 실제 겹침을 결정합니다.
Global·Local의 계층 구분은 설계 지침이며 Flutter의 렌더링 계층과 동일시하지 않습니다.

## 참고

- [Flutter BoxShadow](https://api.flutter.dev/flutter/painting/BoxShadow-class.html)
- [Flutter Stack](https://api.flutter.dev/flutter/widgets/Stack-class.html)
- [Flutter Overlay](https://api.flutter.dev/flutter/widgets/Overlay-class.html)
