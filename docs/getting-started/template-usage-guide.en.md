# Template Usage Guide

A practical, use-case-driven guide — each section is one concrete thing you want to do, with the exact
commands and a pointer back to the task/design doc for deeper detail. Read
[flutter_super_app_template](../../.devtool/epic/flutter_super_app_template/flutter_super_app_template.en.md)
first for the architecture overview.

> **Note on command names**: earlier spec docs mentioned one shared brick/script covering both platforms
> (`native_package`, `extract_native_standalone.sh`, `native_add_ui_dependency.sh`). The final decision is
> **one command per platform** — nothing takes an `android`/`ios` argument. The names below are authoritative.

## Table of Contents
0. [Start a new project from the template](#0-start-a-new-project-from-the-template)
1. [Create a new Flutter package](#1-create-a-new-flutter-package)
2. [Add native code with NO UI to a package](#2-add-native-code-with-no-ui-to-a-package)
3. [Add native code WITH UI to a package](#3-add-native-code-with-ui-to-a-package)
4. [Upgrade an existing no-UI package to add UI](#4-upgrade-an-existing-no-ui-package-to-add-ui)
5. [Create a standalone Android Native project from the template](#5-create-a-standalone-android-native-project-from-the-template)
6. [Create a standalone iOS Native project from the template](#6-create-a-standalone-ios-native-project-from-the-template)
7. [Add a Go binding to an existing native package](#7-add-a-go-binding-to-an-existing-native-package)
8. [Remove a feature package](#8-remove-a-feature-package)

---

## 0. Start a new project from the template

The mandatory first step — every section below assumes this is already done.

```bash
git clone <template-repo-url> my_new_app
cd my_new_app
./scripts/rename_project.sh my_new_app com.mycompany.mynewapp
melos bootstrap
melos genAlls
```

`rename_project.sh` renames the Dart package, every `lib/` import, `applicationId`/bundle id, and the
app's display name — see [template_flutter task 7](../../.devtool/epic/template_flutter/task_7_rename_script.md).
After this, `flutter run` boots straight into the Shell with the Settings tab active.

## 1. Create a new Flutter package

No native code involved — a pure Dart/Flutter feature.

```bash
mason make pac_mvi_feature
# enter the feature name when prompted, e.g. wallet
```

The brick scaffolds `packages/<name>/` (Clean Architecture: `data/domain/presentation`), wires it into root
`pubspec.yaml`, `lib/di/injection.dart`, `lib/app_router.dart`, `lib/core/localization/...`, and runs
`melos bootstrap` + `./scripts/integrateFeatureToApp.sh <name>` for you. This is Case 1 in
[flutter_super_app_template §2](../../.devtool/epic/flutter_super_app_template/flutter_super_app_template.en.md).

## 2. Add native code with NO UI to a package

Use when a package needs to call into Kotlin/Swift but owns no native screen (e.g. secure storage,
crypto, device info). Corresponds to Ô1/Ô3 in the use-case matrix.

```bash
# For Android native code:
mason make native_android_package
#   name: <package_name>
#   trigger: passive        (Dart calls in)  |  os_triggered (OS calls in, independent of Flutter)
#   has_ui: false

# For iOS native code too (separate command, not combined):
mason make native_ios_package
#   name: <package_name>   (same name, writes into the same packages/<name>/)
#   trigger: passive | os_triggered  (pick the same as Android for consistent behavior)
#   has_ui: false
```

Need Android only? Run just the first command. iOS only? Just the second — the two are fully independent;
each brick detects whether `packages/<name>/` already exists (from the other command) and merges instead
of overwriting. Result: `platform/domain/data` scaffolding, depending on native `core`, manual DI (no
Hilt). If `trigger=os_triggered`, the generated entry-point is pre-wrapped in `core.SafeExecution`. See
[template_android task 6](../../.devtool/epic/template_android/task_6_native_package_brick.md) /
[template_ios task 6](../../.devtool/epic/template_ios/task_6_native_package_brick_ios.md).

## 3. Add native code WITH UI to a package

Use when you need an actual native screen/overlay (e.g. a custom camera `PlatformView`). Corresponds to
Ô2/Ô4.

```bash
mason make native_android_package   # has_ui: true
mason make native_ios_package       # has_ui: true (if iOS is needed too)
```

Compared to section 2, the generated package adds `presentation/` (Compose/SwiftUI + `MviViewModel`),
automatically pulls in native `framework`, and applies the Hilt+Compose convention (Android). If
`trigger=passive`, the result embeds into the Flutter widget tree via `PlatformView`; if
`trigger=os_triggered`, it gets its own `Activity`/overlay/Extension, independent of any `FlutterEngine`.

## 4. Upgrade an existing no-UI package to add UI

Use when a package created in section 2 (`has_ui=false`) later needs UI — **don't re-run the brick** (it
would clobber the existing `platform/domain/data`).

```bash
# Android:
./scripts/native_add_ui_dependency_android.sh <package_name>

# iOS (separate, independent command):
./scripts/native_add_ui_dependency_ios.sh <package_name>
```

These two scripts handle only the part most likely to be done wrong: adding the `framework` dependency +
Hilt/Compose convention (Android) or `ios/framework` (iOS). Follow the manual checklist afterward (create
`presentation/`, register `PlatformViewFactory`/`Activity`) — see
[template_android task 7](../../.devtool/epic/template_android/task_7_add_ui_dependency_tool.md) /
[template_ios task 7](../../.devtool/epic/template_ios/task_7_add_ui_dependency_tool_ios.md) for the full
checklist.

## 5. Create a standalone Android Native project from the template

Use when you want to write a pure native Android app (no Flutter) but still inherit the standardized MVI +
tooling (Spotless/Detekt/Hilt/Compose) stack from the template.

```bash
./scripts/extract_native_standalone_android.sh ~/Projects/my_native_android_app
cd ~/Projects/my_native_android_app
git init
./gradlew :app:assembleDebug
```

The script copies `core`/`framework`/`buildSrc` (already Flutter-independent) into the new directory,
generating a fresh `settings.gradle.kts` + minimal demo `app/` — the result runs immediately, with no
Flutter involvement. `native_security`/`logger_native_bridge` are **not** copied (they are Flutter plugins,
not part of a pure-native app skeleton). See
[template_android task 9](../../.devtool/epic/template_android/task_9_standalone_extraction.md).

## 6. Create a standalone iOS Native project from the template

```bash
./scripts/extract_native_standalone_ios.sh ~/Projects/my_native_ios_app
cd ~/Projects/my_native_ios_app
git init
open MyNativeIosApp.xcodeproj
```

Same as section 5, copying `ios/core`/`ios/framework` into a fresh, minimal Xcode project with no
`Flutter.framework` involvement. See
[template_ios task 9](../../.devtool/epic/template_ios/task_9_standalone_extraction.md).

## 7. Add a Go binding to an existing native package

Use when a package (created in section 2/3) needs to call into a compiled Go library (e.g. E2EE for chat).
This is a **guide + copy-paste snippet**, not an automated command/brick — every Go library's API differs.

1. Read `docs/architecture/native-go-binding.md` (Android or iOS section as applicable).
2. Drop the `.aar` (Android, from gomobile) or `.xcframework` (iOS) into the package's `data/`.
3. Copy the panic-recovery snippet into the exact JNI (Android) / cgo (iOS) boundary — **mandatory**, never
   skip it, or a Go panic will crash the whole app.
4. If the package is `trigger=os_triggered`: call Go directly from Kotlin/Swift, don't spin up a headless
   Flutter engine solely to reach Go.

See [template_android task 8](../../.devtool/epic/template_android/task_8_go_binding_guide.md) /
[template_ios task 8](../../.devtool/epic/template_ios/task_8_go_binding_guide_ios.md).

## 8. Remove a feature package

```bash
mason make remove_pac_feature
# enter the feature name to remove
```

The brick unwires the package from `pubspec.yaml`, `injection.dart`, `app_router.dart`, translation
providers — undoing exactly what `pac_mvi_feature` (section 1) wired in.
