---
id: "task_5_refactor_logger_native_bridge"
status: "todo"
priority: "medium"
assignee: null
epic: "template_ios"
dueDate: null
created: "2026-08-29T00:00:00.000Z"
modified: "2026-08-29T00:00:00.000Z"
completedAt: null
labels: ["ios", "refactor", "logger_native_bridge"]
order: "a5"
---
# Task 5: Refactor `logger_native_bridge` (iOS side) + Wire Swift `ReplayQueue`

Epic: [template_ios](../epic/template_ios/template_ios.en.md)

## Requirement Analysis
**Sequencing note**: run *after* Task 10 (SPM-only packaging) — same reasoning as Task 4. References to
`logger_native_bridge.podspec` below become `Package.swift` post-Task-10.

Same layering treatment as Task 4, applied to `packages/logger_native_bridge/ios`. This package's `NativeLogQueue.swift` already implements queue-and-replay logic — refactor it to implement `ios/core`'s `ReplayQueue` (Task 2) instead of being a bespoke implementation, mirroring `template_android` Task 5's treatment.

## Relevant Files & Context Pointers
- `packages/logger_native_bridge/ios/logger_native_bridge/Sources/logger_native_bridge/{NativeLogBridgePlugin,NativeLogAppender,NativeLogQueue,NativeAppenderToggleStore,NativeLogEntry,D3NexusNativeLogger,Messages.g}.swift` (post-Task-10 SPM location) — classify: `NativeLogBridgePlugin` (+ `Messages.g.swift`, Pigeon-generated) → `Platform/`; `NativeLogAppender`, `D3NexusNativeLogger` → `Domain/`; `NativeLogQueue`, `NativeAppenderToggleStore` → `Data/`.
- `NativeLogQueue.swift` — refactor to implement `ios/core.ReplayQueue`'s interface; verify against existing `NativeLogQueueTests.swift` (ported, not rewritten).
- `packages/logger_native_bridge/ios/logger_native_bridge/Tests/logger_native_bridgeTests/{D3NexusNativeLoggerTests,NativeAppenderToggleStoreTests,NativeLogQueueTests}.swift` — move alongside their source.
- `packages/logger_native_bridge/ios/logger_native_bridge/Package.swift` — add target paths for the new layout; add `ios/core` as a package dependency. Update Pigeon's `swiftOut` config to the new `Sources/logger_native_bridge/` path.

## Design Rationale
See design doc §3.3 and the Ô3 diagram (`flutter_super_app_template.en.md` §5, Case 4/5), mirroring `template_android` Task 5's rationale exactly — this package's existing replay logic is the worked example `ReplayQueue`'s Swift API is validated against.

## TDD Checklist

**TDD Adaptation**: this is a structural reorganization of existing, already-tested code — no new behavior to drive with a failing test. Existing unit tests are ported unchanged and must keep passing; see steps below.

- [ ] Map every file to `Platform/Domain/Data`; move and update.
- [ ] Refactor `NativeLogQueue` to implement `ios/core.ReplayQueue`; confirm parity via ported `NativeLogQueueTests.swift`.
- [ ] Update `Package.swift`'s target paths and dependency list.
- [ ] Run SwiftLint/SwiftFormat, fix violations.

## Definition of Done (DoD)
- [ ] `packages/logger_native_bridge/ios/logger_native_bridge/Sources/logger_native_bridge/{Platform,Domain,Data}/` layout exists, matching Android's folder names.
- [ ] `NativeLogQueue` implements `ios/core.ReplayQueue`; all existing queue/replay tests pass.
- [ ] SwiftLint/SwiftFormat + XCTest suite all pass.

## Dependencies & Blockers
- **Dependencies**: [Task 2](task_2_native_core_module_ios.md) (`ios/core`, specifically `ReplayQueue`), [Task 3](task_3_quality_tooling.md) (quality tooling), [Task 10](task_10_spm_only_packaging.md) (SPM-only packaging — sequence after).
- **Blockers**: None.

## References & Rollback
- **References**: [template_ios.en.md](../epic/template_ios/template_ios.en.md), design doc §3.3, `flutter_super_app_template.en.md` §5 (Case 4/5).
- **Rollback Plan**: `git revert`; revertible independently of Task 2's other `core` primitives.
