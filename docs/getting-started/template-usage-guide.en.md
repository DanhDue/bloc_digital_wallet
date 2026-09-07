# Template Usage Guide

A practical, use-case-driven guide — each section is one concrete task you want to accomplish, with the exact commands and architectural pointers. Read [flutter_super_app_template](../../.devtool/epic/flutter_super_app_template/flutter_super_app_template.en.md) for the monorepo architecture overview.

> **Architecture Note**: Standalone native templates (pure Android / pure iOS apps without Flutter) are now maintained in their own dedicated repositories. Inside this Flutter Super App repository, native capabilities are provided through Tri-Platform plugins (`pac_native_plugin`) and shared libraries (`pac_library`).

---

## Table of Contents
0. [Start a new project from the template](#0-start-a-new-project-from-the-template)
1. [Create a new Flutter Feature (`features/`)](#1-create-a-new-flutter-feature-features)
2. [Create a shared Library (`packages/`)](#2-create-a-shared-library-packages)
3. [Create a Native Plugin without UI (Headless Pigeon)](#3-create-a-native-plugin-without-ui-headless-pigeon)
4. [Create a Native Plugin with UI (Compose & SwiftUI)](#4-create-a-native-plugin-with-ui-compose--swiftui)
5. [Upgrade a headless Plugin to include Native UI](#5-upgrade-a-headless-plugin-to-include-native-ui)
6. [Create a Subfeature within an existing Feature](#6-create-a-subfeature-within-an-existing-feature)
7. [Add a Go binding to a native package](#7-add-a-go-binding-to-a-native-package)
8. [Remove a feature package](#8-remove-a-feature-package)

---

## 0. Start a new project from the template

The mandatory first step when starting fresh from the template.
> 📖 **Read the comprehensive step-by-step guide:** [create-new-project-from-template.en.md](create-new-project-from-template.en.md)

```bash
# 1. Clone and initialize fresh git repository
git clone <template-repo-url> my_new_app
cd my_new_app
rm -rf .git && git init

# 2. Rename and re-identify project (app_name, package_name, bundle_id)
./scripts/rename_project.sh "My New App" my_new_app com.mycompany.mynewapp

# 3. Synchronize secure configurations (dev/stg/prd)
sh .agent/skills/copy_secure_configurations/resources/scripts/copy_secure_files.sh

# 4. Verify and launch application
melos run analyze
fvm flutter test
flutter run --flavor dev --dart-define-from-file=secureFiles/dev/environment-configs.json
```

`rename_project.sh` renames the Dart package, imports in `lib/`, `features/`, `applicationId`/bundle id, display names (Android & iOS) and runs `melos bootstrap` & `melos genAlls`. After this, `flutter run` boots straight into the Shell with Home, Scanner, and Settings tabs.

---

## 1. Create a new Flutter Feature (`features/`)

Use when implementing a new business feature (pure Dart/Flutter, following Clean Architecture + MVI).

```bash
mason make pac_mvi_feature --name <feature_name>
# e.g., mason make pac_mvi_feature --name wallet
```

- **Target location:** Scaffolds `features/<feature_name>/` (Clean Architecture: `data/`, `domain/`, `presentation/` with BLoC MVI).
- **Automated Wiring:** Wires into root `pubspec.yaml`, `lib/di/injection.dart`, `lib/app_router.dart`, localization, and executes `melos bootstrap` + `./scripts/integrateFeatureToApp.sh <feature_name>`.

---

## 2. Create a shared Library (`packages/`)

Use when creating shared infrastructure packages, networking helpers, or reusable UI components.

```bash
mason make pac_library --name <library_name> --is_flutter true
```

- Set `--is_flutter false` for pure Dart packages without Flutter dependencies.
- **Target location:** Scaffolds `packages/<library_name>/` and registers it within the Melos monorepo workspace.

---

## 3. Create a Native Plugin without UI (Headless Pigeon)

Use when a package needs to interact with native platform APIs (e.g., biometric authentication, secure hardware storage, device sensors) without rendering native UI views.

```bash
mason make pac_native_plugin --name <plugin_name> --has_ui false
```

- **Target location:** Generates a Tri-Platform plugin in `packages/<plugin_name>/` with Clean Architecture for Android (Kotlin) and iOS (Swift) bridged via Pigeon.
- Both Android and iOS platforms are scaffolded in one unified plugin package with clean separation of concerns.

---

## 4. Create a Native Plugin with UI (Compose & SwiftUI)

Use when a feature requires high-performance native UI components (e.g., custom camera viewfinder, maps, AR view) rendered via Flutter `PlatformView`.

```bash
mason make pac_native_plugin --name <plugin_name> --has_ui true
```

- **Target location:** Adds native presentation layers (`presentation/` with Jetpack Compose on Android and SwiftUI on iOS) alongside `MviViewModel`.
- Automatically wires `PlatformViewFactory` registrations in both Kotlin and Swift.

---

## 5. Upgrade a headless Plugin to include Native UI

Use when a previously created headless plugin (`has_ui=false`) now requires native UI. **Do not re-run `pac_native_plugin`** (to avoid overwriting custom domain/data code).

```bash
mason make pac_add_native_ui --name <plugin_name>
```

- **Automated patches:** Updates Gradle dependencies for Jetpack Compose, iOS Podspec for SwiftUI, scaffolds native MVI ViewModels, and registers `PlatformViewFactory` bridge code.

---

## 6. Create a Subfeature within an existing Feature

Use when adding a secondary screen or workflow into an existing feature without creating a separate package (e.g., adding `order_detail` to `e_commerce`).

```bash
mason make pac_mvi_subfeature --package_name <feature_name> --subfeature_name <subfeature_name>
```

- Reuses the existing repository and data source, extending them with the new subfeature methods and presentation widgets.

---

## 7. Add a Go binding to a native package

Use when a package needs to invoke precompiled Go routines (e.g., E2EE encryption engines). This is a manual integration pattern:

1. Place compiled `.aar` (Android, via gomobile) or `.xcframework` (iOS) into the package `data/` directory.
2. Ensure panic-recovery wrappers are placed on the JNI (Android) / cgo (iOS) boundaries to prevent Go panics from terminating the Flutter host process.
3. For OS-triggered plugins, communicate directly from Kotlin/Swift without instantiating a headless FlutterEngine.

---

## 8. Remove a feature package

Use when safely decommissioning an existing feature package:

```bash
mason make remove_pac_feature --name <feature_name>
```

- Automatically unwires the feature from `pubspec.yaml`, `injection.dart`, `app_router.dart`, and localization providers, cleaning up references cleanly.
