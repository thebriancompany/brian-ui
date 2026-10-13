# Button Group

`BrianButtonGroup`은 하나 또는 두 개의 텍스트 버튼을 가용 너비에 맞춰 배치합니다.
다이얼로그, 바텀 시트의 푸터나 일반 화면의 액션 영역에서 함께 사용합니다.

```dart
BrianButtonGroup(
  primaryAction: BrianButtonGroupAction(
    label: '저장',
    onPressed: save,
  ),
  secondaryAction: BrianButtonGroupAction(
    label: '취소',
    onPressed: cancel,
  ),
)
```

## 기본 표현과 배치

- 주요 액션은 `neutralSolid`, 보조 액션은 `neutralWeak`입니다.
  액션의 `variant`로 개별 변경할 수 있습니다.
- `secondaryAction`을 생략하면 주요 버튼 하나가 전체 너비를 채웁니다.
- 두 버튼은 간격 8 논리 픽셀을 두고 같은 너비로 나란히 배치합니다.
- 어느 한쪽 라벨이 가로 배치에서 두 줄 이상이면 둘 다 세로로 전환합니다.
  글꼴, 글자 확대, 명시적 줄바꿈과 `size`의 패딩·타이포그래피를 반영합니다.
- 가로에서는 읽기 방향 기준 보조→주요, 세로에서는 위부터 주요→보조입니다.
- 긴 라벨을 자르거나 말줄임하지 않습니다. 세로 배치에서도 필요하면 여러 줄이 됩니다.

유한한 너비 안에 배치하세요. 기본 `size`는 `medium`이며 두 버튼에 함께 적용합니다.
아이콘이나 임의 위젯 대신 문자열 `label`을 받아 줄바꿈을 판정합니다.

## 실행과 상태

`onPressed: null`은 해당 버튼을 비활성화합니다. `isLoading: true`는 버튼의
크기를 유지하면서 진행 표시를 보여주고 해당 버튼의 실행을 막습니다.
그룹은 Future를 기다리거나 다른 버튼을 자동으로 잠그지 않습니다.
작업 중 모든 버튼을 막으려면 호출자가 각 액션의 상태를 전달합니다.

`autofocus`는 액션별로 지정하며 기본값은 false입니다. 둘 이상의 액션에 동시에
지정하지 않습니다. 가로·세로 배치의 시각적 순서로 키보드를 탐색합니다.

## 모달에 사용하기

Alert Dialog는 내부에서 이 그룹으로 액션을 배치하며 기존 선택·비동기 처리·포커스
정책을 유지합니다. Bottom Sheet는 `footerBuilder`에 그룹을 전달합니다.
그룹 자체는 모달을 닫지 않으므로 콜백에서 `Navigator.pop` 등을 호출합니다.
