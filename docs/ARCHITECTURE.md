# Clean Architecture + MVI Pattern

## 🏗️ Architecture Overview

This project follows **Clean Architecture** principles combined with **MVI (Model-View-Intent)** pattern for a robust, scalable, and maintainable codebase.

## 📐 Architecture Layers

### 1. **Domain Layer** (Business Logic)
Pure Dart code, no framework dependencies.

- **Entities**: Business objects representing core data
- **Repositories**: Abstract interfaces for data operations
- **Use Cases**: Single-responsibility business operations

```dart
// Entity
class WalletEntity {
  final String address;
  final double balance;
}

// Repository Interface
abstract class WalletRepository {
  Future<Either<Failure, WalletEntity>> getWallet(String address);
}

// Use Case
class GetWalletUseCase {
  final WalletRepository repository;
  
  Future<Either<Failure, WalletEntity>> call(String address) {
    return repository.getWallet(address);
  }
}
```

### 2. **Data Layer** (Data Management)
Handles data sources and implements domain repositories.

- **Models**: DTOs with JSON serialization (Freezed)
- **Data Sources**: Remote (API) and Local (Cache)
- **Repository Implementations**: Concrete implementations

```dart
// Model
@freezed
class WalletModel with _$WalletModel {
  const factory WalletModel({
    required String address,
    required double balance,
  }) = _WalletModel;
  
  factory WalletModel.fromJson(Map<String, dynamic> json) =>
      _$WalletModelFromJson(json);
}

// Data Source
abstract class WalletRemoteDataSource {
  Future<WalletModel> getWallet(String address);
}

// Repository Implementation
class WalletRepositoryImpl implements WalletRepository {
  final WalletRemoteDataSource remoteDataSource;
  final WalletLocalDataSource localDataSource;
  
  @override
  Future<Either<Failure, WalletEntity>> getWallet(String address) async {
    try {
      // Try cache first
      final cached = await localDataSource.getWallet(address);
      if (cached != null) return Right(cached.toEntity());
      
      // Fetch from remote
      final remote = await remoteDataSource.getWallet(address);
      await localDataSource.cacheWallet(remote);
      
      return Right(remote.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}
```

### 3. **Presentation Layer** (UI) - **MVI Pattern**
Flutter-specific code with MVI architecture.

#### MVI Components:

**Intent** → **BLoC** → **State** + **Side Effects** → **View**

```dart
// Intent: User actions
sealed class WalletIntent extends BaseIntent {
  const WalletIntent();
}

class LoadWalletIntent extends WalletIntent {
  final String address;
  const LoadWalletIntent(this.address);
}

// State: UI state
sealed class WalletState extends BaseState {
  const WalletState();
}

class WalletLoaded extends WalletState {
  final WalletEntity wallet;
  const WalletLoaded(this.wallet);
}

// Side Effect: One-time events
sealed class WalletSideEffect extends BaseSideEffect {
  const WalletSideEffect();
}

class ShowSuccessMessage extends WalletSideEffect {
  final String message;
  const ShowSuccessMessage(this.message);
}

class NavigateToDetail extends WalletSideEffect {
  final String address;
  const NavigateToDetail(this.address);
}

// BLoC: Intent → State transformation
class WalletBloc extends MviBloc<WalletIntent, WalletState, WalletSideEffect> {
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
        emitSideEffect(ShowSuccessMessage('Wallet loaded'));
      },
    );
  }
}
```

## 🔄 MVI Flow

```
User Action (Tap, Swipe, etc.)
    ↓
Intent (LoadWalletIntent)
    ↓
BLoC processes intent
    ↓
Call Use Case
    ↓
Repository fetches data
    ↓
Emit new State (WalletLoaded)
    ↓
Emit Side Effect (ShowSuccessMessage) - optional
    ↓
View rebuilds with new state
Side Effect triggers one-time action (Snackbar, Navigation)
```

## 🎯 Key Principles

### 1. **Unidirectional Data Flow**
Data flows in one direction: Intent → BLoC → State → View

### 2. **Separation of Concerns**
- **Intent**: What the user wants to do
- **State**: What the UI should display
- **Side Effect**: One-time events (navigation, snackbars)

### 3. **Immutability**
All states and intents are immutable (using Freezed/sealed classes)

### 4. **Testability**
Each layer can be tested independently with mocks

### 5. **Feature-First Organization**
Code organized by feature, not by layer:

```
lib/
├── core/                    # Shared code
│   ├── architecture/        # MVI base classes
│   ├── errors/             # Failures & exceptions
│   ├── network/            # API clients
│   └── storage/            # Local storage
├── features/               # Feature modules
│   ├── wallet/            # Feature: Wallet
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   └── transaction/       # Feature: Transaction
│       ├── data/
│       ├── domain/
│       └── presentation/
└── di/                    # Dependency injection
```

## 🛠️ Modern Flutter Stack

### State Management
- **flutter_bloc**: ^9.1.1
- **bloc_concurrency**: ^0.2.5

### Dependency Injection
- **get_it**: ^9.2.0
- **injectable**: ^2.5.0

### Networking
- **dio**: ^5.9.0
- **retrofit**: ^4.9.2

### Code Generation
- **freezed**: ^3.2.4
- **json_serializable**: ^6.11.3
- **build_runner**: ^2.10.4

### Storage
- **hive**: ^2.2.3
- **shared_preferences**: ^2.3.4
- **flutter_secure_storage**: ^10.0.1

### Functional Programming
- **dartz**: ^0.10.1
- **equatable**: ^2.0.8

### Logging
- **talker_flutter**: ^5.1.9
- **logger**: ^2.5.0

## 📝 Code Generation

Generate code using Mason:

```bash
# Install bricks
mason get

# Generate feature
mason make mvi_feature --feature_name wallet

# Run code generation
flutter pub run build_runner build --delete-conflicting-outputs
```

## ✅ Best Practices

### 1. **Intent Naming**
Use verb + noun pattern:
- `LoadWalletIntent`
- `CreateTransactionIntent`
- `UpdateProfileIntent`

### 2. **State Naming**
Use noun + state pattern:
- `WalletLoading`
- `WalletLoaded`
- `WalletError`

### 3. **Side Effect Naming**
Use verb + noun pattern:
- `ShowSuccessMessage`
- `NavigateToDetail`
- `ShowErrorDialog`

### 4. **Use Sealed Classes**
For exhaustive pattern matching:

```dart
sealed class WalletState extends BaseState {}

// Later in View
switch (state) {
  case WalletInitial(): // ...
  case WalletLoading(): // ...
  case WalletLoaded(): // ...
  case WalletError(): // ...
}
```

### 5. **Separate Side Effects from State**
- **State**: What to display
- **Side Effect**: What to do once (navigation, toast, etc.)

```dart
// ❌ Bad: Including navigation in state
class WalletLoadedWithNavigation extends WalletState {
  final WalletEntity wallet;
  final bool shouldNavigate;
}

// ✅ Good: Separate state and side effect
class WalletLoaded extends WalletState {
  final WalletEntity wallet;
}

class NavigateToDetail extends WalletSideEffect {}
```

## 🧪 Testing

### Unit Tests
Test use cases and entities:

```dart
test('should return wallet when repository succeeds', () async {
  when(() => repository.getWallet(any())).thenAnswer(
    (_) async => Right(tWallet),
  );
  
  final result = await useCase('address');
  
  expect(result, Right(tWallet));
});
```

### BLoC Tests
Test intent → state transformations:

```dart
blocTest<WalletBloc, WalletState>(
  'emits [Loading, Loaded] when LoadWalletIntent succeeds',
  build: () => WalletBloc(getWalletUseCase: mockUseCase),
  act: (bloc) => bloc.add(LoadWalletIntent('address')),
  expect: () => [
    WalletLoading(),
    WalletLoaded(tWallet),
  ],
);
```

## 📚 Resources

- [Clean Architecture by Uncle Bob](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [MVI Pattern](https://github.com/oldergod/android-architecture)
- [BLoC Library](https://bloclibrary.dev/)
- [Dartz Documentation](https://pub.dev/packages/dartz)

---

**Happy Coding! 🚀**
