# 색상

Brian UI는 색상값과 사용 목적을 분리합니다. 화면을 만들 때는
`BrianTheme.of(context).colors`의 역할 색상을 먼저 선택합니다.
단계별 팔레트는 차트나 장식처럼 역할만으로 표현하기 어려운 경우에 사용합니다.

## 세 가지 속성

| 속성 | 용도 | 예시 |
| --- | --- | --- |
| `foreground` | 텍스트와 아이콘 | `neutral`, `criticalContrast` |
| `background` | 표면과 상태 배경 | `layerDefault`, `brandSolidPressed` |
| `stroke` | 외곽선과 구분선 | `neutralWeak`, `focusRing` |

역할은 `brand`(주요 행동), `neutral`(일반 콘텐츠), `positive`(성공),
`warning`(주의), `critical`(오류·위험), `informative`(정보)로 구분합니다.
같은 값이어도 역할이 다르면 별도 토큰으로 유지합니다.

`solid`는 강한 배경, `weak`는 약한 배경입니다. `contrast`는 의미 색상의
전경 대비를 강화한 변형이지만, 이름만으로 모든 배경에서 가독성을 보장하지 않습니다.
`muted`와 `subtle`은 해당 속성 안에서의 강조도 차이입니다.

## 표면과 상태

- `layerBasement`: 화면 전체의 가장 낮은 바탕.
- `layerDefault`: 일반 본문과 콘텐츠의 표면.
- `layerFloating`: 모달·팝업 등 떠 있는 콘텐츠의 표면.
- `overlay`: 모달 뒤 콘텐츠를 어둡게 가리는 반투명 색상.

라이트에서는 기본·떠 있는 표면이 같아도 다크에서는 다르게 구분됩니다.
레이어 색상은 그림자나 실제 위젯의 z 순서를 변경하지 않습니다.

`Pressed`는 누르는 동안, `Selected`는 선택 상태, `SelectedPressed`는
선택된 항목을 누르는 동안 사용합니다. `disabled`와 `placeholder`는 각각
비활성 요소와 입력 전 힌트에만 사용합니다. 본문을 흐리게 만드는 대체재가 아닙니다.

상태 색상은 값만 제공하며 이벤트 처리는 하지 않습니다. 컴포넌트에서
비활성 → 선택+눌림 → 눌림 → 선택 → 기본 순으로 상태를 해석하도록 권장합니다.
키보드 포커스는 별도 윤곽선으로 표현할 수 있습니다. hover와 focus의 최종
표면 정책은 해당 컴포넌트를 구현할 때 정하며, 기존 눌림 색상을 자동 재사용하지 않습니다.

## 팔레트

회색은 `step0`, `step100`부터 `step1000`까지, 유채색은 `step100`부터
`step1000`까지 제공합니다. 유채색은 `orange`, `blue`, `red`, `green`,
`yellow`, `purple`입니다. 단계는 Material shade나 고정 명도를 의미하지 않습니다.
다크 팔레트는 라이트 팔레트의 단순 역순이 아닙니다.

기본 `brand` 역할은 주황색에 연결되어 있습니다. 역할명은 특정 제품을
의미하지 않으며 테마 가이드(`doc/theming/overview.md`)로 원하는 색상 계열을 연결할 수 있습니다.
`BrianStaticColors`는 모드에 따라 변하지 않습니다. 적응형 `gray.step0`과
고정 `white`는 다르므로 사진 위 전경 등에서 의도에 맞게 선택합니다.
`banner`는 장식용 배경이며 오류·성공의 의미 전달에 사용하지 않습니다.

문서의 8자리 HEX는 `#RRGGBBAA`, Dart 생성자는 `Color(0xAARRGGBB)`입니다.
예를 들어 `#00000074`는 `Color(0x74000000)`입니다.

## 접근성 정책

팔레트와 기본 역할 매핑은 보존하고, 사용 위치별로 대비를 검증합니다.
색상 이름이나 전경·배경의 짝만으로 접근성을 충족한다고 판단하지 않습니다.

- 일반 텍스트의 전경·배경은 4.5:1 이상을 목표로 합니다.
- 큰 텍스트와 필수 UI 경계는 각각 적용되는 기준에 따라 3:1 이상을 검증합니다.
  Flutter의 logical pixel 값만으로 큰 텍스트 여부를 단정하지 않습니다.
- 반투명 색상은 실제 배경과 합성한 결과로 검증합니다.
- 오류·성공은 색상 외에도 텍스트나 아이콘으로 구분합니다.
- APCA와 WCAG 상대 휘도 비율은 다른 지표입니다. 현재 자동 테스트와
  측정표는 상대 휘도 비율만 검증하며 APCA 충족을 주장하지 않습니다.

기본 본문에는 `foreground.neutral` 또는 `neutralMuted`와 `layerDefault`를
사용할 수 있습니다. 성공·경고·오류·정보 안내는 `…Contrast`와 `…Weak` 조합을
우선 고려하되, 실제 사용하는 테마에서 다시 확인합니다.

주의: 기본 `onBrandSolid`/`brandSolid`는 두 모드 모두 약 2.94:1입니다.
일반 텍스트뿐 아니라 3:1 기준에도 미달하므로 이 조합을 버튼 글자로 그대로
사용하지 않습니다. 일부 다른 강한 상태 배경 위 흰색 글자도 4.5:1에 미달합니다.
라이트의 `brandContrast`/`brandWeak` 역시 약 3.64:1입니다.

브랜드 배경의 인상을 유지하면서 작은 글자를 올리려면 `brandSolid` 위에
고정 검은색 전경을 사용하는 사용자 정의를 고려할 수 있습니다(기본 배경에서
약 7.15:1). 이 경우 `onBrandSolid`도 함께 교체해 짝의 의미를 유지합니다.
배경이나 눌림 상태를 변경하면 해당 조합도 다시 검증해야 합니다.

`stroke.focusRing`은 기본 라이트·다크 테마의 `layerDefault`,
`layerBasement`, `layerFloating` 및 기본·떠 있는 표면의 눌림 상태에서
3:1 이상입니다. 다른 인접 배경과 사용자 정의 팔레트에서는 다시 검증합니다.

전체 대비 측정표(`doc/foundations/color/color_contrast.md`)는 제약을 드러내기 위한 자료입니다.
일반 본문·안내문 조합의 대비는 테스트로 보호하고, 기본 강조 조합의 제한도
테스트에 남겨 향후 컴포넌트에서 무심코 재사용하지 않도록 합니다.
색상을 바꾼 사용자 테마, 테마 전환 중간 프레임, 이미지 위 색상은 별도 검증 대상입니다.

기준 참고: [WCAG 텍스트 대비](https://www.w3.org/WAI/WCAG22/Understanding/contrast-minimum.html),
[비텍스트 대비](https://www.w3.org/WAI/WCAG22/Understanding/non-text-contrast.html).
