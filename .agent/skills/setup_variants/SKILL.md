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

### 1. Android Setup
1.  **Modify `android/app/build.gradle.kts`**:
    -   Apply the flavor and signing configuration.
    -   Use the template from local resources: `.agent/skills/setup_variants/resources/android/build_gradle_flavors.kts`.
    -   Ensure `signingConfigs` map to `secureFiles` correctly.
2.  **Update .gitignore**:
    -   Add `keystore.properties` to `android/.gitignore` (defensive, in case it is copied locally).
3.  **Verify Android Build**:
    -   Run `./gradlew bundleRelease` (or `assembleRelease`) to ensure gradle syncs and builds correctly.

### 2. iOS Setup

The iOS config lives in `ios/Runner.xcodeproj/project.pbxproj` (build configurations),
`ios/Runner.xcodeproj/xcshareddata/xcschemes/` (schemes), and `ios/Flutter/*.xcconfig`.
One idempotent script does the pbxproj + xcconfig work; the schemes and Info.plist are
edited once by hand.

1.  **Copy scripts** to `ios/scripts/` and `chmod +x` the shell one:
    -   `setup_ios_flavors.py`  (pbxproj build configs + per-flavor xcconfigs + the GoogleService build phase)
    -   `copy_google_service_plist.sh`
    > Do **not** reintroduce `extract_dart_defines.sh` / `update_project.py` - a build-time
    > extraction script runs *after* Flutter probes the bundle id, so `flutter run` targets a
    > stale id; and `update_project.py` was not idempotent (re-runs duplicated every config).

2.  **Reset a mangled `project.pbxproj` first (only if it was previously processed).**
    `setup_ios_flavors.py` expects a stock Flutter pbxproj. If flavor configs already exist
    (possibly duplicated), restore the pristine file from git history, e.g.
    `git checkout <first-commit> -- ios/Runner.xcodeproj/project.pbxproj`, then re-run below.
    Flutter re-adds its SPM package reference automatically on the next build; `pod install`
    re-adds the CocoaPods phases.

3.  **Run** (from the repo root): `python3 ios/scripts/setup_ios_flavors.py`
    For each `{Debug,Release,Profile}-{dev,stg,prd}` it adds a build configuration to the
    Project / Runner / RunnerTests lists, sets the Runner config's
    `PRODUCT_BUNDLE_IDENTIFIER` to `<base id><APP_ID_SUFFIX>` (read from
    `secureFiles/<flavor>/environment-configs.json`), points its base xcconfig at
    `Flutter/<Mode>-<flavor>.xcconfig`, and adds a "Copy GoogleService-Info.plist" build
    phase after Resources. It also (re)writes `Flutter/<Mode>-<flavor>.xcconfig` with the
    Pods include, `Generated.xcconfig`, and `DART_DEFINES_APP_NAME` from the JSON.
    Safe to re-run. Validate: `plutil -lint ios/Runner.xcodeproj/project.pbxproj`.

4.  **`ios/Flutter/Define-defaults.xcconfig`**: create from the resource `App-defaults.xcconfig`
    (fallback `DART_DEFINES_APP_NAME` for the plain, no-flavor Debug/Release/Profile configs).
    `Debug.xcconfig` / `Release.xcconfig` should `#include` it.

5.  **`ios/Runner/Info.plist`**:
    -   `CFBundleDisplayName` = `$(DART_DEFINES_APP_NAME)`
    -   `CFBundleIdentifier`  = `$(PRODUCT_BUNDLE_IDENTIFIER)`  (the full per-flavor id is set
        in the build configs - do **not** append `$(DART_DEFINES_APP_ID_SUFFIX)`, since an
        empty suffix, e.g. prd, is dropped by `xcodebuild -showBuildSettings`).

6.  **Schemes** `xcshareddata/xcschemes/{dev,stg,prd}.xcscheme`: each must reference
    `Debug-<flavor>` / `Release-<flavor>` / `Profile-<flavor>` and carry the standard Flutter
    `<PreActions>` "Run Prepare Flutter Framework Script" block. Keep `Runner.xcscheme` as a
    no-flavor fallback.

7.  **`ios/Podfile`**: map every new configuration in the `project 'Runner', { ... }` hash
    (`'Debug-dev' => :debug`, `'Release-stg' => :release`, ...) and set `platform :ios, '13.0'`.

8.  **`ios/.gitignore`**: ignore only `Flutter/Generated.xcconfig` and
    `Flutter/flutter_export_environment.sh` - the `<Mode>-<flavor>.xcconfig` files are
    committed source. Keep `Podfile` / `Podfile.lock` tracked (CocoaPods is still the SPM
    fallback for plugins without a Package.swift).

9.  **GoogleService-Info.plist**: run the `@copy_secure_configurations` skill first so
    `ios/Runner/Firebase/GoogleService-Info.<flavor>.plist` exist. The build phase added in
    step 3 copies the right one into the bundle per configuration.

10. **Verify**: `flutter clean && flutter pub get && (cd ios && pod install)`, then for each
    flavor `flutter build ios --flavor <f> --dart-define-from-file=secureFiles/<f>/environment-configs.json --no-codesign`
    and assert `CFBundleDisplayName` / `CFBundleIdentifier` / bundled `GoogleService-Info.plist`
    in `build/ios/iphoneos/Runner.app`. Switch flavors without `flutter clean` between to
    confirm no stale carry-over.

### 3. VS Code Configuration
1.  **Create `launch.json`**:
    -   Create `.vscode/launch.json` using the template from resources.

### 4. Verification


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
