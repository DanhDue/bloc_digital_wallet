---
id: "task_5_pac_add_native_ui_tool"
status: "done"
priority: "high"
assignee: null
epic: "flutter_super_app_template"
dueDate: null
created: "2026-09-06T18:05:00.000Z"
modified: "2026-09-06T18:45:00.000Z"
completedAt: "2026-09-06T18:45:00.000Z"
labels: ["mason", "native", "tooling"]
order: "a5"
---

# Task 5: Brick `pac_add_native_ui` Creation

Epic: [flutter_super_app_template](../epic/flutter_super_app_template/flutter_super_app_template.en.md)

## Requirement Analysis
When a native package is initially created as headless (`has_ui: false`), subsequent feature requirements may introduce native UI (e.g. custom camera viewfinder, biometric prompt screen, hardware overlay). To transition seamlessly without re-scaffolding or damaging existing domain/data/pigeon code, this task delivers `pac_add_native_ui` as a pure Mason brick.

Requirements:
1. Create `bricks/pac_add_native_ui/brick.yaml` with parameter `name` (package name).
2. Implement `hooks/pre_gen.dart`:
   - Validate that `packages/{{name}}/` exists. If not, abort with a clear error message.
   - Validate that `packages/{{name}}/android/src/main/kotlin/.../presentation` does not already exist (idempotency safety).
3. Implement `__brick__/packages/{{name.snakeCase()}}/`:
   - Android: `presentation/MviViewModel.kt`, `{{name.pascalCase()}}Screen.kt` (Compose), `*Action.kt`, `*State.kt`, `*Event.kt`, and `{{name.pascalCase()}}PlatformView.kt`.
   - iOS: `Presentation/MviViewModel.swift`, `{{name.pascalCase()}}View.swift` (SwiftUI), `*Action.swift`, `*State.swift`, `*Event.swift`, and `{{name.pascalCase()}}PlatformView.swift`.
   - Dart: `lib/src/ui/{{name.snakeCase()}}_native_view.dart` (wrapping `AndroidView` and `UiKitView`).
4. Implement `hooks/post_gen.dart`:
   - Android: Inspect `android/build.gradle.kts` and ensure `buildFeatures { compose = true }` is injected if missing.
   - Android: Patch the `*Plugin.kt` file to register `PlatformViewFactory` in `onAttachedToEngine()`.
   - iOS: Patch the `*Plugin.swift` file to register `FlutterPlatformViewFactory` in `register(with:)`.
   - Dart: Append `export 'src/ui/{{name.snakeCase()}}_native_view.dart';` into `lib/{{name.snakeCase()}}.dart`.
5. Register `pac_add_native_ui` in root `mason.yaml`.

## Relevant Files & Context Pointers
- `mason.yaml`
- `bricks/pac_native_plugin/` (reference for presentation templates)
- Target directory: `packages/<name>/`
- New directory: `bricks/pac_add_native_ui/`

## Design Rationale
Executing 100% of validation and patching inside Dart Mason hooks (`pre_gen.dart` and `post_gen.dart`) eliminates external script dependencies (like bash `sed` differences between macOS and Linux) and ensures consistent developer ergonomics (`mason make pac_add_native_ui --name <name>`).
Applicable skills: `writing-skills`, `systematic-debugging`.

## TDD Checklist
- [x] **RED**:
  - [x] Generate a headless plugin: `mason make pac_native_plugin --name demo_upgrade --has_ui false`.
  - [x] Assert that `demo_upgrade` lacks `presentation/` and `_native_view.dart`.
- [x] **GREEN**:
  - [x] Implement `bricks/pac_add_native_ui` (brick.yaml, pre_gen.dart, __brick__, post_gen.dart).
  - [x] Register in `mason.yaml` and run `mason get`.
  - [x] Run `mason make pac_add_native_ui --name demo_upgrade`.
  - [x] Verify `android/` has Compose enabled, `presentation/` created, and `*Plugin.kt` patched.
  - [x] Verify `ios/` has `Presentation/` created and `*Plugin.swift` patched.
  - [x] Verify `lib/demo_upgrade.dart` exports the new native view widget.
- [x] **REFACTOR**:
  - [x] Run `dart analyze packages/demo_upgrade` to confirm zero lint errors.
  - [x] Test idempotency: re-run `mason make pac_add_native_ui --name demo_upgrade` and assert that `pre_gen.dart` safely rejects overwriting.
  - [x] Clean up `packages/demo_upgrade/` and revert `pubspec.yaml`.

## Definition of Done (DoD)
1. `mason make pac_add_native_ui --name <name>` successfully upgrades a headless package to have native UI.
2. Android Compose and iOS SwiftUI views are properly registered with their respective platform view factories.
3. Pre-existing headless logic and files remain 100% intact.
4. Attempting to run on a non-existent package or an already-upgraded package is safely rejected.

## Dependencies & Blockers
- Blocked by: [Task 4](task_4_pac_native_plugin_brick.md)
- Blocks: None

## References & Rollback
- Source Spec: [2026-09-06-flutter-super-app-template-design.md](../epic/flutter_super_app_template/2026-09-06-flutter-super-app-template-design.md) §4.4
- Rollback: Remove `bricks/pac_add_native_ui/` and remove from `mason.yaml`.
