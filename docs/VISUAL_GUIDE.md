# Clean Architecture + MVI - Complete Setup ✅

## 🎯 As a Principal Flutter Developer, Your Project Now Has:

### ✅ 1. Architecture: Clean Architecture + MVI
- **Domain Layer**: Pure business logic (entities, repositories, use cases)
- **Data Layer**: Data management (models, data sources, repository implementations)
- **Presentation Layer**: MVI pattern (intents, states, side effects, BLoC)

### ✅ 2. Code Organization: Feature-First
```
lib/features/{feature_name}/
├── data/          # Data layer
├── domain/        # Business logic
└── presentation/  # UI (MVI)
```

### ✅ 3. Modern Flutter Stack
- State Management: flutter_bloc + bloc_concurrency
- DI: get_it + injectable
- Networking: dio + retrofit
- Storage: hive + shared_preferences + secure_storage
- Functional: dartz + equatable
- Code Gen: freezed + json_serializable + mason

---

## 📊 Architecture Diagram

```
┌─────────────────────────────────────────────────────────┐
│                     PRESENTATION LAYER                   │
│                        (MVI Pattern)                     │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  ┌──────────┐    ┌──────────┐    ┌──────────────────┐ │
│  │  Intent  │───▶│   BLoC   │───▶│  State + Side    │ │
│  │(Actions) │    │(Business)│    │  Effects         │ │
│  └──────────┘    └──────────┘    └──────────────────┘ │
│       ▲               │                    │            │
│       │               ▼                    ▼            │
│  ┌────────────────────────────────────────────────┐    │
│  │              View (UI Widgets)                  │    │
│  └────────────────────────────────────────────────┘    │
│                                                          │
└──────────────────────────────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────┐
│                     DOMAIN LAYER                         │
│                  (Business Logic)                        │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  ┌────────────┐  ┌──────────────┐  ┌────────────────┐ │
│  │  Entities  │  │ Repositories │  │   Use Cases    │ │
│  │ (Business) │  │ (Interfaces) │  │   (Actions)    │ │
│  └────────────┘  └──────────────┘  └────────────────┘ │
│                                                          │
└──────────────────────────────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────┐
│                      DATA LAYER                          │
│                  (Data Management)                       │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  ┌────────────┐  ┌──────────────┐  ┌────────────────┐ │
│  │   Models   │  │ Data Sources │  │  Repositories  │ │
│  │  (DTOs)    │  │ (API/Cache)  │  │(Implementations)│ │
│  └────────────┘  └──────────────┘  └────────────────┘ │
│                                                          │
└──────────────────────────────────────────────────────────┘
```

---

## 🔄 MVI Data Flow

```
1. User taps button
   ↓
2. View dispatches Intent
   context.read<WalletBloc>().add(LoadWalletIntent('123'))
   ↓
3. BLoC receives Intent
   ↓
4. BLoC calls Use Case
   final result = await getWalletUseCase('123')
   ↓
5. Use Case calls Repository
   return repository.getWallet('123')
   ↓
6. Repository fetches from Data Source
   - Try cache first
   - If not cached, fetch from API
   - Cache the result
   ↓
7. Data flows back through layers
   ↓
8. BLoC emits new State
   emit(WalletLoaded(wallet))
   ↓
9. BLoC emits Side Effect (optional)
   emitSideEffect(ShowSuccessMessage('Loaded!'))
   ↓
10. View rebuilds with new State
    BlocBuilder rebuilds UI
    ↓
11. Side Effect triggers one-time action
    Snackbar, Navigation, etc.
```

---

## 📦 What You Can Generate with Mason

```bash
mason make mvi_feature --feature_name wallet
```

**Generates:**
```
lib/features/wallet/
├── data/
│   ├── datasources/
│   │   ├── wallet_remote_datasource.dart    # API calls
│   │   └── wallet_local_datasource.dart     # Cache
│   ├── models/
│   │   └── wallet_model.dart                # DTO with Freezed
│   └── repositories/
│       └── wallet_repository_impl.dart      # Implementation
│
├── domain/
│   ├── entities/
│   │   └── wallet_entity.dart               # Business object
│   ├── repositories/
│   │   └── wallet_repository.dart           # Interface
│   └── usecases/
│       ├── get_wallet_usecase.dart          # Get single
│       └── get_all_wallets_usecase.dart     # Get all
│
└── presentation/
    ├── mvi/
    │   ├── wallet_intent.dart               # User actions
    │   ├── wallet_state.dart                # UI states
    │   ├── wallet_side_effect.dart          # One-time events
    │   └── wallet_bloc.dart                 # Business logic
    └── pages/
        └── wallet_page.dart                 # UI
```

---

## 🎓 Code Examples

### Intent (User Action)
```dart
sealed class WalletIntent extends BaseIntent {}

class LoadWalletIntent extends WalletIntent {
  final String address;
  const LoadWalletIntent(this.address);
}
```

### State (UI State)
```dart
sealed class WalletState extends BaseState {}

class WalletLoading extends WalletState {}

class WalletLoaded extends WalletState {
  final WalletEntity wallet;
  const WalletLoaded(this.wallet);
}
```

### Side Effect (One-time Event)
```dart
sealed class WalletSideEffect extends BaseSideEffect {}

class ShowSuccessMessage extends WalletSideEffect {
  final String message;
  const ShowSuccessMessage(this.message);
}
```

### BLoC (Business Logic)
```dart
class WalletBloc extends MviBloc<
  WalletIntent, 
  WalletState, 
  WalletSideEffect
> {
  final GetWalletUseCase getWalletUseCase;
  
  WalletBloc({required this.getWalletUseCase}) 
      : super(const WalletInitial()) {
    handleIntent(null, _onLoadWallet);
  }
  
  Future<void> _onLoadWallet(
    LoadWalletIntent intent,
    Emitter<WalletState> emit,
  ) async {
    emit(const WalletLoading());
    
    final result = await getWalletUseCase(intent.address);
    
    result.fold(
      (failure) {
        emit(WalletError(failure.message));
        emitSideEffect(ShowErrorMessage(failure.message));
      },
      (wallet) {
        emit(WalletLoaded(wallet));
        emitSideEffect(ShowSuccessMessage('Wallet loaded!'));
      },
    );
  }
}
```

### View (UI)
```dart
class WalletPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<WalletBloc, WalletState>(
        // Listen to side effects
        listener: (context, state) {
          context.read<WalletBloc>().sideEffects.listen((effect) {
            switch (effect) {
              case ShowSuccessMessage(:final message):
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(message)),
                );
              case NavigateToDetail():
                Navigator.push(...);
            }
          });
        },
        // Build UI based on state
        builder: (context, state) {
          return switch (state) {
            WalletInitial() => Text('Press button to load'),
            WalletLoading() => CircularProgressIndicator(),
            WalletLoaded(:final wallet) => WalletView(wallet),
            WalletError(:final message) => ErrorView(message),
          };
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<WalletBloc>().add(
            LoadWalletIntent('address'),
          );
        },
        child: Icon(Icons.refresh),
      ),
    );
  }
}
```

---

## ✅ Checklist for New Features

- [ ] Generate feature with Mason
- [ ] Update entity properties
- [ ] Update model properties
- [ ] Implement remote data source (API)
- [ ] Implement local data source (Cache)
- [ ] Add use cases if needed
- [ ] Register in DI (injectable)
- [ ] Run `build_runner`
- [ ] Customize intents
- [ ] Customize states
- [ ] Customize side effects
- [ ] Implement BLoC handlers
- [ ] Create UI pages
- [ ] Add routing
- [ ] Write tests
- [ ] Format code
- [ ] Add license headers

---

## 🚀 Quick Commands

```bash
# Generate feature
mason make mvi_feature --feature_name auth

# Run code generation
flutter pub run build_runner build --delete-conflicting-outputs

# Format
melos dartfmt

# Test
melos test

# Build
melos build_apk
```

---

## 📚 Documentation

- `docs/ARCHITECTURE.md` - Architecture deep dive
- `docs/MASON_GUIDE.md` - Mason usage
- `docs/QUICK_START.md` - Quick start
- `docs/CLEAN_MVI_SUMMARY.md` - This file
- `README.md` - Project overview

---

**Your project is now production-ready with Clean Architecture + MVI! 🎉**
