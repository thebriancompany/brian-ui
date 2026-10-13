# 타이포그래피

Flutter에서는 확대 전 논리 픽셀로 표현하며, `TextStyle.height`에는
줄 높이를 글자 크기로 나눈 비율을 전달합니다.

## 기반 값

`BrianFontSize`와 `BrianLineHeight`는 각각 다음 값을 제공합니다.

| 단계 | 글자 크기 | 줄 높이 |
| --- | --- | --- |
| t1 | 11 | 15 |
| t2 | 12 | 16 |
| t3 | 13 | 18 |
| t4 | 14 | 19 |
| t5 | 16 | 22 |
| t6 | 18 | 24 |
| t7 | 20 | 27 |
| t8 | 22 | 30 |
| t9 | 24 | 32 |
| t10 | 26 | 35 |
| t11 | 28 | 38 |
| t12 | 32 | 42 |
| t13 | 40 | 52 |
| t14 | 48 | 60 |

단위는 확대 전 논리 픽셀입니다. `BrianFontWeight`는 `regular`(400),
`medium`(500), `bold`(700)를 제공합니다. 실제 획의 모양은 글꼴에 따라 다릅니다.
`t11`~`t14`는 큰 화면의 대형 제목에 권장하며 화면 너비에 따라 자동 전환하지 않습니다.

## 스타일 선택

`BrianTypography`는 각 단계에 Regular·Medium·Bold 조합을 제공합니다.
예를 들어 `t5Regular`는 크기 16, 줄 높이 22, 굵기 400입니다.
역할에 맞는 스타일이 있으면 우선 사용합니다.

| 역할 | 용도 | 글자 크기 | 줄 높이 | 굵기 |
| --- | --- | --- | --- | --- |
| screenTitle | 화면 주요 제목 | 26 | 35 | 700 |
| articleBody | 게시물 본문 | 16 | 24 | 400 |

```dart
final theme = BrianTheme.of(context);
Text(
  '본문',
  style: theme.typography.articleBody.copyWith(
    color: theme.colors.foreground.neutral,
  ),
)
```

기본 스타일에는 색상과 글꼴을 지정하지 않습니다. 라이트·다크의 기본값은 같으며
색상은 역할 색상을 조합합니다. 테마 사용자 정의는 `doc/theming/overview.md`를 참고하세요.

## 앱의 글꼴 지정

폰트 파일 등록과 배포는 앱에서 담당합니다. 앱의 `pubspec.yaml`에 등록한
family 이름을 `DefaultTextStyle` 또는 개별 `TextStyle`에 지정합니다.
Brian UI는 폰트 파일을 포함하거나 다운로드하지 않습니다.

```dart
DefaultTextStyle(
  style: const TextStyle(fontFamily: 'AppFont'),
  child: content,
)
```

기본 typography 스타일은 `inherit: true`이므로 `Text`에서 상위 스타일의
글꼴을 상속합니다. 앱이 기본 스타일을 교체한다면 크기·줄 높이·굵기 등
필요한 속성을 유지하도록 기존 스타일의 `copyWith`를 사용하는 것이 좋습니다.
`RichText`를 직접 사용할 때는 필요한 스타일과 확대 정책을 명시해야 합니다.

## 확대와 줄 배치

기본 `Text`의 확대는 `MediaQuery`의 `TextScaler`에 맡깁니다. 토큰이나 테마에서
크기를 미리 확대하지 않습니다. 확대를 끄는 Static 토큰은 제공하지 않습니다.
예외적으로 확대를 끌 필요가 있는지는 사용 위치에서 판단합니다.

폰트 메트릭, fallback 글꼴, 혼합된 텍스트 크기와 문단 설정에 따라 실제 배치가
달라질 수 있습니다. 웹과 동일한 픽셀 배치나 접근성을 보장하지 않습니다.
한글·영문·여러 줄 본문과 사용자 글자 확대 설정을 앱에서 확인해야 합니다.

## 참고

- [Flutter TextStyle.height](https://api.flutter.dev/flutter/painting/TextStyle/height.html)
- [Flutter Text.textScaler](https://api.flutter.dev/flutter/widgets/Text/textScaler.html)
