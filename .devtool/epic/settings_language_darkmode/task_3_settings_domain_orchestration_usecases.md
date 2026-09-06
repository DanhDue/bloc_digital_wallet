---
id: "task_3_settings_domain_orchestration_usecases"
status: "done"
priority: "high"
assignee: null
epic: "settings_language_darkmode"
dueDate: null
created: "2026-09-06T02:37:10+07:00"
modified: "2026-09-06T23:50:30+07:00"
completedAt: "2026-09-06T23:50:30+07:00"
labels: ["architecture", "feature"]
order: "a3"
---

# Task 3: Settings Domain Orchestration Use Cases

Epic: [settings_language_darkmode](../epic/settings_language_darkmode/settings_language_darkmode.en.md)

## Requirement Analysis
The domain layer must encapsulate all business logic in pure Kotlin, free of any Android framework dependencies (enforced by Konsist K3 rule):
1. Domain Entities:
   - `SupportedLanguage`: `code: String`, `name: String`, `version: String`, `isDefault: Boolean`, `isActive: Boolean`, `isCached: Boolean`.
   - `LanguageSyncStatus`: Sealed hierarchy (`Idle`, `Loading`, `CachedApplied`, `Success`, `Error`).
2. Domain Repository Contract:
   - `SettingsRepository`: Interface declaring `bootstrap()`, `fetchAndCacheTranslations(code)`, `getCachedLanguages()`, `getActiveLanguage()`.
3. Use Cases:
   - `BootstrapSettingsUseCase`: Calls `SettingsRepository.bootstrap()` silently in background to update available languages and cache metadata.
   - `GetCachedLanguagesUseCase`: Calls `SettingsRepository.getCachedLanguages()` to supply the UI with persisted languages immediately upon launch before network bootstrap completes.
   - `ChangeLanguageUseCase`: Flow-based use case. If target language is bundled (`en`, `vi`) or locally cached, immediately applies it (optimistic switch) and triggers a background check for delta updates; if uncached, emits `Loading`, fetches translations from remote, caches them, applies dynamic translations via `AppLocalizationManager`, and emits `Success` (or `Error` on failure).
   - `ToggleDarkModeUseCase`: Updates `AppThemeManager` with the requested theme mode (`DARK` vs `LIGHT`).

## Relevant Files & Context Pointers
- `features/settings/src/main/kotlin/com/danhdue/settings/domain/model/SupportedLanguage.kt`
- `features/settings/src/main/kotlin/com/danhdue/settings/domain/model/LanguageSyncStatus.kt`
- `features/settings/src/main/kotlin/com/danhdue/settings/domain/repository/SettingsRepository.kt`
- `features/settings/src/main/kotlin/com/danhdue/settings/domain/usecase/BootstrapSettingsUseCase.kt`
- `features/settings/src/main/kotlin/com/danhdue/settings/domain/usecase/GetCachedLanguagesUseCase.kt`
- `features/settings/src/main/kotlin/com/danhdue/settings/domain/usecase/ChangeLanguageUseCase.kt`
- `features/settings/src/main/kotlin/com/danhdue/settings/domain/usecase/ToggleDarkModeUseCase.kt`
- `features/settings/src/test/kotlin/com/danhdue/settings/domain/usecase/BootstrapSettingsUseCaseTest.kt`
- `features/settings/src/test/kotlin/com/danhdue/settings/domain/usecase/GetCachedLanguagesUseCaseTest.kt`
- `features/settings/src/test/kotlin/com/danhdue/settings/domain/usecase/ChangeLanguageUseCaseTest.kt`
- `features/settings/src/test/kotlin/com/danhdue/settings/domain/usecase/ToggleDarkModeUseCaseTest.kt`

## Design Rationale & Refinements
- Clean Architecture dictates pure Kotlin domain layer.
- UseCases should do one thing and follow Single Responsibility Principle.
- `ChangeLanguageUseCase` returns a `Flow<LanguageSyncStatus>` so the UI can reactively transition from optimistic applied state to background sync completion or display loading dialog.
- **Introduction of `GetCachedLanguagesUseCase` (Bug Fix & Architecture Alignment)**:
  - *Problem*: Previously, available languages were only retrieved via `BootstrapSettingsUseCase`. If a user opened the language picker immediately or launched offline, newly supported languages (like `ja_JP`, `ko_KR`) were missing from the picker dialog until network completion.
  - *Fix*: Decoupled cached language retrieval into `GetCachedLanguagesUseCase`, allowing Presentation layer to seed `availableLanguages` immediately on startup without network round-trips.

### BDD SCENARIOS

```gherkin
Feature: Settings Domain Orchestration Use Cases
  As a digital wallet user
  I want my settings, language choices, and theme changes to be orchestrated cleanly in domain logic
  So that the app stays fast, responsive, and resilient to network failures

  # Happy Path & Optimistic Switching
  Scenario: Switch to bundled or locally cached language
    Given a target language "vi" or cached "ja_JP" is selected
    When ChangeLanguageUseCase is invoked
    Then it immediately emits "LanguageSyncStatus.CachedApplied"
    And calls AppLocalizationManager.setLocale with the language code
    And silently triggers a background delta check without blocking
    And finally emits "LanguageSyncStatus.Success"

  # Uncached Remote Language (OTA)
  Scenario: Download and apply uncached remote language
    Given an uncached target language "ko_KR"
    When ChangeLanguageUseCase is invoked
    Then it emits "LanguageSyncStatus.Loading"
    And calls SettingsRepository.fetchAndCacheTranslations("ko_KR")
    And on download success, calls AppLocalizationManager.setLocale("ko_KR")
    And emits "LanguageSyncStatus.Success"

  # Network / Remote Failure
  Scenario: Handle failure when downloading remote language
    Given an uncached target language "ko_KR"
    And the network request fails with a timeout or 500 error
    When ChangeLanguageUseCase is invoked
    Then it emits "LanguageSyncStatus.Loading"
    And on failure, it does not change the active locale
    And emits "LanguageSyncStatus.Error" with the failure message

  # Instant Cache Seeding
  Scenario: Instant retrieval of cached languages on startup
    Given local cache contains persisted languages ["en", "vi", "ja_JP"]
    When GetCachedLanguagesUseCase is invoked
    Then it synchronously queries the repository
    And returns the full list of 3 languages without network latency

  # Theme Toggle
  Scenario: Toggle dark mode theme state
    Given the current theme is light
    When ToggleDarkModeUseCase is invoked with isDarkMode = true
    Then it delegates to AppThemeManager.setThemeMode with AppThemeMode.DARK
    And persists to cache and notifies the global AppEventBus
```

## TDD Checklist
- [x] **RED**: Write unit tests for:
  - `BootstrapSettingsUseCase`: Returns updated supported languages list on success, returns cached list on failure.
  - `GetCachedLanguagesUseCase`: Returns cached supported languages from repository.
  - `ChangeLanguageUseCase`: Emits `CachedApplied` immediately for cached/bundled language; emits `Loading` -> `Success` for uncached language; emits `Error` on network failure.
  - `ToggleDarkModeUseCase`: Verifies theme manager is called with correct theme mode.
- [x] **GREEN**: Implement minimal code:
  - Create domain models and interface.
  - Implement the use cases.
- [x] **REFACTOR**: Verify pure Kotlin imports (no `android.*` or `androidx.*`).

## Definition of Done (DoD)
- 100% test pass on use cases.
- Strict compliance with Konsist K3 rule.
- Full branch coverage of optimistic vs loading paths in `ChangeLanguageUseCase`.

## Dependencies & Blockers
- Blocked by [Task 2](task_2_settings_data_layer_api_integration.md)

## References & Rollback
- Epic HLD: [settings_language_darkmode.en.md](../epic/settings_language_darkmode/settings_language_darkmode.en.md)
- Rollback: Revert domain changes in `features/settings/src/main/kotlin/com/danhdue/settings/domain/`.
