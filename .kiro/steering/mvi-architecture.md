---
title: MVI Architecture Patterns
description: MVI (Model-View-Intent) pattern implementation guide
inclusion: always
---

# MVI Architecture Patterns

> [!IMPORTANT]
> This project uses MVI (Model-View-Intent) pattern with BLoC for state management.

## MVI Flow

```
User Action → Intent (Action) → BLoC → State + Side Effects → UI Update
```

### Key Components

1. **Actions (Intents)**: User intentions or system events
2. **States**: UI state representations
3. **Events (Side Effects)**: One-time effects (navigation, snackbars, etc.)
4. **BLoC**: Business logic coordinator

## File Structure

```
lib/features/{feature_name}/
├── data/
│   ├── datasources/
│   │   ├── {feature}_remote_datasource.dart
│   │   └── {feature}_local_datasource.dart
│   ├── models/
│   │   └── {entity}_model.dart
│   └── repositories/
│       └── {feature}_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── {entity}.dart
│   ├── repositories/
│   │   └── {feature}_repository.dart
│   └── usecases/
│       └── {usecase}_usecase.dart
└── presentation/
    ├── bloc/
    │   ├── {feature}_bloc.dart
    │   ├── {feature}_action.dart
    │   ├── {feature}_state.dart
    │   └── {feature}_event.dart
    ├── pages/
    │   └── {feature}_page.dart
    └── widgets/
        └── {widget_name}_widget.dart
```

## Action Pattern

Actions represent user intents or system events.

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet_action.freezed.dart';

@freezed
sealed class WalletAction with _$WalletAction {
  const factory WalletAction.load() = LoadWalletAction;
  const factory WalletAction.refresh() = RefreshWalletAction;
  const factory WalletAction.selectWallet(String id) = SelectWalletAction;
  const factory WalletAction.deleteWallet(String id) = DeleteWalletAction;
}
```

## State Pattern

States represent the UI state at any given moment.

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:bloc_digital_wallet/features/wallet/domain/entities/wallet_entity.dart';

part 'wallet_state.freezed.dart';

@freezed
class WalletState with _$WalletState {
  const factory WalletState.initial() = WalletInitialState;
  const factory WalletState.loading() = WalletLoadingState;
  const factory WalletState.loaded({
    required List<WalletEntity> wallets,
    WalletEntity? selectedWallet,
  }) = WalletLoadedState;
  const factory WalletState.error(String message) = WalletErrorState;
}
```

## Event Pattern (Side Effects)

Events are one-time effects that don't affect state.

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet_event.freezed.dart';

@freezed
sealed class WalletEvent with _$WalletEvent {
  const factory WalletEvent.showSuccess(String message) = ShowSuccessEvent;
  const factory WalletEvent.showError(String message) = ShowErrorEvent;
  const factory WalletEvent.navigateToDetail(String walletId) = NavigateToDetailEvent;
}
```

## BLoC Pattern

BLoC handles actions and emits states/events.

```dart
import 'package:bloc_digital_wallet/core/architecture/mvi_bloc.dart';
import 'package:bloc_digital_wallet/features/wallet/domain/usecases/get_wallets_usecase.dart';
import 'package:bloc_digital_wallet/features/wallet/presentation/bloc/wallet_action.dart';
import 'package:bloc_digital_wallet/features/wallet/presentation/bloc/wallet_state.dart';
import 'package:bloc_digital_wallet/features/wallet/presentation/bloc/wallet_event.dart';
import 'package:injectable/injectable.dart';

@injectable
class WalletBloc extends MviBloc<WalletAction, WalletState, WalletEvent> {
  final GetWalletsUseCase _getWalletsUseCase;

  WalletBloc(this._getWalletsUseCase) : super(const WalletState.initial()) {
    on<LoadWalletAction>(_onLoadWallet);
    on<RefreshWalletAction>(_onRefreshWallet);
    on<SelectWalletAction>(_onSelectWallet);
    on<DeleteWalletAction>(_onDeleteWallet);
  }

  Future<void> _onLoadWallet(
    LoadWalletAction action,
    Emitter<WalletState> emit,
  ) async {
    emit(const WalletState.loading());
    
    final result = await _getWalletsUseCase();
    
    result.fold(
      (failure) {
        emit(WalletState.error(failure.message));
        addEvent(WalletEvent.showError(failure.message));
      },
      (wallets) {
        emit(WalletState.loaded(wallets: wallets));
      },
    );
  }

  Future<void> _onRefreshWallet(
    RefreshWalletAction action,
    Emitter<WalletState> emit,
  ) async {
    // Keep current state while refreshing
    final result = await _getWalletsUseCase();
    
    result.fold(
      (failure) => addEvent(WalletEvent.showError(failure.message)),
      (wallets) => emit(WalletState.loaded(wallets: wallets)),
    );
  }

  Future<void> _onSelectWallet(
    SelectWalletAction action,
    Emitter<WalletState> emit,
  ) async {
    state.mapOrNull(
      loaded: (loadedState) {
        final selected = loadedState.wallets.firstWhere(
          (w) => w.id == action.id,
        );
        emit(loadedState.copyWith(selectedWallet: selected));
        addEvent(WalletEvent.navigateToDetail(action.id));
      },
    );
  }

  Future<void> _onDeleteWallet(
    DeleteWalletAction action,
    Emitter<WalletState> emit,
  ) async {
    // Implementation
  }
}
```

## Page Pattern

Pages use BlocProvider and listen to states/events.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_digital_wallet/core/utils/extensions/build_context_extension.dart';
import 'package:bloc_digital_wallet/di/injection.dart';
import 'package:bloc_digital_wallet/features/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:bloc_digital_wallet/features/wallet/presentation/bloc/wallet_action.dart';
import 'package:bloc_digital_wallet/features/wallet/presentation/bloc/wallet_state.dart';
import 'package:bloc_digital_wallet/features/wallet/presentation/bloc/wallet_event.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<WalletBloc>()..onAction(const WalletAction.load()),
      child: const _WalletView(),
    );
  }
}

class _WalletView extends StatelessWidget {
  const _WalletView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.t.walletTitle),
        backgroundColor: context.appThemes.primaryColor,
      ),
      body: BlocConsumer<WalletBloc, WalletState>(
        listener: _handleEvents,
        builder: (context, state) {
          return state.when(
            initial: () => const SizedBox.shrink(),
            loading: () => const Center(child: CircularProgressIndicator()),
            loaded: (wallets, selectedWallet) => _buildWalletList(context, wallets),
            error: (message) => Center(
              child: Text(
                message,
                style: context.appThemes.bodyMedium,
              ),
            ),
          );
        },
      ),
    );
  }

  void _handleEvents(BuildContext context, WalletState state) {
    context.read<WalletBloc>().eventStream.listen((event) {
      event.when(
        showSuccess: (message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
        },
        showError: (message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: context.appThemes.errorColor,
            ),
          );
        },
        navigateToDetail: (walletId) {
          // Navigate to detail page
        },
      );
    });
  }

  Widget _buildWalletList(BuildContext context, List<WalletEntity> wallets) {
    return ListView.builder(
      itemCount: wallets.length,
      itemBuilder: (context, index) {
        final wallet = wallets[index];
        return ListTile(
          title: Text(wallet.name, style: context.appThemes.bodyMedium),
          subtitle: Text(wallet.balance.toString()),
          onTap: () {
            context.read<WalletBloc>().onAction(
              WalletAction.selectWallet(wallet.id),
            );
          },
        );
      },
    );
  }
}
```

## Key Rules

### 1. Single Entry Point
```dart
// ✅ Correct
bloc.onAction(const LoadWalletAction());

// ❌ Wrong
bloc.add(LoadWalletEvent());
```

### 2. State Immutability
```dart
// ✅ Correct - Use copyWith
emit(state.copyWith(selectedWallet: newWallet));

// ❌ Wrong - Don't mutate
state.selectedWallet = newWallet;
```

### 3. Event Handling
```dart
// ✅ Correct - Listen to eventStream
bloc.eventStream.listen((event) {
  event.when(
    showSuccess: (msg) => showSnackBar(msg),
    navigateToDetail: (id) => navigate(id),
  );
});

// ❌ Wrong - Don't emit events as states
emit(NavigateToDetailState(id));
```

### 4. Use Case Integration
```dart
// ✅ Correct - Use Either for error handling
final result = await _getWalletsUseCase();
result.fold(
  (failure) => emit(WalletState.error(failure.message)),
  (wallets) => emit(WalletState.loaded(wallets: wallets)),
);

// ❌ Wrong - Don't use try-catch directly
try {
  final wallets = await _getWalletsUseCase();
  emit(WalletState.loaded(wallets: wallets));
} catch (e) {
  emit(WalletState.error(e.toString()));
}
```

## Clean Architecture Layers

### Domain Layer (Business Logic)
- **Entities**: Business objects (pure Dart, no Flutter)
- **Repositories**: Abstract interfaces
- **Use Cases**: Single responsibility business operations

### Data Layer (Data Handling)
- **Models**: DTOs with JSON serialization
- **Data Sources**: API clients, local storage
- **Repository Implementations**: Concrete implementations

### Presentation Layer (UI)
- **BLoC**: State management
- **Pages**: Screen widgets
- **Widgets**: Reusable UI components

## Dependency Rules

```
Presentation → Domain ← Data
     ↓           ↓        ↓
   BLoC    Use Cases  Repository Impl
     ↓           ↓        ↓
  Pages     Entities   Models
```

**Rules:**
- Domain layer has NO dependencies on other layers
- Data layer depends ONLY on Domain
- Presentation layer depends ONLY on Domain
- Use Dependency Injection (get_it + injectable)

## Common Patterns

### Loading with Data Retention
```dart
// Keep showing old data while loading new data
Future<void> _onRefresh(RefreshAction action, Emitter<State> emit) async {
  // Don't emit loading state, keep current data visible
  final result = await _useCase();
  result.fold(
    (failure) => addEvent(ShowErrorEvent(failure.message)),
    (data) => emit(State.loaded(data: data)),
  );
}
```

### Optimistic Updates
```dart
Future<void> _onDelete(DeleteAction action, Emitter<State> emit) async {
  // Update UI immediately
  state.mapOrNull(
    loaded: (s) => emit(s.copyWith(
      items: s.items.where((i) => i.id != action.id).toList(),
    )),
  );
  
  // Then sync with backend
  final result = await _deleteUseCase(action.id);
  result.fold(
    (failure) {
      // Revert on failure
      addEvent(ShowErrorEvent(failure.message));
      onAction(const LoadAction()); // Reload
    },
    (_) => addEvent(const ShowSuccessEvent('Deleted')),
  );
}
```

### Pagination
```dart
@freezed
class ListState with _$ListState {
  const factory ListState.loaded({
    required List<Item> items,
    required bool hasMore,
    required bool isLoadingMore,
  }) = ListLoadedState;
}

Future<void> _onLoadMore(LoadMoreAction action, Emitter<State> emit) async {
  state.mapOrNull(
    loaded: (s) async {
      if (s.isLoadingMore || !s.hasMore) return;
      
      emit(s.copyWith(isLoadingMore: true));
      
      final result = await _useCase(page: s.items.length ~/ pageSize);
      result.fold(
        (failure) => emit(s.copyWith(isLoadingMore: false)),
        (newItems) => emit(s.copyWith(
          items: [...s.items, ...newItems],
          hasMore: newItems.length == pageSize,
          isLoadingMore: false,
        )),
      );
    },
  );
}
```

## Testing

### BLoC Testing
```dart
blocTest<WalletBloc, WalletState>(
  'emits loaded state when load action succeeds',
  build: () {
    when(() => mockUseCase()).thenAnswer((_) async => Right(mockWallets));
    return WalletBloc(mockUseCase);
  },
  act: (bloc) => bloc.onAction(const WalletAction.load()),
  expect: () => [
    const WalletState.loading(),
    WalletState.loaded(wallets: mockWallets),
  ],
);
```

## Summary

| Component | Purpose | Example |
|-----------|---------|---------|
| **Action** | User intent | `LoadWalletAction` |
| **State** | UI state | `WalletLoadedState` |
| **Event** | Side effect | `ShowSuccessEvent` |
| **BLoC** | Logic coordinator | `WalletBloc` |
| **Page** | UI screen | `WalletPage` |
| **Use Case** | Business operation | `GetWalletsUseCase` |
| **Repository** | Data abstraction | `WalletRepository` |
| **Entity** | Business object | `WalletEntity` |
| **Model** | DTO | `WalletModel` |

---

**Last Updated**: 2026-01-22  
**Status**: Active ✅
