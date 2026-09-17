---
id: "task_03_non_blocking_bootstrapping_and_deferred_io"
status: "backlog"
priority: "high"
assignee: null
epic: "cold_start_optimization"
dueDate: null
created: "2026-09-17T14:59:15Z"
modified: "2026-09-17T14:59:15Z"
completedAt: null
labels: ["architecture", "performance", "bootstrapping"]
order: "a3"
---

# Task 3: Non-blocking Bootstrapping & Deferred I/O

Epic: [cold_start_optimization](../epic/cold_start_optimization/cold_start_optimization.en.md)

## Requirement Analysis
In `lib/main.dart`, the execution flow sequentially awaits:
1. `configureDependencies()`
2. `core.ThemeManager.instance.init()`
3. `getIt<core.AppInitializer>().init()` (which runs a sequential `for-await` loop of 6 initializers including `LoggingInitializer` and `LocalizationInitializer`)
4. `getIt<DeepLinkCoordinator>().initialize()`

This sequential pipeline forces the OS launcher and native splash screen to block while reading disk files, deserializing dynamic translation JSON maps, and performing platform channel calls before `runApp()` can schedule Frame 0.

This task refactors the startup pipeline to:
- Resolve `SharedPreferences.getInstance()` once and pass it directly to `ThemeManager` and `GetIt`.
- Parallelize critical startup tasks with `Future.wait()`.
- Defer non-critical services (Talker logging toggles, dynamic translation JSON overrides, `DeepLinkCoordinator`) to run asynchronously in parallel via `addPostFrameCallback`.

## Relevant Files & Context Pointers
- `lib/main.dart`
- `packages/core/lib/app_initializer/app_initializer_impl.dart`
- `packages/core/lib/services/theme_manager.dart`
- `lib/core/app_initializer/localization_initializer.dart`
- `lib/core/app_initializer/logging_initializer.dart`
- `lib/deeplink/deep_link_coordinator.dart`
- `test/core/app_initializer/localization_initializer_test.dart`
- `test/di/injection_test.dart`

## Design Rationale
- **Fast-Path to Frame 0**: Static bundled translations (Slang) and default theme provide immediate, functional UI rendering. Dynamic translation overrides and logging listeners attach seamlessly in background without visual disruptions.
- **Deep-Link Buffering**: `DeepLinkCoordinator` already provides `stagedInitialLink` buffering; deferring link subscription does not lose inbound cold start URLs.
- **Applicable Skills**: `architecture-audit` (preserve Clean Architecture separation between composition root and modules).

## Impact Analysis & Blast Radius
- **Target Files & Symbols**:
  - `main()` in `lib/main.dart`
  - `AppInitializerImpl.init` in `packages/core/lib/app_initializer/app_initializer_impl.dart`
  - `ThemeManager.init` in `packages/core/lib/services/theme_manager.dart`
- **Downstream Callers**: Application composition root.
- **Cross-Platform Bridges**: Inbound deep-links and native log bridges continue functioning with asynchronous attachment.
- **Target Test Coverage**: $\ge 85\%$ line coverage across initialization services.

---

### BDD SCENARIOS

```gherkin
@TierA @Unit @Bootstrapping
Scenario: main() invokes runApp within critical time budget
  Given the application bootstrap sequence begins
  When main() parallelizes SharedPreferences and Core DI
  Then runApp() is called without waiting for dynamic translation JSON parsing or deep-link stream binding

@TierA @Unit @Bootstrapping
Scenario: AppInitializerImpl parallelizes initializer execution
  Given a list of AppInitializer instances
  When init() is called on AppInitializerImpl
  Then all initializers execute concurrently using Future.wait
  And a failure in an optional initializer does not abort the remaining initializers

@TierA @Unit @Localization
Scenario: Slang bundled localizations provide instant UI fallback
  Given cached dynamic translation JSON has not yet completed loading
  When the initial widget tree queries translated strings
  Then static bundled translations are returned immediately without throwing null errors

@TierC @Integration @DeepLink
Scenario: Cold start deep link buffered until router is ready
  Given the app is cold-started with a deep-link URI
  When the initial frame is rendered and markRouterReady is triggered
  Then the staged deep-link URI is processed and navigation occurs
```

---

## Test & Verification Checklist

- [ ] **RED**: Write unit tests in `test/di/injection_test.dart` and `test/core/app_initializer/` asserting that `AppInitializerImpl` executes initializers concurrently and handles deferred localization. Confirm tests fail.
- [ ] **GREEN**: Refactor `lib/main.dart`, `app_initializer_impl.dart`, and `theme_manager.dart`. Make tests pass.
- [ ] **REFACTOR**: Ensure all asynchronous background workers are properly caught with try/catch to guarantee crash-free startup. Run `melos format` and `melos analyze`.
- [ ] **Tier B (Governance)**: Verify zero linter warnings across `core` and root app.
- [ ] **Tier C (Integration)**: Run `test/shell/shell_page_deeplink_test.dart` to verify deep link coordination remains intact.

## Definition of Done (DoD)
- `runApp()` is invoked with minimal pre-frame latency.
- Non-critical initializers execute concurrently in the background after Frame 0.
- Deep links and theme switches operate without regression.

## Dependencies & Blockers
- Blocked by: [Task 1](task_01_lazy_indexed_stack_and_shell_navigation.md).
- Blocks: [Task 4](task_04_host_acceptance_tests_and_performance_benchmark.md).

## References & Rollback
- References: Flutter startup performance optimization documentation.
- Rollback: Revert `main.dart` and `app_initializer_impl.dart` to sequential `await` calls.
