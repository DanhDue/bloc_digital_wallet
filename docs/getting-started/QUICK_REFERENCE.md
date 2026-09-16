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

## 🎨 Theme Quick Reference

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

> **Theme do/don't rules** → [FLUTTER_QUALITY_RULES.md §4](../cheat-sheets/FLUTTER_QUALITY_RULES.md#4-theme-usage-rules)

---

## 📁 File Structure Template

```
features/{feature}/lib/
├── data/
│   ├── datasources/
│   │   ├── {feature}_remote_datasource.dart
│   │   └── {feature}_local_datasource.dart
│   ├── models/
│   │   ├── {feature}_model.dart
│   │   ├── {feature}_model.freezed.dart
│   │   └── {feature}_model.g.dart
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
    └── {subfeature}/
        ├── {subfeature}_action.dart
        ├── {subfeature}_state.dart
        ├── {subfeature}_event.dart
        ├── {subfeature}_bloc.dart
        └── {subfeature}_page.dart
```

---

## 🚀 Quick Start Commands

### 1. Dual-Mode Host & Project Setup

```bash
# Initialize/rename new project from template
./scripts/rename_project.sh "My App" my_app com.company.app

# OR initialize in Lean mode (2 tabs: Home, Settings)
./scripts/rename_project.sh "My MVP" my_mvp com.company.mvp --mode lean

# Switch existing checkout between Enterprise (3 tabs) and Lean (2 tabs)
./scripts/configure_mode.sh lean
./scripts/configure_mode.sh enterprise

# Permanently prune Scanner feature in lean mode (clean git tree required)
./scripts/configure_mode.sh lean --prune
```

### 2. Mason Feature & Plugin Generation

```bash
# Create new feature package in features/
mason make pac_mvi_feature --name <feature_name>

# Add subfeature / screen to existing feature package
mason make pac_mvi_subfeature --package_name <feature_name> --subfeature_name <subfeature_name>

# Create shared library in packages/
mason make pac_library --name <library_name> --is_flutter true

# Create Tri-Platform Native Plugin (Pure Dagger 2 + FactoryKit 3.3.2 + BG Workers)
mason make pac_native_plugin --name <plugin_name> --has_ui false   # Headless
mason make pac_native_plugin --name <plugin_name> --has_ui true    # With Compose & SwiftUI

# Upgrade headless plugin to include Native UI (preserves DI and workers)
mason make pac_add_native_ui --name <plugin_name>

# Remove feature package or subfeature
mason make remove_pac_feature --name <feature_name>
mason make remove_pac_subfeature --package_name <feature_name> --subfeature_name <subfeature_name>
```

### 3. Code Generation & Verification

```bash
# 1. Run full code generation pipeline (all packages + root app)
melos genAlls

# 2. Run code generation for single feature
melos genFeature <feature_name>

# 3. Format code with 99 column line length
dart format .

# 4. Analyze all packages (must have zero issues)
melos run analyze

# 5. Run tests across workspace
fvm flutter test

# 6. Run app locally with dev flavor
flutter run --flavor dev --dart-define-from-file=secureFiles/dev/environment-configs.json
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

## ✅ Architecture Rules & Anti-Patterns

> Full do/don't rules → [FLUTTER_QUALITY_RULES.md](../cheat-sheets/FLUTTER_QUALITY_RULES.md) (consolidated source for quality audit skills)  
> Canonical architecture spec → [ARCHITECTURE.md](../architecture/ARCHITECTURE.md)

**Quick reminders:**
- Data flow: `View → BLoC → UseCase → Repository → DataSource`
- Domain layer: **pure Dart only** — no `import 'package:flutter/*'`
- Always `bloc.onAction(action)` — never `bloc.add(event)` directly
- State = persistent UI data · Event = one-time side effect

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

- [docs/getting-started/create-new-project-from-template.vi.md](create-new-project-from-template.vi.md) - Create new project guide (VI)
- [docs/getting-started/template-usage-guide.vi.md](template-usage-guide.vi.md) - Template usage guide by use cases (VI)
- [docs/architecture/ARCHITECTURE.md](../architecture/ARCHITECTURE.md) - Clean Architecture + MVI & Dual-Mode
- [docs/README.md](../README.md) - Central Documentation Hub
- [README.md](../../README.md) - Project overview

---

**Remember:**
- **Action** = User does something
- **State** = What UI shows
- **Event** = What happens once
- **UseCase** = What business logic does
- **Repository** = Where data comes from

**Keep it simple, follow the rules, and code! 🚀**
