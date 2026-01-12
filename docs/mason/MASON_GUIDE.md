# Mason Clean Architecture Guide

This project uses [Mason](https://pub.dev/packages/mason) for code generation following Clean Architecture principles with BLoC pattern.

## 📋 Table of Contents

- [Setup](#setup)
- [Available Bricks](#available-bricks)
- [Usage](#usage)
- [Clean Architecture Structure](#clean-architecture-structure)
- [Examples](#examples)
- [Best Practices](#best-practices)
- [Troubleshooting](#troubleshooting)

---

## 🚀 Setup

### Prerequisites

Mason CLI is already included in the project as a dev dependency. To use Mason commands:

1. **Install Mason globally (optional but recommended):**
   ```bash
   dart pub global activate mason_cli
   ```

2. **Get Mason bricks:**
   ```bash
   melos mason_get
   # or directly
   mason get
   ```

### Verify Installation

```bash
mason --version
melos mason_list
```

---

## 🧱 Available Bricks

### `mvi_feature`

Generates a complete new module following Clean Architecture + MVI pattern.

**When to Use:**
- Creating an entirely new module from scratch
- Feature has completely different domain concepts
- Feature needs its own repository and data sources
- Feature is unrelated to any existing module

**Generated Structure:**
```
lib/features/{feature_name}/
├── data/
│   ├── datasources/
│   │   ├── {feature_name}_remote_data_source.dart
│   │   └── {feature_name}_local_data_source.dart
│   ├── models/
│   │   └── {feature_name}_model.dart
│   └── repositories/
│       └── {feature_name}_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── {feature_name}_entity.dart
│   ├── repositories/
│   │   └── {feature_name}_repository.dart
│   └── usecases/
│       ├── get_{feature_name}_usecase.dart
│       └── get_all_{feature_name}s_usecase.dart
└── presentation/
    ├── bloc/
    │   ├── {feature_name}_bloc.dart
    │   ├── {feature_name}_event.dart
    │   └── {feature_name}_state.dart
    ├── pages/
    │   └── {feature_name}_page.dart
    └── widgets/
        └── {feature_name}_list_widget.dart
```

**Configuration Options:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `feature_name` | string | required | Feature name (e.g., authentication, wallet) |
| `use_equatable` | boolean | true | Use Equatable for value equality |
| `generate_usecase` | boolean | true | Generate use case examples |
| `generate_repository` | boolean | true | Generate repository and data sources |
| `use_freezed` | boolean | true | Use Freezed for data classes |
| `generate_test` | boolean | true | Generate test files |

---

## 💻 Usage

### Interactive Mode (Recommended)

```bash
# Using melos
melos mason_make_feature

# Or directly
mason make clean_feature
```

You'll be prompted for:
- Feature name
- Use Equatable? (Y/n)
- Generate use cases? (Y/n)
- Generate repository? (Y/n)
- Use Freezed? (Y/n)
- Generate tests? (Y/n)

### Command Line Mode

```bash
mason make clean_feature \
  --feature_name authentication \
  --use_equatable true \
  --generate_usecase true \
  --generate_repository true \
  --use_freezed true \
  --generate_test true
```

### Quick Examples

```bash
# Generate wallet feature
mason make clean_feature --feature_name wallet

# Generate transaction feature without tests
mason make clean_feature --feature_name transaction --generate_test false

# Generate profile feature without use cases (direct repository access)
mason make clean_feature --feature_name profile --generate_usecase false
```

---

## 🏗️ Clean Architecture Structure

### Layer Responsibilities

#### **1. Domain Layer (Business Logic)**
- **Entities**: Business objects (pure Dart classes)
- **Repositories**: Abstract interfaces defining data operations
- **Use Cases**: Single-responsibility business logic units

**Characteristics:**
- ✅ No dependencies on other layers
- ✅ Framework-independent
- ✅ Highly testable

#### **2. Data Layer (Data Management)**
- **Models**: Data transfer objects with JSON serialization
- **Data Sources**: Remote (API) and Local (Cache) implementations
- **Repository Implementations**: Concrete implementations of domain repositories

**Characteristics:**
- ✅ Depends on Domain layer
- ✅ Handles data fetching, caching, and mapping
- ✅ Error handling and network logic

#### **3. Presentation Layer (UI)**
- **BLoC**: Business logic components for state management
- **Pages**: Screen widgets
- **Widgets**: Reusable UI components

**Characteristics:**
- ✅ Depends on Domain layer (via use cases)
- ✅ Framework-specific (Flutter)
- ✅ Reactive UI updates

---

## 📚 Examples

### Example 1: Generate Authentication Feature

```bash
mason make clean_feature --feature_name authentication
```

**Post-Generation Steps:**

1. **Run code generation:**
   ```bash
   melos build_runner
   ```

2. **Register dependencies in DI (`lib/di/injection.dart`):**
   ```dart
   // Add to your injectable module
   @module
   abstract class AuthenticationModule {
     @lazySingleton
     AuthenticationRemoteDataSource get remoteDataSource =>
         AuthenticationRemoteDataSourceImpl();
     
     @lazySingleton
     AuthenticationLocalDataSource get localDataSource =>
         AuthenticationLocalDataSourceImpl();
     
     @lazySingleton
     AuthenticationRepository get repository =>
         AuthenticationRepositoryImpl(
           remoteDataSource: get(),
           localDataSource: get(),
         );
     
     @lazySingleton
     GetAuthenticationUseCase get getAuthenticationUseCase =>
         GetAuthenticationUseCase(get());
   }
   ```

3. **Implement data sources:**
   - Add API endpoints in remote data source
   - Add local storage logic in local data source

4. **Update entity and model with your properties:**
   ```dart
   // authentication_entity.dart
   class AuthenticationEntity extends Equatable {
     final String id;
     final String email;
     final String token;
     final DateTime expiresAt;
     
     // ... rest of implementation
   }
   ```

5. **Add routing:**
   ```dart
   // Using AutoRoute
   @MaterialRoute(page: AuthenticationPage)
   ```

### Example 2: Generate Wallet Feature

```bash
mason make clean_feature --feature_name wallet
```

Then customize for blockchain:

```dart
// wallet_entity.dart
class WalletEntity extends Equatable {
  final String address;
  final String privateKey;
  final double balance;
  final String network;
  final List<TransactionEntity> transactions;
  
  // ... implementation
}

// wallet_remote_data_source.dart
class WalletRemoteDataSourceImpl implements WalletRemoteDataSource {
  final Dio dio;
  final BlockchainService blockchainService;
  
  @override
  Future<WalletModel> getWallet(String address) async {
    final balance = await blockchainService.getBalance(address);
    // ... implementation
  }
}
```

---

## ✅ Best Practices

### 1. **Dependency Direction**
Always follow: **Presentation → Domain ← Data**
- Presentation depends on Domain (use cases)
- Data depends on Domain (implements repositories)
- Domain depends on nothing

### 2. **Use Cases**
One use case = One business operation
```dart
// Good ✅
class LoginUserUseCase {
  Future<Either<Failure, User>> call(String email, String password);
}

// Bad ❌
class AuthenticationUseCase {
  Future<User> login();
  Future<void> logout();
  Future<void> register();
  Future<void> resetPassword();
}
```

### 3. **Error Handling**
Use `Either<Failure, Success>` from dartz:
```dart
return await repository.getWallet(id).then(
  (result) => result.fold(
    (failure) => Left(failure),
    (data) => Right(data),
  ),
);
```

### 4. **Entity vs Model**
- **Entity**: Business logic (domain)
- **Model**: Data structure with serialization (data)
- Always map between them in the data layer

### 5. **BLoC Events**
Name events as user actions:
```dart
// Good ✅
class LoginButtonPressed extends AuthEvent {}
class LogoutRequested extends AuthEvent {}

// Bad ❌
class SetAuthState extends AuthEvent {}
class UpdateAuth extends AuthEvent {}
```

### 6. **Testing**
Test each layer independently:
- Domain: Test use cases and entities
- Data: Mock data sources, test repository implementations
- Presentation: Mock use cases, test BLoC logic

---

## 🛠️ Troubleshooting

### Issue: "Mason command not found"

**Solution:**
```bash
# Install Mason CLI globally
dart pub global activate mason_cli

# Add to PATH (if needed)
export PATH="$PATH":"$HOME/.pub-cache/bin"
```

### Issue: Code generation errors after creating feature

**Solution:**
```bash
# Clean and rebuild
melos clean
melos pub_get
melos build_runner
```

### Issue: Import errors in generated code

**Solution:**
1. Ensure all dependencies are in `pubspec.yaml`:
   ```yaml
   dependencies:
     dartz: ^0.10.1
     equatable: ^2.0.8
     flutter_bloc: ^9.1.1
     
   dev_dependencies:
     freezed: ^3.2.4
     json_serializable: ^6.11.3
   ```

2. Run `flutter pub get`

### Issue: Feature not showing in app

**Solution:**
1. Register BLoC in DI container
2. Add page to routing
3. Implement data source TODOs
4. Run build_runner to generate missing files

---

## 🔄 Workflow

Typical workflow for adding a new feature:

```bash
# 1. Generate feature
mason make clean_feature --feature_name payment

# 2. Run code generation
melos build_runner

# 3. Customize entity and model with real properties
# Edit: lib/features/payment/domain/entities/payment_entity.dart
# Edit: lib/features/payment/data/models/payment_model.dart

# 4. Implement data sources
# Edit: lib/features/payment/data/datasources/payment_remote_data_source.dart
# Edit: lib/features/payment/data/datasources/payment_local_data_source.dart

# 5. Register in DI container
# Edit: lib/di/injection.dart

# 6. Add routing
# Edit your routing file (AutoRoute, GoRouter, etc.)

# 7. Run code generation again
melos build_runner

# 8. Format code
melos format

# 9. Add license headers
melos add-license-header

# 10. Test the feature
melos test
```

---

## 📖 Additional Resources

- [Mason Documentation](https://docs.brickhub.dev/)
- [Clean Architecture by Uncle Bob](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [BLoC Pattern](https://bloclibrary.dev/)
- [Dartz Package](https://pub.dev/packages/dartz)
- [Freezed Package](https://pub.dev/packages/freezed)

---

## 🎯 Quick Reference

### Melos Commands

```bash
melos mason_get              # Install Mason bricks
melos mason_make_feature     # Generate new feature
melos mason_list             # List available bricks
melos mason_upgrade          # Upgrade bricks
```

### Mason Commands

```bash
mason list                   # List installed bricks
mason make clean_feature     # Generate feature
mason get                    # Install bricks
mason upgrade               # Upgrade all bricks
mason search                # Search BrickHub
```

---

## 📝 License

Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.
