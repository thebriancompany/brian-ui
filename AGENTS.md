# Brian UI 작업 지침

## 시작하기

- 작업 전 `git status`와 관련 코드를 읽고 기존 변경을 보존한다.
- 코드 변경 시 [Dart/Flutter 컨벤션](doc/contributing/code_style.md)을 따른다.
- API·가이드 변경 시 [문서 작성법](doc/contributing/documentation.md)과
  [주석 기준](doc/contributing/comments.md)을 따른다.
- 이 파일은 핵심 원칙만 담는다. 상세 규칙과 예시는 위 문서에서 관리한다.

## 설계

- Brian UI는 Flutter 기본 계층으로 만드는 독립 디자인 시스템이다.
  핵심 구현에 Material·Cupertino를 import하거나 re-export하지 않는다.
- 기반 값, 역할 토큰, 테마 전달, 컴포넌트의 책임을 구분한다.
  테마는 색상·타이포그래피 등을 묶는 상위 개념이다.
- 구현은 `lib/src/`에 두고, 의도적으로 공개할 API만 `lib/brian_ui.dart`에서 export한다.
- 모델은 불변 값으로 설계한다. 토큰을 변경할 때 라이트·다크와 해당 상태의
  전경·배경 조합을 함께 확인한다. 검증하지 않은 접근성을 보장한다고 쓰지 않는다.
- 이름과 설명은 Brian UI 용어와 일반 색상명을 사용한다.
- 아직 필요하지 않은 추상화, 외부 의존성, 컴포넌트, 예제 앱을 선제적으로 추가하지 않는다.

## 코드와 주석

- `flutter_lints`의 공식 권장 규칙, `dart format`, Effective Dart를 기준으로 한다.
  추가 lint는 구체적인 이유와 영향 범위를 문서화한 뒤 도입한다.
- `public_member_api_docs`를 일괄 활성화하지 않는다.
  공개 멤버라는 이유만으로 자명한 주석을 만들지 않는다.
- API 계약은 한국어 `///`, 구현 의도는 `//`로 설명한다.
  이름·타입·시그니처를 한국어로 반복하는 주석은 생략한다.
- IDE에서 유용한 HEX·ARGB·알파 값, 단위, 사용 제한, 예외, 테마별 동작은 남긴다.
  값이나 동작을 바꾸면 관련 주석도 함께 수정한다.

## 문서 구조

- `doc/foundations/<주제>/`: 기반 값의 의미, 선택 기준, 참조표.
- `doc/theming/`: 테마 조합, 적용 범위, 사용자 정의, 전환.
- `doc/components/<컴포넌트>/`: 사용법, 상태, 상호작용, 접근성.
- `doc/contributing/`: 기여자가 따르는 코드·문서·주석 기준.
- API 문서는 소스의 `///`와 `dartdoc_options.yaml`의 category로 구성한다.
  `doc/api/`는 생성 결과이므로 직접 수정하거나 커밋하지 않는다.
- 문서를 옮기거나 추가하면 README, 내부 참조, category 경로를 함께 확인한다.

## 검증과 결과 보고

- Dart 수정: 포맷 확인과 `flutter analyze`.
- 동작 수정: 변경된 계약을 검증하는 관련 테스트. 단순 주석·문서 정리에는
  테스트를 새로 만들지 않는다.
- API 주석·문서·category 수정: `dart doc --validate-links`.
  종료 코드뿐 아니라 경고·오류 개수도 확인한다.
- 실행하지 못한 검증은 이유와 함께 보고한다. 통과했다고 추정하지 않는다.
- 브랜치를 새로 만들 때 기본 접두사는 `feature/`이다.
  커밋은 `feat:`, `fix:`, `refactor:`, `test:`, `chore:` 등 접두사 뒤에 한국어로 쓴다.
