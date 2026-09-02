---
epic: "settings-bugfixes"
status: "done"
completedAt: "2026-09-01T12:49:48Z"
---

# Task 12: Refactor Language Sync Orchestration

## Problem Statement
`SettingsBloc` currently handles too much orchestration for language changing (checking cache, optimistic UI setting, calling API, setting locale, handling race conditions, calling update user preferences). This leaks Application Business Logic into the Presentation Layer. 

## Technical Requirements
- Create a new `ChangeLanguageUseCase` (Facade Use Case) in `packages/settings/lib/domain/usecases/`.
  - **Same Language check:** If the requested language is already the current active language, skip `setLocaleFromCode` and skip `UpdateUserLanguageUseCase` to avoid redundant logs and backend calls. Just call `GetDynamicLocalizationUseCase` to silently check for delta updates.
  - Check cache (if changing language).
  - Apply optimistic UI (yield Loading or Success/Cached state).
  - Fetch dynamic translation from `GetDynamicLocalizationUseCase`.
  - Update user backend preferences via `UpdateUserLanguageUseCase` (only if changing language).
- Use a `Stream` or multiple callbacks so the Bloc can react to intermediate states (e.g., `LanguageSyncStatus.loading`, `LanguageSyncStatus.cachedApplied`, `LanguageSyncStatus.success`, `LanguageSyncStatus.error`).
- Update `SettingsBloc` to only listen to this Use Case and map its emitted statuses to UI states.
- Ensure the race condition fix from Task 11 (`_pendingLanguageCode`) is either preserved in the Bloc or moved safely into the Use Case.

## Dependencies
- Must run after Task 11 (`task_11_language_race_condition.md`).

## Validation
- `SettingsBloc` tests must be updated and pass.
- `ChangeLanguageUseCase` must have its own unit tests.
