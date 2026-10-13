# 개발과 웹 배포

Brian UI는 패키지와 문서 앱을 같은 저장소에서 관리합니다. `website/`는 실제
`brian_ui`를 로컬 경로로 참조하는 Flutter 웹 앱이며, 설명·코드 예제·컴포넌트
플레이그라운드를 제공합니다. `develop`의 변경을 검증한 뒤 GitHub Pages에 배포합니다.
사이트는 출시 버전의 문서가 아니라 최신 개발 상태를 보여줍니다.

## 문서별 역할

| 위치 | 역할 | 수정할 때 |
| --- | --- | --- |
| `lib/`의 `///` | IDE와 API 참조에서 읽는 계약·제약 | 타입, 기본값, 예외, 상태 동작을 바꿀 때 |
| `doc/`의 Markdown | 선택 기준, 조합 방법, 사용 가이드 | 권장 사용법과 디자인 기준을 바꿀 때 |
| `website/lib/` | 실제 컴포넌트와 토큰을 조작하는 예제 | 새 컴포넌트나 확인할 상태를 추가할 때 |
| `doc/api/` | dartdoc 생성 결과 | 직접 수정하거나 커밋하지 않음 |

문서 사이트가 있어도 dartdoc은 유지합니다. 웹사이트는 실제 사용 모습을 보여주고,
dartdoc은 공개 클래스·생성자·속성의 정확한 시그니처와 API 계약을 보여줍니다.
배포 시 같은 커밋에서 둘을 만들고 사이트의 API 참조 버튼으로 연결합니다.
사용 가이드의 원본은 `doc/`이며 웹 전용으로 같은 설명을 다시 작성하지 않습니다.

## 저장소 구조

```text
lib/                         Brian UI 패키지
doc/                         가이드 원본
website/lib/                 문서 화면과 실제 컴포넌트 예제
website/assets/guides/       doc/에서 복사한 생성 자산 (커밋하지 않음)
website/web/                 Flutter 웹 진입 HTML
website/test/                사이트 동작과 반응형 레이아웃 검증
tool/sync_website_docs.dart  가이드 자산 동기화
tool/build_website.sh        로컬·CI 공통 검증 및 배포 산출물 생성
.github/workflows/deploy-website.yml
```

`website/pubspec.yaml`은 `brian_ui`를 `path: ../`로 참조합니다. 패키지를 별도
배포하지 않아도 현재 체크아웃의 구현으로 사이트를 실행할 수 있습니다.
문서 앱의 의존성과 잠금 파일은 앱 안에서 관리합니다. 패키지의 외부 의존성은
늘리지 않습니다. 사이트의 시각 요소와 버튼에는 Brian UI를 사용하며 Markdown
렌더러의 텍스트 선택·메뉴를 위해 문서 앱에서만 Material 기반 기능을 사용합니다.

## 로컬에서 개발하기

Flutter 3.47.1 / Dart 3.13.1을 기준으로 합니다. SDK를 변경하면 루트와 문서 앱의
`pubspec.yaml`, CI의 `flutter-version`, 문서의 버전 안내를 함께 확인합니다.
명령은 별도 안내가 없으면 저장소 루트에서 실행합니다.

```sh
flutter pub get
dart run tool/sync_website_docs.dart
cd website
flutter pub get
flutter run -d chrome
```

패키지와 예제의 Dart 변경은 hot reload로 확인합니다. Markdown을 수정한 경우
루트에서 `dart run tool/sync_website_docs.dart`를 다시 실행한 뒤 앱을 재시작해
자산 캐시를 갱신합니다. `website/assets/guides/`의 파일을 직접 고치지 않습니다.

로컬 개발 서버에는 API 문서가 함께 제공되지 않습니다. API 참조 연결까지
확인하려면 아래의 전체 빌드를 사용합니다.

## 컴포넌트를 추가하거나 수정하는 순서

1. `lib/src/`에서 구현하고 공개할 API만 `lib/brian_ui.dart`에 export합니다.
2. 바뀐 계약을 검증하는 패키지 테스트를 작성합니다. 기본·비활성화·로딩,
   키보드 입력과 semantics 등 해당 컴포넌트에 필요한 상태를 다룹니다.
3. `doc/components/<이름>/`에 사용 가이드를 작성합니다. API 계약은 소스의
   `///`에 남기고, 사용 기준과 조합 예제는 가이드에 둡니다.
4. `dartdoc_options.yaml`의 category 및 공개 타입의 category 표식을 연결합니다.
5. `website/lib/catalog.dart`에 경로와 원본 Markdown을 등록하고 문서 화면에
   실제 컴포넌트 예제를 연결합니다. `ButtonPlayground`를 구성 예로 참고합니다.
6. 예제의 옵션과 복사되는 코드가 같은 상태를 나타내는지 테스트합니다.
   이미지로 컴포넌트를 대체하거나 패키지 구현을 사이트에 복제하지 않습니다.
7. 사이트에서 라이트·다크, 좁은 화면, 글자 확대, Tab·Enter·Space 입력,
   긴 콘텐츠와 스크롤을 확인합니다. 웹에서의 확인은 모바일 앱 검증을 대체하지 않습니다.

기반 값을 수정할 때에는 `FoundationPreview`와 해당 참조표를 함께 확인합니다.
색상은 전경·배경과 눌림 상태를 함께 검토하고, 측정하지 않은 접근성 수준을
보장한다고 표현하지 않습니다. 사이트 상단의 모드 전환으로 전체 화면을 확인하고
테마 페이지에서는 지역 테마가 적용된 두 예제를 비교할 수 있습니다.

## Markdown 작성과 링크

웹사이트는 `doc/`의 제목·문단·목록·표·코드 블록을 렌더링합니다. 첫 번째 제목은
페이지 제목과 겹치므로 본문에서 생략합니다. 넓은 표와 코드는 가로로 스크롤하며,
본문은 선택해서 복사할 수 있습니다. 직접 작성한 HTML은 사용하지 않습니다.

문서 간 상대 링크는 원본 Markdown 기준으로 작성하고 대상 가이드를
`catalog.dart`에도 등록합니다. 웹사이트는 등록된 원본 경로를 페이지 URL로
변환합니다. 코드 경로는 백틱으로 표기합니다. 페이지 내부 앵커 이동과 등록되지
않은 Markdown 파일로의 이동은 현재 지원하지 않으므로 링크를 추가할 때 확인합니다.
API category에서 읽는 문서라면 dartdoc 링크 검증도 함께 통과해야 합니다.

### 코드 블록 설정

Markdown의 모든 fenced code block은 웹사이트의 공통 `CodeExample`으로 표시합니다.
언어·파일명 헤더, 복사 버튼, 여러 줄 코드의 줄 번호를 기본으로 제공하며,
긴 줄은 가로로 스크롤합니다. 여러 줄 텍스트 선택과 복사 버튼에는 줄 번호나
파일명·강조 메타데이터가 포함되지 않습니다.

여는 코드 펜스의 언어 뒤에 다음처럼 옵션을 작성합니다.

````text
```dart title="lib/theme.dart" highlight="2-4,7" numbers=false
// 코드 원문
```
````

| 옵션 | 기본값 | 사용 방법 |
| --- | --- | --- |
| 언어 | `text` | `dart`, `yaml`·`yml`, `json`, `bash`·`sh`·`shell`에 구문 색상 적용 |
| `title` | 언어명 | 파일명 또는 짧은 맥락을 큰따옴표로 지정 |
| `highlight` | 없음 | 1부터 시작하는 줄 번호 또는 범위를 쉼표로 구분 |
| `numbers` | `true` | `false`로 줄 번호 숨김. 한 줄 코드는 항상 숨김 |

미지원 언어는 원문을 그대로 보여줍니다. 강조할 줄은 실제 코드 범위 안에서만
적용합니다. 제목과 강조 줄은 코드의 의미를 이해하는 데 도움이 될 때 추가하고,
코드를 바꾸면 줄 번호도 함께 확인합니다. dartdoc에서는 같은 코드 원문이 보이며
웹사이트 전용 헤더와 강조 표현은 적용되지 않습니다.

문서 앱에서만 `highlight`를 사용해 문법을 분석합니다. 구문 색상은 라이트·다크
각각 별도로 정의했고 일반 역할 색상과 구분했습니다. `code_example.dart`와
`markdown_code_builder.dart`의 TODO에 Brian UI 코드 블록·구문 역할 토큰 도입 시
이관할 범위를 기록했습니다. 디자인 시스템의 기본 테마나 패키지 의존성에는
이 렌더러를 추가하지 않습니다.

코드에는 앱에 번들한 JetBrains Mono를 `BrianCode` 글꼴로 사용합니다.
출처와 라이선스는 `website/assets/fonts/README.md`와 `OFL.txt`에 보관하며
브라우저의 일반 `monospace` 글꼴 해석이나 별도 글꼴 서버에 의존하지 않습니다.

## 검증하고 배포 산출물 만들기

```sh
bash tool/build_website.sh
```

이 명령은 패키지와 웹 앱 의존성 설치, 문서 자산 동기화, 포맷 확인, 두 패키지의
분석·테스트, Flutter release 빌드, `dart doc --validate-links`를 실행합니다.
dartdoc은 종료 코드뿐 아니라 경고 0개·오류 0개를 확인해야 성공합니다.
로그는 `build/dartdoc.log`에 남습니다. 기존 `doc/api/`는 생성 전에 삭제합니다.

완성된 배포 디렉터리는 다음과 같습니다.

```text
website/build/web/
├── index.html              Flutter 문서 사이트
├── assets/                 번들·가이드 자산
├── api/index.html          dartdoc API 참조
└── .nojekyll
```

로컬에서 배포 결과를 확인합니다.

```sh
python3 -m http.server 8080 --bind 127.0.0.1 --directory website/build/web
```

브라우저에서 `http://localhost:8080`을 열고 페이지 이동, 새로고침, 뒤로·앞으로,
코드 복사, API 참조 연결을 확인합니다. 검토가 끝나면 서버를 종료합니다.

## GitHub Pages 최초 설정

저장소 관리자가 최초 한 번 다음 설정을 확인합니다.

비공개 저장소에서는 GitHub 요금제가 해당 저장소의 Pages를 지원해야 합니다.
지원하지 않는 경우 설정 API가 `Your current plan does not support GitHub Pages
for this repository`로 실패합니다. 이 경우 적합한 요금제를 사용하거나 저장소
공개 여부를 별도로 결정해야 하며, 워크플로 파일만으로 이 제한을 해소할 수 없습니다.

1. 저장소의 Settings → Pages → Build and deployment에서 Source를
   **GitHub Actions**로 선택합니다. 별도의 배포 브랜치는 만들지 않습니다.
2. Actions 실행과 `subosito/flutter-action`, `actions/*` 사용을 허용합니다.
3. `github-pages` environment에 배포 브랜치 제한이 있다면 `develop`을 허용합니다.
   완전 자동 배포를 원하면 해당 environment의 수동 승인 요구도 확인합니다.
4. `develop`의 브랜치 보호에서 PR과 **Validate and build** 검사를 필수로
   설정하는 것을 권장합니다. 직접 push도 배포되므로 머지만 허용하려면 보호가 필요합니다.

배포 작업에는 `pages: write`와 `id-token: write` 권한을 부여하며, 개인 액세스
토큰을 저장소 secret에 추가할 필요가 없습니다. 최초 설정과 실제 GitHub Actions
실행은 코드 파일 생성만으로 완료되지 않습니다.

## 자동 배포 동작

- `develop`을 대상으로 한 PR: 전체 검증과 빌드만 실행합니다. 공개 배포하지 않습니다.
- `develop`에 머지 또는 push: 검증 성공 후 GitHub Pages artifact를 업로드하고 배포합니다.
- Actions → Website → Run workflow: `develop`을 선택하면 수동 재배포합니다.
  다른 브랜치를 선택하면 검증만 실행합니다.
- 분석·테스트·빌드·문서 검증 실패: 배포 job을 실행하지 않고 기존 사이트를 유지합니다.
- 같은 브랜치에 새 실행이 생기면 이전 실행을 취소하고 최신 변경을 검증합니다.

사이트는 동일 커밋의 Flutter 앱과 API 참조를 하나의 artifact로 배포합니다.
`doc/api/`나 `website/build/`를 Git에 커밋하지 않습니다. 배포 성공 여부와 실제
주소는 Actions의 Deploy job 및 저장소의 Pages 화면에서 확인합니다.

## URL과 기본 경로

일반 저장소의 기본 경로는 `/<저장소명>/`입니다. 이 저장소에서는 `/brian-ui/`를
빌드에 적용합니다. `<소유자>.github.io` 저장소는 `/`를 사용합니다.
별도 경로를 사용하려면 저장소의 Actions variable `PAGES_BASE_PATH`에 `/` 또는
`/경로/` 형식으로 설정합니다. 커스텀 도메인을 루트에서 서비스할 때는 `/`로
설정하고 Pages의 도메인·DNS 설정도 별도로 완료해야 합니다.

Flutter의 기본 해시 URL을 사용하므로 `/#/components/button` 형태로 이동합니다.
저장소 하위 경로에서는 `/brian-ui/#/components/button`입니다. 해시 뒤의 경로는
서버에 전달되지 않아 Pages의 별도 rewrite나 404 우회 파일 없이 새로고침이 됩니다.
API 참조는 HTML의 base URL을 기준으로 `api/index.html`에 연결합니다.

하위 경로로 직접 빌드하려면 다음과 같이 실행합니다.

```sh
bash tool/build_website.sh /brian-ui/
```

이 결과를 로컬에서 열려면 `/brian-ui/` 경로에 해당 디렉터리를 제공해야 합니다.
단순 로컬 확인에는 인자 없이 `/`로 빌드하는 편이 편리합니다.

## 운영과 문제 해결

- 첫 배포가 권한 또는 environment 오류로 실패하면 Pages Source와 배포 허용
  브랜치를 확인합니다. 검증 실패를 우회하기 위해 deploy 조건을 제거하지 않습니다.
- 화면이 비거나 자산이 404라면 배포 주소와 base href를 비교합니다.
- 가이드가 오래되었다면 자산 동기화와 앱 재시작 여부를 확인합니다.
- 새 버전이 바로 보이지 않으면 Actions가 배포한 커밋을 확인하고 새로고침합니다.
  브라우저·CDN 캐시 때문에 반영 시점이 다를 수 있습니다.
- 이전 상태로 되돌릴 때에는 변경을 revert하는 PR을 `develop`에 머지하여
  같은 검증 절차로 재배포합니다.

Flutter 웹은 실제 컴포넌트 상호작용을 확인하는 용도로 사용합니다. 검색엔진
색인이나 브라우저 기본 본문 검색이 HTML 문서와 동일하게 동작한다고 가정하지
않습니다. 문서 검색 UI는 아직 제공하지 않으며 왼쪽 메뉴로 탐색합니다.
스크린 리더와 실제 대상 브라우저 검증은 자동 위젯 테스트와 별도로 수행합니다.
