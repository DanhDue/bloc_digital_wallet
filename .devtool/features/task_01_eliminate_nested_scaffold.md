---
id: "task_01_eliminate_nested_scaffold"
status: "todo"
priority: "high"
assignee: null
epic: "view_rendering_optimization"
dueDate: null
created: "2026-09-17T16:25:00+07:00"
modified: "2026-09-17T16:25:00+07:00"
completedAt: null
labels: ["architecture", "performance", "ui"]
order: "a1"
---

# Task 01: Eliminate Nested Scaffold in HomeDashboardPage

Epic: [view_rendering_optimization](../epic/view_rendering_optimization/view_rendering_optimization.en.md)

## Requirement Analysis
Currently, `ShellPage` establishes an outer `Scaffold` with a body and a bottom navigation bar. Inside the active tab 0, `HomeDashboardPage` returns another full `Scaffold(appBar: AppBar(...), body: ...)`.
This nested Scaffold structure creates duplicate `ScaffoldLayout` calculations, redundant `MediaQuery` padding listeners, and unnecessary `FocusScope` render objects on cold start Frame 0.
This task refactors `HomeDashboardPage` to use a flat layout without an internal `Scaffold`, while maintaining 100% visual fidelity and layout structure.

## Relevant Files & Context Pointers
- `lib/shell/home_dashboard_page.dart`
- `lib/shell/shell_page.dart`
- `test/shell/home_dashboard_page_test.dart` (new widget test)

## Design Rationale
- Use a clean `Column` with a top header/app bar widget and body content instead of wrapping in a second `Scaffold`.
- Retain the exact same typography, colors, icon, and alignment.
- Applicable skills: `flutter-ui-audit`, `test-driven-development`.

## Impact Analysis & Blast Radius
- **Target Files**: `lib/shell/home_dashboard_page.dart`
- **Downstream Callers**: `lib/shell/shell_page.dart`
- **Cross-Platform Bridges**: None
- **Target Test Coverage Threshold**: $\ge 80\%$ line coverage on `HomeDashboardPage`.

### BDD SCENARIOS

#### Scenario 1.1: Single Scaffold Mount on Home Dashboard [Tier C - Integration]
- **Given** the app launches from cold start on the initial tab (Home)
- **When** `ShellPage` renders the active tab
- **Then** the widget tree contains exactly one `Scaffold` instance
- **And** `HomeDashboardPage` displays the app title, icon, and description without nesting another `Scaffold`

#### Scenario 1.2: Safe Area & Status Bar Insets [Tier A - Unit]
- **Given** a device with non-standard top/notch insets
- **When** `HomeDashboardPage` renders without an internal `Scaffold`
- **Then** top padding and safe areas are respected cleanly via `SafeArea`
- **And** no text or icon clips into the device status bar

## Test & Verification Checklist
- [ ] **RED**: Create `test/shell/home_dashboard_page_test.dart` asserting that `HomeDashboardPage` does not contain a `Scaffold` and renders all dashboard elements properly.
- [ ] **GREEN**: Refactor `HomeDashboardPage` in `lib/shell/home_dashboard_page.dart` to remove the inner `Scaffold`.
- [ ] **REFACTOR**: Apply `const` constructors, format code (`melos format`), and verify static analysis (`melos analyze`).
- [ ] **Tier C (Integration)**: Verify existing `ShellPage` tests pass and widget tree contains exactly 1 Scaffold.

## Definition of Done (DoD)
- `HomeDashboardPage` has zero `Scaffold` widgets in its subtree.
- `HomeDashboardPage` visual output is identical to before.
- `test/shell/home_dashboard_page_test.dart` passes cleanly.

## Dependencies & Blockers
- Blocked by: None
- Blocks: [Task 04](task_04_view_acceptance_tests.md)

## References & Rollback
- Spec: `.devtool/epic/view_rendering_optimization/2026-09-17-view-rendering-optimization-design.md`
- Rollback: Revert git commit to restore previous `HomeDashboardPage`.
