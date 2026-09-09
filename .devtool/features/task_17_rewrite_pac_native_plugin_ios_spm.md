---
id: "task_17_rewrite_pac_native_plugin_ios_spm"
status: "todo"
priority: "high"
assignee: null
epic: "flutter_super_app_template"
dueDate: null
created: "2026-09-09T09:51:07.000Z"
modified: "2026-09-09T11:20:00.000Z"
completedAt: "2026-09-09T11:20:00.000Z"
labels: ["mason", "brick", "ios", "spm", "factorykit", "phase-5"]
order: "a17"
---

# Task 17: Rewrite `pac_native_plugin` Brick — iOS Side (SPM + FactoryKit)

Epic: [flutter_super_app_template](../epic/flutter_super_app_template/flutter_super_app_template.en.md)

## Requirement Analysis
Replace the CocoaPods/`ios/Classes/**` output of `pac_native_plugin` with the SwiftPM layout and the per-plugin FactoryKit container pattern. Android and Dart output of the brick are unchanged.

Requirements:
1. **`__brick__` iOS layout** at `bricks/pac_native_plugin/__brick__/packages/{{name.snakeCase()}}/ios/{{name.snakeCase()}}/`:
   - `Package.swift` — `swift-tools-version: 5.9`, `platforms: [.iOS("13.0")]`, product `.library(name: "{{name.paramCase()}}", targets: ["{{name.snakeCase()}}"])`, deps `FlutterFramework` (path `../FlutterFramework`) + FactoryKit (`.package(url: "https://github.com/hmlongco/Factory.git", exact: "<pin>")`), `.target` + `.testTarget(name: "{{name.snakeCase()}}Tests")`.
   - `Sources/{{name.snakeCase()}}/`:
     - `{{name.pascalCase()}}Plugin.swift` — composition root; `register(with:)` overrides registrar-dependent factories, then registers the Pigeon `HostApi` (`has_ui=false`) or the `PlatformViewFactory` (`has_ui=true`).
     - `{{name.pascalCase()}}Container.swift` — `final class {{name.pascalCase()}}Container: SharedContainer` + `extension` with a `repository` `Factory` defaulting to `{{name.pascalCase()}}DataSource()`.
     - `Platform/{{name.pascalCase()}}HostApiImpl.swift` (`has_ui=false`) / `Platform/{{name.pascalCase()}}PlatformViewFactory.swift` (`has_ui=true`).
     - `Domain/{{name.pascalCase()}}Repository.swift`, `Data/{{name.pascalCase()}}DataSource.swift`.
     - `Presentation/` (only `has_ui=true`): `MviViewModel.swift` (base, copied per plugin), `{{name.pascalCase()}}ViewModel.swift` (`@Injected(\{{name.pascalCase()}}Container.repository)`, no default-arg init), `{{name.pascalCase()}}Action/State/Event.swift`, `{{name.pascalCase()}}View.swift` (SwiftUI), `{{name.pascalCase()}}PlatformView.swift`.
   - Delete the old `ios/{{name.snakeCase()}}.podspec` and `ios/Classes/**` templates.
2. **Pigeon**: `pigeons/{{name}}_messages.dart` `@ConfigurePigeon` `swiftOut` → `ios/{{name}}/Sources/{{name}}/Messages.g.swift`; `dartOut` + Kotlin unchanged.
3. **`hooks/post_gen.dart`**: remove all `.podspec` logic; retarget the `has_ui` cleanup to the new `Sources/{{name}}/...` paths; keep the root `pubspec.yaml` `workspace:` append; keep `melos bootstrap`; add `flutter pub get`.
4. **`brick.yaml`**: vars unchanged (`name`, `has_ui`; the current brick has no `android_package` var — leave as-is).
5. **Brick `README.md`**: state the SPM-only requirement (no `.podspec`; needs an SPM-enabled host), how to add a dependency to `{{Name}}Container`, how to override in tests. Add `.build/`, `.swiftpm/`, `Package.resolved` to the brick's templated `.gitignore`.

## Relevant Files & Context Pointers
- `bricks/pac_native_plugin/brick.yaml`
- `bricks/pac_native_plugin/hooks/post_gen.dart`
- `bricks/pac_native_plugin/__brick__/packages/{{name.snakeCase()}}/ios/` (full rewrite)
- `bricks/pac_native_plugin/__brick__/packages/{{name.snakeCase()}}/pigeons/{{name.snakeCase()}}_messages.dart`
- `bricks/pac_native_plugin/__brick__/packages/{{name.snakeCase()}}/.gitignore`, `README.md`
- `mason.yaml`
- Pattern reference: `packages/logger_native_bridge/` after Task 15; `ios_digital_wallet` `SettingsContainer.swift`
- Mason string helpers: `paramCase`, `pascalCase`, `snakeCase`

## Design Rationale
The brick must emit exactly the pattern Tasks 15–16 establish for hand-written plugins, so generated and shipped plugins are structurally identical. Per-plugin `SharedContainer` (D3), `register(with:)` composition root (D4), `MviViewModel` copied per plugin (D5). SPM-only because FactoryKit 3.x has no CocoaPods spec (D1).
Applicable skills: `test-driven-development`, `writing-skills` (brick authoring conventions), `verification-before-completion`.

## TDD Checklist
- [x] **RED**: `mason make pac_native_plugin --name device_info --has_ui false` against the pre-rewrite brick produced `ios/device_info.podspec` + `ios/Classes/**` (no `Package.swift`, no Container) — the target assertions fail.
- [x] **GREEN**:
  - [x] Rewrote `__brick__/.../ios/` → `ios/{{name}}/Package.swift` + `Sources/{{name}}/{Platform,Domain,Data,Presentation}`; added `{{Name}}Container.swift`, `Platform/{{Name}}HostApiImpl.swift`; closure-based `PlatformViewFactory`; `@Injected(\{{Name}}Container.repository)` in the ViewModel; deleted the podspec template. Rewrote `post_gen.dart` (new `has_ui` cleanup paths, no podspec logic, `flutter pub get`). Pigeon `swiftOut` → `Sources/{{name}}/Messages.g.swift`. `.gitignore` + brick README updated. Added `Tests/{{name}}Tests/{{Name}}ContainerTests.swift`.
  - [x] `mason make pac_native_plugin --name device_info --has_ui false` → generates `ios/device_info/Package.swift` + `Sources/device_info/{DeviceInfoPlugin,DeviceInfoContainer}.swift` + `Platform/DeviceInfoHostApiImpl.swift`, **no `.podspec`**, no `Presentation/`. Temp-added as an app dep → `flutter build ios --simulator --debug` → `✓ Built Runner.app`; `device_info` resolves via SPM (off Flutter's "no SPM" list); FactoryKit + `DeviceInfoContainer` + `@Injected` compile.
  - [x] `mason make pac_native_plugin --name custom_camera --has_ui true` → full SPM layout incl. `Presentation/` + `Platform/CustomCameraPlatformViewFactory.swift`, no `Messages.g.swift`/`HostApiImpl`. Build → `✓ Built Runner.app` after bumping the brick `Package.swift` platform floor to `.iOS("15.0")` (SwiftUI `ProgressView` needs 14+; 15 matches the host).
  - [~] `xcodebuild test` of `{{name}}Tests` — needs an Xcode test host; deferred (proxy verification). The generated test file compiles as part of the resolved SPM graph.
  - Throwaway `device_info` / `custom_camera` deleted; `pubspec.yaml` / `lib/main.dart` temp edits reverted. `flutter analyze` (workspace) + `dart analyze post_gen.dart` → No issues.
- [x] **REFACTOR**: One `Package.swift` template serves both `has_ui` modes (SwiftPM globs `Sources/`); `has_ui` mustache conditionals limited to `Plugin.swift`, `pubspec.yaml`, `lib/{{name}}.dart`, README; the rest is folder-level cleanup in `post_gen`.

## Definition of Done (DoD)
1. `pac_native_plugin` emits an SPM-only iOS layout with a per-plugin FactoryKit `SharedContainer`; no `.podspec` is generated.
2. Both `has_ui` modes generate, build, and run on iOS with DI resolved through the plugin's container.
3. `post_gen.dart` has no podspec logic; runs `flutter pub get`; Pigeon `swiftOut` points into `Sources/`.
4. Brick README documents the SPM-only constraint and the container workflow.

## Dependencies & Blockers
- Blocked by: [Task 13](task_13_enable_flutter_spm_host.md)
- Blocks: [Task 18](task_18_update_pac_add_native_ui_ios_spm.md), [Task 19](task_19_pac_rename_project_package_swift.md)
- Related: best done after [Task 15](task_15_migrate_logger_native_bridge_spm_factorykit.md) lands the reference pattern.

## References & Rollback
- Source Spec: [2026-09-09-ios-native-plugin-factory-di-spm-design.md](../epic/flutter_super_app_template/2026-09-09-ios-native-plugin-factory-di-spm-design.md) §6, §8, verification rows 5–7, 9
- Flutter SPM for plugin authors: https://docs.flutter.dev/packages-and-plugins/swift-package-manager/for-plugin-authors
- Rollback: `git revert` the brick commit — restores the podspec-emitting brick; already-generated plugins are unaffected.
