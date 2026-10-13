# 기여 가이드

Brian UI의 코드와 문서는 아래 기준으로 작성합니다.

- [Dart/Flutter 컨벤션](doc/contributing/code_style.md): 공식 린트, 포맷, 설계 원칙.
- [문서 작성법](doc/contributing/documentation.md): API 주석, 사용 가이드, dartdoc 연결.
- [개발과 웹 배포](doc/contributing/website.md): 실제 예제, 문서 사이트 검증, Pages 자동 배포.
- [주석 기준](doc/contributing/comments.md): 남길 정보와 생략할 설명의 구분.
- [에이전트 작업 지침](AGENTS.md): 자동화된 작업에도 적용할 핵심 원칙.

## 변경 확인

```sh
dart format --output=none --set-exit-if-changed lib test
flutter analyze
```

동작을 바꾸었다면 관련 테스트를 실행합니다. 전체 테스트는 `flutter test`입니다.
API 주석이나 문서를 변경했다면 `dart doc --validate-links`로 생성 결과도 확인합니다.
Markdown 안의 Dart 예제가 자동 컴파일되는 것은 아니므로, 실행 가능한 예제로
소개할 코드는 별도로 분석하거나 해당 사용 경로를 테스트해야 합니다.

PR에는 변경한 동작과 이유, 실제 수행한 검증, 남아 있는 제한을 적습니다.
불필요한 API 변경이나 작업 범위 밖 정리를 함께 넣지 않습니다.

컴포넌트를 변경했다면 `website/`의 실제 예제와 가이드도 함께 확인합니다.
웹사이트와 API 참조를 포함한 전체 검증은 `bash tool/build_website.sh`로 실행합니다.
