# Modular Development Guide

This guide explains how to develop in the **Bloc Digital Wallet** Modular Architecture.

---

## Table of Contents

- [I. Implementing a New Feature](#i-implementing-a-new-feature)
  - [1. Generate the Feature Package](#1-generate-the-feature-package)
  - [2. Configure the App Module ("The Glue")](#2-configure-the-app-module-the-glue)
  - [3. Run Build](#3-run-build)
- [II. Implementing a Sub-Feature](#ii-implementing-a-sub-feature)
- [III. Dependency Injection (DI) Configuration](#iii-dependency-injection-di-configuration)
  - [1. Architecture](#1-architecture)
  - [2. How it works](#2-how-it-works)
- [IV. Localization Solution](#iv-localization-solution)
  - [1. Architecture](#1-architecture-1)
  - [2. Usage in Features](#2-usage-in-features)
  - [3. Adding New Strings](#3-adding-new-strings)
  - [4. Why this approach?](#4-why-this-approach)

---

## I. Implementing a New Feature

We use **Mason** to automate feature creation, ensuring consistency with Clean Architecture + MVI.

### 1. Generate the Feature Package
Use `pac_mvi_feature` to create a standalone package with the correct structure.

```bash
# Example: Create a 'staking' feature
mason make pac_mvi_feature --name staking
```

**Output:**
- Creates `packages/staking/`
- Sets up `pubspec.yaml`, `build.yaml` (using core/network deps).
- Generates `StakingRouter`, `StakingNetworkModule` (DI).
- Generates `StakingPage`, `StakingBloc`.

### 2. Configure the App Module ("The Glue")

After generating the package, you must register it in the **root App Module** (`lib/`).

#### 2.1 Register Dependency Injection
Open `lib/di/injection.dart` and add the new package's DI configuration.

```dart
// lib/di/injection.dart
import 'package:staking/staking.dart' as staking; // [NEW]

@InjectableInit(initializerName: r'$initGetIt')
void configureDependencies() {
  core.configureModuleDependencies(getIt);
  network.configureModuleDependencies(getIt);
  
  // Register Feature Module
  staking.configureModuleDependencies(getIt); // [NEW]

  getIt.$initGetIt();
}
```

> **Note**: The `pac_mvi_feature` brick generates a `configureModuleDependencies` function in `package:staking/staking.dart`.

#### 2.2 Register Routing
Open `lib/app_router.dart` and add the feature's router.

```dart
// lib/app_router.dart
import 'package:staking/staking.dart' as staking; // [NEW]

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  // Initialize Feature Router
  final _stakingRouter = staking.StakingRouter(); // [NEW]

  @override
  List<AutoRoute> get routes => [
    ..._stakingRouter.routes, // [NEW] Spread the routes
    // ... other routes
  ];
}
```

#### 2.3 Register Localization Provider
Open `lib/core/localization/app_translation_providers.dart` and add the feature's provider.

```dart
// lib/core/localization/app_translation_providers.dart
import 'package:staking/staking.dart' as staking; // [NEW]

final List<Widget Function({required Widget child})> appTranslationProviders = [
  // ... existing providers
  
  // Register Feature Provider
  ({required child}) => staking.TranslationProvider(child: child), // [NEW]
];
```

### 3. Run Build
Run the master build command to wire everything together.

```bash
melos genAlls
```

---

## II. Implementing a Sub-Feature

Sub-features (e.g., `staking_history` inside `staking`) are added to an **existing** package.

```bash
# Example: Add 'history' sub-feature to 'staking' package
mason make pac_mvi_subfeature --package_name staking --subfeature_name history
```

**Automation**:
- This brick **automatically** runs `melos genAlls` at the end.
- It updates `{package}_router.dart` to include the new page.
- It exports the new code in `{package}.dart`.
- DI is auto-discovered via `@injectable`.

---

## III. Dependency Injection (DI) Configuration

Our DI system handles the multi-package architecture using `injectable` + `get_it`.

### 1. Architecture
1.  **Root Scope (`lib/di/injection.dart`)**:
    - Acts as the orchestrator.
    - Initializes valid instances of `Core`, `Network`, and `Features`.
    - `getIt` is a global singleton.

2.  **Package Scope (`packages/{feature}/lib/di/`)**:
    - Each package defines its own dependencies using `@injectable` / `@module`.
    - **`NetworkModule`**: Each feature defines its own `Service/Client` which depends on the `Dio` instance provided by the Root Scope (from `Core/Network`).

### 2. How it works
- **Providing**: Use `@injectable`, `@singleton`, `@lazySingleton`.
- **Consuming**: Constructor injection.
- **Cross-Package**: `Core` exports common providers (like `SecureStorage`, `Dio`). Features blindly ask for `Dio`, and the Root DI satisfies it because `Network` package is registered in Root.

```dart
// Feature Module (packages/staking/lib/data/di/network_module.dart)
@module
abstract class StakingNetworkModule {
  // Asks for Dio (from Root), provides StakingClient (to Feature)
  @lazySingleton
  StakingClient stakingClient(Dio dio) => StakingClient(dio, baseUrl: ...);
}
```

---

## IV. Localization Solution

We use **Slang** (formerly `fast_i18n`) for type-safe, multi-package localization.

### 1. Architecture
1.  **Single Source of Truth**:
    - Translation files live in `packages/core/assets/locales/`.
    - This avoids fragmentation and ensures consistency across 100+ modules.

2.  **Core Package**:
    - Generates `translations.dart`.
    - Exports `Translations.of(context)` via `core.dart`.
    - Manages `LocalizationManager` (Stream of `Locale` changes).

### 2. Usage in Features

Since all features depend on `packages/core`, they simply import `core.dart` and use the extensions.

```dart
import 'package:core/core.dart';

Widget build(BuildContext context) {
  // Access translations
  final title = context.t.staking.title; 
  
  // Access Locale Manager
  return Text(title);
}
```

### 3. Adding New Strings
1.  Edit `packages/core/assets/locales/en.i18n.json`.
2.  Run `melos gen`.
3.  Use immediately in any feature package.

### 4. Why this approach?
- **No Conflict**: Multiple packages generating their own `S.current` classes often leads to context conflicts.
- **Simplicity**: One `t` variable for the whole app.
- **Performance**: Slang is pure Dart code generation, very fast.
