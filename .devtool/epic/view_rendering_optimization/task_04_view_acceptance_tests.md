---
id: "task_04_view_acceptance_tests"
status: "done"
priority: "high"
assignee: null
epic: "view_rendering_optimization"
dueDate: null
created: "2026-09-17T16:25:00+07:00"
modified: "2026-09-17T09:36:02Z"
completedAt: "2026-09-17T09:36:02Z"
labels: ["acceptance", "integration", "testing"]
order: "a4"
---

# Task 04: Host App Integration and View Acceptance Tests

Epic: [view_rendering_optimization](view_rendering_optimization.en.md)

## Requirement Analysis
Every epic requires an explicit Tier C Host App integration and acceptance test task to validate that all individual components (flat HomeDashboardPage, static AppThemeData, two-stage CustomBottomNavBar, stream distinct gating) operate cohesively in the full application composition root without regression.
This task implements an automated acceptance test suite in `test/shell/view_rendering_acceptance_test.dart` and executes the full workspace test suite and linter.

## Relevant Files & Context Pointers
- `test/shell/view_rendering_acceptance_test.dart` (new)
- `integration_test/cold_start_performance_test.dart`
- `lib/shell/shell_page.dart`
- `lib/main.dart`

## Design Rationale
- Write comprehensive acceptance tests asserting:
  1. `ShellPage` renders exactly 1 `Scaffold` widget when the Home tab is active.
  2. Frame 0 -> Frame 1 transition properly activates shadow decorations without visual glitches.
  3. `MaterialApp.router` correctly binds cached `AppThemeData` light and dark schemes.
- Execute workspace-wide checks (`melos test` and `fvm flutter analyze`).
- Applicable skills: `flutter-ui-audit`, `quality_check`.

## Impact Analysis & Blast Radius
- **Target Files**: `test/shell/view_rendering_acceptance_test.dart`
- **Downstream Callers**: Workspace test runner
- **Cross-Platform Bridges**: None
- **Target Test Coverage Threshold**: 100% test scenario pass rate.

### BDD SCENARIOS

#### Scenario 4.1: Host App Single Scaffold Acceptance [Tier C - Integration]
- **Given** the full `ShellPage` is pumped in a test environment
- **When** the widget tree stabilizes
- **Then** `find.byType(Scaffold)` yields exactly 1 match
- **And** `HomeDashboardPage` content is fully accessible and rendered

#### Scenario 4.2: Two-Stage Navigation Bar Transition [Tier C - Integration]
- **Given** `ShellPage` is mounted
- **When** `pump()` is called for Frame 0
- **Then** the navigation bar has no active `BoxShadow`
- **When** `pumpAndSettle()` completes post-frame callbacks
- **Then** `BoxShadow` is present on the navigation bar container

#### Scenario 4.3: Regression Free Workspace Verification [Tier B - Tooling]
- **Given** all 3 previous tasks are merged
- **When** `melos test` runs across all packages
- **Then** all tests pass (74+ tests)
- **And** `fvm flutter analyze` returns zero issues

## Test & Verification Checklist
- [ ] **RED**: Author `test/shell/view_rendering_acceptance_test.dart` with assertions for single Scaffold and staged shadow transitions.
- [ ] **GREEN**: Run tests and verify all acceptance scenarios pass.
- [ ] **REFACTOR**: Ensure test code is clean and properly commented.
- [ ] **Tier C (Integration)**: Execute `melos test` and `fvm flutter analyze`.

## Definition of Done (DoD)
- Acceptance test suite in `test/shell/view_rendering_acceptance_test.dart` passes.
- Exactly 1 Scaffold confirmed in ShellPage tree.
- Full workspace tests pass 100% (`melos test`).
- Analyzer reports zero warnings/errors.

## Dependencies & Blockers
- Blocked by: [Task 01](task_01_eliminate_nested_scaffold.md), [Task 02](task_02_static_cached_theme_data.md), [Task 03](task_03_two_stage_bottom_nav_bar.md)
- Blocks: None

## References & Rollback
- Spec: `.devtool/epic/view_rendering_optimization/2026-09-17-view-rendering-optimization-design.md`
- Rollback: Remove `test/shell/view_rendering_acceptance_test.dart`.
