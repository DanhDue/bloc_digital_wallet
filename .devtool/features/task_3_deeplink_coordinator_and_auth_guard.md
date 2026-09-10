---
id: "task_3_deeplink_coordinator_and_auth_guard"
status: "todo"
priority: "high"
assignee: null
epic: "deeplink_router_engine"
dueDate: null
created: "2026-09-11T01:58:25+07:00"
modified: "2026-09-11T01:58:25+07:00"
completedAt: null
labels: ["architecture", "routing", "security", "tdd"]
order: "a3"
---

# Task 3: DeepLink Coordinator, Auth Guard & Deduplication

Epic: [deeplink_router_engine](../epic/deeplink_router_engine/deeplink_router_engine.en.md)

## Requirement Analysis
The Host application requires a centralized orchestration layer to manage the lifecycle of incoming deep links, prevent race conditions during Cold Start, eliminate duplicate OS intent firings, and gate access to protected routes behind an authentication challenge.

Key Requirements:
1. Implement `DeepLinkCoordinator`:
   - Initialize and listen to `AppLinks.getInitialLink()` for Cold Start.
   - Buffer initial URI into `_stagedInitialLink` if router is not marked ready.
   - Listen to `AppLinks.uriLinkStream` for Warm Start.
   - Implement deduplication logic: ignore identical URIs received within 1000ms.
2. Implement `DeepLinkAuthGuard`:
   - If `payload.isProtected == true` and user session is unauthenticated:
     - Store `payload` into `_pendingPayload`.
     - Trigger navigation to `DeepLinkRoutes.login`.
     - Listen for `LoginSuccessEvent` on `AppEventBus` to retrieve and dispatch `_pendingPayload`, clearing the cache afterward.
   - If public route or user is authenticated, pass payload directly to navigation handler.
3. Register services in Host DI container (`lib/di/injection.dart`).

## Relevant Files & Context Pointers
- `lib/deeplink/deep_link_coordinator.dart` — [NEW] Core coordinator managing timing, streams, and staging.
- `lib/deeplink/deep_link_auth_guard.dart` — [NEW] Centralized auth guard and pending link store.
- `lib/di/injection.dart` — Host DI composition root.
- `packages/platform/lib/platform.dart` — Consumed for `DeepLinkParser`, `DeepLinkPayload`, `DeepLinkRegistry`, and `AppEventBus`.
- `test/deeplink/deep_link_coordinator_test.dart` — [NEW] Unit test suite with mock `AppLinks`.
- `test/deeplink/deep_link_auth_guard_test.dart` — [NEW] Unit test suite for auth guard and pending resume.

## Design Rationale
- **Decoupling Protocol from Host Orchestration:** `packages/platform` defines what a deep link payload is, while the Host (`lib/deeplink/`) decides how and when it should be executed based on the current app lifecycle and authentication state.
- **Skill Pointer:** Developers or agents working on this task should invoke `.agents/skills/test-driven-development/SKILL.md` to design the unit tests before writing the coordinator implementation.

## TDD Checklist
- [ ] **RED**:
  - Write unit tests in `test/deeplink/deep_link_coordinator_test.dart`:
    - Cold Start: When initial link is received before `markRouterReady()`, verify it is staged and not dispatched immediately.
    - Router Ready: When `markRouterReady()` is called, verify the staged link is parsed and dispatched.
    - Warm Start: When link stream emits a URI, verify immediate dispatch.
    - Deduplication: When two identical URIs emit within 500ms, verify handler is invoked only once.
  - Write unit tests in `test/deeplink/deep_link_auth_guard_test.dart`:
    - Public Route: Passes through to navigator directly.
    - Protected Route (Unauthenticated): Diverts to login and stores pending payload.
    - Post-Login Resume: Emitting `LoginSuccessEvent` dispatches the pending payload and resets the store.
  - Confirm tests fail before implementation.
- [ ] **GREEN**:
  - Implement `DeepLinkAuthGuard` with pending payload caching and event subscription.
  - Implement `DeepLinkCoordinator` with `AppLinks`, timing gates, and deduplication logic.
  - Wire services in DI container (`lib/di/`).
  - Run `flutter test test/deeplink/` and verify all tests pass.
- [ ] **REFACTOR**:
  - Clean up stream subscriptions, ensuring proper disposal on coordinator shutdown.
  - Run `dart format -l 99` and `melos run analyze`.

## Definition of Done (DoD)
- [ ] Over 90% unit test coverage on `DeepLinkCoordinator` and `DeepLinkAuthGuard`.
- [ ] Zero unhandled stream leaks or uncancelled subscriptions.
- [ ] Clean compilation and zero lint warnings.

## Dependencies & Blockers
- Blocked by: [Task 1: Platform DeepLink Protocol, Parser & Registry](task_1_deeplink_protocol_and_parser.md), [Task 2: Native OS Configuration & AppLinks Integration](task_2_native_os_and_app_links.md).
- Blocks: [Task 4: Shell Lifecycle Integration & Smart Hybrid Navigation](task_4_shell_lifecycle_and_hybrid_navigation.md).

## References & Rollback
- Design Spec: [2026-09-11-external-deeplink-engine-design.md](../epic/deeplink_router_engine/2026-09-11-external-deeplink-engine-design.md)
- Rollback Strategy: Revert changes in `lib/deeplink/` and DI registration.
