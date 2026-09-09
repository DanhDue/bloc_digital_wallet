# Epic: Flutter Super App Template & Unified Mason Bricks

## Table of Contents
1. [Meta Data](#meta-data)
2. [Background](#background)
3. [Goals & Non-Goals](#goals--non-goals)
4. [Architecture & Technical Design](#architecture--technical-design)
   - [High-Level Architecture](#high-level-architecture)
   - [Use Cases](#use-cases)
   - [Sequence Diagram](#sequence-diagram)
5. [Rollout Strategy & Mitigation](#rollout-strategy--mitigation)
6. [Kanban Tasks Breakdown](#kanban-tasks-breakdown)

---

## Meta Data
- **Epic**: `flutter_super_app_template`
- **Status**: In-Progress (Phase 5: iOS DI → FactoryKit + Flutter SPM)
- **Target Release**: Flutter Super App Template v1.0
- **Source Spec**: [2026-09-06-flutter-super-app-template-design.md](2026-09-06-flutter-super-app-template-design.md)
- **Phase 5 Spec**: [2026-09-09-ios-native-plugin-factory-di-spm-design.md](2026-09-09-ios-native-plugin-factory-di-spm-design.md)
- **Reference Native Templates**:
  - Android: `/Users/danhdue/AllProjects/digital_wallet/android_digital_wallet/.worktrees/android_super_app_template`
  - iOS: `/Users/danhdue/AllProjects/digital_wallet/iOSDigitalWallet/.worktrees/ios_super_app_template`

---

## Background
The `bloc_digital_wallet` repository is a Flutter monorepo managed with Melos, employing Clean Architecture + MVI. Previously, all packages (core infrastructure, utilities, native bridges, and business mini-apps) were located in a single flat `packages/` directory. Furthermore, previous draft specifications attempted to extract standalone Android native apps directly from the Flutter repository.

Because two production-grade native super-app templates already exist independently (`android_super_app_template` and `ios_super_app_template`), the goal is now re-focused:
1. Re-architect `bloc_digital_wallet` into a reusable **Flutter Super App Template** by separating `packages/` (infrastructure, utilities, and native bridge plugins) from `features/` (mini-apps), achieving 100% architectural parity across Android, iOS, and Flutter.
2. Develop a clean suite of Mason bricks to generate features, libraries, and native-integrated packages (supporting both headless/no-UI and native-UI with Compose/SwiftUI + MVI).
3. Provide a one-click UI upgrade mechanism (`pac_add_native_ui` / `scripts/add_native_ui.sh`) to transition headless native packages to UI-enabled packages.
4. Remove legacy attempts to generate standalone native apps from Flutter.

---

## Goals & Non-Goals

### Goals
- **Tri-Platform Monorepo Parity**: Structure repository into `packages/` (infrastructure) and `features/` (mini-apps), mirroring the conventions of `android_super_app_template` and `ios_super_app_template`.
- **Streamlined Template Package Inventory**: Retain 8 infrastructure packages in `packages/` (`core`, `framework`, `network`, `ui_kit`, `platform`, `logger`, `logger_native_bridge`, `native_security`), 1 complete feature sample (`features/settings`), and 1 minimal scaffold feature (`features/scanner`). Purge wallet-specific domain packages (`wallet`, `transaction`, `trends`, `authentication`, `onboard`).
- **Shell Reconstitution**: Shell 3 tabs (`Home` stub, `Scanner`, `Settings`), defaulting to Settings tab, bypassing custom onboarding splash.
- **Mason Bricks Suite**:
  - `pac_mvi_feature`: Scaffolds pure-Dart feature packages in `features/{{name}}/`, auto-wiring into DI, AutoRoute, and `platform`'s `DeepLinkRoutes`.
  - `pac_library`: Scaffolds internal utility/infrastructure packages in `packages/{{name}}/`.
  - `pac_native_plugin`: Scaffolds Flutter plugins in `packages/{{name}}/` with Android (Kotlin) and iOS (Swift) Clean Architecture (`Platform/Domain/Data/Presentation`). Supports Pigeon for headless mode (`has_ui: false`) and Jetpack Compose/SwiftUI + self-contained `MviViewModel` via PlatformView for UI mode (`has_ui: true`).
  - `pac_add_native_ui` & `scripts/add_native_ui.sh`: Enables one-click upgrade from headless to UI-enabled native package without destroying existing logic.
- **Project Renaming Tool**: Ship `scripts/rename_project.sh` to automate app cloning, renaming bundle IDs, packages, and imports while preserving vendor plugin namespaces (`com.danhdue.*`).
- **CI Governance Gate**: Update `scripts/check_module_boundaries.sh` to enforce boundary rules between `features/*` and `packages/*`.
- **iOS DI Standardization (Phase 5)**: Every iOS-native package — the two shipped plugins (`logger_native_bridge`, `native_security`) and everything `pac_native_plugin` generates — uses **FactoryKit 3.x** with **one per-plugin `SharedContainer` subclass** (`register(with:)` as the composition root), delivered via **Flutter Swift Package Manager** (`Package.swift`, no `.podspec`). The host enables SPM and runs hybrid with CocoaPods.

### Non-Goals
- Generating or extracting standalone Android/iOS native applications from the Flutter codebase (handled by the two independent native repositories).
- Rewriting runtime dynamic feature module loaders (Flutter packages are compiled into a unified binary).
- Replacing `auto_route` or `get_it`.
- **Removing CocoaPods entirely from the iOS host** — deferred to a separate Phase 2 spec; Phase 5 stays hybrid (third-party pods without SPM keep resolving via CocoaPods).
- **Changing the Dart side of plugins or Android DI** — Phase 5 is iOS-native Swift only.

---

## Architecture & Technical Design

### High-Level Architecture
```mermaid
graph TD
    subgraph HostApp ["Flutter Super App Host (lib/)"]
        ShellPage["ShellPage (3 Tabs: Home, Scanner, Settings)"]
        AppRouter["AppRouter (AutoRoute)"]
        DI["AppInjection (GetIt)"]
    end

    subgraph Features ["features/ (Mini-Apps / Features)"]
        Settings["features/settings (Real Sample)"]
        Scanner["features/scanner (Empty Sample)"]
        NewFeature["features/{{name}} (via pac_mvi_feature)"]
    end

    subgraph PlatformPkg ["packages/platform (Governance)"]
        DeepLink["DeepLinkRoutes (Decoupled Navigation)"]
        EventBus["AppEventBus (Decoupled Events)"]
    end

    subgraph InfraPkgs ["packages/ (Core & Infrastructure)"]
        Core["packages/core"]
        Framework["packages/framework (MviBloc)"]
        Network["packages/network (Dio/Retrofit)"]
        UIKit["packages/ui_kit (Design System)"]
        Logger["packages/logger"]
    end

    subgraph NativePlugins ["packages/ (Native Bridges & Plugins) — Flutter SPM + FactoryKit DI"]
        NativeSec["packages/native_security (FFI + NativeSecurityContainer)"]
        NativeLog["packages/logger_native_bridge (Pigeon + LoggerNativeBridgeContainer)"]
        NewPlugin["packages/{{plugin}} (via pac_native_plugin — Package.swift + {{Plugin}}Container)"]
    end

    ShellPage --> Features
    AppRouter --> Features
    DI --> Features
    Features --> PlatformPkg
    Features --> InfraPkgs
    NativePlugins --> Core
    NewPlugin -.->|PlatformView (UI) or Pigeon (No-UI)| HostApp
    NativePlugins -.->|resolved via Flutter SwiftPM, hybrid with CocoaPods| HostApp
```

### Use Cases
```mermaid
flowchart TD
    Dev["Developer"] --> U1["Scaffold new Mini-App Feature"]
    Dev --> U2["Scaffold internal Dart/Flutter library"]
    Dev --> U3["Scaffold Native Plugin (Headless / With-UI)"]
    Dev --> U4["Upgrade Headless Plugin to With-UI"]
    Dev --> U5["Clone Template & Rename App"]

    U1 -->|Runs| B1["mason make pac_mvi_feature --name <name>"]
    B1 --> O1["Outputs to features/<name>/ & wires DI/Router/DeepLink"]

    U2 -->|Runs| B2["mason make pac_library --name <name>"]
    B2 --> O2["Outputs to packages/<name>/ & adds to workspace"]

    U3 -->|Runs| B3["mason make pac_native_plugin --name <name> --has_ui <bool>"]
    B3 --> O3["Outputs to packages/<name>/ · Kotlin Clean Arch · iOS = Package.swift + Sources/<name>/ + FactoryKit per-plugin Container"]

    U4 -->|Runs| B4["mason make pac_add_native_ui --name <name>"]
    B4 --> O4["Injects Compose (Android) + SwiftUI PlatformView into ios/<name>/Sources/<name>/Presentation/ via Mason Hooks"]

    U5 -->|Runs| S1["mason make pac_rename_project (or ./scripts/rename_project.sh)"]
    S1 --> O5["Full cross-platform renaming via Mason Dart Hook & validated with melos genAlls"]
```

### Sequence Diagram
```mermaid
sequenceDiagram
    autonumber
    actor Dev as Developer
    participant Mason as Mason CLI (pac_add_native_ui)
    participant HookPre as Hook pre_gen.dart
    participant PluginDir as packages/<name>/
    participant Android as Android Source
    participant iOS as iOS Source
    participant Dart as Dart Barrel & UI
    participant HookPost as Hook post_gen.dart

    Dev->>Mason: mason make pac_add_native_ui --name <name>
    Mason->>HookPre: Run initial validations
    HookPre->>PluginDir: Verify packages/<name> exists & presentation/ is absent
    Mason->>Android: Enable Compose in build.gradle.kts
    Mason->>Android: Scaffold presentation/ (MviViewModel.kt, Screen.kt, PlatformView.kt)
    Mason->>iOS: Scaffold ios/<name>/Sources/<name>/Presentation/ (MviViewModel.swift, View.swift, PlatformView.swift)
    Mason->>Dart: Generate lib/src/ui/<name>_native_view.dart (AndroidView/UiKitView)
    Mason->>HookPre: Verify ios/<name>/Sources/<name>/Presentation/ is absent
    Mason->>HookPost: Finalize and patch source code
    HookPost->>Android: Patch *Plugin.kt to register PlatformViewFactory
    HookPost->>iOS: Patch Sources/<name>/<Name>Plugin.swift to register FlutterPlatformViewFactory (Container already has FactoryKit)
    HookPost->>Dart: Export view widget in lib/<name>.dart
    Mason-->>Dev: Upgrade complete 100% via Mason (Ready for Compose & SwiftUI development)
```

---

## Rollout Strategy & Mitigation

### Phased Migration
1. **Phase 1 (Directory Migration)**: Move `packages/settings` and `packages/scanner` to `features/`. Update `melos.yaml`, root `pubspec.yaml`, and relative path imports. Validate `melos bootstrap` and `melos genAlls`.
2. **Phase 2 (Bricks Suite)**: Build and test `pac_mvi_feature`, `pac_library`, `pac_native_plugin`, `pac_add_native_ui`, and `pac_rename_project`. Verify output against existing code standards.
3. **Phase 3 (Template Trimming)**: Remove obsolete wallet domain packages, rebuild Shell 3 tabs, clean assets, update boundary scripts.
4. **Phase 4 (Validation & Renaming)**: Execute `mason make pac_rename_project` on an isolated branch, verifying compilation across Android and iOS.
5. **Phase 5 (iOS DI → FactoryKit + Flutter SPM)**: Enable Flutter SPM on the host (hybrid with CocoaPods). A spike (`task_14`) first de-risks the `native_security` mixed C/C++/Swift target under release dead-strip. Then migrate `logger_native_bridge` and `native_security` from `.podspec` to `Package.swift` + FactoryKit per-plugin `SharedContainer`, and rewrite the iOS side of `pac_native_plugin` / `pac_add_native_ui` to the SPM layout. `pac_rename_project` learns `Package.swift` tokens. **Phase 2 (full CocoaPods removal from the host) is out of scope — a separate future spec.**

### Risks & Mitigations
- **Relative Path Breakages during Restructuring**: Moving features from `packages/` to `features/` changes relative import depth to `../../packages/*`. Mitigation: Validate with `dart analyze` and `melos run analyze`.
- **Pigeon Version Alignment**: Conflicting analyzer constraints when using newer Pigeon releases. Mitigation: Keep Pigeon pinned to compatible workspace ceiling (`26.3.2`).
- **Vendor Plugin Breakage on Rename**: Renaming native plugins could break FFI/MethodChannel bindings. Mitigation: Lock `com.danhdue.*` namespaces in `pac_rename_project` hook.
- **SPM ffiPlugin symbol reachability (`native_security`)**: A SwiftPM static-library target lets the linker drop an unreferenced C archive member, so `DynamicLibrary.executable()`/`.process()` can't find the FFI symbols. **`task_14` spike (2026-09-09): resolved — verdict GO.** Fix = a `__attribute__((constructor))` anchor in the C TU (plus the existing `((used))` attrs and the `register(with:)` force-reference); verified surviving a `--release` build's dead-strip via `nm` on `Release-iphoneos/Runner.app/Runner`. Fallback (keep `native_security` on `.podspec`, fold into Phase 2) no longer needed.
- **Factory 3.x is SPM-only**: No CocoaPods spec, so generated plugins are SPM-only and unusable by a non-SPM host. Mitigation: the template host has SPM enabled; documented in the brick README.

---

## Kanban Tasks Breakdown

| Task ID | Task Title | Scope & Target Files |
|---|---|---|
| [Task 1](task_1_monorepo_restructuring.md) | Monorepo Directory Restructuring (Tri-Platform Parity) | Separate `packages/` and `features/`, move `settings` and `scanner`, update `melos.yaml` and workspace root. |
| [Task 2](task_2_pac_mvi_feature_brick.md) | Brick `pac_mvi_feature` Update | Target `features/{{name}}`, anchor to `settings`, update hooks and companion bricks. |
| [Task 3](task_3_pac_library_brick.md) | Brick `pac_library` Creation | Target `packages/{{name}}`, pure Dart/Flutter library scaffolding and workspace registration. |
| [Task 4](task_4_pac_native_plugin_brick.md) | Brick `pac_native_plugin` Creation | Android (Kotlin) & iOS (Swift) Clean Arch; Pigeon for headless, Compose/SwiftUI + MviViewModel for UI. |
| [Task 5](task_5_pac_add_native_ui_tool.md) | Brick `pac_add_native_ui` Creation | One-click headless to UI upgrade via Mason hooks (pre_gen/post_gen), patching Gradle, Kotlin, Swift, Dart. |
| [Task 6](task_6_template_trimming_and_shell.md) | Template Trimming & Shell Reconstitution | Purge wallet packages, rebuild Shell 3 tabs (Home stub, Scanner, Settings), clean assets, update CI gate. |
| [Task 7](task_7_obsolete_cleanups.md) | Obsolete Bricks & Standalone Scripts Cleanup | Remove legacy `sample`, `test_brick`, `native_feature_module`, and standalone extraction scripts. |
| [Task 8](task_8_rename_project_brick_and_validation.md) | Brick `pac_rename_project` & Full Validation | Implement `pac_rename_project` (cross-platform Dart hook) + wrapper script, test clone/rename, run `melos genAlls`, build APK and iOS Runner. |

### Phase 5 — iOS DI → FactoryKit + Flutter SPM ([spec](2026-09-09-ios-native-plugin-factory-di-spm-design.md))

| Task ID | Task Title | Scope & Target Files |
|---|---|---|
| [Task 13](task_13_enable_flutter_spm_host.md) | Enable Flutter SPM on the host (hybrid) | `flutter config --enable-swift-package-manager`, commit the one-time `ios/Runner.xcodeproj` SPM migration, update CI/setup docs, verify build with existing pods still resolving. |
| [Task 14](task_14_spike_native_security_spm_ffi.md) | Spike — `native_security` mixed C/C++/Swift as a Flutter SPM ffiPlugin | Throwaway spike: mixed-language `Package.swift` builds in **release** (dead-strip on) and `getSslPin1()` resolves from Dart on a real device. Output = go/no-go + approach or podspec fallback. |
| [Task 15](task_15_migrate_logger_native_bridge_spm_factorykit.md) | Migrate `logger_native_bridge` → SPM + FactoryKit | `.podspec` → `ios/logger_native_bridge/Package.swift`, sources → `Sources/`, `LoggerNativeBridgeContainer: SharedContainer`, move Pigeon `swiftOut`, port Swift tests to container overrides. |
| [Task 16](task_16_migrate_native_security_spm_factorykit.md) | Migrate `native_security` → SPM + FactoryKit | `.podspec` → `Package.swift` (C/C++ target + Swift target + module map), `NativeSecurityContainer`, FFI symbol reachability, `logger_native_bridge` via `.package(path:)`, tests + secure-storage smoke. Blocked by 14, 15. |
| [Task 17](task_17_rewrite_pac_native_plugin_ios_spm.md) | Rewrite `pac_native_plugin` brick — iOS side | New `__brick__` SPM layout (`ios/{{name}}/Package.swift` + `Sources/{{name}}/…`), `{{Name}}Container.swift`, `@Injected` consumers, `register(with:)` composition root, both `has_ui` modes, drop podspec template, rewrite `post_gen.dart`, brick README + `.gitignore`. Blocked by 13. |
| [Task 18](task_18_update_pac_add_native_ui_ios_spm.md) | Update `pac_add_native_ui` brick for the SPM layout | `pre_gen` path check → `ios/{{name}}/Sources/{{name}}/Presentation/`, `__brick__` emits `Presentation/` under `Sources/`, `post_gen` patches the SPM-layout `*Plugin.swift`, barrel export. Blocked by 17. |
| [Task 19](task_19_pac_rename_project_package_swift.md) | `pac_rename_project` — handle `Package.swift` tokens | Rewrite `name` / library-product tokens for every SPM plugin (generated + the two migrated), preserve `com.danhdue.*`, validate rename on a clone + iOS build. Blocked by 15, 16, 17. |
| [Task 20](task_20_phase5_docs_sync.md) | Docs sync — spec §4.3/§4.4/§8 + HLD + design doc | Reflect SPM + FactoryKit per-plugin container in `2026-09-06-…-design.md`, refresh epic HLD diagrams/Kanban, record Phase 5 done / Phase 2 deferred. After 15–19. |

