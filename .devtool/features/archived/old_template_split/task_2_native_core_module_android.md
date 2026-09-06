---
id: "task_2_native_core_module"
status: "todo"
priority: "high"
assignee: null
epic: "template_android"
dueDate: null
created: "2026-08-29T00:00:00.000Z"
modified: "2026-08-29T00:00:00.000Z"
completedAt: null
labels: ["android", "core"]
order: "a2"
---
# Task 2: Native `core` Module (Android)

Epic: [template_android](../epic/template_android/template_android.en.md)

## Requirement Analysis
Create a new Gradle module, `android/core`, holding the 5 primitives every native Android module (UI or not) must depend on: `SafeExecution`, `DataState<T>`, a `Logger` contract, a `Container` DI convention, and `ReplayQueue`. This module has zero dependency on `androidx.lifecycle`/Compose/Hilt — it must be usable from a `Service`, a `Worker`, a `BroadcastReceiver`, or a plain plugin class with no lifecycle owner at all.

## Relevant Files & Context Pointers
- Extract from `android_digital_wallet/libraries/framework/.../base/mvvm/MvvmViewModel.kt` — specifically its `CoroutineExceptionHandler`/`safeLaunch` pattern, generalized into a standalone `SafeExecution` that doesn't require a `ViewModel`/`viewModelScope` (accept an external `CoroutineScope` or expose a suspend-friendly wrapper instead).
- `DataState<T>` — model on `MvvmViewModel`'s existing `DataState`/`BaseViewState` sealed types, simplified to just `Success`/`Error` (no `Loading`/`Empty` — those are `framework`/UI concerns per the `core`/`framework` split).
- `Logger` — a plain interface (`fun log(level, tag, message, throwable?)`), no concrete backend; this is the native-side mirror of the Dart `logger` package's role.
- `Container` — a minimal manual-DI convention (e.g. a `class Container { private val instances = mutableMapOf<KClass<*>, Any>(); fun <T> provide(...): T; fun <T> get(): T }`), documented as the pattern every `has_ui=false` plugin uses instead of Hilt.
- `ReplayQueue` — generalize the queue-and-replay-on-next-launch logic already implemented ad hoc in `packages/logger_native_bridge` (see Task 5) into a reusable, typed primitive (`enqueue(entry)` on the native side, `drainOnNextLaunch(): List<T>` consumed by a Dart initializer).
- New: `android/core/build.gradle.kts` applies only `codeanalyzetools.spotless`/`detekt-check` (Task 1) — no Hilt/Compose.

## Design Rationale
See design doc §3, "native `core`" bullet, and §3.6 for why `SafeExecution` matters beyond convenience: it is the concrete implementation the OS-triggered use cases (Ô3/Ô4, Phase 3) will wrap their entry-points in — building it now, decoupled from any single consumer, means Phase 3 doesn't have to invent it later.

## TDD Checklist
- [ ] Scaffold `android/core` as a plain Kotlin/Android library module, registered in the host's `settings.gradle.kts`; apply `codeanalyzetools.{spotless,detekt-check}` in its `build.gradle.kts`.
- [ ] **RED**: write failing unit tests for each primitive first — `SafeExecution` catches and routes an exception without crashing; `DataState<T>` exhaustively models Success/Error; `Container` throws/fails clearly on a missing registration and returns the right instance on a present one; `ReplayQueue` round-trips enqueue→drain in order.
- [ ] **GREEN**: implement `SafeExecution`, `DataState<T>`, `Logger`, `Container`, `ReplayQueue` — minimal code to pass the tests above.
- [ ] **REFACTOR**: clean up naming/structure once green; confirm no primitive accidentally pulls in `androidx.lifecycle`/Compose/Hilt.

## Definition of Done (DoD)
- [ ] `android/core` compiles standalone with zero dependency on `androidx.lifecycle`, Compose, or Hilt.
- [ ] Unit tests cover `SafeExecution`'s exception-catching behavior, `Container`'s provide/get, and `ReplayQueue`'s enqueue/drain round-trip.
- [ ] `./gradlew :core:detekt :core:spotlessCheck` passes clean.

## Dependencies & Blockers
- **Dependencies**: [Task 1](task_1_buildsrc_port.md) (`buildSrc` quality convention must exist to apply here).
- **Blockers**: None.

## References & Rollback
- **References**: [template_android.en.md](../epic/template_android/template_android.en.md), design doc §3, §3.6.
- **Rollback Plan**: `git revert`; new module, no existing code depends on it yet until Task 4/5.
