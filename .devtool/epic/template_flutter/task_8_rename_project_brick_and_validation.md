---
id: "task_8_rename_project_brick_and_validation"
status: "done"
priority: "high"
assignee: null
epic: "flutter_super_app_template"
dueDate: null
created: "2026-09-06T18:05:00.000Z"
modified: "2026-09-06T19:10:00.000Z"
completedAt: "2026-09-06T19:10:00.000Z"
labels: ["tooling", "validation", "mason"]
order: "a8"
---

# Task 8: Brick `pac_rename_project` & Full Validation

Epic: [flutter_super_app_template](../epic/flutter_super_app_template/flutter_super_app_template.en.md)

## Requirement Analysis
The final milestone of turning `bloc_digital_wallet` into a reusable Flutter Super App Template is enabling a developer to clone the repository, execute a single rename command, and immediately build and run their new application without manual search-and-replace.

Requirements:
1. Implement `bricks/pac_rename_project/brick.yaml` with parameters:
   - `app_name`: Human-readable display name (e.g., "My Super App").
   - `package_name`: Dart package identifier in snake_case (e.g., `my_super_app`).
   - `bundle_id`: Reverse-domain identifier for mobile platforms (e.g., `com.company.mysuperapp`).
2. Implement `hooks/post_gen.dart` using pure Dart (cross-platform, immune to macOS vs Linux `sed` incompatibilities):
   - Replace root package name in `pubspec.yaml` and `melos.yaml`.
   - Traverse `lib/`, `features/`, `packages/` and replace all `package:bloc_digital_wallet/...` imports with `package:{{package_name}}/...`.
   - Update Android `applicationId` and namespace in `android/app/build.gradle.kts`.
   - Update iOS `PRODUCT_BUNDLE_IDENTIFIER` in `ios/Runner.xcodeproj/project.pbxproj` and `.xcconfig`.
   - Update app display titles in `AndroidManifest.xml`, `Info.plist`, and `flutter_native_splash.yaml`.
   - **Crucial Vendor Lock**: Strictly preserve `com.danhdue.*` namespaces in `packages/native_security` and `packages/logger_native_bridge`.
   - Trigger `melos genAlls` upon completion.
3. Provide `./scripts/rename_project.sh`:
   - A lightweight 2-line convenience wrapper forwarding arguments to `mason make pac_rename_project "$@"`.
4. Register `pac_rename_project` in `mason.yaml`.
5. Full End-to-End Validation:
   - On an isolated test worktree or branch, run the renaming tool.
   - Verify `melos bootstrap` and `melos genAlls` complete cleanly.
   - Verify all unit tests pass with `fvm flutter test`.
   - Verify `fvm flutter build apk --debug` succeeds.
   - Verify `fvm flutter build ios --no-codesign` succeeds.

## Relevant Files & Context Pointers
- `mason.yaml`
- New brick: `bricks/pac_rename_project/`
- New script: `scripts/rename_project.sh`
- `pubspec.yaml`
- `melos.yaml`
- `android/app/build.gradle.kts`
- `ios/Runner.xcodeproj/project.pbxproj`
- `ios/Runner/Info.plist`

## Design Rationale
Using a Mason brick written in pure Dart eliminates shell quoting and regex differences across platforms (macOS, Windows, Linux). Providing the shell script wrapper ensures developers accustomed to bash scripts get the same zero-friction experience.
Applicable skills: `writing-skills`, `verification-before-completion`.

## TDD Checklist
*TDD Adaptation:* End-to-end integration and compilation verification in an isolated git worktree.
- [x] **IMPLEMENT**:
  - [x] Implement `bricks/pac_rename_project` (brick.yaml and post_gen.dart).
  - [x] Register in `mason.yaml`.
  - [x] Implement `scripts/rename_project.sh` wrapper with executable permissions (`chmod +x`).
- [x] **ISOLATED TEST**:
  - [x] Create a temporary git worktree or branch `test/template_rename_validation`.
  - [x] Execute `mason make pac_rename_project --app_name "Demo App" --package_name "demo_app" --bundle_id "com.example.demoapp"`.
  - [x] Assert `pubspec.yaml` has name `demo_app`.
  - [x] Assert no dangling `package:bloc_digital_wallet/` imports remain.
  - [x] Assert `com.danhdue.native_security` and `com.danhdue.logger_native_bridge` were not altered.
  - [x] Run `melos bootstrap && melos genAlls`.
  - [x] Run `melos run analyze` -> 0 errors.
  - [x] Run `fvm flutter test` -> 100% pass.
  - [x] Run `fvm flutter build apk --debug` -> SUCCESS.
  - [x] Run `fvm flutter build ios --no-codesign` -> SUCCESS.
- [x] **CLEANUP**:
  - [x] Delete temporary test worktree/branch after verification.

## Definition of Done (DoD)
1. `pac_rename_project` brick and `scripts/rename_project.sh` are fully functional.
2. Executing the rename command transforms the repository into a fully working new app.
3. Zero compilation or code generation errors occur under the new identity.
4. Android and iOS builds succeed without codesigning failures.

## Dependencies & Blockers
- Blocked by: [Task 6](task_6_template_trimming_and_shell.md), [Task 7](task_7_obsolete_cleanups.md)
- Blocks: None (Terminal Epic Milestone)

## References & Rollback
- Source Spec: [2026-09-06-flutter-super-app-template-design.md](../epic/flutter_super_app_template/2026-09-06-flutter-super-app-template-design.md) §4.5 & §8
- Rollback: Delete `bricks/pac_rename_project/` and `scripts/rename_project.sh`.
