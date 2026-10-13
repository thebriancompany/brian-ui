# 테마

테마는 색상·타이포그래피 등 디자인 설정을 묶어 앱이나 특정 영역에 적용하는 체계입니다.
각 기반 값의 의미와 사용 기준은 `foundations/`에서, 설정의 조합과 전달은
이 문서에서 다룹니다. 현재 구현은 색상과 타이포그래피를 제공합니다.

Brian UI는 Flutter의 `painting`, `foundation`, `widgets` 계층을 사용합니다.
색상과 타이포그래피 모델은 불변 데이터이며 `BrianTheme`은 `InheritedTheme`으로 데이터를
공급합니다. `ThemeData`, `ColorScheme`, `ThemeExtension`에 의존하지 않습니다.

## 앱 연결

`WidgetsApp`의 `builder` 아래에 `BrianTheme`을 배치합니다.
시스템 모드를 따르려면 다음처럼 밝기를 구독합니다.

```dart
builder: (context, child) => BrianTheme(
  data: BrianThemeData.forBrightness(
    MediaQuery.platformBrightnessOf(context),
  ),
  child: child ?? const SizedBox.shrink(),
),
```

사용자가 앱 설정에서 모드를 선택했다면 시스템 밝기 대신 해당 설정에 따라
`BrianThemeData.light` 또는 `dark`를 전달합니다. 테마는 설정을 저장하지 않습니다.
테마 데이터가 바뀌면 `BrianTheme.of(context)`를 호출한 위젯이 다시 빌드됩니다.

```dart
final colors = BrianTheme.of(context).colors;
final background = colors.background.layerDefault;
final foreground = colors.foreground.neutral;
```

테마를 생성하는 위치의 context는 그 아래에 있는 테마를 볼 수 없습니다.
`Builder` 또는 별도 자식 위젯 안에서 읽어야 합니다. 테마가 없는 경우
`of`는 설명이 포함된 `FlutterError`를 던지고 `maybeOf`는 null을 반환합니다.

## 사용자 정의

한 역할만 바꾸려면 해당 그룹을 복사합니다. 배경과 전경, 눌림 상태의 대비를
함께 확인하고, 라이트·다크 테마를 각각 준비합니다.

```dart
final base = BrianThemeData.light;
final colors = base.colors;
final custom = base.copyWith(
  colors: colors.copyWith(
    foreground: colors.foreground.copyWith(
      onBrandSolid: BrianStaticColors.black,
    ),
  ),
);
```

전체 브랜드 계열은 `brandScale`로 교체하며, 일반 색상명 팔레트는 보존합니다.
아래 예제의 보라색도 새로운 배경·전경 조합이므로 대비 검증은 별도로 필요합니다.

```dart
final palette = BrianPalette.light;
final colors = BrianColors.fromPalette(
  palette: palette,
  brightness: Brightness.light,
  brandScale: palette.purple,
);
final theme = BrianThemeData(colors: colors);
```

`colors.copyWith(palette: ...)`는 역할 색상을 다시 계산하지 않습니다.
팔레트와 역할을 함께 바꾸려면 `BrianColors.fromPalette`을 사용합니다.
이 factory는 기본 역할 매핑을 재적용하므로 기존 역할별 사용자 정의는
반환된 값에 다시 적용해야 합니다. 배너는 팔레트 매핑과 독립적입니다.

## 타이포그래피 사용자 정의

`BrianThemeData`는 typography를 생략하면 `const BrianTypography()`를 사용합니다.
라이트·다크 기본값은 같으며 `BrianTheme.of(context).typography`로 조회합니다.

```dart
final base = BrianThemeData.light;
final custom = base.copyWith(
  typography: base.typography.copyWith(
    articleBody: base.typography.articleBody.copyWith(
      fontSize: 18,
      height: 26 / 18,
    ),
  ),
);
```

스케일 스타일을 교체해도 역할 스타일은 다시 계산하지 않습니다.
폰트는 앱에서 등록하고 `DefaultTextStyle` 또는 개별 스타일로 지정합니다.
기반 값과 사용 기준은 `doc/foundations/typography/typography.md`에 정리합니다.

## 지역 테마와 오버레이

화면 일부를 `BrianTheme(data: custom, child: ...)`으로 감싸면
그 하위에는 가장 가까운 테마가 적용됩니다. 데이터는 값으로 비교되므로
같은 내용의 복사본으로 교체해도 테마 변경 알림은 발생하지 않습니다.

다른 위치에 삽입하는 오버레이나 라우트는 지역 테마를 자동 상속하지 않을 수 있습니다.
삽입할 위젯을 다음처럼 감싸 테마를 명시적으로 전달합니다.

```dart
final content = InheritedTheme.captureAll(
  context,
  const PopupContent(),
);
```

이때 전달한 테마는 캡처 시점의 값입니다. 열린 오버레이에서도 변경된 지역 테마를
따라야 한다면 다시 캡처·빌드하거나 공통 테마 아래에 배치해야 합니다.

## 전환

`theme.lerp(otherTheme, t)`는 색상·팔레트·배너·타이포그래피를 함께 보간합니다.
0과 1은 각각 시작과 끝이며, 밝기 열거값은 중간 지점에서 전환됩니다.
텍스트 스타일은 `TextStyle.lerp`의 규칙을 따르며, 중간값에서 두 스타일의
`inherit` 값은 같아야 합니다. `BrianTheme`은 자동 애니메이션을 수행하지 않습니다. 이후 전환을 추가할 때
이 보간 함수를 사용하고, 기기의 모션 감소 설정을 반영합니다.

테마는 데이터를 전달합니다. 일반 `Text`나 `Icon`의 스타일을 자동으로
덮어쓰지 않으므로 위젯에 텍스트 스타일과 역할 색상을 명시해야 합니다.
