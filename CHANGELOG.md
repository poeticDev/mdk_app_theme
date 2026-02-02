# Changelog

## [0.4.1] - 2026-02-02

### Changed

- **Brand Colors**: 각 브랜드의 색상 가시성과 조화를 개선했습니다.
  - **Default Brand**: `secondary`를 Slate Blue (`0xFF5A5D72`)로 변경하여 `primary`와 구분하고, `tertiary`로 Coral (`0xFFEF5350`)을 추가했습니다.
  - **Midnight Brand**: `tertiary`로 Golden Amber (`0xFFFFAB00`)를 추가하여 포인트를 주었습니다.
  - **Orange Day Brand**: `tertiary`로 Mustard/Sand (`0xFF6C5D00`)를 추가하여 자연스러운 조화를 유도했습니다.

## [0.4.0] - 2026-02-02

### Breaking Changes

- **Core Architecture**: `AppColors`가 더 이상 모든 색상 토큰을 담지 않고, `ThemeExtension`으로 변경되었습니다.
  - `primary`, `secondary`, `surface`, `error` 등 표준 색상은 Flutter의 `ColorScheme`으로 이관되었습니다.
  - `AppColors.light()` 및 `AppColors.dark()` 팩토리 생성자가 제거되었습니다.
  - `AppTheme`의 `_buildColorScheme` 메서드가 제거되었습니다.

### Added

- **Semantic Colors**: `AppColors`는 이제 `success`, `warning`, `surfaceElevated`와 같은 커스텀 시맨틱 색상만 관리합니다.
- **ThemeExtension Support**: `AppTheme`가 `ColorScheme`과 `Extension`을 조합하여 더욱 유연하게 `ThemeData`를 생성하도록 개선되었습니다.
- **ThemeBrandTokens**: `ThemeBrandTokens` 구조가 `lightScheme`/`darkScheme` (표준) 및 `lightExtension`/`darkExtension` (커스텀)으로 분리되었습니다.

### Migration

- 기존에 `AppColors`의 필드(예: `colors.primary`)를 직접 사용하던 코드는 `Theme.of(context).colorScheme.primary`로 변경해야 합니다.
- 커스텀 색상(예: `colors.success`)은 `Theme.of(context).extension<AppColors>()!.success`로 접근해야 합니다.
- 자세한 내용은 `docs/migration_v0_4_0.md` 문서를 참고하세요.

### Changed

- **Midnight Brand**: 'Deep Navy' 배경 틴트와 부드러운 블루 프라이머리(HCT Tone 6/80)를 적용하여 다크 모드 심미성 개선.
- **Orange Day Brand**: **시각적 정체성 수정**. 프라이머리 색상을 Blue에서 Terracotta Orange로 변경하고, 배경색을 Warm Cream으로 교체하여 따뜻한 톤 구축.

### Added

- **Theme Showroom**: 컴포넌트 갤러리 및 컬러 팔레트 뷰를 포함한 종합 쇼룸 형태로 예제 앱 업그레이드.
- **Design Methodology**: HCT 색 공간 및 토날 팔레트 방법론을 담은 `docs/theme_design_guide.md` 추가.

## [0.2.0] - 2026-01-30

### Breaking Changes

- **Token System**: `AppColors` 생성자에 `secondary` 필드가 필수(`required`)로 추가되었습니다.
- **Midnight Brand**: Primary 색상이 `0xFF0098D8` (Sky Blue)로 변경되었습니다.

### Added

- **New Brand**: `Orange Day` 브랜드가 추가되었습니다. (Primary: Blue, Secondary: Orange)
- **Token System**: `secondary` 색상 토큰이 추가되었습니다.

## [0.1.0] - 2024-03-21

- 최초 배포 (Initial release).
