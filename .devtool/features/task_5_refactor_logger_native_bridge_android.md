---
id: "task_5_refactor_logger_native_bridge"
status: "todo"
priority: "medium"
assignee: null
epic: "template_android"
dueDate: null
created: "2026-08-29T00:00:00.000Z"
modified: "2026-08-29T00:00:00.000Z"
completedAt: null
labels: ["android", "refactor", "logger_native_bridge"]
order: "a5"
---
# Task 5: Refactor `logger_native_bridge` (Android side) + Generalize `ReplayQueue`

Epic: [template_android](../epic/template_android/template_android.en.md)

## Requirement Analysis
Same layering treatment as Task 4, applied to `packages/logger_native_bridge/android`. This package already implements its own queue-and-replay-on-next-launch logic (`NativeLogQueue`) — this task additionally generalizes that logic into `core.ReplayQueue` (Task 2) so future OS-triggered packages (Phase 3) reuse one primitive instead of each reinventing it.

## Relevant Files & Context Pointers
- `packages/logger_native_bridge/android/src/main/kotlin/com/danhdue/logger_native_bridge/{NativeLogBridgePlugin,NativeLogAppender,NativeLogQueue,NativeAppenderToggleStore,NativeJson,NativeLogEntry,D3NexusNativeLogger,Messages.g}.kt` — classify: `NativeLogBridgePlugin` (+ `Messages.g.kt`, Pigeon-generated) → `platform/`; `NativeLogAppender`, `D3NexusNativeLogger` → `domain/`; `NativeLogQueue`, `NativeAppenderToggleStore`, `NativeJson` → `data/`.
- `NativeLogQueue` — refactor to implement/wrap `core.ReplayQueue`'s interface (Task 2) rather than being a bespoke one-off; verify the Dart-side replay consumer (`lib/` of this package, outside this epic's scope but noted for `template_flutter` coordination) still drains correctly.
- `build.gradle` — same version-catalog/quality-convention treatment as Task 4. Note: this package's `pubspec.yaml` already documents a pinned `pigeon: 26.3.2` due to an `analyzer` version ceiling from `ui_kit`'s `theme_tailor` dependency — preserve that pin, it's unrelated to this task.
- Existing tests: `D3NexusNativeLoggerTest.kt`, `NativeAppenderToggleStoreTest.kt`, `NativeLogQueueTest.kt`, `FakeSharedPreferences.kt` — move and update alongside their source.

## Design Rationale
See design doc §3.3 and the Ô3 diagram (`flutter_super_app_template.en.md` §5, Case 4/5) — `logger_native_bridge`'s existing replay-on-next-launch behavior is literally the worked example the `ReplayQueue` primitive is generalized from, so this task both refactors the package and validates that `core.ReplayQueue`'s API shape is sufficient for a real, already-shipping consumer.

## TDD Checklist

**TDD Adaptation**: this is a structural reorganization of existing, already-tested code — no new behavior to drive with a failing test. Existing unit tests are ported unchanged and must keep passing; see steps below.

- [ ] Map every file to `platform/domain/data`; move and update.
- [ ] Refactor `NativeLogQueue` to implement `core.ReplayQueue`; confirm behavior parity via existing `NativeLogQueueTest.kt` (ported, not rewritten from scratch).
- [ ] Apply the shared version catalog + quality convention in `build.gradle`, preserving the pinned `pigeon` version.
- [ ] Move/update existing unit tests.
- [ ] Run `detekt`/`spotlessApply`, fix violations.

## Definition of Done (DoD)
- [ ] `packages/logger_native_bridge/android` follows the same `platform/domain/data` layout as Task 4.
- [ ] `NativeLogQueue` is implemented in terms of `core.ReplayQueue`; all existing queue/replay tests still pass.
- [ ] `./gradlew :logger_native_bridge:detekt :logger_native_bridge:spotlessCheck :logger_native_bridge:testDebugUnitTest` pass.

## Dependencies & Blockers
- **Dependencies**: [Task 1](task_1_buildsrc_port.md) (buildSrc), [Task 2](task_2_native_core_module_android.md) (native `core`, specifically `ReplayQueue`).
- **Blockers**: None.

## References & Rollback
- **References**: [template_android.en.md](../epic/template_android/template_android.en.md), design doc §3.3, `flutter_super_app_template.en.md` §5 (Case 4/5 diagram).
- **Rollback Plan**: `git revert`; if `ReplayQueue` generalization regresses replay behavior, this task alone can be reverted without affecting Task 2's other 4 `core` primitives.
