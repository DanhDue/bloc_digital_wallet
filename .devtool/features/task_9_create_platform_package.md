---
id: "task_9_create_platform_package"
status: "todo"
priority: "high"
assignee: null
epic: "super_app_governance"
dueDate: null
created: "2026-08-26T10:00:00.000Z"
modified: "2026-08-26T16:51:29.000Z"
completedAt: null
labels: ["architecture", "platform", "routing"]
order: "a9"
---
# Task 9: Create `platform` package — DeepLinkRoutes relocation

Epic: [super_app_governance](../epic/super_app_governance/super_app_governance.en.md)

## Requirement Analysis
A routing-decoupling mechanism already exists — `packages/core/lib/utils/feature_public_routes.dart` (`FeaturePublicRoutes`) — auto-generated per feature by the `pac_mvi_feature` brick, defining name-string `PageRouteInfo` constants so callers navigate without importing a feature's router/page classes. It works but is used in exactly one place (`onboard/splash_page.dart`) and lives inside `core`, which also carries unrelated auth/localization/theme/service concerns. This task creates a new dedicated `platform` workspace package and relocates the mechanism into it (renamed `DeepLinkRoutes`), establishing the package other tasks in this epic (10, 12, 14) build on.

## Relevant Files & Context Pointers
- `packages/core/lib/utils/feature_public_routes.dart` — source to relocate (delete after move).
- `packages/onboard/lib/presentation/splash/splash_page.dart` — the one existing call site; update its import/reference to the new location.
- `pubspec.yaml` (root) — add `platform` to the `workspace:` list and `dependencies:`.
- `melos.yaml` — no change expected (packages glob is `packages/**`, already covers a new package).
- `lib/di/injection.dart` — register `platform.configureModuleDependencies(getIt)` alongside the existing feature registrations.
- New files: `packages/platform/pubspec.yaml`, `packages/platform/lib/platform.dart` (barrel), `packages/platform/lib/deep_link_routes.dart`, `packages/platform/lib/di/injection.dart`.

## Design Rationale
`platform` is infrastructure shared by every Mini App, not an MVI feature — model its package layout after `network`/`ui_kit` (flat `lib/`, no `domain`/`data`/`presentation` split), not after the `pac_mvi_feature` brick output. No `.agent/skills/` entry targets shared-infra package creation specifically; follow the existing `network`/`ui_kit` package structure as the reference pattern. See the epic's source spec's "`platform` package" and "Approach A" (rejected: putting this in `core` instead) sections for why this is a separate package.

## TDD Adaptation
This task is a relocation + wiring change with no new business logic (the route-resolution mechanism itself is unchanged, only its location and name). RED/GREEN/REFACTOR doesn't apply. Concrete verification steps instead:
1. Move the file content, rename `FeaturePublicRoutes` → `DeepLinkRoutes`, update `splash_page.dart`'s reference.
2. Run `melos bootstrap` — must succeed with `platform` resolved as a workspace member.
3. Run `flutter analyze` (root + `platform` + `onboard`) — must show no issues, and no remaining reference to `core/utils/feature_public_routes.dart` anywhere in the repo (`grep -r "feature_public_routes" .` returns nothing outside git history).
4. Manual smoke test: launch the app, complete onboarding, confirm it still navigates to the Settings screen exactly as before.

## Definition of Done (DoD)
- [ ] `packages/platform` exists, is a workspace member, and is a dependency of `onboard` (the only current consumer).
- [ ] `DeepLinkRoutes` in `packages/platform/lib/deep_link_routes.dart` has identical route constants to the old `FeaturePublicRoutes` (splash, login, settings, home, trends, wallet, scanner, transaction).
- [ ] `packages/core/lib/utils/feature_public_routes.dart` is deleted; no dangling references anywhere.
- [ ] `melos bootstrap`, `flutter analyze`, and the onboarding→settings manual smoke test all pass.

## Dependencies & Blockers
None — this is the foundation task other tasks in this epic depend on.

## References & Rollback
- Source spec: [platform package section](../epic/super_app_governance/2026-08-26-super-app-governance-design.md#platform-package).
- Rollback: revert the commit — this is a pure relocation with a single existing call site, low blast radius.
