# Epic: Template — iOS Native Architecture

## Table of Contents
1. [Meta Data](#1-meta-data)
2. [Background](#2-background)
3. [Goals & Non-Goals](#3-goals--non-goals)
4. [Scope](#4-scope)
5. [Kanban Tasks Breakdown](#5-kanban-tasks-breakdown)

## 1. Meta Data
- **Epic**: `template_ios`
- **Status**: Planning
- **Parent spec**: [flutter_super_app_template.en.md](../flutter_super_app_template/flutter_super_app_template.en.md), [2026-08-29-flutter-super-app-template-design.md §3.5](../flutter_super_app_template/2026-08-29-flutter-super-app-template-design.md)
- **Sibling epics**: [template_flutter](../template_flutter/template_flutter.en.md), [template_android](../template_android/template_android.en.md)
- **Source references**: none pre-existing for iOS (unlike Android's `android_digital_wallet`) — the Swift MVI layer is designed from scratch in this epic, translating `android_digital_wallet`'s Kotlin `MviViewModel` concept-for-concept.

## 2. Background
The two existing native plugins (`native_security`, `logger_native_bridge`) each ship an `ios/Classes/` folder with flat Swift source, no shared layering, and no lint/format tooling. Unlike Android, there is no sibling native iOS project to port an MVI/DI/quality stack from — this epic designs the Swift equivalent of `template_android`'s Kotlin stack (native `core`, native `framework`, quality tooling) from first principles, keeping the same names and semantics across platforms so the two are easy to cross-reference.

## 3. Goals & Non-Goals

### Goals
- Design and implement a Swift `MviViewModel`/`MvvmViewModel`/`ViewState` equivalent (Combine-based `ObservableObject`, minimum deployment target **iOS 13** — decided 2026-08-29, not `@Observable`/`swift-perception`), translating the Kotlin `StateFlow`/`Channel`/`SharedFlow` semantics 1:1 (`uiState`, `viewState`, `event`, `sharedEvent`, `dispatch`/`reduce`/`setState`, `startLoading`/`handleError`).
- Build native `core` Swift equivalents (`SafeExecution`, `DataState<T>`, `Logger`, `Container`, `ReplayQueue`) as a mandatory dependency for every native module, UI or not — same contract as the Android `core`, different language.
- Set up shared SwiftLint + SwiftFormat config (one ruleset, referenced by every plugin/module) as the iOS equivalent of the Android quality convention plugin.
- Refactor `native_security` and `logger_native_bridge`'s Swift source into `Platform/Domain/Data`, matching the Android folder names 1:1 for cross-reference.
- Cover the iOS side of the `native_package` Mason brick (`trigger`/`has_ui` flags) and of `scripts/native_add_ui_dependency.sh`.
- Package `native_security`, `logger_native_bridge`, and the `native_ios_package` brick's output via **SPM only** (no `.podspec`) — decided 2026-08-29, ahead of CocoaPods' registry going read-only 2026-12-02. Scope is these plugins only, not the app's `ios/Podfile`.
- Ship `scripts/extract_native_standalone_ios.sh` so `core`/`framework` — already Flutter-independent by construction — can be extracted into a fresh, standalone native iOS app repo (no Flutter involvement) whenever a project needs pure native development.

### Non-Goals
- Any Android work — see `template_android`.
- Phase 3 (OS-integrated plugin safety, e.g. `CallDirectoryHandler`-style extensions; Go binding) — parked, only `core.SafeExecution` is built here as the primitive Phase 3 will need.
- A full production Call Directory Extension or similar — `vchat_shield`'s iOS side is a lessons-learned reference only.

## 4. Scope
The use-case matrix, the `core`/`framework` split, and the Kotlin→Swift translation table are already finalized in the parent spec (§3.5 and the per-use-case diagrams) — this epic implements them. See the Kanban breakdown for the task split.

## 5. Kanban Tasks Breakdown

| # | Task | Summary |
|---|---|---|
| 1 | [Swift `MviViewModel`](../../features/task_1_swift_mvi_viewmodel.md) | Design + implement the Combine-based ViewModel/`ViewState` trio (iOS 13 floor, decided). |
| 2 | [Native `core` module](../../features/task_2_native_core_module_ios.md) | Swift `SafeExecution`, `DataState<T>`, `Logger`, `Container`, `ReplayQueue`. |
| 3 | [Quality tooling](../../features/task_3_quality_tooling.md) | Shared `.swiftlint.yml`/`.swiftformat`, wired into a Run Script Phase. |
| 4 | [Refactor `native_security`](../../features/task_4_refactor_native_security_ios.md) | Reorganize Swift source into `Platform/Domain/Data`. |
| 5 | [Refactor `logger_native_bridge`](../../features/task_5_refactor_logger_native_bridge_ios.md) | Same treatment; wire the Swift `ReplayQueue`. |
| 6 | [`native_ios_package` brick](../../features/task_6_native_package_brick_ios.md) | Standalone brick, iOS scaffolding for Ô1–Ô4, same `trigger`/`has_ui` var shape as Android's but a separate invocation. |
| 7 | [`native_add_ui_dependency` (iOS)](../../features/task_7_add_ui_dependency_tool_ios.md) | Podspec/target wiring to add `framework` + `presentation/` to an existing package. |
| 8 | [Go binding guide (iOS half)](../../features/task_8_go_binding_guide_ios.md) | `.xcframework` integration, panic-recovery snippet for the Swift/cgo boundary. |
| 9 | [Standalone-repo extraction](../../features/task_9_standalone_extraction_ios.md) | `scripts/extract_native_standalone_ios.sh` — spin `core`/`framework` out into a fresh, Flutter-independent native app repo. |
| 10 | [SPM-only packaging](../../features/task_10_spm_only_packaging.md) | Remove `.podspec` from `native_security`/`logger_native_bridge`/brick output; SPM only. Sequence before Tasks 4–7. |
