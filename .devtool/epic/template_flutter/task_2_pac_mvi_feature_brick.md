---
id: "task_2_pac_mvi_feature_brick"
status: "done"
priority: "high"
assignee: null
epic: "flutter_super_app_template"
dueDate: null
created: "2026-09-06T18:05:00.000Z"
modified: "2026-09-06T18:27:00.000Z"
completedAt: "2026-09-06T18:27:00.000Z"
labels: ["mason", "tooling"]
order: "a2"
---

# Task 2: Brick `pac_mvi_feature` Update

Epic: [flutter_super_app_template](../epic/flutter_super_app_template/flutter_super_app_template.en.md)

## Requirement Analysis
The `pac_mvi_feature` Mason brick currently scaffolds new feature packages into `packages/{{name.snakeCase()}}` and relies on `import 'package:onboard/onboard.dart' as onboard;` as an anchor in its `post_gen.dart` hook for code injection (DI, Router, Workspace, DeepLinkRoutes). Since `onboard` is being removed from the template and feature packages must now reside in `features/`, this brick and its companion subfeature/removal bricks must be updated.

Requirements:
1. Update `bricks/pac_mvi_feature/__brick__` output target from `packages/{{name.snakeCase()}}` to `features/{{name.snakeCase()}}`.
2. Update `pubspec.yaml` template inside `pac_mvi_feature` so relative dependencies to `core`, `framework`, `network`, `ui_kit`, `platform` point to `../../packages/<pkg>`.
3. In `hooks/post_gen.dart`:
   - Change all 5 injection anchor targets from `onboard` to `settings`.
   - Update workspace registration in root `pubspec.yaml` to register `- features/{{name}}`.
   - Update `lib/di/injection.dart` to inject `{{name.pascalCase()}}PackageModule`.
   - Update `lib/app_router.dart` to include `{{name.pascalCase()}}Router()`.
   - Update `packages/platform/lib/deep_link_routes.dart` to append `{{name.camelCase()}}Route`.
4. Update companion bricks:
   - `pac_mvi_subfeature`: target `features/{{feature.snakeCase()}}/lib/presentation/{{name.snakeCase()}}`.
   - `remove_pac_feature`: target `features/{{name.snakeCase()}}` and remove its registration entries from `pubspec.yaml`, `injection.dart`, `app_router.dart`, and `deep_link_routes.dart`.
   - `remove_pac_subfeature`: target `features/{{feature.snakeCase()}}`.

## Relevant Files & Context Pointers
- `bricks/pac_mvi_feature/brick.yaml`
- `bricks/pac_mvi_feature/__brick__/`
- `bricks/pac_mvi_feature/hooks/post_gen.dart`
- `bricks/pac_mvi_subfeature/`
- `bricks/remove_pac_feature/`
- `bricks/remove_pac_subfeature/`
- `lib/app_router.dart`
- `lib/di/injection.dart`
- `packages/platform/lib/deep_link_routes.dart`

## Design Rationale
Using `settings` as the permanent anchor guarantees that newly generated features are auto-wired cleanly into DI, routing, and public deep links without requiring manual boilerplate.
Applicable skills: `writing-skills`, `create_new_feature`.

## TDD Checklist
- [ ] **RED**: Run test generation of a mock feature `sample_feature` using the un-updated brick to capture the failure/misplacement into `packages/`.
- [ ] **GREEN**:
  - [ ] Retarget `pac_mvi_feature/__brick__` to `features/{{name.snakeCase()}}`.
  - [ ] Adjust `pubspec.yaml` paths to `../../packages/*`.
  - [ ] Retarget `post_gen.dart` anchor strings from `onboard` to `settings`.
  - [ ] Update `remove_pac_feature` hook and targets to match `features/`.
  - [ ] Update `pac_mvi_subfeature` and `remove_pac_subfeature` to target `features/`.
  - [ ] Run `mason make pac_mvi_feature --name test_feature` and verify generation in `features/test_feature`.
- [ ] **REFACTOR**:
  - [ ] Run `melos bootstrap && melos genAlls`.
  - [ ] Run `remove_pac_feature --name test_feature` to confirm complete and clean removal.
  - [ ] Run `git status` to ensure working tree returns to clean state.

## Definition of Done (DoD)
1. `mason make pac_mvi_feature --name <name>` generates files in `features/<name>/`.
2. DI, AutoRoute, workspace `pubspec.yaml`, and `DeepLinkRoutes` are updated automatically with zero syntax errors.
3. `melos genAlls` succeeds on the newly generated feature.
4. `remove_pac_feature` cleanly reverses all changes.

## Dependencies & Blockers
- Blocked by: [Task 1](task_1_monorepo_restructuring.md)
- Blocks: [Task 6](task_6_template_trimming_and_shell.md)

## References & Rollback
- Source Spec: [2026-09-06-flutter-super-app-template-design.md](../epic/flutter_super_app_template/2026-09-06-flutter-super-app-template-design.md) §4.1
- Rollback: Revert modifications to `bricks/pac_mvi_feature/` and companion bricks.
