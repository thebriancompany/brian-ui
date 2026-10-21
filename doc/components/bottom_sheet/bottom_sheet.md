# Bottom Sheet

화면 아래에서 선택지나 추가 정보를 보여줍니다. 콘텐츠가 짧으면 필요한 높이만
사용하고, 길면 헤더와 푸터를 고정한 채 콘텐츠만 스크롤합니다.
화면의 안전 영역과 키보드를 제외한 높이 안에서 표시합니다.
넓은 화면에서는 기본 최대 너비 640 논리 픽셀로 가운데 정렬합니다.

## 사용하기

```dart
final result = await showBrianBottomSheet<String>(
  context: context,
  semanticLabel: '정렬 순서',
  headerBuilder: (context) => const Text('정렬 순서'),
  footerBuilder: (context) => BrianButtonGroup(
    primaryAction: BrianButtonGroupAction(
      label: '확인',
      onPressed: () => Navigator.of(context).pop(),
    ),
  ),
  builder: (context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      for (final label in ['추천순', '최신순', '낮은 가격순'])
        BrianButton(
          onPressed: () => Navigator.of(context).pop(label),
          child: Text(label),
        ),
    ],
  ),
);
```

`headerBuilder`와 `footerBuilder`는 선택적 고정 영역이고 `builder`는 스크롤할
콘텐츠입니다. 헤더·푸터는 남은 화면 안에 들어가는 간결한 내용으로 구성합니다.
둘 다 생략하면 콘텐츠만 표시합니다. 각 builder의 context로 시트를 닫을 수 있습니다.

시트가 세로 스크롤을 관리하므로 builder에는 Column 등 일반 콘텐츠를 전달합니다.
중첩된 세로 ListView·SingleChildScrollView나 Expanded는 사용하지 않습니다.
모든 자식을 한 번에 배치하므로 대량 데이터를 지연 생성하는 목록 용도는 아닙니다.

## 푸터 버튼

`footerBuilder`에 `BrianButtonGroup`을 전달하면 단일 버튼은 기본 neutralSolid로
전체 너비를 채웁니다. `secondaryAction`을 추가하면 보조 neutralWeak와 주요
neutralSolid 버튼을 같은 너비로 나란히 배치합니다. 어느 라벨이든 한 줄에 들어가지
않으면 주요→보조 순서의 세로 배치로 바뀝니다. 푸터는 배치 방향과 관계없이 고정됩니다.
버튼 동작과 로딩 상태는 호출자가 관리하며, 임의 푸터 위젯도 계속 사용할 수 있습니다.

## 스크롤과 닫기

- `showHandle`은 핸들 표시만 제어합니다. 기본값은 true입니다.
- `enableDrag`의 기본값은 true입니다. 핸들·헤더·본문·푸터·여백을 아래로 드래그할 수 있습니다.
- 내부 콘텐츠가 스크롤되어 있으면 먼저 맨 위로 이동합니다. 같은 드래그에서 남은
  거리는 시트 이동으로 이어지며, 방향을 되돌리면 시트 복귀 후 콘텐츠가 스크롤됩니다.
- 헤더·푸터·여백에서 드래그하면 본문 위치는 바뀌지 않습니다. 본문이 최상단일 때만
  시트가 움직입니다. 본문이 내려가 있다면 본문에서 먼저 위로 돌아오세요.
- 시트 높이의 25% 넘게 내리거나 아래로 빠르게 놓으면 닫힙니다. 짧은 드래그는 복귀합니다.
- 마우스 드래그도 지원합니다. 휠 스크롤은 콘텐츠만 움직입니다.
- 배경 탭으로 닫기만 막으려면 `barrierDismissible: false`를 사용합니다.
  드래그 닫기도 막으려면 `enableDrag: false`를 함께 지정합니다.
  두 옵션은 Esc·시스템 뒤로가기를 막지 않습니다.
- Esc·시스템 뒤로가기로 닫을 수 있습니다. 드래그를 끄는 경우에도 닫기 버튼을 제공합니다.

## 테마와 접근성

호출 위치의 BrianTheme을 모달에 전달하며 라이트·다크의 표면·전경·경계 역할 색상을
사용합니다. `semanticLabel`에는 시트의 목적을 적습니다. 포커스는 모달로 이동하고
키보드 탐색은 모달 안에서 순환합니다. 운영체제의 동작 줄이기 설정에서는
진입·복귀 애니메이션 시간을 없앱니다. 핸들만을 유일한 닫기 수단으로 삼지 않습니다.

모달 없이 표면만 필요하면 유한한 높이 제약 안에 `BrianBottomSheet`를 배치합니다.
`header`·`footer`는 고정되고 `child`만 스크롤됩니다.
`onDismiss`가 없으면 드래그 닫기가 꺼집니다.

## 고정 푸터와 Scroll Fog

푸터가 있으면 본문 하단에 80px Scroll Fog를 겹쳐 배치합니다. 본문 끝에도
80px 패딩이 있어 마지막 항목을 끝까지 읽을 수 있습니다. Fog는 스크롤 상태와
관계없이 유지되며, 짧은 본문에서는 패딩 위에 놓입니다. 푸터가 없으면 이 Fog와
추가 패딩은 적용하지 않습니다. 헤더·푸터의 고정과 드래그 닫기 동작은 유지됩니다.

## 내부 스타일 사용자 정의

`BrianThemeData.bottomSheet`의 `BrianBottomSheetStyle`로 `maxWidth`,
방향성 `padding`, `sectionGap`, `borderRadius`를 지정합니다.
생략한 필드는 기존 너비 640과 테마의 간격·모서리 토큰을 사용합니다.
`sectionGap`은 핸들 아래와 헤더 아래의 간격입니다.
