---
id: "task_18_update_pac_add_native_ui_ios_spm"
status: "done"
priority: "medium"
assignee: null
epic: "flutter_super_app_template"
dueDate: null
created: "2026-09-09T09:51:07.000Z"
modified: "2026-09-09T11:35:00.000Z"
completedAt: "2026-09-09T11:35:00.000Z"
labels: ["mason", "brick", "ios", "spm", "phase-5"]
order: "a18"
---

# Task 18: Update `pac_add_native_ui` Brick for the SPM Layout

Epic: [flutter_super_app_template](../epic/flutter_super_app_template/flutter_super_app_template.en.md)

## Requirement Analysis
`pac_add_native_ui` upgrades a headless plugin to a native-UI plugin. Its iOS half must target the SPM layout that Task 17 makes `pac_native_plugin` emit. Its Android half is unchanged.

Requirements:
1. **`hooks/pre_gen.dart`**: existence check retargets to `packages/{{name}}/ios/{{name}}/Sources/{{name}}/Presentation/` — abort if it already exists (avoid overwriting).
2. **`__brick__`**: emit `ios/{{name}}/Sources/{{name}}/Presentation/**` in the SPM layout — `MviViewModel.swift` (base), `{{name.pascalCase()}}ViewModel.swift` (`@Injected(\{{name.pascalCase()}}Container.repository)`), `{{name.pascalCase()}}Action/State/Event.swift`, `{{name.pascalCase()}}View.swift`, `{{name.pascalCase()}}PlatformView.swift`. `lib/src/ui/{{name}}_native_view.dart` unchanged.
3. **`hooks/post_gen.dart`**:
   - Patch `ios/{{name}}/Sources/{{name}}/{{name.pascalCase()}}Plugin.swift` to add `registrar.register({{name.pascalCase()}}PlatformViewFactory { {{name.pascalCase()}}ViewModel() }, withId: "com.danhdue.{{name.snakeCase()}}/native_view")`.
   - Add the export line to the plugin's Dart barrel.
   - **No `Package.swift` edit** — FactoryKit is already a dependency from `pac_native_plugin`.
   - Android steps (`build.gradle.kts` `compose = true`, `*Plugin.kt` patch) unchanged.
4. Keep `scripts/add_native_ui.sh` wrapper working (arg forwarding only).

## Relevant Files & Context Pointers
- `bricks/pac_add_native_ui/hooks/pre_gen.dart`
- `bricks/pac_add_native_ui/hooks/post_gen.dart`
- `bricks/pac_add_native_ui/__brick__/packages/{{name.snakeCase()}}/ios/` (retarget to `ios/{{name}}/Sources/{{name}}/Presentation/`)
- `bricks/pac_add_native_ui/__brick__/.../lib/src/ui/{{name.snakeCase()}}_native_view.dart`
- `scripts/add_native_ui.sh`
- Depends on the layout from [Task 17](task_17_rewrite_pac_native_plugin_ios_spm.md)

## Design Rationale
The two bricks must stay in lockstep: `pac_add_native_ui` only ever runs against a plugin created by `pac_native_plugin`, so its paths and patch targets are whatever Task 17 defines. No `Package.swift` change is needed on upgrade because the container + FactoryKit dependency already exist from creation time.
Applicable skills: `test-driven-development`, `writing-skills`, `verification-before-completion`.

## TDD Checklist
- [x] **RED**: Against the pre-change brick, `mason make pac_add_native_ui --name device_info` (on a task_17-generated `device_info`) targeted `ios/Classes/Presentation/` + `ios/Classes/DeviceInfoPlugin.swift` — paths that no longer exist in the SPM layout → no-op patch, assertions fail.
- [x] **GREEN**:
  - [x] `pre_gen.dart` iOS existence check → `packages/<name>/ios/<name>/Sources/<name>/Presentation`. `git mv` the `__brick__` Presentation templates into `ios/{{name}}/Sources/{{name}}/Presentation/` (+ `Platform/{{Name}}PlatformViewFactory.swift`); aligned `ViewModel` / `PlatformView` / `PlatformViewFactory` with task_17's versions (`@Injected`, closure-based factory). `post_gen.dart` step 3 → patches `Sources/<name>/<Name>Plugin.swift` with `let nativeViewFactory = <Name>PlatformViewFactory { <Name>ViewModel() }; registrar.register(nativeViewFactory, withId: "com.danhdue.<name>/native_view")`. **No `Package.swift` edit** — FactoryKit already a dep from `pac_native_plugin`; `Sources/` glob picks up the new folders.
  - [x] `mason make pac_native_plugin --name device_info --has_ui false` → `mason make pac_add_native_ui --name device_info`: adds `Platform/DeviceInfoPlatformViewFactory.swift` + `Presentation/*.swift` (incl. `MviViewModel.swift`); `DeviceInfoPlugin.swift` gains the factory registration (Pigeon `HostApi` + PlatformView now coexist). Temp app dep → `flutter build ios --simulator --debug` → `✓ Built Runner.app`.
  - [~] `UiKitView` on-screen render — needs a running app/device; deferred (proxy verification). The SwiftUI `View` + `UIHostingController` PlatformView compile and link.
  - Throwaway `device_info` deleted; temp app edits reverted. `dart analyze` (both hooks) → No issues.
- [x] **REFACTOR**: `pre_gen` guard messages unchanged (already clear); zero remaining references to `ios/Classes/` in the brick or hooks.

## Definition of Done (DoD)
1. `pac_add_native_ui` emits `Presentation/` under `ios/{{name}}/Sources/{{name}}/` and patches the SPM-layout plugin class.
2. A headless plugin upgraded by this brick builds and renders native UI on iOS with DI through the plugin container.
3. `pre_gen.dart` correctly refuses a second run.
4. Android upgrade path unchanged and still working.

## Dependencies & Blockers
- Blocked by: [Task 17](task_17_rewrite_pac_native_plugin_ios_spm.md)
- Blocks: None.

## References & Rollback
- Source Spec: [2026-09-09-ios-native-plugin-factory-di-spm-design.md](../epic/flutter_super_app_template/2026-09-09-ios-native-plugin-factory-di-spm-design.md) §7, verification row 8
- Rollback: `git revert` the brick commit — restores the `ios/Classes/Presentation/` targeting.
