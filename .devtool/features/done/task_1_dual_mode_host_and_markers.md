---
id: "task_1_dual_mode_host_and_markers"
status: "done"
priority: "high"
assignee: null
epic: "flutter_super_app_template"
dueDate: null
created: "2026-09-15T13:20:00Z"
modified: "2026-09-15T06:36:06Z"
completedAt: "2026-09-15T06:36:06Z"
labels: ["host", "shell", "router", "di", "markers"]
order: "a1"
---

# Task 1: Dual-Mode Host Seams & Marker Regions

Epic: [flutter_super_app_template](../epic/flutter_super_app_template/flutter_super_app_template.en.md)

## Requirement Analysis
Prepare the Flutter Host Application (`lib/`) and governance layer (`packages/platform/`) to support Dual-Mode (`enterprise` and `lean`) via deterministic Marker Regions:
1. **Shell Navigation Seams (`lib/shell/shell_page.dart`)**:
   - Wrap the Scanner navigation destination and badge in `// shell:scanner-tab:begin` and `// shell:scanner-tab:end`.
   - Ensure the Shell responds to a parameter or marker indicating whether tab count is 3 (enterprise: Home, Scanner, Settings) or 2 (lean: Home, Settings).
   - In enterprise mode, default tab index is 2 (Settings). In lean mode, default tab index is 1 (Settings).
2. **AutoRoute Seams (`lib/app_router.dart`)**:
   - Wrap the Scanner route import in `// app:scanner-route-import:begin` and `// app:scanner-route-import:end`.
   - Wrap the `AdaptiveRoute(page: ScannerRoute.page, path: '/scanner')` in `// app:scanner-route:begin` and `// app:scanner-route:end`.
3. **DI Registration Seams (`lib/di/injection.dart`)**:
   - Wrap the Scanner module import in `// di:scanner-import:begin` and `// di:scanner-import:end`.
   - Wrap the Scanner DI invocation `configureScannerInjection(getIt);` in `// di:scanner-module:begin` and `// di:scanner-module:end`.
4. **DeepLink Registry Seams (`packages/platform/lib/deeplink/deep_link_registry.dart`)**:
   - Wrap Scanner route mapping in `// deeplink:scanner-register:begin` and `// deeplink:scanner-register:end`.
5. **Unit Test Protection**:
   - Add unit tests verifying that when marker regions are commented out, the host codebase compiles cleanly, `AppRouter` omits `/scanner`, `ShellPage` renders 2 tabs, and `injection.dart` initializes without crashing.

## Relevant Files & Context Pointers
- `lib/shell/shell_page.dart`
- `lib/app_router.dart`
- `lib/di/injection.dart`
- `packages/platform/lib/deeplink/deep_link_registry.dart`
- `packages/platform/lib/deeplink/deep_link_routes.dart`
- `test/shell/shell_page_deeplink_test.dart`
- `test/di/injection_test.dart`
- `test/router/app_router_mode_test.dart` [NEW]

## Design Rationale
- **Zero Runtime Reflection**: Switching modes is a compile-time/build-time operation via marker comments, introducing zero runtime penalty, zero dynamic module loading overhead, and zero code-bloat in release binaries.
- **Syntactic Safety**: Marker comments are strictly structured with explicit `:begin` and `:end` anchors, preventing accidental deletion of adjacent code during scripting.
- **Applicable Skills**: `flutter-ui-audit`, `architecture-audit`.

## Impact Analysis & Blast Radius
- **Target Files & Symbols**:
  - `lib/shell/shell_page.dart`: `ShellPage`, `_ShellPageState`
  - `lib/app_router.dart`: `AppRouter`
  - `lib/di/injection.dart`: `configureAppInjection`
  - `packages/platform/lib/deeplink/deep_link_registry.dart`: `DeepLinkRegistry`
- **Downstream Callers**: `lib/main.dart`, `test/shell/shell_page_deeplink_test.dart`, `integration_test/deep_link_flow_test.dart`.
- **Cross-Platform Bridges**: None directly modified in this task.
- **Target Test Coverage Threshold**: $\ge 85\%$ line coverage for modified seams and new router tests.

### BDD SCENARIOS

#### Scenario 1.1: [Tier A - Unit] Shell Navigation 3-Tab Rendering (Enterprise Markers Active)
```gherkin
Given "lib/shell/shell_page.dart" has all marker regions uncommented
When the widget tree pumps "ShellPage"
Then the bottom navigation bar displays 3 destinations: "Home", "Scanner", "Settings"
And the initially selected tab index is 2 ("Settings")
```

#### Scenario 1.2: [Tier A - Unit] Shell Navigation 2-Tab Rendering (Lean Markers Commented)
```gherkin
Given "lib/shell/shell_page.dart" has "shell:scanner-tab" commented out
And the tab count is set to 2
When the widget tree pumps "ShellPage"
Then the bottom navigation bar displays 2 destinations: "Home", "Settings"
And the initially selected tab index is 1 ("Settings")
And no overflow or index-out-of-bounds error occurs
```

#### Scenario 1.3: [Tier A - Unit] AppRouter Route Resolution (Enterprise vs Lean)
```gherkin
Given "AppRouter" instance in enterprise mode
When querying route configuration for path "/scanner"
Then "ScannerRoute" is present in the route list
Given "AppRouter" instance with "app:scanner-route" commented out
When querying route configuration for path "/scanner"
Then the route is absent and resolves to the unknown route handler
```

#### Scenario 1.4: [Tier A - Unit] DI Container Independence in Lean Mode
```gherkin
Given GetIt service locator instance
When "configureAppInjection" runs with "di:scanner-module" commented out
Then core, framework, network, and settings dependencies are registered
And no missing factory or unregistered dependency exception is thrown
```

#### Scenario 1.5: [Tier C - Integration] Host Cold Start under Lean Marker State
```gherkin
Given all host marker regions are toggled to lean mode
When the application boots in a widget test environment
Then the shell mounts immediately on "Settings" screen
And tapping "Home" switches to tab 0 smoothly
```

## Test & Verification Checklist
- [x] **RED**: Write `test/router/app_router_mode_test.dart` and `test/shell/shell_mode_test.dart` asserting 3-tab vs 2-tab configurations.
- [x] **GREEN**: Insert marker tags across `shell_page.dart`, `app_router.dart`, `injection.dart`, and `deep_link_registry.dart`.
- [x] **REFACTOR**: Ensure formatting is pristine with `melos format`, run `melos run analyze`, and assert zero linter errors.
- [x] **Tier C (Integration)**: Run `fvm flutter test test/shell/` and verify existing tests pass.

## Definition of Done (DoD)
- [x] Marker regions are in place and strictly delimited across all 4 target files.
- [x] Seam unit tests pass 100%.
- [x] `melos run analyze` reports zero issues.

## Dependencies & Blockers
- None. This is Task 1 (Foundational host task).

## References & Rollback
- References: Spec Section 3.2, HLD Section 4.
- Rollback: `git checkout HEAD -- lib/ packages/platform/`.
