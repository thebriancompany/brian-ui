# Scroll Fog

`BrianScrollFog`는 스크롤 영역의 가장자리를 표면색에서 투명으로 연결합니다.
스크롤 영역 위에 겹쳐 배치하는 장식으로, 스크롤 뷰나 컨트롤러를 만들지 않습니다.

## 방향과 깊이

| placement | 불투명한 가장자리 | 기본 깊이 |
| --- | --- | --- |
| top | 위 | 20px |
| bottom | 아래 | 80px |
| left | 왼쪽 | 20px |
| right | 오른쪽 | 20px |

단위는 논리 픽셀입니다. `extent`로 깊이를 조절할 수 있으며 유한한 0 이상의
값을 사용합니다. 좌우는 물리적 방향이므로 RTL이나 `reverse`에 따라 바뀌지
않습니다. 실제 가려지는 가장자리에 맞춰 배치하세요.

```dart
SizedBox(
  height: 240,
  child: Stack(
    children: [
      SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 80),
        child: Column(children: items),
      ),
      const Positioned.fill(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: BrianScrollFog(),
        ),
      ),
    ],
  ),
)
```

위·아래 Fog는 유한한 가로 공간, 좌·우 Fog는 유한한 세로 공간이 필요합니다.
`Positioned.fill`과 `Align`으로 감싸면 깊이도 뷰포트 크기 안으로 제한됩니다.
양쪽 경계에 적용하려면 Fog를 각각 배치하고 해당 방향 모두에 패딩을 둡니다.

## 표면색과 콘텐츠 여백

기본 색상은 `background.layerDefault`이며 라이트·다크 테마를 따릅니다.
다른 배경에서는 `color`에 실제 표면색을 전달하세요. 투명한 끝은 같은 색상의
알파만 0으로 바꾸므로 검은색이나 흰색 테두리가 끼지 않습니다.

Fog는 스크롤 시작·정지·끝 도달과 관계없이 항상 표시됩니다. 따라서 콘텐츠
안쪽에 Fog 깊이 이상의 패딩을 확보해야 마지막 항목을 가리지 않습니다.
짧은 콘텐츠에서도 패딩을 유지하며, Fog를 별도 여백으로 배치하지 않습니다.

## BottomSheet와 함께 사용하기

`BrianBottomSheet.footer` 또는 `showBrianBottomSheet`의 `footerBuilder`를
제공하면 본문 하단에 80px Fog와 80px 스크롤 패딩이 자동 적용됩니다.
헤더와 푸터는 고정되고 본문만 그라디언트 아래로 스크롤합니다.
푸터가 없으면 Fog와 추가 패딩을 넣지 않습니다.

## 상호작용과 접근성

Fog는 포인터 이벤트와 접근성 트리에서 제외됩니다. 아래 콘텐츠의 터치·드래그와
스크린 리더 탐색을 막지 않습니다. 스크롤 가능 여부를 전달하는 유일한 수단으로
사용하지 말고 스크롤 뷰의 기본 접근성 동작을 유지하세요. 중요한 텍스트와 액션은
끝까지 스크롤했을 때 Fog 바깥에서 읽고 조작할 수 있어야 합니다.
