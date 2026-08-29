---
id: "task_2_native_core_module"
status: "todo"
priority: "high"
assignee: null
epic: "template_ios"
dueDate: null
created: "2026-08-29T00:00:00.000Z"
modified: "2026-08-29T00:00:00.000Z"
completedAt: null
labels: ["ios", "core", "swift"]
order: "a2"
---
# Task 2: Native `core` Module (iOS)

Epic: [template_ios](../epic/template_ios/template_ios.en.md)

## Requirement Analysis
Swift equivalent of `template_android`'s Task 2: `SafeExecution`, `DataState<T>`, `Logger`, `Container`, `ReplayQueue` — same contract, no dependency on Combine/SwiftUI/`ObservableObject`, usable from a plain plugin class, a Call Directory Extension, or a background task with no view hierarchy at all.

## Relevant Files & Context Pointers
- New: `ios/core/SafeExecution.swift` — a `do`/`catch` wrapper (or a `Result`-returning helper for async contexts) with a pluggable error handler, the Swift mirror of `template_android`'s `SafeExecution` (Task 2 there). This is what Phase 3's OS-triggered entry-points (Extensions, background tasks) will eventually wrap themselves in — see design doc §3.6.
- New: `ios/core/DataState.swift` — `enum DataState<T> { case success(T); case failure(Error) }`.
- New: `ios/core/Logger.swift` — a `protocol Logger { func log(level:, tag:, message:, error: Error?) }`, no concrete backend.
- New: `ios/core/Container.swift` — a minimal manual-DI convention mirroring the Android `Container` (a type-keyed instance registry), documented as the pattern every `has_ui=false` plugin uses.
- New: `ios/core/ReplayQueue.swift` — Swift mirror of `template_android`'s `ReplayQueue`, generalized from `logger_native_bridge`'s existing iOS replay logic (`NativeLogQueue.swift`, see `template_ios` Task 5).

## Design Rationale
See design doc §3, "native `core`" bullet, applied to Swift. Kept as a plain Swift package/target with zero UIKit/SwiftUI dependency, matching the Android side's "usable with no lifecycle owner" requirement exactly.

## TDD Checklist
- [ ] Scaffold `ios/core` as a Swift Package (matching the `VShieldCore`-style local Swift Package pattern seen in `vchat_shield`, since it's already proven in this codebase's own precedent).
- [ ] **RED**: write failing XCTest cases first — same assertions as `template_android`'s [Task 2](task_2_native_core_module_android.md): `SafeExecution` catches/routes errors without crashing; `DataState<T>` models Success/Error; `Container` provide/get semantics; `ReplayQueue` enqueue/drain round-trip.
- [ ] **GREEN**: implement `SafeExecution`, `DataState<T>`, `Logger`, `Container`, `ReplayQueue` — minimal code to pass.
- [ ] **REFACTOR**: clean up once green; confirm zero UIKit/SwiftUI/Combine dependency in this module.

## Definition of Done (DoD)
- [ ] `ios/core` builds standalone with zero UIKit/SwiftUI/Combine dependency.
- [ ] Unit tests cover `SafeExecution`'s error-catching behavior, `Container`'s provide/get, `ReplayQueue`'s enqueue/drain round-trip.
- [ ] SwiftLint/SwiftFormat (Task 3) pass clean once wired.

## Dependencies & Blockers
- **Dependencies**: None — can start immediately, independent of [Task 1](task_1_swift_mvi_viewmodel.md).
- **Blockers**: Packaging-approach decision (Swift Package vs. plain source group) — check against `vchat_shield`'s `VShieldCore` pattern for precedent.

## References & Rollback
- **References**: [template_ios.en.md](../epic/template_ios/template_ios.en.md), design doc §3, §3.6.
- **Rollback Plan**: `git revert`; new module, no existing code depends on it until Task 4/5.
