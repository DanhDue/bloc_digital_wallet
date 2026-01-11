# Architecture: MVI Mechanism
*(Feature-First Clean Architecture)*

This document describes the Data Flow and Naming Conventions used in the Flutter project, following the exact architecture from the Android project.

## 1. Core Concepts

Three core components with specific naming:

| Component | Type | Direction | Meaning & Responsibility |
| :--- | :--- | :--- | :--- |
| **Action** | **INPUT** | **View → ViewModel** | **User actions.** <br> Triggers processing logic (e.g., Click button, Type text). |
| **State** | **DATA** | **ViewModel → View** | **UI state.** <br> Data needed to render the screen (Persistent). View listens to State to rebuild. |
| **Event** | **OUTPUT** | **ViewModel → View** | **One-time events (Side Effect).** <br> UI control commands without state (e.g., Toast, Navigation, Dialog). |

## 2. Data Flow Diagram

**Unidirectional Data Flow:**

```
┌──────────────────────────────────────────────────────────────┐
│                   PRESENTATION LAYER                          │
│                                                               │
│  ┌────────┐   1. Action (Input)    ┌────────────┐           │
│  │  View  │ ──────────────────────> │   BLoC     │           │
│  │(Widget)│                          │(ViewModel) │           │
│  └────────┘                          └────────────┘           │
│      ↑                                     │                  │
│      │ 4. State (Data)                    │ 2. Call UseCase  │
│      │                                     ↓                  │
│      │                          ┌──────────────────┐         │
│      └──────────────────────────┤  5. Event (Side  │         │
│                                  │     Effect)      │         │
│                                  └──────────────────┘         │
└──────────────────────────────────────────────────────────────┘
                                   │
                                   ↓
┌──────────────────────────────────────────────────────────────┐
│                     DOMAIN LAYER                             │
│                                                               │
│  ┌──────────┐   ┌───────────────┐   ┌─────────────────┐    │
│  │ UseCase  │   │  Repository   │   │    Entity       │    │
│  │          │   │  (Interface)  │   │  (Pure Dart)    │    │
│  └──────────┘   └───────────────┘   └─────────────────┘    │
│       │                 │                                    │
│       └─────────────────┘                                    │
└──────────────────────────────────────────────────────────────┘
                          │
                          ↓
┌──────────────────────────────────────────────────────────────┐
│                      DATA LAYER                              │
│                                                               │
│  ┌──────────────┐   ┌──────────────┐   ┌───────────────┐   │
│  │ Repository   │   │ Data Sources │   │    Models     │   │
│  │    Impl      │   │ (Remote/     │   │    (DTOs)     │   │
│  │              │   │  Local)      │   │               │   │
│  └──────────────┘   └──────────────┘   └───────────────┘   │
└──────────────────────────────────────────────────────────────┘
```

## 3. Important Rules

> **⚠️ Critical Architecture Rules:**
>
> 1. **Dependency Rule:** `Presentation` → `Domain` ← `Data`. Presentation CANNOT call Data directly. Domain CANNOT import anything from Presentation or Data.
> 2. **Pure Domain:** Domain layer must be Pure Dart (no Flutter imports). If you see `import 'package:flutter/*'` in Domain, it's wrong.
> 3. **Unidirectional Data Flow:** Data always flows in one circle: `View` → `BLoC` → `Domain` → `Data` → `Domain` → `BLoC` → `View`.
> 4. **Single Entry Point:** View only calls `bloc.onAction(action)`. Never call multiple methods.
> 5. **State vs Event:** State is persistent (what to display). Event is transient (what to do once).

## 4. Layer Details

### 🟢 Presentation Layer (UI & State)

**View (Flutter Widget):**
- Stateless/Stateful widgets
- **Responsibility:** Render UI based on current `State`
- **Principle:** "Dumb View". No business logic, no direct API calls. Only receives data to display and reports user `Action` to BLoC.

**BLoC (ViewModel):**
- **Responsibility:** Manage UI state (`State`), handle `Action` from View, interact with Domain (UseCase)
- **State Holder:** Holds `Stream<State>` for View to listen
- **Event Emitter:** Emits `Stream<Event>` for one-time events (Navigation, Toast)
- **Single Entry Point:** `onAction(action)` is the ONLY method View should call

**Contract (State/Action/Event):**
- Defines communication protocol between View and BLoC

### 🟡 Domain Layer (Business Logic - The Core)

*The heart of the application. Contains pure business logic, no Android/Flutter Framework dependencies.*

**UseCase (Interactor):**
- **Responsibility:** Encapsulates specific business logic (e.g., `LoginUseCase`, `GetWalletBalanceUseCase`)
- **Single Responsibility:** Each UseCase does one thing only
- **Orchestrator:** Coordinates data flow (Call Repository, validate data, calculations...)

**Entity (Domain Model):**
- **Responsibility:** Objects representing business data (e.g., `User`, `Wallet`)
- **Pure Dart:** No library annotations (Freezed, Json). Only essential app data.

**Repository Interface:**
- **Responsibility:** Defines "contract" for data operations (e.g., `Future<User> getUser()`)
- **Abstraction:** Domain doesn't need to know where data comes from (Server or Local DB)

### 🔵 Data Layer (Implementation & Infrastructure)

*Where technical details are implemented. Responsible for providing data to Domain.*

**Repository Implementation:**
- **Responsibility:** Implements Domain's Interface
- **Decision Maker:** Decides where to get data (Cache first or API first?)
- **Coordinator:** Calls DataSource and Maps raw data (DTO) to Entity

**DataSource (Remote/Local):**
- **Remote:** Works with Network (Dio, Retrofit)
- **Local:** Works with Database (Hive, SharedPreferences)

**DTO (Data Transfer Object):**
- **Responsibility:** Data model matching 1:1 with Server response or DB table
- **Annotations:** Contains `@JsonKey`, `@freezed`, etc.

**Mapper:**
- **Responsibility:** Converts between `DTO` ↔ `Entity`. Ensures API changes don't directly affect Domain.

## 5. Implementation Examples

### A. Define Contract

**File:** `features/wallet/presentation/mvi/wallet_contract.dart`

```dart
// 1. STATE: What UI needs to display (Persistent)
@freezed
class WalletState with _$WalletState {
  const factory WalletState.initial() = WalletInitial;
  const factory WalletState.loading() = WalletLoading;
  const factory WalletState.loaded(WalletEntity wallet) = WalletLoaded;
  const factory WalletState.error(String message) = WalletError;
}

// 2. ACTION (INPUT): What user does
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

// 3. EVENT (OUTPUT): Instant control commands (Transient)
sealed class WalletEvent extends BaseEvent {
  const WalletEvent();
}

class NavigateToHome extends WalletEvent {
  const NavigateToHome();
}

class ShowToast extends WalletEvent {
  final String message;
  const ShowToast(this.message);
}
```

### B. Handle in BLoC

**File:** `features/wallet/presentation/mvi/wallet_bloc.dart`

```dart
class WalletBloc extends MviBloc<WalletAction, WalletState, WalletEvent> {
  final GetWalletUseCase getWalletUseCase;

  WalletBloc({required this.getWalletUseCase}) 
      : super(const WalletState.initial()) {
    handleAction(null, _onLoadWallet);
    handleAction(null, _onRefreshWallet);
  }

  // Single entry point - ONLY method View calls
  @override
  void onAction(WalletAction action) {
    add(action);
  }

  Future<void> _onLoadWallet(
    LoadWalletAction action,
    Emitter<WalletState> emit,
  ) async {
    // 1. Update State → Loading
    emit(const WalletState.loading());

    // 2. Call Domain
    final result = await getWalletUseCase(action.address);

    result.fold(
      (failure) {
        // 3. Update State → Error
        emit(WalletState.error(failure.message));
        // 4. Emit Event → Show error
        emitEvent(ShowToast(failure.message));
      },
      (wallet) {
        // 3. Update State → Loaded
        emit(WalletState.loaded(wallet));
        // 4. Emit Event → Show success
        emitEvent(const ShowToast('Wallet loaded!'));
      },
    );
  }
}
```

### C. Display in View

**File:** `features/wallet/presentation/pages/wallet_page.dart`

```dart
@override
Widget build(BuildContext context) {
  return BlocConsumer<WalletBloc, WalletState>(
    // 1. Listen to EVENTS (Side Effects)
    listener: (context, state) {
      context.read<WalletBloc>().events.listen((event) {
        switch (event) {
          case NavigateToHome():
            Navigator.pushNamed(context, '/home');
          case ShowToast(:final message):
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message)),
            );
        }
      });
    },
    
    // 2. Build UI based on STATE
    builder: (context, state) {
      return switch (state) {
        WalletInitial() => Text('Press button to load'),
        WalletLoading() => CircularProgressIndicator(),
        WalletLoaded(:final wallet) => WalletView(wallet),
        WalletError(:final message) => ErrorView(message),
      };
    },
  );
}

// 3. Send ACTION when user interacts
ElevatedButton(
  onPressed: () {
    // Single entry point!
    context.read<WalletBloc>().onAction(
      LoadWalletAction('address'),
    );
  },
  child: Text('Load Wallet'),
)
```

## 6. Naming Conventions

### Actions (User Interactions)
- Pattern: `Verb + Noun + Action`
- Examples:
  - `LoadWalletAction`
  - `CreateTransactionAction`
  - `UpdateProfileAction`
  - `DeleteAccountAction`

### States (UI State)
- Pattern: `Noun + State/Adjective`
- Examples:
  - `WalletInitial`
  - `WalletLoading`
  - `WalletLoaded`
  - `WalletError`

### Events (Side Effects)
- Pattern: `Verb + Noun` or `Show/Navigate + What`
- Examples:
  - `ShowSuccessMessage`
  - `ShowErrorDialog`
  - `NavigateToHome`
  - `NavigateBack`

## 7. Feature-First Organization

```
lib/
├── core/                    # Shared infrastructure
│   ├── architecture/        # MVI base classes
│   ├── errors/             # Failures & exceptions
│   ├── network/            # API clients
│   └── storage/            # Local storage
├── features/               # Feature modules
│   └── wallet/
│       ├── data/           # Data layer
│       │   ├── datasources/
│       │   ├── models/
│       │   └── repositories/
│       ├── domain/         # Business logic
│       │   ├── entities/
│       │   ├── repositories/
│       │   └── usecases/
│       └── presentation/   # UI
│           ├── mvi/        # Contract (Action/State/Event + BLoC)
│           ├── pages/
│           └── widgets/
└── di/                     # Dependency injection
```

---

**This architecture ensures:**
- ✅ Clean separation of concerns
- ✅ Testable at every layer
- ✅ Consistent with Android architecture
- ✅ Scalable and maintainable
- ✅ Feature-first organization
