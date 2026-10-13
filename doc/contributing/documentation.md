# 문서 작성법

Brian UI는 API 설명과 사용 가이드를 함께 관리합니다. API 선언 옆의 `///`는
호출 지점에서 필요한 계약을 설명하고, Markdown 가이드는 여러 API를 조합하는
방법과 디자인 기준을 설명합니다. 긴 가이드를 각 멤버의 주석에 반복하지 않습니다.

## API 문서와 dartdoc

`dart doc`은 공개 Dart API를 읽어 정적 HTML 문서를 생성하는 SDK 명령입니다.
클래스·생성자·멤버의 이름과 시그니처는 코드에서 가져오고, 부가 설명은
선언 앞의 `///`에서 가져옵니다. 일반 `//`는 API 설명에 포함되지 않습니다.
주석이 없는 공개 멤버도 API 목록에서 확인할 수 있으므로, 목록을 채우려고
의미 없는 주석을 작성할 필요는 없습니다.

문서 주석은 한국어로 작성하고, 식별자는 코드 이름을 그대로 사용합니다.
첫 문장은 요약으로 쓰고 추가 계약·제약·예시는 빈 `///` 줄 이후에 씁니다.
Markdown 코드 블록과 목록을 사용할 수 있습니다.

```dart
/// 가장 가까운 테마를 반환하고 변경을 구독합니다.
///
/// 상위에 [BrianTheme]이 없으면 [FlutterError]를 던집니다.
```

`[BrianTheme]`처럼 범위 안의 식별자를 대괄호로 감싸면 API 링크가 됩니다.
찾을 수 없는 식별자나 사용식은 백틱으로 표현합니다. `@param`, `@returns`
같은 별도 태그 대신 문장 안에서 인자·반환값·예외를 설명합니다.
문서 주석은 `@immutable` 같은 annotation보다 앞에 둡니다.

어떤 주석을 남길지는 `doc/contributing/comments.md`를 따릅니다.

## 사용 가이드의 위치

```text
doc/
├── foundations/<주제>/  # 값의 의미·사용 기준·참조표
├── theming/             # 테마 조합·전달·사용자 정의
├── components/<이름>/   # 사용법·상태·상호작용·접근성
├── contributing/        # 코드·문서 작성 기준
└── api/                 # 생성 결과: 수정·커밋하지 않음
```

테마는 여러 foundation을 묶으므로 특정 foundation 아래에 두지 않습니다.
아직 구현하지 않은 내용을 실제로 제공하는 API처럼 설명하지 않습니다.
문서에는 적용할 범위, 선택 기준, 짧은 사용 예, 필요한 제약을 적습니다.
토큰 참조표와 접근성 측정표는 값이 바뀔 때 함께 갱신합니다.

## 가이드를 API 사이트에 연결하기

현재는 `dartdoc_options.yaml`의 category에 Markdown 가이드를 등록합니다.
예를 들어 색상 주제는 다음 설정을 사용합니다.

```yaml
dartdoc:
  categories:
    Color:
      markdown: doc/foundations/color/color.md
      displayName: 색상
  categoryOrder:
    - Color
```

관련 공개 타입이나 라이브러리의 문서 주석에는 다음 표식을 붙입니다.

```dart
/// 모드에 적응하는 팔레트입니다.
///
/// {@category Color}
```

`Color`는 설정과 일치하는 내부 키이고, `displayName`은 화면에 표시할 이름입니다.
category는 문서를 해당 주제로 묶는 용도입니다. 주석 본문 대신 표식만 달아
내용이 없는 API 설명을 늘리지 않습니다.

파일을 새로 만들었다고 자동으로 API 사이트의 가이드가 되지는 않습니다.
category 설정과 연결할 공개 선언을 함께 확인합니다. 생성 후 해당 주제 페이지가
실제로 나타나는지 확인합니다. 기여 가이드는 저장소에서 읽으며 API category에
등록하지 않습니다.

## 생성과 검증

```sh
flutter pub get
flutter analyze
dart doc --validate-links
```

문서는 `doc/api/`에 생성됩니다. 새 의존성 설치 없이 SDK의 `dart doc`을 사용합니다.
Flutter 설치의 `bin/dart`를 PATH로 실행하며, 캐시 안의 Dart 바이너리를 직접
호출해 Flutter SDK 경로 설정을 우회하지 않습니다.

경고가 있어도 문서 생성 명령이 성공할 수 있으므로 경고·오류 개수를 확인합니다.
특히 선언 참조, category 누락, 이동한 경로, 깨진 링크를 검토합니다.
`--validate-links`만으로 외부 웹 페이지의 존재나 코드 예제의 실행 결과까지
검증되는 것은 아닙니다. 주석의 코드 블록도 자동 테스트가 아닙니다.

README와 category Markdown은 저장소와 생성된 사이트에서 서로 다른 경로로
열립니다. 현재 README 및 category 가이드의 저장소 파일 참조는 `doc/...`처럼
코드 경로로 표기하고, API 사이트에서는 category 메뉴로 이동합니다.
Markdown 상대 링크를 추가할 때는 두 환경을 모두 검증합니다. 경고를 없애기
위해 검증하지 않은 외부 URL로 바꾸거나 생성 HTML을 직접 고치지 않습니다.

브라우저에서 검색·탐색까지 확인하려면 `doc/api/`를 HTTP 서버로 제공합니다.
README의 이미지는 dartdoc이 복사하지 않으므로 로컬 미리보기 전에 함께 복사합니다.
웹 문서 사이트 배포에서는 `tool/build_website.sh`가 이 복사를 처리합니다.
예를 들어 Python이 설치되어 있다면 다음 명령을 사용할 수 있습니다.

```sh
mkdir -p doc/api/doc/assets
cp doc/assets/* doc/api/doc/assets/
python3 -m http.server 8080 --bind 127.0.0.1 --directory doc/api
```

이후 브라우저에서 `http://localhost:8080`을 엽니다. 서버는 검토 후 종료합니다.
향후 pub.dev에 배포하면 공개 API 문서가 자동으로 호스팅됩니다. 생성 HTML은
GitHub Pages 같은 정적 호스팅에도 배포할 수 있습니다. 현재는 `develop` 변경 시 웹 문서 사이트와 API 참조를 함께 배포합니다.
설정과 검증 절차는 `doc/contributing/website.md`를 참고하세요.

## 공식 자료

- [dart doc](https://dart.dev/tools/dart-doc)
- [dartdoc category 설정](https://pub.dev/packages/dartdoc#dartdoc_optionsyaml)
- [Effective Dart: Documentation](https://dart.dev/effective-dart/documentation)
