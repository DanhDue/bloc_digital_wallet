# Design Spec: System Theme Synchronization & SSL Pinning Resiliency

**Date:** 2026-09-17  
**Epic Slug:** `system_theme_sync_and_ssl_pinning`  
**Status:** In Review (Gate 1)  
**Authors:** DanhDue ExOICTIF & AI Agent  

---

## 1. Executive Summary & Problem Context

### 1.1 Problems Addressed

1. **System Theme Desynchronization:**
   - On app startup, `ThemeManager` defaults to `ThemeMode.system` when no cached preference exists in `SharedPreferences`.
   - However, `ThemeManager.isDarkMode` simply returns `currentThemeMode == ThemeMode.dark`. When `currentThemeMode == ThemeMode.system`, `isDarkMode` evaluates to `false` even if the operating system is in Dark Mode.
   - Consequently, `SettingsBloc._onStarted` sets `SettingsUiModel.isDarkModeEnabled = false`, rendering the Settings UI Switch in the OFF position on first launch regardless of the user's OS brightness setting.
   - Furthermore, runtime OS theme switches (e.g. via Control Center or sunrise/sunset schedule) are not propagated to the Settings view if the user has not explicitly chosen a preference.

2. **SSL Pinning Handshake Failure in Non-Debug Modes:**
   - In non-debug builds (`--profile` and `--release`, or when `ENABLE_SSL_PINNING=true` in `secureFiles/stg/environment-configs.json` and `secureFiles/prd/environment-configs.json`), `AutoSslConfiguration` activates `HardenedSslPinning`.
   - `HardenedSslPinning` disables system OS CA trust (`withTrustedRoots: false`) and requires the server's leaf TLS certificate to match one of the hardcoded fingerprints provided by `NativeSecurity.getAllowedFingerprints()`.
   - The Heroku backend (`digital-wallet-93c4ba68a41d.herokuapp.com`) rotated its wildcard TLS certificate (`*.herokuapp.com` issued by Amazon RSA 2048 M01). The new active certificate fingerprint is `k9HqKHp7CLk410cHWxSuIB6q1sbvRQ3rjgSZ2NwzkvA=`.
   - Because the native C++ library (`packages/native_security`) contained only old fingerprints, TLS handshakes failed with `CERTIFICATE_VERIFY_FAILED: application verification failure(handshake.cc:320)` on bootstrap API calls.

### 1.2 User Decision & Requirements

- **First Launch (Initial State):** The app must automatically reflect the operating system's theme (Dark or Light) upon first launch, and the Settings UI switch must accurately show ON when the OS is in Dark Mode and OFF when in Light Mode.
- **User Override:** Once the user manually toggles the Dark Mode switch in the Settings UI, this preference is persisted in `SharedPreferences` as an explicit user choice (`ThemeMode.dark` or `ThemeMode.light`), overriding system-level changes.
- **SSL Pinning Hardening:** The native security layer must include the updated active server certificate fingerprint while retaining backup pins for rotation redundancy, verified across unit tests and compiled C++ binaries.

---

## 2. Architecture & Detailed Technical Design

### 2.1 Component Architecture Diagram

```mermaid
flowchart TD
    subgraph Core_Package ["packages/core"]
        TM["ThemeManager"]
        PD["PlatformDispatcher.instance"]
        SP["SharedPreferences (app_theme_mode)"]
    end

    subgraph Settings_Feature ["features/settings"]
        SB["SettingsBloc"]
        SP_UI["SettingsPage (Switch Widget)"]
        UC["ToggleDarkModeUseCase"]
    end

    subgraph Platform_Package ["packages/platform"]
        EB["AppEventBus"]
        EVT["ThemeModeChanged(isDarkMode)"]
    end

    subgraph Security_Network ["packages/native_security & packages/network"]
        CPP["native_security.cpp (get_ssl_pin_1)"]
        NS["NativeSecurity (Dart FFI)"]
        HSP["HardenedSslPinning"]
    end

    %% Theme Flow
    SP -.->|1. Load on init| TM
    PD -.->|2. platformBrightness| TM
    TM -->|3. isDarkMode (effective)| SB
    SB -->|4. Frame-0 State| SP_UI
    SP_UI -->|5. User Toggle| SB
    SB -->|6. onToggleDarkMode| UC
    UC -->|7. setThemeMode| TM
    UC -->|8. publish| EB
    EB --> EVT

    %% Security Flow
    CPP -->|FFI Lookup| NS
    NS -->|Allowed Fingerprints| HSP
```

---

### 2.2 Component Specifications

#### A. `packages/core` — `ThemeManager` Enhancements
File: `packages/core/lib/services/theme_manager.dart`

1. **Explicit Preference State:**
   - Introduce `bool _hasUserExplicitPreference = false;`
   - Expose getter: `bool get hasUserExplicitPreference => _hasUserExplicitPreference;`
2. **Effective Brightness Calculation:**
   - Update `isDarkMode` getter:
     ```dart
     bool get isDarkMode {
       if (currentThemeMode == ThemeMode.system) {
         return WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;
       }
       return currentThemeMode == ThemeMode.dark;
     }
     ```
3. **Initialization Lifecycle (`init`):**
   - Read `prefs.getInt(_themeKey)`.
   - If present:
     - Set `_hasUserExplicitPreference = true`.
     - Seed/add `ThemeMode.values[themeIndex]` to `_themeModeSubject`.
   - If absent (First Init):
     - Set `_hasUserExplicitPreference = false`.
     - Seed/add `ThemeMode.system` to `_themeModeSubject`.
     - Attach listener to `PlatformDispatcher.instance.onPlatformBrightnessChanged`:
       When triggered and `!_hasUserExplicitPreference`, emit `ThemeMode.system` to `_themeModeSubject` to refresh downstream listeners.
4. **User Preference Setter (`setThemeMode`):**
   - Save `mode.index` into `SharedPreferences` with `_themeKey`.
   - Set `_hasUserExplicitPreference = true`.
   - Add `mode` to `_themeModeSubject`.

#### B. `features/settings` — Presentation & Domain Synchronization
Files:
- `features/settings/lib/presentation/settings/settings_bloc.dart`
- `features/settings/lib/presentation/settings/settings_page.dart`
- `features/settings/lib/domain/usecases/toggle_dark_mode_usecase.dart`

1. **`SettingsBloc._onStarted` (Zero-I/O Frame-0):**
   - Initializes `SettingsUiModel.isDarkModeEnabled = _themeManager.isDarkMode`.
   - Because `ThemeManager.isDarkMode` returns the effective brightness, the switch immediately renders the accurate state on Frame 0 with zero disk latency.
2. **Dynamic System Brightness Subscription:**
   - In `_onStarted`, subscribe to `_themeManager.themeModeStream`.
   - When a theme update occurs: if `!_themeManager.hasUserExplicitPreference`, update `state.uiModel.isDarkModeEnabled = _themeManager.isDarkMode`.
3. **`ToggleDarkModeUseCase`:**
   - When the user flips the switch:
     ```dart
     Future<void> call({required bool isEnabled}) async {
       final mode = isEnabled ? ThemeMode.dark : ThemeMode.light;
       await _themeManager.setThemeMode(mode);
       _appEventBus.publish(ThemeModeChanged(isDarkMode: isEnabled));
     }
     ```
   - Persists the selection, marks user override, and broadcasts `ThemeModeChanged` to all mini-apps.

#### C. `packages/native_security` & `packages/network` — SSL Pinning Hardening
Files:
- `packages/native_security/ios/native_security/Sources/native_security_ffi/native_security.cpp`
- `packages/native_security/lib/native_security.dart`
- `packages/network/lib/ssl/hardened_ssl_pinning.dart`

1. **Active Certificate Fingerprint Rotation:**
   - Target Host: `digital-wallet-93c4ba68a41d.herokuapp.com` (`*.herokuapp.com`)
   - SHA-256 Digest (DER): `k9HqKHp7CLk410cHWxSuIB6q1sbvRQ3rjgSZ2NwzkvA=`
   - Obfuscation: XOR `0xAA` byte array in `get_ssl_pin_1()`:
     `{ 0xc1, 0x93, 0xe2, 0xdb, 0xe1, 0xe2, 0xda, 0x9d, 0xe9, 0xe6, 0xc1, 0x9e, 0x9b, 0x9a, 0xc9, 0xe2, 0xfd, 0xd2, 0xf9, 0xdf, 0xe3, 0xe8, 0x9c, 0xdb, 0x9b, 0xd9, 0xc8, 0xdc, 0xf8, 0xfb, 0x99, 0xd8, 0xc0, 0xcd, 0xf9, 0xf0, 0x98, 0xe4, 0xdd, 0xd0, 0xc1, 0xdc, 0xeb, 0x97 }`
2. **Fail-Closed Resilience:**
   - `NativeSecurityFingerprintSource` catches FFI lookup errors and returns an empty list.
   - `HardenedSslPinning` treats an empty list as fail-closed, rejecting untrusted handshakes.

---

## 3. Behavioral Scenarios (BDD Specifications)

### Feature: System Theme Detection & Settings Synchronization

```gherkin
Scenario: First app launch in OS Dark Mode reflects Dark Mode in Settings UI
  Given the app is launched for the first time without cached theme preferences
  And the operating system brightness is set to Dark Mode
  When the user navigates to the Settings page
  Then the Dark Mode toggle switch is displayed in the ON state
  And ThemeManager.isDarkMode returns true
  And ThemeManager.hasUserExplicitPreference is false

Scenario: First app launch in OS Light Mode reflects Light Mode in Settings UI
  Given the app is launched for the first time without cached theme preferences
  And the operating system brightness is set to Light Mode
  When the user navigates to the Settings page
  Then the Dark Mode toggle switch is displayed in the OFF state
  And ThemeManager.isDarkMode returns false

Scenario: User explicitly toggles Dark Mode in Settings UI
  Given the app is running in System theme mode
  When the user toggles the Dark Mode switch to ON
  Then ThemeManager.setThemeMode is invoked with ThemeMode.dark
  And the preference index is persisted to SharedPreferences
  And ThemeManager.hasUserExplicitPreference becomes true
  And ThemeModeChanged(isDarkMode: true) is published to AppEventBus

Scenario: System brightness changes at runtime before user override
  Given the app is running in System theme mode
  And the user has not explicitly set a theme preference
  When the operating system brightness toggles from Light to Dark
  Then ThemeManager notifies themeModeStream
  And SettingsBloc updates isDarkModeEnabled to true
```

### Feature: Hardened SSL Pinning Validation in Non-Debug Mode

```gherkin
Scenario: Non-debug profile build connects with matching leaf certificate
  Given the app is built in profile mode with ENABLE_SSL_PINNING=true
  When an HTTPS request is made to digital-wallet-93c4ba68a41d.herokuapp.com
  And the server presents the active certificate with fingerprint k9HqKHp7CLk410cHWxSuIB6q1sbvRQ3rjgSZ2NwzkvA=
  Then HardenedSslPinning.accepts validates the fingerprint against NativeSecurity.getAllowedFingerprints
  And the TLS handshake succeeds with HTTP status 200 OK

Scenario: Non-debug build rejects mismatched certificate
  Given the app is built in profile mode with ENABLE_SSL_PINNING=true
  When an HTTPS request encounters a certificate with an untrusted fingerprint
  Then HardenedSslPinning rejects the certificate
  And a HandshakeException is raised to prevent MITM attacks
```

---

## 4. Verification & Quality Plan

1. **Automated Unit Tests:**
   - `packages/core/test/services/theme_manager_test.dart`: Test effective brightness resolution, preference persistence, and listener callbacks.
   - `features/settings/test/presentation/settings/settings_bloc_test.dart`: Test Frame-0 UI state initialization and action dispatching.
   - `features/settings/test/domain/usecases/toggle_dark_mode_usecase_test.dart`: Verify usecase interactions with `ThemeManager` and `AppEventBus`.
   - `packages/native_security/test/native_security_test.dart`: Verify FFI symbol resolution and fingerprint format.
   - `packages/network/test/ssl/ssl_strategies_test.dart`: Verify `HardenedSslPinning.accepts` behavior with matching and mismatching certificates.

2. **Quality Gate (`@quality_check`):**
   - `melos analyze`: 0 errors, 0 warnings.
   - `melos format`: 100% formatted.
   - `./scripts/check_module_boundaries.sh`: Pass.
   - `./scripts/check_license_header.sh`: Pass.
   - C++ compilation test with `clang++`: Pass.
