---
id: "task_1_monorepo_restructuring"
status: "todo"
priority: "high"
assignee: null
epic: "flutter_super_app_template"
dueDate: null
created: "2026-09-06T18:05:00.000Z"
modified: "2026-09-06T18:05:00.000Z"
completedAt: null
labels: ["architecture", "monorepo"]
order: "a1"
---

# Task 1: Monorepo Directory Restructuring (Tri-Platform Parity)

Epic: [flutter_super_app_template](../epic/flutter_super_app_template/flutter_super_app_template.en.md)

## Requirement Analysis
Currently, all 13+ packages in `bloc_digital_wallet` reside in a flat `packages/` directory, blurring the boundary between shared platform infrastructure and independent feature mini-apps. Meanwhile, both sibling native super app templates (`android_super_app_template` and `ios_super_app_template`) have strictly partitioned their repositories into `packages/` (core, framework, network, platform, ui_kit) and `features/` (settings, scanner).

This task establishes 100% Tri-Platform Parity by:
1. Creating a top-level `features/` directory in the repository.
2. Relocating `packages/settings` to `features/settings`.
3. Relocating `packages/scanner` to `features/scanner`.
4. Updating `melos.yaml` and the root `pubspec.yaml` Dart workspace definitions to include both `packages/*` and `features/*`.
5. Adjusting relative path dependencies in `features/settings/pubspec.yaml` and `features/scanner/pubspec.yaml` (from `../core` to `../../packages/core`, etc.).

## Relevant Files & Context Pointers
- `melos.yaml`
- `pubspec.yaml`
- `packages/settings/pubspec.yaml` -> `features/settings/pubspec.yaml`
- `packages/scanner/pubspec.yaml` -> `features/scanner/pubspec.yaml`
- `lib/app_router.dart`
- `lib/di/injection.dart`
- Reference: `/Users/danhdue/AllProjects/digital_wallet/android_digital_wallet/.worktrees/android_super_app_template`
- Reference: `/Users/danhdue/AllProjects/digital_wallet/iOSDigitalWallet/.worktrees/ios_super_app_template`

## Design Rationale
Decoupling features from infrastructure packages prevents architectural ambiguity and simplifies CI governance scanning. The path depth change from `../<pkg>` to `../../packages/<pkg>` is minimal and standardized. Melos natively supports wildcard package roots (`packages/*` and `features/*`).
Applicable skill: `subagent-driven-development` / `verification-before-completion`.

## TDD Checklist
*TDD Adaptation:* This task is an architectural restructuring and configuration update with no new business logic code. The standard RED/GREEN/REFACTOR cycle is adapted into structural verification:
- [ ] **PRE-CHECK**: Run `melos bootstrap && melos run analyze` to confirm clean baseline before moving.
- [ ] **RESTRUCTURE**:
  - [ ] Create `features/` directory.
  - [ ] Move `packages/settings` to `features/settings` via `git mv`.
  - [ ] Move `packages/scanner` to `features/scanner` via `git mv`.
  - [ ] Update `melos.yaml` `packages` globs to include `'features/*'`.
  - [ ] Update root `pubspec.yaml` `workspace` entries to reference `features/settings` and `features/scanner`.
  - [ ] Fix relative paths in `features/settings/pubspec.yaml` and `features/scanner/pubspec.yaml` to point to `../../packages/<pkg>`.
- [ ] **VERIFY**:
  - [ ] Execute `melos bootstrap` to re-link workspace members.
  - [ ] Run `melos genAlls` to ensure code generation succeeds with updated paths.
  - [ ] Run `dart analyze` across workspace with zero errors.
  - [ ] Run `fvm flutter test` in `features/settings` to ensure tests pass.

## Definition of Done (DoD)
1. `features/settings` and `features/scanner` live in `features/`.
2. `packages/` only contains infrastructure, utility, and plugin packages.
3. `melos bootstrap` and `melos genAlls` complete with exit code 0.
4. All existing tests pass without regressions.

## Dependencies & Blockers
- Blocked by: None
- Blocks: [Task 2](task_2_pac_mvi_feature_brick.md), [Task 6](task_6_template_trimming_and_shell.md)

## References & Rollback
- Source Spec: [2026-09-06-flutter-super-app-template-design.md](../epic/flutter_super_app_template/2026-09-06-flutter-super-app-template-design.md)
- Rollback: `git checkout develop` or `git revert` the restructuring commit.
