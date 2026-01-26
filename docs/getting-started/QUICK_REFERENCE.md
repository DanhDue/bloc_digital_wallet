# Quick Reference Card

**MVI Architecture - Cheat Sheet**

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

## 🎨 Theme & Styling Rules

### ✅ ALWAYS Use Theme Tailor

```dart
// ❌ NEVER
Theme.of(context).textTheme.bodyMedium
Theme.of(context).colorScheme.surface
Colors.red

// ✅ ALWAYS
context.appThemes.bodyMedium
context.appThemes.surfaceColor
context.appThemes.errorColor
```

### Quick Reference

```dart
// Text Styles
context.appThemes.headlineSmall
context.appThemes.bodyMedium
context.appThemes.labelLarge

// Colors
context.appThemes.primaryColor
context.appThemes.surfaceColor
context.appThemes.textSecondaryColor

// Combined
context.appThemes.bodyMedium.copyWith(
  color: context.appThemes.textSecondaryColor
)
```

---

## 📁 File Structure Template

```
lib/features/{feature}/
├── data/
│   ├── datasources/
│   │   ├── {feature}_remote_datasource.dart
│   │   └── {feature}_local_datasource.dart
│   ├── models/
│   │   └── {feature}_model.dart
│   └── repositories/
│       └── {feature}_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── {feature}_entity.dart
│   ├── repositories/
│   │   └── {feature}_repository.dart
│   └── usecases/
│       └── get_{feature}_usecase.dart
└── presentation/
    ├── models/
    │   └── {feature}_ui_model.dart
    └── {feature}/
        ├── {feature}_action.dart
        ├── {feature}_state.dart
        ├── {feature}_event.dart
        ├── {feature}_bloc.dart
        └── {feature}_page.dart
```

---

## 🚀 Quick Start Commands

### Mason Feature Generation

```bash
# Create new feature module
mason make mvi_feature --feature_name wallet

# Add subfeature to existing module (interactive)
mason make mvi_subfeature
# → What is the module name? authentication
# → What is the subfeature name? forgot_password
# → Entity name (press Enter to use module's main entity)? [Enter]
# → Create a new data model? false
# → Create a new entity? false

# Remove feature module
mason make remove_feature --feature_name wallet

# Remove subfeature
mason make remove_subfeature --module_name authentication --subfeature_name forgot_password
```

### Code Generation & Verification

```bash
# 1. Run code generation
melos genAlls
# OR: flutter pub run build_runner build --delete-conflicting-outputs

# 2. Format code
dart format lib/

# 3. Analyze (must be 0 issues)
flutter analyze --no-fatal-infos

# 4. Test
flutter test

# 5. Run app
flutter run
```

---

## 💻 Code Templates

### Entity (Domain)

```dart
class WalletEntity extends Equatable {
  final String address;
  final double balance;
  
  const WalletEntity({
    required this.address,
    required this.balance,
  });
  
  @override
  List<Object?> get props => [address, balance];
}
```

### Repository Interface (Domain)

```dart
abstract class WalletRepository {
  Future<Either<Failure, WalletEntity>> getWallet(String address);
}
```

### Use Case (Domain)

```dart
@injectable
class GetWalletUseCase {
  final WalletRepository repository;
  
  GetWalletUseCase(this.repository);
  
  Future<Either<Failure, WalletEntity>> call(String address) {
    return repository.getWallet(address);
  }
}
```

### Model (Data)

```dart
@freezed
class WalletModel with _$WalletModel {
  const WalletModel._();
  
  const factory WalletModel({
    required String address,
    required double balance,
  }) = _WalletModel;
  
  factory WalletModel.fromJson(Map<String, dynamic> json) =>
      _$WalletModelFromJson(json);
      
  WalletEntity toEntity() => WalletEntity(
    address: address,
    balance: balance,
  );
}
```

### Action (Presentation)

```dart
sealed class WalletAction extends BaseAction {
  const WalletAction();
}

class LoadWalletAction extends WalletAction {
  final String address;
  const LoadWalletAction(this.address);
}
```

### State (Presentation)

```dart
sealed class WalletState extends BaseState {
  const WalletState();
}

class WalletLoading extends WalletState {}

class WalletLoaded extends WalletState {
  final WalletEntity wallet;
  const WalletLoaded(this.wallet);
}
```

### Event (Presentation)

```dart
sealed class WalletEvent extends BaseEvent {
  const WalletEvent();
}

class ShowSuccessMessage extends WalletEvent {
  final String message;
  const ShowSuccessMessage(this.message);
}
```

### BLoC (Presentation)

```dart
@injectable
class WalletBloc extends MviBloc<WalletAction, WalletState, WalletEvent> {
  final GetWalletUseCase getWalletUseCase;
  
  WalletBloc({required this.getWalletUseCase}) 
      : super(const WalletInitial()) {
    handleAction(null, _onLoadWallet);
  }
  
  @override
  void onAction(WalletAction action) {
    add(action);
  }
  
  Future<void> _onLoadWallet(
    LoadWalletAction action,
    Emitter<WalletState> emit,
  ) async {
    emit(const WalletLoading());
    
    final result = await getWalletUseCase(action.address);
    
    result.fold(
      (failure) {
        emit(WalletError(failure.message));
        emitEvent(ShowErrorMessage(failure.message));
      },
      (wallet) {
        emit(WalletLoaded(wallet));
        emitEvent(const ShowSuccessMessage('Loaded!'));
      },
    );
  }
}
```

### Page (Presentation)

```dart
class WalletPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<WalletBloc>()
        ..onAction(LoadWalletAction('0x123')),
      child: BlocConsumer<WalletBloc, WalletState>(
        // Listen to events
        listener: (context, state) {
          context.read<WalletBloc>().events.listen((event) {
            switch (event) {
              case ShowSuccessMessage(:final message):
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(message)),
                );
            }
          });
        },
        // Build UI based on state
        builder: (context, state) {
          return switch (state) {
            WalletLoading() => CircularProgressIndicator(),
            WalletLoaded(:final wallet) => WalletView(wallet),
            WalletError(:final message) => ErrorView(message),
            _ => SizedBox(),
          };
        },
      ),
    );
  }
}
```

---

## 🎨 Naming Conventions

### Actions
- Pattern: `Verb + Noun + Action`
- Examples: `LoadWalletAction`, `CreateTransactionAction`, `UpdateProfileAction`

### States
- Pattern: `Noun + State/Adjective`
- Examples: `WalletLoading`, `WalletLoaded`, `WalletError`, `WalletInitial`

### Events
- Pattern: `Verb + Noun` or `Show/Navigate + What`
- Examples: `ShowSuccessMessage`, `NavigateToHome`, `TransactionCreated`

### Use Cases
- Pattern: `Verb + Noun + UseCase`
- Examples: `GetWalletUseCase`, `CreateTransactionUseCase`, `DeleteAccountUseCase`

### Files
- Snake case: `wallet_entity.dart`, `transaction_model.dart`, `profile_bloc.dart`

---

## ✅ Architecture Rules

| Rule | Description | Example |
|------|-------------|---------|
| **Unidirectional Flow** | Data flows in one direction | View → BLoC → Domain → Data |
| **Dependency Rule** | Outer depends on inner | Presentation → Domain ← Data |
| **Pure Domain** | No framework dependencies | No `import 'package:flutter/*'` |
| **Single Entry Point** | One method for all actions | `bloc.onAction(action)` only |
| **State vs Event** | State persistent, Event transient | State = what to show, Event = what to do |

---

## ⚠️ Common Mistakes

| ❌ Wrong | ✅ Correct |
|---------|-----------|
| `bloc.add(action)` directly | `bloc.onAction(action)` |
| Flutter imports in Domain | Pure Dart only |
| Multiple entry points | Single `onAction()` |
| Business logic in View | Logic in UseCase |
| Using State for navigation | Use Events |
| Entity with `@JsonKey` | Model with `@freezed` |

---

## 🔧 Dependency Injection

```dart
// Automatically registered with @injectable or @LazySingleton

@injectable
class GetWalletUseCase { }

@LazySingleton(as: WalletRepository)
class WalletRepositoryImpl implements WalletRepository { }

@LazySingleton(as: WalletRemoteDataSource)
class WalletRemoteDataSourceImpl { }

// Usage in BLoC
@injectable
class WalletBloc {
  final GetWalletUseCase useCase;
  WalletBloc({required this.useCase});
}

// Get from DI
final bloc = getIt<WalletBloc>();
```

---

## 🧪 Testing Template

```dart
void main() {
  late GetWalletUseCase useCase;
  late MockWalletRepository mockRepository;

  setUp(() {
    mockRepository = MockWalletRepository();
    useCase = GetWalletUseCase(mockRepository);
  });

  test('should return wallet when repository succeeds', () async {
    // Arrange
    when(() => mockRepository.getWallet(any()))
        .thenAnswer((_) async => Right(tWallet));

    // Act
    final result = await useCase('address');

    // Assert
    expect(result, Right(tWallet));
    verify(() => mockRepository.getWallet('address')).called(1);
  });
}
```

---

## 📦 Essential Packages

```yaml
dependencies:
  flutter_bloc: ^8.1.6
  bloc: ^8.1.4
  bloc_concurrency: ^0.2.5
  get_it: ^9.2.0
  injectable: ^2.5.0
  dartz: ^0.10.1
  equatable: ^2.0.8
  freezed_annotation: ^3.1.0
  dio: ^5.9.0
  hive: ^2.2.3

dev_dependencies:
  freezed: ^3.2.4
  json_serializable: ^6.11.3
  build_runner: ^2.10.4
  injectable_generator: ^2.7.0
  mocktail: ^1.0.4
```

---

## 📚 Documentation

- [docs/architecture/ARCHITECTURE.md](../architecture/ARCHITECTURE.md) - Full architecture guide
- [docs/development/IMPLEMENTATION_GUIDE.md](../development/IMPLEMENTATION_GUIDE.md) - Step-by-step tutorial
- [docs/architecture/VISUAL_GUIDE.md](../architecture/VISUAL_GUIDE.md) - Visual diagrams
- [README.md](../../README.md) - Project overview

---

**Remember:**
- **Action** = User does something
- **State** = What UI shows
- **Event** = What happens once
- **UseCase** = What business logic does
- **Repository** = Where data comes from

**Keep it simple, follow the rules, and code! 🚀**
