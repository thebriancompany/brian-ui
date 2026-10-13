# Dart/Flutter 컨벤션

## 기준과 도구

| 영역 | 기준 | 적용 방식 |
| --- | --- | --- |
| 정적 분석 | 공식 `flutter_lints` | `analysis_options.yaml`에서 include |
| 포맷 | Dart SDK의 `dart format` | 들여쓰기·줄바꿈 등을 자동 정렬 |
| 명명·설계·사용법 | Effective Dart | 린트가 검사하지 않는 부분도 코드 검토에 적용 |
| Brian UI의 설계 선택 | 이 저장소의 지침 | 독립 디자인 시스템, 불변 모델, 한국어 문서 |

`flutter_lints`는 Dart의 `lints/recommended.yaml` 위에 Flutter 규칙을 더한
공식 권장 세트입니다. `flutter create`로 생성한 프로젝트에도 적용됩니다.
현재 `pubspec.yaml`의 버전 제약은 `^6.0.0`입니다. 실제 해석된 버전은
`flutter pub deps`로 확인하며, 버전을 올릴 때 새 진단과 영향 범위를 검토합니다.

```yaml
include: package:flutter_lints/flutter.yaml
```

추가 규칙을 전부 활성화하거나 다른 린트 세트를 중복 적용하지 않습니다.
현재 별도로 활성화한 규칙은 없습니다. `public_member_api_docs`는 공식으로
제공되는 선택 규칙이지만 권장 세트의 필수 규칙은 아니며, 이 프로젝트에서는
모든 공개 멤버의 주석을 강제하지 않습니다. 대신 호출자가 알아야 할 계약을
주석 기준에 따라 검토합니다.

SDK의 analyzer 진단, lint, formatter는 역할이 다릅니다. `flutter analyze`가
통과해도 포맷·접근성·API 설계·문서 정확성까지 모두 검증된 것은 아닙니다.

## 작성 원칙

- 타입은 `UpperCamelCase`, 멤버·변수는 `lowerCamelCase`, 파일은
  `lowercase_with_underscores.dart`를 사용합니다.
- 패키지 이름은 `brian_ui`입니다. 외부 공개 타입에는 `Brian` 접두사를 사용해
  Flutter 및 다른 라이브러리 타입과 구분합니다. 이것은 저장소의 규칙입니다.
- 수동으로 열을 맞추거나 줄바꿈을 고집하지 않고 formatter 결과를 따릅니다.
- 재할당이 필요 없으면 `final`, 컴파일 시 상수로 표현할 수 있으면 `const`를
  사용합니다. 값 객체는 불변으로 만들고 위젯은 기존 Flutter 관례를 따릅니다.
- 이름과 타입이 의도를 드러내게 합니다. 주석이나 추상화로 불명확한 이름을
  보완하기 전에 더 나은 이름과 책임 분리를 검토합니다.
- 공개 진입점은 `lib/brian_ui.dart`, 구현은 `lib/src/`입니다.
  `src`에 있다는 사실만으로 export된 타입이 비공개가 되지는 않습니다.
- 핵심 구현은 `foundation`, `painting`, `widgets` 등 Flutter 기본 계층을 사용합니다.
  Material·Cupertino 테마나 컴포넌트에 의존하지 않습니다.
- 모델, 역할 매핑, 테마 전달을 분리하고 현재 필요한 기능만 구현합니다.
  `copyWith`·동등성·보간의 동작은 해당 값 객체의 계약과 일치해야 합니다.

## 확인 명령

`pubspec.yaml`의 SDK 조건을 만족하는 같은 Flutter 설치의 `flutter`와 `dart`를 사용합니다.
프로젝트의 의존성을 바꾼 경우 먼저 `flutter pub get`을 실행합니다.

```sh
dart format lib test
dart format --output=none --set-exit-if-changed lib test
flutter analyze
```

동작 변경에는 관련 테스트를 실행합니다. 실패를 숨기기 위해 lint를 끄거나
광범위한 `ignore_for_file`을 추가하지 않습니다. 규칙 예외가 필요하면 가장 좁은
범위에 적용하고 코드만으로 알기 어려운 이유를 남깁니다.

## 공식 자료

- [flutter_lints](https://pub.dev/packages/flutter_lints)
- [Effective Dart](https://dart.dev/effective-dart)
- [dart format](https://dart.dev/tools/dart-format)
- [public_member_api_docs](https://dart.dev/tools/linter-rules/public_member_api_docs)
