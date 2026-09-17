---
id: "task_02_static_cached_theme_data"
status: "done"
priority: "high"
assignee: null
epic: "view_rendering_optimization"
dueDate: null
created: "2026-09-17T16:25:00+07:00"
modified: "2026-09-17T09:31:24Z"
completedAt: "2026-09-17T09:31:24Z"
labels: ["architecture", "performance", "theme"]
order: "a2"
---

# Task 02: Static Cached AppThemeData and Stream Gating

Epic: [view_rendering_optimization](view_rendering_optimization.en.md)

## Requirement Analysis
In `lib/main.dart`, `ThemeData` for light and dark modes is allocated dynamically inside `StreamBuilder.builder` on every stream tick, reconstructing dozens of objects (color schemes, extensions, button themes).
Additionally, `themeModeStream` and `localeStream` are listened to without `.distinct()`, allowing identical consecutive emissions to trigger unnecessary rebuilds of the entire root `MaterialApp.router`.
This task introduces a cached `AppThemeData` container with static immutable `lightTheme` and `darkTheme` instances, and applies `.distinct()` stream gating.

## Relevant Files & Context Pointers
- `lib/theme/app_theme_data.dart` (new)
- `lib/main.dart`
- `test/theme/app_theme_data_test.dart` (new)

## Design Rationale
- Create `AppThemeData` with `static final ThemeData lightTheme` and `static final ThemeData darkTheme`.
- In `lib/main.dart`, pass `AppThemeData.lightTheme` and `AppThemeData.darkTheme` directly to `MaterialApp.router`.
- Apply `core.ThemeManager.instance.themeModeStream.distinct()` and `core.LocalizationManager.instance.localeStream.distinct()`.
- Applicable skills: `flutter-ui-audit`, `test-driven-development`.

## Impact Analysis & Blast Radius
- **Target Files**: `lib/theme/app_theme_data.dart`, `lib/main.dart`
- **Downstream Callers**: `lib/main.dart`
- **Cross-Platform Bridges**: None
- **Target Test Coverage Threshold**: $\ge 90\%$ line coverage on `app_theme_data.dart`.

### BDD SCENARIOS

#### Scenario 2.1: Static Cached ThemeData Usage [Tier A - Unit]
- **Given** `AppThemeData.lightTheme` and `AppThemeData.darkTheme` are defined as cached instances
- **When** `MaterialApp.router` is built in `main.dart`
- **Then** `theme` references the cached `AppThemeData.lightTheme`
- **And** `darkTheme` references the cached `AppThemeData.darkTheme`
- **And** no new `ThemeData` instance is allocated during the build pass

#### Scenario 2.2: Stream Deduplication with `distinct()` [Tier A - Unit]
- **Given** `themeModeStream` and `localeStream` have duplicate consecutive events emitted
- **When** the streams are listened to in `main.dart` with `.distinct()`
- **Then** `StreamBuilder` does not trigger redundant builds of the `MaterialApp` root

## Test & Verification Checklist
- [ ] **RED**: Write `test/theme/app_theme_data_test.dart` asserting that `AppThemeData.lightTheme` and `AppThemeData.darkTheme` contain all expected colors, extensions, and match theme definitions.
- [ ] **GREEN**: Create `lib/theme/app_theme_data.dart` and update `lib/main.dart` to use cached instances and `.distinct()` streams.
- [ ] **REFACTOR**: Ensure zero warnings (`melos analyze`), format code (`melos format`).
- [ ] **Tier C (Integration)**: Verify all 74+ tests pass without regression.

## Definition of Done (DoD)
- `ThemeData` is constructed only once statically.
- `lib/main.dart` uses `AppThemeData.lightTheme` and `AppThemeData.darkTheme`.
- Both streams have `.distinct()` applied.
- `test/theme/app_theme_data_test.dart` passes.

## Dependencies & Blockers
- Blocked by: None
- Blocks: [Task 04](task_04_view_acceptance_tests.md)

## References & Rollback
- Spec: `.devtool/epic/view_rendering_optimization/2026-09-17-view-rendering-optimization-design.md`
- Rollback: Revert git commit to restore dynamic `ThemeData` in `main.dart`.
