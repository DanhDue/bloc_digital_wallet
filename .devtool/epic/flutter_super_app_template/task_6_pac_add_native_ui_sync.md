---
id: "task_6_pac_add_native_ui_sync"
status: "done"
priority: "medium"
assignee: null
epic: "flutter_super_app_template"
dueDate: null
created: "2026-09-15T13:20:00Z"
modified: "2026-09-15T09:50:46Z"
completedAt: "2026-09-15T09:50:46Z"
labels: ["mason", "tooling", "ui-upgrade", "compose", "swiftui", "bricks"]
order: "a6"
---

# Task 6: Brick `pac_add_native_ui` Synchronization

Epic: [flutter_super_app_template](flutter_super_app_template.en.md)

## Requirement Analysis
Update `bricks/pac_add_native_ui` and `scripts/add_native_ui.sh` to ensure a one-touch upgrade from a headless native package to a UI-enabled package while strictly preserving existing Pure Dagger 2, FactoryKit, and background workers:
1. **Pre-Gen Validation (`hooks/pre_gen.dart`)**:
   - Verify `packages/{{name}}/` exists.
   - Verify `packages/{{name}}/android/src/main/kotlin/.../presentation` does not already exist.
   - Verify `packages/{{name}}/ios/{{name}}/Sources/{{name}}/Presentation` does not already exist.
2. **Android UI Injection**:
   - Emit `presentation/` containing Base `MviViewModel.kt`, `ViewContract.kt`, Compose Screen, ViewModel, and PlatformView.
   - Inject Jetpack Compose dependencies and `id("org.jetbrains.kotlin.plugin.compose")` into `android/build.gradle.kts`.
   - Patch `*Plugin.kt` to register `PlatformViewFactory`.
   - **Preserve**: `di/` (Pure Dagger 2) and `data/worker/` (WorkManager) without any modifications or deletions.
3. **iOS UI Injection**:
   - Emit `ios/{{name}}/Sources/{{name}}/Presentation/` containing SwiftUI View, Combine MVI ViewModel, and PlatformView.
   - Emit `ios/{{name}}/Sources/{{name}}/Platform/{{name.pascalCase()}}PlatformViewFactory.swift`.
   - Patch `Sources/{{name}}/{{name.pascalCase()}}Plugin.swift` to register PlatformViewFactory.
   - **Preserve**: `{{name.pascalCase()}}Container.swift` and `Data/Background/{{name.pascalCase()}}SyncTask.swift`.
4. **Dart Public Export**:
   - Emit `lib/src/ui/{{name.snakeCase()}}_native_view.dart` (AndroidView/UiKitView wrapper).
   - Export view widget in `lib/{{name.snakeCase()}}.dart`.

## Relevant Files & Context Pointers
- `bricks/pac_add_native_ui/brick.yaml`
- `bricks/pac_add_native_ui/hooks/pre_gen.dart`
- `bricks/pac_add_native_ui/hooks/post_gen.dart`
- `bricks/pac_add_native_ui/__brick__/**`
- `scripts/add_native_ui.sh`
- Reference: Android `bricks/add_native_ui` and iOS `bricks/ios_add_native_ui`.

## Design Rationale
- **Non-Destructive In-Place Upgrade**: Upgrading headless plugins to have native UI must never disturb established business domain rules, repositories, DI containers, or background workers.
- **Surgical Code Patching**: `post_gen.dart` uses exact anchors in `*Plugin.kt` and `*Plugin.swift` to inject registration lines.
- **Applicable Skills**: `writing-skills`, `flutter-ui-audit`.

## Impact Analysis & Blast Radius
- **Target Files & Symbols**: `bricks/pac_add_native_ui/**`, `scripts/add_native_ui.sh`.
- **Downstream Callers**: Developer feature evolution workflow.
- **Cross-Platform Bridges**: Injects `PlatformViewFactory` into both Android and iOS plugin lifecycles.
- **Target Test Coverage Threshold**: 100% pass rate on headless-to-UI upgrade test suite.

### BDD SCENARIOS

#### Scenario 6.1: [Tier A - Unit] Upgrade Headless Plugin to UI (Happy Path)
```gherkin
Given a headless plugin "packages/sensor_kit" with Pure Dagger 2 and WorkManager
When running "mason make pac_add_native_ui --name sensor_kit"
Then Android "presentation/" is added with Jetpack Compose Screen
And Android "build.gradle.kts" enables Compose
And iOS "Presentation/" is added with SwiftUI View
And existing Dagger 2 DI and WorkManager files are 100% intact
And existing FactoryKit container and BGTaskScheduler files are 100% intact
And the upgraded plugin compiles on both Android and iOS
```

#### Scenario 6.2: [Tier A - Unit] Reject Upgrade when Presentation Already Exists
```gherkin
Given a plugin "packages/sensor_kit" that already has "presentation/"
When running "mason make pac_add_native_ui --name sensor_kit"
Then "pre_gen.dart" aborts with error "Presentation layer already exists in sensor_kit"
And no files are altered
```

#### Scenario 6.3: [Tier C - Integration] Render Native View in Flutter Widget Tree
```gherkin
Given an upgraded plugin "packages/sensor_kit"
When mounting "SensorKitNativeView()" in a Flutter widget test
Then on Android it renders an "AndroidView"
And on iOS it renders an "UiKitView"
And no platform view channel mismatch occurs
```

## Test & Verification Checklist
- [x] **RED**: Create a mock headless plugin and verify upgrade failure if post_gen corrupts gradle or plugin files.
- [x] **GREEN**: Implement updated `pac_add_native_ui` templates and hooks matching Kotlin 2.1 and SPM.
- [x] **REFACTOR**: Validate idempotency and clean formatting.
- [x] **Tier C (Integration)**: Run `mason make pac_native_plugin --name test_up --has_ui false` followed by `mason make pac_add_native_ui --name test_up` and assert clean compilation.

## Definition of Done (DoD)
- `pac_add_native_ui` upgrades a headless plugin without mutating Domain, Data, DI, or Workers.
- Android `build.gradle.kts` and iOS `*Plugin.swift` are properly patched.
- `scripts/add_native_ui.sh` provides a convenient wrapper.

## Dependencies & Blockers
- Blocked by [Task 4](task_4_pac_native_plugin_android_dagger_workmanager.md) and [Task 5](task_5_pac_native_plugin_ios_bgtask.md).

## References & Rollback
- References: Spec Section 6.2, HLD Section 4.
- Rollback: `git checkout HEAD -- bricks/pac_add_native_ui/ scripts/add_native_ui.sh`.
