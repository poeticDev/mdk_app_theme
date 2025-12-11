# Contributing to mdk_app_theme

## Branch & Commit
- main에서 작업 브랜치를 생성합니다. 네이밍 예: `feat/theme-registry`, `fix/colors`, `docs/release-guide`.
- 커밋 메시지는 Conventional Commits(`feat:`, `fix:`, `docs:`, `chore:` 등)를 사용하세요.

## 개발 절차
1. `flutter pub get`
2. 코드 변경
3. `flutter analyze`
4. `flutter test`
5. 필요한 경우 `dart format .`

## 디자인 토큰/테마 변경 시 추가 요구 사항
- `.github/ISSUE_TEMPLATE/theme_change.md`를 통해 디자인 승인, golden 테스트 계획, 문서 업데이트 범위를 명시합니다.
- `docs/theme_package_checklist.md`와 `docs/development_guide.md`에 변경 사항을 기록합니다.
- 호스트 앱(web_dashboard)에서 smoke test를 실행해 AdaptiveTheme/브랜드 토글이 정상동작하는지 확인합니다.

## 릴리스
- `docs/release_workflow.md`를 따라 release 브랜치 생성 → QA → 태그 생성 → 배포까지 진행합니다.

감사합니다! 🙌
