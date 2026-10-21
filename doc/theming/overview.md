# 테마

Brian UI의 테마는 색상·타이포그래피·그림자·레이아웃 설정을 한곳에서 조합합니다.
컴포넌트는 `BrianTheme`에서 값을 읽으므로 테마를 바꾸면 같은 구현으로
라이트·다크와 사용자 정의 스타일을 표현할 수 있습니다.

일반 화면에서는 고정 색상보다 `background.layerDefault`, `foreground.neutral`
같은 **역할 토큰**을 먼저 선택하세요. 값의 이름이 사용 의도를 설명하고,
테마가 해당 모드에 맞는 실제 색상을 결정합니다.

## 역할 토큰으로 시작하기

배경과 그 위에 표시하는 전경을 함께 선택합니다. 다음 조합은 일반 콘텐츠의
기본 표면과 본문에 사용합니다.

```dart title="lib/content.dart" highlight="2-3"
final colors = BrianTheme.of(context).colors;
final background = colors.background.layerDefault;
final foreground = colors.foreground.neutral;

return ColoredBox(
  color: background,
  child: Text(
    'Brian UI',
    style: TextStyle(color: foreground),
  ),
);
```

| 사용 위치 | 배경 | 전경 |
| --- | --- | --- |
| 일반 콘텐츠 | `background.layerDefault` | `foreground.neutral` |
| 보조 표면 | `background.neutralWeak` | `foreground.neutral` |
| 중립 강조 액션 | `background.neutralSolid` | `foreground.onNeutralSolid` |
| 브랜드 강조 액션 | `background.brandSolid` | `foreground.onBrandSolid` |

기본 브랜드는 파란색 계열이며, 라이트는 흰색 전경, 다크는 검은색 전경을
사용합니다. 기본 상태의 대비는 각각 약 5.92:1, 7.76:1입니다. 사용자 정의
브랜드에서는 전경·배경과 눌림 상태를 함께 검증하세요.
측정값은 `doc/foundations/color/color_contrast.md`에서 확인합니다.

## 앱에 테마 연결

`WidgetsApp`의 `builder` 아래에 `BrianTheme`을 배치합니다.
시스템 모드를 따르려면 다음처럼 밝기를 구독합니다.

```dart title="lib/app.dart" highlight="2-4"
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

테마를 생성하는 위치의 context는 그 아래에 있는 테마를 볼 수 없습니다.
`Builder` 또는 별도 자식 위젯 안에서 읽어야 합니다. 테마가 없는 경우
`of`는 설명이 포함된 `FlutterError`를 던지고 `maybeOf`는 null을 반환합니다.

## 역할 색상 사용자 정의

한 역할만 바꾸려면 해당 그룹을 복사합니다. 배경과 전경, 눌림 상태의 대비를
함께 확인하고, 라이트·다크 테마를 각각 준비합니다.

```dart title="lib/theme.dart" highlight="5-7"
final base = BrianThemeData.light;
final colors = base.colors;
final custom = base.copyWith(
  colors: colors.copyWith(
    foreground: colors.foreground.copyWith(
      neutral: colors.palette.gray.step900,
    ),
  ),
);
```

전체 브랜드 계열은 `brandScale`로 교체하며, 일반 색상명 팔레트는 보존합니다.
아래 예제의 보라색도 새로운 배경·전경 조합이므로 대비 검증은 별도로 필요합니다.

```dart title="lib/brand_theme.dart" highlight="5"
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

## 그림자 사용자 정의

`BrianThemeData`는 shadows를 생략하면 `const BrianShadows()`를 사용합니다.
라이트·다크 기본값은 같으며 `BrianTheme.of(context).shadows`로 조회합니다.

```dart
final base = BrianThemeData.light;
final custom = base.copyWith(
  shadows: base.shadows.copyWith(
    s2: base.shadows.s2.copyWith(blurRadius: 12),
  ),
);
```

그림자만 바꿔도 테마 구독 위젯에 변경이 전달됩니다. 모드별로 다른 그림자가
필요하면 각 테마에 지정합니다. 다크 모드에서는 그림자를 진하게 만드는 것만으로
구분감을 해결하기보다 표면색과 경계색을 함께 검토합니다.
기본 수치와 사용 기준은 `doc/foundations/elevation/elevation.md`에 정리합니다.

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

`theme.lerp(otherTheme, t)`는 색상·팔레트·배너·타이포그래피·그림자·레이아웃 설정을 함께 보간합니다.
0과 1은 각각 시작과 끝이며, 밝기 열거값은 중간 지점에서 전환됩니다.
텍스트 스타일은 `TextStyle.lerp`의 규칙을 따르며, 중간값에서 두 스타일의
`inherit` 값은 같아야 합니다. 그림자는 `BoxShadow.lerp`의 규칙을 따릅니다.
레이아웃 토큰은 수치 보간하며, 컴포넌트 스타일은 양쪽 필드에 값이 있을 때
보간합니다. 한쪽이 null이면 0.5에서 상속 여부가 전환되어 크기가 바뀔 수 있습니다.
부드럽게 전환하려면 양쪽 테마에 같은 필드를 명시하세요.
`BrianTheme`은 자동 애니메이션을 수행하지 않습니다. 전환을 구현할 때는
기기의 모션 감소 설정을 반영합니다.

테마는 데이터를 전달합니다. 일반 `Text`나 `Icon`의 스타일을 자동으로
덮어쓰지 않으므로 위젯에 텍스트 스타일과 역할 색상을 명시해야 합니다.


## 적용 후 확인하기

- 라이트·다크에서 기본·눌림·비활성화 상태의 배경과 전경을 함께 확인합니다.
- `BrianTheme.of(context)`는 테마 아래의 context에서 호출합니다.
- 지역 테마 밖에 표시되는 오버레이에는 필요한 테마를 명시적으로 전달합니다.
- 팔레트 교체와 역할 색상 재계산은 구분합니다. `copyWith`는 기존 역할을 유지합니다.

테마 모델은 불변 값이며 `BrianTheme`은 `InheritedTheme`으로 데이터를 전달합니다.
핵심 패키지는 Flutter 기본 계층을 사용하며 Material의 `ThemeData`, `ColorScheme`,
`ThemeExtension`에 의존하지 않습니다. 기반 값의 선택 기준은 `doc/foundations/`에서,
생성자·속성의 정확한 계약은 API 참조에서 확인하세요.

## 컴포넌트 내부 레이아웃 사용자 정의

`spacing`과 `radius`는 `BrianSpacing`, `BrianRadius`와 같은 기본값의 테마
토큰입니다. 현재 버튼·아이콘 버튼·칩·바텀 시트에 적용하며 정적 상수는 바꾸지 않습니다.

**크기별 컴포넌트 스타일 → 테마 토큰 → 기본값** 순서로 적용합니다.
`buttons`, `iconButtons`, `chips`는 각각 독립적으로 크기별 설정을 받습니다.
생략한 필드는 기존 계산을 따릅니다. xsmall 버튼과 칩의 캡슐 형태는 `shape`로
변경하며, shape의 테두리 색과 두께는 컴포넌트 상태가 결정합니다.

| 설정 | 기본 토큰 사용 |
| --- | --- |
| 버튼 최소 높이 | xsmall `x8`, small `x9`, medium `x10`, large `x13` |
| 버튼 가로 패딩 | xsmall·small `x3Point5`, medium `x4`, large `x5` |
| 버튼 세로 패딩 | `x1Point5`, `x2`, `x2Point5`, `x3Point5` |
| 버튼 아이콘 간격 | xsmall·small `x1`, medium `x1Point5`, large `x2` |
| 버튼 모서리 | small·medium `r2`, large `r3` |
| 칩 최소 높이 | small `x8`, medium `x9`, large `x10` |
| 칩 패딩·간격 | 가로 small `x2Point5`, 나머지 `x3`; 세로·간격 `x1Point5` |
| 시트 | 패딩 `x6`, 영역 간격 `x5`, 상단 모서리 `r6` |

칩의 이미지 앞 패딩은 `x1`, 삭제 버튼 앞 패딩은 `x0Point5`입니다.
아이콘 버튼은 버튼의 세로 패딩을 양쪽에도 사용합니다.
`BrianControlStyle.padding`을 지정하면 이러한 슬롯별 기본 패딩을 대체합니다.

다음은 그린 역할 색상과 레이아웃을 라이트·다크에 적용하는 예입니다.
버튼 스타일은 medium에만 지정합니다.

```dart title="lib/custom_theme.dart"
BrianThemeData customTheme(Brightness brightness) {
  final base = BrianThemeData.forBrightness(brightness);
  return base.copyWith(
    colors: BrianColors.fromPalette(
      palette: base.colors.palette,
      brightness: brightness,
      brandScale: base.colors.palette.green,
    ),
    radius: const BrianRadiusTokens(r2: 16, r3: 24, r6: 32),
    buttons: const BrianButtonStyles(
      medium: BrianControlStyle(
        minimumSize: Size(48, 40),
        minimumTouchTarget: Size.square(48),
        padding: EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 8),
        gap: 8,
      ),
    ),
  );
}

final lightTheme = customTheme(Brightness.light);
final darkTheme = customTheme(Brightness.dark);
```

`minimumSize`는 시각적 최소 크기이며 콘텐츠에 따라 늘어납니다.
`minimumTouchTarget`은 투명한 터치 영역을 추가합니다. 두 값 모두 부모 제약을
따르므로 필요한 터치 크기보다 작은 최대 크기를 지정하지 마세요.
`EdgeInsetsDirectional` 패딩은 RTL에서 방향에 맞게 해석합니다.

`copyWith`의 null은 기존 값을 유지합니다. 크기별 덮어쓰기를 초기화하려면
해당 크기에 `const BrianControlStyle()`을 지정합니다.
