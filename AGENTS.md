# Repository Guidelines (mdk_app_theme)

## Project Structure & Modules
- `lib/mdk_app_theme.dart`: 패키지 단일 export 진입점. 반드시 하나의 export만 유지한다.
- `lib/src/`: 실 구현. tokens/controller/widgets/constants/adapters/brands 폴더 구조를 유지하고 part로 연결한다.
- `assets/font/`: Pretendard Variable 기본 폰트를 포함하며, 다른 폰트를 추가할 때도 여기서 관리한다.
- `example/`: 최소 예제 및 사용법. AdaptiveTheme 적용 샘플을 제공하고, README에서 참조한다.
- `test/`: `lib/src` 구조를 반영한 단위·위젯 테스트. 공개 API 파일마다 대응 테스트를 둔다.
- `docs/`: 패키지 개발 체크리스트·가이드 문서. 변경 시 README와 동기화한다.

## Build, Test, and Development
- `flutter pub get`: 의존성/폰트 자산 동기화.
- `flutter test`: 단위/위젯 테스트 실행.
- `flutter analyze`: 린트 검사. 코드 생성물은 최소화하고 필요 시 `dart run build_runner build --delete-conflicting-outputs`를 사용한다.
- 릴리스 전 `dart format .`으로 일관된 포맷을 유지한다.

## Coding Style & Naming
- Dart 3.x, 들여쓰기 2칸. 모든 변수·파라미터·반환 타입 명시.
- 파일: `snake_case.dart`; 클래스: PascalCase; 멤버/함수: camelCase; 불리언: 동사형(`isActive`).
- 매직 넘버 금지 → `lib/src/constants/`에서 의미 있는 상수로 정의.
- 함수 길이 20줄 이내를 권장하고 단일 책임 원칙을 지킨다.
- part 파일 내에서도 `const` 생성자 우선, 불변 데이터 우선.

## Testing Guidelines
- AAA(Arrange-Act-Assert) 패턴과 명확한 변수명(`inputX`, `expectedX`).
- `AppTheme`/컨트롤러/위젯 등 공개 API마다 대응 테스트를 작성한다.
- Riverpod/AdaptiveTheme 관련 테스트는 가능한 mock adapter를 도입해 deterministic하게 유지한다.
- 커버리지 목표 80% 이상을 유지하고, 릴리스 후보는 `flutter test --coverage`로 확인한다.

## Release & Versioning
- 기본 버전 규칙: SemVer (`major.minor.patch`). Breaking change 발생 시 major를 올린다.
- `CHANGELOG.md`에 사용자 영향(신규 API, breaking change, 버그 수정)을 요약한다.
- peer dependency(`adaptive_theme`, `flutter_riverpod`) 업데이트 시 README와 docs를 동기화한다.

## Documentation
- README에는 설치, peer dependency 버전, 예제, 확장 포인트(getIt, ThemeRegistry, font override)를 명시한다.
- `docs/`에는 패키지 체크리스트, 마이그레이션 가이드, 디자인 토큰 설명을 저장한다.
- 외부 앱이 참조해야 하는 추가 자료는 `/Users/poeticdev/workspace/web_dashboard/docs` 경로 문서를 링크한다.

## Security & Config
- 비공개 키/토큰은 저장하지 않는다. 폰트/디자인 자산만 포함한다.
- `build/` 산출물, `.dart_tool/`, `.fvm/`, `pubspec.lock`(패키지에서는 유지) 외 파일은 커밋하지 않는다.

## Communication Principles
- 사용자/동료 지원 시 한국어로 응답하고, 요구사항이 불명확하면 먼저 질문해 명확히 한다.
- 결정 사항은 체크리스트나 docs에 기록해 팀이 추적할 수 있도록 한다.

## Reference Docs
- `/Users/poeticdev/workspace/web_dashboard/docs/theme_package_checklist.md`: 상위 앱에서 정의한 패키지 전환 절차.
- `/Users/poeticdev/workspace/web_dashboard/docs/theme_design.md`: 테마 설계 철학 및 토큰 정책.
