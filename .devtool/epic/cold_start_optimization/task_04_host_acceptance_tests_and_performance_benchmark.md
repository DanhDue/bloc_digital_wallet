---
id: "task_04_host_acceptance_tests_and_performance_benchmark"
status: "done"
priority: "high"
assignee: null
epic: "cold_start_optimization"
dueDate: null
created: "2026-09-17T14:59:15Z"
modified: "2026-09-17T08:54:23Z"
completedAt: "2026-09-17T08:54:23Z"
labels: ["testing", "acceptance", "performance"]
order: "a4"
---

# Task 4: Host Acceptance Tests & Performance Benchmark

Epic: [cold_start_optimization](cold_start_optimization.en.md)

## Requirement Analysis
Following the implementation of `LazyIndexedStack` (Task 1), `RepaintBoundary` shadow isolation (Task 2), and non-blocking parallel bootstrapping (Task 3), this final Tier C integration task validates the end-to-end user experience, benchmarks cold start metrics against the agreed KPIs, and executes the mandatory 3-tier quality gate (`@quality_check`).

## Relevant Files & Context Pointers
- `integration_test/cold_start_performance_test.dart` (NEW)
- `test/shell/shell_page_test.dart`
- `scripts/testWithCoverage.sh`
- `scripts/check_module_boundaries.sh`

## Design Rationale
- **End-to-End Verification**: Confirms that lazy mounting of tabs, shadow layer caching, and deferred background tasks work harmoniously in the host composition root without regression.
- **KPI Measurement**: Validates that TTID (Time to Initial Display) is < 450ms and GPU first-frame raster time is < 12ms under profile mode.
- **Applicable Skills**: `quality_check` (master gatekeeper running 3-tier tests and 4 semantic audits).

## Impact Analysis & Blast Radius
- **Target Files & Symbols**:
  - `integration_test/cold_start_performance_test.dart`
  - Host integration harness.
- **Downstream Callers**: CI/CD pipeline and release validation.
- **Cross-Platform Bridges**: All bridges validated under live execution.
- **Target Test Coverage**: Maintain overall repository test coverage thresholds ($\ge 80\%$).

---

### BDD SCENARIOS

```gherkin
@TierC @Integration @Performance
Scenario: Host app launches to Settings screen within cold start budget
  Given the application is cold started in profile mode
  When the initial frame is completely rasterized by the GPU
  Then the elapsed time from main entry to first frame is less than 450 milliseconds
  And the GPU raster thread duration for Frame 0 is less than 12 milliseconds

@TierC @Integration @Navigation
Scenario: Full navigation workflow across lazy tabs with zero regressions
  Given the app has finished rendering SettingsPage on cold start
  When the user taps Home on CustomBottomNavBar
  Then HomeDashboardPage mounts cleanly
  And when the user taps Scanner on CustomBottomNavBar
  Then ScannerPage mounts cleanly
  And when the user returns to Settings
  Then SettingsPage maintains all previous toggle states without rebuilding
```

---

## Test & Verification Checklist

- [ ] **RED**: Create integration test harness in `integration_test/cold_start_performance_test.dart` asserting cold start milestones and tab switching. Run test and verify it fails or runs as red benchmark.
- [ ] **GREEN**: Wire all optimizations into the Host App testbed and make tests pass cleanly.
- [ ] **REFACTOR**: Ensure zero dead imports, clean formatting (`melos format`), and clean static analysis (`melos analyze`).
- [ ] **Tier B (Governance)**: Execute `./scripts/check_module_boundaries.sh` and `./scripts/check_license_header.sh`.
- [ ] **Tier C (Acceptance Gate)**: Execute `melos test` across all packages and run `./scripts/testWithCoverage.sh`.
- [ ] **Gate 4 (Quality Check)**: Invoke `quality_check` skill to run 3-Tier tests and 4 semantic audits (Security, Architecture, UI, Code Health) for final 🟢 LGTM verdict.

## Definition of Done (DoD)
- TTID benchmarked at < 450ms.
- 100% of Unit, Widget, and Integration tests pass without failure.
- `quality_check` awards clean 🟢 LGTM report.

## Dependencies & Blockers
- Blocked by: [Task 1](task_01_lazy_indexed_stack_and_shell_navigation.md), [Task 2](task_02_repaint_boundary_and_gpu_shadow_caching.md), [Task 3](task_03_non_blocking_bootstrapping_and_deferred_io.md).
- Blocks: Epic Completion and Gate 4/5 Sign-off.

## References & Rollback
- References: Flutter DevTools performance profiling guide.
- Rollback: N/A (Verification task).
