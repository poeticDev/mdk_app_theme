# DI 독립성 확보 체크리스트

패키지를 "레고 블럭"처럼 제공하고, DI/상태관리 구성은 host 앱 책임으로 두기 위한 작업 목록입니다.

## 완료된 항목
- [x] get_it 의존성 제거 (2025-12-11)
- [x] ThemeRegistry in-memory 재설계 및 `ephemeral()` 제공 (2025-12-11)
- [x] 패키지 내부 Riverpod Provider 제거 (2025-12-11)
- [x] README·release·migration 문서에 DI-agnostic 철학 반영 (2025-12-11)
- [x] 순수 Stateful 예제 + Riverpod 예제 분리 제공 (2025-12-11)
- [x] 테스트를 순수 객체 기반으로 정비 (2025-12-11)

## 남은 항목
- [ ] `docs/theme_package_checklist.md`와 기타 문서에 남아 있는 legacy 문구 정리 (필요 시 추가 작업)
- [ ] CI(workflows)에서 golden/coverage 등을 연동해 release checklist 5단계를 완료
- [ ] 새 브랜드 토큰 샘플(highContrast 등)과 주석 템플릿 제공
- [ ] visual regression/golden pipeline 구축

필요 시 항목을 추가/세분화하여 진행 현황을 계속 추적하세요.
