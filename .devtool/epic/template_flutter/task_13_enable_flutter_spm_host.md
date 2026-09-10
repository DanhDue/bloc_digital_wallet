---
id: "task_13_enable_flutter_spm_host"
status: "done"
priority: "high"
assignee: null
epic: "flutter_super_app_template"
dueDate: null
created: "2026-09-09T09:51:07.000Z"
modified: "2026-09-09T10:30:00.000Z"
completedAt: "2026-09-09T10:30:00.000Z"
labels: ["ios", "spm", "infra", "phase-5"]
order: "a13"
---

# Task 13: Enable Flutter Swift Package Manager on the Host (Hybrid)

Epic: [flutter_super_app_template](../epic/flutter_super_app_template/flutter_super_app_template.en.md)

## Requirement Analysis
Phase 5 delivers every iOS-native package as a Swift Package (`Package.swift`) with a FactoryKit dependency. Flutter can only resolve SwiftPM plugins when Swift Package Manager support is enabled on the host app. This task turns it on with the **minimum** change and keeps CocoaPods working for every plugin that has not migrated yet.

Requirements:
1. Enable SPM support: `flutter config --enable-swift-package-manager` (Flutter ≥ 3.44 — template is on 3.47.0 per `.fvmrc`; no upgrade needed).
2. Run `flutter build ios --no-codesign` (or `flutter run`) once so the Flutter CLI performs its one-time migration of `ios/Runner.xcodeproj` — it adds the local `FlutterGeneratedPluginSwiftPackage` package reference to the `Runner` target. Commit the resulting `project.pbxproj` / workspace changes.
3. Confirm **hybrid** operation: with SPM enabled and no plugin migrated yet, the app still builds and all current CocoaPods plugins (`native_security`, `logger_native_bridge`, `permission_handler_apple`, `connectivity_plus`, `shared_preferences_foundation`, `sqflite_darwin`, `google_sign_in_ios`, `share_plus`, `package_info_plus`, `flutter_secure_storage_darwin`, `image_gallery_saver_plus`, `animated_item`, `pretty_animated_text`, `flutter_native_splash`) keep resolving via `ios/Podfile`.
4. Document the flag: add `flutter config --enable-swift-package-manager` to the developer setup docs (`README.md` and/or `docs/`) and to CI setup steps (`.github/workflows/*` if an iOS job exists).
5. No change to `scripts/buildIPA.sh` build logic — only the one-time `flutter config` in setup/bootstrap.

## Relevant Files & Context Pointers
- `.fvmrc` (Flutter 3.47.0 — SPM available)
- `ios/Runner.xcodeproj/project.pbxproj`
- `ios/Runner.xcworkspace/`
- `ios/Podfile`, `ios/Podfile.lock`
- `ios/Flutter/` (ephemeral SPM shim already present)
- `scripts/buildIPA.sh`, `scripts/` setup scripts
- `README.md`, `docs/`
- `.github/workflows/` (CI, if iOS build job present)

## Design Rationale
SPM and CocoaPods coexist in a Flutter iOS app since Flutter 3.24+/3.44+. Enabling the flag is reversible (`flutter config --no-enable-swift-package-manager`) and non-destructive: unmigrated plugins keep their podspec path. Doing this as its own task isolates the host-project churn (a `project.pbxproj` diff) from the plugin migrations that depend on it, so a regression here is easy to bisect.
Applicable skills: `verification-before-completion`, `mobile-developer`.

## TDD Checklist
*TDD Adaptation:* This is a build-system/config change with no new runtime behavior. RED/GREEN/REFACTOR does not apply; the verification is a clean hybrid build.
- [x] **IMPLEMENT**:
  - [x] `flutter config --enable-swift-package-manager` — already enabled machine-wide (`~/.config/flutter/settings` has `"enable-swift-package-manager": true`).
  - [x] `ios/Runner.xcodeproj` SPM migration — **already present** on `super_app_template` (`XCLocalSwiftPackageReference "Flutter/ephemeral/Packages/FlutterGeneratedPluginSwiftPackage"` wired into `packageReferences`). Nothing to re-commit.
  - [x] Add the flag to setup docs: `docs/getting-started/create-new-project-from-template.{en,vi}.md` Step 4, `docs/development/IMPLEMENTATION_GUIDE.md` Prerequisites. **No CI:** the repo has no `.github/workflows/`, so there is no CI setup step to update.
- [x] **VERIFY (no regression)**:
  - [x] `flutter pub get` + `pod install` succeed (build log: `Running pod install... 677ms`).
  - [x] `flutter build ios --simulator --debug` SUCCESS — `✓ Built build/ios/iphonesimulator/Runner.app`; Flutter reports `animated_item, image_gallery_saver_plus, logger_native_bridge, native_security, permission_handler_apple` still on CocoaPods (hybrid confirmed). Device (`--no-codesign`) build compiles (`Xcode build done 16.7s`) and only stops at the signing-team gate.
  - [x] `melos run analyze` → `No issues found!`
  - [~] Simulator `flutter run` launch + on-device `NativeSecurity.getSslPin1()` — deferred; covered by task_15/task_16 verification (proxy iOS verification agreed for this environment).
  - [~] Reversibility (`--no-enable-swift-package-manager`) — not toggled to avoid disturbing the shared machine setting; documented as reversible.

## Definition of Done (DoD)
1. SPM support is enabled and the `ios/Runner.xcodeproj` one-time migration is committed.
2. `flutter build ios --no-codesign` passes in hybrid mode (SPM on, all plugins still CocoaPods).
3. No existing plugin regressed.
4. Setup docs and CI include the `flutter config` step.

## Dependencies & Blockers
- Blocked by: None (first task of Phase 5).
- Blocks: [Task 15](task_15_migrate_logger_native_bridge_spm_factorykit.md), [Task 16](task_16_migrate_native_security_spm_factorykit.md), [Task 17](task_17_rewrite_pac_native_plugin_ios_spm.md)

## References & Rollback
- Source Spec: [2026-09-09-ios-native-plugin-factory-di-spm-design.md](../epic/flutter_super_app_template/2026-09-09-ios-native-plugin-factory-di-spm-design.md) §5.1, verification row 1
- Flutter SPM for app authors: https://docs.flutter.dev/packages-and-plugins/swift-package-manager/for-app-developers
- Rollback: `flutter config --no-enable-swift-package-manager` and revert the `ios/Runner.xcodeproj` commit.
