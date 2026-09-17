---
id: "task_02_settings_bloc_theme_synchronization"
status: "done"
priority: "high"
assignee: null
epic: "system_theme_sync"
dueDate: null
created: "2026-09-17T22:25:00+07:00"
modified: "2026-09-17T15:34:44Z"
completedAt: "2026-09-17T15:34:44Z"
labels: ["settings", "bloc", "mvi", "presentation", "tdd"]
order: "a2"
---

# Task 02: SettingsBloc Frame-0 & Runtime Synchronization

## Context & Objectives
Update `SettingsBloc` in `features/settings/lib/presentation/settings/settings_bloc.dart`:
1. Ensure Frame-0 synchronous emission in `_onStarted` assigns `isDarkModeEnabled: ThemeManager.instance.isDarkMode`, accurately reflecting the system state on first launch.
2. Listen to `ThemeManager.instance.themeModeStream` so that if `!ThemeManager.instance.hasUserExplicitPreference` and the OS theme switches while Settings is open, the UI state automatically updates without page reload.
3. Validate `ToggleDarkModeUseCase` interactions when the user explicitly triggers `SettingsAction.toggleDarkMode`.
4. Update unit tests in `features/settings/test/presentation/settings/settings_bloc_test.dart` and `features/settings/test/domain/usecases/toggle_dark_mode_usecase_test.dart`.

---

## BDD Acceptance Criteria

```gherkin
Feature: SettingsBloc Theme Synchronization

  Scenario: SettingsBloc emits Frame-0 state with matching effective brightness
    Given ThemeManager.instance.isDarkMode is true
    When SettingsBloc receives SettingsAction.started()
    Then the emitted SettingsState has uiModel.isDarkModeEnabled equal to true
    And the transition occurs synchronously with zero network delays

  Scenario: User toggle action calls ToggleDarkModeUseCase and updates state
    Given SettingsBloc is initialized
    When SettingsBloc receives SettingsAction.toggleDarkMode(isEnabled: false)
    Then state.uiModel.isDarkModeEnabled is updated to false
    And ToggleDarkModeUseCase is invoked with isEnabled false

  Scenario: Runtime system theme change updates SettingsBloc state when not overridden
    Given SettingsBloc is initialized in system mode with no explicit user preference
    When ThemeManager emits a theme change with isDarkMode equal to false
    Then SettingsBloc updates state.uiModel.isDarkModeEnabled to false
```

---

## TDD Implementation Steps

### 1. QA Red Team (Test Authoring)
- Update `features/settings/test/presentation/settings/settings_bloc_test.dart`:
  - Add test verifying `isDarkModeEnabled` reflects `ThemeManager.isDarkMode` during `_onStarted`.
  - Add test verifying `onAction(SettingsAction.toggleDarkMode(isEnabled: true/false))` updates `SettingsUiModel`.
- Update `features/settings/test/domain/usecases/toggle_dark_mode_usecase_test.dart` to verify persistence and event publication.

### 2. TDD Master (Implementation)
- In `features/settings/lib/presentation/settings/settings_bloc.dart`:
  - In `_onStarted`, maintain Frame-0 emission:
    `isDarkModeEnabled: ThemeManager.instance.isDarkMode`
  - Add subscription to `_themeManager.themeModeStream`:
    ```dart
    on<SettingsActionThemeUpdated>((event, emit) {
      if (!ThemeManager.instance.hasUserExplicitPreference) {
        final currentModel = state.uiModel;
        if (currentModel != null) {
          emit(state.copyWith(uiModel: currentModel.copyWith(isDarkModeEnabled: ThemeManager.instance.isDarkMode)));
        }
      }
    });
    ```
- Verify `features/settings/lib/domain/usecases/toggle_dark_mode_usecase.dart`.

### 3. System Integration & Verification
- Run `fvm flutter test features/settings/test/presentation/settings/settings_bloc_test.dart`.
- Run `fvm flutter test features/settings/test/domain/usecases/toggle_dark_mode_usecase_test.dart`.
- Run `fvm flutter analyze features/settings`.

---

## Definition of Done (DoD)
- [ ] `SettingsBloc` initializes `isDarkModeEnabled` accurately on Frame 0.
- [ ] Runtime system brightness updates are reflected when user has not set an explicit override.
- [ ] All `features/settings` unit tests pass with zero regressions.
- [ ] Zero analyzer warnings or formatting issues.
