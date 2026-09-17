---
id: "task_03_two_stage_bottom_nav_bar"
status: "done"
priority: "high"
assignee: null
epic: "view_rendering_optimization"
dueDate: null
created: "2026-09-17T16:25:00+07:00"
modified: "2026-09-17T09:33:52Z"
completedAt: "2026-09-17T09:33:52Z"
labels: ["architecture", "performance", "ui"]
order: "a3"
---

# Task 03: Two-Stage First Paint for CustomBottomNavBar

Epic: [view_rendering_optimization](view_rendering_optimization.en.md)

## Requirement Analysis
On Frame 0, GPU rasterization of Gaussian blurs (`BoxShadow(blurRadius: 10)` on the bottom navigation bar container, and `BoxShadow(blurRadius: 12)` on the center elevated button) incurs shader compilation and convolution latency when the GPU raster cache is cold.
This task introduces a staged rendering mechanism inside `CustomBottomNavBar`:
- On **Frame 0**, render the navigation bar with flat background colors, omitting `BoxShadow`.
- On **Frame 1** (via `WidgetsBinding.instance.addPostFrameCallback`), enable the exact original `BoxShadow` configurations.
This ensures Frame 0 renders in <30ms, while maintaining 100% aesthetic preservation immediately on Frame 1.

## Relevant Files & Context Pointers
- `lib/shell/widgets/custom_bottom_nav_bar.dart`
- `test/shell/custom_bottom_nav_bar_test.dart` (new widget test)

## Design Rationale
- Convert `CustomBottomNavBar` to a lightweight `StatefulWidget` (or manage staged shadow state cleanly).
- When first mounted, `_showShadows` is `false`. A `postFrameCallback` in `initState()` sets `_showShadows = true` if `mounted`.
- Blur radius values (`10` and `12`), offsets, colors, and opacity remain 100% identical.
- Applicable skills: `flutter-ui-audit`, `test-driven-development`.

## Impact Analysis & Blast Radius
- **Target Files**: `lib/shell/widgets/custom_bottom_nav_bar.dart`
- **Downstream Callers**: `lib/shell/shell_page.dart`
- **Cross-Platform Bridges**: None
- **Target Test Coverage Threshold**: $\ge 85\%$ line coverage on `custom_bottom_nav_bar.dart`.

### BDD SCENARIOS

#### Scenario 3.1: Two-Stage First Paint for Bottom Navigation Bar [Tier A - Unit]
- **Given** `CustomBottomNavBar` is rendered during Frame 0
- **When** the first layout pass completes before post-frame callbacks execute
- **Then** the navigation bar container renders with a flat background and without `BoxShadow`
- **When** `WidgetsBinding.instance.addPostFrameCallback` fires for Frame 1
- **Then** the `BoxShadow` list with blurRadius 10 is enabled on the outer bar
- **And** the elevated center QR button enables its `BoxShadow` with blurRadius 12

#### Scenario 3.2: Interaction During Frame 0 [Tier A - Unit]
- **Given** `CustomBottomNavBar` is mounted with `_showShadows = false`
- **When** the user taps a nav item before post-frame callback fires
- **Then** `onTap` callback triggers correctly without exception

#### Scenario 3.3: Disposal Before Frame 1 [Tier A - Unit]
- **Given** `CustomBottomNavBar` is disposed immediately before post-frame callback executes
- **When** post-frame callback triggers
- **Then** the `mounted` check prevents `setState` calls or memory leaks

## Test & Verification Checklist
- [ ] **RED**: Write `test/shell/custom_bottom_nav_bar_test.dart` testing initial flat rendering and post-frame shadow activation.
- [ ] **GREEN**: Implement staged rendering in `lib/shell/widgets/custom_bottom_nav_bar.dart`.
- [ ] **REFACTOR**: Ensure `const` constructor support, verify formatting (`melos format`), zero analyzer issues (`melos analyze`).
- [ ] **Tier C (Integration)**: Verify shell page tests and navigation tests pass.

## Definition of Done (DoD)
- Frame 0 renders flat navbar without `BoxShadow`.
- Frame 1 activates full `BoxShadow` with blur 10 and 12.
- 100% visual fidelity maintained.
- `test/shell/custom_bottom_nav_bar_test.dart` passes cleanly.

## Dependencies & Blockers
- Blocked by: None
- Blocks: [Task 04](task_04_view_acceptance_tests.md)

## References & Rollback
- Spec: `.devtool/epic/view_rendering_optimization/2026-09-17-view-rendering-optimization-design.md`
- Rollback: Revert git commit to restore stateless `CustomBottomNavBar`.
