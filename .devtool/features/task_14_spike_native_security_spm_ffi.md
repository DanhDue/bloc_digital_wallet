---
id: "task_14_spike_native_security_spm_ffi"
status: "todo"
priority: "high"
assignee: null
epic: "flutter_super_app_template"
dueDate: null
created: "2026-09-09T09:51:07.000Z"
modified: "2026-09-09T09:51:07.000Z"
completedAt: null
labels: ["ios", "spm", "ffi", "spike", "phase-5"]
order: "a14"
---

# Task 14: Spike — `native_security` Mixed C/C++/Swift as a Flutter SPM ffiPlugin

Epic: [flutter_super_app_template](../epic/flutter_super_app_template/flutter_super_app_template.en.md)

## Requirement Analysis
`native_security` is the only local package with a C/C++ FFI target (`ios/Classes/native_security.cpp` + `.h`, `pubspec.yaml` `ffiPlugin: true`). Its Dart side (`lib/native_security.dart`) loads symbols via `DynamicLibrary.executable()` → `.process()` → framework paths and calls `get_ssl_pin_1/2/3()`. Migrating this to a SwiftPM `Package.swift` risks the linker **dead-stripping** those symbols out of the app binary in a release build, breaking FFI silently. This spike answers one question before Task 16 commits: **does a mixed C/C++/Swift Flutter SPM ffiPlugin build in release and keep its FFI symbols reachable from Dart on a real device?**

This is a **throwaway** spike. Nothing it produces ships. Its output is a written recommendation appended to the Phase 5 spec (or this file) and a go/no-go for Task 16.

Investigate:
1. Minimal `Package.swift` with a **C/C++ target** (`Sources/<name>_ffi/` holding `native_security.cpp` + `include/native_security.h` + a `module.modulemap`) and a **Swift target** depending on it.
2. Symbol retention: does `__attribute__((used)) __attribute__((visibility("default")))` in the header + a force-reference from `<Name>Plugin.register(with:)` survive `-dead_strip` under `flutter build ios --release`? If not, what does — `cSettings: [.unsafeFlags(["-fvisibility=default"])]`, a `linkerSettings` `-Xlinker -exported_symbol` entry, `-all_load`, or a `.xcprivacy`/module-map tweak?
3. Does Flutter's SPM support actually pick up an `ffiPlugin: true` plugin from `ios/<name>/Package.swift` (vs only `pluginClass` plugins)?
4. Does `DynamicLibrary.executable()` still resolve, or must the Dart loader fall back to `.process()` — does `lib/native_security.dart` need changes?

## Relevant Files & Context Pointers
- `packages/native_security/lib/native_security.dart` (FFI loader + `getSslPin1/2/3`)
- `packages/native_security/ios/Classes/native_security.cpp`, `native_security.h`
- `packages/native_security/ios/Classes/NativeSecurityPlugin.swift` (force-reference trick)
- `packages/native_security/ios/native_security.podspec` (`static_framework`, `GCC_SYMBOLS_PRIVATE_EXTERN = NO`)
- `packages/native_security/pubspec.yaml` (`ffiPlugin: true`)
- Scratch worktree only — do not modify `packages/native_security/` in place for the spike.

## Design Rationale
FFI symbol visibility under SwiftPM static linking is the single highest-uncertainty item in Phase 5 (spec R3). A cheap isolated spike de-risks Task 16 and gives the fallback decision (keep this one plugin on `.podspec`, hybrid-tolerated, fold into Phase 2) a factual basis instead of discovering the problem mid-migration.
Applicable skills: `systematic-debugging`, `verification-before-completion`.

## TDD Checklist
*TDD Adaptation:* Spike / feasibility probe. Output is a recommendation, not shipped code. Replace RED/GREEN/REFACTOR with a probe protocol.
- [ ] **PROBE**:
  - [ ] In a scratch dir (or `git worktree`), build a throwaway Flutter plugin `spm_ffi_probe` exposing one C function `probe_pin()` returning a known string, mirroring `native_security`'s structure.
  - [ ] Author `ios/spm_ffi_probe/Package.swift` with the C/C++ target + Swift target + module map.
  - [ ] Wire a host example app, `flutter config --enable-swift-package-manager`.
  - [ ] `flutter build ios --release` (dead-strip on) → build SUCCESS.
  - [ ] Run on a **real device**; assert Dart `DynamicLibrary.executable()/.process()` + `lookupFunction` returns `probe_pin()`'s value.
  - [ ] Record which symbol-retention flags were required.
- [ ] **REPORT**:
  - [ ] Append a "Spike findings" subsection to the Phase 5 spec §5.3: verdict (go / go-with-flags / no-go), exact `Package.swift` snippet that worked, and any `lib/native_security.dart` change needed.
  - [ ] If no-go: update Task 16 to the podspec-fallback path and note it in the epic HLD risk row.
- [ ] **CLEANUP**:
  - [ ] Delete the scratch probe project / worktree.

## Definition of Done (DoD)
1. A documented, reproducible answer to "does the mixed C/C++/Swift SPM ffiPlugin work in release on device?".
2. The exact `Package.swift` + flag recipe that worked (or a stated no-go with the fallback wired into Task 16).
3. No changes committed under `packages/native_security/`; scratch artifacts deleted.

## Dependencies & Blockers
- Blocked by: [Task 13](task_13_enable_flutter_spm_host.md)
- Blocks: [Task 16](task_16_migrate_native_security_spm_factorykit.md)

## References & Rollback
- Source Spec: [2026-09-09-ios-native-plugin-factory-di-spm-design.md](../epic/flutter_super_app_template/2026-09-09-ios-native-plugin-factory-di-spm-design.md) §5.3, R3, verification row 3
- Flutter SPM for plugin authors: https://docs.flutter.dev/packages-and-plugins/swift-package-manager/for-plugin-authors
- Rollback: N/A (spike produces no committed code).
