---
id: "task_13_domain_data_language_normalization"
status: "done"
priority: "high"
assignee: null
epic: "settings-bugfixes"
dueDate: null
created: "2026-09-16T13:36:00+07:00"
modified: "2026-09-16T06:48:30Z"
completedAt: "2026-09-16T06:48:30Z"
labels: ["domain", "data", "bugfix", "localization"]
order: "a1"
---

# Task 13: Domain & Data - Language Normalization & Bundled Cache Resolution

Epic: [settings_bugfixes](settings_bugfixes.en.md)

## Requirement Analysis
The application has two bundled compiled-in languages (`en` and `vi`). Currently, `ChangeLanguageUseCase`, `CheckLanguageCachedUseCase`, `GetCachedLanguagesUseCase`, and `SettingsLocalDataSourceImpl.loadBundledFallback` perform literal string matching (`== 'en' || == 'vi'`). When backend bootstrap or device locale settings provide region-tagged language codes (e.g. `en_US`, `en-US`, `vi_VN`, `vi-VN`), these checks fail.
As a result:
- `CheckLanguageCachedUseCase` returns `false` for `en_US` because local OTA storage has no downloaded JSON for compiled-in languages.
- `GetCachedLanguagesUseCase` sets `isCached: false` for `SupportedLanguage(languageCode: 'en_US')`.
- `ChangeLanguageUseCase` evaluates `isBundled = false`, `isCached = false`, and emits `LanguageSyncStatus.loading('en_US')` instead of `cachedApplied`.
- `SettingsLocalDataSourceImpl.loadBundledFallback` attempts to load `assets/locales/en_US.i18n.json` which does not exist, instead of resolving to `en.i18n.json`.

This task must normalize language codes by extracting the base language tag (e.g., `baseCode = languageCode.toLowerCase().split(RegExp(r'[-_]')).first`) across all these touchpoints, ensuring bundled languages are always recognized as cached.

## Relevant Files & Context Pointers
- `features/settings/lib/domain/usecases/change_language_usecase.dart`
- `features/settings/lib/domain/usecases/check_language_cached_usecase.dart`
- `features/settings/lib/domain/usecases/get_cached_languages_usecase.dart`
- `features/settings/lib/data/datasources/local/settings_local_datasource_impl.dart`
- `features/settings/test/domain/usecases/change_language_usecase_test.dart`
- `features/settings/test/domain/usecases/check_language_cached_usecase_test.dart` (NEW)
- `features/settings/test/domain/usecases/get_cached_languages_usecase_test.dart`
- `features/settings/test/data/datasources/local/settings_local_datasource_impl_test.dart`

## Design Rationale
- Normalization extracts `baseCode`: `languageCode.toLowerCase().split(RegExp(r'[-_]')).first`.
- Any code where `baseCode == 'en' || baseCode == 'vi'` is immediately recognized as bundled and therefore `isCached = true`.
- In `SettingsLocalDataSourceImpl.loadBundledFallback`, candidate paths must check both `$languageCode.i18n.json` and `$baseCode.i18n.json` to ensure asset resolution never fails for locale variants.

## Impact Analysis & Blast Radius
- **Target Files & Symbols**:
  - `ChangeLanguageUseCase.call`
  - `CheckLanguageCachedUseCase.call`
  - `GetCachedLanguagesUseCase.call`
  - `SettingsLocalDataSourceImpl.loadBundledFallback`
- **Downstream Callers**: `SettingsBloc`, `LanguagePickerBottomSheet`, `BootstrapUseCase`.
- **Cross-Platform Bridges**: None.
- **Target Test Coverage Threshold**: $\ge 85\%$ for Domain UseCases, $\ge 80\%$ for Data Source.

### BDD SCENARIOS

#### [Tier A - Unit] Scenario 1: CheckLanguageCachedUseCase normalizes region tags for bundled languages
```gherkin
Given CheckLanguageCachedUseCase is initialized
When called with "en_US", "en-US", "vi_VN", or "vi-VN"
Then it returns true without querying local storage for OTA translation versions
```

#### [Tier A - Unit] Scenario 2: GetCachedLanguagesUseCase marks region-tagged bundled languages as cached
```gherkin
Given the backend returns an available language list containing "en_US" and "vi_VN"
When GetCachedLanguagesUseCase is invoked
Then the returned SupportedLanguage for "en_US" has isCached == true
And the returned SupportedLanguage for "vi_VN" has isCached == true
```

#### [Tier A - Unit] Scenario 3: ChangeLanguageUseCase executes optimistic switch for en_US without loading state
```gherkin
Given the current locale is "vi"
When ChangeLanguageUseCase is called with "en_US"
Then it emits [LanguageSyncStatus.cachedApplied('en_US'), LanguageSyncStatus.success('en_US')]
And it NEVER emits LanguageSyncStatus.loading('en_US')
And LocalizationManager.instance.currentLocale resolves to "en"
```

#### [Tier A - Unit] Scenario 4: SettingsLocalDataSourceImpl.loadBundledFallback resolves base asset file
```gherkin
Given SettingsLocalDataSourceImpl is initialized with rootBundle containing "en.i18n.json"
When loadBundledFallback is called with "en_US"
Then it loads the fallback content from "en.i18n.json" successfully
```

## Test & Verification Checklist
- [ ] **RED**: Write failing tests in `check_language_cached_usecase_test.dart`, `get_cached_languages_usecase_test.dart`, `change_language_usecase_test.dart`, and `settings_local_datasource_impl_test.dart` asserting correct behavior for `en_US` and `vi_VN`. Confirm failure.
- [ ] **GREEN**: Implement minimal code changes in `check_language_cached_usecase.dart`, `get_cached_languages_usecase.dart`, `change_language_usecase.dart`, and `settings_local_datasource_impl.dart`. Verify all tests pass.
- [ ] **REFACTOR**: Ensure clean code, proper const usage, and format via `fvm dart format .`.
- [ ] Run `fvm flutter test features/settings/test/` to verify zero regressions.
