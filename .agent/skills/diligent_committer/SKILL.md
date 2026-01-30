---
name: diligent_committer
description: Generate consistent, descriptive commit messages based on staged changes.
---

# Diligent Committer Skill

This skill helps you generate commit messages that follow the project's established conventions.

## 1. 🕵️ Analyze Changes

- First, always run `git diff --cached` to see what is currently staged.
- If nothing is staged, ask the user what they want to commit, or suggesting running `git add`.
- Analyze the semantic meaning of the changes.

## 2. 📝 Commit Message Format

The project follows a specific variation of Conventional Commits:

`Type(Scope): Subject`

### Types

- **Feat**: New features (새로운 기능 추가)
- **Fix**: Bug fixes (버그 수정)
- **Doc**: Documentation changes (문서 수정)
- **Style**: Formatting, missing semi-colons, etc, no code change (코드 포맷팅 등)
- **Refactor**: Refactoring production code (코드 리팩토링)
- **Test**: Adding tests, refactoring test; no production code change (테스트 코드 추가)
- **Chore**: Build process, dependency updates (빌드, 패키지 매니저 설정 등)

### Rules

- **Capitalization**: The first letter of the `Type` MUST be capitalized. (e.g., `Feat`, `Fix`, not `feat`, `fix`).
- **Scope**: Optional. Use it if the change is specific to a module (e.g., `Feat(audio)`, `Fix(server)`).
- **Subject**:
  - Concise description of the change.
  - **Language**: Korean (한국어) is preferred based on project history, unless the user specifically asks for English.
  - Use imperative mood ("Add feature" not "Added feature" - though Korean naturally handles this differently, keep it concise).

## 3. 🚦 Workflow

1.  **Check Staged**: `git diff --cached`
2.  **Generate**: Draft a commit message following the format.
3.  **Propose**: Show the calculated diff summary and the proposed message to the user.
4.  **Confirm & Commit**: If the user approves, run `git commit -m "..."`.

## 4. Examples

- `Feat(audio): 오디오 장치 추가 및 UI 연동`
- `Fix: 노트북 오디오 채널 설정 오류 수정`
- `Doc: README.md 버전 업데이트`
- `Refactor(di): GetIt 의존성 일부를 Riverpod으로 이관`
