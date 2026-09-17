# BDD Test Scenarios — Cold Start Performance Measurement & Telemetry

## Use Case 1: End-to-End Cold Start Milestone Capture
Covers the primary happy path where the application starts normally and the profiler tracks every phase from `mainEntry` to `firstScreenInteractive`.

```gherkin
Feature: End-to-End Cold Start Telemetry Capture

  Scenario: 1.1 Complete milestone recording in chronological order
    Given the ColdStartProfiler is enabled and started at T0
    When the application executes through WidgetsFlutterBinding, dependency injection, and core initializers
    And runApp is invoked, followed by the first frame post-frame callback
    And ShellPage signals that the first screen is interactive
    Then ColdStartProfiler should have records for all milestones:
      | milestone               |
      | mainEntry               |
      | bindingInitialized      |
      | diStarted               |
      | diReady                 |
      | coreServicesStarted     |
      | coreServicesReady       |
      | runAppInvoked           |
      | firstFrameRendered      |
      | firstScreenInteractive  |
    And each milestone's elapsed time should be monotonically non-decreasing
    And totalToFcp should be strictly greater than 0 milliseconds
    And totalToTti should be greater than or equal to totalToFcp

  Scenario: 1.2 Formatted ASCII Report Generation
    Given the ColdStartProfiler has finished capturing startup milestones
    When get report or toFormattedAsciiTable is called
    Then the output string should contain table borders and headers
    And the output should include milestone durations in milliseconds
    And the output should include relative percentages totaling 100% for TTI
```

---

## Use Case 2: Micro-Benchmarking Sub-Initializers in AppInitializerImpl
Covers measuring each service during `AppInitializerImpl.init()`.

```gherkin
Feature: Micro-Benchmarking for Core Sub-Initializers

  Scenario: 2.1 Concurrent sub-initializer timing capture
    Given AppInitializerImpl is configured with LoggingInitializer, LocalizationInitializer, and ImageCacheInitializer
    When AppInitializerImpl.init is invoked
    Then ColdStartProfiler should record an individual timing entry for each initializer by name
    And each recorded sub-initializer duration should be greater than or equal to 0 milliseconds
    And the report's subInitializersDuration map should contain all 3 initializers

  Scenario: 2.2 Error isolation during sub-initializer profiling
    Given one sub-initializer throws an exception during init
    When AppInitializerImpl.init executes with profiler timing
    Then the exception should be safely caught without crashing the application
    And the duration of the failing initializer up to failure should still be recorded
    And sibling initializers should complete and be recorded normally
```

---

## Use Case 3: Toggle, Fail-Safe, and Release Mode Zero Overhead
Covers disabling profiling or handling disabled states.

```gherkin
Feature: Profiler Toggle and Fail-Safe Behavior

  Scenario: 3.1 Profiler disabled in release or via config
    Given ColdStartProfiler is instantiated with enabled set to false
    When mark, timeSync, or timeAsync are called
    Then the provided blocks should execute normally and return their expected values
    And no timestamps, records, or timeline events should be stored
    And report should return an empty or zero-duration report without throwing exceptions

  Scenario: 3.2 Idempotent finish and logging
    Given ColdStartProfiler has already called finish
    When mark or finish are called again
    Then the profiler should ignore redundant calls without throwing state errors
```

---

## Use Case 4: Flutter DevTools Timeline Task Integration
Covers emitting Timeline events for visual inspection in Flutter DevTools.

```gherkin
Feature: Flutter Timeline Integration

  Scenario: 4.1 Timeline tasks emitted during execution
    Given ColdStartProfiler is enabled
    When timeSync or timeAsync executes a named startup block
    Then a TimelineTask or Timeline synchronous event with that name should start and finish cleanly
    And no unhandled exceptions should occur even if Timeline tracing is not inspected
```
