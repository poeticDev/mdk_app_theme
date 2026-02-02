# v0.4.0 마이그레이션 가이드

`mdk_app_theme` 패키지의 0.4.0 버전은 Flutter의 Material 3 디자인 시스템 표준을 더 완벽하게 준수하기 위해 대규모 리팩토링이 진행되었습니다. 기존에 `AppColors` 클래스 하나로 모든 색상을 관리하던 방식에서, 표준 색상은 `ColorScheme`으로, 커스텀 색상은 `ThemeExtension`으로 분리하는 구조로 변경되었습니다.

이 문서는 기존 0.3.x 버전을 사용하던 프로젝트를 0.4.0 버전으로 업데이트하기 위한 가이드입니다.

---

## 1. 주요 변경 사항 (Core Concepts)

### 기존 구조 (legacy)

- `AppColors` 클래스가 `primary`, `secondary`, `surface` 등 모든 색상을 필드로 가지고 있었습니다.
- `AppTheme`가 `AppColors` 객체를 받아 내부적으로 `ColorScheme`을 생성하거나 직접 색상을 매핑했습니다.

### 새로운 구조 (New Structure)

- **`ColorScheme`**: `primary`, `secondary`, `surface`, `error` 등 Flutter 표준 색상은 `ColorScheme` 객체에 정의됩니다.
- **`AppColors (Extension)`**: `success`, `warning`, `surfaceElevated` 등 `ColorScheme`에 없는 커스텀(시맨틱) 색상만 `ThemeExtension<AppColors>`를 상속받은 `AppColors` 클래스에 남았습니다.
- **`ThemeBrandTokens`**: 각 브랜드(Default, Midnight, Orange Day 등)는 이제 `lightScheme`/`darkScheme` (표준 색상 셋)과 `lightExtension`/`darkExtension` (커스텀 색상 셋)을 분리하여 관리합니다.

---

## 2. 코드 마이그레이션 (Code Migration)

### 2.1 색상 접근 방법 변경

가장 큰 변화는 위젯에서 색상을 가져오는 방법입니다.

#### ❌ 기존 (v0.3.x)

```dart
// ThemeController 등을 통해 가져온 AppColors 인스턴스 사용
final AppColors colors = ThemeController.to.getAppColors(context);

Container(
  color: colors.primary, // 표준 색상 접근
  child: Text(
    'Success',
    style: TextStyle(color: colors.success), // 커스텀 색상 접근
  ),
);
```

#### ✅ 변경 (v0.4.0)

이제 표준 색상은 `Theme.of(context).colorScheme`를 통해, 커스텀 색상은 `Theme.of(context).extension`을 통해 접근해야 합니다.

```dart
final ThemeData theme = Theme.of(context);
final ColorScheme scheme = theme.colorScheme;
final AppColors? customColors = theme.extension<AppColors>();

Container(
  color: scheme.primary, // 표준 색상은 ColorScheme 사용
  child: Text(
    'Success',
    // 커스텀 색상은 Extension 사용. null check 필요
    style: TextStyle(color: customColors?.success ?? scheme.primary),
  ),
);
```

### 2.2 ThemeController 사용 시

`ThemeController`는 여전히 유효하지만, `getAppColors(context)` 메서드의 반환값은 이제 커스텀 색상만 담고 있는 `AppColors` Extension 인스턴스입니다.

```dart
// 여전히 사용 가능하지만, 반환된 객체에는 primary, surface 등이 없습니다.
final AppColors extension = themeController.getAppColors(context);

// 가능:
final Color success = extension.success;

// 불가능 (컴파일 에러):
// final Color primary = extension.primary;
// -> Theme.of(context).colorScheme.primary 를 대신 사용하세요.
```

### 2.3 팩토리 생성자 제거

`AppColors.light(brand)` 및 `AppColors.dark(brand)` 팩토리 생성자가 제거되었습니다. 만약 특정 브랜드의 색상 토큰 원본이 직접 필요하다면 `themeBrandRegistry`를 사용하세요.

```dart
// v0.4.0 에서 특정 브랜드의 토큰 접근
final ThemeBrandTokens tokens = themeBrandRegistry.tokensOf(ThemeBrand.midnight);

final ColorScheme lightScheme = tokens.lightScheme;
final AppColors lightCustomColors = tokens.lightExtension;
```

---

## 3. 필드 매핑 테이블 (Field Mapping)

| 기존 `AppColors` 필드 | 대체 접근 경로 (`Theme.of(context).colorScheme`) | 비고                                                  |
| :-------------------- | :----------------------------------------------- | :---------------------------------------------------- |
| `primary`             | `primary`                                        |                                                       |
| `primaryVariant`      | `primaryContainer`                               | Material 3 표준에 맞춰 `primaryContainer`로 매핑 권장 |
| `secondary`           | `secondary`                                      |                                                       |
| `surface`             | `surface`                                        |                                                       |
| `error`               | `error`                                          |                                                       |
| `textPrimary`         | `onSurface`                                      | 배경 위 주 텍스트는 `onSurface` 사용                  |
| `textSecondary`       | `onSurfaceVariant`                               | 배경 위 보조 텍스트는 `onSurfaceVariant` 사용         |
| `surfaceElevated`     | `extension<AppColors>()!.surfaceElevated`        | **커스텀 Extension 유지**                             |
| `success`             | `extension<AppColors>()!.success`                | **커스텀 Extension 유지**                             |
| `warning`             | `extension<AppColors>()!.warning`                | **커스텀 Extension 유지**                             |

---

## 4. 요약

1. 표준 색상(`primary` 등)은 `Theme.of(context).colorScheme` 사용.
2. 커스텀 색상(`success` 등)은 `Theme.of(context).extension<AppColors>()` 사용.
3. `textPrimary` -> `onSurface`, `textSecondary` -> `onSurfaceVariant` 로 개념 전환.

이 변경을 통해 `mdk_app_theme`는 Flutter 생태계의 표준 라이브러리 및 위젯들과 훨씬 더 자연스럽게 통합될 수 있습니다.
