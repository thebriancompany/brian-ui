# 알림 다이얼로그

`BrianAlertDialog`는 사용자의 확인이나 선택이 필요한 상황에 사용합니다.
설명과 주요 액션은 필수이며, 제목과 보조 액션은 생략할 수 있습니다.
입력 폼이나 임의 콘텐츠를 담는 용도로 사용하지 않습니다.

## 표시하고 결과 받기

`BrianTheme`과 `Navigator` 아래의 context에서 호출합니다.
`showBrianAlertDialog<T>()`는 선택한 액션의 값을 `Future<T?>`로 반환합니다.
즉시 닫으려면 반환값을 받은 뒤 업무를 처리합니다.
완료까지 다이얼로그를 유지하려면 액션의 `onPressed`를 지정합니다.

```dart
final shouldDelete = await showBrianAlertDialog<bool>(
  context: context,
  title: '항목을 삭제할까요?',
  description: '삭제한 항목은 복구할 수 없습니다.',
  primaryAction: const BrianAlertDialogAction(
    label: '삭제',
    value: true,
    variant: BrianButtonVariant.criticalSolid,
  ),
  secondaryAction: const BrianAlertDialogAction(
    label: '취소',
    value: false,
    variant: BrianButtonVariant.neutralWeak,
  ),
);
if (shouldDelete == true) {
  // 삭제를 수행합니다. context를 다시 사용할 때는 mounted를 확인합니다.
}
```

단순 안내에서는 `secondaryAction`을 생략하고 주요 액션을 '확인'으로 제공합니다.
기본 버튼 표현은 `neutralSolid`입니다. 삭제처럼 되돌릴 수 없는 액션에만
`criticalSolid`를 지정하고 취소 버튼에는 경고 표현을 사용하지 않습니다.

## 액션 배치

- 한 개: 본문 안쪽 전체 너비를 채웁니다.
- 두 개: 간격 8 논리 픽셀을 두고 같은 너비로 가로 배치합니다.
- 어느 한쪽이라도 가로 배치에서 한 줄에 들어가지 않으면 둘 다 세로로 전환합니다.
- 명시적 줄바꿈, 번역, 현재 글꼴과 시스템 글자 확대를 판정에 반영합니다.
- 세로 배치에서도 긴 라벨은 여러 줄이 되고 버튼 높이가 늘어납니다. 말줄임하지 않습니다.

가로 순서는 읽기 방향 기준 보조→주요입니다. RTL에서는 보조 액션이 오른쪽에
놓입니다. 세로 순서는 위부터 주요→보조로 전환합니다.
버튼은 `BrianButton`의 medium 크기를 사용합니다.

## 닫기와 키보드

바깥 영역 탭, 시스템 뒤로가기, Esc로 닫히지 않습니다. 제공된 버튼을
탭하거나 포커스된 버튼에서 Enter·Space를 눌러 선택합니다. 사용자가 작업을
취소할 수 있어야 한다면 명시적인 취소 액션을 제공합니다.

처음에는 보조 액션에, 보조 액션이 없으면 주요 액션에 포커스를 둡니다.
Tab·Shift+Tab 탐색은 다이얼로그 안에서 순환하고, 닫으면 이전 포커스로
돌아갑니다. 파괴적 액션에는 보조 취소 액션을 함께 제공하는 것이 좋습니다.
닫기 애니메이션 중 중복 선택은 무시합니다.

앱 코드가 직접 `Navigator.pop`이나 라우트 제거를 호출하는 것까지 막지는
않습니다. 이런 경우 결과가 null일 수 있으므로 주요 동작은 명시적으로
해당 결과와 일치할 때 수행하세요.

## 크기·테마·접근성

최대 너비는 272 논리 픽셀이고, 안전 영역에서 좌우 최소 32, 상하 최소 64
논리 픽셀의 여백을 둡니다. 상하 안전 영역 중 큰 값을 양쪽에 적용하고
키보드가 차지한 영역을 제외해 가운데에 배치합니다. 가용 높이가 부족하면
제목·설명·버튼 전체를 스크롤할 수 있습니다.

표면은 `background.layerFloating`, 본문은 `foreground.neutral`, 바깥 영역은
`background.overlay`를 사용합니다. 라이트·다크 및 호출 위치의 지역 테마를
표시 시점에 캡처합니다. 열린 뒤 호출 위치의 테마를 바꾸면 자동으로
재캡처되지는 않습니다. 모션 감소 설정에서는 전환 애니메이션을 생략합니다.

제목이 있으면 제목을, 없으면 설명을 라우트의 접근성 이름으로 사용합니다.
버튼 라벨은 동작을 구체적으로 설명해야 합니다. 스크린리더와 극단적인 글자
확대의 실제 사용 경험은 대상 기기에서도 확인하세요.

## 본문만 구성하기

`BrianAlertDialog<T>`는 `onSelected`로 값을 전달하는 본문 위젯입니다.
직접 배치할 때는 유한한 너비·높이를 제공해야 합니다. 오버레이, 닫기 차단,
라우트 포커스 처리가 필요하면 `showBrianAlertDialog`를 사용합니다.

표시 함수는 기본적으로 최상위 Navigator를 사용합니다. 중첩 Navigator에
표시하려면 `useRootNavigator: false`를 지정합니다. 상태 복원은 지원하지 않습니다.


## 비동기 처리 후 닫기

액션의 `onPressed`에 비동기 작업을 지정하면 완료될 때까지 선택한 버튼에
로딩을 표시합니다. 다른 액션과 중복 입력은 잠기며, 작업이 성공한 뒤
선택한 값을 반환하고 닫힙니다. 확인과 취소에 각각 지정할 수 있습니다.

```dart
primaryAction: BrianAlertDialogAction(
  label: '확인',
  value: true,
  onPressed: () async {
    await Future<void>.delayed(const Duration(seconds: 3));
  },
),
```

실제 앱에서는 지연 대신 저장·전송 작업을 기다립니다. 작업이 실패하면
`FlutterError.reportError`로 오류를 보고하고 다이얼로그를 유지하며 다시
선택할 수 있게 합니다. 사용자가 읽을 오류 안내는 앱에서 처리하세요.
작업 중 라우트가 외부에서 닫히면 완료 시 다른 라우트를 닫지 않습니다.
본문 위젯을 직접 사용할 때도 작업 완료 후 `onSelected`가 호출됩니다.

문서 사이트는 기본, 버튼 2개, 긴 버튼 2개, 로딩 후 닫기, 브랜드 솔리드
사용 사례별로 설명·실행 예제·복사 가능한 코드를 제공합니다.
