# Slang Super App Modular Localization Guide

**Comprehensive guide for multi-package, type-safe, compile-time and dynamic OTA localization using Slang in the Digital Wallet Super App monorepo.**

---

## 🎯 1. Overview & Architecture

This project uses [slang](https://pub.dev/packages/slang) and [slang_flutter](https://pub.dev/packages/slang_flutter) to power a **3-Tier Modular Localization Architecture** designed for high-scale Flutter Super Apps.

```
┌────────────────────────────────────────────────────────────────────────┐
│                        Root App Shell (/)                              │
│  - Namespace: AppTranslations                                          │
│  - Accessor: context.t                                                 │
│  - Scope: App Shell, Bottom Navigation, Main Tabs, System Dialogs      │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
         ┌─────────────────────────┴─────────────────────────┐
         ▼                                                   ▼
┌─────────────────────────────────┐       ┌──────────────────────────────────┐
│     Core Package (packages/core)│       │ Feature Packages (features/*)    │
│  - Namespace: CoreTranslations  │       │  - Settings: context.tSettings   │
│  - Accessor: context.coreT      │       │  - Scanner:  context.tScanner    │
│  - Scope: Common shared UI,     │       │  - Other:    context.t<Feature>  │
│    Cancel, OK, Error, Retry     │       │  - Scope: Feature-isolated logic │
└─────────────────────────────────┘       └──────────────────────────────────┘
```

### Key Pillars
1. **Module Isolation**: Each feature package (`features/*`) and core package (`packages/core`) manages its own `assets/locales/` directory, independent `slang.yaml`, and generated types. Features do not cross-import each other's translations.
2. **Compile-Time Safety**: Translation keys are statically typed Dart accessors, preventing typos and missing placeholder errors at compile time.
3. **Reactive Recomposition**: Language switching updates the entire widget tree instantly without reloading pages or tearing down active bottom sheets.
4. **Centralized Sync**: `LocalizationManager` coordinates locale propagation across all package-level Slang singletons.
5. **Over-The-Air (OTA) & Dynamic Translations**: Supports downloading remote JSON updates at runtime via `overrideTranslationsFromMap` and querying non-compile-time API keys via `DynamicTranslator`.

---

## 📁 2. Project Directory Structure

```
bloc_digital_wallet/
├── assets/locales/                          # Root app translations
│   ├── en.i18n.json                         # Base English
│   ├── vi.i18n.json                         # Vietnamese
│   └── ... (70+ locales supported)
├── slang.yaml                               # Root Slang configuration (translate_var: t)
├── lib/
│   ├── generated/translations.dart          # Root generated translations
│   ├── main.dart                            # MultiTranslationProvider bootstrap
│   └── core/
│       ├── app_initializer/
│       │   └── localization_initializer.dart # Binds sync & OTA callbacks
│       └── localization/
│           ├── app_translation_providers.dart# List of all package TranslationProviders
│           └── multi_translation_provider.dart# Widget flattener
├── packages/core/
│   ├── assets/locales/{en,vi,...}.i18n.json # Shared core strings
│   ├── slang.yaml                           # Core Slang config (translate_var: coreT)
│   └── lib/
│       ├── generated/translations.dart
│       └── localization/
│           ├── localization_manager.dart    # Singleton orchestrator (RxDart stream)
│           └── dynamic_translator.dart      # Runtime dynamic key lookup
└── features/settings/
    ├── assets/locales/{en,vi,...}.i18n.json # Settings-specific translations
    ├── slang.yaml                           # Feature Slang config (translate_var: tSettings)
    └── lib/
        ├── generated/translations.dart
        └── settings_strings.dart            # Optional static accessor (SettingsStrings.t)
```

---

## 🚀 3. Daily Developer Workflow

### 3.1 Accessing Translations in Widgets

Select the appropriate accessor depending on the layer your code belongs to:

#### In a Feature Package (e.g. `features/settings`)
```dart
import 'package:settings/generated/translations.dart';

@override
Widget build(BuildContext context) {
  // Method A: Context Extension (Rebuilds automatically on locale change) ✅ RECOMMENDED
  final t = context.tSettings.settings;
  return Text(t.account.title);
}
```

```dart
import 'package:settings/settings_strings.dart';

// Method B: Static Accessor (Useful outside build methods, e.g. BLoC or helper functions)
final title = SettingsStrings.t.settings.account.title;
```

#### In Core Shared Widgets (`packages/core` or components consuming `core`)
```dart
import 'package:core/core.dart';

@override
Widget build(BuildContext context) {
  return ElevatedButton(
    onPressed: () {},
    child: Text(context.coreT.core.common.cancel),
  );
}
```

#### In Root Shell Widgets (`lib/shell/`, `lib/main.dart`)
```dart
import 'package:d3_nexus_shield/generated/translations.dart';

@override
Widget build(BuildContext context) {
  return Text(context.t.home.nav.settings);
}
```

> [!IMPORTANT]
> **Always use `context.t*` in widgets.** Using `context.tSettings`, `context.coreT`, or `context.t` ensures the widget subscribes to that package's `TranslationProvider` and rebuilds automatically when the user changes language.

---

### 3.2 Adding New Translation Keys

#### Step 1: Add Keys to Module JSON Files

**Feature English** (`features/settings/assets/locales/en.i18n.json`):
```json
{
  "settings": {
    "security": {
      "biometricTitle": "Biometric Authentication",
      "biometricSubtitle": "Use Face ID or Fingerprint to unlock"
    }
  }
}
```

**Feature Vietnamese** (`features/settings/assets/locales/vi.i18n.json`):
```json
{
  "settings": {
    "security": {
      "biometricTitle": "Xác thực sinh trắc học",
      "biometricSubtitle": "Sử dụng Face ID hoặc Vân tay để mở khóa"
    }
  }
}
```

#### Step 2: Run Code Generation

```bash
# To generate for just this feature package:
melos genFeature settings

# OR to regenerate all locales across the entire Super App:
melos genLocales
```

#### Step 3: Use in Feature Code

```dart
Text(context.tSettings.settings.security.biometricTitle)
```

---

## 🔧 4. Advanced Slang Capabilities

### 4.1 Parameterized Strings (Placeholders)

**In JSON**:
```json
{
  "greeting": "Hello, {name}!",
  "walletBalance": "Your balance is {amount} {currency}"
}
```

**In Dart**:
```dart
Text(context.tSettings.greeting(name: user.name))
Text(context.tSettings.walletBalance(amount: '250.00', currency: 'USD'))
```

### 4.2 Pluralization

**In JSON**:
```json
{
  "transactionCount": {
    "zero": "No transactions",
    "one": "1 transaction",
    "other": "{count} transactions"
  }
}
```

**In Dart**:
```dart
Text(context.tSettings.transactionCount(count: items.length))
```

### 4.3 RichText Formatting

**In JSON**:
```json
{
  "termsNotice": "I accept the {terms} and {privacy}",
  "@termsNotice": {
    "placeholders": {
      "terms": {},
      "privacy": {}
    }
  }
}
```

**In Dart**:
```dart
RichText(
  text: TextSpan(
    children: [
      TextSpan(
        text: context.tSettings.termsNotice(
          terms: (builder) => TextSpan(
            text: 'Terms of Service',
            style: const TextStyle(color: Colors.blue),
            recognizer: TapGestureRecognizer()..onTap = openTerms,
          ),
          privacy: (builder) => TextSpan(
            text: 'Privacy Policy',
            style: const TextStyle(color: Colors.blue),
            recognizer: TapGestureRecognizer()..onTap = openPrivacy,
          ),
        ),
      ),
    ],
  ),
)
```

---

## ⚡ 5. Build & Code Generation Commands

| Command | Purpose | When to Use |
|---|---|---|
| `melos genLocales` | Runs `fvm dart run slang` across all packages containing `slang.yaml` | When you added translation keys to one or more packages |
| `melos genFeature <name>` | Runs Slang → `build_runner` → formatting for a single package | Fast iteration while developing within a specific feature |
| `melos genAlls` | Full pipeline: Slang → `build_runner` (UI kit, packages, root) → `fluttergen` → format → license → analyze | Prior to submitting a PR or after pulling major upstream changes |

> [!TIP]
> **Do not use `flutter pub run build_runner` for Slang.** The monorepo uses the standalone Slang CLI (`fvm dart run slang`), which is 10x faster than running the full `build_runner` suite.

---

## 🏗️ 6. Provider Wiring & Mason Automation

### 6.1 Avoiding Provider Nesting Hell with `MultiTranslationProvider`

In standard Flutter, nesting 10+ feature `TranslationProvider` widgets creates deep callback indentation in `main.dart`. This repository solves this with [`MultiTranslationProvider`](file:///Users/danhdueexoictif/AllProjects/digital_wallet/bloc_digital_wallet/lib/core/localization/multi_translation_provider.dart) and [`appTranslationProviders`](file:///Users/danhdueexoictif/AllProjects/digital_wallet/bloc_digital_wallet/lib/core/localization/app_translation_providers.dart):

```dart
// lib/core/localization/app_translation_providers.dart
final List<Widget Function({required Widget child})> appTranslationProviders = [
  ({required child}) => core.TranslationProvider(child: child),
  ({required child}) => TranslationProvider(child: child),
  ({required child}) => scanner.TranslationProvider(child: child),
  ({required child}) => settings.TranslationProvider(child: child),
];
```

In `lib/main.dart`:
```dart
MultiTranslationProvider(
  providers: appTranslationProviders,
  child: MaterialApp.router(...),
)
```

### 6.2 Automatic Scaffolding via Mason Bricks

When generating a new feature package via:
```bash
melos mason_make_pac_feature
```
The Mason template ([`pac_mvi_feature`](file:///Users/danhdueexoictif/AllProjects/digital_wallet/bloc_digital_wallet/bricks/pac_mvi_feature)) automatically:
1. Generates `slang.yaml` configured with `translate_var: t{{name.pascalCase()}}` and `enum_name: {{name.pascalCase()}}AppLocale`.
2. Creates `assets/locales/en.i18n.json` and `vi.i18n.json`.
3. Creates `lib/{{name.snakeCase()}}_strings.dart`.
4. Executes `post_gen.dart` hook to **automatically register** the new `TranslationProvider` into `app_translation_providers.dart` and the locale sync callbacks into `localization_initializer.dart`.

---

## 🌐 7. Centralized Locale Synchronization & Dynamic OTA

### 7.1 Programmatic Locale Changes

> [!CAUTION]
> **NEVER call `LocaleSettings.setLocale(...)` directly in application code.**  
> Calling `LocaleSettings` only updates that single package's singleton, leaving other features in the old language.

**Always use `LocalizationManager.instance`:**
```dart
import 'package:core/core.dart';

// Switch to Vietnamese across ALL packages and features
await LocalizationManager.instance.setLocaleFromCode('vi');

// Switch to English
await LocalizationManager.instance.setLocaleFromCode('en');
```

#### How it works under the hood:
1. `LocalizationManager.instance.setLocaleFromCode()` updates preferences and triggers `_syncLocaleCallback`.
2. [`LocalizationInitializer`](file:///Users/danhdueexoictif/AllProjects/digital_wallet/bloc_digital_wallet/lib/core/app_initializer/localization_initializer.dart) synchronizes raw locales across all packages:
   ```dart
   LocaleSettings.setLocaleRaw(rawLocale);
   core.LocaleSettings.setLocaleRaw(rawLocale);
   scanner.LocaleSettings.setLocaleRaw(rawLocale);
   settings.LocaleSettings.setLocaleRaw(rawLocale);
   ```
3. `LocalizationManager.localeStream` emits the new `Locale`, causing the root `StreamBuilder` in `main.dart` to notify all providers.

---

### 7.2 Dynamic Over-The-Air (OTA) Translations

The app supports updating string resources without releasing a new binary to the app store.
1. The backend provides full or delta JSON translation maps (e.g. from `/api/v1/sync/bootstrap`).
2. `LocalizationManager.instance.applyDynamicTranslations(json)` splits the payload by namespace:
   ```dart
   // Core strings
   await core.LocaleSettings.overrideTranslationsFromMap(map: {'core': json['core'] ?? {}});
   // Settings strings
   await settings.LocaleSettings.overrideTranslationsFromMap(map: {'settings': json['settings'] ?? {}});
   ```

### 7.3 Resolving Non-Compile-Time Server Keys (`DynamicTranslator`)

When the server returns dynamic identifiers (such as API status enums or backend error codes) that cannot be declared at compile time, use [`DynamicTranslator`](file:///Users/danhdueexoictif/AllProjects/digital_wallet/bloc_digital_wallet/packages/core/lib/localization/dynamic_translator.dart):

```dart
import 'package:core/core.dart';

// Server returns status: "FLAGGED_FRAUD"
final serverStatus = response.status;

// Look up dynamic key "transaction.status.FLAGGED_FRAUD"
final label = DynamicTranslator.translate('transaction.status.$serverStatus');
// Falls back to the key string itself if not present in the dynamic dictionary
```

---

## 📋 8. Configuration Reference (`slang.yaml`)

Every package has a `slang.yaml` adhering to the following standard:

### Feature Package (`features/settings/slang.yaml`)
```yaml
base_locale: en
fallback_strategy: base_locale
input_directory: assets/locales
input_file_pattern: .i18n.json
output_directory: lib/generated
output_file_name: translations.dart
output_format: single_file
locale_handling: true
flutter_integration: true
namespaces: false
translate_var: tSettings
enum_name: SettingsAppLocale
class_name: SettingsTranslations
translation_overrides: true
```

### Core Package (`packages/core/slang.yaml`)
```yaml
base_locale: en
fallback_strategy: base_locale
input_directory: assets/locales
input_file_pattern: .i18n.json
output_directory: lib/generated
output_file_name: translations.dart
output_format: single_file
locale_handling: true
flutter_integration: true
namespaces: false
translate_var: coreT
enum_name: CoreAppLocale
class_name: CoreTranslations
translation_class_visibility: public
translation_overrides: true
```

### Root App (`slang.yaml`)
```yaml
base_locale: en
fallback_strategy: base_locale
input_directory: assets/locales
input_file_pattern: .i18n.json
output_directory: lib/generated
output_file_name: translations.dart
output_format: single_file
locale_handling: true
flutter_integration: true
namespaces: false
translate_var: t
enum_name: AppLocale
class_name: AppTranslations
translation_overrides: true
```

---

## 🔍 9. Best Practices & Naming Conventions

### ✅ DO
1. **Scope keys by feature domain**:
   - `settings.account.profile`
   - `core.common.error`
   - `home.nav.wallet`
2. **Use camelCase** for all JSON keys (`editProfile`, not `edit_profile`).
3. **Add new keys to both `en.i18n.json` and `vi.i18n.json` simultaneously**.
4. **Use `context.t<Feature>`** inside widgets to enable reactive rebuilds on language change.
5. **Route all runtime language switching** through `LocalizationManager.instance.setLocaleFromCode(...)`.

### ❌ DON'T
1. **Do NOT hardcode user-facing strings** in widgets or BLoCs.
2. **Do NOT call `LocaleSettings.setLocale(...)` directly**.
3. **Do NOT cross-import feature translations** (e.g. `features/scanner` importing `features/settings/generated/translations.dart`). Place shared strings in `packages/core/assets/locales/` instead.
4. **Do NOT run `build_runner` for Slang**. Use `melos genLocales` or `melos genFeature <name>`.

---

## 🐛 10. Troubleshooting

| Symptom | Cause | Solution |
|---|---|---|
| Widget text doesn't update when changing language | Used static accessor or direct `LocaleSettings.instance` inside `build()`, or missing `context.t*` | Change widget to use `context.t<Feature>` or `context.coreT` |
| Only one module updates language, others stay in English | Called `LocaleSettings.setLocale()` directly instead of using `LocalizationManager` | Replace call with `await LocalizationManager.instance.setLocaleFromCode(code)` |
| `Undefined name 'context.tSettings'` | Missing import or missing code generation | Run `melos genFeature settings` and ensure `import 'package:settings/generated/translations.dart';` is imported |
| Build error `part of 'translations'` | Missing `.dart` extension in output filename | Ensure `output_file_name: translations.dart` is present in `slang.yaml` |

---

## 🚦 11. Checklist for Feature Developers

When adding or modifying user-facing text:
- [ ] Added keys to `features/<feature>/assets/locales/en.i18n.json`
- [ ] Added corresponding keys to `features/<feature>/assets/locales/vi.i18n.json`
- [ ] Generated code: `melos genFeature <feature>`
- [ ] Replaced hardcoded text with `context.t<Feature>.<module>.<key>`
- [ ] Tested switching between English and Vietnamese in Settings
- [ ] Verified analyzer passes cleanly: `melos run analyze`

---

**Last Updated**: 2026-09-16  
**Architecture**: Clean Architecture + MVI Super App Monorepo  
**Target Runtimes**: Flutter 3.32+ / Dart 3.8+ / Slang 4.12+
