---
id: "task_4_settings_presentation_mvi_viewmodel"
status: "done"
priority: "high"
assignee: null
epic: "settings_language_darkmode"
dueDate: null
created: "2026-09-06T02:37:10+07:00"
modified: "2026-09-06T15:55:00+07:00"
completedAt: "2026-09-06T02:53:00+07:00"
labels: ["architecture", "feature"]
order: "a4"
---

# Task 4: Settings Presentation MVI ViewModel

Epic: [settings_language_darkmode](../epic/settings_language_darkmode/settings_language_darkmode.en.md)

## Requirement Analysis
The presentation layer must adhere to the MVI pattern inherited from `MviViewModel<SettingsState, SettingsAction, SettingsEvent>` (`:packages:framework`):
1. `SettingsState`:
   - `isDarkMode: Boolean = false`
   - `selectedLanguageCode: String = "en"`
   - `selectedLanguageName: String = "English"`
   - `availableLanguages: List<SupportedLanguage> = emptyList()`
   - `isLanguagePickerVisible: Boolean = false`
   - `isLoadingLanguage: Boolean = false`
   - `error: UiText? = null`
2. `SettingsAction`:
   - `Init`: Dispatches silent bootstrap sync and observes theme/locale updates.
   - `ToggleDarkMode(val isDark: Boolean)`: Toggles dark mode.
   - `OpenLanguagePicker`: Opens the modal bottom sheet.
   - `DismissLanguagePicker`: Closes the modal bottom sheet.
   - `SelectLanguage(val languageCode: String)`: Triggers language change via `ChangeLanguageUseCase`.
   - `OpenProfile`, `OpenSecurity`, `OpenDeveloperOptions`, `Logout`: Feature navigation triggers.
3. `SettingsEvent`:
   - `NavigateToProfile`, `NavigateToSecurity`, `NavigateToDeveloperOptions`, `ShowToast(val message: UiText)`.
4. `SettingsViewModel`:
   - Injects `BootstrapSettingsUseCase`, `GetCachedLanguagesUseCase`, `ChangeLanguageUseCase`, `ToggleDarkModeUseCase`, `AppThemeManager`, `AppLocalizationManager`, and `AppEventBus`.
   - On startup (`loadInitialData()`), immediately calls `getCachedLanguagesUseCase()` to populate `availableLanguages` from disk cache before initiating background `bootstrapSettingsUseCase()`.
   - Resolves display names via `resolveLanguageName(code)` checking cached `SupportedLanguage` models with fallback to standard `Locale.forLanguageTag(code).getDisplayLanguage()`.
   - Cancels any running language sync jobs if the user rapidly selects another language to avoid race conditions.

## Relevant Files & Context Pointers
- `features/settings/src/main/kotlin/com/danhdue/settings/presentation/SettingsState.kt`
- `features/settings/src/main/kotlin/com/danhdue/settings/presentation/SettingsAction.kt`
- `features/settings/src/main/kotlin/com/danhdue/settings/presentation/SettingsEvent.kt`
- `features/settings/src/main/kotlin/com/danhdue/settings/presentation/SettingsViewModel.kt`
- `features/settings/src/test/kotlin/com/danhdue/settings/presentation/SettingsViewModelTest.kt`

## Design Rationale & Refinements
- MVI guarantees predictable unidirectional data flow.
- The ViewModel does not touch UI elements and exposes state solely through immutable `StateFlow<SettingsState>`.
- Cancellation of in-flight language loading prevents out-of-order state overwrites.
- **Immediate Cached Language Loading (Bug Fix)**:
  - *Problem*: `availableLanguages` was initialized empty or with hardcoded fallbacks, causing a delay where remote languages (e.g. `ja_JP`) were invisible if user opened the language picker immediately upon entering Settings.
  - *Fix*: `SettingsViewModel` calls `getCachedLanguagesUseCase()` at initialization to populate all persisted languages from disk instantly.
- **Bottom Sheet Picker Stability & Non-reentrant Closes (Bug Fix)**:
  - *Problem*: User selects a language -> bottom sheet closes -> language is applied. When rapidly reopening the picker, the background delta update finishes, triggering an event that caused the bottom sheet to close again.
  - *Fix*: The delta update runs in a decoupled background coroutine without manipulating `isLanguagePickerVisible`. Combined with fine-grained string recomposition in Compose, opening and closing the picker is completely stable.
- **Dynamic Display Name Resolution**:
  - Replaced static `when (code)` branching with dynamic lookup from `availableLanguages` and `java.util.Locale.forLanguageTag(code).getDisplayLanguage(locale).replaceFirstChar { it.uppercase() }`.

### BDD SCENARIOS

```gherkin
Feature: Settings Presentation MVI ViewModel
  As a digital wallet user
  I want predictable, unidirectional UI interactions on the Settings screen
  So that changing theme and language is instantaneous, glitch-free, and handles all edge cases

  # Startup & Initial State
  Scenario: Load initial settings data and seed cached languages immediately
    Given the app has launched and persisted languages exist in local storage
    When SettingsViewModel initializes
    Then it immediately seeds availableLanguages with cached languages
    And updates selectedLanguageCode and localized selectedLanguageName
    And silently invokes BootstrapSettingsUseCase in background without blocking UI

  # Theme Toggle
  Scenario: Toggle dark mode switch
    Given the Settings screen is visible
    When the user dispatches ToggleDarkMode(true)
    Then ToggleDarkModeUseCase is executed
    And SettingsState.isDarkMode is updated to true

  # Language Picker Lifecycle
  Scenario: Open and dismiss language picker bottom sheet
    Given the Settings screen is visible
    When the user dispatches OpenLanguagePicker
    Then SettingsState.isLanguagePickerVisible becomes true
    When the user dispatches DismissLanguagePicker
    Then SettingsState.isLanguagePickerVisible becomes false

  # Language Selection - Optimistic & Cached
  Scenario: Select cached language from picker
    Given the language picker is open
    When the user dispatches SelectLanguage with cached "vi"
    Then SettingsState.isLanguagePickerVisible becomes false immediately
    And SettingsState.selectedLanguageCode becomes "vi"
    And SettingsState.selectedLanguageName becomes "Tiếng Việt"

  # Language Selection - Same Language (Edge Case)
  Scenario: Select currently active language
    Given the current language is "en"
    And the language picker is open
    When the user dispatches SelectLanguage with "en"
    Then SettingsState.isLanguagePickerVisible becomes false
    And no background synchronization or locale switch is re-triggered

  # Language Selection - Uncached Loading & Error Handling
  Scenario: Select uncached language with download error
    Given the language picker is open
    When the user dispatches SelectLanguage with uncached "ko_KR"
    And the download fails with a network error
    Then SettingsState.isLoadingLanguage is reset to false
    And a SettingsEvent.ShowToast event is emitted with the error message
    And the active selectedLanguageCode is not changed

  # Rapid Selection / Race Condition
  Scenario: Rapidly select multiple languages
    Given the language picker is open
    When the user rapidly selects "ko_KR" followed immediately by "ja_JP"
    Then the in-flight job for "ko_KR" is cancelled
    And only the latest selection "ja_JP" is processed and applied to SettingsState
```

## TDD Checklist
- [x] **RED**: Write unit tests for:
  - `SettingsViewModel` on `Init`: loads cached languages immediately, runs silent bootstrap and populates `availableLanguages` without setting `isLoadingLanguage = true`.
  - `ToggleDarkMode`: updates `isDarkMode` state and executes use case.
  - `SelectLanguage`: handles loading state, switches language immediately if cached, shows and dismisses dialog appropriately.
  - `SelectLanguage` with already selected language: does nothing and closes picker.
  - Rapid language selection (race condition): ensures only the latest selection completes.
- [x] **GREEN**: Implement minimal ViewModel and MVI Contract.
- [x] **REFACTOR**: Ensure clean separation between Actions and Events, no hardcoded strings.

## Definition of Done (DoD)
- 100% tests pass on `SettingsViewModelTest`.
- Immutability of `SettingsState` guaranteed.
- Single responsibility for all action handlers.
- Language picker immediately reflects cached languages without waiting for network.

## Dependencies & Blockers
- Blocked by [Task 3](task_3_settings_domain_orchestration_usecases.md)

## References & Rollback
- Epic HLD: [settings_language_darkmode.en.md](../epic/settings_language_darkmode/settings_language_darkmode.en.md)
- Rollback: Revert presentation files in `features/settings/src/main/kotlin/com/danhdue/settings/presentation/`.
