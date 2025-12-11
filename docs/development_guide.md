# mdk_app_theme Development Guide

## 필수 작업 흐름
1. `docs/theme_package_checklist.md`(web_dashboard repo)와 이 문서를 동시에 업데이트한다.
2. 새 기능을 추가할 때는 `example/`에 사용 예시를 추가하고, README의 "다음 단계" 섹션을 갱신한다.
3. AdaptiveTheme 추상화(ThemePlatformAdapter)와 ThemeRegistry 정립은 4단계 체크리스트의 최우선 과제다.

## Adapter/Registry TODO
- [x] `lib/src/adapters/theme_platform_adapter.dart` 생성: AdaptiveThemeManager 호출을 래핑하고, 테스트 시 mock으로 교체 가능하게 만든다. (2025-12-11)
- [x] `lib/src/controller/theme_controller.dart`가 직접 `AdaptiveTheme.of`를 호출하지 않고 adapter에 의존하도록 수정한다. (2025-12-11)
- [x] `ThemeRegistry` + getIt 연동을 도입해 adapter/controller 싱글톤을 관리하고 Provider override 전략을 정의한다. (2025-12-11)
- [x] `lib/src/brands/` 하위에 브랜드별 토큰 모듈(`default_brand_tokens.dart`, `brand_registry.dart`)을 분리한다. (2025-12-11)
- [x] README에 adapter 사용법과 getIt 통합 예제를 추가한다. (2025-12-11)
- [x] Riverpod 상태를 `StateNotifierProvider`로 래핑해 ThemeController 상태(모드/브랜드)를 노출한다. (2025-12-11)
- [x] `lib/theme_utilities.dart` 단일 export 파일을 추가해 공개 API를 큐레이션한다. (2025-12-11)
- [x] `docs/theme_package_migration.md`를 작성해 web_dashboard → 패키지 전환 절차를 문서화한다. (2025-12-11)
- [x] Pretendard Variable + Paperlogy 정적 폰트 전략을 `AppFontFamily` 인터페이스로 지원한다. (2025-12-11)

## 샘플 앱 TODO
- [x] AdaptiveTheme + Riverpod + ThemeToggle 예제(`example/mdk_app_theme_example.dart`) 작성. (2025-12-11)
- [x] 브랜드 전환/ThemeRegistry 연동 예제를 example에 추가한다. (2025-12-11)

## 테스트 & CI 체크리스트
- [ ] adapter mock 테스트, controller 상태 전이 테스트 작성.
- [ ] golden/golden-lite 테스트 도입 가능성 조사.
- [ ] GitHub Actions(workflows/ci.yaml) 작성: `flutter analyze`, `flutter test --coverage`.

## 참고 링크
- 상위 앱 저장소: `/Users/poeticdev/workspace/web_dashboard`
- 디자인 토큰 문서: `/Users/poeticdev/workspace/web_dashboard/docs/theme_design.md`
- 패키지 계획: `/Users/poeticdev/workspace/web_dashboard/docs/theme_package_checklist.md`
