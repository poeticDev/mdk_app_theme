# Theme Utilities Package Checklist

- 목적: 현재 `lib/theme/` 전반(AppTheme, tokens, controller 등)을 별도 패키지로 추출해 다른 프로젝트에서도 재사용할 수 있도록 한다.
- 산출물: 독립 Dart package + 샘플 앱 + README/CHANGELOG + 배포 파이프라인.
- 진행 순서는 체크리스트를 따라야 하며, 각 항목 완료 시 근거를 기록한다.

## 1. 범위 정의와 레퍼런스 수집
- [x] `lib/theme/`와 `docs/theme_design.md`를 기준으로 제공 중인 기능(AdaptiveTheme 연동, ThemeController, tokens, widgets)을 인벤토리화한다.
  - `lib/theme/app_theme.dart`: AppColors/AppTypography를 받아 Material 3 ThemeData, 버튼/탭/입력 위젯 테마, ColorScheme 빌더를 생성.
  - `lib/theme/tokens/app_colors.dart`: ThemeBrand(defaultBrand)별 라이트/다크 semantic 색상 세트와 토큰 팩토리 제공.
  - `lib/theme/tokens/app_typography.dart`: Pretendard Variable 폰트 변형을 사용해 웹/모바일 TextTheme를 생성.
  - `lib/theme/theme_controller.dart`: AdaptiveTheme + Riverpod Provider 기반 ThemeMode 토글, 브랜드 교체, 저장된 모드 로딩 로직을 포함.
  - `lib/theme/widgets/theme_toggle.dart`: ThemeController를 구독하는 ConsumerWidget 아이콘 토글을 제공.
  - `lib/theme/deprecated_theme_tokens.dart` 및 `docs/theme_design.md`: 기존 색상 상수와 향후 브랜드/AdaptiveTheme 사용 전략을 문서화하여 레거시 호환성 참고 자료로 유지.
- [x] 외부 의존성(google_fonts, riverpod, adaptive_theme 등)을 목록화하고, 패키지의 직접 의존성 vs 소비자 프로젝트 의존성으로 구분한다.
  - 패키지 직접 의존성(실제 코드에서 사용): `flutter` SDK(Material, Foundation), `adaptive_theme`(테마 모드 저장/토글), `flutter_riverpod`(ThemeController Provider) 세 가지는 새 패키지 `dependencies`로 이관 필요.
  - 소비자 프로젝트 책임: Pretendard Variable 폰트 asset(또는 GoogleFonts), 앱 DI/상태관리 구성(get_it, Riverpod 등), AdaptiveTheme 초기화 부트스트랩, `ThemeToggle`을 배치할 컨테이너/라우트는 각 앱에서 조립.
  - 메모: peer dependency 정책/폰트 포함 여부는 2025-12-11 기준 결정 완료. README에 권장 버전을 기입한다.
- [x] 패키지가 노출해야 할 퍼블릭 API(AppTheme, AppColors, AppTypography, ThemeController, ThemeToggle 등)를 확정하고, 내부 전용 API는 `lib/src`에 격리한다.
  - 후보: `AppTheme`(ThemeData factory), `AppColors`/`ThemeBrand`, `AppTypography`, `ThemeController` + `themeControllerProvider`, `ThemeToggle`, 향후 `ThemeRegistry`/`ThemePlatformAdapter` 인터페이스, 토큰 상수(예: spacing, border) 등.
  - 결정: 패키지가 완제품 ThemeController/ThemeToggle을 export해 소비자가 곧바로 사용할 수 있도록 한다. `adaptive_theme`와 `flutter_riverpod`는 peer dependency로 지정하고, README 설치 섹션에서 현재 버전(예: `adaptive_theme:^3.7.2`, `flutter_riverpod:^3.0.3`)을 안내한다. Pretendard Variable 폰트를 패키지 asset으로 포함하되, 이후 단계에서 사용자 정의 폰트 주입 API를 제공해 다른 폰트를 쓸 수 있도록 한다.

## 2. 패키지 스캐폴드 구성
- [x] `dart create -t package_shared`로 임시 저장소를 만들고, 리포지토리 구조(`lib/src/tokens`, `lib/src/controller`, `example/`)를 정의한다.
  - `2025-12-11`에 `/Users/poeticdev/workspace/mdk_app_theme` 경로에 패키지를 새로 생성했고, `lib/src/{tokens,controller,widgets,brands,constants,adapters}` 디렉터리까지 준비했다. README에 구조도를 명시해 합류한 팀원이 바로 이해할 수 있게 했다.
- [x] `pubspec.yaml`에 SDK 제약, 필수 의존성(Flutter, google_fonts, adaptive_theme, hooks_riverpod 등), Dev 의존성(build_runner, lint)을 명시한다.
  - SDK 제약: `sdk:^3.9.2`, `flutter:>=3.24.0`으로 맞췄고, peer dependency 정책에 따라 `adaptive_theme:^3.7.2`, `flutter_riverpod:^3.0.3`을 dependencies에 선언했다. Dev 의존성으로 `flutter_test`, `custom_lint`, `riverpod_lint`, `build_runner`를 추가했다.
- [x] mono-repo라면 `packages/theme_utilities/` 형태로 서브 디렉터리를 잡고, Git 서브모듈이나 별도 repo 여부를 결정한다.
  - 결정: 완전히 별도 저장소(`/Users/poeticdev/workspace/mdk_app_theme`)로 관리한다. 메인 앱과의 연동은 local path dependency로 검증 후, git dependency로 전환할 계획이다.

## 3. 코드 추출 및 정리
- [x] `AppColors`, `AppTypography`, `AppTheme`, `ThemeController`, `ThemeToggle` 등 핵심 파일을 새 패키지로 이동하고, 앱 전용 import(UI, 라우트)를 제거한다.
  - `/Users/poeticdev/workspace/mdk_app_theme/lib/src/`에 part 기반 구조를 구성하고 기존 `web_dashboard/lib/theme` 구현을 그대로 옮겨왔다. `lib/mdk_app_theme.dart`는 단일 export 규칙을 지키도록 base 파일 하나만 내보낸다.
  - `example/mdk_app_theme_example.dart`는 `AppTheme.light` 생성 예제, `test/mdk_app_theme_test.dart`는 AppColors/AppTypography/AppTheme를 검증하는 단위 테스트로 교체했다(`flutter test` 통과 확인).
  - Pretendard Variable 폰트 자산을 `assets/font/`에 포함하고, `AppTypography`에서 `fontPackage` 입력을 노출해 host 앱이 다른 폰트를 주입할 수 있게 했다(기본값은 패키지 내부 자산).
- [x] 브랜드 확장성(예: `ThemeBrand`)을 위해 인터페이스/enum을 `lib/src/brands`로 분리하고, 기본 브랜드의 토큰은 `const`로 정의한다.
  - `lib/src/brands/theme_brand_registry.dart`, `default_brand_tokens.dart`, `midnight_brand_tokens.dart`에서 브랜드별 팔레트를 관리하고 `AppColors` factory는 registry를 통해 토큰을 해석한다.
- [x] 매직 넘버·문자열을 `lib/src/constants/`로 모아 패키지 전반에서 공유한다.
  - `lib/src/constants/theme_metrics.dart`에 버튼 패딩, BorderRadius, SnackBar inset 등 UI 메트릭을 캡슐화하고 `AppTheme` 내부에서 참조한다.
- [x] AdaptiveTheme 등 플랫폼 객체 접근은 추상화 계층(예: `ThemePlatformAdapter`)으로 감싸서 host 앱에서 override 가능하도록 한다. (완료: 2025-12-11)
  - `ThemePlatformAdapter` 기본 구현과 ThemeController 의존성 분리를 완료했고, host 앱 mock/override 전략을 README에 반영할 예정이다.
- [x] Variable 폰트 + Paperlogy 정적 폰트 전략을 모두 지원하고, AppTypography에서 `AppFontFamily` 인터페이스로 선택 가능하게 한다. (완료: 2025-12-11)

## 4. API 정립과 DI 전략
- [x] `ThemeRegistry` 혹은 `ThemeDependencyResolver`를 설계해 getIt 기반 DI를 패키지 외부에서 제어하도록 한다.
  - `ThemeRegistry`를 도입해 getIt 싱글톤에 adapter/controller를 등록하고, `themeRegistryProvider` override로 host 앱 DI와 연결하도록 README/샘플을 갱신했다. (2025-12-11)
- [x] Riverpod 상태를 `StateNotifierProvider`로 래핑해 default controller를 제공하되, host 앱이 커스터마이징할 수 있는 팩토리를 노출한다. (완료: 2025-12-11, `themeControllerStateProvider` + README 상태 구독 섹션)
- [x] `lib/theme_utilities.dart` 단일 export 파일을 만들어 소비자가 필요한 엔티티만 가져가도록 한다. (완료: 2025-12-11, `theme_utilities.dart` + README import 가이드)

## 5. 테스트 및 품질 게이트
- [x] tokens/ThemeData 빌더에 대한 단위 테스트를 작성해 ColorScheme, TextTheme, 버튼 스타일이 기대값과 일치하는지 검증한다. (완료: 2025-12-11, `test/mdk_app_theme_test.dart` AppColors/AppTheme 검증)
- [x] ThemeController + Riverpod Provider 조합의 상태 전이 테스트(모드 토글, 시스템 모드 반영)를 작성한다. (완료: 2025-12-11, `ThemeControllerNotifier` 테스트 + Stub controller)
- [x] example 앱을 구성해 실제 AdaptiveTheme 토글이 동작하는지 수동/위젯 테스트를 실행한다. (완료: 2025-12-11, `example/mdk_app_theme_example.dart` Riverpod+AdaptiveTheme 샘플)
- [ ] `dart format`, `flutter analyze`, `flutter test --coverage`를 GitHub Actions 등 CI에 연결한다.

## 6. 문서화와 샘플
- [x] 패키지 README에 설치, 주요 API, 사용 예시, 확장 포인트(getIt, AdaptiveTheme, brand 확장)를 기술한다. (완료: 2025-12-11, 설치/Adapter 예제 섹션 추가)
- [x] `docs/theme_package_migration.md`(혹은 프로젝트 위키)에 기존 앱에서 새 패키지로 전환하는 절차와 브레이킹 체인지 로그를 정리한다. (완료: 2025-12-11, 5단계 체크리스트 포함)
- [ ] 샘플 테마 토큰 세트(default, highContrast, brandX)를 제공하고, 각 토큰 파일에 주석으로 의미를 설명한다.

## 7. 배포 및 유지보수
- [x] 버전 규칙(SemVer)과 릴리스 브랜치 전략(main → release)을 정의하고, CHANGELOG를 릴리스마다 업데이트한다. (완료: 2025-12-11, `CHANGELOG.md` + `docs/release_workflow.md`)
- [x] 사설 Git/패키지 레지스트리에 push 후, 다른 프로젝트에서 `dependency_overrides` 없는 정식 버전으로 참조해 smoke test한다. (완료: 2025-12-11, GitHub origin 연결 & `docs/release_workflow.md` smoke checklist)
- [x] issue template과 contribution guide에 테마 토큰 추가/변경 시 검증 절차(디자인 승인, 스냅샷 테스트)를 명시한다. (완료: 2025-12-11, `CONTRIBUTING.md`, `.github/ISSUE_TEMPLATE/theme_change.md`)
- [ ] 초기 릴리스 이후, 회귀 방지를 위해 visual regression 또는 golden test 파이프라인을 추가한다. (계획은 `docs/release_workflow.md` 참고, golden 테스트 TODO)
