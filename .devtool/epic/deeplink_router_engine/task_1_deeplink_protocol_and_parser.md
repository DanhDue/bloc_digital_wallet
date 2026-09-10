---
id: "task_1_deeplink_protocol_and_parser"
status: "done"
priority: "high"
assignee: null
epic: "deeplink_router_engine"
dueDate: null
created: "2026-09-11T01:58:25+07:00"
modified: "2026-09-11T02:17:40+07:00"
completedAt: "2026-09-11T02:17:40+07:00"
labels: ["architecture", "routing", "platform", "tdd"]
order: "a1"
---

# Task 1: Platform DeepLink Protocol, Parser & Registry

Epic: [deeplink_router_engine](../epic/deeplink_router_engine/deeplink_router_engine.en.md)

## Requirement Analysis
In order to support decoupled deep-link routing across all feature modules without introducing cross-module dependencies, `packages/platform` must provide a standardized, pure Dart protocol to parse, normalize, and register route mappings.

Key Requirements:
1. Define `DeepLinkPayload` immutable data class containing `path`, `queryParams`, `targetTab`, and `isProtected`.
2. Implement `DeepLinkParser` to convert any raw URI (Custom Scheme `d3nexus://...` or HTTPS App/Universal Links `https://app.d3nexus.com/...`) into a normalized `DeepLinkPayload`.
   - Must handle case insensitivity.
   - Must normalize trailing slashes (`/scanner/` -> `/scanner`).
   - Must parse query parameters into `Map<String, String>`.
   - Must safely return fallback/null for malformed URIs without throwing unhandled exceptions.
3. Implement `DeepLinkRegistry` to hold public route definitions and map URI paths to target shell tab indices (Home: 0, Scanner: 1, Settings: 2) and protected route flags.

## Relevant Files & Context Pointers
- `packages/platform/lib/deeplink/deep_link_routes.dart` — Existing route constants (`DeepLinkRoutes.home`, `scanner`, `settings`).
- `packages/platform/lib/deeplink/deep_link_payload.dart` — [NEW] Immutable payload model.
- `packages/platform/lib/deeplink/deep_link_parser.dart` — [NEW] Pure Dart URI parser and normalizer.
- `packages/platform/lib/deeplink/deep_link_registry.dart` — [NEW] Route catalog and resolver.
- `packages/platform/lib/platform.dart` — Export barrel for `packages/platform`.
- `packages/platform/test/deep_link_parser_test.dart` — [NEW] Unit test suite for parser and registry.

## Design Rationale
- **Pure Dart Independence:** Implementing the protocol in `packages/platform` ensures it has zero dependencies on Flutter UI bindings or native plugins. It executes in pure Dart VM, allowing 100% unit-test coverage in milliseconds.
- **Skill Pointer:** Developers or agents working on this task should follow `.agents/skills/test-driven-development/SKILL.md` to ensure rigorous TDD cycle execution.

## TDD Checklist
- [ ] **RED**:
  - Write unit tests in `packages/platform/test/deep_link_parser_test.dart` for:
    - Custom Scheme parsing: `d3nexus://scanner?auto_scan=true` -> `path: '/scanner'`, `queryParams: {'auto_scan': 'true'}`, `targetTab: 1`.
    - Universal Link parsing: `https://app.d3nexus.com/settings/languages` -> `path: '/settings/languages'`, `targetTab: 2`.
    - Trailing slashes and case variations: `D3NEXUS://HOME/` -> `path: '/home'`, `targetTab: 0`.
    - Malformed or unrecognized URIs -> returns safe fallback payload or handles null gracefully.
  - Confirm tests fail to compile/run before implementation.
- [ ] **GREEN**:
  - Implement `DeepLinkPayload` with equality and `toString()`.
  - Implement `DeepLinkParser` with regex / `Uri` standard library normalization.
  - Implement `DeepLinkRegistry` with default mappings for `home`, `scanner`, and `settings`.
  - Export new public API via `packages/platform/lib/platform.dart`.
  - Confirm all unit tests pass.
- [ ] **REFACTOR**:
  - Ensure code formatting adheres to project conventions (`dart format -l 99`).
  - Run `melos run analyze` across the workspace to ensure zero linter warnings.

## Definition of Done (DoD)
- [ ] 100% line and branch coverage on `DeepLinkParser` and `DeepLinkRegistry`.
- [ ] Zero compile errors and zero lint warnings (`dart analyze --fatal-infos`).
- [ ] All public classes documented with dartdoc comments.

## Dependencies & Blockers
- Blocked by: None.
- Blocks: [Task 2: Native OS Configuration & AppLinks Integration](task_2_native_os_and_app_links.md), [Task 3: DeepLink Coordinator, Auth Guard & Deduplication](task_3_deeplink_coordinator_and_auth_guard.md).

## References & Rollback
- Source Design Spec: [2026-09-11-external-deeplink-engine-design.md](../epic/deeplink_router_engine/2026-09-11-external-deeplink-engine-design.md)
- Rollback Strategy: Revert changes in `packages/platform/` via git checkout; no host app impact.
