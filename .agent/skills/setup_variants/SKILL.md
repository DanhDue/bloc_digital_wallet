---
name: setup-variants
description: Automates the setup of build variants (flavors) for Android and iOS in a default Flutter project, including signing and VS Code launch configuration.
---

# Setup Variants Skill

This skill configures `dev`, `stg`, and `prd` build variants for both Android and iOS in a standard Flutter project.

**Reference Guide:** [Setup Development Environments Guide](https://viblo.asia/p/setup-development-environmentsdevelopstagingproduction-for-the-flutter-project-bJzKmd9659N#_1-parse-properties-from-the-flutter-command-arguments-6)

## Prerequisites
- A standard Flutter project structure
- `secureFiles` directory with signing keys and flavor configurations (json)

## Steps

### 1. Secure Files Setup
1.  **Check/Create `secureFiles`**:
    -   Copy the template `secureFiles` folder from resources (`.agent/skills/setup_variants/resources/secureFiles`) to the project root if it does not exist.
    -   Ensure `signing/debug.keystore` and `signing/keystore.properties.template` are present.

### 2. Android Setup
1.  **Modify `android/app/build.gradle.kts`**:
    -   Apply the flavor and signing configuration.
    -   Use the template from local resources: `.agent/skills/setup_variants/resources/android/build_gradle_flavors.kts`.
    -   Ensure `signingConfigs` map to `secureFiles` correctly.
2.  **Update .gitignore**:
    -   Add `keystore.properties` to `android/.gitignore` (defensive, in case it is copied locally).
3.  **Verify Android Build**:
    -   Run `./gradlew bundleRelease` (or `assembleRelease`) to ensure gradle syncs and builds correctly.

### 3. iOS Setup
1.  **Clean Default Scheme**:
    -   Remove `ios/Runner.xcodeproj/xcshareddata/xcschemes/Runner.xcscheme`.
2.  **Copy Scripts**:
    -   Copy `extract_dart_defines.sh` to `ios/scripts/`.
    -   Copy `update_project.py` and `update_project_runner_tests.py` to `ios/scripts/`.
    -   Make `extract_dart_defines.sh` executable (`chmod +x`).
3.  **Run Automation Scripts**:
    -   Run `python3 ios/scripts/update_project.py` to create Build Configurations (Debug-dev, etc.).
    -   Run `python3 ios/scripts/update_project_runner_tests.py` to fix RunnerTests targets.
4.  **Create XCConfigs**:
    -   Create `ios/Flutter/Define-defaults.xcconfig` using the resource template.
    -   Create flavor `.xcconfig` files (`Debug-dev.xcconfig`, etc.) in `lib/ios/Flutter/` that import `Define.xcconfig` and generated Pods configs.
5.  **Update .gitignore**:
    -   Add `Flutter/Define.xcconfig` to `ios/.gitignore` as it is a generated file.
6.  **Update Info.plist**:
    -   Set `CFBundleDisplayName` to `$(DART_DEFINES_APP_NAME)`.
    -   Set `CFBundleIdentifier` to `$(PRODUCT_BUNDLE_IDENTIFIER)$(DART_DEFINES_APP_ID_SUFFIX)`.
7.  **Create Schemes**:
    -   (Already handled by `update_project.py` logic or manual xml creation if needed - *Note: current script does not create schemes xml, only config. You may need to create scheme XMLs defined in previous steps if not present*).
    -   Actually, for this skill, ensure `dev`, `stg`, `prd` schemes exist in `xcshareddata`.
8.  **Update Podfile**:
    -   Map the new configurations to `:debug` and `:release`.
    -   Ensure `platform :ios, '13.0'` (or higher) is set.
    -   Enforce `IPHONEOS_DEPLOYMENT_TARGET` in `post_install`.
9.  **Verify iOS Build**:
    -   Run `pod install` in `ios/`.

### 4. VS Code Configuration
1.  **Create `launch.json`**:
    -   Create `.vscode/launch.json` using the template from resources.

### 5. Verification


Run the following commands to verify the setup for each environment. These match the configurations in `.vscode/launch.json`.

**Dev Environment:**
```bash
flutter run --flavor dev --dart-define-from-file=secureFiles/dev/environment-configs.json
```

**Staging Environment:**
```bash
flutter run --flavor stg --dart-define-from-file=secureFiles/stg/environment-configs.json
```

**Production Environment:**
```bash
flutter run --flavor prd --dart-define-from-file=secureFiles/prd/environment-configs.json
```
