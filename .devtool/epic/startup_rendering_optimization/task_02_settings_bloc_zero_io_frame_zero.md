---
id: "task_02_settings_bloc_zero_io_frame_zero"
status: "todo"
priority: "high"
assignee: null
epic: "startup_rendering_optimization"
dueDate: null
created: "2026-09-17T18:00:00+07:00"
modified: "2026-09-17T18:00:00+07:00"
completedAt: null
labels: ["settings", "bloc", "non-blocking", "frame-zero"]
order: "a2"
---

# Task 02: Zero-I/O Frame-0 for SettingsBloc

## Context & Objectives
Refactor `SettingsBloc._onStarted` in `features/settings/lib/presentation/settings/settings_bloc.dart` so that `SettingsStatus.success` with an initial `SettingsUiModel` is emitted synchronously on Frame 0 using bundled defaults. Defer `_appInfoService.getPackageInfo()` (Platform Channel) and `_bootstrapUseCase()` (HTTP API request) to background execution so they never delay initial rendering or FCP.

---

## BDD Acceptance Criteria

```gherkin
Feature: SettingsBloc Frame-0 Instant Render

  Scenario: Synchronous Frame-0 state emission
    Given SettingsBloc is initialized
    When SettingsAction.started() is dispatched
    Then SettingsBloc should emit SettingsStatus.success synchronously
    And the initialUiModel should be populated with bundled defaults
    And no platform channel or network calls should block the event loop

  Scenario: Background execution updates UI silently
    Given SettingsBloc has emitted the Frame-0 state
    When the deferred package info and bootstrap call completes
    Then SettingsBloc should emit an updated SettingsUiModel
    And the new version and dynamic languages should be reflected

  Scenario: Network resilience during background sync
    Given SettingsBloc background bootstrap fails with a network exception
    When the error occurs
    Then the exception should be caught silently
    And the previously emitted state should remain valid without crashing
```

---

## TDD Implementation Steps

### 1. QA Red Team (Test Authoring)
- Update `features/settings/test/presentation/settings/settings_bloc_test.dart`:
  - Assert that on `SettingsAction.started()`, the first emitted state has `status: SettingsStatus.success`.
  - Verify that subsequent background emission updates `appVersion` and `availableLanguages`.
  - Add test verifying that if `_bootstrapUseCase()` fails, no exception is thrown and state remains `SettingsStatus.success`.

### 2. TDD Master (Implementation)
- Refactor `SettingsBloc._onStarted`:
  - Synchronously build and emit `initialUiModel` using bundled fallback values.
  - Wrap `_appInfoService.getPackageInfo()` and `_bootstrapUseCase()` in an unawaited helper method `_runBackgroundSync(emit)`.
  - Ensure `if (!isClosed)` checks are respected when updating state post-sync.

### 3. System Integration & Verification
- Run `fvm flutter test features/settings/test/presentation/settings/settings_bloc_test.dart`.
- Run `fvm flutter analyze features/settings`.
- Ensure zero errors and zero warnings.

---

## Definition of Done (DoD)
- [ ] Frame-0 state emission executes synchronously.
- [ ] Background sync runs detached without blocking UI.
- [ ] 100% unit tests passing in `features/settings`.
