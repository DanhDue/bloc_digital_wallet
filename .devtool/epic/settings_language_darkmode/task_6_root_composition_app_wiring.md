---
id: "task_6_root_composition_app_wiring"
status: "done"
priority: "high"
assignee: null
epic: "settings_language_darkmode"
dueDate: null
created: "2026-09-06T02:37:10+07:00"
modified: "2026-09-06T15:55:00+07:00"
completedAt: "2026-09-06T03:01:30+07:00"
labels: ["architecture", "feature"]
order: "a6"
---

# Task 6: Root Composition & App-Wide Wiring Verification

Epic: [settings_language_darkmode](../epic/settings_language_darkmode/settings_language_darkmode.en.md)

## Requirement Analysis
Integrate the entire Settings, Dark Mode, and Localization feature into the application composition root (`:app`):
1. Root Theme Observation:
   - In `MainActivity.kt`, inject `AppThemeManager`.
   - Collect `isDarkMode` reactively: `val isDarkMode by appThemeManager.isDarkMode.collectAsStateWithLifecycle()`.
   - Pass `isDarkMode` to `AndroidDigitalWalletTheme(darkTheme = isDarkMode)`.
2. App-wide Dynamic Localization & Fine-Grained Recomposition:
   - Inject `AppLocalizationManager` into `MainActivity`.
   - Collect `currentLanguageCode` and `translationsVersion`.
   - Supply `LocalDynamicStringResolver` via `CompositionLocalProvider(LocalDynamicStringResolver provides remember(currentLanguageCode, translationsVersion) { appLocalizationManager::getString })`.
   - Provide helper composable function `appStringResource(id: Int, fallbackKey: String? = null)` in `:packages:ui_kit` that resolves remote dynamic overrides via `LocalDynamicStringResolver.current` before falling back to local XML resources.
3. Architecture Gate & Code Quality:
   - Run Konsist tests (`./gradlew :konsist-test:test`) to ensure K1 through K9 rules pass with 0 violations.
   - Run `./gradlew spotlessCheck` and `./gradlew spotlessApply`.
   - Verify `./gradlew :app:assembleDebug`.

## Relevant Files & Context Pointers
- `app/src/main/kotlin/com/danhdue/androiddigitalwallet/ui/MainActivity.kt`
- `packages/ui_kit/src/main/kotlin/com/danhdue/uikit/theme/Theme.kt`
- `packages/ui_kit/src/main/kotlin/com/danhdue/uikit/localization/AppStringResource.kt`
- `packages/platform/src/main/kotlin/com/danhdue/platform/localization/AppLocalizationManager.kt`
- `konsist-test/src/test/kotlin/com/danhdue/konsist/ArchitectureTest.kt`

## Design Rationale & Refinements
- The composition root (`:app`) brings all packaged modules together.
- `MainActivity` observes the platform theme state and propagates it to the Compose theme without tight coupling to features.
- Konsist ensures no boundary leaks or forbidden cross-module dependencies occurred during development.
- **Root Key Destruction Elimination (Critical Bug Fix)**:
  - *Problem*: Initially, `MainActivity` wrapped the root composable in `key(currentLanguageCode, translationsVersion) { ... }`. When a background delta translation finished downloading and called `applyDynamicTranslations`, `translationsVersion` changed, which completely tore down and recreated the root composition. This caused open Bottom Sheets to abruptly dismiss and violently reopen.
  - *Solution*: Removed the root `key(...)`. Instead, wired `LocalDynamicStringResolver` providing `appLocalizationManager::getString`. Only individual text composables reading `appStringResource` recompose smoothly in place without restarting Activity or navigation trees.
- **Frame-0 Cold Start Initialization**:
  - `MainActivity` reads `appLocalizationManager.currentLanguageCode.value` directly upon creation, ensuring initial Compose rendering aligns with the persisted user locale without any flash or fallback to system locale.

## TDD Checklist
- [x] **RED**: Run test verifying theme state changes propagate to the root theme and string overrides apply.
- [x] **GREEN**: Wire `AppThemeManager` in `MainActivity` and implement dynamic string helper in UI kit.
- [x] **REFACTOR**: Run `./gradlew :konsist-test:test`, `./gradlew spotlessCheck`, and assemble debug build.

## Definition of Done (DoD)
- `./gradlew :konsist-test:test` passes with 0 violations.
- `./gradlew spotlessCheck` passes.
- `./gradlew check` passes across all modules.
- `./gradlew :app:assembleDebug` builds successfully.
- No destructive root composition recreations during OTA translation sync.

## Dependencies & Blockers
- Blocked by [Task 5](task_5_settings_card_ui_language_bottom_sheet.md)

## References & Rollback
- Epic HLD: [settings_language_darkmode.en.md](../epic/settings_language_darkmode/settings_language_darkmode.en.md)
- Rollback: Revert `app/src/main/kotlin/com/danhdue/androiddigitalwallet/ui/MainActivity.kt`.
