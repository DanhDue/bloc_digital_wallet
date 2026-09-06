---
id: "task_4_pac_native_plugin_brick"
status: "done"
priority: "high"
assignee: null
epic: "flutter_super_app_template"
dueDate: null
created: "2026-09-06T18:05:00.000Z"
modified: "2026-09-06T18:40:00.000Z"
completedAt: "2026-09-06T18:40:00.000Z"
labels: ["mason", "native", "plugin"]
order: "a4"
---

# Task 4: Brick `pac_native_plugin` Creation (Headless & Native UI)

Epic: [flutter_super_app_template](../epic/flutter_super_app_template/flutter_super_app_template.en.md)

## Requirement Analysis
Flutter packages that interface with native device hardware, secure hardware, or proprietary OS SDKs must follow a standardized, layered Clean Architecture matching the sibling native templates (`android_super_app_template` and `ios_super_app_template`).

Requirements:
1. Create `bricks/pac_native_plugin/brick.yaml` with parameters:
   - `name`: Package name in snake_case (e.g. `biometric_auth`, `camera_scanner`).
   - `has_ui`: Boolean (default: false).
   - `android_package`: Namespace for Android (default: `com.danhdue.{{name}}`).
2. Implement native directory structures inside `__brick__/packages/{{name.snakeCase()}}/`:
   - **Android (`android/`)**:
     - `src/main/kotlin/com/danhdue/{{name}}/platform/`: Plugin class registering MethodChannel/Pigeon or `PlatformViewFactory`.
     - `src/main/kotlin/com/danhdue/{{name}}/domain/`: Pure Kotlin models, repository interfaces, use cases.
     - `src/main/kotlin/com/danhdue/{{name}}/data/`: System services, hardware APIs, storage adapters.
     - `src/main/kotlin/com/danhdue/{{name}}/presentation/` (Conditional: `has_ui == true`):
       - `MviViewModel.kt`: Self-contained MVI base (StateFlow + Channel, no Hilt coupling).
       - `{{name.pascalCase()}}ViewModel.kt`, `*Action.kt`, `*State.kt`, `*Event.kt`.
       - `{{name.pascalCase()}}Screen.kt`: Jetpack Compose `@Composable` UI.
       - `{{name.pascalCase()}}PlatformView.kt`: `ComposeView` wrapped in Flutter `PlatformView`.
     - `build.gradle.kts`: Configured with Kotlin, enabling Compose when `has_ui == true`.
   - **iOS (`ios/`)**:
     - `Classes/Platform/`: Plugin class, Pigeon implementation or `FlutterPlatformViewFactory`.
     - `Classes/Domain/`: Pure Swift entities, protocols, use cases.
     - `Classes/Data/`: Apple frameworks (Security, AVFoundation, etc.).
     - `Classes/Presentation/` (Conditional: `has_ui == true`):
       - `MviViewModel.swift`: Self-contained MVI base (Combine `@Published` + `PassthroughSubject`).
       - `{{name.pascalCase()}}ViewModel.swift`, `*Action.swift`, `*State.swift`, `*Event.swift`.
       - `{{name.pascalCase()}}View.swift`: SwiftUI `View`.
       - `{{name.pascalCase()}}PlatformView.swift`: `UIHostingController` wrapped in `FlutterPlatformView`.
     - `{{name.snakeCase()}}.podspec`: Podspec definition.
   - **Dart (`lib/`)**:
     - `lib/{{name.snakeCase()}}.dart`: Public API barrel.
     - `pigeons/{{name.snakeCase()}}_messages.dart` (when `has_ui == false`): Pigeon type-safe schema.
     - `lib/src/ui/{{name.snakeCase()}}_native_view.dart` (when `has_ui == true`): Widget wrapping `AndroidView` and `UiKitView`.
3. Implement `hooks/post_gen.dart`:
   - Registers package in root `pubspec.yaml`.
   - Generates initial Pigeon output if `has_ui == false`.
4. Register `pac_native_plugin` in root `mason.yaml`.

## Relevant Files & Context Pointers
- `mason.yaml`
- `packages/logger_native_bridge/` (reference for Pigeon IPC & native layers)
- `packages/native_security/` (reference for native FFI & platform layers)
- Reference: `/Users/danhdue/AllProjects/digital_wallet/android_digital_wallet/.worktrees/android_super_app_template/packages/framework/src/main/java/com/danhdue/framework/base/MviViewModel.kt`
- Reference: `/Users/danhdue/AllProjects/digital_wallet/iOSDigitalWallet/.worktrees/ios_super_app_template/Packages/Framework/Sources/Framework/MviViewModel.swift`
- New directory: `bricks/pac_native_plugin/`

## Design Rationale
Plugin packages must be completely self-contained (no hard external file dependencies into the standalone native repos), enabling effortless publishing or portability. Structuring native code into `Platform/Domain/Data/Presentation` creates 100% architectural parity with the native templates.
Applicable skills: `writing-skills`, `mobile-developer`.

## TDD Checklist
- [ ] **RED**: Assert failure when attempting to generate native plugin before brick implementation.
- [ ] **GREEN**:
  - [ ] Implement `bricks/pac_native_plugin/brick.yaml`.
  - [ ] Implement all templates in `__brick__/packages/{{name.snakeCase()}}/` for both UI and No-UI branches.
  - [ ] Implement `hooks/post_gen.dart` for workspace registration.
  - [ ] Register in `mason.yaml`.
  - [ ] Run `mason make pac_native_plugin --name test_headless --has_ui false`.
  - [ ] Verify `packages/test_headless/` has `Platform/Domain/Data` and `pigeons/`.
  - [ ] Run `mason make pac_native_plugin --name test_ui_plugin --has_ui true`.
  - [ ] Verify `packages/test_ui_plugin/` has Compose screen, SwiftUI view, and `PlatformView` wrapper.
- [ ] **REFACTOR**:
  - [ ] Run `melos bootstrap`.
  - [ ] Run `dart analyze` on generated packages.
  - [ ] Clean up test packages and revert `pubspec.yaml`.

## Definition of Done (DoD)
1. `pac_native_plugin` brick is registered in `mason.yaml`.
2. Headless generation (`has_ui: false`) produces clean Pigeon-ready native code.
3. UI-enabled generation (`has_ui: true`) produces working Compose and SwiftUI `PlatformView` integrations with MVI view models.
4. Generated code compiles cleanly in Dart, Kotlin, and Swift without lint errors.

## Dependencies & Blockers
- Blocked by: [Task 1](task_1_monorepo_restructuring.md)
- Blocks: [Task 5](task_5_pac_add_native_ui_tool.md)

## References & Rollback
- Source Spec: [2026-09-06-flutter-super-app-template-design.md](../epic/flutter_super_app_template/2026-09-06-flutter-super-app-template-design.md) §4.3
- Rollback: Remove `bricks/pac_native_plugin/` and its `mason.yaml` entry.
