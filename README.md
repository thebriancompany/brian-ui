# brian-ui

Flutter 기본 위젯 계층으로 구성하는 독립 디자인 시스템입니다.
패키지 이름은 `brian_ui`이며, 색상·타이포그래피·그림자·모서리·간격·테마와 버튼을 제공합니다.

- 라이트·다크 팔레트와 고정 흰색·검은색/알파 값
- 전경·배경·테두리의 역할 색상, 상호작용 상태와 배너 배경
- 크기·줄 높이·굵기 토큰과 스케일·역할별 텍스트 스타일
- 세 단계의 그림자 토큰과 표면색·경계색을 조합하는 고도 가이드
- 논리 픽셀 단위의 모서리 반지름과 간격 기본 스케일
- `BrianTheme`을 통한 테마 전달과 지역 테마 재정의
- 7가지 variant와 4가지 size, 로딩·키보드 입력을 지원하는 `BrianButton`
- 한국어 API 주석, 색상 선택 가이드와 대비 측정표

## 사용하기

```dart
import 'package:brian_ui/brian_ui.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(
    WidgetsApp(
      color: BrianStaticColors.white,
      builder: (context, child) => BrianTheme(
        data: BrianThemeData.forBrightness(
          MediaQuery.platformBrightnessOf(context),
        ),
        child: const Greeting(),
      ),
    ),
  );
}

class Greeting extends StatelessWidget {
  const Greeting({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = BrianTheme.of(context);
    final colors = theme.colors;
    return ColoredBox(
      color: colors.background.layerDefault,
      child: Center(
        child: Text(
          '안녕하세요, Brian UI',
          style: theme.typography.t5Regular.copyWith(
            color: colors.foreground.neutral,
          ),
        ),
      ),
    );
  }
}
```

`BrianTheme`은 색상·타이포그래피·그림자 데이터를 공급합니다. 시스템 모드 감지는 위 예제처럼
앱에서 연결하며, 모드 변경 시 구독하는 위젯을 다시 빌드합니다.
`BrianRadius`와 `BrianSpacing`은 테마 없이 사용하는 고정 기본 스케일입니다.
`BrianButton`은 이 기반 값을 조합하며 Material·Cupertino에 의존하지 않습니다.

## 문서

- 색상 선택과 접근성: `doc/foundations/color/color.md`
- 타이포그래피 선택과 글꼴 지정: `doc/foundations/typography/typography.md`
- 고도와 그림자 선택: `doc/foundations/elevation/elevation.md`
- 모서리 반지름과 원형·캡슐 표현: `doc/foundations/radius/radius.md`
- 간격 선택과 안전 영역: `doc/foundations/spacing/spacing.md`
- 버튼 사용과 상호작용: `doc/components/button/button.md`
- 테마 연결과 사용자 정의: `doc/theming/overview.md`
- 전체 색상값: `doc/foundations/color/color_reference.md`
- 전경·배경 대비 측정: `doc/foundations/color/color_contrast.md`

`///` 주석은 IDE 도움말과 API 문서의 원본입니다.
`dart doc`으로 `doc/api/`에 HTML을 생성할 수 있으며, `dartdoc_options.yaml`의
색상·타이포그래피·고도·모서리·간격·테마·버튼·색상값·대비 분류에서 가이드도 함께 읽을 수 있습니다.
생성된 문서는 정적 웹 호스팅에 배포할 수 있습니다. 향후 pub.dev에 배포하면
공개 API 문서도 자동으로 호스팅됩니다.

## 웹 문서 사이트

`website/`에서 실제 Brian UI 컴포넌트를 조작하고 기존 가이드를 읽을 수 있습니다.
라이트·다크 전환, 기반 토큰 미리보기, 버튼 옵션과 코드 복사를 제공합니다.
`develop`에 변경이 반영되면 GitHub Actions가 검증 후 GitHub Pages에 배포합니다.
최초 Pages 설정, 개발·검증 순서와 배포 방식은 `doc/contributing/website.md`를 참고하세요.

```sh
flutter pub get
dart run tool/sync_website_docs.dart
cd website
flutter pub get
flutter run -d chrome
```

사이트는 사용 가이드와 실행 예제를, dartdoc은 공개 API의 정확한 계약을 담당합니다.
배포 시 API 참조도 `api/`에 함께 제공하므로 둘을 유지합니다.
전체 검증과 배포 빌드는 저장소 루트에서 `bash tool/build_website.sh`로 실행합니다.

## 개발

기여 절차는 `CONTRIBUTING.md`, 에이전트 작업 기준은 `AGENTS.md`에 정리되어 있습니다.
Dart/Flutter 컨벤션, 문서 작성법, 주석 기준은 `doc/contributing/`에서 관리합니다.

현재 SDK 조건과 검증 환경은 Flutter 3.47.1 / Dart 3.13.1입니다.

```sh
flutter pub get
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
dart doc --validate-links
```

패키지는 현재 `publish_to: none`이며 pub.dev에 배포하지 않습니다. 웹 문서 사이트 배포와는 별개입니다.
프로젝트 자체의 배포 라이선스는 아직 결정하지 않았습니다.
