---
id: "task_03_host_app_instrumentation"
status: "todo"
priority: "high"
assignee: null
epic: "cold_start_measurement"
dueDate: null
created: "2026-09-17T17:15:00+07:00"
modified: "2026-09-17T17:15:00+07:00"
completedAt: null
labels: ["instrumentation", "telemetry", "host_app"]
order: "a3"
---

# Task 03: Host App Instrumentation & Logging in lib/main.dart & lib/shell/

## Context & Objectives
Instrument the host application's cold start path in `lib/main.dart` and `lib/shell/shell_page.dart`. The profiler must record macro milestones (`mainEntry`, `bindingInitialized`, `diStarted`, `diReady`, `coreServicesStarted`, `coreServicesReady`, `runAppInvoked`, `firstFrameRendered`, `firstScreenInteractive`), finish telemetry collection, and emit a formatted ASCII report to the developer console and `Talker` logger.

---

## BDD Acceptance Criteria

```gherkin
Feature: Host App Startup Instrumentation

  Scenario: Full startup milestone progression
    When main executes in lib/main.dart
    Then ColdStartProfiler should be started at the first line of main
    And bindingInitialized should be marked after WidgetsFlutterBinding.ensureInitialized
    And diStarted and diReady should enclose configureDependencies
    And coreServicesStarted and coreServicesReady should enclose ThemeManager and AppInitializer init
    And runAppInvoked should be marked immediately prior to runApp

  Scenario: First Contentful Paint and First Screen Interactive capture
    When the initial frame is rendered
    Then WidgetsBinding.instance.addPostFrameCallback should record firstFrameRendered (FCP)
    And ShellPage post-frame callback should record firstScreenInteractive (TTI)
    And profiler.finish should be called
    And profiler.logReport should print the ASCII summary to Talker and console
```

---

## TDD Implementation Steps

### 1. QA Red Team (Test Authoring)
- Create widget and host integration test in `test/shell/shell_page_telemetry_test.dart`.
- Assert that mounting `ShellPage` triggers `firstScreenInteractive` on `ColdStartProfiler`.

### 2. TDD Master (Implementation)
- In `lib/main.dart`:
  - `ColdStartProfiler.instance.start()` at entry of `main()`.
  - Mark `bindingInitialized` after `ensureInitialized()`.
  - Mark `diStarted` and `diReady` around `configureDependencies()`.
  - Mark `coreServicesStarted` and `coreServicesReady` around `Future.wait([ThemeManager.init(), AppInitializer.init()])`.
  - Mark `runAppInvoked` right before `runApp()`.
  - In root `WidgetsBinding.instance.addPostFrameCallback`, mark `firstFrameRendered`.
- In `lib/shell/shell_page.dart`:
  - In post-frame callback after `LazyIndexedStack` and bottom nav mount, mark `firstScreenInteractive`.
  - Invoke `ColdStartProfiler.instance.finish()`.
  - Invoke `ColdStartProfiler.instance.logReport(...)` sending output to `Talker` / console.

### 3. System Integration
- Run `fvm flutter test test/shell/shell_page_telemetry_test.dart` and existing host tests.
- Run `fvm flutter analyze`.
- Ensure 100% test pass rate with 0 linter warnings.

---

## Definition of Done (DoD)
- [ ] All startup milestones from `mainEntry` to `firstScreenInteractive` captured in host app.
- [ ] ASCII summary table logged upon first interactive frame.
- [ ] Existing functionality and test suites remain 100% green.
