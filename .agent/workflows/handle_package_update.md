---
description: 패키지 수정 요청 처리 (디자인/설계/구현 관점 분석 및 테스트 포함)
---

1. **요구사항 접수 및 관점별 분석 (Reception & Perspective Analysis)**
   - **Request Manager** (`.agent/skills/request_manager/SKILL.md`): `docs/EXTERNAL_REQUESTS.md`를 확인하여 처리할 요청(Pending)을 식별하고 상태를 '진행중'으로 업데이트합니다.
   - 식별된 요청에 대해 다음 4가지 **Skill**을 로드하여 `implementation_plan.md`를 작성합니다.
     - **Design Reviewer** (`.agent/skills/design_reviewer/SKILL.md`): 기존 디자인 토큰/브랜드와의 일관성, 네이밍 적합성 확인.
     - **Client Advocate** (`.agent/skills/client_advocate/SKILL.md`): 태블릿, 키오스크, 웹앱 등 소비 앱에서의 사용성 예측 및 마이그레이션 난이도 분석.
     - **Package Architect** (`.agent/skills/package_architect/SKILL.md`): Breaking Change 감지, 버전 전략(SemVer) 수립, 파일 구조 영향도 파악.
     - **Safe Coder** (`.agent/skills/safe_coder/SKILL.md`): 실제 수정 대상 파일(`lib/**/*.dart`) 및 구체적 구현 로직 식별.

2. **계획 수립 및 리뷰 요청 (Plan & Review)**
   - 위 5가지(Manager + 4 Perspectives) 관점을 종합하여 계획을 수립합니다.
   - **Critical**: Breaking Change가 있거나 클라이언트 앱 수정이 필수적인 경우, 이를 명확히 강조합니다.
   - `notify_user`를 통해 승인을 받습니다.

3. **구현 및 문서화 (Implementation & Documentation)**
   - 코드 변경 사항을 적용합니다.
   - 워크플로우 내에서 `CHANGELOG.md` 업데이트를 **강제**합니다.
   - 필요시 마이그레이션 가이드(주석 또는 문서)를 작성합니다.

4. **검증 (Verification)**
   - **정적 분석**: `flutter analyze`
   - **로직 테스트**: `flutter test`
   - **시각적 검증 (Visual QA)**: `example` 앱을 실행하거나 관련 위젯 테스트를 통해 디자인 토큰 적용 결과가 의도한 대로 나오는지 확인합니다. (가능한 경우 스크린샷 캡처)

5. **보고 (Reporting)**
   - `walkthrough.md`에 결과를 정리합니다:
     - 변경 요약 및 버전 추천
     - 클라이언트 앱 개발자를 위한 **Update Guide** 포함
   - **Request Manager**: `docs/EXTERNAL_REQUESTS.md`의 상태를 '완료'로 업데이트하고 배포 버전을 기록합니다.
