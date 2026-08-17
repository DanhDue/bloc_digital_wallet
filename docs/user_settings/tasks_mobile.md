# Mobile App Tasks: Dynamic Configuration & User Preferences Sync

This document outlines the main tasks that the Mobile App team needs to implement to support the Dynamic Configuration, User Preferences Sync, and Delta Versioning features.

> **Related Documents**:
> - [Dynamic Configuration HLD](./dynamic_configuration_hld.md)
> - [Dynamic Configuration API](./dynamic_configuration_api.md)
> - [User Preferences Sync API](./user_preferences_sync_api.md)

---

## 1. App Startup & Sync (Bootstrap)
- [ ] **Bundled Fallback Assets**: Ensure the app binary ships with a default `1.0.0` JSON translation and theme in the `assets/` folder. Load this first on a clean install before making network requests to prevent a blank UI if offline.
- [ ] Implement API call to `POST /api/v1/sync/bootstrap` during app initialization (cold start).
- [ ] **Guest State Handling**: If user is not logged in, call the API without token. Fallback to System Locale/Theme if `user_preferences` is null.
- [ ] Pass `cached_versions` of all locally stored translations and themes to the bootstrap API.
- [ ] Handle response: apply `user_preferences` (language, theme) if different from local state.
  - **Theme Precedence**: Implement logic to prioritize `active_campaign_theme_id` > `user_preferences.selected_theme_id` > System Default.
- [ ] Handle response: fetch stale resources based on the returned URLs (`fetch_url` or `full_fetch_url`).
- [ ] Handle response: purge resources marked in `removed_resources` from local cache.
  - **Active Deletion Fallback**: If the currently active theme is in `removed_resources`, immediately fallback to `System Default` to prevent UI crash.
- [ ] Handle response: update the lists of `available_languages` and `available_themes` for UI pickers.

## 2. Delta Versioning & Data Integrity
- [ ] **ConfigurationSyncManager**: Implement a queue/mutex lock for config sync. Ensure that Bootstrap, Push Notifications, and User interactions do not read/write local JSON files concurrently.
- [ ] Update data layer to parse the new API response structure for Translation and Theme details (`mode`, `version`, `since_version`, `checksum`, `changes`, `deleted_keys`).
- [ ] Implement Deep Merge logic:
  - If `mode == "full"`, replace the entire local cache for that resource.
  - If `mode == "delta"`, recursively merge `changes` into the existing local JSON tree.
  - Remove all keys specified in `deleted_keys` from the local tree.
- [ ] **Checksum Validation**: After a Delta merge, calculate the MD5/SHA-256 hash of the resulting JSON string. Compare it with the API's `checksum`. If mismatched, delete the local file and force a Full Fetch.
- [ ] Save the updated `version` string in local storage to be used in future `since_version` requests.

## 3. Slang Dynamic Overriding (Multi-Package)
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

## 4. Theme Tailor Dynamic Overriding (Multi-Package)
- [ ] **JSON Parsing Logic**: Implement a mapper in `packages/ui_kit` to parse the `mergedJson` Map into `ThemeTailor` generated classes (e.g., `AppTheme.fromJson(mergedJson)`). Note: `theme_tailor` doesn't generate `fromJson` out of the box, so custom factories or `json_serializable` integration may be needed.
- [ ] **Core ThemeManager**: Implement `ThemeManager.applyDynamicTheme(Map<String, dynamic> mergedJson)` to parse the new theme and push the resulting `ThemeData` (or `ThemeExtension`) into a Stream/State.
- [ ] **App Layer Reconstruction**: In the root App widget (`lib/main.dart` or `App.dart`), wrap `MaterialApp` in a builder that listens to `ThemeManager`. When the theme changes, rebuild `MaterialApp` with the new `ThemeData(extensions: [newAppTheme])`.
- [ ] **Automatic Propagation**: Because `theme_tailor` relies on Flutter's `Theme.of(context).extension<AppTheme>()`, independent feature packages do not need explicit override calls. Rebuilding the root `MaterialApp` will automatically propagate the new colors/styles down the widget tree to all packages.

## 5. User Preferences Synchronization
- [ ] When the user manually changes the app language or theme via Settings, call `PUT /api/v1/users/me/preferences` to sync to the server.
- [ ] Ensure local UI updates instantly without waiting for the API response.
- [ ] **Offline Sync Queue**: If the network is unavailable when `PUT /preferences` is called, queue the request and retry in the background when connectivity is restored.

## 6. Push Notification Integration
- [ ] Listen for Silent Push Notifications (Data Messages) from FCM/APNS.
- [ ] Parse payload for `type: "config_update"`, `resource`, `resource_id`, and `new_version`.
- [ ] Compare `new_version` with locally cached version.
- [ ] If out of date, trigger a background fetch for that specific resource using `since_version` (Delta mode).
- [ ] Trigger UI rebuild via `LocalizationManager` or `ThemeManager` upon successful update.

## 7. UI Updates & Asset Handling
- [ ] Update the App's Theme/Language selector UI to consume `available_languages` and `available_themes` data from local storage (synced via Bootstrap).
- [ ] For Themes: ensure dynamic asset URLs (e.g., `home_banner`) are seamlessly handled using `cached_network_image`.
- [ ] **Asset Precaching**: When delta sync returns new theme asset URLs, precache these images in the background before applying the theme update to prevent UI flickering.
- [ ] Always append `?dpr=<device_pixel_ratio>` when fetching Theme details.
