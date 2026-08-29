# Epic: Template — Android Native Architecture

## Table of Contents
1. [Meta Data](#1-meta-data)
2. [Background](#2-background)
3. [Goals & Non-Goals](#3-goals--non-goals)
4. [Scope](#4-scope)
5. [Kanban Tasks Breakdown](#5-kanban-tasks-breakdown)

## 1. Meta Data
- **Epic**: `template_android`
- **Status**: Planning
- **Parent spec**: [flutter_super_app_template.en.md](../flutter_super_app_template/flutter_super_app_template.en.md), [2026-08-29-flutter-super-app-template-design.md §3](../flutter_super_app_template/2026-08-29-flutter-super-app-template-design.md)
- **Sibling epics**: [template_flutter](../template_flutter/template_flutter.en.md), [template_ios](../template_ios/template_ios.en.md)
- **Source references**: `android_digital_wallet` (Android MVI + `buildSrc` source to port from), `vchat_shield` (native code whose mistakes this epic's crash-boundary rules exist to prevent — its OS-integrated patterns are Phase 3, out of scope here)

## 2. Background
Today the repo has exactly two Android native surfaces — `native_security` (FFI plugin) and `logger_native_bridge` (Pigeon plugin) — each with its own flat Kotlin source, no shared layering convention, no lint/format tooling, and duplicated `kotlin_version`/AGP boilerplate in their `build.gradle`. Separately, `android_digital_wallet` (a sibling native project) already has a working MVI ViewModel (`MviViewModel`/`MvvmViewModel`/`ViewState`) and a full `buildSrc` (Spotless, Detekt, Hilt+Compose convention plugins, a version catalog). This epic ports the reusable parts of that into the template's `android/`, establishes a `platform/domain/data(/presentation)` layering convention, and produces a single parameterized Mason brick so any future Android-side native module is generated consistently instead of hand-rolled.

## 3. Goals & Non-Goals

### Goals
- Port `android/buildSrc`'s quality convention (Spotless/ktlint + Detekt, one shared ruleset) so it applies to **every** native module including plugin packages — proven feasible because Flutter's plugin loader makes every plugin a subproject of the same root Gradle build as the host app at build time.
- Port the Hilt+Compose convention plugin, applied **only** to modules that own a native screen (`has_ui=true`).
- Create native `core` (`SafeExecution`, `DataState<T>`, `Logger`, `Container`, `ReplayQueue`) as a mandatory dependency for every native module, UI or not.
- Create native `framework` (`MviViewModel`/`MvvmViewModel`/`ViewState`), ported from `android_digital_wallet`, depending only on native `core`.
- Refactor `native_security` and `logger_native_bridge`'s Kotlin source into `platform/domain/data`, remove their `kotlin_version`/AGP duplication, get them lint/format-clean.
- Keep plugin packages DI-framework-agnostic (manual `Container`, no Hilt) so they stay usable in any Flutter app.
- Ship one parameterized Mason brick, `native_package(trigger, has_ui)`, covering all 4 quadrants (Ô1–Ô4) from one source instead of 3–4 separately-maintained bricks.
- Ship `scripts/native_add_ui_dependency.sh` — the tool half of upgrading an existing no-UI package to add UI later (Android side).
- Ship `scripts/extract_native_standalone_android.sh` so `core`/`framework`/`buildSrc` — already Flutter-independent by construction — can be extracted into a fresh, standalone native Android app repo (no Flutter involvement) whenever a project needs pure native development.

### Non-Goals
- iOS work of any kind — see `template_ios`.
- Phase 3 (OS-integrated plugin safety patterns, Go binding) — parked; only the crash-boundary primitive (`core.SafeExecution`) that Phase 3 will eventually rely on is built here.
- Rewriting `vchat_shield` itself — it is a reference for lessons only, not a migration target.

## 4. Scope
The use-case matrix (trigger × has_ui), the `core`/`framework` split, the single-brick strategy, and the per-use-case diagrams are already finalized in the parent spec — this epic implements the Android half. See the Kanban breakdown for the task split.

## 5. Kanban Tasks Breakdown

| # | Task | Summary |
|---|---|---|
| 1 | [Port `buildSrc`](../../features/task_1_buildsrc_port.md) | Quality convention (Spotless/Detekt) + Hilt/Compose convention, trimmed from `android_digital_wallet`. |
| 2 | [Native `core` module](../../features/task_2_native_core_module_android.md) | `SafeExecution`, `DataState<T>`, `Logger`, `Container`, `ReplayQueue`. |
| 3 | [Native `framework` module](../../features/task_3_native_framework_module.md) | `MviViewModel`/`MvvmViewModel`/`ViewState`, ported and adapted. |
| 4 | [Refactor `native_security`](../../features/task_4_refactor_native_security_android.md) | Reorganize into `platform/domain/data`, apply quality convention. |
| 5 | [Refactor `logger_native_bridge`](../../features/task_5_refactor_logger_native_bridge_android.md) | Same treatment; wire `ReplayQueue` generalized from its existing replay logic. |
| 6 | [`native_android_package` brick](../../features/task_6_native_package_brick_android.md) | Standalone, parameterized brick generating Ô1–Ô4 Android scaffolding (separate from iOS's brick). |
| 7 | [`native_add_ui_dependency.sh`](../../features/task_7_add_ui_dependency_tool_android.md) | Adds `framework` dependency + Hilt/Compose convention + Hilt↔`Container` bridge to an existing package. |
| 8 | [Go binding guide (Android half)](../../features/task_8_go_binding_guide_android.md) | `docs/architecture/native-go-binding.md` — gomobile `.aar`, panic-recovery snippet for JNI. |
| 9 | [Standalone-repo extraction](../../features/task_9_standalone_extraction_android.md) | `scripts/extract_native_standalone_android.sh` — spin `core`/`framework`/`buildSrc` out into a fresh, Flutter-independent native app repo. |
