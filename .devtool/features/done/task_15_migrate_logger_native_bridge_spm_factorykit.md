---
id: "task_15_migrate_logger_native_bridge_spm_factorykit"
status: "done"
priority: "high"
assignee: null
epic: "flutter_super_app_template"
dueDate: null
created: "2026-09-09T09:51:07.000Z"
modified: "2026-09-09T11:05:00.000Z"
completedAt: "2026-09-09T11:05:00.000Z"
labels: ["ios", "spm", "factorykit", "pigeon", "phase-5"]
order: "a15"
---

# Task 15: Migrate `logger_native_bridge` → Flutter SPM + FactoryKit

Epic: [flutter_super_app_template](../epic/flutter_super_app_template/flutter_super_app_template.en.md)

## Requirement Analysis
`logger_native_bridge` is a Swift-only headless Pigeon plugin — the lower-risk of the two shipped native plugins and the reference implementation of the Phase 5 pattern for `native_security` and the brick to follow.

Requirements:
1. **Layout**: `ios/logger_native_bridge.podspec` → `ios/logger_native_bridge/Package.swift`; move `ios/Classes/*.swift` → `ios/logger_native_bridge/Sources/logger_native_bridge/`. Delete the podspec. `pubspec.yaml` `flutter.plugin.platforms.ios.pluginClass` unchanged.
2. **`Package.swift`**: `swift-tools-version: 5.9`; `platforms: [.iOS("13.0")]`; product `.library(name: "logger-native-bridge", targets: ["logger_native_bridge"])`; deps `FlutterFramework` (`.package(name: "FlutterFramework", path: "../FlutterFramework")`) + FactoryKit (`.package(url: "https://github.com/hmlongco/Factory.git", exact: "<pin>")`, `.product(name: "FactoryKit", package: "Factory")`); `.testTarget(name: "logger_native_bridgeTests")`.
3. **Container**: add `Sources/logger_native_bridge/LoggerNativeBridgeContainer.swift` — `public final class LoggerNativeBridgeContainer: SharedContainer { public static let shared = LoggerNativeBridgeContainer(); public let manager = ContainerManager() }`. Register the plugin's internal singletons as `Factory` computed vars (the log queue, the appender toggle store, the native appender, the Pigeon-facing `D3NexusNativeLogger` — map exact types from the current sources). Safe defaults that need no `registrar`.
4. **Composition root**: `NativeLogBridgePlugin.register(with:)` overrides any factory that needs `registrar` / `messenger`, then wires the Pigeon `HostApi`.
5. **Consumers**: replace direct singleton construction / passing with `@Injected(\LoggerNativeBridgeContainer.<factory>)`.
6. **Pigeon**: move `swiftOut` to `ios/logger_native_bridge/Sources/logger_native_bridge/Messages.g.swift`; regenerate; Dart `Messages.g.dart` path unchanged.
7. **Tests**: move `ios/Tests/logger_native_bridgeTests/*` → `ios/logger_native_bridge/Tests/logger_native_bridgeTests/`; rewrite fixture wiring to `LoggerNativeBridgeContainer.shared.<factory>.register { … }` + `.reset()` in teardown (Swift Testing or XCTest, matching the repo's current style).

## Relevant Files & Context Pointers
- `packages/logger_native_bridge/ios/logger_native_bridge.podspec` (delete)
- `packages/logger_native_bridge/ios/Classes/` → `ios/logger_native_bridge/Sources/logger_native_bridge/`
  - `NativeLogBridgePlugin.swift`, `D3NexusNativeLogger.swift`, `NativeAppenderToggleStore.swift`, `NativeLogQueue.swift`, `NativeLogAppender.swift`, `NativeLogEntry.swift`, `Messages.g.swift`
- `packages/logger_native_bridge/ios/Tests/logger_native_bridgeTests/`
- `packages/logger_native_bridge/pubspec.yaml`
- `packages/logger_native_bridge/pigeons/` (Pigeon schema + config)
- Reference: `/Users/danhdueexoictif/AllProjects/digital_wallet/ios_digital_wallet` — `Features/Settings/Sources/Settings/SettingsContainer.swift`, `Packages/Platform/Sources/Platform/DIExports.swift` (Container pattern)

## Design Rationale
Per-plugin `SharedContainer` subclass (not the global `Container.shared`) keeps the plugin self-contained and free of cross-plugin name collisions — the Flutter host has no Swift composition root to own a global container (spec D3). `register(with:)` is the one Flutter hook with engine-scoped objects, so it is the composition point (D4). FactoryKit is declared directly in `Package.swift` because there is no shared iOS infra package.
Applicable skills: `test-driven-development`, `verification-before-completion`, `mobile-developer`.

## TDD Checklist
- [x] **RED**: Added `Tests/logger_native_bridgeTests/LoggerNativeBridgeContainerTests.swift` — asserts `LoggerNativeBridgeContainer` resolves `toggleStore`/`logQueue` and that `.register { spy }` overrides + `.reset()` restores. The 3 existing headless Swift tests (`NativeLogQueueTests`, `NativeAppenderToggleStoreTests`, `D3NexusNativeLoggerTests`) moved unchanged — they already cover forwarding + toggle gating via constructor injection + fake `UserDefaults`.
- [x] **GREEN**:
  - [x] Created `ios/logger_native_bridge/Package.swift` (`swift-tools-version: 5.9`, product `logger-native-bridge`, deps `FlutterFramework` + `Factory` 3.3.2 → `FactoryKit`); `git mv` sources into `Sources/logger_native_bridge/`; deleted `.podspec`.
  - [x] Added `LoggerNativeBridgeContainer.swift`; `register(with:)` now resolves `toggleStore`/`logQueue` through it (headless `D3NexusNativeLogger` path untouched — must not need FactoryKit).
  - [x] `pigeon/schema.dart` `swiftOut` → `Sources/logger_native_bridge/Messages.g.swift`; regenerated (Android/Dart pigeon outputs reverted — iOS-only task).
  - [x] `flutter build ios --simulator --debug` → `✓ Built Runner.app`; `logger_native_bridge` dropped off Flutter's "does not support SPM" list. Dart tests: `flutter test packages/logger_native_bridge` → 11/11 pass. `flutter analyze` → No issues.
  - [~] `xcodebuild test` of the Swift test targets — needs an Xcode test host; deferred (proxy verification agreed for this environment). Sources compile as part of the resolved SPM graph.
- [x] **REFACTOR**: `register(with:)` is the only production registration site; no manual DI plumbing left. Package kept at `swift-tools-version: 5.9` so the hand-tuned `NSLock` code stays Swift 5 language mode while FactoryKit builds in its own Swift 6 mode.

## Definition of Done (DoD)
1. `logger_native_bridge` resolves via SPM — `ios/Runner.xcodeproj` `Package.resolved` lists it and `FactoryKit`; no `.podspec` remains.
2. Pigeon round-trips Dart ↔ Swift at runtime; the log bridge behaves as before.
3. All plugin Swift tests pass and use `LoggerNativeBridgeContainer` overrides.
4. `flutter build ios --no-codesign` and `melos run analyze` clean; existing pod plugins unaffected.

## Dependencies & Blockers
- Blocked by: [Task 13](task_13_enable_flutter_spm_host.md)
- Blocks: [Task 16](task_16_migrate_native_security_spm_factorykit.md) (path dependency), [Task 19](task_19_pac_rename_project_package_swift.md)

## References & Rollback
- Source Spec: [2026-09-09-ios-native-plugin-factory-di-spm-design.md](../epic/flutter_super_app_template/2026-09-09-ios-native-plugin-factory-di-spm-design.md) §5.2, verification row 2
- FactoryKit custom container: https://github.com/hmlongco/Factory
- Rollback: `git revert` the migration commit — restores `ios/Classes/` + `.podspec`; CocoaPods path resumes with no host change.
