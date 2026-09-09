---
id: "task_18_update_pac_add_native_ui_ios_spm"
status: "todo"
priority: "medium"
assignee: null
epic: "flutter_super_app_template"
dueDate: null
created: "2026-09-09T09:51:07.000Z"
modified: "2026-09-09T09:51:07.000Z"
completedAt: null
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
- [ ] **RED**: Generation test — after `mason make pac_native_plugin --name device_info --has_ui false` then `mason make pac_add_native_ui --name device_info`, assert `ios/device_info/Sources/device_info/Presentation/DeviceInfoViewModel.swift` exists and `DeviceInfoPlugin.swift` contains the `PlatformViewFactory` registration. Fails against the current brick.
- [ ] **GREEN**:
  - [ ] Retarget `pre_gen.dart` path check; move `__brick__` Presentation templates into the SPM path; update `post_gen.dart` patch target.
  - [ ] Run the upgrade on a freshly generated `device_info`; `flutter build ios --no-codesign` → the `UiKitView` renders the SwiftUI view; `ViewModel` resolves via the container.
- [ ] **REFACTOR**: Ensure `pre_gen` guard message is clear; no dangling references to the old `ios/Classes/Presentation/` path.

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
