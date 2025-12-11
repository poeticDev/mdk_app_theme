# Theme Package Migration Guide

이 문서는 기존 `web_dashboard` 앱의 `lib/theme/*` 구현을 `mdk_app_theme` 패키지로 이전할 때 따라야 할 절차를 정리한 것이다. Version: 2025-12-11.

## 1. 사전 준비
- `web_dashboard` 최신 main 브랜치에서 작업 브랜치(`feat/theme-package`)를 생성한다.
- `mdk_app_theme` 저장소를 git submodule 또는 sibling 디렉터리로 clone 한다.
  - 예: `git clone git@github.com:poeticDev/mdk_app_theme.git ../mdk_app_theme`
- `pubspec.yaml`에 git 또는 path dependency를 추가하고 `flutter pub get`으로 동기화한다.

```yaml
dependencies:
  mdk_app_theme:
    git:
      url: git@github.com:poeticDev/mdk_app_theme.git
      ref: main   # 혹은 release 태그
# (로컬 연동이 필요하면 path: ../mdk_app_theme 로 교체)
```

- 앱 진입점에서 `ThemeRegistry`를 초기화하고, 기존 AdaptiveTheme bootstrap 코드를 README 섹션 2~4 단계와 동일하게 교체한다.

## 2. ThemeController 연동
1. `ThemeRegistry.instance`에 맞춰 getIt DI 등록 함수를 정리한다.
2. 기존 `ThemeController` 싱글톤/Provider 정의를 제거하고 `themeRegistryProvider` override를 사용하는 ProviderScope를 구성한다.
3. 기존 위젯에서 사용하는 `ThemeController` 접근 코드를 `themeControllerProvider` 혹은 `themeControllerStateProvider`로 교체한다.

## 3. 위젯/토큰 교체
- `AppTheme`, `AppColors`, `AppTypography`, `ThemeToggle`를 직접 import하던 경로를 `package:mdk_app_theme/theme_utilities.dart`로 통일한다.
- Pretendard Variable 폰트를 더 이상 앱에서 중복 포함하지 않도록 `pubspec.yaml`의 폰트 asset 항목을 정리한다.
- 브랜드 확장이 필요한 경우 `mdk_app_theme/lib/src/brands` 구조를 참조해 새로운 `ThemeBrandTokens`를 정의한 뒤 PR로 upstream에 반영한다.

## 4. 테스트 & 검증
- AdaptiveTheme 연동이 제대로 작동하는지 example 앱을 참고해 smoke test를 진행한다.
- `flutter test`와 기존 golden test를 모두 실행해 회귀가 없는지 확인한다.
- `themeControllerStateProvider`를 사용하는 화면은 widget test에서 ProviderContainer를 override하여 deterministic하게 검증한다.

## 5. 배포 체크리스트
- README/앱 내 개발 문서에 패키지 버전, 설치 방법, 확장 전략을 명시한다.
- `docs/theme_package_checklist.md`와 `docs/release_workflow.md` 항목을 최신 상태로 동기화하고, 마이그레이션 진행도(브랜치, 커밋 SHA)를 기록한다.
- 릴리스 노트(CHANGELOG)에는 패키지 전환으로 인한 breaking change, API 사용법, 필요한 smoke 테스트를 명시한다.
- 릴리스 브랜치(`release/x.y.z`)를 생성하고, 상위 앱에서 git dependency를 통해 smoke test 후 태그(`vX.Y.Z`)를 생성한다.
