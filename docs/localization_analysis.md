# Localization Strategy Analysis

## 🎯 Executive Summary
**Decision:** Continue using **`slang`** with a **unified scalable architecture**.  
**Reasoning:** Fits the project's strict requirement for type safety (alongside `freezed` & `retrofit`) and solves the "nested provider hell" with a clean, centralized provider list.

---

## 🏗️ Architecture Overview

The solution keeps the core benefits of `slang` (type safety, modularity) while solving the nesting visibility issue.

### 1. Unified Localization Manager
A singleton in `core` that manages the single source of truth for the locale stream.
*   **File**: `packages/core/lib/src/localization/localization_manager.dart`
*   **Role**: Exposes `localeStream` and updates all packages simultaneously.

### 2. MultiTranslationProvider (The "Flattening" Wrapper)
A widget that takes a flat list of providers and recursively wraps them.
*   **File**: `lib/core/localization/multi_translation_provider.dart`
*   **Concept**: Turns deep nesting into a clean list in code.

### 3. Centralized Provider Registry
A dedicated file to list all package providers, keeping `main.dart` clean.
*   **File**: `lib/core/localization/app_translation_providers.dart`
*   **Role**: The single place to register new feature translations.

### 4. Static Access Wrappers
Per-package static classes to access translations without context, fully synced with the locale stream.
*   **Example**: `AuthStrings.t.loginTitle`
*   **Role**: Provides easy access to translations in Business Logic Components (BLoC) or repositories where context isn't available.

---

## 🛠️ How to Add a New Package

When creating a new feature package (e.g., `packages/settings`) that uses translations:

### 1. Configure Slang
Ensure your package's `slang.yaml` is set up correctly (or copy from another package).
Run generation:
```bash
dart run slang
```

### 2. Create Static Wrapper
Create a file `lib/settings_strings.dart`:
```dart
import 'generated/translations.dart';

class SettingsStrings {
  SettingsStrings._();
  static SettingsTranslations get t => LocaleSettings.instance.currentTranslations;
}
```

### 3. Export Generated Files
In your package's main export file (e.g., `lib/settings.dart`), export the translations and wrapper:
```dart
export 'generated/translations.dart';
export 'settings_strings.dart';
```

### 4. Register the Provider
Open `lib/core/localization/app_translation_providers.dart` in the main app.
Add an import and the provider to `appTranslationProviders`:
```dart
import 'package:settings/settings.dart' as settings;

final List<Widget Function({required Widget child})> appTranslationProviders = [
  // ... existing providers
  ({required child}) => settings.TranslationProvider(child: child),
];
```

### 5. Use Translations
You can now use translations safely via Context OR Static Getter:

**Method A: Context (Recommended for Widgets)**
```dart
Text(context.tSettings.pageTitle);
```

**Method B: Static (Recommended for BLoC/Logic)**
```dart
String error = SettingsStrings.t.errors.invalidInput;
```

---

## ⚔️ Comparison: Slang vs. Easy Localization (Archive)

### 1. 🛡️ Type Safety (Crucial)
This project prioritizes compile-time safety. `slang` aligns with this philosophy, whereas `easy_localization` relies on runtime resolution.

| Feature | Slang (Selected) | Easy Localization |
| :--- | :--- | :--- |
| **Missing Keys** | 🛑 **Build Error**<br>Code fails to compile if a key is missing or renamed. | ⚠️ **Runtime Glitch**<br>Shows the raw key string (e.g., `'auth.title'`) to the user. |
| **Autocomplete** | ✅ **Full Support**<br>IDE suggests keys like `t.auth.login.title`. | ❌ **None**<br>Must manually type magic strings like `'auth.login.title'`. |
| **Parameters** | ✅ **Typed**<br>`t.greet(name: "John")` enforces name argument. | ❌ **Loose**<br>`tr('greet', args: ['John'])` accepts any list/map. |

### 2. 🧩 Modularity
The project uses a multi-package architecture. Our new `app_translation_providers.dart` approach solves the only downside of explicit isolation (the setup boilerplate).

| Feature | Slang | Easy Localization |
| :--- | :--- | :--- |
| **Scope** | **Package-Scoped**<br>Each package has its own translation class. `context.tAuth` ensures scope safety. | **Global Scope**<br>Typically loads a single large asset bucket, risking key collisions. |
| **Isolation** | ✅ Strong boundaries between features. | ⚠️ Harder to separate feature strings strictly. |

### 3. 🚀 Performance
| Feature | Slang | Easy Localization |
| :--- | :--- | :--- |
| **Mechanism** | **Pure Dart Code**<br>Translations are compiled classes. | **Runtime Parsing**<br>Reads & parses JSON/YAML files at startup. |
| **Startup** | ⚡ **Instant** | 🐢 Slight delay for file I/O & parsing. |
