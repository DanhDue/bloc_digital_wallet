---
id: "task_4_mason_bricks_platform"
status: "done"
priority: "medium"
assignee: null
epic: "super_app_governance"
dueDate: null
created: "2026-08-26T10:00:00.000Z"
modified: "2026-08-26T19:11:27.000Z"
completedAt: "2026-08-26T19:11:27.000Z"
labels: ["mason", "tooling", "governance"]
order: "a4"
---
# Task 4: Update Mason bricks for `platform`

Epic: [super_app_governance](../epic/super_app_governance/super_app_governance.en.md)

## Requirement Analysis
The `pac_mvi_feature` brick's `post_gen.dart` hook currently writes each new feature's public route into `packages/core/lib/utils/feature_public_routes.dart`. After Task 1 relocates that mechanism to `packages/platform/lib/deep_link_routes.dart`, every newly-scaffolded package must be wired into the new location and dependency by default — otherwise this epic's own tooling would keep regenerating the pattern it's trying to retire. The four orphaned bricks targeting the unused `lib/features/` pattern (`mvi_feature`, `mvi_subfeature`, `remove_feature`, `remove_subfeature`) are kept per explicit user decision, but marked deprecated so `mason list` warns contributors away from them.

**Naming note (Task 1 ruling — read before editing pubspec templates):** the package's pubspec `name:` is `app_platform`, not `platform` — a real pub.dev package named `platform` is already a transitive dependency (via `settings → path_provider → path_provider_platform_interface`), and Dart pub has no name-aliasing for a local `path:` package colliding with a hosted one. The **directory** is still `packages/platform/`. Every pubspec dependency line this task generates must use the key `app_platform:` (e.g. `app_platform: {path: ../platform}`), while generated Dart code that imports it should alias `as platform` so call sites still read `platform.someName` as originally designed. See Task 1's report (`.superpowers/sdd/super_app_governance.en/task-9-report.md`) and the epic ledger for the full rationale.

## Relevant Files & Context Pointers
- `bricks/pac_mvi_feature/hooks/post_gen.dart` — `_updateFeaturePublicRoutes` function, retarget its file path to `packages/platform/lib/deep_link_routes.dart`.
- `bricks/pac_mvi_feature/__brick__/packages/{{name.snakeCase()}}/pubspec.yaml` — add `app_platform: {path: ../platform}` (dependency **key** is `app_platform`, not `platform`) alongside the existing `core`/`network`/`ui_kit`/`framework` local dependencies.
- `bricks/remove_pac_feature/hooks/` — extend cleanup to remove the package's entry from `packages/platform/lib/deep_link_routes.dart`.
- `bricks/mvi_feature/brick.yaml`, `bricks/mvi_subfeature/brick.yaml`, `bricks/remove_feature/brick.yaml`, `bricks/remove_subfeature/brick.yaml` — prefix each `description:` field with `[DEPRECATED — use pac_mvi_feature/pac_mvi_subfeature instead]`.
- `bricks/pac_mvi_subfeature/` — no change (subfeature routes correctly stay internal to the owning package's router).
- Check `.agents/skills/create_new_feature/` for any doc referencing `feature_public_routes.dart` by path and update it if so.

## Design Rationale
Barrel-export discipline in the brick's `{{name}}.dart` template is already correct (only exports domain/presentation/DI/router, never `data/**`) — no change needed there. Reference the source spec's "Mason / Bricks changes" section for the full list of what does and doesn't change. `pac_mvi_subfeature` is explicitly out of scope — subfeature routes are not meant to be publicly deep-linkable by default.

## TDD Adaptation
Brick template edits — verification is generation-based, not unit tests:
1. Run `mason make pac_mvi_feature` with a scratch package name in a throwaway location; confirm the generated `pubspec.yaml` includes the `app_platform: {path: ../platform}` dependency and the `post_gen.dart` hook writes the route entry into `packages/platform/lib/deep_link_routes.dart` (not the old `core` path).
2. Run `mason make remove_pac_feature` against that same scratch package; confirm its `packages/platform/lib/deep_link_routes.dart` entry is cleaned up.
3. Run `mason list`; confirm the four legacy bricks show the `[DEPRECATED...]` prefix in their descriptions.
4. Delete the scratch package/branch used for verification.

## Definition of Done (DoD)
- [ ] A freshly-generated `pac_mvi_feature` package depends on `app_platform` (pubspec key) and registers its route in `packages/platform/lib/deep_link_routes.dart`.
- [ ] `remove_pac_feature` correctly cleans up the `deep_link_routes.dart` entry it added.
- [ ] All four legacy bricks' `brick.yaml` descriptions carry the `[DEPRECATED...]` prefix.
- [ ] No remaining reference to the old `core/utils/feature_public_routes.dart` path anywhere in `bricks/`.

## Dependencies & Blockers
Blocked by [Task 1](task_1_create_platform_package.md) — the brick must target a `platform` package that already exists.

## References & Rollback
- Source spec: [Mason / Bricks changes section](../epic/super_app_governance/2026-08-26-super-app-governance-design.md#mason--bricks-changes).
- Rollback: revert the hook/template/brick.yaml edits — no effect on already-generated packages either way.
