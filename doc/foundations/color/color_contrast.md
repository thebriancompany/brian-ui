# 전경·배경 대비 측정

기본 테마의 sRGB 상대 휘도 비율입니다. 반투명 전경은 배경 위에 합성한 뒤 측정했습니다.
APCA 점수가 아니며, 모든 토큰 조합이나 완성된 UI의 접근성을 보장하지 않습니다.

| 전경 / 배경 | 라이트 | 다크 | 일반 텍스트 4.5:1 (라이트 / 다크) |
| --- | ---: | ---: | --- |
| `neutral` / `layerDefault` | 17.06:1 | 16.26:1 | 충족 / 충족 |
| `neutralMuted` / `layerDefault` | 6.62:1 | 13.31:1 | 충족 / 충족 |
| `neutralSubtle` / `layerDefault` | 3.42:1 | 8.53:1 | 미달 / 충족 |
| `placeholder` / `layerDefault` | 2.10:1 | 5.23:1 | 미달 / 충족 |
| `onBrandSolid` / `brandSolid` | 2.94:1 | 2.94:1 | 미달 / 미달 |
| `onBrandSolid` / `brandSolidPressed` | 3.99:1 | 2.03:1 | 미달 / 미달 |
| `brandContrast` / `brandWeak` | 3.64:1 | 5.10:1 | 미달 / 충족 |
| `onCriticalSolid` / `criticalSolid` | 3.76:1 | 3.82:1 | 미달 / 미달 |
| `criticalContrast` / `criticalWeak` | 8.05:1 | 9.83:1 | 충족 / 충족 |
| `onInformativeSolid` / `informativeSolid` | 3.95:1 | 3.85:1 | 미달 / 미달 |
| `informativeContrast` / `informativeWeak` | 8.37:1 | 9.91:1 | 충족 / 충족 |
| `onPositiveSolid` / `positiveSolid` | 3.96:1 | 5.39:1 | 미달 / 충족 |
| `positiveContrast` / `positiveWeak` | 8.30:1 | 10.10:1 | 충족 / 충족 |
| `onWarningSolid` / `warningSolid` | 10.80:1 | 7.93:1 | 충족 / 충족 |
| `warningContrast` / `warningWeak` | 9.61:1 | 9.85:1 | 충족 / 충족 |
| `onNeutralSolid` / `neutralSolid` | 13.31:1 | 16.26:1 | 충족 / 충족 |

## 포커스 링과 표면

| 윤곽선 / 배경 | 라이트 | 다크 | 3:1 (라이트 / 다크) |
| --- | ---: | ---: | --- |
| `stroke.focusRing` / `layerDefault` | 3.95:1 | 4.65:1 | 충족 / 충족 |
| `stroke.focusRing` / `layerBasement` | 3.59:1 | 5.45:1 | 충족 / 충족 |
| `stroke.focusRing` / `layerFloating` | 3.95:1 | 4.24:1 | 충족 / 충족 |

기본·떠 있는 표면의 눌림 상태도 두 모드에서 3:1 이상인지 테스트합니다.
다른 인접 색상이나 사용자 정의 테마, 포커스 표시의 면적·두께는 별도 검증 대상입니다.
