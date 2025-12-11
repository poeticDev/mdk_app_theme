# DI 독립성 확보 체크리스트

패키지를 "레고 블럭"처럼 제공하고, DI 구성은 host 앱 책임으로 남기기 위한 단계별 가이드입니다. 각 항목을 완료하면 체크하세요.

- [x] **get_it 의존성 제거** (완료: 2025-12-11)
  - `pubspec.yaml`에서 `get_it`을 삭제했습니다.
  - ThemeRegistry가 자체적으로 의존성을 보관하도록 리팩터링해, 더 이상 외부 DI 컨테이너에 의존하지 않습니다.

- [x] **ThemeRegistry 재설계** (완료: 2025-12-11)
  - 단순 in-memory 컨테이너(`ThemeRegistry.ephemeral()`)로 축소했고, `registerAdapter`/`registerController`만 제공하도록 변경했습니다.
  - host 앱은 필요하면 자체 DI로 래핑할 수 있습니다.

- [x] **Riverpod 의존 제거** (완료: 2025-12-11)
  - 패키지 내부에서 Riverpod import와 Provider를 전부 삭제했습니다.
  - README/예제에서만 Riverpod 연동 예시를 보여주며, host 앱 커스터마이징을 강조합니다.

- [x] **README/문서 업데이트** (완료: 2025-12-11)
  - 설치/구성 섹션에 DI-agnostic 철학과 Riverpod 예시를 명시했습니다.
- [x] **예제 앱 개편** (완료: 2025-12-11)
  - 순수 Stateful 예제(`example/mdk_app_theme_example.dart`)와 Riverpod 예제(`example/riverpod_theme_example.dart`)를 분리 제공.
- [x] **테스트 정비** (완료: 2025-12-11)
  - 단위 테스트를 순수 객체 기반으로 유지하고, Riverpod 의존 테스트는 제거했습니다.
- [x] **체크리스트 & 릴리스 문서 동기화** (완료: 2025-12-11)
  - theme_package_checklist, release_workflow, migration 가이드에 DI-agnostic 정책을 반영했습니다.
- [x] **마이그레이션 가이드 보완** (완료: 2025-12-11)
  - host 앱 DI 책임 및 전환 절차를 `docs/theme_package_migration.md`에 업데이트했습니다.
- [x] **커뮤니케이션 정비** (완료: 2025-12-11)
  - README/문서/체크리스트에서 “DI/상태관리 host 앱 책임”을 강조했습니다.

- [ ] **예제 앱 개편**
  - 기본 예제는 순수 객체만으로 동작하는 최소 구성을 제공하고, 별도 섹션에서는 `flutter_riverpod`(v3 이상)을 활용해 테마 토글/브랜드 전환을 구현하는 방법을 보여줍니다.
  - 필요 시 get_it 등 다른 DI를 연결하는 방법은 README 하위 섹션이나 주석으로 안내합니다.

- [ ] **테스트 정비**
  - 단위/위젯 테스트는 순수 객체/팩토리만으로 동작하도록 리팩터링합니다.
  - Riverpod Provider 테스트는 별도 파일로 분리하고, host 앱 관점에서만 검증합니다.

- [ ] **체크리스트 & 릴리스 문서 동기화**
  - `docs/theme_package_checklist.md`에 DI-agnostic 리팩터링 항목을 추가하고 완료 시점/근거를 기록합니다.
  - `docs/release_workflow.md`, `docs/theme_package_migration.md`에도 "DI/상태관리는 host 앱 책임"임을 명시합니다.

- [ ] **마이그레이션 가이드 보완**
  - get_it/Riverpod 기반 기존 앱이 새 버전으로 옮길 때 필요한 단계/주의사항을 `docs/theme_package_migration.md`에 상세히 서술합니다.

- [ ] **커뮤니케이션 정비**
  - README/FAQ/CONTRIBUTING 등에서 "DI/상태 관리와 무관한 순수 구성" 방향을 강조해 사용자 기대치를 맞춥니다.
