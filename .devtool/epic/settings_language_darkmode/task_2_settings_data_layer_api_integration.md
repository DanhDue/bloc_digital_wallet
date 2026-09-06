---
id: "task_2_settings_data_layer_api_integration"
status: "done"
priority: "high"
assignee: null
epic: "settings_language_darkmode"
dueDate: null
created: "2026-09-06T02:37:10+07:00"
modified: "2026-09-06T15:55:00+07:00"
completedAt: "2026-09-06T02:47:35+07:00"
labels: ["architecture", "feature"]
order: "a2"
---

# Task 2: Settings Remote APIs & Data Layer Integration

Epic: [settings_language_darkmode](../epic/settings_language_darkmode/settings_language_darkmode.en.md)

## Requirement Analysis
The Settings feature requires communication with two backend endpoints:
1. `POST /api/v1/settings/sync/bootstrap`:
   - Request body: `{"cached_translations": [{"resource_id": "en_US", "version": "0.0.1"}]}`.
   - Response: `{"available_languages": [...], "stale_translations": [...]}`.
2. `GET /api/v1/translations/{code}?since_version={version}`:
   - Response: Nested JSON tree of strings for the target locale.
3. Data Layer Components:
   - Moshi DTOs: `BootstrapRequestDto`, `BootstrapResponseDto`, `SupportedLanguageDto`, `StaleTranslationDto`.
   - Utility `JsonFlattener`: Converts nested map structure `{"settings": {"preferences": {"darkMode": "..."}}}` into flat dot-notation keys (`settings.preferences.darkMode = "..."`).
   - `SettingsLocalDataSource`: Dual-layer caching of supported language list, translation dot-maps, and versions using both asynchronous `CacheStore` (`:packages:core`) and synchronous `SharedPreferences` (`app_preferences`).
   - `DefaultSettingsRepository`: Integrates `SettingsApiService`, `SettingsLocalDataSource`, and `AppLocalizationManager`.

## Relevant Files & Context Pointers
- `features/settings/src/main/kotlin/com/danhdue/settings/data/remote/SettingsApiService.kt`
- `features/settings/src/main/kotlin/com/danhdue/settings/data/remote/dto/BootstrapRequestDto.kt`
- `features/settings/src/main/kotlin/com/danhdue/settings/data/remote/dto/BootstrapResponseDto.kt`
- `features/settings/src/main/kotlin/com/danhdue/settings/data/util/JsonFlattener.kt`
- `features/settings/src/main/kotlin/com/danhdue/settings/data/local/SettingsLocalDataSource.kt`
- `features/settings/src/main/kotlin/com/danhdue/settings/data/repository/DefaultSettingsRepository.kt`
- `features/settings/src/main/kotlin/com/danhdue/settings/di/SettingsDataModule.kt`
- `features/settings/src/test/kotlin/com/danhdue/settings/data/util/JsonFlattenerTest.kt`
- `features/settings/src/test/kotlin/com/danhdue/settings/data/local/SettingsLocalDataSourceTest.kt`
- `features/settings/src/test/kotlin/com/danhdue/settings/data/repository/DefaultSettingsRepositoryTest.kt`

## Design Rationale & Refinements
- Leverage the project's existing network stack (`:packages:network`) utilizing Retrofit and Moshi.
- Applicable skills: `api_integration`, `moshi_dto_generator`.
- DTOs must use `@JsonClass(generateAdapter = true)` with `@Json(name = "...")` to adhere to Moshi guidelines.
- **Dual-Layer Caching (Bug Fix & Architecture Enhancement)**:
  - *Problem*: If languages and translations are only persisted in asynchronous `CacheStore` (DataStore), during cold starts and fast screen renders, data is not available synchronously on Frame 0, causing the language picker to appear with incomplete language options until network or DataStore coroutines finish.
  - *Solution*: Added `getSupportedLanguagesSync()` and `cacheSupportedLanguagesSync()` backed by `SharedPreferences` + Moshi in `SettingsLocalDataSource`. Caches the remote language list immediately upon bootstrap response.
- **Delta Sync Guard & Non-destructive Updates**:
  - `DefaultSettingsRepository.fetchAndCacheTranslations` checks if the received delta updates are non-empty (`flattened.isNotEmpty()`) before calling `appLocalizationManager.applyDynamicTranslations()`. If unchanged, it skips emitting redundant updates, avoiding UI redraw glitches.

### BDD SCENARIOS

```gherkin
Feature: Settings Data Layer & API Integration
  As the settings data layer
  I want robust remote API communication, envelope deserialization, and dual-layer persistence
  So that user preferences and translations are preserved across restarts and network outages

  # Bootstrap Happy Path & Merging
  Scenario: Successful remote bootstrap sync
    Given the backend returns 200 OK with available languages ["en_US", "ja_JP", "ko_KR"]
    When SettingsRepository.bootstrap() is called
    Then the remote languages are merged with the bundled default "vi"
    And the merged list of 4 languages is saved into both DataStore and SharedPreferences
    And Result.success is returned with all 4 languages

  # Bootstrap Network Failure Fallback
  Scenario: Remote bootstrap network failure with local cache
    Given the remote bootstrap call throws an IOException
    And the local storage contains previously saved languages ["en", "vi", "ja_JP"]
    When SettingsRepository.bootstrap() is called
    Then it catches the exception safely
    And returns Result.success containing the cached language list

  # Bootstrap Total Failure Fallback
  Scenario: Remote bootstrap network failure with empty cache
    Given the remote bootstrap call fails
    And the local storage is completely empty
    When SettingsRepository.bootstrap() is called
    Then it returns Result.success containing the bundled default languages ["en", "vi"]

  # Translation Delta Updates & Deleted Keys
  Scenario: Fetch translation with delta updates and deleted keys
    Given the backend returns translation JSON with new keys and deleted_keys: ["old_key"]
    And local storage contains {"old_key": "old_val", "existing_key": "val"}
    When SettingsRepository.fetchAndCacheTranslations("ja_JP") is called
    Then "old_key" is removed from the local translation map
    And new keys are merged with existing keys
    And the merged map is persisted to storage and applied to AppLocalizationManager

  # Empty Delta Guard
  Scenario: Fetch translation returning empty delta updates
    Given the backend returns empty translations and empty deleted_keys
    When SettingsRepository.fetchAndCacheTranslations("ja_JP") is called
    Then it returns existing translations
    And skips calling AppLocalizationManager.applyDynamicTranslations to avoid UI jitter
```

## TDD Checklist
- [x] **RED**: Write unit tests for:
  - `JsonFlattener`: Correctly flattens multi-level nested maps and preserves primitive string values.
  - `SettingsLocalDataSource`: Correctly serializes and deserializes language lists and flattened translation maps via `CacheStore` and `SharedPreferences`.
  - `DefaultSettingsRepository`: Correctly handles bootstrap call, maps DTOs to Domain models, and downloads & caches translations.
- [x] **GREEN**: Implement minimal data layer code:
  - Create DTOs with Moshi annotations.
  - Create `SettingsApiService`.
  - Implement `JsonFlattener` and `SettingsLocalDataSource`.
  - Implement `DefaultSettingsRepository`.
  - Wire Hilt dependencies in `SettingsDataModule`.
- [x] **REFACTOR**: Ensure no leaked DTOs into domain interfaces, use pure Kotlin mappers.

## Definition of Done (DoD)
- Unit tests pass with >85% coverage on data layer.
- Konsist architecture rules (K2, K3, K4) pass.
- Remote failure scenarios safely return domain `Failure` / `Result.failure` without unhandled exceptions.
- Dual-layer cache supports both synchronous and asynchronous retrieval.

## Dependencies & Blockers
- Blocked by [Task 1](task_1_platform_theme_localization_infrastructure.md)

## References & Rollback
- Epic HLD: [settings_language_darkmode.en.md](../epic/settings_language_darkmode/settings_language_darkmode.en.md)
- Rollback: Revert data layer changes in `features/settings/src/main/kotlin/com/danhdue/settings/data/`.
