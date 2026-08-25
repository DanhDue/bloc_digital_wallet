---
id: "task_7_native_bridge"
status: "todo"
priority: "low"
assignee: null
epic: "logging-refactor"
dueDate: null
created: "2026-08-25T19:00:00.000Z"
modified: "2026-08-25T19:00:00.000Z"
completedAt: null
labels: ["native", "plugin", "tdd"]
order: "a7"
---
# Task 7: Create `logger_native_bridge` Package

Epic: [logging_refactor](../epic/logging_refactor/logging_refactor.en.md)

## Requirement Analysis
Native platform code (confirmed real example: `packages/native_security`'s `ios/Classes/NativeSecurityPlugin.swift`) has no path to push logs into the Flutter debug console. This must be a strictly opt-in package — modules without native code must never depend on it or pay its Pigeon-generated-code cost.

## Relevant Files & Context Pointers
- `packages/logger_native_bridge/` — new package (does not exist yet), depends only on `packages/logger`.
- `packages/logger_native_bridge/pigeon/schema.dart` — new, Pigeon schema for `NativeLogMessage{level, tag, message, traceId?}` and `@FlutterApi()`.
- `packages/native_security/ios/Classes/NativeSecurityPlugin.swift` — reference/first integration point on iOS.
- `packages/native_security/android/` — Kotlin side, if present, for the Android integration point.
- `packages/native_security/pubspec.yaml` — add `logger_native_bridge` here only (not to the root app or other modules).

## Design Rationale
**Federated plugin, opt-in per module**: only a module that actually ships native platform code adds `logger_native_bridge` as a dependency and registers the channel from its own native side — the root app and pure-Dart modules never depend on it. Pigeon generates type-safe Kotlin/Swift ↔ Dart bindings, avoiding hand-written `MethodChannel` parsing/type errors.

Relevant project skill: `mobile-developer` (`.agent/skills/mobile-developer`) for Kotlin/Swift plugin conventions used elsewhere in this repo (e.g. `native_security`).

## TDD Checklist
- [ ] **RED**: Write a Dart unit test that mocks the Pigeon-generated `FlutterApi` call and asserts a received `NativeLogMessage` is forwarded into `D3NexusLogger.getLogger('Native:$tag')` with the right level/message mapping.
- [ ] **GREEN**: Implement the Pigeon schema, generate Kotlin/Swift bindings, implement the Dart-side listener (`NativeLogBridge`), and wire `packages/native_security`'s Swift plugin to call the generated static logging util.
- [ ] **REFACTOR**: Verify channel call overhead is acceptable for log-frequency traffic; add a small static Kotlin/Swift convenience wrapper (`D3NexusNativeLogger.d(tag, message)`) if call sites would otherwise be verbose.

## Definition of Done (DoD)
- [ ] Pigeon-generated code compiles cleanly on both Android (Kotlin) and iOS (Swift).
- [ ] App builds and runs without crashing when the native channel registers.
- [ ] A test log sent from `native_security`'s Swift plugin appears in `D3NexusLogger`'s Talker appender output.
- [ ] No module other than `native_security` depends on `logger_native_bridge`.

## Dependencies & Blockers
- **Dependencies**: Blocked by [Task 2](task_2_core_interfaces.md) (`D3NexusLogger`/`ILogger` must exist first). Recommended to do after the core Flutter-side tasks (1-4) are complete.

## References & Rollback
- **References**: [Pigeon Documentation](https://pub.dev/packages/pigeon), [Federated Plugins](https://docs.flutter.dev/packages-and-plugins/developing-packages#plugin-federation).
- **Rollback Plan**: Remove the `logger_native_bridge` dependency from `packages/native_security/pubspec.yaml` if a platform build breaks; the rest of the epic is unaffected since no other package depends on this one.
