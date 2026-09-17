# BDD Test Scenarios: Test Suite & Integration Test Remediation

This document provides the exhaustive Behavior-Driven Development (BDD) specification for the `test_suite_remediation` epic, structured across the mandatory 5-dimension boundary matrix.

---

## 1. Happy Paths (Normal Flow & Core Behavior)

### Scenario 1: Clean Application Boot into Shell with Isolated English Locale
- **Tags**: `[Tier C - Integration]`, `[HappyPath]`
- **Given** the test runner initializes `IntegrationTestHelper.launchApp()`
- **And** platform mocks for PackageInfo, NativeLogHostApi, and AppLinks are active
- **When** the Flutter application initializes dependencies in `onDependenciesConfigured`
- **Then** `LocalizationManager.instance.currentLocale` is reset to `'en'`
- **And** the `ShellPage` is mounted within the 15-second startup timeout
- **And** `HomeDashboardPage` is visible at tab index `0`.

### Scenario 2: Deep Link Navigation across 3-Tab Shell
- **Tags**: `[Tier C - Integration]`, `[HappyPath]`
- **Given** the app is running on `ShellPage` with 3 configured tabs (Home, Scanner, Settings)
- **When** a deep link URI `d3nexus://scanner` is dispatched via `DeepLinkCoordinator`
- **Then** the `ShellBloc` transitions to tab index `1`
- **And** `ScannerPage` is mounted on the screen
- **When** a deep link URI `d3nexus://settings` is dispatched
- **Then** the `ShellBloc` transitions to tab index `2`
- **And** `SettingsPage` is mounted on the screen
- **When** an unrecognized deep link URI `d3nexus://unknown/path` is dispatched
- **Then** the `ShellBloc` gracefully falls back to tab index `0` (`HomeDashboardPage`).

### Scenario 3: Live OTA Translation Download and UI Update for Japanese on Staging
- **Tags**: `[Tier C - Integration]`, `[HappyPath]`
- **Given** the app is launched on Staging (`--dart-define-from-file=secureFiles/stg/environment-configs.json`)
- **And** the user has navigated to the `SettingsPage`
- **When** the user opens the language picker bottom sheet
- **And** taps the Japanese language option (`ja_JP`)
- **Then** the `CustomLoadingWidget` mounts on screen within `100ms`
- **And** a real HTTP request `GET /api/v1/translations/ja` is dispatched to Heroku Staging server
- **And** upon receiving HTTP 200 OK, the loading dialog is dismissed
- **And** the Settings page UI text updates dynamically to Japanese (`設定`).

---

## 2. Edge Cases & Boundaries

### Scenario 4: Rapid Language Switching (Race Condition)
- **Tags**: `[Tier C - Integration]`, `[EdgeCase]`
- **Given** the user is on the language picker bottom sheet
- **When** the user rapidly selects Korean (`ko_KR`) and immediately selects Japanese (`ja_JP`) within `200ms`
- **Then** the in-flight request for Korean is superseded or safely ignored
- **And** the final UI state settles strictly on Japanese
- **And** no corrupted or mixed-language state is displayed.

### Scenario 5: Cold-Start Language Restoration from SharedPreferences
- **Tags**: `[Tier C - Integration]`, `[EdgeCase]`
- **Given** `SharedPreferences` contains `saved_language_code = 'ja_JP'`
- **When** the application is launched from a clean cold-start
- **Then** the startup frames settle across the Lottie splash animation without timing out
- **And** `LocalizationManager.instance.currentLocale` resolves to `'ja'` upon reaching `ShellPage`
- **And** navigating to `SettingsPage` displays Japanese headers.

---

## 3. State Transitions

### Scenario 6: Shell Navigation State Transitions (3 Tabs)
- **Tags**: `[Tier A - Unit]`, `[StateTransition]`
- **Given** `ShellBloc` is initialized with default state `currentTabIndex = 0`
- **When** `ShellAction.tabChanged(1)` is added
- **Then** `ShellState(currentTabIndex: 1)` is emitted
- **When** `ShellAction.tabChanged(2)` is added
- **Then** `ShellState(currentTabIndex: 2)` is emitted
- **When** `ShellAction.tabChanged(0)` is added
- **Then** `ShellState(currentTabIndex: 0)` is emitted
- **When** `ShellAction.tabChanged(99)` is added (out of bounds)
- **Then** `currentTabIndex` is clamped to valid range `[0, 2]`.

### Scenario 7: Language Picker BottomSheet Selection State Transition
- **Tags**: `[Tier A - Unit]`, `[StateTransition]`
- **Given** `SettingsBloc` is in `SettingsStatus.success` with available languages
- **When** `SettingsAction.changeLanguage(languageCode: 'ja')` is dispatched for an uncached language
- **Then** `SettingsBloc` emits `SettingsState(status: SettingsStatus.loading)`
- **And** upon stream completion emits `SettingsState(status: SettingsStatus.success)`.

---

## 4. Async & Race Conditions

### Scenario 8: Loading Dialog Mounting & Visual Frame Progression
- **Tags**: `[Tier C - Integration]`, `[AsyncRace]`
- **Given** an uncached language is tapped in `change_language_test.dart`
- **When** `tester.pump(Duration(milliseconds: 100))` is executed
- **Then** `find.byType(CustomLoadingWidget)` evaluates to exactly one widget
- **And** the dialog remains mounted while the network stream is active.

### Scenario 9: Error SnackBar Display Persistence Without Premature Dismissal
- **Tags**: `[Tier C - Integration]`, `[AsyncRace]`
- **Given** a network failure occurs during language download in `language_edge_cases_test.dart`
- **When** `CustomLoadingWidget` dismisses
- **Then** the test framework polls with `pump(200ms)` without calling `pumpAndSettle()`
- **And** `pumpUntil(find.byType(SnackBar))` discovers the error toast on screen
- **And** the toast contains the expected localized failure message.

---

## 5. Failures & Resilience

### Scenario 10: Graceful Handling of Remote Translation Download Failure
- **Tags**: `[Tier C - Integration]`, `[Resilience]`
- **Given** the remote translation endpoint returns HTTP 500 or network is unreachable
- **When** the translation download fails
- **Then** the loading dialog is dismissed cleanly
- **And** an error `SnackBar` is presented to the user
- **And** the active application locale remains unchanged (fallback to previous valid locale).

### Scenario 11: Heroku Bootstrap Cold-Start Interception
- **Tags**: `[Tier C - Integration]`, `[Resilience]`
- **Given** integration tests are running against the Staging environment
- **When** `Dio` receives a request targeting `/api/v1/settings/sync/bootstrap`
- **Then** `IntegrationTestHelper`'s interceptor intercepts the call
- **And** resolves immediately with HTTP 200 containing `stale_translations: []`
- **And** prevents background OTA download loops from stalling UI pumps.

### Scenario 12: Package Test Suite Monorepo Governance
- **Tags**: `[Tier B - Governance]`, `[Resilience]`
- **Given** `melos exec -- fvm flutter test` is executed across all packages in `packages/*` and `features/*`
- **When** `packages/framework` and `packages/native_security` contain test files
- **Then** `fvm flutter test` executes cleanly in every package
- **And** Melos exits with code `0`.
