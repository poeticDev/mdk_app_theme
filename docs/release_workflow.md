# Release Workflow

## Branching & Versioning

- `main`: 항상 최신 개발 상태 유지.
- `release/x.y.z`: 릴리스 후보 브랜치. main에서 분기 후 QA/문서 마무리.
- 버전 규칙: SemVer. Breaking change 시 `x`, 호환 기능 추가 시 `y`, 버그 수정/문서 업데이트는 `z`.
- 태그: `vX.Y.Z` 형태. 태그 생성 시 CHANGELOG 항목을 해당 버전에 맞춰 고정.

## 릴리스 절차

1. main 최신 상태를 기준으로 `release/x.y.z` 브랜치를 만든다.
2. `CHANGELOG.md`에 새 섹션을 추가하고 README/문서를 최신화한다.
3. `flutter test`, `flutter analyze`, `dart format --output=none --set-exit-if-changed .`를 실행한다.
4. 상위 앱(web_dashboard)에서 `mdk_app_theme`를 git path dependency로 참조하여 로컬 검증(Smoke Test)을 수행한다.
5. 문제가 없으면 release 브랜치를 main에 merge한다.
6. GitHub Actions 탭에서 `Publish Release` 워크플로우를 실행하거나, GitHub CLI를 사용하여 릴리스를 배포한다.

   ```bash
   # pubspec.yaml 버전을 기준으로 릴리스 생성
   gh workflow run main_release.yaml

   # 특정 버전을 지정하여 릴리스 생성 (선택 사항)
   gh workflow run main_release.yaml -f version=1.0.0
   ```

   이 액션은 자동으로 태그(`vX.Y.Z`)를 생성하고 GitHub Release를 배포한다.

## Smoke Test 체크리스트

- ThemeToggle이 라이트/다크 전환을 수행하는지 확인.
- 브랜드 드롭다운(Default ↔ Midnight) 동작 및 ColorScheme 적용 확인.
- Pretendard/Paperlogy 폰트 선택 시 UI가 올바르게 렌더링되는지 확인.
- Host 앱의 DI/상태 관리 계층(예: get_it, Riverpod, Provider 등)에 `ThemeController`가 기대 방식으로 주입되는지 확인.

## Issue & Contribution 가이드

- `.github/ISSUE_TEMPLATE/theme_change.md`를 사용해 토큰/테마 변경 요청 시 디자인 승인·테스트 계획을 명시한다.
- `CONTRIBUTING.md`에 기여자 절차(브랜치 네이밍, 테스트 명령, 문서 업데이트)를 기록한다.

## Visual Regression / Golden Tests

- 초기 릴리스 이후 `test/golden/` 경로에 golden 스냅샷을 추가하고, GitHub Actions에서 `flutter test --update-goldens`/`flutter test`를 병행 실행한다.
- 디자인 변경 시 issue 템플릿에서 golden 업데이트 필요 여부를 체크하도록 한다.
