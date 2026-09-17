# BDD Test Scenarios — Startup Rendering & Shell Lazy Builder Optimization

## Use Case 1: Lazy Builder Tab Instantiation
Covers lazy builder evaluation in `LazyIndexedStack` when starting on the required tab index.

```gherkin
Feature: Lazy Builder Tab Instantiation

  Scenario: 1.1 Only active tab builder is evaluated on initial mount
    Given a LazyIndexedStack configured with itemCount 3 and default index 2
    When the widget is pumped into the element tree
    Then the itemBuilder should be invoked exactly once for index 2
    And the itemBuilder should NOT be invoked for index 0 or index 1
    And the rendered tree should contain the widget for index 2 and SizedBox.shrink for indices 0 and 1

  Scenario: 1.2 Inactive tab builder is triggered only upon switching
    Given LazyIndexedStack is mounted at index 2 with only child 2 active
    When the index is updated to 0
    Then the itemBuilder should be invoked for index 0
    And both child 0 and child 2 should now be preserved in the stack
    And child 1 should remain unbuilt as SizedBox.shrink

  Scenario: 1.3 Out-of-bounds index handling
    Given a LazyIndexedStack with itemCount 3
    When an out-of-bounds index -1 or 5 is provided
    Then the index should be safely clamped between 0 and 2 without throwing an exception
```

---

## Use Case 2: SettingsBloc Frame-0 Instant Render & Detached Background Sync
Covers non-blocking state emission and detached background execution in `SettingsBloc`.

```gherkin
Feature: SettingsBloc Frame-0 Instant Render

  Scenario: 2.1 Synchronous Frame-0 state emission
    Given SettingsBloc is instantiated
    When SettingsAction.started() is dispatched
    Then SettingsBloc should synchronously emit SettingsStatus.success with bundled initialUiModel
    And the state emission should complete within the initial event-loop tick
    And the UI should not enter a modal loading state

  Scenario: 2.2 Detached background package info and bootstrap execution
    Given SettingsBloc has emitted the Frame-0 initialUiModel
    When the background execution completes successfully
    Then SettingsBloc should emit an updated uiModel with actual package version and dynamic languages
    And the previous UI state should seamlessly update without re-rendering the whole page

  Scenario: 2.3 Network failure resilience during background bootstrap
    Given SettingsBloc is executing the detached background bootstrap
    When the HTTP bootstrap endpoint fails with a SocketException or timeout
    Then the error should be silently caught without throwing an unhandled exception
    And the application should continue functioning normally using bundled settings and languages
```

---

## Use Case 3: ShellPage Navigation & State Preservation
Covers integration with `ShellPage` using `defaultTabIndex = 2`.

```gherkin
Feature: ShellPage Integration with Lazy Builder

  Scenario: 3.1 Initial boot mounts SettingsPage without constructing Home or Scanner
    Given ShellConfig.defaultTabIndex is 2
    When ShellPage is mounted during application startup
    Then SettingsPage should be mounted and interactive
    And HomeDashboardPage should not exist in the element tree
    And ScannerPage should not exist in the element tree

  Scenario: 3.2 Switching between tabs retains state without rebuilding active views
    Given ShellPage is active on SettingsPage (tab 2)
    When the user navigates to Home (tab 0) and enters some state
    And the user navigates back to Settings (tab 2)
    Then SettingsPage state should be completely retained without resetting scroll or inputs
```

---

## Use Case 4: Cold Start Telemetry Budget & Performance Sanity
Covers verified reduction in cold start duration.

```gherkin
Feature: Performance Telemetry Verification

  Scenario: 4.1 Cold start FCP budget satisfaction
    Given the application launches on a device or simulator
    When ShellPage post-frame callback fires
    Then ColdStartReport.totalToFcp should be strictly less than 280 milliseconds
    And ColdStartReport.widgetTreeDuration should be strictly less than 200 milliseconds
    And ColdStartProfiler should output the structured ASCII report to Talker
```
