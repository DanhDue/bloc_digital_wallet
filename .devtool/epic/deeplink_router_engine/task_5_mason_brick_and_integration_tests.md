---
id: "task_5_mason_brick_and_integration_tests"
status: "done"
priority: "high"
assignee: null
epic: "deeplink_router_engine"
dueDate: null
created: "2026-09-11T01:58:25+07:00"
modified: "2026-09-11T02:37:30+07:00"
completedAt: "2026-09-11T02:37:30+07:00"
labels: ["mason", "brick", "automation", "integration_test", "governance"]
order: "a5"
---

# Task 5: Mason Brick Automation & E2E Integration Tests

Epic: [deeplink_router_engine](../epic/deeplink_router_engine/deeplink_router_engine.en.md)

## Requirement Analysis
To guarantee developer ergonomics in the Super App Template, creating a new Mini App via Mason must automatically integrate with the DeepLink Router Engine without manual boilerplate wiring. In addition, an end-to-end integration test must verify the entire flow from OS link reception to UI presentation.

Key Requirements:
1. Update `pac_mvi_feature` Mason Brick Hook:
   - In `bricks/pac_mvi_feature/hooks/post_gen.dart`:
      - Append a new route string constant to `packages/platform/lib/deeplink/deep_link_routes.dart` (e.g. `static const String {{name.camelCase()}} = '/{{name.snakeCase()}}';`).
      - Register the new feature route in `packages/platform/lib/deeplink/deep_link_registry.dart`.
2. Write End-to-End Integration Test:
   - Create `integration_test/deep_link_flow_test.dart` using Flutter `integration_test` package.
   - Verify that emitting a deep link (e.g. `d3nexus://scanner` or `d3nexus://settings`) transitions the UI properly from Tab 0 (Home) to the corresponding destination screen.
3. Validate with dry-run brick generation and cleanup.

## Relevant Files & Context Pointers
- `bricks/pac_mvi_feature/hooks/post_gen.dart` — Mason post-generation hook to enhance.
- `packages/platform/lib/deeplink/deep_link_routes.dart` — Target for auto-wired route constants.
- `packages/platform/lib/deeplink/deep_link_registry.dart` — Target for auto-wired registration.
- `integration_test/deep_link_flow_test.dart` — [NEW] End-to-end integration test.

## Design Rationale
- **Zero-Friction Scaffolding:** Developers should only focus on business logic inside their Mini App. Route registration and platform wiring must happen automatically upon scaffolding.
- **Skill Pointer:** Developers or agents working on this task should invoke `.agents/skills/flutter-add-integration-test/SKILL.md` to configure and run the integration test suite.

## Implementation Steps & Verification Checklist
- [x] **Brick Hook Enhancement**:
  - Edit `bricks/pac_mvi_feature/hooks/post_gen.dart` to inject route constants into `packages/platform/lib/deeplink/deep_link_routes.dart`.
  - Inject registration entry into `packages/platform/lib/deeplink/deep_link_registry.dart`.
  - Test brick generation locally with a dummy feature and verify clean injection.
  - Revert the dummy feature.
- [x] **Integration Test Implementation**:
  - Implement `integration_test/deep_link_flow_test.dart`:
    - Start the app with `app.main()`.
    - Pump and settle initial frame on Home (Tab 0).
    - Trigger `deepLinkCoordinator.onUriReceived(Uri.parse('d3nexus://scanner'))`.
    - Verify `ScannerPage` is visible and `currentTabIndex == 1`.
    - Trigger `deepLinkCoordinator.onUriReceived(Uri.parse('d3nexus://settings'))`.
    - Verify `SettingsPage` is visible and `currentTabIndex == 2`.
- [x] **Verification**:
  - Run `flutter test integration_test/deep_link_flow_test.dart`.
  - Run `melos run analyze` across all packages.

## Definition of Done (DoD)
- [x] `pac_mvi_feature` scaffolds a new feature that is immediately reachable via deep link.
- [x] Integration test passes cleanly.
- [x] No regression in existing test suites across the monorepo.

## Dependencies & Blockers
- Blocked by: [Task 4: Shell Lifecycle Integration & Smart Hybrid Navigation](task_4_shell_lifecycle_and_hybrid_navigation.md).
- Blocks: None (Epic Final Task).

## References & Rollback
- Design Spec: [2026-09-11-external-deeplink-engine-design.md](../epic/deeplink_router_engine/2026-09-11-external-deeplink-engine-design.md)
- Rollback Strategy: Revert `post_gen.dart` and delete `integration_test/deep_link_flow_test.dart`.
