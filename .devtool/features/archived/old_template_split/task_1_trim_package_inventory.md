---
id: "task_1_trim_package_inventory"
status: "todo"
priority: "high"
assignee: null
epic: "template_flutter"
dueDate: null
created: "2026-08-29T00:00:00.000Z"
modified: "2026-08-29T00:00:00.000Z"
completedAt: null
labels: ["package", "cleanup"]
order: "a1"
---
# Task 1: Trim Package Inventory

Epic: [template_flutter](../epic/template_flutter/template_flutter.en.md)

## Requirement Analysis
The template must ship exactly two feature packages — `settings` (kept as-is, the one real reference feature) and `scanner` (regenerated empty via `pac_mvi_feature`, a blank skeleton) — with every digital-wallet-domain feature package removed. All infra packages (`core`, `framework`, `network`, `native_security`, `ui_kit`, `platform`, `logger`, `logger_native_bridge`) stay untouched by this task.

## Relevant Files & Context Pointers
- `packages/authentication/`, `packages/onboard/`, `packages/wallet/`, `packages/transaction/`, `packages/trends/` — delete entirely.
- `packages/scanner/` — delete the existing wallet-domain version; regenerate empty via `mason make pac_mvi_feature`.
- `packages/d3nexus_logger/` — delete (empty stub, never in the workspace list).
- `pubspec.yaml` (root `workspace:`/`dependencies:`), `melos.yaml` — remove entries for deleted packages.
- `scripts/module_boundary_whitelist.txt` — the `onboard→settings` entry becomes irrelevant once `onboard` is deleted (also touched by Task 6).

## Design Rationale
See parent spec §"Package inventory" (`flutter_super_app_template.en.md` §2, row for feature-package keep list) and design doc §4.1. `settings` survives because it is generic (theme/locale/app-info) and already exercises `DeepLinkRoutes`/`AppEventBus`; `scanner` survives as an empty package specifically so the template demonstrates the Shell's 3-tab composition without carrying wallet domain logic.

## TDD Checklist

**TDD Adaptation**: structural cleanup/rewiring with no new business logic to drive with a failing test — RED/GREEN/REFACTOR does not apply. Verified instead via the concrete steps below plus `melos run analyze`/`melos run test` for regressions.

- [ ] Delete `packages/{authentication,onboard,wallet,transaction,trends,d3nexus_logger}`.
- [ ] Run `mason make pac_mvi_feature` with `name=scanner`, let the post-gen hook wire it into root `pubspec.yaml` (note: Task 4 fixes the hook's `onboard` anchor — do this task's brick run *after* Task 4, or expect to hand-fix the wiring here).
- [ ] Remove the deleted packages from root `pubspec.yaml` `workspace:`/`dependencies:` and from `melos.yaml` if listed there.
- [ ] `melos bootstrap` succeeds with only `core`, `framework`, `network`, `native_security`, `ui_kit`, `platform`, `logger`, `logger_native_bridge`, `settings`, `scanner` in the workspace.

## Definition of Done (DoD)
- [ ] `find packages -maxdepth 1` shows exactly the 10 packages listed above.
- [ ] `melos bootstrap` and `melos run analyze` succeed (Task 2's Host-side wiring may still be red until that task lands — acceptable here).
- [ ] No remaining reference to the deleted packages' pub names anywhere in `pubspec.yaml`/`melos.yaml`.

## Dependencies & Blockers
- **Dependencies**: Sequencing note with [Task 4](task_4_mason_bricks_cleanup.md) (brick hook fix) — see TDD Checklist above.
- **Blockers**: None.

## References & Rollback
- **References**: [flutter_super_app_template.en.md §2, §4](../epic/flutter_super_app_template/flutter_super_app_template.en.md).
- **Rollback Plan**: `git revert` this task's commit; the deleted packages are recoverable from git history if a decision reverses.
