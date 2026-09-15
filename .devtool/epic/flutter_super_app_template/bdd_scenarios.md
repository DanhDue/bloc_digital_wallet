# Living BDD Scenarios — Dual-Mode Flutter Super App Template & Native SDKs

## Metadata
- **Epic**: `flutter_super_app_template`
- **Target Platform**: Flutter, Android Native, iOS Native
- **Source Spec**: [2026-09-15-dual-mode-and-native-sdk-upgrade-design.md](2026-09-15-dual-mode-and-native-sdk-upgrade-design.md)
- **Status**: Stage 2 (Design & Specification)

---

## Feature 1: Dual-Mode Host Configuration (`configure_mode.sh`)

### Scenario 1.1: Switch from Enterprise to Lean Mode (Non-Prune)
```gherkin
Given a Flutter Super App host configured in "enterprise" mode with 3 tabs
When the developer runs "./scripts/configure_mode.sh lean"
Then "lib/shell/shell_page.dart" comments out the Scanner tab marker region
And "lib/shell/shell_page.dart" sets the total tab count to 2
And "lib/app_router.dart" comments out the Scanner route marker regions
And "lib/di/injection.dart" comments out the Scanner DI registration
And "packages/platform/lib/deeplink/deep_link_registry.dart" unhooks the Scanner deep link
And the directory "features/scanner" remains untouched on disk
And "melos bootstrap" and "melos run analyze" pass cleanly with zero errors
```

### Scenario 1.2: Round-Trip Switch from Lean Back to Enterprise Mode
```gherkin
Given a Flutter Super App host currently in "lean" mode
When the developer runs "./scripts/configure_mode.sh enterprise"
Then all commented marker regions in "shell_page.dart", "app_router.dart", "injection.dart", and "deep_link_registry.dart" are uncommented
And the Shell navigation bar restores 3 tabs: Home (0), Scanner (1), and Settings (2)
And the app builds successfully and passes all 3-tab integration tests
```

### Scenario 1.3: Switch to Lean Mode with Prune (`--prune`)
```gherkin
Given a clean git status in the repository
When the developer runs "./scripts/configure_mode.sh lean --prune"
Then the project is configured into "lean" mode
And the directory "features/scanner" is permanently removed from the workspace
And "features/scanner" is removed from "pubspec.yaml" and "melos.yaml"
And "melos bootstrap" and "melos run analyze" pass with zero missing package references
```

### Scenario 1.4: Abort Prune on Dirty Working Tree
```gherkin
Given uncommitted or untracked changes in the working directory
When the developer runs "./scripts/configure_mode.sh lean --prune" without "--force"
Then the script aborts immediately with an actionable error message
And no files or directories are deleted from disk
```

---

## Feature 2: Shell Navigation & Deep Linking Parity

### Scenario 2.1: Default Tab on Cold Start (Enterprise Mode)
```gherkin
Given the app launches in "enterprise" mode
When cold start finishes
Then the active tab displayed is "Settings" (tab index 2)
And bottom navigation bar displays 3 destinations: Home, Scanner, Settings
```

### Scenario 2.2: Default Tab on Cold Start (Lean Mode)
```gherkin
Given the app launches in "lean" mode
When cold start finishes
Then the active tab displayed is "Settings" (tab index 1)
And bottom navigation bar displays 2 destinations: Home and Settings
```

### Scenario 2.3: Deep Link Resolution in Lean Mode
```gherkin
Given the app is running in "lean" mode
When an external deep link "blocwallet://app/settings" is received
Then the deep link navigator routes directly to the Settings screen
When an external deep link "blocwallet://app/scanner" is received
Then the deep link registry ignores or handles as an unsupported route without crashing
```

---

## Feature 3: Android Native Plugin Architecture (Pure Dagger 2 & WorkManager)

### Scenario 3.1: Scaffold Headless Plugin with Pure Dagger 2 (`has_ui: false`)
```gherkin
When the developer runs "mason make pac_native_plugin --name device_monitor --has_ui false"
Then "packages/device_monitor/android/build.gradle.kts" is generated with Kotlin 2.1.0, KSP, and Java 21
And "packages/device_monitor/android/src/main/kotlin/.../di/" contains "DeviceMonitorComponent.kt" and "DeviceMonitorComponentProvider.kt"
And no Dagger Hilt annotations or plugins are present
And "packages/device_monitor/android/src/main/kotlin/.../data/worker/DeviceMonitorSyncWorker.kt" is generated extending "CoroutineWorker"
And the generated Android package compiles successfully with "./gradlew compileDebugKotlin"
```

### Scenario 3.2: Scaffold UI-Enabled Plugin with Jetpack Compose (`has_ui: true`)
```gherkin
When the developer runs "mason make pac_native_plugin --name custom_camera --has_ui true"
Then "packages/custom_camera/android/build.gradle.kts" applies "org.jetbrains.kotlin.plugin.compose"
And "packages/custom_camera/android/src/main/kotlin/.../presentation/" contains:
  | File | Purpose |
  | CustomCameraScreen.kt | Jetpack Compose Composable UI |
  | CustomCameraViewModel.kt | Coroutines StateFlow MviViewModel |
  | CustomCameraPlatformView.kt | ComposeView wrapped in PlatformView |
  | CustomCameraPlatformViewFactory.kt | Flutter PlatformViewFactory |
And "packages/custom_camera/lib/src/ui/custom_camera_native_view.dart" provides the Flutter AndroidView wrapper
```

### Scenario 3.3: Android Background Sync Without Flutter Engine
```gherkin
Given the Android host application is killed by the OS or in background
When WorkManager triggers "DeviceMonitorSyncWorker"
Then the worker obtains its use case via "DeviceMonitorComponentProvider.get(context)"
And the synchronization logic executes purely in Kotlin Coroutines
And no "FlutterEngine" instance is initialized in memory
```

---

## Feature 4: iOS Native Plugin Architecture (FactoryKit 3.3.2 & BGTaskScheduler)

### Scenario 4.1: Scaffold Headless Plugin with Flutter SPM (`has_ui: false`)
```gherkin
When the developer runs "mason make pac_native_plugin --name device_monitor --has_ui false"
Then "packages/device_monitor/ios/device_monitor/Package.swift" is generated targeting iOS 15
And the package declares dependency on "Factory" exact version "3.3.2" (FactoryKit)
And "packages/device_monitor/ios/device_monitor/Sources/device_monitor/DeviceMonitorContainer.swift" defines a dedicated "SharedContainer" subclass
And "packages/device_monitor/ios/device_monitor/Sources/device_monitor/Data/Background/DeviceMonitorSyncTask.swift" registers with "BGTaskScheduler"
And no CocoaPods ".podspec" file is created
```

### Scenario 4.2: Scaffold UI-Enabled Plugin with SwiftUI (`has_ui: true`)
```gherkin
When the developer runs "mason make pac_native_plugin --name custom_camera --has_ui true"
Then "packages/custom_camera/ios/custom_camera/Sources/custom_camera/Presentation/" contains:
  | File | Purpose |
  | CustomCameraView.swift | SwiftUI View |
  | CustomCameraViewModel.swift | Combine @Published MviViewModel |
  | CustomCameraPlatformView.swift | UIHostingController wrapped in FlutterPlatformView |
And "packages/custom_camera/lib/src/ui/custom_camera_native_view.dart" provides the Flutter UiKitView wrapper
```

### Scenario 4.3: iOS Background Sync Without Flutter Engine
```gherkin
Given the iOS host application is suspended or terminated
When "BGTaskScheduler" triggers the task with identifier "com.danhdue.device_monitor.sync"
Then the handler executes using "DeviceMonitorContainer.shared.syncUseCase()"
And the task reports completion without booting a headless "FlutterEngine"
```

---

## Feature 5: One-Click Native UI Upgrade (`pac_add_native_ui`)

### Scenario 5.1: Upgrade Existing Headless Plugin to UI
```gherkin
Given an existing headless plugin "packages/device_monitor" with Domain, Data, Workers, and DI
When the developer runs "mason make pac_add_native_ui --name device_monitor"
Then Android "presentation/" is generated with Compose Screen, ViewModel, and PlatformView
And Android "build.gradle.kts" is patched with Compose compiler plugin
And iOS "Sources/device_monitor/Presentation/" is generated with SwiftUI View and PlatformView
And existing Dagger 2 components and FactoryKit containers remain intact
And existing "DeviceMonitorSyncWorker" and "DeviceMonitorSyncTask" remain intact
And the upgraded plugin builds cleanly on both Android and iOS
```

---

## Feature 6: Template Cloning & Renaming (`rename_project.sh`)

### Scenario 6.1: Rename Template with Lean Mode
```gherkin
When the developer runs "./scripts/rename_project.sh 'FinTechApp' fintech_app com.fintech.app --mode lean"
Then all package names, bundle IDs, and imports are renamed to "fintech_app" and "com.fintech.app"
And the internal vendor plugin namespaces "com.danhdue.*" remain preserved
And the project is configured into "lean" mode (2-tab Shell, scanner unhooked)
And "melos bootstrap && melos run analyze" completes with 0 errors
And the application compiles successfully for Android APK and iOS Runner
```
