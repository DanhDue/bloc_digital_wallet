# Guide: Creating a New Project from the Flutter Super App Template

This guide provides step-by-step instructions for creating and configuring a new Flutter application from the **Flutter Super App Template**, using the automated renaming and identification tooling (`rename_project.sh` / `pac_rename_project`).

---

## 📌 Table of Contents
- [1. Quick 4-Step Setup Process](#1-quick-4-step-setup-process)
  - [Step 1: Copy Template & Initialize Git](#step-1-copy-template--initialize-git)
  - [Step 2: Rename & Re-identify Project (Single Command)](#step-2-rename--re-identify-project-single-command)
  - [Step 3: Configure Secure Files & Flavors](#step-3-configure-secure-files--flavors)
  - [Step 4: Verify & Run the Application](#step-4-verify--run-the-application)
- [2. Under the Hood (Automated Mechanics)](#2-under-the-hood-automated-mechanics)
- [3. Developing New Features with Mason Bricks](#3-developing-new-features-with-mason-bricks)
- [4. Common Utility Scripts](#4-common-utility-scripts)
- [5. Troubleshooting](#5-troubleshooting)

---

## 1. Quick 4-Step Setup Process

### Step 1: Copy Template & Initialize Git

1. Clone the template into a new directory for your application (e.g., `my_super_app`):
   ```bash
   git clone <URL_TEMPLATE_REPO> my_super_app
   cd my_super_app
   ```

2. Detach git history to establish your independent repository:
   ```bash
   # Remove template's git history
   rm -rf .git

   # Initialize new git repository
   git init
   git branch -M main
   ```

---

### Step 2: Rename & Re-identify Project (Single Command)

The template provides a cross-platform automated script (compatible with macOS, Linux, and Windows):
```bash
./scripts/rename_project.sh "<App Name>" <package_name> <bundle_id>
```

#### Parameters:
| Parameter | Format | Example | Description |
|---|---|---|---|
| `app_name` | String | `"My Super App"` | Display name shown on the mobile home screen |
| `package_name` | `snake_case` | `my_super_app` | Dart package identifier in `pubspec.yaml` |
| `bundle_id` | `reverse-domain` | `com.company.mysuperapp` | Android Application ID / iOS Bundle Identifier |

#### Concrete Example:
```bash
./scripts/rename_project.sh "E-Commerce App" ecommerce_app com.mycompany.ecommerce
```

> **Note**: Running `./scripts/rename_project.sh` with no arguments triggers interactive prompts for each field.

---

### Step 3: Configure Secure Files & Flavors

1. Update the environment configuration files (Dev, Staging, Production) in `secureFiles/`:
   - `secureFiles/dev/environment-configs.json`
   - `secureFiles/stg/environment-configs.json`
   - `secureFiles/prd/environment-configs.json`

2. *(Optional)* If your project uses Firebase, copy the configuration files for each flavor:
   - Android: `secureFiles/{dev,stg,prd}/google-services.json`
   - iOS: `secureFiles/{dev,stg,prd}/GoogleService-Info.plist`

3. Run the copy script to place configuration files into the native Android and iOS folders:
   ```bash
   sh .agents/skills/copy_secure_configurations/resources/scripts/copy_secure_files.sh
   ```

---

### Step 4: Verify & Run the Application

Verify that the newly renamed project builds and passes tests:

1. **Run Static Analysis:**
   ```bash
   melos run analyze
   ```
   *Expected result: `No issues found!`*

2. **Run Test Suite (Unit / Widget Tests):**
   ```bash
   fvm flutter test
   ```

3. **Launch the Application (Dev Flavor):**
   ```bash
   flutter run --flavor dev --dart-define-from-file=secureFiles/dev/environment-configs.json
   ```

---

## 2. Under the Hood (Automated Mechanics)

The script `./scripts/rename_project.sh` triggers the Mason brick `pac_rename_project` whose pure Dart hook [post_gen.dart](../../bricks/pac_rename_project/hooks/post_gen.dart) executes:

1. **Root Configuration:**
   - Updates `name` in `pubspec.yaml` and `melos.yaml`.
2. **Dart Code & Imports:**
   - Recursively traverses `lib/`, `features/`, `test/`, `integration_test/`.
   - Replaces all `package:bloc_digital_wallet/...` imports with `package:<package_name>/...`.
   - **Preserves Internal Vendor Plugins:** Retains `com.danhdue.*` namespaces (`packages/native_security`, `packages/logger_native_bridge`).
3. **Android Native Configuration:**
   - Updates `namespace` and `applicationId` in `android/app/build.gradle.kts`.
   - Updates `DART_DEFINES_APP_NAME` with the new display name.
   - Moves `MainActivity.kt` to the new package directory structure `android/app/src/main/kotlin/<bundle/id>/` and updates the package declaration.
4. **iOS Native Configuration:**
   - Updates `PRODUCT_BUNDLE_IDENTIFIER` in `ios/Runner.xcodeproj/project.pbxproj`.
   - Updates bundle name in `ios/Runner/Info.plist`.
   - Updates `BASE_ID` in `ios/scripts/verify_flavors.sh`.
   - Updates `DART_DEFINES_APP_NAME` across flavor configs in `ios/Flutter/*.xcconfig`.
5. **App & Environment Configurations:**
   - Updates `defaultValue` in `lib/config/app_config.dart`.
   - Updates `APP_NAME` in `secureFiles/{dev,stg,prd}/environment-configs.json` and template resources.
   - Updates target configurations in `.vscode/launch.json` and `.agents/skills/setup_variants/resources/launch.json`.
   - Updates `project_name` in `.agents/config.json`.
   - Updates package imports across `bricks/` Mason templates (`bricks/mvi_feature`, `bricks/mvi_subfeature`).
6. **Dependency Sync & Code Generation:**
   - Executes `melos bootstrap`.
   - Executes `./scripts/genAlls.sh` (Slang localization code gen, `build_runner`, Freezed/Retrofit).

---

## 3. Developing New Features with Mason Bricks

Once the project is initialized, you can scale the application using the standardized Super App Mason Bricks:

### 1. Create a New Feature with Clean Architecture + MVI (`features/`)
```bash
mason make pac_mvi_feature --name e_commerce
```
Scaffolds a complete feature module in `features/e_commerce` with `data`, `domain`, `presentation`, BLoC MVI, and auto-wires it into the Router and DI.

### 2. Create a Subfeature / Screen within an Existing Feature
```bash
mason make pac_mvi_subfeature --feature_name e_commerce --name order_detail
```

### 3. Create a Shared Pure Dart/Flutter Package (`packages/`)
```bash
mason make pac_library --name network_cache
```
Scaffolds a reusable library in `packages/network_cache` and registers it with the Melos workspace.

### 4. Create a Tri-Platform Native Plugin (Android Kotlin + iOS Swift)
- **No UI (Dart calls native API via Pigeon bridge):**
  ```bash
  mason make pac_native_plugin --name biometric_auth --has_ui false
  ```
- **With UI (Jetpack Compose & SwiftUI PlatformViews):**
  ```bash
  mason make pac_native_plugin --name custom_scanner --has_ui true
  ```

### 5. Upgrade an Existing No-UI Plugin to With-UI (Compose & SwiftUI)
```bash
mason make pac_add_native_ui --plugin_name biometric_auth
```
Automatically patches Gradle, Podfile, scaffolds native MVI ViewModels, and registers `PlatformViewFactory`.

---

## 4. Common Utility Scripts

| Action | Command | Notes |
|---|---|---|
| **Generate all code** | `./scripts/genAlls.sh` | Runs Slang l10n + `build_runner` across the monorepo |
| **Generate code for changed files** | `./scripts/genChanged.sh` | Fast incremental code generation |
| **Check architectural boundaries** | `./scripts/check_module_boundaries.sh` | Validates Clean Architecture module boundaries |
| **Build Debug APK (Dev)** | `./scripts/buildApk.sh dev` | Builds Dev APK |
| **Build Release APK (Stg/Prd)** | `./scripts/buildApk.sh prd` | Builds Production APK |
| **Build iOS IPA** | `./scripts/buildIPA.sh prd` | Archives and exports iOS IPA |

---

## 5. Troubleshooting

### Issue 1: `melos: command not found` or `mason: command not found`
**Solution:** Activate CLI tools globally via Dart SDK:
```bash
dart pub global activate melos
dart pub global activate mason_cli
mason get
```

### Issue 2: Build runner conflicts or cache issues
**Solution:** Clean cache and rebuild generators:
```bash
./scripts/clean.sh
melos bootstrap
./scripts/genAlls.sh
```

### Issue 3: iOS CocoaPods not picking up new Bundle ID
**Solution:** Re-install CocoaPods in `ios/`:
```bash
cd ios
rm -rf Pods Podfile.lock .symlinks
pod install --repo-update
cd ..
```
