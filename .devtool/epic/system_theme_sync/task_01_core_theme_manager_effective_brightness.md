---
id: "task_01_core_theme_manager_effective_brightness"
status: "done"
priority: "high"
assignee: null
epic: "system_theme_sync"
dueDate: null
created: "2026-09-17T22:25:00+07:00"
modified: "2026-09-17T15:29:03Z"
completedAt: "2026-09-17T15:29:03Z"
labels: ["core", "theme", "platform-brightness", "tdd"]
order: "a1"
---

# Task 01: Core ThemeManager Effective Brightness & Lifecycle

## Context & Objectives
Enhance `ThemeManager` in `packages/core/lib/services/theme_manager.dart` to support intelligent effective brightness detection and lifecycle synchronization:
1. Track whether the user has set an explicit theme preference via `_hasUserExplicitPreference`.
2. Evaluate `isDarkMode` dynamically: when `currentThemeMode == ThemeMode.system`, check `WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark`.
3. When `!_hasUserExplicitPreference`, attach a listener to `PlatformDispatcher.instance.onPlatformBrightnessChanged` so runtime OS theme switches notify `_themeModeSubject`.
4. Add a full test suite in `packages/core/test/services/theme_manager_test.dart` providing 100% coverage.

---

## BDD Acceptance Criteria

```gherkin
Feature: ThemeManager Effective Brightness & Lifecycle Management

  Scenario: First init without cached preference defaults to system and dynamic effective brightness
    Given SharedPreferences contains no 'app_theme_mode' entry
    And PlatformDispatcher platformBrightness is Brightness.dark
    When ThemeManager.instance.init() is called
    Then currentThemeMode is ThemeMode.system
    And hasUserExplicitPreference is false
    And isDarkMode evaluates to true

  Scenario: First init under Light Mode evaluates isDarkMode to false
    Given SharedPreferences contains no 'app_theme_mode' entry
    And PlatformDispatcher platformBrightness is Brightness.light
    When ThemeManager.instance.init() is called
    Then currentThemeMode is ThemeMode.system
    And hasUserExplicitPreference is false
    And isDarkMode evaluates to false

  Scenario: Calling setThemeMode marks explicit preference and persists to disk
    Given ThemeManager has initialized in ThemeMode.system
    When ThemeManager.instance.setThemeMode(ThemeMode.dark) is called
    Then currentThemeMode becomes ThemeMode.dark
    And hasUserExplicitPreference becomes true
    And SharedPreferences stores 'app_theme_mode' as 2

  Scenario: System brightness changes notify themeModeStream when not overridden
    Given ThemeManager is in ThemeMode.system with hasUserExplicitPreference false
    When PlatformDispatcher.onPlatformBrightnessChanged fires
    Then themeModeStream emits ThemeMode.system
```

---

## TDD Implementation Steps

### 1. QA Red Team (Test Authoring)
- Create `packages/core/test/services/theme_manager_test.dart`.
- Mock `SharedPreferences` via `SharedPreferences.setMockInitialValues({...})`.
- Write unit tests covering all 4 BDD scenarios, verifying initial state, effective brightness calculation, and persistence.

### 2. TDD Master (Implementation)
- Modify `packages/core/lib/services/theme_manager.dart`:
  - Add `bool _hasUserExplicitPreference = false;`.
  - Expose getter `bool get hasUserExplicitPreference => _hasUserExplicitPreference;`.
  - Update `bool get isDarkMode` to check `platformBrightness` when `currentThemeMode == ThemeMode.system`.
  - In `init()`:
    - If `prefs.getInt(_themeKey) != null`, set `_hasUserExplicitPreference = true`.
    - If `null`, attach listener to `PlatformDispatcher.instance.onPlatformBrightnessChanged`.
  - In `setThemeMode(ThemeMode mode)`:
    - Persist to `_themeKey`.
    - Set `_hasUserExplicitPreference = true`.
    - Emit `mode` to `_themeModeSubject`.

### 3. System Integration & Verification
- Run `fvm flutter test packages/core/test/services/theme_manager_test.dart`.
- Verify `packages/core` analyzer report is clean: `fvm flutter analyze packages/core`.

---

## Definition of Done (DoD)
- [ ] `ThemeManager` correctly evaluates effective brightness for `ThemeMode.system`.
- [ ] `hasUserExplicitPreference` accurately differentiates between initial state and user override.
- [ ] 100% unit test pass rate in `packages/core/test/services/theme_manager_test.dart`.
- [ ] Zero analyzer warnings or formatting issues.
