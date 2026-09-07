---
id: "task_7_native_bridge"
status: "done"
priority: "medium"
assignee: null
epic: "logging-refactor"
dueDate: null
created: "2026-08-25T19:00:00.000Z"
modified: "2026-08-26T12:02:27.000Z"
completedAt: "2026-08-26T12:02:27.000Z"
labels: ["native", "plugin", "tdd", "headless"]
order: "a7"
---
# Task 7: Create `logger_native_bridge` Package

Epic: [logging_refactor](../epic/logging_refactor/logging_refactor.en.md)
Design Spec: [2026-08-26-logger-native-bridge-headless-design.md](../epic/logging_refactor/2026-08-26-logger-native-bridge-headless-design.md)

## Requirement Analysis
The original scope assumed native code always has a live Flutter engine to call into. That assumption breaks for three concrete requirements:

1. Telemetry backends (Datadog, OpenTelemetry) must receive logs in realtime even when native code runs fully **headless** — Android `WorkManager`/foreground `Service`/`BroadcastReceiver`, or iOS `BGTaskScheduler`/background fetch — with **no `FlutterEngine` instance at all**. A Pigeon `@FlutterApi()` call has nothing to call into in that case.
2. Those headless logs must still surface on TalkerScreen for developers, even though they can't be delivered live.
3. Integration must stay as easy as the rest of the epic's appender model — register-and-go.

Two facts discovered while scoping this confirmed the redesign was necessary:
- The task's original reference integration point, `packages/native_security`'s `ios/Classes/NativeSecurityPlugin.swift`, is actually a `dart:ffi` plugin (Dart calls synchronously into native, not the reverse) — it has **no Android Kotlin source at all**, only a CMake/NDK build for the same C library. There is no existing "native pushes to Dart" plumbing anywhere in this repo, and **no existing headless task (WorkManager/BGTask) exists yet either** — this design defines the pattern from scratch, not an extension of one.
- `packages/settings` already persists app preferences via `shared_preferences` (`^2.5.5`), backed by Android `SharedPreferences` / iOS `UserDefaults` — a file that exists on disk independent of any Flutter engine or Dart isolate.

## Relevant Files & Context Pointers
- `packages/logger_native_bridge/` — new package (does not exist yet), depends only on the core logger package (name TBD by Task 1: `packages/logger` or `packages/d3nexus_logger`).
- `packages/logger_native_bridge/pigeon/schema.dart` — new. `@FlutterApi()` for `onNativeLog(NativeLogMessage)` (required); `@HostApi()` for an optional `triggerFlush()` dev/test convenience (not required for correctness).
- `packages/logger_native_bridge/android/.../D3NexusNativeLogger.kt`, `NativeLogAppender.kt`, `NativeLogQueue.kt`, `NativeAppenderToggleStore.kt`, `NativeLogBridgePlugin.kt` — new. Only `NativeLogBridgePlugin.kt` may import Flutter/Pigeon.
- `packages/logger_native_bridge/ios/Classes/D3NexusNativeLogger.swift`, `NativeLogAppender.swift`, `NativeLogQueue.swift`, `NativeAppenderToggleStore.swift`, `NativeLogBridgePlugin.swift` — new. Only `NativeLogBridgePlugin.swift` may import Flutter/Pigeon.
- `packages/native_security/ios/Classes/NativeSecurityPlugin.swift`, `packages/native_security/pubspec.yaml` — first (and only, per DoD) consumer. Note: `native_security` has no headless task today; a test fixture (not a real production Worker/BGTask) is enough to prove the headless path, unless a real headless consumer lands before this task starts.
- `packages/settings/pubspec.yaml` (`shared_preferences: ^2.5.5`) and wherever Task 6 persists `logging.appender_toggles` — `NativeAppenderToggleStore` must read the exact same key/encoding. **Confirm this key contract against Task 6's actual implementation before finalizing.**

## Design Rationale
**Native core / Flutter shim split, inside one federated plugin package.** `packages/logger_native_bridge` stays a single pub package (matches the epic's package boundary and this repo's tooling — no separate native-only publishing pipeline exists), but its native code is split in two:
- A **native core** (`D3NexusNativeLogger`, `NativeLogAppender`, `NativeLogQueue`, `NativeAppenderToggleStore`) with zero Flutter/Pigeon imports, callable from any Kotlin/Swift code whether or not an engine exists. This is what makes the headless requirement achievable at all.
- A **thin Flutter shim** (`NativeLogBridgePlugin`) that only matters when an engine is attached: it drains `NativeLogQueue` into `FlutterApi.onNativeLog(...)` on `onAttachedToEngine` (replay), and is the only class in the package allowed to import Flutter/Pigeon.

Concrete backends (`DatadogNativeAppender`) are **not** implemented inside `logger_native_bridge` — they're implemented in the consuming module's own native code (`native_security`) and registered via `D3NexusNativeLogger.registerAppender(...)` at native bootstrap. This mirrors the epic's own rule for the Dart core ("core has zero concrete-SDK dependency, appenders live at the app layer") applied symmetrically to the native side, and is what keeps the native appender abstraction pluggable for a future OTel native exporter without touching this package's core.

**Kill switch reaches headless for free.** Rather than a live Pigeon round-trip to push toggle state into native, `NativeAppenderToggleStore` reads the same `shared_preferences`-backed file `packages/settings` already writes `logging.appender_toggles` to. No new channel, no extra latency — the flag is eventually consistent, which is fine for a kill switch (a call already in flight in a background task can't be interrupted by a network flag regardless).

**Replay is best-effort, not guaranteed.** `NativeLogQueue` is a bounded ring buffer (default: 200 entries or 64KB, whichever first, drop-oldest) drained into Talker on the next engine attach, then cleared. It exists purely for developer visibility — durable BE delivery already happened via the native SDK during the headless push itself, so replay doesn't need acks or retry.

**Alternative rejected**: a fully separate native-only package (no pub involvement) for maximum isolation was considered and rejected — this repo has no Gradle/CocoaPods-only publishing pipeline, and DoD limits this to a single consumer today, so a second release pipeline isn't justified yet.

Relevant project skill: `mobile-developer` (`.agents/skills/mobile-developer`) for Kotlin/Swift plugin conventions used elsewhere in this repo.

## TDD Checklist
- [ ] **RED**: `NativeLogQueue` enqueue/drain is FIFO and bounded (oldest dropped once full).
- [ ] **RED**: `NativeAppenderToggleStore` returns the correct boolean for a given key, both when the toggle is present and when absent (default: enabled).
- [ ] **RED**: `D3NexusNativeLogger.d()` does not call a `NativeLogAppender` whose id is disabled in the toggle store.
- [ ] **RED**: Dart unit test mocking the Pigeon-generated `FlutterApi` call, asserting a received `NativeLogMessage` is forwarded into `D3NexusLogger.getLogger('Native:$tag')` with the right level/message mapping and original timestamp preserved.
- [ ] **GREEN**: Implement `NativeLogAppender`/`D3NexusNativeLogger`/`NativeLogQueue`/`NativeAppenderToggleStore` as plain Kotlin/Swift first (unit-testable without an engine); then the Pigeon schema and `NativeLogBridgePlugin`'s `onAttachedToEngine` drain; then wire a `DatadogNativeAppender` registered from `native_security`'s native side.
- [ ] **REFACTOR**: Verify replay does not duplicate entries across two consecutive cold starts (queue cleared only after a successful drain). Verify channel/queue overhead is acceptable for log-frequency traffic; add a convenience wrapper only if call sites would otherwise be verbose (`D3NexusNativeLogger.d(tag, message)` should already be short enough).

## Definition of Done (DoD)
- [ ] Pigeon-generated code compiles cleanly on both Android (Kotlin) and iOS (Swift).
- [ ] App builds and runs without crashing when the native channel registers.
- [ ] A log sent from a headless context (test `WorkManager`/`BGTask` fixture, no `FlutterEngine` running) reaches the Datadog native SDK.
- [ ] The same headless log appears on `D3NexusLogger`'s Talker appender the next time the app is foregrounded, in original causal order.
- [ ] Disabling the Datadog appender via Settings UI (`setAppenderEnabled('datadog', false)`) stops the headless push on the next headless invocation.
- [ ] No module other than `native_security` depends on `logger_native_bridge`.
- [ ] No file under `packages/logger_native_bridge/android/**/*.kt` or `ios/Classes/*.swift` other than `NativeLogBridgePlugin.{kt,swift}` imports anything Flutter/Pigeon-related.

## Dependencies & Blockers
- **Dependencies**: Blocked by [Task 2](task_2_core_interfaces.md) (`D3NexusLogger`/`ILogger` must exist first). Recommended to do after the core Flutter-side tasks (1-4) are complete.
- **New dependency**: the exact `shared_preferences` key/encoding [Task 6](task_6_settings_ui.md) uses for `logging.appender_toggles` must be confirmed before `NativeAppenderToggleStore` is finalized.

## References & Rollback
- **References**: [Design Spec](../epic/logging_refactor/2026-08-26-logger-native-bridge-headless-design.md), [Pigeon Documentation](https://pub.dev/packages/pigeon), [Federated Plugins](https://docs.flutter.dev/packages-and-plugins/developing-packages#plugin-federation).
- **Rollback Plan**: Remove the `logger_native_bridge` dependency from `packages/native_security`'s native build files if a platform build breaks; the rest of the epic is unaffected since no other package depends on this one. If the headless Datadog native SDK integration misbehaves in production (quota burn, crashes in a background task), use `setAppenderEnabled('datadog', false)` as an immediate kill switch — no release needed.
