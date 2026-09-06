---
id: "task_11_language_race_condition"
status: "done"
priority: "high"
assignee: null
epic: "settings-bugfixes"
dueDate: null
created: "2026-09-01T17:34:00Z"
modified: "2026-09-01T17:47:30Z"
completedAt: "2026-09-01T17:47:30Z"
labels: ["architecture", "feature"]
order: "a11"
---

# Task 11: Fix Language Race Condition

Epic: [Settings Bugfixes](../epic/settings_bugfixes/settings_bugfixes.en.md)

## Requirement Analysis
The language change functionality suffers from race conditions and chaotic optimistic UI updates. When a user selects a language that has not been cached yet, the UI immediately switches to that locale (showing fallbacks/empty strings) while the API fetches the translation. Additionally, rapid language switching causes parallel API fetches that overwrite the current locale when they complete out of order.

We need to implement **State-aware Optimistic UI** and **Cancellation check**:
1. Create `CheckLanguageCachedUseCase` to check if a language is default ('en', 'vi') or cached.
2. In `SettingsBloc._onChangeLanguage`:
   - If cached -> switch locale immediately, fetch in background.
   - If NOT cached -> emit loading, fetch, and only switch locale if the user hasn't selected another language in the meantime.

## Relevant Files & Context Pointers
- `packages/settings/lib/domain/usecases/check_language_cached_usecase.dart` (New file)
- `packages/settings/lib/presentation/settings/settings_bloc.dart`
- `packages/settings/test/presentation/settings/settings_bloc_test.dart`

## Design Rationale
We track `_pendingLanguageCode` in `SettingsBloc` to cancel out-of-order API responses. We use a new UseCase to determine if we can safely apply Optimistic UI.

## TDD Checklist
- [ ] **RED**: Write failing tests (Unit) in `settings_bloc_test.dart` for rapid language switching scenarios and loading state verification.
- [ ] **GREEN**: Implement `CheckLanguageCachedUseCase` and update `SettingsBloc` to pass the tests.
- [ ] **REFACTOR**: Clean up code.

## Definition of Done (DoD)
- Tests pass.
- No UI glitches when rapidly clicking different languages.
- Uncached languages show loading state before switching.

## Dependencies & Blockers
None.

## References & Rollback
- Revert changes to `SettingsBloc` if behavior breaks.
