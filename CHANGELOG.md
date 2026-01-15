# Changelog

모든 중요 변경 사항은 이 파일에 기록돼 SemVer 버전 규칙과 연동된다.

## [0.1.0-dev.1] - 2026-01-15

### Added
- ThemeController에 `getAppColors`/`getBrandList` API 추가.
- `ThemeBrandRegistry`에서 브랜드 목록 조회 지원.

### Changed
- `ThemeController` 기본 브랜드 추적을 위해 `initialBrand` 파라미터 도입.
- README의 현재 테마 색상 조회 예제를 `getAppColors` 기반으로 정리.

## [0.1.0] - 2025-12-11

### Added
- AdaptiveTheme + Riverpod 기반 ThemeController 및 상태 Provider.
- ThemeRegistry + getIt DI 전략과 ThemePlatformAdapter 추상화.
- ThemeBrandRegistry(기본/미드나이트) 및 브랜드 전환 예제.
- Pretendard Variable/ Paperlogy 폰트 자산과 `AppFontFamily` 전략.
- Theme utilities export, README/문서/테스트 세트.

### Notes
- 아직 정식 릴리스가 아니므로 `0.x` 버전이며, breaking change 가능성이 있다.
