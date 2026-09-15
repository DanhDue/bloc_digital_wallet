---
id: "task_4_pac_native_plugin_android_dagger_workmanager"
status: "done"
priority: "high"
assignee: null
epic: "flutter_super_app_template"
dueDate: null
created: "2026-09-15T13:20:00Z"
modified: "2026-09-15T07:02:24Z"
completedAt: "2026-09-15T07:02:24Z"
labels: ["mason", "android", "dagger2", "workmanager", "compose", "bricks"]
order: "a4"
---

# Task 4: Brick `pac_native_plugin` — Android Pure Dagger 2 & WorkManager

Epic: [flutter_super_app_template](../epic/flutter_super_app_template/flutter_super_app_template.en.md)

## Requirement Analysis
Upgrade the Android portion of the `bricks/pac_native_plugin` Mason template to achieve 100% architectural parity with Android Devbed `:plugin` (`android_digital_wallet`):
1. **Gradle Build Script (`build.gradle.kts`)**:
   - Replace legacy Groovy `build.gradle` with Kotlin DSL `build.gradle.kts`.
   - Configure Kotlin 2.1.0, Android Gradle Plugin (AGP) 8.13+, JDK 21, and KSP (`com.google.devtools.ksp`).
   - When `has_ui == true`, apply the official Compose Compiler Gradle Plugin (`org.jetbrains.kotlin.plugin.compose`) instead of the deprecated `kotlinCompilerExtensionVersion`.
2. **Pure Dagger 2 DI Architecture (Zero Hilt)**:
   - Generate `di/{{name.pascalCase()}}Component.kt` annotated with `@Component`.
   - Generate `di/{{name.pascalCase()}}Module.kt` providing repository and use cases.
   - Generate `di/{{name.pascalCase()}}ComponentProvider.kt` implementing a thread-safe double-checked locking singleton holder accepting Android `Context`.
3. **Zero Flutter Engine Background Execution (WorkManager)**:
   - Generate `data/worker/{{name.pascalCase()}}SyncWorker.kt` extending `CoroutineWorker`.
   - Resolve dependencies via `{{name.pascalCase()}}ComponentProvider.get(applicationContext)`.
   - Execute background tasks without initializing or booting `FlutterEngine`.
4. **Jetpack Compose UI & PlatformView**:
   - When `has_ui == true`, generate `presentation/` with base `ViewContract.kt`, `MviViewModel.kt` (Coroutines `StateFlow` + `Channel`), `{{name.pascalCase()}}Screen.kt`, and `{{name.pascalCase()}}PlatformView.kt` (`ComposeView` embedded into `PlatformView`).
5. **Pigeon IPC**:
   - Generate `pigeons/{{name.snakeCase()}}_messages.dart` and `platform/{{name.pascalCase()}}HostApiImpl.kt` implementing Pigeon interface.
6. **Unit Tests**:
   - Generate unit tests under `android/src/test/kotlin/` verifying DI component, worker execution, and ViewModel state transitions.

## Relevant Files & Context Pointers
- `bricks/pac_native_plugin/brick.yaml`
- `bricks/pac_native_plugin/__brick__/packages/{{name.snakeCase()}}/android/build.gradle` [DELETE/REPLACE]
- `bricks/pac_native_plugin/__brick__/packages/{{name.snakeCase()}}/android/build.gradle.kts` [NEW]
- `bricks/pac_native_plugin/__brick__/packages/{{name.snakeCase()}}/android/src/main/kotlin/com/danhdue/{{name.snakeCase()}}/di/**` [NEW]
- `bricks/pac_native_plugin/__brick__/packages/{{name.snakeCase()}}/android/src/main/kotlin/com/danhdue/{{name.snakeCase()}}/data/worker/**` [NEW]
- `bricks/pac_native_plugin/__brick__/packages/{{name.snakeCase()}}/android/src/main/kotlin/com/danhdue/{{name.snakeCase()}}/presentation/**`
- `bricks/pac_native_plugin/__brick__/packages/{{name.snakeCase()}}/android/src/test/kotlin/com/danhdue/{{name.snakeCase()}}/**` [NEW]
- Reference: `/Users/danhdueexoictif/AllProjects/digital_wallet/android_digital_wallet/plugin/`

## Design Rationale
- **Zero Host Constraint**: Standard Flutter host apps cannot apply the Dagger Hilt Gradle plugin. Using Pure Dagger 2 with KSP keeps the plugin completely self-contained.
- **Resource Optimization**: Running background sync via WorkManager without FlutterEngine saves 150MB+ RAM and prevents OS kill events.
- **Applicable Skills**: `android-ui-audit`, `writing-skills`.

## Impact Analysis & Blast Radius
- **Target Files & Symbols**: `bricks/pac_native_plugin` Android files.
- **Downstream Callers**: All newly generated native plugins in `packages/`.
- **Cross-Platform Bridges**: `Messages.g.kt`, `PlatformViewFactory`.
- **Target Test Coverage Threshold**: 100% compilation pass; $\ge 85\%$ line coverage for generated Kotlin unit tests.

### BDD SCENARIOS

#### Scenario 4.1: [Tier A - Unit] Scaffolding Headless Android Plugin (`has_ui: false`)
```gherkin
When running "mason make pac_native_plugin --name device_monitor --has_ui false"
Then "packages/device_monitor/android/build.gradle.kts" is generated
And "packages/device_monitor/android/src/main/kotlin/.../di/DeviceMonitorComponent.kt" is generated with Pure Dagger 2
And "packages/device_monitor/android/src/main/kotlin/.../data/worker/DeviceMonitorSyncWorker.kt" is generated
And no Compose dependencies or "presentation/" folder are created
And "./gradlew compileDebugKotlin" passes cleanly
```

#### Scenario 4.2: [Tier A - Unit] Scaffolding UI-Enabled Android Plugin (`has_ui: true`)
```gherkin
When running "mason make pac_native_plugin --name custom_scanner --has_ui true"
Then "packages/custom_scanner/android/build.gradle.kts" applies Compose Compiler Plugin
And "presentation/CustomScannerScreen.kt" provides Composable UI
And "presentation/CustomScannerPlatformView.kt" wraps "ComposeView" in "PlatformView"
And "./gradlew compileDebugKotlin" passes with Compose enabled
```

#### Scenario 4.3: [Tier A - Unit] Background Execution without FlutterEngine
```gherkin
Given "DeviceMonitorSyncWorker" triggered by Android WorkManager
When "doWork()" executes in a background thread
Then it resolves "SyncDeviceMonitorDataUseCase" from "DeviceMonitorComponentProvider"
And executes sync logic without instantiating or attaching "FlutterEngine"
And returns "Result.success()"
```

#### Scenario 4.4: [Tier C - Integration] PlatformView Registration in Flutter Host
```gherkin
Given a generated plugin with "has_ui: true"
When the Flutter app launches and renders the plugin widget
Then the Android PlatformViewFactory creates a native PlatformView
And the Jetpack Compose Screen renders on screen without frame drops
```

## Test & Verification Checklist
- [x] **RED**: Assert template failure when Dagger 2 or WorkManager dependencies are missing.
- [x] **GREEN**: Rewrite Android template files in `pac_native_plugin` with Kotlin DSL, Pure Dagger 2, KSP, and WorkManager.
- [x] **REFACTOR**: Validate Kotlin code style, ensure no hardcoded package names, and verify parameter interpolations.
- [x] **Tier C (Integration)**: Run `mason make pac_native_plugin --name test_android_plugin --has_ui true` in a temporary testbed and compile with `./gradlew compileDebugKotlin`.

## Definition of Done (DoD)
- Android plugin templates use Kotlin DSL `build.gradle.kts` and Kotlin 2.1.0.
- Pure Dagger 2 + KSP is used exclusively (zero Hilt).
- WorkManager background worker is fully generated and tested.
- `has_ui` false and true both generate compiling Android modules.

## Dependencies & Blockers
- Independent. Can be developed in parallel with iOS tasks.

## References & Rollback
- References: Spec Section 4, HLD Section 4.
- Rollback: `git checkout HEAD -- bricks/pac_native_plugin/`.
