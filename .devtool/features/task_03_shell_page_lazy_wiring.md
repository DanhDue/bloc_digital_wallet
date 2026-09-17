---
id: "task_03_shell_page_lazy_wiring"
status: "todo"
priority: "high"
assignee: null
epic: "startup_rendering_optimization"
dueDate: null
created: "2026-09-17T18:00:00+07:00"
modified: "2026-09-17T18:00:00+07:00"
completedAt: null
labels: ["shell", "navigation", "lazy-wiring"]
order: "a3"
---

# Task 03: ShellPage Lazy Wiring & Regression Verification

## Context & Objectives
Update `lib/shell/shell_page.dart` to wire `LazyIndexedStack` using its lazy builder API. Preserve `ShellConfig.defaultTabIndex = 2` so that on application launch, only the builder for index 2 (`SettingsPage`) executes, while Tab 0 (`HomeDashboardPage`) and Tab 1 (`ScannerPage`) remain completely unevaluated.

---

## BDD Acceptance Criteria

```gherkin
Feature: ShellPage Integration with Lazy Builder

  Scenario: ShellPage launches directly into SettingsPage without creating other tabs
    Given ShellConfig.defaultTabIndex is 2
    When ShellPage mounts in the widget tree
    Then SettingsPage should be mounted and rendered
    And HomeDashboardPage should not exist in the element tree
    And ScannerPage should not exist in the element tree

  Scenario: Tab switching retains state properly
    Given ShellPage is mounted on tab 2
    When the user switches to tab 0 (Home)
    Then HomeDashboardPage should mount
    When the user switches back to tab 2 (Settings)
    Then SettingsPage state should be retained seamlessly without rebuilding
```

---

## TDD Implementation Steps

### 1. QA Red Team (Test Authoring)
- Update `test/shell/shell_page_telemetry_test.dart`:
  - Assert that when `ShellPage` mounts with `defaultTabIndex = 2`, `find.byType(SettingsPage)` finds 1 widget, while `find.byType(HomeDashboardPage)` and `find.byType(ScannerPage)` find 0 widgets in the element tree.
  - Test switching tabs to index 0 and verify `HomeDashboardPage` then appears while `SettingsPage` remains in the stack.

### 2. TDD Master (Implementation)
- Update `ShellPage.handleState`:
  - Replace eager `children: [...]` list with `itemCount: ShellConfig.tabCount` and `itemBuilder: (context, index) => ...`.
  - Wrap each tab in its corresponding `MiniAppErrorBoundary`.

### 3. System Integration & Verification
- Run `fvm flutter test test/shell/shell_page_telemetry_test.dart`.
- Run `fvm flutter analyze lib/shell`.
- Ensure zero errors and zero warnings.

---

## Definition of Done (DoD)
- [ ] `ShellPage` uses lazy builder API.
- [ ] Only active tab is mounted on launch.
- [ ] 100% tests passing in `test/shell/`.
