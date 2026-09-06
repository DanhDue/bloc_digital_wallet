---
id: "task_1_platform_theme_localization_infrastructure"
status: "done"
priority: "high"
assignee: null
epic: "settings_language_darkmode"
dueDate: null
created: "2026-09-06T02:37:10+07:00"
modified: "2026-09-06T23:46:00+07:00"
completedAt: "2026-09-06T23:46:00+07:00"
labels: ["architecture", "feature"]
order: "a1"
---

# Task 1: Platform Theme & Localization Infrastructure

Epic: [settings_language_darkmode](../epic/settings_language_darkmode/settings_language_darkmode.en.md)

## Requirement Analysis

The app requires centralized theme mode and dynamic localization state management living in `:packages:platform`, which serves as the cross-feature seam without coupling to feature presentation layers.

1. `AppThemeMode`: Enum representing `SYSTEM`, `LIGHT`, `DARK`.
2. `AppThemeManager`: Interface & implementation backed by `CacheStore` (`:packages:core`) to persist user preference. Exposes `isDarkMode: StateFlow<Boolean>`, `themeMode: StateFlow<AppThemeMode>`, and `suspend fun setThemeMode(mode: AppThemeMode)`. Emits `AppEvent.ThemeModeChanged` on `AppEventBus`.
3. `AppLocalizationManager`: Interface & implementation managing dynamic translation key-value overrides (from remote OTA delta/full downloads) and the current active language code (`currentLanguageCode: StateFlow<String>`). Exposes `translationsVersion: StateFlow<Long>`, `suspend fun setLocale(languageCode: String)`, `suspend fun applyDynamicTranslations(translations: Map<String, String>)`, and `fun getString(key: String, fallback: String): String`. Emits `AppEvent.AppLanguageChanged` on `AppEventBus`.
4. `AppEvent`: Extend with `data class ThemeModeChanged(val isDarkMode: Boolean) : AppEvent` and `data class AppLanguageChanged(val languageCode: String) : AppEvent`.
5. Dependency Injection: Wire singletons in `PlatformModule.kt`.

## Relevant Files & Context Pointers

- `packages/platform/src/main/kotlin/com/danhdue/platform/theme/AppThemeMode.kt`
- `packages/platform/src/main/kotlin/com/danhdue/platform/theme/AppThemeManager.kt`
- `packages/platform/src/main/kotlin/com/danhdue/platform/localization/AppLocalizationManager.kt`
- `packages/platform/src/main/kotlin/com/danhdue/platform/event/AppEvent.kt`
- `packages/platform/src/main/kotlin/com/danhdue/platform/di/PlatformModule.kt`
- `packages/platform/src/test/kotlin/com/danhdue/platform/theme/AppThemeManagerTest.kt`
- `packages/platform/src/test/kotlin/com/danhdue/platform/localization/AppLocalizationManagerTest.kt`

## Design Rationale & Refinements

- Placing `AppThemeManager` and `AppLocalizationManager` in `:packages:platform` adheres to the governed multi-module architecture (§III.3 of `ARCHITECTURE.md`). `:packages:platform` depends only on `:packages:core`. Both `:app` and `:features:settings` can access these managers without creating any cross-feature dependency.
- **Cold Start Synchronous Locale Restoration (Bug Fix)**:
  - *Problem*: Asynchronous reading from `CacheStore` during app startup caused a race condition where `_currentLanguageCode` defaulted to `"en"` on Frame 0, causing `MainActivity` to invoke `AppCompatDelegate.setApplicationLocales("en")` and overwrite the user's previously chosen language.
  - *Fix*: `DefaultAppLocalizationManager` reads the saved `selected_language_code` and cached dynamic translations synchronously from `SharedPreferences` in its `init` block before Compose renders Frame 0.
- **Dynamic Translations Versioning (`translationsVersion`)**:
  - `translationsVersion: StateFlow<Long>` tracks dynamic string changes, enabling Compose runtime to trigger in-place recomposition via `LocalDynamicStringResolver` without destroying the Activity or Root Composable tree.

## TDD Checklist

- [x] **RED**: Write unit tests verifying:
  - `AppThemeManager` loads initial theme from `CacheStore`, defaults to `SYSTEM`, emits state updates and publishes `AppEvent.ThemeModeChanged`.
  - `AppLocalizationManager` applies dynamic translations into in-memory overrides, updates active locale, and retrieves overridden strings with fallback.
- [x] **GREEN**: Implement minimal code in `packages/platform`:
  - Create `AppThemeMode`, `AppThemeManager`, `DefaultAppThemeManager`.
  - Create `AppLocalizationManager`, `DefaultAppLocalizationManager`.
  - Add `ThemeModeChanged` and `AppLanguageChanged` to `AppEvent`.
  - Wire bindings in `PlatformModule`.
- [x] **REFACTOR**: Ensure all classes follow Effective Kotlin, use injected dispatchers (`DispatcherProvider`), and pass Konsist rules K1–K9.

## Definition of Done (DoD)

- 100% test pass on `packages/platform:test`.
- Konsist architecture gates pass.
- No direct Android UI or Compose dependencies in pure manager logic.
- Cold start immediately restores persisted locale and overrides synchronously on frame 0.

## Dependencies & Blockers

None. This is the foundational platform task.

## References & Rollback

- Epic HLD: [settings_language_darkmode.en.md](../epic/settings_language_darkmode/settings_language_darkmode.en.md)
- Rollback: Revert files under `packages/platform/`.
