---
id: "task_1_swift_mvi_viewmodel"
status: "todo"
priority: "high"
assignee: null
epic: "template_ios"
dueDate: null
created: "2026-08-29T00:00:00.000Z"
modified: "2026-08-29T00:00:00.000Z"
completedAt: null
labels: ["ios", "mvi", "swift"]
order: "a1"
---
# Task 1: Design & Implement Swift `MviViewModel`

Epic: [template_ios](../epic/template_ios/template_ios.en.md)

## Requirement Analysis
Design, from scratch, the Swift equivalent of Kotlin's `MviViewModel`/`MvvmViewModel`/`ViewState` — no existing iOS reference project to port from. Must translate the Kotlin `StateFlow`/`Channel`/`SharedFlow` semantics 1:1: `uiState`, `viewState` (Loading/Error/Content), `event` (single-collector, one-time), `sharedEvent` (multicast), `dispatch`/`reduce`/`setState`, `startLoading`/`handleError`.

**Decided 2026-08-29: Combine/`ObservableObject`, minimum deployment target iOS 13.** Neither `@Observable`
(requires iOS 17) nor `swift-perception` (SPM-only backport, adds a third-party dependency to the
foundational `framework` layer) are used. Rationale: (1) `vchat_shield` — the closest real-world native iOS
precedent available — targets iOS 16 and runs Combine-adjacent code fine; no justification to set a higher
floor than a proven precedent. (2) Combine's `Publisher`/`Subject` model is the structurally correct analog
to Kotlin Flow (`StateFlow`≈`CurrentValueSubject`, `Channel`/`SharedFlow`≈`PassthroughSubject`) — matching
the epic's actual goal (1:1 conceptual parity with the Kotlin source), whereas `@Observable`'s
property-tracking model has no Publisher/operator concept and is architecturally closer to how Compose
consumes a Flow at the *rendering* layer, not to the ViewModel's *contract* layer. (3) `event`/`sharedEvent`
require Combine regardless of the state-observation choice, so using Combine end-to-end avoids mixing two
observation paradigms in one class. (4) Keeps `ios/framework` free of third-party dependencies, consistent
with the "native infra stays light and neutral" principle applied identically on the Android side (no Hilt
forced into plugin packages).

## Relevant Files & Context Pointers
- Reference (read-only, Kotlin source of truth): `android_digital_wallet/libraries/framework/.../MviViewModel.kt`, `MvvmViewModel.kt`, `ViewState.kt` — see design doc §3.5's full translation table.
- New: `ios/framework/MviViewModel.swift`, `MvvmViewModel.swift`, `ViewState.swift` — base class `class MviViewModel<STATE, ACTION, EVENT>: MvvmViewModel, ObservableObject`, `@Published var uiState: STATE`, `@Published var viewState: ViewState<STATE>`, a `PassthroughSubject<EVENT, Never>` for `event` (documented as single-consumer by convention, since Combine has no true single-collector channel), a second `PassthroughSubject` for `sharedEvent`.
- `ios/framework/Package.swift` — declares `platforms: [.iOS(.v13)]`.

## Design Rationale
See design doc §3.5 for the full Kotlin→Swift mapping table. `MvvmViewModel`'s exception handling delegates to the Swift `core.SafeExecution` (this epic's Task 2) rather than reimplementing it, mirroring the Android side's Task 3 decision to keep exception handling in exactly one place per platform.

## TDD Checklist
- [ ] Scaffold `ios/framework/Package.swift` (`platforms: [.iOS(.v13)]`), depending on `ios/core`.
- [ ] **RED**: write failing XCTest cases, mirroring `template_android`'s [Task 3](task_3_native_framework_module.md) coverage — a throwaway `MviViewModel` subclass asserting `dispatch`/`reduce`/`setState`/`startLoading`/`handleError` and `event`/`sharedEvent` delivery behave per the Kotlin→Swift translation table.
- [ ] **GREEN**: implement `ViewState<T>` (`.loading`/`.error(Error)`/`.content(T)`), `MvvmViewModel` (delegates exception handling to `core.SafeExecution`), and `MviViewModel<STATE, ACTION, EVENT>` (Combine-based) — minimal code to pass.
- [ ] **REFACTOR**: clean up once green; confirm no `@Observable`/`swift-perception` usage crept in.

## Definition of Done (DoD)
- [ ] Swift `MviViewModel` exposes the same 4 observable surfaces (uiState, viewState, event, sharedEvent) and the same 5 methods (dispatch, reduce, setState, startLoading, handleError) as the Kotlin original, verified against the translation table.
- [ ] `ios/framework/Package.swift` declares `.iOS(.v13)`; no `@Observable`/`swift-perception` usage anywhere in the module.
- [ ] Unit tests pass for state/event semantics.

## Dependencies & Blockers
- **Dependencies**: [Task 2](task_2_native_core_module_ios.md) (native `core`, for `SafeExecution` delegation) — can be developed in parallel and wired together, or sequenced after Task 2.
- **Blockers**: None — deployment target and state mechanism are resolved (see above).

## References & Rollback
- **References**: [template_ios.en.md](../epic/template_ios/template_ios.en.md), design doc §3.5.
- **Rollback Plan**: `git revert`; new module, no existing code depends on it until a `has_ui=true` package (Task 6) exists.
