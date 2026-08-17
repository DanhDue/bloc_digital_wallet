# Mobile App Tasks: Dynamic Configuration & User Preferences Sync

This document outlines the main tasks that the Mobile App team needs to implement to support the Dynamic Configuration, User Preferences Sync, and Delta Versioning features.

> **Related Documents**:
> - [Dynamic Configuration HLD](./dynamic_configuration_hld.md)
> - [Dynamic Configuration API](./dynamic_configuration_api.md)
> - [User Preferences Sync API](./user_preferences_sync_api.md)

---

> **Architecture Note**: The entire Bootstrap flow MUST be executed inside **SplashScreen** (not in `main()`).
> Calling the network API before `runApp()` blocks the Flutter engine and causes a blank white screen.
> The Splash screen acts as the "loading gate" — it displays a brand animation while the app bootstraps in the background.

---

## Shared Prerequisites

> These tasks are required before implementing either Translation or Theme flows.

- [ ] **Bundled Fallback Assets**: Ship a default `1.0.0` JSON for both translation and theme in the `assets/` folder.
  - Load bundled assets **first** on a clean install (or offline) before any network call.
  - Prevents blank UI when there is no network on first launch.
- [ ] Implement API call to `POST /api/v1/sync/bootstrap` from **SplashBloc** (not `main()`).
- [ ] **Guest State Handling**: If user is not logged in, call the API without a token. Fallback to System Locale/Theme if `user_preferences` is null.
- [ ] Pass `cached_versions` of all locally stored translations **and** themes to the bootstrap API.

---

## Part I: Translation

### I.1. Bootstrap — Localization

> Executed inside **SplashBloc** on app startup.

- [ ] **Apply user language preference**: Read `user_preferences.language` from the bootstrap response. If it differs from the current locale, update via `LocalizationManager`.
- [ ] **Guest fallback**: If `user_preferences` is null (guest), fallback to System Locale.
- [ ] **Fetch stale translations**: For each translation entry in the response where `is_stale == true`, download updated JSON from `fetch_url` (delta) or `full_fetch_url` (full replace).
- [ ] **Purge removed translations**: Remove any translation resources listed in `removed_resources` from local cache.
  - If the active locale's translation is removed, fallback to the bundled `1.0.0` asset to prevent a crash.
- [ ] **Update available languages list**: Persist the `available_languages` list from the response to local storage for use in the Language Picker UI.

---

### I.2. Delta Versioning — Translation

> Data integrity layer for local translation JSON files.

- [ ] Update data layer to parse the API response fields for translation resources: `mode`, `version`, `since_version`, `checksum`, `changes`, `deleted_keys`.
- [ ] Implement Deep Merge logic for translations:
  - If `mode == "full"`, replace the entire local translation cache for that resource.
  - If `mode == "delta"`, recursively merge `changes` into the existing local JSON tree.
  - Remove all keys specified in `deleted_keys` from the local tree.
- [ ] **Checksum Validation**: After a delta merge, calculate the MD5/SHA-256 hash of the resulting JSON string. Compare it with the API's `checksum`. If mismatched, delete the local file and force a Full Fetch.
- [ ] Save the updated `version` string in local storage to be used in future `since_version` requests.

---

### I.3. Slang Dynamic Overriding (Multi-Package)

> Apply merged translation JSON into Slang at runtime across all feature packages.

- [ ] **Core LocalizationManager**: Implement `LocalizationManager.applyDynamicTranslations(Map<String, dynamic> mergedJson)` in `packages/core`.
- [ ] **App Layer Orchestration**: In `lib/main.dart`, register a callback with `LocalizationManager` to broadcast the new translation map to all independent packages.
- [ ] **Trigger Overrides**: In the callback, iterate and call Slang's override method for the root and all feature packages:
  ```dart
  AppLocaleSettings.overrideTranslations(locale: currentLocale, map: mergedJson);
  HomeLocaleSettings.overrideTranslations(locale: currentLocale, map: mergedJson['home']);
  SettingsLocaleSettings.overrideTranslations(locale: currentLocale, map: mergedJson['settings']);
  // ... repeat for all feature packages
  ```
- [ ] **Safe Fallback for Slang**: Ensure the Slang configuration (in `build.yaml`) handles missing/deleted translation keys gracefully (e.g., returning the key name or using fallback language) to prevent app crashes when keys are removed via delta sync.

---

### I.4. User Preferences — Language

> Sync user's language preference to the server when changed manually.

- [ ] When the user manually changes the app language via Settings, call `PUT /api/v1/users/me/preferences` to sync to the server.
- [ ] Ensure the local locale updates **instantly** without waiting for the API response (optimistic update).
- [ ] **Offline Sync Queue**: If the network is unavailable when `PUT /preferences` is called, queue the request and retry in the background when connectivity is restored.

---

### I.5. Push Notification — Translation Updates

> Handle server-pushed config_update notifications for translation resources.

- [ ] Listen for Silent Push Notifications (Data Messages) from FCM/APNS with `type: "config_update"` and `resource: "translation"`.
- [ ] Parse payload for `resource_id` and `new_version`.
- [ ] Compare `new_version` with the locally cached translation version.
- [ ] If out of date, trigger a background delta fetch for that specific translation resource using `since_version`.
- [ ] Upon successful update, trigger a UI rebuild via `LocalizationManager`.

---

### I.6. UI — Language Picker

> Expose synced translation data in the Settings UI.

- [ ] Update the Language Selector UI to consume `available_languages` data from local storage (synced via Bootstrap).

---

## Part II: Theme

### II.1. Bootstrap — Theme

> Executed inside **SplashBloc** on app startup.

- [ ] **Apply theme precedence**: Implement the following priority order when resolving which theme to display:
  1. `active_campaign_theme_id` (highest priority — server-driven campaign)
  2. `user_preferences.selected_theme_id` (user's saved choice)
  3. System Default (lowest priority — fallback)
- [ ] **Guest fallback**: If `user_preferences` is null (guest), apply System Default theme.
- [ ] **Fetch stale themes**: For each theme entry in the response where `is_stale == true`, download updated JSON from `fetch_url` (delta) or `full_fetch_url` (full replace).
- [ ] **Purge removed themes**: Remove any theme resources listed in `removed_resources` from local cache.
  - **Active Deletion Fallback**: If the currently active theme is in `removed_resources`, immediately switch to System Default to prevent UI crash.
- [ ] **Update available themes list**: Persist the `available_themes` list from the response to local storage for use in the Theme Picker UI.

---

### II.2. Delta Versioning — Theme

> Data integrity layer for local theme JSON files.

- [ ] Update data layer to parse the API response fields for theme resources: `mode`, `version`, `since_version`, `checksum`, `changes`, `deleted_keys`.
- [ ] Implement Deep Merge logic for themes:
  - If `mode == "full"`, replace the entire local theme cache for that resource.
  - If `mode == "delta"`, recursively merge `changes` into the existing local JSON tree.
  - Remove all keys specified in `deleted_keys` from the local tree.
- [ ] **Checksum Validation**: After a delta merge, calculate the MD5/SHA-256 hash of the resulting JSON string. Compare it with the API's `checksum`. If mismatched, delete the local file and force a Full Fetch.
- [ ] Save the updated `version` string in local storage to be used in future `since_version` requests.

---

### II.3. Theme Tailor Dynamic Overriding (Multi-Package)

> Apply merged theme JSON into ThemeTailor at runtime and propagate to all feature packages.

- [ ] **JSON Parsing Logic**: Implement a mapper in `packages/ui_kit` to parse the `mergedJson` Map into `ThemeTailor` generated classes (e.g., `AppTheme.fromJson(mergedJson)`). Note: `theme_tailor` doesn't generate `fromJson` out of the box, so custom factories or `json_serializable` integration may be needed.
- [ ] **Core ThemeManager**: Implement `ThemeManager.applyDynamicTheme(Map<String, dynamic> mergedJson)` to parse the new theme and push the resulting `ThemeData` (or `ThemeExtension`) into a Stream/State.
- [ ] **App Layer Reconstruction**: In the root App widget (`lib/main.dart` or `App.dart`), wrap `MaterialApp` in a builder that listens to `ThemeManager`. When the theme changes, rebuild `MaterialApp` with the new `ThemeData(extensions: [newAppTheme])`.
- [ ] **Automatic Propagation**: Because `theme_tailor` relies on Flutter's `Theme.of(context).extension<AppTheme>()`, independent feature packages do not need explicit override calls. Rebuilding the root `MaterialApp` will automatically propagate the new colors/styles down the widget tree to all packages.

---

### II.4. User Preferences — Theme

> Sync user's theme preference to the server when changed manually.

- [ ] When the user manually changes the app theme via Settings, call `PUT /api/v1/users/me/preferences` to sync to the server.
- [ ] Ensure the local theme updates **instantly** without waiting for the API response (optimistic update).
- [ ] **Offline Sync Queue**: If the network is unavailable when `PUT /preferences` is called, queue the request and retry in the background when connectivity is restored.

---

### II.5. Push Notification — Theme Updates

> Handle server-pushed config_update notifications for theme resources.

- [ ] Listen for Silent Push Notifications (Data Messages) from FCM/APNS with `type: "config_update"` and `resource: "theme"`.
- [ ] Parse payload for `resource_id` and `new_version`.
- [ ] Compare `new_version` with the locally cached theme version.
- [ ] If out of date, trigger a background delta fetch for that specific theme resource using `since_version`.
- [ ] Upon successful update, trigger a UI rebuild via `ThemeManager`.

---

### II.6. UI — Theme Picker & Asset Handling

> Expose synced theme data in the Settings UI and handle dynamic remote assets.

- [ ] Update the Theme Selector UI to consume `available_themes` data from local storage (synced via Bootstrap).
- [ ] For dynamic asset URLs (e.g., `home_banner`): ensure they are seamlessly handled using `cached_network_image`.
- [ ] **Asset Precaching**: When delta sync returns new theme asset URLs, precache these images in the background **before** applying the theme update to prevent UI flickering.
- [ ] Always append `?dpr=<device_pixel_ratio>` when fetching Theme details.
