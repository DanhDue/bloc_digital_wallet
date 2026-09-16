# Architecture: Clean Architecture + MVI
*(Feature-First Organization)*

This document is the **authoritative architecture guide** for the Flutter Super App Template (`super_app_template`).

---

## Table of Contents

- [I. Clean Architecture + MVI Diagram](#i-clean-architecture--mvi-diagram)
  - [1. Core Concepts](#1-core-concepts)
  - [2. Data Flow Diagram](#2-data-flow-diagram)
- [II. MVI Mechanism](#ii-mvi-mechanism)
  - [1. Core Concepts](#1-core-concepts-1)
  - [2. Data Flow Diagram](#2-data-flow-diagram-1)
- [III. Feature-First Organization & Architecture Layers](#iii-feature-first-organization--architecture-layers)
  - [1. Directory Structure](#1-directory-structure)
  - [2. Architecture Layer Details](#2-architecture-layer-details)
  - [3. Usage with Mason](#3-usage-with-mason)
- [IV. Modern Flutter Stack](#iv-modern-flutter-stack)
- [V. Code Examples & Best Practices](#v-code-examples--best-practices)
  - [1. Contract Definition](#1-contract-definition-actionstateevent)
  - [2. BLoC Implementation](#2-bloc-implementation)
  - [3. View Implementation](#3-view-implementation)
  - [4. Critical Rules](#4-critical-rules)
- [VI. References](#vi-references)
  - [1. Implementation Guides](#1-implementation-guides)
  - [2. Mason & Code Generation](#2-mason--code-generation)
  - [3. AI Agent Resources](#3-ai-agent-resources)
  - [4. External Resources](#4-external-resources)
- [VII. Summary](#vii-summary)
  - [1. Architecture at a Glance](#1-architecture-at-a-glance)
  - [2. Key Principles](#2-key-principles)
  - [3. Quick Commands](#3-quick-commands)

---

## I. Clean Architecture + MVI Diagram

### 1. Core Concepts

| Principle | Description |
|-----------|-------------|
| **Dependency Rule** | `Presentation → Domain ← Data`. Domain knows nothing about outer layers. |
| **Separation of Concerns** | UI, business logic, and data handling are strictly separated. |
| **Testability** | Each layer can be tested independently. |
| **Pure Domain** | Domain layer must be Pure Dart (no Flutter imports). |

### 2. Data Flow Diagram

```mermaid
%%{init: {'flowchart': {'subGraphTitleMargin': 40, 'diagramPadding': 30}}}%%
graph LR
    %% --- LAYER DEFINITIONS ---
    subgraph Presentation_Layer ["Presentation"]
        View["View (Widget)"]
        BLoC["BLoC"]
    end

    subgraph Domain_Layer ["Domain"]
        UseCase["Use Case"]
        RepoInterface(["Repository Interface"])
    end

    subgraph Data_Layer ["Data"]
        RepoImpl["Repository Impl"]
        DataSource["Remote/Local Data Source"]
    end

    %% --- DATA FLOW ---
    View -- "1. Send Action" --> BLoC
    BLoC -- "2. Call UseCase" --> UseCase
    UseCase -- "2a. Call Repo Interface" --> RepoInterface
    RepoInterface -. "implements" .-> RepoImpl
    RepoImpl -- "2b. Call Data Source" --> DataSource

    DataSource -- "3a. Return Data" --> RepoImpl
    RepoImpl -- "3b. Map to Entity" --> UseCase
    UseCase -- "3. Return Result" --> BLoC

    BLoC -- "4. Update State" --> View
    BLoC -. "5. Emit Event" .-> View

    %% --- STYLING ---
    classDef interface fill:#fffde7,stroke:#fbc02d,stroke-width:1px,stroke-dasharray: 5 5;
    class RepoInterface interface;
    style Presentation_Layer fill:#C7FDCB,stroke:#02CC0C,stroke-width:2px;
    style Data_Layer fill:#A7DAF2,stroke:#088DF3,stroke-width:2px;
    style Domain_Layer fill:#F4F0C0,stroke:#fbc02d,stroke-width:2px;
```

### Layer Dependency Rules


<br/>

> [!IMPORTANT]
> **Important Rules**
>
> 1. **Dependency Rule:** `Presentation` -> `Domain` <- `Data`. Presentation MUST NOT call Data directly. Domain MUST NOT import anything from Presentation or Data.
> 2. **No Flutter in Domain:** Domain layer must be `Pure Dart`. If you see `import 'package:flutter/*'` in Domain, it violates architecture.
> 3. **Unidirectional Data Flow:** Data always flows in a circle: `View` -> `BLoC` -> `Domain` -> `Data` -> `Domain` -> `BLoC` -> `View`.


```
Allowed Dependencies:
  Presentation → Domain
  Data → Domain
  Domain → (no dependencies on other layers)

Forbidden:
  ❌ Domain → Presentation
  ❌ Domain → Data
  ❌ Domain → Flutter/Material
  ❌ Presentation → Data (must go through Domain)
```

---

## II. MVI Mechanism

### 1. Core Concepts

Three core components with specific naming and responsibilities:

| Component | Type | Direction | Meaning & Responsibility |
| :--- | :--- | :--- | :--- |
| **Action** | **INPUT** | **View ➡️ BLoC** | **User actions.** <br> Triggers processing logic (e.g., Button click, Key press). |
| **State** | **DATA** | **BLoC ➡️ View** | **UI state.** <br> Data needed to render the screen (Persistent). View listens to State to rebuild. |
| **Event** | **OUTPUT** | **BLoC ➡️ View** | **One-time events (Side Effect).** <br> UI control commands without state storage (e.g., Toast, Navigation, Dialog). |

#### Action (User Input)
- **Base Class**: `BaseAction`
- **Naming**: `{Verb}{Noun}Action`
- **Examples**: `LoadWalletAction`, `CreateTransactionAction`, `UpdateProfileAction`
- **Flow**: View → BLoC
- **Properties**: `sealed class`, `const constructors`

#### State (Persistent UI Data)
- **Base Class**: `BaseState`
- **Naming**: `{Noun}{Status/Adjective}`
- **Examples**: `WalletInitial`, `WalletLoading`, `WalletLoaded`, `WalletError`
- **Flow**: BLoC → View (rebuild)
- **Properties**: `sealed class`, extends `Equatable`

#### Event (One-time Side Effect)
- **Base Class**: `BaseEvent`
- **Naming**: `{Verb}{Noun}` or `Show/Navigate{What}`
- **Examples**: `ShowSuccessMessage`, `NavigateToDetail`, `ShowErrorDialog`
- **Flow**: BLoC → View (once, handled by listener)
- **Properties**: `sealed class`, `const constructors`

### 2. Data Flow Diagram

**Unidirectional Data Flow:**

```
┌───────────────────────────────────────────────────────────────────────────┐
│                         PRESENTATION LAYER                                │
│                                                                           │
│   ┌─────────────────────┐     1. Action (Input)   ┌─────────────────┐     │
│   │      ViewModel      │ ◀────────────────────── │      View       │     │
│   │   ┌─────────────┐   │ ──────────────────────▶ │    (Widget)     │     │
│   │   │    BLoC     │   │   9. emit() / emitEvent └─────────────────┘     │
│   │   └─────────────┘   │                                                 │
│   └─────────────────────┘                                                 │
│             │                                                             │
│             │ 2. Call UseCase                                             │
└─────────────│─────────────────────────────────────────────────────────────┘
              │
              ▼
┌───────────────────────────────────────────────────────────────────────────┐
│                           DOMAIN LAYER                                    │
│                                                                           │
│   ┌─────────────────┐   3. Call Repo     ┌─────────────────────┐          │
│   │                 │ ─────────────────▶ │     Repository      │          │
│   │     UseCase     │                    │    (Interface)      │          │
│   │                 │ ◀───────────────── │                     │          │
│   └─────────────────┘   8. Either<F,E>   └─────────────────────┘          │
│                                                    │                      │
│                                                    │ implements           │
└────────────────────────────────────────────────────│──────────────────────┘
                                                     │
                                                     ▼
┌───────────────────────────────────────────────────────────────────────────┐
│                            DATA LAYER                                     │
│                                                                           │
│   ┌─────────────────┐   4. Call DS       ┌─────────────────────┐          │
│   │   DataSource    │ ◀───────────────── │   Repository Impl   │          │
│   │ (Remote/Local)  │                    │                     │          │
│   └─────────────────┘                    └─────────────────────┘          │
│           │                                        ▲                      │
│           │ 5. API/DB Call                         │ 7. Return Entity     │
│           ▼                                        │                      │
│   ┌─────────────────┐   6. Map to Entity ┌─────────────────────┐          │
│   │   Model (DTO)   │ ─────────────────▶ │       Entity        │          │
│   │    Response     │                    │    (Pure Dart)      │          │
│   └─────────────────┘                    └─────────────────────┘          │
│                                                                           │
└───────────────────────────────────────────────────────────────────────────┘
```

**Complete Flow:**

```
User Interaction (Tap, Type, etc.)
    ↓
View dispatches Action via bloc.onAction(action)
    ↓
BLoC receives Action in onAction() method
    ↓
BLoC calls UseCase (Domain)
    ↓
UseCase calls Repository Interface
    ↓
Repository Impl decides caching strategy
    ↓
Repository calls DataSource (Remote/Local)
    ↓
DataSource returns raw data (DTO/Model)
    ↓
Repository maps Model → Entity
    ↓
UseCase returns Either<Failure, Entity>
    ↓
BLoC emits new State via emit(state)
    ↓
BLoC optionally emits Event via emitEvent(event)
    ↓
View rebuilds with new State (via BlocBuilder/BlocConsumer)
    ↓
View reacts to Event (Navigation, Toast, Dialog)
```

---

## III. Feature-First Organization & Architecture Layers

### 1. Directory Structure

```
lib/                         # Root App Shell ("The Glue")
├── app_router.dart          # Main router configuration
├── main.dart                # Application entry point
├── di/                      # Root Dependency Injection
│   ├── app_module.dart      # Global singletons & initializers
│   └── injection.dart       # Orchestrates DI across all packages
└── core/                    # Root core setup (e.g., initializers)

packages/                    # Shared Infrastructure Libraries
├── core/                    # Core utilities, failures, base models, AppInitializer
│   ├── assets/locales/      # Multi-language translation files (slang)
│   └── lib/                 # Core services, auth stream, memory observer
├── framework/               # Architecture foundation (MviBloc, BaseAction, BaseState)
├── logger/                  # Unified logging abstraction
├── logger_native_bridge/    # Platform channel / FFI logging bridge
├── native_security/         # Native security plugins (Android/iOS)
├── network/                 # Dio client, interceptors, SSL pinning
├── platform/                # Platform event bus and helpers
└── ui_kit/                  # Shared widgets, themes (ThemeTailor), assets

features/                    # Feature Modules (Clean Architecture + MVI Packages)
└── {feature}/               # e.g., scanner, settings
    ├── lib/
    │   ├── data/
    │   │   ├── datasources/ # Remote & Local data sources
    │   │   ├── models/      # Freezed DTO models + JSON serializers
    │   │   └── repositories/# Repository implementations
    │   ├── domain/
    │   │   ├── entities/    # Pure Dart domain entities
    │   │   ├── repositories/# Repository interfaces
    │   │   └── usecases/    # Business use cases
    │   ├── presentation/
    │   │   ├── models/      # UI display models
    │   │   └── {subfeature}/# MVI: Action, State, Event, BLoC, Page
    │   ├── {feature}.dart   # Package barrel exports
    │   └── {feature}_router.dart # Feature route definition
    └── pubspec.yaml
```

### 2. Architecture Layer Details

#### 🟢 Presentation Layer (UI & State)

| Component | Responsibility |
|-----------|----------------|
| **View (Widget)** | Render UI based on State. "Dumb View" - no business logic, no API calls. |
| **BLoC** | Manages State, processes Actions, interacts with Domain. Single entry point: `onAction()`. |
| **Contract** | Defines Action/State/Event communication protocol between View and BLoC. |

#### 🟡 Domain Layer (Business Logic - The Core)

| Component | Responsibility |
|-----------|----------------|
| **Entity** | Pure Dart objects representing business data. **MUST use `@freezed`** or `Equatable`. |
| **Repository Interface** | Defines contract for data operations. Returns `Either<Failure, Entity>`. |
| **UseCase** | Encapsulates specific business logic. Single responsibility. Orchestrates data flow. |

> ⚠️ **CRITICAL**: Domain layer must be **Pure Dart**. If you see `import 'package:flutter/*'` in Domain, it's wrong!

#### 🔵 Data Layer (Implementation & Infrastructure)

| Component | Responsibility |
|-----------|----------------|
| **Model (DTO)** | Data matching 1:1 with API response or DB table. **MUST use `@freezed`** with `@JsonSerializable`. |
| **DataSource** | Remote (Dio, Retrofit) or Local (Hive, SharedPreferences). Throws Exceptions on error. |
| **Repository Impl** | Implements Domain interface. Decides cache strategy. Maps Model → Entity. Converts Exceptions → Failures. |

### 3. Dual-Mode Architecture (Enterprise vs Lean)

The template provides built-in dual-mode flexibility for the host application:

| Mode | Shell Structure | Default Tabs | Use Case |
|---|---|---|---|
| **`enterprise`** (Default) | Full 3-tab Shell | Home, Scanner, Settings | Super App ecosystem with multi-mini-app capabilities |
| **`lean`** | Focused 2-tab Shell | Home, Settings | Standalone MVP or single-purpose client (Scanner unhooked) |

#### How Mode Switching Works:
The mode switcher (`scripts/configure_mode.sh`) toggles declarative marker comment blocks across the 4 integration seams of the host app without breaking Git history or compilation:
1. `lib/shell/shell_page.dart` (toggles `// shell:scanner-tab` and adjusts tab count)
2. `lib/app_router.dart` (toggles `// app:scanner-route`)
3. `lib/di/injection.dart` (toggles `// di:scanner-module`)
4. `packages/platform/lib/deeplink/deep_link_registry.dart` (toggles `// deeplink:scanner-register`)

```bash
# Switch to Lean mode (keeps code on disk, unhooks from UI/DI/Router)
./scripts/configure_mode.sh lean

# Switch back to Enterprise mode
./scripts/configure_mode.sh enterprise

# Permanently prune Scanner feature from monorepo (clean git tree required)
./scripts/configure_mode.sh lean --prune

# Initialize new project directly in chosen mode
./scripts/rename_project.sh "My App" my_app com.company.app --mode lean
```

### 4. Code Generation with Mason (Monorepo Bricks)

The monorepo uses Mason bricks specifically designed for isolated packages and Tri-Platform plugins:

| Command | Description |
|---|---|
| `mason make pac_mvi_feature --name <name>` | Create new feature package in `features/<name>` |
| `mason make pac_mvi_subfeature --package_name <pkg> --subfeature_name <name>` | Add subfeature (action/state/event/bloc/page) |
| `mason make pac_library --name <name> --is_flutter true` | Create shared library package in `packages/<name>` |
| `mason make pac_native_plugin --name <name> --has_ui <bool>` | Create Tri-Platform plugin (Android Kotlin + iOS Swift) |
| `mason make pac_add_native_ui --name <name>` | Upgrade plugin with Jetpack Compose & SwiftUI |
| `mason make remove_pac_feature --name <name>` | Safely remove feature package |
| `mason make remove_pac_subfeature --package_name <pkg> --subfeature_name <name>` | Remove subfeature from package |

> **Native Plugin Architecture**:
> - **Android**: Kotlin 2.1.0, KSP, **Pure Dagger 2** (`PluginComponentProvider` — zero Hilt), and **WorkManager** `DataSyncWorker` for background execution with zero Flutter Engine.
> - **iOS**: Swift Package Manager (`Package.swift`), **FactoryKit 3.3.2** (`SharedContainer`), and **`BGTaskScheduler`** `DataSyncTask` for background execution with zero Flutter Engine.

> 📖 **See**: [Quick Reference](../getting-started/QUICK_REFERENCE.md) for full commands and code templates.


---

## IV. Modern Flutter Stack

| Category | Packages | Purpose |
|----------|----------|---------|
| **State Management** | `flutter_bloc`, `bloc_concurrency` | MVI pattern with BLoC |
| **Dependency Injection** | `get_it`, `injectable` | Auto-registration, lazy singletons |
| **Networking** | `dio`, `retrofit`, `pretty_dio_logger` | Type-safe API clients |
| **Storage** | `hive`, `shared_preferences`, `flutter_secure_storage` | Local persistence |
| **Code Generation** | `freezed`, `json_serializable`, `build_runner`, `mason_cli` | Immutable models, feature scaffolding |
| **Functional** | `dartz`, `equatable` | Either type, value equality |
| **Theming** | `theme_tailor` | Type-safe themes via `context.appThemes` |
| **Localization** | `slang` | Type-safe translations via `context.t` |
| **Logging** | `talker_flutter`, `logger` | Debug logging |
| **Testing** | `mocktail`, `bloc_test` | Mocking, BLoC testing |

---

## V. Code Examples & Best Practices

### 1. Contract Definition (Action/State/Event)

```dart
// ═══════════════ STATE ═══════════════
sealed class WalletState extends BaseState with EquatableMixin {
  const WalletState();
}

class WalletInitial extends WalletState {
  const WalletInitial();
  @override List<Object?> get props => [];
}

class WalletLoading extends WalletState {
  const WalletLoading();
  @override List<Object?> get props => [];
}

class WalletLoaded extends WalletState {
  final WalletEntity wallet;
  const WalletLoaded(this.wallet);
  @override List<Object?> get props => [wallet];
}

class WalletError extends WalletState {
  final String message;
  const WalletError(this.message);
  @override List<Object?> get props => [message];
}

// ═══════════════ ACTION ═══════════════
sealed class WalletAction extends BaseAction {
  const WalletAction();
}

class LoadWalletAction extends WalletAction {
  final String address;
  const LoadWalletAction(this.address);
}

class RefreshWalletAction extends WalletAction {
  const RefreshWalletAction();
}

// ═══════════════ EVENT ═══════════════
sealed class WalletEvent extends BaseEvent {
  const WalletEvent();
}

class ShowSuccessMessageEvent extends WalletEvent {
  final String message;
  const ShowSuccessMessageEvent(this.message);
}

class NavigateToDetailEvent extends WalletEvent {
  final String address;
  const NavigateToDetailEvent(this.address);
}
```

### 2. BLoC Implementation

```dart
@injectable
class WalletBloc extends MviBloc<WalletAction, WalletState, WalletEvent> {
  final GetWalletUseCase _getWalletUseCase;

  WalletBloc({required GetWalletUseCase getWalletUseCase})
      : _getWalletUseCase = getWalletUseCase,
        super(const WalletInitial());

  // Single Entry Point - ONLY method View calls
  @override
  Future<void> onAction(WalletAction action, Emitter<WalletState> emit) async {
    switch (action) {
      case LoadWalletAction(:final address):
        await _loadWallet(address, emit);
      case RefreshWalletAction():
        await _refresh(emit);
    }
  }

  Future<void> _loadWallet(String address, Emitter<WalletState> emit) async {
    emit(const WalletLoading());

    final result = await _getWalletUseCase(address);

    result.fold(
      (failure) {
        emit(WalletError(failure.message));
        emitEvent(ShowErrorMessageEvent(failure.message));
      },
      (wallet) {
        emit(WalletLoaded(wallet));
        emitEvent(const ShowSuccessMessageEvent('Wallet loaded!'));
      },
    );
  }
}
```

### 3. View Implementation

Using `BaseMviPage` (or `BaseMviStatefulPage`) simplifies BLoC provision and event listening.

```dart
@RoutePage()
class WalletPage extends BaseMviPage<WalletBloc, WalletAction, WalletState, WalletEvent> {
  final String address;
  const WalletPage({super.key, required this.address});

  @override
  WalletAction? get initialAction => LoadWalletAction(address);

  @override
  Widget buildPage(BuildContext context, WalletState state) {
    return Scaffold(
      appBar: AppBar(title: Text(context.t.walletTitle)),
      body: switch (state) {
        WalletLoading() => const Center(child: CircularProgressIndicator()),
        WalletLoaded(:final wallet) => _buildContent(context, wallet),
        WalletError(:final message) => Center(child: Text('Error: $message')),
        _ => const SizedBox(),
      },
      floatingActionButton: FloatingActionButton(
        onPressed: () => onAction(context, const RefreshWalletAction()),
        child: const Icon(Icons.refresh),
      ),
    );
  }

  @override
  void onEvent(BuildContext context, WalletEvent event) {
    switch (event) {
      case ShowSuccessMessageEvent(:final message):
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
      case NavigateToDetailEvent(:final address):
        context.router.push(DetailRoute(address: address));
    }
  }

  Widget _buildContent(BuildContext context, WalletEntity wallet) {
    return Column(
      children: [
        Text('Balance: ${wallet.balance}', style: context.appThemes.headlineSmall),
        Text('Address: ${wallet.address}', style: context.appThemes.bodyMedium),
      ],
    );
  }
}
```

### 4. Critical Rules

#### 🎨 Theming (MANDATORY)

```dart
// ✅ ALWAYS use context.appThemes
context.appThemes.bodyMedium.copyWith(color: context.appThemes.primaryColor)
context.appThemes.surfaceColor
context.appThemes.headlineSmall

// ❌ NEVER use Theme.of(context) or hardcoded colors
Theme.of(context).textTheme.bodyMedium  // ❌
Colors.red                               // ❌
Color(0xFF123456)                        // ❌
```

#### 🌐 Localization (MANDATORY)

```dart
// ✅ ALWAYS use context.t
Text(context.t.walletTitle)
Text(context.t.authWelcomeBack)

// ❌ NEVER use hardcoded strings
Text("My Wallet")    // ❌
Text('Welcome Back') // ❌
```

#### ✅ Single Entry Point (MANDATORY)

```dart
// ✅ Correct
context.read<WalletBloc>().onAction(LoadWalletAction(address));

// ❌ Wrong - Multiple entry points
context.read<WalletBloc>().add(LoadWalletAction(address));
context.read<WalletBloc>().loadWallet(address);
```

#### ✅ After Every Change (MANDATORY)

```bash
# 1. Format code
dart format lib/

# 2. Analyze (MUST show "No issues found!")
flutter analyze --no-fatal-infos

# 3. Run code generation (if models/DI changed)
flutter pub run build_runner build --delete-conflicting-outputs
```

### 5. App Initializer Pattern

The `AppInitializer` pattern orchestrates application startup logic in a modular, testable, and deterministic way. Instead of cluttering `main.dart` with initialization calls, each startup task (Logging, Firebase, Analytics, Security) is encapsulated in its own class implementing `AppInitializer` located in `lib/core/app_initializer/`.

Initializers are registered in the DI graph and composed in `lib/di/app_module.dart`:

```dart
@module
abstract class AppModule {
  @singleton
  AppInitializer provideAppInitializer(
    LoggingInitializer loggingInitializer,
    SecurityInitializer securityInitializer,
  ) {
    return AppInitializerImpl([
      loggingInitializer,
      securityInitializer,
    ]);
  }
}
```

In `main.dart`, the composite initializer runs before launching the UI:
```dart
void main() async {
  configureDependencies();
  await getIt<AppInitializer>().init();
  runApp(const MyApp());
}
```

---

## VI. References

- **[Networking Architecture](NETWORKING.md)** - Network layer & Retrofit clients
- **[Quick Reference](../getting-started/QUICK_REFERENCE.md)** - Developer cheat sheet with MVI code templates & commands
- **[Documentation Hub](../README.md)** - Complete documentation directory
- [Clean Architecture by Uncle Bob](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [BLoC Library](https://bloclibrary.dev/)

---

## VII. Summary

### 1. Architecture at a Glance

| Aspect | Implementation |
|--------|---------------|
| **Architecture** | Clean Architecture (3 layers) + MVI |
| **Structure** | Feature packages in `features/` & `packages/` |
| **State Management** | `flutter_bloc` with Action/State/Event |
| **DI** | `get_it` + `injectable` (auto-registration) |
| **Code Generation** | `mason` (features), `build_runner` (models/DI) |
| **Theming** | `theme_tailor` via `context.appThemes` |
| **Localization** | `slang` via `context.coreT` |

### 2. Key Principles

1. ✅ **Unidirectional Data Flow** - View → BLoC → Domain → Data → Domain → BLoC → View
2. ✅ **Separation of Concerns** - Each layer has single responsibility
3. ✅ **Immutability** - All States, Actions, Events, Entities, Models are immutable
4. ✅ **Single Entry Point** - BLoC has only `onAction()` method
5. ✅ **Pure Domain** - No Flutter imports in Domain layer
6. ✅ **Feature-First** - Code organized by feature, not by layer
7. ✅ **Freezed Everywhere** - Use `@freezed` for all data classes (Models, Entities, States, Events)

### 3. Quick Commands

```bash
# Create new feature
mason make mvi_feature --feature_name wallet

# Add to existing feature
mason make mvi_subfeature

# Generate all code
melos genAlls

# Analyze (must show "No issues found!")
flutter analyze --no-fatal-infos
```

---

**This architecture ensures: Scalability • Testability • Maintainability • Consistency**

**Happy Coding! 🚀**
