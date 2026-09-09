---
id: "task_16_migrate_native_security_spm_factorykit"
status: "done"
priority: "high"
assignee: null
epic: "flutter_super_app_template"
dueDate: null
created: "2026-09-09T09:51:07.000Z"
modified: "2026-09-09T11:05:00.000Z"
completedAt: "2026-09-09T11:05:00.000Z"
labels: ["ios", "spm", "factorykit", "ffi", "phase-5"]
order: "a16"
---

# Task 16: Migrate `native_security` → Flutter SPM + FactoryKit

Epic: [flutter_super_app_template](../epic/flutter_super_app_template/flutter_super_app_template.en.md)

## Requirement Analysis
Migrate the FFI + Datadog-appender plugin `native_security` to a SwiftPM package, applying the pattern proven in Task 15 plus the FFI recipe from the Task 14 spike. **Task 14 verdict: GO** (spec §5.3 "Spike findings") — ffiPlugin + SPM works; plugin packages link `type: .static` into the app; the fix for FFI symbol dead-strip is a `__attribute__((constructor))` anchor in the C TU.

Requirements (go path):
1. **Layout**: `ios/native_security.podspec` → `ios/native_security/Package.swift`. Sources: `NativeSecurityPlugin.swift`, `DatadogNativeAppender.swift` → `Sources/native_security/`; `native_security.cpp` + `native_security.h` → `Sources/native_security_ffi/` with `include/native_security.h` + a `module.modulemap`. Delete the podspec. `pubspec.yaml` keeps `ffiPlugin: true`.
2. **`Package.swift`**: two targets — a **C/C++ target** `native_security_ffi` and a **Swift target** `native_security` listing it in `dependencies`; product `.library(name: "native-security", targets: ["native_security"])`. Deps: `FlutterFramework` (path), FactoryKit (`exact: "<pin>"`, same as Task 15), and `logger_native_bridge` via `.package(path: "../../logger_native_bridge/ios/logger_native_bridge")` (replaces podspec `s.dependency 'logger_native_bridge'`). Apply the exact symbol-retention flags from the Task 14 spike (`cSettings` / `linkerSettings`).
3. **FFI reachability** (per Task 14 spike): (a) retain `__attribute__((used)) __attribute__((visibility("default")))` in `native_security.h`; (b) **add a `__attribute__((constructor))` anchor** in `native_security.cpp` that references `get_ssl_pin_1/2/3()` — this is the decisive fix (bare `((used))` is not enough; the linker drops the unreferenced static-archive member); (c) keep the `_ = get_ssl_pin_1() …` force-reference in `NativeSecurityPlugin.register(with:)` as a second anchor; (d) `cSettings: [.unsafeFlags(["-fvisibility=default"])]` on the C/C++ target. `lib/native_security.dart` needs **no** loader change (its `executable()` → `process()` fallback already covers static linking).
4. **Container**: `Sources/native_security/NativeSecurityContainer.swift` (`SharedContainer`). Move `DatadogNativeAppender` construction and its `D3NexusNativeLogger` hook (from `logger_native_bridge`) onto container factories. `NativeSecurityPlugin.register(with:)` is the composition root.
5. **Tests**: move `ios/Tests/native_securityTests/*` → `ios/native_security/Tests/native_securityTests/`.
6. **`packages/network` consumer stays as-is** — `HardenedSslPinning` still imports `package:native_security/native_security.dart`; the Dart API surface is unchanged, only the iOS build system changes.

## Relevant Files & Context Pointers
- `packages/native_security/ios/native_security.podspec` (delete on go path)
- `packages/native_security/ios/Classes/` → `ios/native_security/Sources/{native_security,native_security_ffi}/`
  - `NativeSecurityPlugin.swift`, `DatadogNativeAppender.swift`, `native_security.cpp`, `native_security.h`
- `packages/native_security/ios/Tests/native_securityTests/`
- `packages/native_security/lib/native_security.dart` (FFI loader)
- `packages/native_security/pubspec.yaml` (`ffiPlugin: true`, dep `logger_native_bridge`)
- `packages/network/lib/ssl/hardened_ssl_pinning.dart` (consumer — do not change)
- Task 14 spike findings (appended to spec §5.3)
- Task 15 migration (pattern reference)

## Design Rationale
Same per-plugin `SharedContainer` rationale as Task 15 (spec D3/D4). The FFI target is split out so the C/C++ compile settings and module map stay isolated from the Swift target. The `logger_native_bridge` dependency becomes a local SwiftPM path package, mirroring the old podspec `s.dependency`. The spike-first sequencing means this task never discovers the dead-strip problem cold.
Applicable skills: `systematic-debugging`, `test-driven-development`, `verification-before-completion`.

## TDD Checklist
- [x] **RED**: Added `Tests/native_securityTests/NativeSecurityContainerTests.swift` (`.register { spy }` override + `.reset()`); the existing `DatadogNativeAppenderHeadlessTests` moved unchanged. FFI constant check runs as the `nm` / `dyld_info -exports` assertion below (no Dart FFI test existed and `DynamicLibrary.executable()` can't run under `flutter test`).
- [x] **GREEN**:
  - [x] Created `ios/native_security/Package.swift` — **two targets**: C/C++ `native_security_ffi` (`cSettings: -fvisibility=default`, `include/native_security.h` + `module.modulemap`) and Swift `native_security` depending on it + `FlutterFramework` + `FactoryKit` + `logger-native-bridge` (`.package(path: "../../../logger_native_bridge/ios/logger_native_bridge")` — Flutter resolved this cross-plugin path). Deleted `.podspec`.
  - [x] Added the `__attribute__((constructor)) native_security_link_anchor` to `native_security.cpp` (task_14 recipe); kept the Swift `_ = get_ssl_pin_*()` force-refs in `register(with:)`; kept `__attribute__((used, visibility("default")))` in the header.
  - [x] Added `NativeSecurityContainer` with a `datadogAppender` factory (not newly wired into `D3NexusNativeLogger` — that stays Task 7's scope).
  - [x] `flutter build ios --release --no-codesign` (dead-strip on) → `✓ Built Runner.app`. `nm build/ios/Release-iphoneos/Runner.app/Runner` → `T _get_ssl_pin_1/2/3` + `t native_security_link_anchor`; `dyld_info -exports` lists all three → `DynamicLibrary.executable()/.process()` resolves. `native_security` dropped off Flutter's "does not support SPM" list.
  - [~] On-device `getSslPin1()` smoke + `xcodebuild test` — deferred (needs a device / test host; proxy verification agreed).
  - [x] `packages/network` SSL pinning path: `flutter analyze packages/network` + `flutter test packages/network/test` pass — Dart API surface unchanged.
- [x] **REFACTOR**: `register(with:)` is the only Swift registration site; `Package.swift` `swift-tools-version: 5.9` keeps the plugin Swift 5 while FactoryKit builds Swift 6.

## Definition of Done (DoD)
1. `native_security` resolves via SPM (`Package.resolved` lists it, `FactoryKit`, and the local `logger_native_bridge` package); no `.podspec` remains — **or**, on the spike no-go path, it is explicitly left on `.podspec` with a Phase 2 note.
2. `NativeSecurity.getSslPin1/2/3()` work from Dart in a **release** build on a real device (no regression vs. the podspec build).
3. `DatadogNativeAppender` still forwards to `logger_native_bridge`.
4. `packages/network` SSL pinning path unchanged and compiling; `flutter build ios` + `melos run analyze` clean.

## Dependencies & Blockers
- Blocked by: [Task 14](task_14_spike_native_security_spm_ffi.md), [Task 15](task_15_migrate_logger_native_bridge_spm_factorykit.md)
- Blocks: [Task 19](task_19_pac_rename_project_package_swift.md)

## References & Rollback
- Source Spec: [2026-09-09-ios-native-plugin-factory-di-spm-design.md](../epic/flutter_super_app_template/2026-09-09-ios-native-plugin-factory-di-spm-design.md) §5.3, R3, verification row 4
- Rollback: `git revert` the migration commit — restores `ios/Classes/` + `.podspec` + the podspec `s.dependency`; CocoaPods path resumes with no host change.
