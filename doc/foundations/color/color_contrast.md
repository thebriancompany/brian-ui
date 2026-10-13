# 전경·배경 대비 측정

기본 테마의 sRGB 상대 휘도 비율입니다. 반투명 전경은 배경 위에 합성한 뒤 측정했습니다.
APCA 점수가 아니며, 모든 토큰 조합이나 완성된 UI의 접근성을 보장하지 않습니다.

| 전경 / 배경 | 라이트 | 다크 | 일반 텍스트 4.5:1 (라이트 / 다크) |
| --- | ---: | ---: | --- |
| `neutral` / `layerDefault` | 17.06:1 | 16.26:1 | 충족 / 충족 |
| `neutralMuted` / `layerDefault` | 6.62:1 | 13.31:1 | 충족 / 충족 |
| `neutralSubtle` / `layerDefault` | 3.42:1 | 8.53:1 | 미달 / 충족 |
| `placeholder` / `layerDefault` | 2.10:1 | 5.23:1 | 미달 / 충족 |
| `onBrandSolid` / `brandSolid` | 5.92:1 | 7.76:1 | 충족 / 충족 |
| `onBrandSolid` / `brandSolidPressed` | 9.11:1 | 10.53:1 | 충족 / 충족 |
| `brandContrast` / `brandWeak` | 5.44:1 | 5.43:1 | 충족 / 충족 |
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

## 작은 상태 라벨용 배경

Badge의 solid 상태색은 다음 역할 조합을 사용합니다. 전경은 배경에 합성해 측정합니다.

| 전경 / 배경 | 라이트 | 다크 | 일반 텍스트 4.5:1 (라이트 / 다크) |
| --- | ---: | ---: | --- |
| `onInformativeSolid` / `informativeSolidContrast` | 5.92:1 | 5.45:1 | 충족 / 충족 |
| `onPositiveSolid` / `positiveSolidContrast` | 5.73:1 | 5.39:1 | 충족 / 충족 |
| `onCriticalSolid` / `criticalSolidContrast` | 5.68:1 | 5.58:1 | 충족 / 충족 |

위 역할은 끝점 색상끼리 보간합니다. 기본 테마 전환의 중간값도 테스트하며,
사용자 정의 조합과 다른 역할 조합의 전환 중 대비까지 보장하지 않습니다.
