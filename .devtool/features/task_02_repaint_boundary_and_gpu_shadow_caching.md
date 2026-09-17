---
id: "task_02_repaint_boundary_and_gpu_shadow_caching"
status: "backlog"
priority: "high"
assignee: null
epic: "cold_start_optimization"
dueDate: null
created: "2026-09-17T14:59:15Z"
modified: "2026-09-17T14:59:15Z"
completedAt: null
labels: ["ui", "gpu", "performance"]
order: "a2"
---

# Task 2: GPU Layer & RepaintBoundary Optimization

Epic: [cold_start_optimization](../epic/cold_start_optimization/cold_start_optimization.en.md)

## Requirement Analysis
The application UI features soft drop shadows with `blurRadius` (10–12px) across settings cards and the bottom navigation bar. In Flutter's rendering pipeline (Impeller/Skia), computing Gaussian blur convolutions on rounded rectangles is an offscreen multi-pass operation.

Currently, neither `SettingsSectionWidget` nor `CustomBottomNavBar` use `RepaintBoundary`. As a result, scrolling the settings page or toggling an individual switch forces the GPU to recalculate blur convolutions across all 4 cards and the navigation bar, producing raster thread spikes.

This task wraps `CustomBottomNavBar` and each `SettingsSectionWidget` container in a `RepaintBoundary` and extracts constant shadow decorations, enabling GPU raster layer caching.

## Relevant Files & Context Pointers
- `features/settings/lib/presentation/settings/widgets/settings_section_widget.dart`
- `features/settings/test/presentation/settings/widgets/settings_section_widget_test.dart`
- `lib/shell/widgets/custom_bottom_nav_bar.dart`
- `test/shell/widgets/custom_bottom_nav_bar_test.dart`

## Design Rationale
- **RenderRepaintBoundary**: Creates an isolated `RenderLayer` on the GPU. Unaffected sections reuse cached raster textures without invoking blur convolution shaders.
- **Pixel-Perfect Preservation**: Exact shadow colors, `blurRadius: 10`, `offset: Offset(0, 2)`, and glowing blue QR button (`blurRadius: 12`) are preserved without any visual changes.
- **Applicable Skills**: `flutter-ui-audit` (audit widget rebuilds, ensure const discipline, verify repaint isolation).

## Impact Analysis & Blast Radius
- **Target Files & Symbols**:
  - `SettingsSectionWidget.build` in `features/settings/lib/presentation/settings/widgets/settings_section_widget.dart`
  - `CustomBottomNavBar.build` and `_CenterNavItem.build` in `lib/shell/widgets/custom_bottom_nav_bar.dart`
- **Downstream Callers**: `SettingsPage` and `ShellPage`.
- **Cross-Platform Bridges**: None.
- **Target Test Coverage**: $\ge 85\%$ line coverage on modified widgets.

---

### BDD SCENARIOS

```gherkin
@TierA @Unit @RepaintBoundary
Scenario: CustomBottomNavBar is enclosed in a RepaintBoundary
  Given CustomBottomNavBar is rendered inside the widget tree
  When the render tree is inspected
  Then a RenderRepaintBoundary exists as a parent of the bottom navigation bar container
  And the layer is marked for raster cache retention

@TierA @Unit @RepaintBoundary
Scenario: SettingsSectionWidget renders card content inside an isolated RepaintBoundary
  Given a SettingsSectionWidget with title "ACCOUNT" and 3 children
  When the widget tree is pumped
  Then the Card Container with BoxShadow is wrapped in a RepaintBoundary
  And toggling a state in one child does not trigger repaint on sibling sections

@TierA @Unit @RepaintBoundary
Scenario: Dark mode toggle updates cached shadow colors cleanly
  Given SettingsSectionWidget is rendered in Light theme
  When the ThemeMode changes to Dark
  Then the RepaintBoundary invalidates its layer
  And repaints cleanly using Dark theme shadow colors without visual artifacts
```

---

## Test & Verification Checklist

- [ ] **RED**: Write widget tests in `features/settings/test/presentation/settings/widgets/settings_section_widget_test.dart` asserting that a `RepaintBoundary` surrounds the shadow container. Run test and confirm failure.
- [ ] **GREEN**: Add `RepaintBoundary` to `SettingsSectionWidget` and `CustomBottomNavBar`. Make tests pass.
- [ ] **REFACTOR**: Extract shadow and border radius configurations into `const` / static cached values where applicable. Run `melos format` and `melos analyze`.
- [ ] **Tier B (Governance)**: Verify zero linter warnings and clean formatting across `ui_kit`, `settings`, and root `lib/`.
- [ ] **Tier C (Integration)**: Run widget tests on `SettingsPage` to verify that all toggles and actions operate seamlessly.

## Definition of Done (DoD)
- `SettingsSectionWidget` and `CustomBottomNavBar` isolate their shadow rendering inside `RepaintBoundary`.
- Visual regression test confirms 100% pixel-perfect preservation of cards and glowing buttons.
- All unit and widget tests pass cleanly.

## Dependencies & Blockers
- Blocked by: None.
- Blocks: [Task 4](task_04_host_acceptance_tests_and_performance_benchmark.md).

## References & Rollback
- References: Flutter `RepaintBoundary` optimization guide.
- Rollback: Remove `RepaintBoundary` wrappers from `SettingsSectionWidget` and `CustomBottomNavBar`.
