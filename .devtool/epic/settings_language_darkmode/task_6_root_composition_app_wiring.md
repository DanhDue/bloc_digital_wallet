---
id: "task_6_root_composition_app_wiring"
status: "done"
priority: "high"
assignee: null
epic: "settings_language_darkmode"
dueDate: null
created: "2026-09-06T02:37:10+07:00"
modified: "2026-09-07T00:00:20+07:00"
completedAt: "2026-09-07T00:00:20+07:00"
labels: ["architecture", "feature"]
order: "a6"
---

# Task 6: Root Composition & App-Wide Wiring Verification

Epic: [settings_language_darkmode](../epic/settings_language_darkmode/settings_language_darkmode.en.md)

## Requirement Analysis
Integrate and verify the entire Settings, Dark Mode, and Localization feature in the application root composition:
1. Root Theme Observation:
   - In `lib/main.dart`, observe `ThemeManager.instance.themeModeStream`.
   - Pass `currentThemeMode` to `MaterialApp.router(themeMode: currentThemeMode)`.
   - Configure light theme with `AppThemes.light` and dark theme with `AppThemes.dark`.
2. App-wide Dynamic Localization & Seamless Recomposition:
   - Observe `LocalizationManager.instance.localeStream` in `lib/main.dart`.
   - Wrap the application tree with `MultiTranslationProvider(providers: appTranslationProviders)`.
   - Ensure dynamic language changes update UI smoothly without tearing down the routing or navigation tree.
3. Architecture Gate & Code Quality:
   - Run root composition tests verifying reactive updates to theme mode and locale.
   - Run `melos run analyze` across the entire workspace with 0 issues.
   - Run test suite across packages and features.

## Relevant Files & Context Pointers
- `lib/main.dart`
- `lib/core/localization/multi_translation_provider.dart`
- `packages/core/lib/services/theme_manager.dart`
- `packages/core/lib/localization/localization_manager.dart`
- `test/root_composition_test.dart`

## Design Rationale & Refinements
- The composition root (`lib/main.dart`) brings all packaged modules and features together.
- `StreamBuilder<ThemeMode>` and `StreamBuilder<Locale>` observe platform state streams without tight coupling to features.
- No root navigation destruction: `MultiTranslationProvider` propagates locale changes directly down the widget tree without rebuilding `AppRouter`.
- Frame-0 cold start: `ThemeManager.instance.init()` and `AppInitializer.init()` run before `runApp()`, using `initialData` for seamless initial rendering.

### BDD SCENARIOS

```gherkin
Feature: Root Composition Theme and Localization Wiring
  As the digital wallet super app
  I want the root MaterialApp to reactively observe ThemeManager and LocalizationManager
  So that changing theme mode and language dynamically updates the app UI seamlessly without tearing down the widget tree

  Scenario: Root reacts to ThemeManager theme mode updates
    Given the root app is launched with initial theme mode
    When ThemeManager emits ThemeMode.dark
    Then MaterialApp updates themeMode to ThemeMode.dark

  Scenario: Root reacts to LocalizationManager locale updates
    Given the root app is launched with initial locale
    When LocalizationManager emits Locale('vi')
    Then MaterialApp updates locale to Locale('vi')
```

## TDD Checklist
- [x] **RED**: Write integration test `test/root_composition_test.dart` verifying reactive stream wiring of theme mode and locale.
- [x] **GREEN**: Ensure `lib/main.dart` stream builders and `MultiTranslationProvider` react cleanly to stream events.
- [x] **REFACTOR**: Verify `melos run analyze` (0 issues) and full test suite across workspace.

## Definition of Done (DoD)
- Root composition tests pass 100%.
- `melos run analyze` passes with 0 issues across the monorepo.
- Monorepo tests run cleanly.
- No root key destruction or navigation resets during theme or language changes.

## Dependencies & Blockers
- Blocked by [Task 5](task_5_settings_card_ui_language_bottom_sheet.md)

## References & Rollback
- Epic HLD: [settings_language_darkmode.en.md](../epic/settings_language_darkmode/settings_language_darkmode.en.md)
- Rollback: Revert `lib/main.dart` and `test/root_composition_test.dart`.
