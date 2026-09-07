# MVI Pattern Guide

**Quick reference for MVI (Model-View-Intent) pattern implementation**

> [!IMPORTANT]
> **Import Convention**: Always use **full package paths** (e.g., `import 'package:bloc_digital_wallet/core/network/app_uri.dart';`) instead of relative imports (e.g., `import '../../core/network/app_uri.dart';`).

---

## 🎯 Core Concepts

```
Action (INPUT)  →  BLoC  →  State (DATA) + Event (OUTPUT)  →  View
```

| Component | Purpose | Example |
|-----------|---------|---------|
| **Action** | User input | `LoadWalletAction('0x123')` |
| **State** | UI data (persistent) | `WalletLoaded(wallet)` |
| **Event** | Side effect (one-time) | `ShowSuccessMessage('Done!')` |

---

## 📋 Pattern Implementation

### Action (User Input)

```dart
sealed class WalletAction extends BaseAction {
  const WalletAction();
}

class LoadWalletAction extends WalletAction {
  final String address;
  const LoadWalletAction(this.address);
}

class CreateTransactionAction extends WalletAction {
  final TransactionEntity transaction;
  const CreateTransactionAction(this.transaction);
}
```

**Rules**:
- Extend `BaseAction`
- Sealed class
- Pattern: `VerbNounAction`

---

### State (Persistent UI Data)

```dart
sealed class WalletState extends BaseState {
  const WalletState();
}

class WalletInitial extends WalletState {}

class WalletLoading extends WalletState {}

class WalletLoaded extends WalletState {
  final WalletEntity wallet;
  const WalletLoaded(this.wallet);
}

class WalletError extends WalletState {
  final String message;
  const WalletError(this.message);
}
```

**Rules**:
- Extend `BaseState` + `EquatableMixin`
- Sealed class
- Pattern: `NounAdjective`
- Use `emit()` in BLoC

---

### Event (One-time Effects)

```dart
sealed class WalletEvent extends BaseEvent {
  const WalletEvent();
}

class ShowSuccessMessage extends WalletEvent {
  final String message;
  const ShowSuccessMessage(this.message);
}

class NavigateToDetail extends WalletEvent {
  final String id;
  const NavigateToDetail(this.id);
}

class TransactionCreated extends WalletEvent {
  final TransactionEntity transaction;
  const TransactionCreated(this.transaction);
}
```

**Rules**:
- Extend `BaseEvent`
- Sealed class
- Pattern: `ShowX`, `NavigateX`, or `VerbNoun`
- Use `emitEvent()` in BLoC
- Listen in widget with `_bloc.events.listen()`

---

### BLoC Implementation

```dart
@injectable
class WalletBloc extends MviBloc<WalletAction, WalletState, WalletEvent> {
  final GetWalletUseCase _getWalletUseCase;
  final CreateTransactionUseCase _createTransactionUseCase;
  
  WalletBloc(
    this._getWalletUseCase,
    this._createTransactionUseCase,
  ) : super(const WalletInitial());
  
  @override
  Future<void> onAction(WalletAction action) async {
    switch (action) {
      case LoadWalletAction(:final address):
        emit(const WalletLoading());
        final result = await _getWalletUseCase(address);
        result.fold(
          (failure) => emit(WalletError(failure.message)),
          (wallet) => emit(WalletLoaded(wallet)),
        );
        
      case CreateTransactionAction(:final transaction):
        final result = await _createTransactionUseCase(transaction);
        result.fold(
          (failure) {
            emit(WalletError(failure.message));
            emitEvent(ShowErrorMessage(failure.message));
          },
          (created) {
            emitEvent(const ShowSuccessMessage('Transaction created!'));
            emitEvent(NavigateToDetail(created.id));
          },
        );
    }
  }
}
```

**Key Points**:
- Extends `MviBloc<Action, State, Event>`
- Single entry point: `onAction(action)`
- Use `emit()` for states
- Use `emitEvent()` for events
- Handle `Either<Failure, Success>` with `.fold()`

---

### Page Implementation

```dart
@RoutePage()
class WalletPage extends StatefulWidget {
  const WalletPage({super.key});
  
  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  late final WalletBloc _bloc;
  late final StreamSubscription<WalletEvent> _eventSub;
  
  @override
  void initState() {
    super.initState();
    _bloc = getIt<WalletBloc>();
    
    // Listen to events stream
    _eventSub = _bloc.events.listen((event) {
      if (!mounted) return;
      switch (event) {
        case ShowSuccessMessage(:final message):
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
        case NavigateToDetail(:final id):
          context.router.push(TransactionDetailRoute(id: id));
        case ShowErrorMessage(:final message):
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: context.appThemes.errorColor,
            ),
          );
      }
    });
    
    // Dispatch initial action
    _bloc.onAction(const LoadWalletAction('0x123'));
  }
  
  @override
  void dispose() {
    _eventSub.cancel();
    _bloc.close();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        body: BlocBuilder<WalletBloc, WalletState>(
          builder: (context, state) {
            return switch (state) {
              WalletInitial() => const SizedBox.shrink(),
              WalletLoading() => const Center(child: CircularProgressIndicator()),
              WalletLoaded(:final wallet) => WalletView(wallet: wallet),
              WalletError(:final message) => ErrorView(message: message),
            };
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // ✅ CORRECT: Single entry point
            _bloc.onAction(const CreateTransactionAction(tTransaction));
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
```

**Key Points**:
- Use `BlocProvider.value` (if BLoC created manually)
- Listen to `_bloc.events.listen()` for one-time effects
- Use `BlocBuilder` for state changes
- Single entry point: `_bloc.onAction(action)`
- Dispose subscriptions and close BLoC

---

## 🔄 Data Flow

```
User Interaction
    ↓
Widget dispatches Action
    ↓
bloc.onAction(action)  ← Single entry point
    ↓
BLoC processes Action
    ↓
BLoC calls UseCase
    ↓
UseCase returns Either<Failure, Success>
    ↓
BLoC handles result:
    - emit(newState)      → BlocBuilder rebuilds UI
    - emitEvent(event)    → events stream triggers side effects
```

---

## ⚠️ Common Mistakes

### ❌ Wrong Patterns

```dart
// 1. Multiple entry points
_bloc.add(SomeAction());  // ❌ Wrong!
_bloc.someMethod();       // ❌ Wrong!
context.read<WalletBloc>().execute();  // ❌ Wrong!

// 2. Using events as actions
_bloc.add(ShowSuccessMessage('Done'));  // ❌ Wrong!

// 3. State logic in widget
if (someCondition) {
  _bloc.onAction(action);  // ❌ Logic should be in BLoC
}

// 4. Not listening to events
// Widget only uses BlocBuilder  // ❌ Missing event handling
```

### ✅ Correct Patterns

```dart
// 1. Single entry point
_bloc.onAction(const LoadWalletAction('0x123'));  // ✅

// 2. Proper event handling
_bloc.events.listen((event) { /* handle */ });  // ✅

// 3. Business logic in BLoC
// Widget only dispatches actions based on user interaction  // ✅

// 4. Both state and event handling
BlocBuilder<WalletBloc, WalletState>(...)  // For state
_bloc.events.listen(...)                    // For events  // ✅
```

---

## 📚 Key Principles

1. **Unidirectional Flow**: Action → BLoC → State/Event → View
2. **Single Entry Point**: Only `bloc.onAction()` for dispatching actions
3. **State vs Event**: State = persistent UI data, Event = one-time effects
4. **Separation of Concerns**: Business logic in BLoC, not in widgets
5. **Type Safety**: Use sealed classes for exhaustive pattern matching

---

**Source**: `docs/architecture/ARCHITECTURE.md`, `docs/development/IMPLEMENTATION_GUIDE.md`
