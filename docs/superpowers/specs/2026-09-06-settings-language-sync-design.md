# Design Spec: Flutter Settings Language Switch & OTA Dynamic Localization (Tri-Platform Parity)

**Date**: 2026-09-06  
**Status**: Approved (Draft Spec)  
**Authors**: Antigravity & DanhDue ExOICTIF  
**Target Architecture**: Clean Architecture + MVI + Multi-Module Monorepo Flutter (BLoC, Injectable, Slang, Retrofit)  
**Epic Parity Reference**: `.devtool/epic/settings_language_darkmode/2026-09-06-settings-language-darkmode-design.md`

---

## 1. Context & Motivation

In the sibling Android template (`android_super_app_template`), the Settings screen and dynamic localization system was upgraded under the `settings_language_darkmode` epic. It established a seamless Over-The-Air (OTA) translation and state-orchestrated language switching capability with tri-platform parity goals.

In the Flutter project (`features/settings` and `packages/core`), several localization building blocks already exist (`BootstrapUseCase`, `FetchTranslationUseCase`, `LocalizationManager`), but several critical gaps must be resolved to achieve full tri-platform parity:
1. **Silent Background Bootstrap (UC-02)**: `BootstrapUseCase` is defined but currently never invoked when opening the Settings screen. Users only receive stale or local-only language lists.
2. **Instant Frame-0 Cache Retrieval (UC-01)**: If the local cache is empty, the language list must safely and synchronously fallback to bundled languages (`en`, `vi`), preventing empty bottom sheets.
3. **State-aware Language Switching (UC-03)**:
   - **Same-language skip**: Selecting the currently active language immediately dismisses the bottom sheet without redundant network or state emissions.
   - **Optimistic Switch for Bundled / Cached Locales**: Immediately switch locale in-memory (`LocalizationManager.setLocaleFromCode`) without a blocking loading dialog, and quietly run delta sync in the background.
   - **OTA Download for Uncached Locales**: Show a modal `LoadingDialog`, fetch remote translations via `GET /api/v1/translations/{code}`, save JSON + version + checksum, apply locale, and dismiss dialog. On failure, preserve the previous active language and emit a soft error snackbar.
4. **Componentization & Native Naming (UC-04)**: Extract `LanguagePickerBottomSheet` as a clean, reusable widget displaying native language names (`English`, `Tiếng Việt`, `日本語`, `한국어`) with checkmark selection.
5. **Monorepo Directory Alignment (UC-05)**: Fix `loadBundledFallback` in `SettingsLocalDataSourceImpl` to load assets from `features/scanner` and `features/settings` rather than legacy `packages/` paths.

---

## 2. System Architecture & Module Boundaries

The implementation strictly respects monorepo boundaries:
- `packages/core`: Houses `LocalizationManager`, `DynamicTranslator`, and global locale stream.
- `features/settings`: Contains data models, network clients, local data sources, domain use cases, and BLoC presentation components.

```mermaid
graph TD
    UI[SettingsPage] --> Picker[LanguagePickerBottomSheet]
    UI --> Bloc[SettingsBloc]
    
    Bloc --> UC_GetCached[GetCachedLanguagesUseCase]
    Bloc --> UC_Bootstrap[BootstrapUseCase]
    Bloc --> UC_ChangeLang[ChangeLanguageUseCase]
    
    UC_ChangeLang --> UC_CheckCached[CheckLanguageCachedUseCase]
    UC_ChangeLang --> UC_GetDynamic[GetDynamicLocalizationUseCase]
    UC_ChangeLang --> UC_UpdateUser[UpdateUserLanguageUseCase]
    
    UC_GetDynamic --> Repo[SettingsRepository]
    UC_Bootstrap --> Repo
    UC_GetCached --> Repo
    
    Repo --> RemoteDS[SettingsRemoteDataSource]
    Repo --> LocalDS[SettingsLocalDataSource]
    
    LocalDS --> Prefs[SharedPreferences]
    LocalDS --> FileSys[Atomic JSON Cache Files]
    
    UC_ChangeLang --> LocMgr[LocalizationManager (packages/core)]
    LocMgr --> Slang[LocaleSettings (Slang)]
```

---

## 3. Domain Layer Specifications (`features/settings`)

### 3.1 Domain Entities

```dart
class SupportedLanguage {
  final String languageCode;
  final String languageName;
  final String? version;
  final bool isDefault;
  final bool isActive;
  final bool isCached;

  const SupportedLanguage({
    required this.languageCode,
    required this.languageName,
    this.version,
    this.isDefault = false,
    this.isActive = true,
    this.isCached = false,
  });
}
```

```dart
sealed class LanguageSyncStatus {
  const LanguageSyncStatus();
  const factory LanguageSyncStatus.idle() = _Idle;
  const factory LanguageSyncStatus.loading(String languageCode) = _Loading;
  const factory LanguageSyncStatus.cachedApplied(String languageCode) = _CachedApplied;
  const factory LanguageSyncStatus.success(String languageCode) = _Success;
  const factory LanguageSyncStatus.error(String languageCode, String message) = _Error;
}
```

### 3.2 Use Cases Specification

#### 1. `GetCachedLanguagesUseCase`
- **Contract**: `Future<Either<Failure, List<SupportedLanguage>>> call()`
- **Behavior**:
  - Reads locally stored `AvailableLanguage` list from `SettingsRepository.getAvailableLanguages()`.
  - Maps to `SupportedLanguage`, verifying whether each language is cached via `SettingsRepository.isLanguageCached()`.
  - If the cache is empty, returns the default bundled language list:
    - English (`en`, `languageName: "English"`, `isDefault: true`, `isCached: true`)
    - Vietnamese (`vi`, `languageName: "Tiếng Việt"`, `isDefault: false`, `isCached: true`)

#### 2. `BootstrapUseCase`
- **Contract**: `Future<Either<Failure, SyncBootstrapResponse>> call()`
- **Behavior**:
  - Collects all cached language codes and their version hashes.
  - Calls `POST /api/v1/settings/sync/bootstrap`.
  - Merges remote `available_languages` with bundled defaults.
  - Persists updated list via `SettingsRepository.saveAvailableLanguages()`.
  - If `stale_translations` are returned, triggers background refresh.

#### 3. `ChangeLanguageUseCase`
- **Contract**: `Stream<LanguageSyncStatus> call(String targetLanguageCode)`
- **Behavior**:
  1. **Same-Language Skip**:
     - Compares `LocalizationManager.instance.resolveLocale(targetLanguageCode)` with `LocalizationManager.instance.currentLocale`.
     - If equal, returns immediately with no emissions.
  2. **Cache Verification**:
     - Checks `CheckLanguageCachedUseCase(targetLanguageCode)`.
     - Bundled locales (`en`, `vi`) always evaluate to `isCached = true`.
  3. **Optimistic Path (Cached / Bundled)**:
     - Calls `LocalizationManager.instance.setLocaleFromCode(targetLanguageCode)`.
     - Emits `LanguageSyncStatus.cachedApplied(targetLanguageCode)`.
     - Silently checks for background delta updates via `GetDynamicLocalizationUseCase(targetLanguageCode)`.
     - Emits `LanguageSyncStatus.success(targetLanguageCode)`.
  4. **OTA Download Path (Uncached)**:
     - Emits `LanguageSyncStatus.loading(targetLanguageCode)`.
     - Calls `GetDynamicLocalizationUseCase(targetLanguageCode)` to download remote JSON overrides.
     - On download success:
       - Applies locale: `LocalizationManager.instance.setLocaleFromCode(targetLanguageCode)`.
       - Emits `LanguageSyncStatus.success(targetLanguageCode)`.
     - On download error:
       - Retains existing locale (no switch).
       - Emits `LanguageSyncStatus.error(targetLanguageCode, failure.message)`.
  5. Syncs remote user preference: calls `UpdateUserLanguageUseCase(targetLanguageCode)` in the background.

---

## 4. Data Layer & Asset Fixes (`features/settings`)

### 4.1 Asset Path Correction in `SettingsLocalDataSourceImpl`
In `loadBundledFallback(String languageCode)`, update package paths to account for monorepo restructuring:
```dart
// Previous (broken):
// 'packages/scanner/assets/locales/$languageCode.i18n.json'
// 'packages/settings/assets/locales/$languageCode.i18n.json'

// Updated (correct):
final assetPaths = [
  'assets/locales/$languageCode.i18n.json',
  'packages/core/assets/locales/$languageCode.i18n.json',
  'features/scanner/assets/locales/$languageCode.i18n.json',
  'features/settings/assets/locales/$languageCode.i18n.json',
];
```

### 4.2 Cache Status & Persistence
- Store cached language codes in `SharedPreferences` under key `cached_language_codes`.
- When translations are successfully downloaded and saved as atomic files (`translation_{code}.json`), register `languageCode` into `cached_language_codes`.
- Provide `isLanguageCached(String languageCode)`: returns true if code is `'en'`, `'vi'`, or exists in `cached_language_codes` with an existing file.

---

## 5. Presentation Layer & UI (`features/settings`)

### 5.1 `SettingsBloc` Refinements
- **`_onStarted`**:
  1. Emits initial UI state immediately using `_getCachedLanguagesUseCase()` and `_appInfoService.getPackageInfo()` (status: `SettingsStatus.success`).
  2. Spawns silent background execution of `_bootstrapUseCase()`.
  3. When `_bootstrapUseCase()` finishes, updates `state.uiModel.availableLanguages` seamlessly.
- **`_onChangeLanguage`**:
  - Guards against race conditions using `_pendingLanguageCode`.
  - Listens to `_changeLanguageUseCase(action.languageCode)`:
    - `loading`: sets `isLoadingLanguage: true` (which triggers `LoadingDialog` in the view).
    - `cachedApplied` & `success`: sets `isLoadingLanguage: false`, updates active selection in `uiModel`.
    - `error`: sets `isLoadingLanguage: false`, dispatches `SettingsEvent.showError(message)`.

### 5.2 Component `LanguagePickerBottomSheet`
Create `features/settings/lib/presentation/settings/widgets/language_picker_bottom_sheet.dart`:
- Rounded top corners (`20.dp`).
- Title: localized string (`t.preferences.language`).
- Native Language Name Resolution:
  ```dart
  String resolveNativeLanguageName(String code, String fallbackName) {
    switch (code.toLowerCase().split(RegExp(r'[-_]')).first) {
      case 'en': return 'English';
      case 'vi': return 'Tiếng Việt';
      case 'ja': return '日本語';
      case 'ko': return '한국어';
      case 'zh': return '中文';
      case 'fr': return 'Français';
      case 'de': return 'Deutsch';
      default: return fallbackName;
    }
  }
  ```
- Checkmark trailing icon on the currently selected locale.
- Tapping item closes bottom sheet immediately and emits action to BLoC.

---

## 6. Verification & Testing Strategy

### 6.1 Unit Tests
- `features/settings/test/domain/usecases/change_language_usecase_test.dart`:
  - Verify same-language skip emits nothing.
  - Verify cached/bundled language emits `cachedApplied` then `success`.
  - Verify uncached language emits `loading` then `success` on remote completion.
  - Verify uncached language emits `loading` then `error` on network failure without altering locale.
- `features/settings/test/domain/usecases/get_cached_languages_usecase_test.dart`:
  - Verify returns cached list if present.
  - Verify returns default `['en', 'vi']` if cache is empty.
- `features/settings/test/presentation/settings/settings_bloc_test.dart`:
  - Verify `_onStarted` displays cached languages immediately on frame 0.
  - Verify `_onChangeLanguage` emits loading and handles error snackbar.

### 6.2 Static & Integration Verification
1. `melos run analyze`: Verify 0 errors/warnings.
2. `fvm flutter test`: Ensure 100% pass across all tests.
3. `integration_test/change_language_test.dart`: End-to-end integration test verifying UI switch between English and Vietnamese.
