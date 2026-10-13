#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."
base_href="${1:-/}"
if [[ ! "$base_href" =~ ^/([A-Za-z0-9._-]+/)*$ ]]; then
  echo 'base href는 / 또는 /저장소명/ 형태여야 합니다.' >&2
  exit 1
fi

flutter pub get
dart run tool/sync_website_docs.dart
(
  cd website
  flutter pub get --enforce-lockfile
)
dart format --output=none --set-exit-if-changed lib test tool website/lib website/test
flutter analyze
flutter test
(
  cd website
  flutter analyze
  flutter test
  flutter build web --release --base-href "$base_href"
)

mkdir -p build
# 이전 생성 결과가 남아 삭제된 API가 배포되지 않도록 매번 새로 만듭니다.
rm -rf doc/api
dart doc --validate-links 2>&1 | tee build/dartdoc.log
if ! grep -Eq '^Found 0 warnings and 0 errors\.$' build/dartdoc.log; then
  echo 'dartdoc 경고·오류가 없음을 확인하지 못했습니다. build/dartdoc.log를 확인하세요.' >&2
  exit 1
fi

rm -rf website/build/web/api
cp -R doc/api website/build/web/api
touch website/build/web/.nojekyll
echo "배포 산출물: website/build/web (base href: $base_href)"
