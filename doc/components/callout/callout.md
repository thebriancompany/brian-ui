# Callout

`BrianCallout`은 화면 흐름 안에서 안내·상태·주의 사항을 강조합니다.
상위에 `BrianTheme`을 배치하고 가로 너비가 제한된 영역에서 사용합니다.

```dart
const BrianCallout(
  tone: BrianCalloutTone.informative,
  title: Text('배송 안내'),
  description: Text('주문 상세에서 예상 도착일을 확인해 주세요.'),
)
```

## 톤

| 톤 | 사용 상황 | 전경 / 배경 역할 |
| --- | --- | --- |
| neutral | 일반 안내 | neutral / neutralWeak |
| informative | 정보와 도움말 | informativeContrast / informativeWeak |
| critical | 오류·즉각적인 조치 | criticalContrast / criticalWeak |
| positive | 성공·완료 | positiveContrast / positiveWeak |
| warning | 주의 사항 | warningContrast / warningWeak |

라이트·다크 모두 현재 테마의 역할 색상을 사용합니다. 전체 영역을 누르는 동안에는
같은 배경의 `Pressed` 역할을 사용합니다. 사용자 정의 테마에서는 전경·배경 대비를
다시 확인하세요. 중요한 의미는 색상만으로 구분하지 말고 본문에도 적습니다.

## 아이콘

기본값은 20 논리 픽셀의 채워진 원형 느낌표입니다. 내부 벡터로 그리므로 이미지
에셋이나 아이콘 폰트 설치가 필요 없습니다. `icon`에 `Icon`, SVG 위젯, 이미지 등
원하는 위젯을 전달할 수 있습니다. `IconTheme`은 톤의 색상과 크기를 전달하지만
이미지의 색상을 자동으로 바꾸지는 않습니다. 이미지 크기는 직접 제한하세요.
`showIcon: false`이면 기본·커스텀 아이콘 모두 숨깁니다.

```dart
BrianCallout(
  tone: BrianCalloutTone.positive,
  icon: Icon(myCheckIcon),
  description: Text('프로필 인증이 완료되었습니다.'),
)
```

`myCheckIcon`은 앱에서 제공하는 `IconData`입니다. 체크 같은 기호를 `Text`로
넣으면 글꼴의 기준선과 내부 여백에 따라 위아래 위치가 달라 보일 수 있으므로
아이콘 폰트의 `Icon`이나 정사각형 벡터 위젯을 권장합니다.

아이콘은 장식용으로 취급하며 입력·포커스·접근성 탐색에서 제외합니다.
아이콘만으로 전하는 정보가 있다면 본문에도 작성하세요.

## 동작

- 기본은 읽기 전용입니다. 제목은 본문 위에, 보조 `action`은 본문 아래에 배치합니다.
- `onPressed`를 지정하면 전체 영역이 버튼이 되고 방향 표시가 나타납니다.
  탭·Enter·Space로 실행하며 키보드 탐색 시 포커스 테두리를 표시합니다.
- `onDismiss`를 지정하면 닫기 버튼이 나타납니다. 실제 제거와 재표시 여부는
  부모가 관리합니다. `dismissLabel`은 맥락에 맞게 지정하며 기본값은 ‘안내 닫기’입니다.
- `onPressed`는 `onDismiss`나 `action`과 함께 사용할 수 없습니다.
  제목과 본문에는 버튼·링크·입력 필드를 넣지 않습니다.

```dart
if (!dismissed)
  BrianCallout(
    description: const Text('새로운 검색 기능을 만나보세요.'),
    onDismiss: () => setState(() => dismissed = true),
  )
```

해결해야 하는 오류나 필수 경고에는 닫기를 제공하지 않는 편이 좋습니다.
본문에는 고정 높이나 줄 수 제한을 두지 않아 확대된 글자와 긴 문장을 표시할 수 있습니다.
동적으로 바뀌는 중요한 안내를 읽도록 요청하려면 `liveRegion: true`를 사용합니다.
모든 안내를 자동 알림으로 설정하지 않으며, 자동 포커스 이동은 수행하지 않습니다.
