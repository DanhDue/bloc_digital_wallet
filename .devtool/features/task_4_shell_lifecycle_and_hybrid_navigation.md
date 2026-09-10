---
id: "task_4_shell_lifecycle_and_hybrid_navigation"
status: "todo"
priority: "high"
assignee: null
epic: "deeplink_router_engine"
dueDate: null
created: "2026-09-11T01:58:25+07:00"
modified: "2026-09-11T01:58:25+07:00"
completedAt: null
labels: ["architecture", "navigation", "ui", "tdd"]
order: "a4"
---

# Task 4: Shell Lifecycle Integration & Smart Hybrid Navigation

Epic: [deeplink_router_engine](../epic/deeplink_router_engine/deeplink_router_engine.en.md)

## Requirement Analysis
The DeepLink engine must execute navigation requests cleanly against the Host's UI structure, specifically coordinating between `ShellBloc` (which manages the bottom navigation bar and `IndexedStack`) and `AppRouter` (which manages the stack of pushed pages).

Key Requirements:
1. Implement `DeepLinkNavigator`:
   - Smart Hybrid Navigation logic:
     - If target matches a root tab (Home: 0, Scanner: 1, Settings: 2), dispatch `ShellAction.tabChanged(tabIndex)` to `ShellBloc`.
     - If target is a sub-page or modal route (e.g. `/settings/languages`), resolve `PageRouteInfo` from `DeepLinkRegistry` and invoke `appRouter.push(pageRouteInfo)`.
     - If path is unrecognized, fallback gracefully to `DeepLinkRoutes.home` (Tab 0) without throwing.
2. Hook into `ShellPage` Lifecycle:
   - In `ShellPage`, use `WidgetsBinding.instance.addPostFrameCallback` after Frame 0 to call `deepLinkCoordinator.markRouterReady()`.
   - This guarantees that any Cold Start URI buffered during app launch is only executed when the widget tree and router context are fully mounted.
3. Write widget and unit tests verifying the hybrid navigation behavior.

## Relevant Files & Context Pointers
- `lib/deeplink/deep_link_navigator.dart` — [NEW] Hybrid navigation execution engine.
- `lib/shell/shell_page.dart` — Host shell UI receiving the `markRouterReady` signal.
- `lib/shell/shell_bloc.dart` — Target for tab index switching actions.
- `lib/app_router.dart` — Target for stack navigation pushes.
- `packages/platform/lib/platform.dart` — Source of `DeepLinkRegistry` and route info mappings.
- `test/deeplink/deep_link_navigator_test.dart` — [NEW] Unit test suite for hybrid navigation.
- `test/shell/shell_page_deeplink_test.dart` — [NEW] Widget test verifying post-frame trigger.

## Design Rationale
- **Smart Hybrid Decoupling:** Rather than forcing every deep link to become a modal page on top of the current screen, root tabs switch in place inside `IndexedStack`, preserving bottom navigation bar state and avoiding redundant route stacks.
- **Skill Pointer:** Developers or agents working on this task should follow `.agents/skills/test-driven-development/SKILL.md`.

## TDD Checklist
- [ ] **RED**:
  - Write unit tests in `test/deeplink/deep_link_navigator_test.dart`:
    - Root Tab Route (e.g. `/scanner`): Verifies `ShellBloc.onAction(ShellAction.tabChanged(1))` is dispatched.
    - Nested Route (e.g. `/settings/languages`): Verifies `appRouter.push(...)` is invoked.
    - Invalid Route: Verifies fallback to `ShellAction.tabChanged(0)`.
  - Write widget test in `test/shell/shell_page_deeplink_test.dart`:
    - Mount `ShellPage` inside test environment, pump one frame, and verify `markRouterReady()` is called exactly once.
  - Confirm tests fail before implementation.
- [ ] **GREEN**:
  - Implement `DeepLinkNavigator` with `ShellBloc` and `AppRouter` dependencies.
  - Add post-frame callback in `ShellPage.initState()` to trigger `markRouterReady()`.
  - Wire `DeepLinkNavigator` into `DeepLinkCoordinator`.
  - Run tests and confirm all pass.
- [ ] **REFACTOR**:
  - Verify no memory leaks or context retention after pop.
  - Run `dart format -l 99` and `melos run analyze`.

## Definition of Done (DoD)
- [ ] Unit and widget tests pass with 100% success rate.
- [ ] Cold start and warm start navigation tested without console errors.
- [ ] Code adheres strictly to formatting standards.

## Dependencies & Blockers
- Blocked by: [Task 3: DeepLink Coordinator, Auth Guard & Deduplication](task_3_deeplink_coordinator_and_auth_guard.md).
- Blocks: [Task 5: Mason Brick Automation & E2E Integration Tests](task_5_mason_brick_and_integration_tests.md).

## References & Rollback
- Design Spec: [2026-09-11-external-deeplink-engine-design.md](../epic/deeplink_router_engine/2026-09-11-external-deeplink-engine-design.md)
- Rollback Strategy: Revert `lib/shell/shell_page.dart` and remove `DeepLinkNavigator`.
