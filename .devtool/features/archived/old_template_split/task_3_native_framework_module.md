---
id: "task_3_native_framework_module"
status: "todo"
priority: "high"
assignee: null
epic: "template_android"
dueDate: null
created: "2026-08-29T00:00:00.000Z"
modified: "2026-08-29T00:00:00.000Z"
completedAt: null
labels: ["android", "framework", "mvi"]
order: "a3"
---
# Task 3: Native `framework` Module (Android) — `MviViewModel`

Epic: [template_android](../epic/template_android/template_android.en.md)

## Requirement Analysis
Create `android/framework`, holding `MviViewModel`/`MvvmViewModel`/`ViewState`, ported from `android_digital_wallet/libraries/framework`. This module depends on native `core` (Task 2) and on `androidx.lifecycle`/Compose — it is only ever a dependency of modules with `has_ui=true`.

## Relevant Files & Context Pointers
- Source (read-only reference): `android_digital_wallet/libraries/framework/src/main/java/com/danhdue/framework/base/mvi/MviViewModel.kt` (241 lines: `uiState`/`viewState`/`event`/`sharedEvent`, `dispatch`/`reduce`/`setState`, `startLoading`/`handleError` overrides) and `.../base/mvvm/MvvmViewModel.kt` (the `safeLaunch`/`call`/`execute` base — note: this task's `MvvmViewModel` delegates its exception handling to `core.SafeExecution` from Task 2 rather than reimplementing `CoroutineExceptionHandler` locally, to avoid duplicating that logic across `core` and `framework`).
- Destination: `android/framework/src/main/kotlin/.../base/mvi/{MviViewModel,ViewState}.kt`, `.../base/mvvm/MvvmViewModel.kt`.
- `android/framework/build.gradle.kts` — depends on `android/core`; applies `codeanalyzetools.{spotless,detekt-check}` (quality only — Hilt/Compose is applied per-consumer, not baked into `framework` itself, since `framework` is a plain library, not itself a UI-owning module).

## Design Rationale
See design doc §3, "native `framework`" bullet. Reusing `core.SafeExecution` inside `MvvmViewModel` (instead of the original's standalone `CoroutineExceptionHandler`) is the one deliberate deviation from a literal port — it keeps the "exception handling lives in one place" invariant from the `core`/`framework` split rather than having two independent implementations that could drift.

## TDD Checklist
- [ ] Scaffold `android/framework`, add `android/core` as a dependency; apply the quality convention plugin.
- [ ] **RED**: write failing unit tests, with a throwaway `MviViewModel` test subclass, asserting: `dispatch` routes to `onAction`; `reduce` atomically updates `uiState` and mirrors into `viewState.Content`; `startLoading`/`handleError` flip `viewState` to Loading/Error while `uiState` is preserved; `event`/`sharedEvent` deliver emitted values to a collector.
- [ ] **GREEN**: port `ViewState` (Loading/Error/Content), `MvvmViewModel` (rewired to delegate to `core.SafeExecution` instead of the original's standalone `CoroutineExceptionHandler`), and `MviViewModel` — minimal code to pass the tests above.
- [ ] **REFACTOR**: clean up once green; run `detekt`/`spotlessCheck`.

## Definition of Done (DoD)
- [ ] `android/framework` compiles, depends only on `android/core` + `androidx.lifecycle`/coroutines (no Hilt/Compose dependency inside `framework` itself).
- [ ] Unit tests pass for state/event semantics equivalent to the source `MviViewModel`.
- [ ] `./gradlew :framework:detekt :framework:spotlessCheck` passes clean.

## Dependencies & Blockers
- **Dependencies**: [Task 1](task_1_buildsrc_port.md) (buildSrc), [Task 2](task_2_native_core_module_android.md) (native `core`, for the `SafeExecution` delegation).
- **Blockers**: None.

## References & Rollback
- **References**: [template_android.en.md](../epic/template_android/template_android.en.md), design doc §3.
- **Rollback Plan**: `git revert`; new module, no existing code depends on it until Task 6's brick or a future `has_ui=true` package.
