# Epic: Template — Flutter/Dart Trimming

## Table of Contents
1. [Meta Data](#1-meta-data)
2. [Background](#2-background)
3. [Goals & Non-Goals](#3-goals--non-goals)
4. [Scope](#4-scope)
5. [Kanban Tasks Breakdown](#5-kanban-tasks-breakdown)

## 1. Meta Data
- **Epic**: `template_flutter`
- **Status**: Planning
- **Parent spec**: [flutter_super_app_template.en.md](../flutter_super_app_template/flutter_super_app_template.en.md), [2026-08-29-flutter-super-app-template-design.md §4](../flutter_super_app_template/2026-08-29-flutter-super-app-template-design.md)
- **Sibling epics**: [template_android](../template_android/template_android.en.md), [template_ios](../template_ios/template_ios.en.md)
- **Split rationale**: the combined native+Flutter template work was too large for one epic; split along platform lines so each can be planned, executed, and reviewed independently. Recommended order: `template_android`/`template_ios` first (native foundation), `template_flutter` last — but this epic's Tasks 1–6 have no hard dependency on the native epics and can start in parallel.
- **Working location (decided 2026-08-29)**: all work happens on a **git worktree of this same `bloc_digital_wallet` repo** (e.g. `.worktrees/flutter_super_app_template`), not a separate, freshly `git init`'d repo. Spinning it out into an independent repo is deferred to a later decision, not a blocker for this epic.

## 2. Background
`bloc_digital_wallet` is a mature Clean Architecture + MVI monorepo carrying a full digital-wallet product (7 feature packages, 90 locales, domain-specific assets, a large `.agent`/`.devtool` history). The goal is a clone-and-rename starter template: strip the digital-wallet domain down to one real reference feature (`settings`) and one empty skeleton feature (`scanner`), keep every piece of reusable tooling (Mason bricks, CI gate, scripts), and add a single rename entrypoint so a new project is a clone + one script run away.

## 3. Goals & Non-Goals

### Goals
- Reduce the feature package set to `settings` (real) + `scanner` (empty, generated) while keeping all infra packages (`core`, `framework`, `network`, `native_security`, `ui_kit`, `platform`, `logger`, `logger_native_bridge`) intact.
- Rebuild the Host `lib/` around a 3-tab Shell (home stub, scanner, settings) with settings as the landing tab, no custom splash.
- Keep the full 90-locale localization setup and SF Compact fonts; remove only digital-wallet-specific assets.
- Keep `pac_mvi_feature`/`pac_mvi_subfeature`/`remove_pac_feature`/`remove_pac_subfeature` **and** the deprecated `lib/features/`-targeting bricks (`mvi_feature`, `mvi_subfeature`, `sample`, `remove_feature`, `remove_subfeature`, `remove_sample`, `test_brick`) — kept, not deleted, in case a future project doesn't adopt package-first organization. Fix `pac_mvi_feature`'s post-gen hook so it still wires new features correctly once `onboard` (its current anchor) is gone.
- Trim `.agent/`, `.devtool/epic/`, `docs/`, and multi-IDE config to a lean, generic set.
- Ship a single `scripts/rename_project.sh` as the only step a new project needs to run after cloning. It renames Dart/Android/iOS project identity but **never** touches the plugin packages' fixed `com.danhdue.*` Kotlin/Swift namespace — that stays constant regardless of the consuming project's org.
- Keep `.gitlab-ci.yml` as-is (including the Firebase-secrets-copy and `buildIPA` steps) as a worked reference sample for a new project to adapt, rather than stripping it to a minimal skeleton.

### Non-Goals
- Any native (Android/Kotlin, iOS/Swift) architecture work — see `template_android`/`template_ios`.
- Phase 3 items from the parent design doc (OS-integrated plugin safety, Go binding) — explicitly parked, not part of this epic.
- Redesigning the digital-wallet domain itself — it is deleted, not migrated.

## 4. Scope
Full package-keep/remove list, Shell tab layout, locale/asset decisions, and the CI/rename-script design are already finalized in the parent spec — this epic implements them. See the Kanban breakdown below for the concrete task split; each task file links back to the exact section of the parent design doc it implements.

## 5. Kanban Tasks Breakdown

| # | Task | Summary |
|---|---|---|
| 1 | [Trim package inventory](../../features/task_1_trim_package_inventory.md) | Remove `authentication`/`onboard`/`wallet`/`transaction`/`trends`/`d3nexus_logger`; generate empty `scanner` via `pac_mvi_feature`. |
| 2 | [Rebuild Host Shell](../../features/task_2_rebuild_host_shell.md) | 3-tab Shell (home stub/scanner/settings), drop custom splash, update `app_router.dart`/`injection.dart`/`AuthNavigationInitializer`. |
| 3 | [Asset & locale cleanup](../../features/task_3_asset_locale_cleanup.md) | Remove wallet-specific images/lotties/jsons; keep all 90 locales and SF Compact fonts. |
| 4 | [Mason bricks cleanup](../../features/task_4_mason_bricks_cleanup.md) | Keep the deprecated `lib/features/`-era bricks as-is; fix `pac_mvi_feature` post-gen hook's `onboard` anchor. |
| 5 | [Docs & `.agent` cleanup](../../features/task_5_docs_agent_cleanup.md) | Scrub project-name references, trim `.devtool/epic`/`docs/`, consolidate multi-IDE config. |
| 6 | [CI config sync](../../features/task_6_ci_simplification.md) | Keep `.gitlab-ci.yml` as a reference sample; sync `module_boundary_whitelist.txt`/`FEATURE_PACKAGES` to the trimmed package set. |
| 7 | [Rename script](../../features/task_7_rename_script.md) | `scripts/rename_project.sh` — the clone-and-rename entrypoint (native plugin namespace stays fixed). |
| 8 | [Worktree extraction & validation](../../features/task_8_extraction_validation.md) | Set up a dedicated git worktree in this repo; run the full rename→build loop end to end on it. |
