# 버튼

`BrianButton`은 액션을 실행하는 독립 버튼입니다. `BrianTheme` 아래에서 사용하며
Material·Cupertino 컴포넌트에 의존하지 않습니다.

```dart
BrianButton(
  variant: BrianButtonVariant.neutralSolid,
  size: BrianButtonSize.large,
  onPressed: isValid ? submit : null,
  isLoading: isSubmitting,
  child: const Text('저장하기'),
)
```

## Variant

| 값 | 사용 | 배경 / 전경 |
| --- | --- | --- |
| brandSolid | 브랜드 의미가 중요한 핵심 액션 | brandSolid / onBrandSolid |
| neutralSolid | 기본값, 일반적인 주요 액션 | neutralSolid / onNeutralSolid |
| neutralWeak | 일반·보조 액션 | neutralWeak / neutral |
| brandOutline | 브랜드 보조 액션 | transparent / brand |
| neutralOutline | 중립 보조 액션 | transparent / neutral |
| criticalSolid | 삭제 등 위험 액션 | criticalSolid / onCriticalSolid |
| ghost | 배경 없는 보조 액션 | transparent / neutral |

일반 버튼과 아이콘 버튼의 기본값은 neutralSolid입니다. 브랜드 강조가 필요한
액션에만 brandSolid를 명시하며, 기본 테마에서는 파란색 배경에
라이트는 흰색, 다크는 검은색 전경을 사용합니다. 두 outline 모두 `stroke.neutralMuted`를 사용합니다.
누르거나 포인터를 올리면 해당 배경의 Pressed 색상을 사용합니다.
비활성화 시 전경은 `foreground.disabled`, solid·weak 배경은
`background.disabled`이며 outline·ghost는 투명 배경을 유지합니다.
라이트·다크와 사용자 정의 색상은 가장 가까운 BrianTheme에서 가져옵니다.

## Size와 레이아웃

| 값 | 최소 높이 | 좌우 / 상하 패딩 | 글꼴 | 모서리 |
| --- | --- | --- | --- | --- |
| xsmall | 32 | 14 / 6 | t3Bold | 캡슐 |
| small | 36 | 14 / 8 | t4Bold | 8 |
| medium | 40 | 16 / 10 | t4Bold | 8 |
| large | 52 | 20 / 14 | t6Bold | 12 |

수치는 논리 픽셀이고 기본값은 medium입니다. 아이콘 전용 버튼은 좌우에도 상하
패딩을 적용합니다. 최소 너비는 각 크기의 최소 높이와 같습니다.
높이를 고정하지 않으므로 글자 확대나 긴 라벨에서 줄바꿈하며 높이가 늘어납니다.
부모가 높이를 강하게 제한하면 콘텐츠가 넘칠 수 있습니다.

기본 너비는 콘텐츠에 맞춥니다. 전체 너비는 유한한 너비의 부모 아래에서
`SizedBox(width: double.infinity, child: BrianButton(...))`로 지정하고,
Row 안에서는 `Expanded` 등 부모 레이아웃으로 비율을 정합니다.

`leading` 또는 `trailing`에 아이콘 위젯을 전달할 수 있으며 동시에 지정하지 않습니다.
방향은 Directionality를 따릅니다. 아이콘에는 IconTheme, 라벨에는
DefaultTextStyle을 적용합니다. 라벨의 크기·굵기·색상은 버튼 스타일을 따르고,
글꼴은 상위 DefaultTextStyle에서 상속합니다. 테마나 자식에 직접 지정한
글꼴·스타일은 해당 속성을 덮어쓸 수 있습니다.
자식에는 별도의 버튼·링크 같은 상호작용 컨트롤을 넣지 않습니다.

```dart
BrianButton.icon(
  onPressed: close,
  semanticLabel: '닫기',
  icon: closeIcon,
)
```

## 상태와 상호작용

- `onPressed: null`은 비활성화이며 실행과 키보드 포커스 이동 대상에서 제외합니다.
- `isLoading: true`이면 진행 표시를 보여주고 중복 실행을 막습니다.
  onPressed도 null인 경우 로딩 표현이 우선합니다.
- 로딩은 자식의 레이아웃과 접근성 라벨을 유지합니다. 처리 여부는 호출부에서
  관리하며 Future를 자동으로 기다리지 않습니다.
- 로딩 배경은 solid·weak·ghost에서 Pressed 색상, outline에서는 투명입니다.
- Tab으로 포커스를 이동하고 Enter·Space로 실행합니다. 키 반복 실행은 막습니다.
  키보드는 키를 누를 때 실행하며 키를 놓으면 눌림 표현을 해제합니다.
- 키보드 포커스에는 버튼 바깥에 2픽셀 간격을 두고 `stroke.focusRing`
  2픽셀 테두리를 표시합니다. 레이아웃 크기는 유지하므로 부모는 바깥 4픽셀이
  잘리거나 인접 콘텐츠에 가려지지 않도록 여유를 둡니다.
- 누르는 동안 시각적 크기를 97%로 줄이며 100ms 동안 전환합니다.
  레이아웃과 터치 영역의 크기는 유지합니다.
- 배경·전경·테두리 색상은 150ms 동안 전환하며 두 전환 모두 easeOutCubic을 사용합니다.
- 모션 감소 설정에서는 축소를 생략하고 색상을 즉시 적용하며 진행 표시의 회전을 멈춥니다.

## 접근성

버튼 역할과 활성 상태를 semantics로 제공합니다. 아이콘 전용 생성자에는
동작을 설명하는 semanticLabel이 필요합니다. 일반 버튼에서 semanticLabel을
지정하면 자식의 설명을 대체합니다. 로딩 중에는 기존 라벨과 함께 loadingLabel을
live region으로 제공하며 기본 설명은 '처리 중'입니다. 다국어 앱은 해당 값을 번역합니다.

시각적 크기와 터치 영역은 같습니다. 작은 size를 터치 화면에 사용할 때는
주변 간격과 플랫폼별 터치 영역 요구를 함께 검토합니다. 사용자 정의 테마와
outline·ghost의 실제 합성 배경에서는 전경 대비를 별도로 확인해야 합니다.
기본 neutralSolid는 라이트·다크의 기본·눌림 상태에서 전경 대비가 4.5:1 이상입니다.
기본 brandSolid도 두 모드의 기본·눌림 상태에서 4.5:1 이상입니다.
브랜드 색상을 사용자 정의하면 전경·배경과 눌림 상태를 함께 검증합니다.
전체 측정값은
`doc/foundations/color/color_contrast.md`에서 확인합니다.
포커스 링은 기본 layer 표면에서 3:1 이상이며, 다른 인접 배경에서는 다시 검증합니다.
자동 테스트는 상태·입력·semantics·글자 확대를 검사하며 스크린 리더의 실제
발화나 모든 플랫폼의 접근성 충족을 보장하지 않습니다.

