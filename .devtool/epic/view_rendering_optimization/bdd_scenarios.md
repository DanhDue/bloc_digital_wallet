# BDD Scenarios: View Rendering Optimization

- **Epic**: `view_rendering_optimization`
- **Related Spec**: [2026-09-17-view-rendering-optimization-design.md](2026-09-17-view-rendering-optimization-design.md)
- **Status**: Ready for Implementation
- **Coverage**: Mandatory 5-Dimension Boundary Matrix

---

## Dimension 1: Happy Paths

### Scenario 1.1: Single Scaffold Mount on Home Dashboard [Tier C - Integration]
- **Given** the app launches from cold start on the initial tab (Home)
- **When** `ShellPage` renders the active tab
- **Then** the widget tree contains exactly one `Scaffold` instance
- **And** `HomeDashboardPage` displays the app title, icon, and description without nesting another `Scaffold`

### Scenario 1.2: Static Cached ThemeData Usage [Tier A - Unit]
- **Given** `AppThemeData.lightTheme` and `AppThemeData.darkTheme` are defined as cached instances
- **When** `MaterialApp.router` is built in `main.dart`
- **Then** `theme` references the cached `AppThemeData.lightTheme`
- **And** `darkTheme` references the cached `AppThemeData.darkTheme`
- **And** no new `ThemeData` instance is allocated during the build pass

### Scenario 1.3: Two-Stage First Paint for Bottom Navigation Bar [Tier A - Unit]
- **Given** `CustomBottomNavBar` is rendered during Frame 0
- **When** the first layout pass completes before post-frame callbacks execute
- **Then** the navigation bar container renders with a flat background and without `BoxShadow`
- **When** `WidgetsBinding.instance.addPostFrameCallback` fires for Frame 1
- **Then** the `BoxShadow` list with blurRadius 10 is enabled on the outer bar
- **And** the elevated center QR button enables its `BoxShadow` with blurRadius 12

---

## Dimension 2: Edge Cases & Boundaries

### Scenario 2.1: Instant Tab Switching During Frame 0 [Tier A - Unit]
- **Given** the app is rendering Frame 0 with shadows disabled
- **When** a user immediately taps on a navigation tab before Frame 1 executes
- **Then** `onTap` triggers `ShellAction.tabChanged` properly without exceptions
- **And** the state transitions smoothly with shadows enabled on Frame 1

### Scenario 2.2: Extreme Screen Heights and Insets [Tier A - Unit]
- **Given** a device with non-standard status bar or notch insets (`MediaQueryData`)
- **When** `HomeDashboardPage` renders without an internal `Scaffold`
- **Then** top padding and safe areas are respected cleanly via `SafeArea`
- **And** no text or icon clips into the device status bar

---

## Dimension 3: State Transitions

### Scenario 3.1: Theme Mode Switch with Cached ThemeData [Tier A - Unit]
- **Given** the app is running in light mode using `AppThemeData.lightTheme`
- **When** `ThemeManager.instance.themeModeStream` emits `ThemeMode.dark`
- **Then** `MaterialApp` switches cleanly to `AppThemeData.darkTheme`
- **And** existing widget trees rebuild with dark theme tokens without throwing null extension errors

### Scenario 3.2: Stream Deduplication with `distinct()` [Tier A - Unit]
- **Given** `themeModeStream` and `localeStream` have duplicate consecutive events emitted
- **When** the streams are listened to in `main.dart` with `.distinct()`
- **Then** `StreamBuilder` does not trigger redundant builds of the `MaterialApp` root

---

## Dimension 4: Async / Race Conditions

### Scenario 4.1: Rapid Post-Frame Re-renders [Tier A - Unit]
- **Given** `CustomBottomNavBar` mounts and registers a post-frame callback
- **When** a re-render occurs before the post-frame callback finishes
- **Then** no duplicate callback or memory leak occurs
- **And** `mounted` check prevents calling `setState` on unmounted widgets

---

## Dimension 5: Failures & Resilience

### Scenario 5.1: Error Boundary in Home Dashboard [Tier C - Integration]
- **Given** `HomeDashboardPage` is wrapped with `MiniAppErrorBoundary`
- **When** an unhandled layout or rendering exception occurs within `HomeDashboardPage`
- **Then** `MiniAppErrorBoundary` catches the error and displays the recovery fallback UI
- **And** the outer `ShellPage` and `CustomBottomNavBar` remain responsive
