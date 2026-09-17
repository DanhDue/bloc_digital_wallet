# BDD Test Specifications: System Theme Synchronization & SSL Pinning

**Epic**: `system_theme_sync`  
**Living Specification**: Behavioral contracts covering the Mandatory 5-Dimension Boundary Matrix.

---

## Use Case 1: First Application Launch & OS Theme Detection

### 1. Happy Paths
```gherkin
Scenario: First app launch under OS Dark Mode displays ON toggle in Settings
  Given the app is launched fresh with no prior 'app_theme_mode' entry in SharedPreferences
  And the host operating system platformBrightness is Brightness.dark
  When ThemeManager.init() completes
  Then ThemeManager.currentThemeMode equals ThemeMode.system
  And ThemeManager.hasUserExplicitPreference is false
  And ThemeManager.isDarkMode evaluates to true
  And SettingsBloc emits Frame-0 SettingsUiModel with isDarkModeEnabled equal to true
  And SettingsPage renders the Dark Mode toggle switch in the ON position

Scenario: First app launch under OS Light Mode displays OFF toggle in Settings
  Given the app is launched fresh with no prior 'app_theme_mode' entry in SharedPreferences
  And the host operating system platformBrightness is Brightness.light
  When ThemeManager.init() completes
  Then ThemeManager.currentThemeMode equals ThemeMode.system
  And ThemeManager.hasUserExplicitPreference is false
  And ThemeManager.isDarkMode evaluates to false
  And SettingsBloc emits Frame-0 SettingsUiModel with isDarkModeEnabled equal to false
  And SettingsPage renders the Dark Mode toggle switch in the OFF position
```

### 2. Edge Cases & Boundaries
```gherkin
Scenario: SharedPreferences contains an out-of-range integer index
  Given SharedPreferences contains 'app_theme_mode' with value 999
  When ThemeManager.init() is invoked
  Then ThemeManager catches the RangeError gracefully
  And falls back to ThemeMode.system without throwing an unhandled exception
  And ThemeManager.hasUserExplicitPreference is false
```

### 3. State Transitions
```gherkin
Scenario: Transition from System state to explicit User Dark state
  Given ThemeManager is currently in ThemeMode.system
  And ThemeManager.hasUserExplicitPreference is false
  When ThemeManager.setThemeMode(ThemeMode.dark) is called
  Then ThemeManager.currentThemeMode transitions to ThemeMode.dark
  And ThemeManager.hasUserExplicitPreference transitions to true
  And SharedPreferences stores 'app_theme_mode' with value 2
  And themeModeStream emits ThemeMode.dark to all active listeners
```

### 4. Async & Race Conditions
```gherkin
Scenario: Rapid concurrent calls to ThemeManager.init() execute idempotently
  Given ThemeManager has not yet finished initializing
  When ThemeManager.init() is invoked concurrently from multiple isolates or tasks
  Then only one SharedPreferences read is dispatched
  And themeModeStream does not emit duplicate identical state transitions
```

### 5. Failures & Resilience
```gherkin
Scenario: SharedPreferences throws disk I/O failure during initialization
  Given SharedPreferences throws a PlatformException during getInstance()
  When ThemeManager.init() runs
  Then the error is logged via Talker or caught safely
  And ThemeManager falls back to ThemeMode.system
  And Frame-0 UI renders without application crash
```

---

## Use Case 2: Explicit User Override & Settings View Interactions

### 1. Happy Paths
```gherkin
Scenario: User manually toggles Dark Mode to OFF in Settings UI
  Given the SettingsPage is open and displaying isDarkModeEnabled equal to true
  When the user taps the toggle switch to turn it OFF
  Then SettingsBloc receives SettingsAction.toggleDarkMode(isEnabled: false)
  And SettingsBloc emits updated state with isDarkModeEnabled equal to false
  And ToggleDarkModeUseCase invokes ThemeManager.setThemeMode(ThemeMode.light)
  And ToggleDarkModeUseCase publishes ThemeModeChanged(isDarkMode: false) to AppEventBus
  And SharedPreferences stores key 'app_theme_mode' equal to 1
```

### 2. Edge Cases & Boundaries
```gherkin
Scenario: User toggles switch to the same current state
  Given the Dark Mode switch is currently ON
  When SettingsBloc receives SettingsAction.toggleDarkMode(isEnabled: true)
  Then the UI state remains isDarkModeEnabled equal to true
  And the operation completes without duplicate network or redundant bus events
```

### 3. State Transitions
```gherkin
Scenario: Subsequent app launch restores explicit user preference
  Given the user previously saved Dark Mode (value 2) in SharedPreferences
  When the app restarts and ThemeManager.init() executes
  Then ThemeManager.currentThemeMode is set to ThemeMode.dark
  And ThemeManager.hasUserExplicitPreference is set to true
  And SettingsBloc._onStarted initializes isDarkModeEnabled equal to true
  Regardless of whether the host operating system is in Light or Dark Mode
```

### 4. Async & Race Conditions
```gherkin
Scenario: Rapid double toggling of the Dark Mode switch in Settings UI
  Given the SettingsPage is active
  When the user taps the toggle switch twice in rapid succession (ON -> OFF -> ON)
  Then SettingsBloc processes both actions in order
  And the final state settles at isDarkModeEnabled equal to true
  And SharedPreferences reflects the final intent without race conditions
```

### 5. Failures & Resilience
```gherkin
Scenario: SharedPreferences write fails when persisting user toggle
  Given SharedPreferences fails to write 'app_theme_mode'
  When ToggleDarkModeUseCase calls setThemeMode(ThemeMode.dark)
  Then the in-memory stream still updates to maintain responsive UI
  And the failure is caught and logged without crashing the UI isolate
```

---

## Use Case 3: Runtime Operating System Brightness Transitions

### 1. Happy Paths
```gherkin
Scenario: System brightness changes while user has no explicit preference
  Given ThemeManager is initialized with ThemeMode.system
  And ThemeManager.hasUserExplicitPreference is false
  And SettingsPage is currently visible on screen showing Dark Mode OFF
  When the host operating system platformBrightness changes from light to dark
  And PlatformDispatcher triggers onPlatformBrightnessChanged
  Then ThemeManager broadcasts the brightness change on themeModeStream
  And SettingsBloc updates isDarkModeEnabled to true dynamically
  And the toggle switch animates to the ON position without page reload
```

### 2. Edge Cases & Boundaries
```gherkin
Scenario: System brightness changes after user has set an explicit preference
  Given the user has explicitly set Dark Mode to OFF (ThemeMode.light)
  And ThemeManager.hasUserExplicitPreference is true
  When the host operating system platformBrightness changes from light to dark
  Then ThemeManager ignores the platform brightness event
  And the app remains in ThemeMode.light
  And SettingsPage switch remains in the OFF position
```

### 3. State Transitions
```gherkin
Scenario: Disposing ThemeManager cleans up platform dispatcher listeners
  Given ThemeManager is actively listening to onPlatformBrightnessChanged
  When ThemeManager.dispose() is called
  Then the subject is closed
  And no further callbacks are dispatched to closed streams
```

---

## Use Case 4: Hardened SSL Pinning in Non-Debug Modes

### 1. Happy Paths
```gherkin
Scenario: Successful HTTPS handshake against backend with rotated certificate
  Given the application is compiled in profile or release mode with ENABLE_SSL_PINNING=true
  And NativeSecurity.getAllowedFingerprints() contains "k9HqKHp7CLk410cHWxSuIB6q1sbvRQ3rjgSZ2NwzkvA="
  When an HTTPS request is initiated to "https://digital-wallet-93c4ba68a41d.herokuapp.com/api/v1/settings/sync/bootstrap"
  And the server presents the leaf certificate for "*.herokuapp.com"
  Then HardenedSslPinning.accepts matches the leaf SHA-256 fingerprint
  And the TLS handshake succeeds with HTTP status 200 OK
```

### 2. Edge Cases & Boundaries
```gherkin
Scenario: Server presents an unpinned intermediate or root certificate
  Given HardenedSslPinning is configured with SecurityContext(withTrustedRoots: false)
  When badCertificateCallback is evaluated for an intermediate CA certificate
  Then HardenedSslPinning strictly checks the allowed list
  And rejects any certificate whose specific leaf fingerprint is not pinned
```

### 3. Failures & Resilience
```gherkin
Scenario: Man-in-the-middle proxy presents forged certificate
  Given the app is executing with HardenedSslPinning enabled
  When an interception proxy presents a forged certificate
  Then HardenedSslPinning.accepts evaluates to false
  And Talker logs "SSL Pinning failed for digital-wallet-93c4ba68a41d.herokuapp.com — fingerprint mismatch"
  And DioException wrapping HandshakeException is thrown, preventing credential exfiltration
```
