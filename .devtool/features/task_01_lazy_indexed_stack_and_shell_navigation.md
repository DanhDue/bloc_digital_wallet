---
id: "task_01_lazy_indexed_stack_and_shell_navigation"
status: "done"
priority: "high"
assignee: null
epic: "cold_start_optimization"
dueDate: null
created: "2026-09-17T14:59:15Z"
modified: "2026-09-17T08:22:56Z"
completedAt: "2026-09-17T08:22:56Z"
labels: ["ui", "navigation", "performance"]
order: "a1"
---

# Task 1: Lazy Navigation Shell (LazyIndexedStack)

Epic: [cold_start_optimization](../epic/cold_start_optimization/cold_start_optimization.en.md)

## Requirement Analysis
In `d3_nexus_shield`, `ShellPage` hosts 3 primary tabs (`HomeDashboardPage`, `ScannerPage`, and `SettingsPage`) using Flutter's built-in `IndexedStack`. Because `IndexedStack` eagerly evaluates all child widget subtrees upon initial build, all 3 tabs are constructed on Frame 0 even though the app defaults to tab 2 (`SettingsPage`). This triples the initial widget inflation, layout passes, and BLoC subscriptions during cold start.

This task introduces a reusable `LazyIndexedStack` in `packages/ui_kit` that lazily builds and mounts children on-demand upon first activation while preserving their state thereafter. `ShellPage` will be updated to use this component.

## Relevant Files & Context Pointers
- `packages/ui_kit/lib/widgets/lazy_indexed_stack.dart` (NEW)
- `packages/ui_kit/lib/ui_kit.dart` (Export new widget)
- `packages/ui_kit/test/widgets/lazy_indexed_stack_test.dart` (NEW)
- `lib/shell/shell_page.dart` (Update to use `LazyIndexedStack`)
- `test/shell/shell_page_test.dart` (Verify shell tab mounting behavior)

## Design Rationale
- **Zero External Dependencies**: Implemented using pure Flutter primitives (`StatefulWidget`, `IndexedStack`, `Set<int> _activatedIndices`).
- **Preserved State**: Active children are stored in an indexed list. Once an index is added to `_activatedIndices`, its child is mounted and stays alive across tab switches. Inactive tabs render as `const SizedBox.shrink()`.
- **Applicable Skills**: `flutter-ui-audit` (ensure widget rebuild efficiency, const constructors, and minimal element churn).

## Impact Analysis & Blast Radius
- **Target Files & Symbols**:
  - `LazyIndexedStack` in `packages/ui_kit/lib/widgets/lazy_indexed_stack.dart`
  - `_ShellPageState.handleState` in `lib/shell/shell_page.dart`
- **Downstream Callers**: Consumed exclusively by `ShellPage` (and available across feature packages via `ui_kit`).
- **Cross-Platform Bridges**: None. Pure Dart/Flutter widget layer.
- **Target Test Coverage**: $\ge 90\%$ line coverage on `lazy_indexed_stack.dart`.

---

### BDD SCENARIOS

```gherkin
@TierA @Unit @LazyIndexedStack
Scenario: LazyIndexedStack mounts only the initial active child on Frame 0
  Given a LazyIndexedStack with 3 builder children [Child0, Child1, Child2]
  And index is set to 2
  When the widget tree is pumped
  Then only Child2 is mounted in the element tree
  And Child0 is rendered as SizedBox.shrink
  And Child1 is rendered as SizedBox.shrink

@TierA @Unit @LazyIndexedStack
Scenario: Switching to an unmounted tab instantiates it on-demand
  Given LazyIndexedStack is currently displaying index 2
  When the index property updates to 0
  And the widget tree is pumped
  Then Child0 is mounted in the element tree
  And Child2 remains in the tree with its state preserved
  And Child1 remains unmounted as SizedBox.shrink

@TierA @Unit @LazyIndexedStack
Scenario: Clamping out-of-bounds index gracefully
  Given a LazyIndexedStack with 3 children
  When the provided index is -1 or 99
  Then the widget clamps the active index to 0 or 2 respectively
  And does not throw a RangeError

@TierA @Unit @LazyIndexedStack
Scenario: Rapid index switches do not cause duplicate mounting
  Given a LazyIndexedStack with 3 children
  When index changes rapidly from 2 to 0, then 1, then 0 within a single microtask
  Then each activated child is added to the internal index set exactly once
  And no duplicate keys or memory leaks occur
```

---

## Test & Verification Checklist

- [ ] **RED**: Write comprehensive unit tests in `packages/ui_kit/test/widgets/lazy_indexed_stack_test.dart` asserting all 4 BDD scenarios above. Run `fvm flutter test packages/ui_kit/test/widgets/lazy_indexed_stack_test.dart` and confirm test failures.
- [ ] **GREEN**: Implement `LazyIndexedStack` in `packages/ui_kit/lib/widgets/lazy_indexed_stack.dart`, export in `packages/ui_kit/lib/ui_kit.dart`, and make tests pass.
- [ ] **REFACTOR**: Replace `IndexedStack` with `LazyIndexedStack` in `lib/shell/shell_page.dart`. Run `melos format` and `melos analyze`.
- [ ] **Tier B (Governance)**: Run `./scripts/check_module_boundaries.sh` and `./scripts/check_license_header.sh`.
- [ ] **Tier C (Integration)**: Run existing `test/shell/shell_page_deeplink_test.dart` and confirm zero regressions.

## Definition of Done (DoD)
- `LazyIndexedStack` passes all unit tests with $\ge 90\%$ line coverage.
- `ShellPage` renders `SettingsPage` on cold start with `HomeDashboardPage` and `ScannerPage` deferred.
- All Melos analyzers and formatting checks pass cleanly.

## Dependencies & Blockers
- Blocked by: None.
- Blocks: [Task 4](task_04_host_acceptance_tests_and_performance_benchmark.md).

## References & Rollback
- References: Flutter `IndexedStack` API documentation.
- Rollback: Revert `ShellPage` back to `IndexedStack`.
