# BDD Scenarios — Cold Start & Graphics Optimization

This document defines the behavioral specifications for the `cold_start_optimization` epic across the **Mandatory 5-Dimension Boundary Matrix** in standard Gherkin syntax.

---

## Use Case 1: Cold Start Bootstrapping & First Frame Rendering

### 1. Happy Paths
```gherkin
@TierA @Unit @ColdStart
Scenario: Cold start bootstrapping executes critical path in parallel and reaches Frame 0
  Given the mobile application is cold launched from the OS launcher
  When main() invokes WidgetsFlutterBinding.ensureInitialized()
  And Future.wait() parallelizes SharedPreferences resolution, Core DI, and ThemeManager
  Then runApp() is called within 300 milliseconds of main entry
  And the initial Frame 0 renders the active tab without blocking on secondary services
```

### 2. Edge Cases & Boundaries
```gherkin
@TierA @Unit @Theme
Scenario: Theme mode preference has not been set by user
  Given SharedPreferences contains no saved theme key "app_theme_mode"
  When ThemeManager.instance.init() is executed
  Then the currentThemeMode defaults to ThemeMode.system
  And the initial theme stream emits ThemeMode.system without delay
```

### 3. State Transitions
```gherkin
@TierA @Unit @Bootstrapping
Scenario: Transition from uninitialized to initialized state
  Given AppInitializer has registered all critical and deferred initializers
  When init() is invoked on AppInitializerImpl
  Then each initializer in the composite executes its initialization logic
  And failures in individual deferred initializers do not prevent the app from remaining operational
```

### 4. Async & Race Conditions
```gherkin
@TierC @Integration @DeepLink
Scenario: Inbound deep link arrives while deferred initialization is still in flight
  Given the application was cold launched via an external deep link URI "https://wallet.app/settings"
  And DeepLinkCoordinator is still completing its asynchronous background setup
  When the initial URI is captured by the underlying platform channel
  Then the URI is staged safely in stagedInitialLink without dropping
  And once ShellPage triggers markRouterReady(), the staged URI is dispatched to the router
```

### 5. Failures & Resilience
```gherkin
@TierA @Unit @Localization
Scenario: Dynamic translation JSON cache is corrupted or unavailable during startup
  Given the device is offline or the cached dynamic translation JSON file is unreadable
  When LocalizationInitializer loads the saved locale
  Then the system falls back seamlessly to the bundled static Slang translations
  And no fatal exceptions are thrown to the user
```

---

## Use Case 2: Lazy Navigation Shell (LazyIndexedStack)

### 1. Happy Paths
```gherkin
@TierA @Unit @ShellNavigation
Scenario: ShellPage with LazyIndexedStack mounts only the default active tab on Frame 0
  Given ShellConfig specifies defaultTabIndex as 2
  And children contain [HomeDashboardPage, ScannerPage, SettingsPage]
  When ShellPage is mounted and rendered on screen
  Then only SettingsPage at index 2 is instantiated and built
  And HomeDashboardPage at index 0 is rendered as SizedBox.shrink
  And ScannerPage at index 1 is rendered as SizedBox.shrink
```

```gherkin
@TierC @Integration @ShellNavigation
Scenario: Tapping an inactive tab mounts it on-demand while preserving previously mounted tab state
  Given ShellPage is displaying SettingsPage at index 2
  And the user has customized settings state on SettingsPage
  When the user taps Tab 0 (Home) on CustomBottomNavBar
  Then HomeDashboardPage at index 0 is instantiated and displayed
  And SettingsPage at index 2 remains alive in the widget tree with its state preserved
```

### 2. Edge Cases & Boundaries
```gherkin
@TierA @Unit @ShellNavigation
Scenario: Target tab index is outside the valid range of children
  Given LazyIndexedStack has 3 children
  When the parent supplies an index of 5 or -1
  Then LazyIndexedStack clamps the active index to the valid child bounds
  And does not throw an RangeError
```

```gherkin
@TierA @Unit @ShellNavigation
Scenario: Rapid consecutive tab clicks do not duplicate child elements
  Given LazyIndexedStack is rendering index 0
  When the user taps Tab 1, then Tab 2, then Tab 1 within 50 milliseconds
  Then each distinct tab index is mounted exactly once in the internal activated set
  And no duplicate keys or memory leaks occur
```

### 3. State Transitions
```gherkin
@TierA @Unit @ShellNavigation
Scenario: Tab index changes update the visible child while preserving scroll position
  Given SettingsPage at index 2 is scrolled to offset 350.0
  When the user switches to Tab 0 and subsequently returns to Tab 2
  Then SettingsPage retains its scroll position of 350.0 without jumping to top
```

### 4. Async & Race Conditions
```gherkin
@TierA @Unit @ShellNavigation
Scenario: Back pressed action while switching tabs preserves navigation history
  Given the user navigates from Settings (Tab 2) to Home (Tab 0)
  When the system back button is invoked
  Then ShellBloc processes the back action without race condition crashes
```

### 5. Failures & Resilience
```gherkin
@TierA @Unit @ShellNavigation
Scenario: One of the inactive tabs encounters a build error
  Given ScannerPage encounters an unexpected error during its on-demand lazy instantiation
  When the user taps Tab 1
  Then MiniAppErrorBoundary catches the failure
  And displays an inline error view without crashing the entire Super-App shell
```

---

## Use Case 3: GPU Layer Isolation & Shadow Caching

### 1. Happy Paths
```gherkin
@TierA @Unit @UI
Scenario: CustomBottomNavBar is isolated within a RepaintBoundary
  Given CustomBottomNavBar is rendered at the bottom of the ShellPage
  When the page content inside the body scrolls vertically
  Then CustomBottomNavBar's RenderRepaintBoundary does not repaint its layer
  And the GPU reuses the cached layer texture for the navigation bar and QR button
```

```gherkin
@TierA @Unit @UI
Scenario: SettingsSectionWidget isolates card shadow within a RepaintBoundary
  Given SettingsPage contains 4 SettingsSectionWidget containers
  When a single switch inside the Developer section is toggled
  Then only that specific switch row requests a repaint
  And the other 3 SettingsSectionWidget cards do not re-rasterize their BoxShadow
```

### 2. Edge Cases & Boundaries
```gherkin
@TierA @Unit @UI
Scenario: Zero blur radius shadow fallback
  Given a section configuration with blurRadius of 0
  When SettingsSectionWidget renders
  Then the box shadow renders as a crisp single-pass rectangle without invoking blur shaders
```

### 3. State Transitions
```gherkin
@TierA @Unit @UI
Scenario: Theme switch from Light to Dark mode invalidates cached shadow layers correctly
  Given the application is running in Light mode with light shadow colors
  When the user toggles Dark Mode to true
  Then the RepaintBoundary layers for cards and bottom nav bar invalidate their cache
  And re-rasterize with dark theme shadow colors on the subsequent frame
```

### 4. Async & Race Conditions
```gherkin
@TierA @Unit @UI
Scenario: Fast inertial scrolling through multiple card sections
  Given SettingsPage has multiple sections totaling height greater than viewport
  When an aggressive flick gesture creates high velocity scrolling
  Then frame rendering times remain consistently below 12 milliseconds
  And no raster thread drops below 60 frames per second
```

### 5. Failures & Resilience
```gherkin
@TierA @Unit @UI
Scenario: Device low-memory pressure warning received during heavy animation
  Given the mobile device triggers an OS low-memory warning (MemoryPressureObserver)
  When the system purges unused image cache buffers
  Then the cached RepaintBoundary textures continue rendering without visual artifacts
```
