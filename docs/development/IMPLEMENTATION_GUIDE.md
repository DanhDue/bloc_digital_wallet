# Implementation Guide: Creating a New Feature

**Step-by-Step Guide for Creating Features with Clean Architecture + MVI**

This guide will walk you through creating a complete feature from scratch, following the MVI architecture pattern.

---

## 📋 Table of Contents

1. [Prerequisites](#prerequisites)
2. [Working with AI Agents? Use Task Templates!](#-working-with-ai-agents-use-task-templates)
3. [Deciding: New Module vs Subfeature](#deciding-new-module-vs-subfeature)
4. [Option A: Create New Module](#option-a-create-new-module)
5. [Option B: Add Subfeature to Existing Module](#option-b-add-subfeature-to-existing-module)
6. [Step 1: Generate Feature Structure](#step-1-generate-feature-structure)
7. [Step 2: Define Domain Layer](#step-2-define-domain-layer)
8. [Step 3: Implement Data Layer](#step-3-implement-data-layer)
9. [Step 4: Implement Presentation Layer (MVI)](#step-4-implement-presentation-layer-mvi)
10. [Step 5: Dependency Injection](#step-5-dependency-injection)
11. [Step 6: Navigation & Integration](#step-6-navigation--integration)
12. [Step 7: Testing](#step-7-testing)
13. [Common Pitfalls](#common-pitfalls)
14. [Checklist](#checklist)

---

## Prerequisites

Before starting, ensure you have:

- [ ] Flutter SDK installed
- [ ] Project dependencies installed: `flutter pub get`
- [ ] Mason CLI installed: `mason get`
- [ ] Basic understanding of Clean Architecture
- [ ] Basic understanding of MVI pattern (read [ARCHITECTURE.md](../architecture/ARCHITECTURE.md))
- [ ] Understanding of Theme Tailor usage (see below)

---

## 📝 Working with AI Agents? Use Task Templates!

**⭐ IMPORTANT**: If you're working with AI agents (Cursor, GitHub Copilot, ChatGPT, etc.), use our **Task Prompt Templates** for better results:

👉 **[Task Prompt Templates Guide](../task-prompt-templates/README.md)**

### Why Use Templates?

**Without Templates:**
- ❌ Vague requirements lead to wrong implementations
- ❌ AI agents miss critical rules (theme usage, translations, etc.)
- ❌ Multiple iterations to fix mistakes
- ❌ Inconsistent code patterns
- ❌ Time wasted on corrections

**With Templates:**
- ✅ **Clear, structured task assignments**
- ✅ **All critical rules included automatically**
- ✅ **8 complete real-world examples** to follow
- ✅ **Consistent, high-quality results**
- ✅ **Fewer errors and iterations**
- ✅ **Better AI agent understanding**

### Available Templates:

1. **[Create New Feature](../task-prompt-templates/create-new-feature.md)** 
   - For new modules (e.g., wallet, notifications)
   - For subfeatures (e.g., forgot_password in authentication)
   - Includes 2 complete examples

2. **[Fix Bug](../task-prompt-templates/fix-bug.md)**
   - For fixing bugs and errors
   - Includes root cause analysis steps
   - Includes 2 complete examples

3. **[Refactor Code](../task-prompt-templates/refactor-code.md)**
   - For improving code quality
   - For performance optimization
   - Includes 2 complete examples

4. **[Update UI](../task-prompt-templates/update-ui.md)**
   - For visual/styling changes
   - For redesigning screens
   - Includes 2 complete examples

### Quick Start with Templates:

```bash
# 1. Choose the right template based on your task
# 2. Open the template file
# 3. Copy the template structure
# 4. Fill in your specific requirements
# 5. Attach relevant files using @file or @folder
# 6. Submit to AI agent
# 7. Review the AI's plan before proceeding
```

### Example: Assigning "Add Forgot Password" Task

**❌ Without Template (Vague):**
```
"Add forgot password to the app"
```
Result: AI might create wrong structure, miss translations, use wrong theme patterns, etc.

**✅ With Template (Clear):**
```
See: docs/task-prompt-templates/create-new-feature.md
Example 1: Add Forgot Password Feature

TASK: Add forgot_password as subfeature to authentication module

GOAL: Allow users to reset password via email

MODULE INFORMATION:
- Target module: authentication
- Subfeature name: forgot_password
- Feature type: Subfeature (reuse existing auth module)

REQUIREMENTS:
- Functionality: Email input, send reset link, success confirmation
- UI: Forgot password page with email field
- Validation: Email format validation
- API: POST /auth/forgot-password endpoint

FILES TO REVIEW:
@lib/features/authentication

[... complete structured template ...]
```
Result: AI creates correct structure, follows all rules, implements properly on first try!

### 💡 Pro Tip:

**Always use task templates when:**
- 🎯 Creating any new feature or subfeature
- 🐛 Fixing bugs (especially complex ones)
- 🔧 Refactoring code
- 🎨 Updating UI/styling
- 🤖 Working with AI agents

**This saves time and ensures quality!**

---

## 🎨 Theme & Styling Guidelines

### Using Theme Tailor (MANDATORY)

This project uses `theme_tailor` for centralized theme management. **NEVER** use `Theme.of(context)` directly.

#### ❌ NEVER Do This:
```dart
// ❌ Direct theme access
Text(
  'Hello',
  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
    color: Theme.of(context).colorScheme.onSurfaceVariant,
  ),
)

Container(
  color: Theme.of(context).colorScheme.surface,
)

// ❌ Hardcoded colors
Container(color: Colors.red)
Text('Error', style: TextStyle(color: Colors.red))
```

#### ✅ ALWAYS Do This:
```dart
// ✅ Using context.appThemes
Text(
  'Hello',
  style: context.appThemes.bodyMedium.copyWith(
    color: context.appThemes.textSecondaryColor,
  ),
)

Container(
  color: context.appThemes.surfaceColor,
)

// ✅ Using theme colors
Container(color: context.appThemes.errorColor)
Text('Error', style: context.appThemes.bodyMedium.copyWith(
  color: context.appThemes.errorColor,
))
```

#### Adding New Colors

1. **Add to `assets/colors/colors.xml`**:
```xml
<color name="your_color_name">#HEX_CODE</color>
```

2. **Add field to `lib/config/theme/app_themes.dart`**:
```dart
@override
final Color yourColorName;
```

3. **Initialize in both `light` and `dark` themes**:
```dart
static final light = AppThemes(
  // ... existing colors ...
  yourColorName: AppColors.yourColorName,
);

static final dark = AppThemes(
  // ... existing colors ...
  yourColorName: AppColors.yourColorNameDark, // or adaptive color
);
```

4. **Run code generation**:
```bash
melos genAlls
```

5. **Use in widgets**:
```dart
Container(color: context.appThemes.yourColorName)
```

#### Available Text Styles

- Display: `displayLarge`, `displayMedium`, `displaySmall`
- Headline: `headlineLarge`, `headlineMedium`, `headlineSmall`
- Title: `titleLarge`, `titleMedium`, `titleSmall`
- Body: `bodyLarge`, `bodyMedium`, `bodySmall`
- Label: `labelLarge`, `labelMedium`, `labelSmall`
- Emphasized variants: Add `Emphasized` suffix (e.g., `bodyMediumEmphasized`)

---

## Deciding: New Module vs Subfeature

Before creating a feature, analyze the codebase and determine whether you need a new module or a subfeature:

### Decision Workflow

When you need to add functionality:

1. **ANALYZE** - Check existing modules:
   - Look at `lib/features/` directory
   - Identify if related module exists
   - Determine if feature shares domain concepts
   - Consider architecture implications

2. **DETERMINE** - Choose appropriate approach:
   - New domain concept → `mvi_feature`
   - Extends existing module → `mvi_subfeature`

3. **PLAN** - Consider:
   - Code reuse opportunities
   - Module cohesion
   - Maintenance implications
   - Future extensibility

### Use `mvi_feature` (New Module) When:

- ✅ Creating a completely new domain concept
- ✅ Feature has entirely different data and business logic
- ✅ Feature needs its own repository and data sources
- ✅ No existing module handles this domain
- ✅ Feature is independent from other modules

**Examples**: Authentication (first time), Wallet (first time), Profile (first time), Settings, Notifications

### Use `mvi_subfeature` (Add to Existing Module) When:

- ✅ Related module already exists
- ✅ Adding a feature that shares same domain/data
- ✅ Want to reuse existing repository and bloc
- ✅ Feature is a variation of module's core functionality
- ✅ Maintains module cohesion

**Examples**:
- Add "Forgot Password" to authentication module (auth-related)
- Add "Transfer Money" to wallet module (wallet-related)
- Add "Edit Profile" to profile module (profile-related)
- Add "Transaction History" to wallet module (wallet-related)

### Decision Tree

```
Need to add functionality?
│
├─ Step 1: ANALYZE
│  └─ Check lib/features/ for existing modules
│
├─ Step 2: Does a related module exist?
│  │
│  ├─ YES → Does feature belong to this domain?
│  │         │
│  │         ├─ YES → Use mvi_subfeature ✅
│  │         │         Benefits:
│  │         │         • Reuses repository, bloc, entities
│  │         │         • Maintains module cohesion
│  │         │         • Easier maintenance
│  │         │         Example: add forgot_password to authentication
│  │         │
│  │         └─ NO → Use mvi_feature ✅
│  │                 (Different domain concept)
│  │                 Example: add notifications (separate from auth/wallet)
│  │
│  └─ NO → Use mvi_feature ✅
│            (New domain needs new module)
│            Example: create authentication module
```

### Quick Reference

| Scenario | Module Exists? | Template | Example |
|----------|----------------|----------|---------|
| Create auth system | ❌ No | `mvi_feature` | New authentication module |
| Add forgot password | ✅ auth exists | `mvi_subfeature` | Add to authentication |
| Create wallet | ❌ No | `mvi_feature` | New wallet module |
| Add transfer money | ✅ wallet exists | `mvi_subfeature` | Add to wallet |
| Create profile | ❌ No | `mvi_feature` | New profile module |
| Add edit profile | ✅ profile exists | `mvi_subfeature` | Add to profile |

---

## Option A: Create New Module

Follow these steps when creating a new module with `mvi_feature`:

[Continue with existing steps below...]

---

## Option B: Add Subfeature to Existing Module

Follow these steps when adding a subfeature with `mvi_subfeature`:

### B.1: Generate Subfeature Structure

```bash
mason make mvi_subfeature
```

**Prompts**:
```
? What is the module name? authentication
? What is the subfeature name? forgot_password
? Entity name (press Enter to use module's main entity)? [Press Enter]
? Create a new data model? (y/N) N
? Create a new entity? (y/N) N
```

**What Gets Created**:
```
lib/features/authentication/
  domain/usecases/
    forgot_password_usecase.dart        ✨ NEW
  presentation/
    models/
      forgot_password_ui_model.dart     ✨ NEW
    forgot_password/                    ✨ NEW folder
      forgot_password_action.dart
      forgot_password_bloc.dart
      forgot_password_event.dart
      forgot_password_page.dart
      forgot_password_state.dart
```

### B.2: Implement Use Case

Open `lib/features/{module}/domain/usecases/{subfeature}_usecase.dart` and implement logic:

```dart
@injectable
class ForgotPasswordUseCase {
  final AuthenticationRepository _repository;

  ForgotPasswordUseCase(this._repository);

  Future<Either<Failure, void>> call(String email) async {
    // Add validation
    if (email.isEmpty) {
      return Left(ValidationFailure('Email is required'));
    }
    
    // Call repository
    return await _repository.sendPasswordResetEmail(email);
  }
}
```

### B.3: Add Action to Bloc

Open `lib/features/{module}/presentation/{module}/{module}_action.dart`:

```dart
// Add new action
class ForgotPasswordAction extends AuthenticationAction {
  final String email;
  const ForgotPasswordAction(this.email);
}
```

### B.4: Handle Action in Bloc

Open `lib/features/{module}/presentation/{module}/{module}_bloc.dart`:

```dart
@injectable
class AuthenticationBloc extends MviBloc<AuthenticationAction, AuthenticationState, AuthenticationEvent> {
  final ForgotPasswordUseCase _forgotPasswordUseCase; // Add

  AuthenticationBloc(
    // ... existing
    this._forgotPasswordUseCase, // Add
  ) : super(const AuthenticationInitial());

  @override
  Future<void> onAction(AuthenticationAction action) async {
    switch (action) {
      // Existing cases...
      
      // Add new case
      case ForgotPasswordAction(:final email):
        emit(const AuthenticationLoading());
        final result = await _forgotPasswordUseCase(email);
        result.fold(
          (failure) => emitEvent(ShowErrorMessage(failure.message)),
          (_) => emitEvent(const ShowSuccessMessage('Email sent!')),
        );
    }
  }
}
```

### B.5: Update Repository

**Interface** (`lib/features/{module}/domain/repositories/{module}_repository.dart`):

```dart
abstract class AuthenticationRepository {
  // Add method signature
  Future<Either<Failure, void>> sendPasswordResetEmail(String email);
}
```

**Implementation** (`lib/features/{module}/data/repositories/{module}_repository_impl.dart`):

```dart
@override
Future<Either<Failure, void>> sendPasswordResetEmail(String email) async {
  try {
    await _remoteDataSource.sendPasswordResetEmail(email);
    return const Right(null);
  } on ServerException catch (e) {
    return Left(ServerFailure(e.message));
  }
}
```

### B.6: Update Data Source

Open `lib/features/{module}/data/datasources/{module}_remote_datasource.dart`:

```dart
abstract class AuthRemoteDataSource {
  Future<void> sendPasswordResetEmail(String email);
}

@Injectable(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<void> sendPasswordResetEmail(String email) async {
    final response = await _dio.post('/auth/forgot-password', data: {'email': email});
    if (response.statusCode != 200) {
      throw ServerException('Failed to send email');
    }
  }
}
```

### B.7: Add Translations

Add to `assets/locales/en.i18n.json` and `assets/locales/vi.i18n.json`:

```json
{
  "authForgotPasswordTitle": "Forgot Password",
  "authForgotPasswordButton": "Send Reset Link"
}
```

### B.8: Implement Page UI

Edit `lib/features/{module}/presentation/pages/{subfeature}_page.dart` to implement your UI using:
- ✅ `context.t` for translations
- ✅ `context.appThemes` for styling
- ✅ BlocBuilder/BlocProvider for state management

### B.9: Add Route

Add route in `lib/app_router.dart`:

```dart
AutoRoute(page: ForgotPasswordRoute.page, path: '/forgot-password'),
```

### B.10: Run Code Generation

```bash
melos genAlls
dart format lib/
flutter analyze --no-fatal-infos  # Must be 0 issues
```

**For detailed subfeature guide, see**: `docs/mason/MASON_GUIDE.md`

---

## Step 1: Generate Feature Structure

### 1.1 Generate the feature using Mason

**Option A: Monolith Module (Legacy)**
```bash
mason make mvi_feature --feature_name transaction
```

**Option B: Package Module (Recommended for Modularization)**
```bash
mason make pac_mvi_feature --name transaction
```

> **Note:** The copyright year in generated files is automatically set to the current year via a pre-generation hook. You can also manually specify the year with `--year 2025` if needed.

This generates the complete structure:
```
lib/features/transaction/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
└── presentation/
    ├── models/
    │   └── transaction_ui_model.dart
    └── transaction/
        ├── transaction_action.dart
        ├── transaction_bloc.dart
        ├── transaction_event.dart
        ├── transaction_page.dart
        └── transaction_state.dart
```

---

## Step 2: Define Domain Layer

**⚠️ Important:** Domain layer must be **Pure Dart** - no Flutter/Android imports!

### 2.1 Define Entity

**File:** `lib/features/transaction/domain/entities/transaction_entity.dart`

```dart
import 'package:equatable/equatable.dart';

class TransactionEntity extends Equatable {
  final String id;
  final String fromAddress;
  final String toAddress;
  final double amount;
  final String currency;
  final DateTime timestamp;
  final TransactionStatus status;

  const TransactionEntity({
    required this.id,
    required this.fromAddress,
    required this.toAddress,
    required this.amount,
    required this.currency,
    required this.timestamp,
    required this.status,
  });

  @override
  List<Object?> get props => [
    id,
    fromAddress,
    toAddress,
    amount,
    currency,
    timestamp,
    status,
  ];
}

enum TransactionStatus {
  pending,
  completed,
  failed,
}
```

**✅ Good:** Pure Dart, no framework dependencies  
**❌ Bad:** Importing `package:flutter/material.dart` or using `@JsonKey`

### 2.2 Define Repository Interface

**File:** `lib/features/transaction/domain/repositories/transaction_repository.dart`

```dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/transaction_entity.dart';

abstract class TransactionRepository {
  Future<Either<Failure, TransactionEntity>> getTransaction(String id);
  Future<Either<Failure, List<TransactionEntity>>> getAllTransactions();
  Future<Either<Failure, TransactionEntity>> createTransaction(TransactionEntity entity);
}
```

**Key Points:**
- Use `Either<Failure, Success>` for error handling
- Return domain `Entity`, not data `Model`
- Keep it abstract - implementation in Data layer

### 2.3 Create Use Cases

**File:** `lib/features/transaction/domain/usecases/get_transaction_usecase.dart`

```dart
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/transaction_entity.dart';
import '../repositories/transaction_repository.dart';

@injectable
class GetTransactionUseCase {
  final TransactionRepository repository;

  GetTransactionUseCase(this.repository);

  Future<Either<Failure, TransactionEntity>> call(String id) async {
    return await repository.getTransaction(id);
  }
}
```

**File:** `lib/features/transaction/domain/usecases/create_transaction_usecase.dart`

```dart
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/transaction_entity.dart';
import '../repositories/transaction_repository.dart';

@injectable
class CreateTransactionUseCase {
  final TransactionRepository repository;

  CreateTransactionUseCase(this.repository);

  Future<Either<Failure, TransactionEntity>> call({
    required String fromAddress,
    required String toAddress,
    required double amount,
    required String currency,
  }) async {
    // Business logic validation
    if (amount <= 0) {
      return Left(ValidationFailure(message: 'Amount must be positive'));
    }

    if (fromAddress == toAddress) {
      return Left(ValidationFailure(message: 'Cannot send to same address'));
    }

    // Create entity
    final entity = TransactionEntity(
      id: '', // Will be generated by server
      fromAddress: fromAddress,
      toAddress: toAddress,
      amount: amount,
      currency: currency,
      timestamp: DateTime.now(),
      status: TransactionStatus.pending,
    );

    return await repository.createTransaction(entity);
  }
}
```

**✅ Use Case Best Practices:**
- One use case = One business operation
- Put business logic validation here
- Keep it simple and focused
- Add `@injectable` for DI

---

## Step 3: Implement Data Layer

### 3.1 Create Model (DTO)

**File:** `lib/features/transaction/data/models/transaction_model.dart`

```dart
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/transaction_entity.dart';

part 'transaction_model.freezed.dart';
part 'transaction_model.g.dart';

@freezed
class TransactionModel with _$TransactionModel {
  const TransactionModel._();
  
  const factory TransactionModel({
    required String id,
    required String fromAddress,
    required String toAddress,
    required double amount,
    required String currency,
    required String timestamp,
    required String status,
  }) = _TransactionModel;

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);

  /// Convert model to entity
  TransactionEntity toEntity() {
    return TransactionEntity(
      id: id,
      fromAddress: fromAddress,
      toAddress: toAddress,
      amount: amount,
      currency: currency,
      timestamp: DateTime.parse(timestamp),
      status: _parseStatus(status),
    );
  }

  /// Create model from entity
  factory TransactionModel.fromEntity(TransactionEntity entity) {
    return TransactionModel(
      id: entity.id,
      fromAddress: entity.fromAddress,
      toAddress: entity.toAddress,
      amount: entity.amount,
      currency: entity.currency,
      timestamp: entity.timestamp.toIso8601String(),
      status: entity.status.name,
    );
  }

  TransactionStatus _parseStatus(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return TransactionStatus.completed;
      case 'failed':
        return TransactionStatus.failed;
      default:
        return TransactionStatus.pending;
    }
  }
}
```

### 3.2 Implement Remote Data Source

**File:** `lib/features/transaction/data/datasources/transaction_remote_datasource.dart`

```dart
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/transaction_model.dart';

abstract class TransactionRemoteDataSource {
  Future<TransactionModel> getTransaction(String id);
  Future<List<TransactionModel>> getAllTransactions();
  Future<TransactionModel> createTransaction(TransactionModel model);
}

@LazySingleton(as: TransactionRemoteDataSource)
class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  final Dio dio;

  const TransactionRemoteDataSourceImpl(this.dio);

  @override
  Future<TransactionModel> getTransaction(String id) async {
    try {
      final response = await dio.get('/transactions/$id');
      
      if (response.statusCode == 200) {
        return TransactionModel.fromJson(response.data);
      } else {
        throw ServerException(
          message: 'Failed to get transaction',
          code: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw NetworkException(
        message: e.message ?? 'Network error',
        originalException: e,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<TransactionModel>> getAllTransactions() async {
    try {
      final response = await dio.get('/transactions');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => TransactionModel.fromJson(json)).toList();
      } else {
        throw ServerException(
          message: 'Failed to get transactions',
          code: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw NetworkException(
        message: e.message ?? 'Network error',
        originalException: e,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<TransactionModel> createTransaction(TransactionModel model) async {
    try {
      final response = await dio.post(
        '/transactions',
        data: model.toJson(),
      );
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        return TransactionModel.fromJson(response.data);
      } else {
        throw ServerException(
          message: 'Failed to create transaction',
          code: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw NetworkException(
        message: e.message ?? 'Network error',
        originalException: e,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
```

### 3.3 Implement Local Data Source

**File:** `lib/features/transaction/data/datasources/transaction_local_datasource.dart`

```dart
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/transaction_model.dart';

abstract class TransactionLocalDataSource {
  Future<void> cacheTransaction(TransactionModel model);
  Future<TransactionModel?> getCachedTransaction(String id);
  Future<List<TransactionModel>> getAllCachedTransactions();
  Future<void> clearCache();
}

@LazySingleton(as: TransactionLocalDataSource)
class TransactionLocalDataSourceImpl implements TransactionLocalDataSource {
  static const String boxName = 'transactions';

  @override
  Future<void> cacheTransaction(TransactionModel model) async {
    try {
      final box = await Hive.openBox<Map>(boxName);
      await box.put(model.id, model.toJson());
    } catch (e) {
      throw CacheException(message: 'Failed to cache transaction');
    }
  }

  @override
  Future<TransactionModel?> getCachedTransaction(String id) async {
    try {
      final box = await Hive.openBox<Map>(boxName);
      final json = box.get(id);
      if (json != null) {
        return TransactionModel.fromJson(Map<String, dynamic>.from(json));
      }
      return null;
    } catch (e) {
      throw CacheException(message: 'Failed to get cached transaction');
    }
  }

  @override
  Future<List<TransactionModel>> getAllCachedTransactions() async {
    try {
      final box = await Hive.openBox<Map>(boxName);
      return box.values
          .map((json) => TransactionModel.fromJson(Map<String, dynamic>.from(json)))
          .toList();
    } catch (e) {
      throw CacheException(message: 'Failed to get cached transactions');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      final box = await Hive.openBox<Map>(boxName);
      await box.clear();
    } catch (e) {
      throw CacheException(message: 'Failed to clear cache');
    }
  }
}
```

### 3.4 Implement Repository

**File:** `lib/features/transaction/data/repositories/transaction_repository_impl.dart`

```dart
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasources/transaction_local_datasource.dart';
import '../datasources/transaction_remote_datasource.dart';
import '../models/transaction_model.dart';

@LazySingleton(as: TransactionRepository)
class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDataSource remoteDataSource;
  final TransactionLocalDataSource localDataSource;

  TransactionRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, TransactionEntity>> getTransaction(String id) async {
    try {
      // Try cache first
      final cachedData = await localDataSource.getCachedTransaction(id);
      if (cachedData != null) {
        return Right(cachedData.toEntity());
      }

      // Fetch from remote
      final remoteData = await remoteDataSource.getTransaction(id);
      
      // Cache the result
      await localDataSource.cacheTransaction(remoteData);
      
      return Right(remoteData.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, code: e.code));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TransactionEntity>>> getAllTransactions() async {
    try {
      final remoteData = await remoteDataSource.getAllTransactions();
      
      // Cache all items
      for (final item in remoteData) {
        await localDataSource.cacheTransaction(item);
      }
      
      return Right(remoteData.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      // Try cache on failure
      try {
        final cachedData = await localDataSource.getAllCachedTransactions();
        if (cachedData.isNotEmpty) {
          return Right(cachedData.map((model) => model.toEntity()).toList());
        }
      } catch (_) {}
      
      return Left(ServerFailure(message: e.message, code: e.code));
    } on NetworkException catch (e) {
      // Try cache on network failure
      try {
        final cachedData = await localDataSource.getAllCachedTransactions();
        if (cachedData.isNotEmpty) {
          return Right(cachedData.map((model) => model.toEntity()).toList());
        }
      } catch (_) {}
      
      return Left(NetworkFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, TransactionEntity>> createTransaction(
      TransactionEntity entity) async {
    try {
      final model = TransactionModel.fromEntity(entity);
      final result = await remoteDataSource.createTransaction(model);
      await localDataSource.cacheTransaction(result);
      return Right(result.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
```

**✅ Repository Pattern:**
- Implements Domain interface
- Decides caching strategy (cache-first, network-first, etc.)
- Converts exceptions to failures
- Maps Model ↔ Entity

---

## Step 4: Implement Presentation Layer (MVI)

### 4.1 Define Actions

**File:** `lib/features/transaction/presentation/transaction/transaction_action.dart`

```dart
import '../../../../core/architecture/architecture.dart';

sealed class TransactionAction extends BaseAction {
  const TransactionAction();
}

class LoadAllTransactionsAction extends TransactionAction {
  const LoadAllTransactionsAction();
}

class LoadTransactionAction extends TransactionAction {
  final String id;
  const LoadTransactionAction(this.id);
}

class CreateTransactionAction extends TransactionAction {
  final String fromAddress;
  final String toAddress;
  final double amount;
  final String currency;

  const CreateTransactionAction({
    required this.fromAddress,
    required this.toAddress,
    required this.amount,
    required this.currency,
  });
}

class RefreshTransactionsAction extends TransactionAction {
  const RefreshTransactionsAction();
}
```

### 4.2 Define States

**File:** `lib/features/transaction/presentation/transaction/transaction_state.dart`

```dart
import 'package:equatable/equatable.dart';
import '../../../../core/architecture/architecture.dart';
import '../../domain/entities/transaction_entity.dart';

sealed class TransactionState extends BaseState with EquatableMixin {
  const TransactionState();
}

class TransactionInitial extends TransactionState {
  const TransactionInitial();
  
  @override
  List<Object?> get props => [];
}

class TransactionLoading extends TransactionState {
  const TransactionLoading();
  
  @override
  List<Object?> get props => [];
}

class TransactionsLoaded extends TransactionState {
  final List<TransactionEntity> transactions;
  
  const TransactionsLoaded(this.transactions);
  
  @override
  List<Object?> get props => [transactions];
}

class TransactionLoaded extends TransactionState {
  final TransactionEntity transaction;
  
  const TransactionLoaded(this.transaction);
  
  @override
  List<Object?> get props => [transaction];
}

class TransactionError extends TransactionState {
  final String message;
  
  const TransactionError(this.message);
  
  @override
  List<Object?> get props => [message];
}

class TransactionEmpty extends TransactionState {
  const TransactionEmpty();
  
  @override
  List<Object?> get props => [];
}

class TransactionCreating extends TransactionState {
  const TransactionCreating();
  
  @override
  List<Object?> get props => [];
}
```

### 4.3 Define Events

**File:** `lib/features/transaction/presentation/transaction/transaction_event.dart`

```dart
import '../../../../core/architecture/architecture.dart';

sealed class TransactionEvent extends BaseEvent {
  const TransactionEvent();
}

class ShowSuccessMessage extends TransactionEvent {
  final String message;
  const ShowSuccessMessage(this.message);
}

class ShowErrorMessage extends TransactionEvent {
  final String message;
  const ShowErrorMessage(this.message);
}

class NavigateToTransactionDetail extends TransactionEvent {
  final String id;
  const NavigateToTransactionDetail(this.id);
}

class NavigateBack extends TransactionEvent {
  const NavigateBack();
}

class TransactionCreatedSuccessfully extends TransactionEvent {
  final TransactionEntity transaction;
  const TransactionCreatedSuccessfully(this.transaction);
}
```

### 4.4 Implement BLoC

**File:** `lib/features/transaction/presentation/transaction/transaction_bloc.dart`

```dart
import 'package:injectable/injectable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/architecture/architecture.dart';
import '../../domain/usecases/get_transaction_usecase.dart';
import '../../domain/usecases/get_all_transactions_usecase.dart';
import '../../domain/usecases/create_transaction_usecase.dart';
import 'transaction_action.dart';
import 'transaction_state.dart';
import 'transaction_event.dart';

@injectable
class TransactionBloc extends MviBloc<
  TransactionAction,
  TransactionState,
  TransactionEvent
> {
  final GetTransactionUseCase getTransactionUseCase;
  final GetAllTransactionsUseCase getAllTransactionsUseCase;
  final CreateTransactionUseCase createTransactionUseCase;

  TransactionBloc({
    required this.getTransactionUseCase,
    required this.getAllTransactionsUseCase,
    required this.createTransactionUseCase,
  }) : super(const TransactionInitial()) {
    // Register action handlers
    handleAction(null, _onLoadAllTransactions);
    handleAction(null, _onLoadTransaction);
    handleAction(null, _onCreateTransaction);
    handleAction(null, _onRefreshTransactions);
  }

  /// Single entry point - ONLY method View calls
  @override
  void onAction(TransactionAction action) {
    add(action);
  }

  Future<void> _onLoadAllTransactions(
    LoadAllTransactionsAction action,
    Emitter<TransactionState> emit,
  ) async {
    emit(const TransactionLoading());
    
    final result = await getAllTransactionsUseCase();
    
    result.fold(
      (failure) {
        emit(TransactionError(failure.message));
        emitEvent(ShowErrorMessage(failure.message));
      },
      (transactions) {
        if (transactions.isEmpty) {
          emit(const TransactionEmpty());
        } else {
          emit(TransactionsLoaded(transactions));
        }
      },
    );
  }

  Future<void> _onLoadTransaction(
    LoadTransactionAction action,
    Emitter<TransactionState> emit,
  ) async {
    emit(const TransactionLoading());
    
    final result = await getTransactionUseCase(action.id);
    
    result.fold(
      (failure) {
        emit(TransactionError(failure.message));
        emitEvent(ShowErrorMessage(failure.message));
      },
      (transaction) {
        emit(TransactionLoaded(transaction));
      },
    );
  }

  Future<void> _onCreateTransaction(
    CreateTransactionAction action,
    Emitter<TransactionState> emit,
  ) async {
    emit(const TransactionCreating());
    
    final result = await createTransactionUseCase(
      fromAddress: action.fromAddress,
      toAddress: action.toAddress,
      amount: action.amount,
      currency: action.currency,
    );
    
    result.fold(
      (failure) {
        emit(TransactionError(failure.message));
        emitEvent(ShowErrorMessage(failure.message));
      },
      (transaction) {
        emitEvent(TransactionCreatedSuccessfully(transaction));
        emitEvent(const ShowSuccessMessage('Transaction created successfully!'));
        // Reload transactions list
        add(const LoadAllTransactionsAction());
      },
    );
  }

  Future<void> _onRefreshTransactions(
    RefreshTransactionsAction action,
    Emitter<TransactionState> emit,
  ) async {
    add(const LoadAllTransactionsAction());
  }
}
```

### 4.5 Create Page

> ⚠️ **MVI PAGE PATTERN (CRITICAL)**
> 
> **Default**: Use `StatelessWidget` with `BlocProvider`/`BlocConsumer`
> - All UI state managed in BLoC
> - NO local state with `setState()`
> - Use `context.read<Bloc>().onAction()` to dispatch actions
>
> **Exception**: Use `StatefulWidget` only for `TextEditingController`, `FocusNode`, or `AnimationController`

**File:** `lib/features/transaction/presentation/pages/transaction_list_page.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../di/injection.dart';
import '../mvi/transaction_bloc.dart';
import '../mvi/transaction_action.dart';
import '../mvi/transaction_state.dart';
import '../mvi/transaction_event.dart';

class TransactionListPage extends StatelessWidget {
  const TransactionListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<TransactionBloc>()
        ..onAction(const LoadAllTransactionsAction()),
      child: const _TransactionListView(),
    );
  }
}

class _TransactionListView extends StatelessWidget {
  const _TransactionListView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context
                  .read<TransactionBloc>()
                  .onAction(const RefreshTransactionsAction());
            },
          ),
        ],
      ),
      body: BlocConsumer<TransactionBloc, TransactionState>(
        // Listen to events (side effects)
        listener: (context, state) {
          context.read<TransactionBloc>().events.listen((event) {
            switch (event) {
              case ShowSuccessMessage(:final message):
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(message),
                    backgroundColor: Colors.green,
                  ),
                );
              case ShowErrorMessage(:final message):
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(message),
                    backgroundColor: Colors.red,
                  ),
                );
              case NavigateToTransactionDetail(:final id):
                // Navigator.pushNamed(context, '/transaction/$id');
                break;
              case TransactionCreatedSuccessfully(:final transaction):
                // Handle success
                break;
              case NavigateBack():
                Navigator.of(context).pop();
            }
          });
        },
        // Build UI based on state
        builder: (context, state) {
          return switch (state) {
            TransactionInitial() => const Center(
                child: Text('Press refresh to load transactions'),
              ),
            TransactionLoading() || TransactionCreating() => const Center(
                child: CircularProgressIndicator(),
              ),
            TransactionEmpty() => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.inbox, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    const Text('No transactions found'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context
                            .read<TransactionBloc>()
                            .onAction(const RefreshTransactionsAction());
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            TransactionsLoaded(:final transactions) => RefreshIndicator(
                onRefresh: () async {
                  context
                      .read<TransactionBloc>()
                      .onAction(const RefreshTransactionsAction());
                },
                child: ListView.builder(
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final tx = transactions[index];
                    return ListTile(
                      leading: _StatusIcon(status: tx.status),
                      title: Text('${tx.amount} ${tx.currency}'),
                      subtitle: Text(
                        'From: ${tx.fromAddress}\nTo: ${tx.toAddress}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Text(
                        _formatDate(tx.timestamp),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      onTap: () {
                        context
                            .read<TransactionBloc>()
                            .events
                            .listen((event) {});
                        // Navigate to detail
                      },
                    );
                  },
                ),
              ),
            TransactionError(:final message) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      'Error: $message',
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context
                            .read<TransactionBloc>()
                            .onAction(const RefreshTransactionsAction());
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            _ => const Center(child: Text('Unknown state')),
          };
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to create transaction page
          _showCreateTransactionDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showCreateTransactionDialog(BuildContext context) {
    // Show dialog to create transaction
    // For demo purposes, creating a sample transaction
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Create Transaction'),
        content: const Text('Transaction creation form goes here'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Use the BLoC from the parent context
              context.read<TransactionBloc>().onAction(
                    const CreateTransactionAction(
                      fromAddress: '0x123...',
                      toAddress: '0x456...',
                      amount: 100.0,
                      currency: 'USD',
                    ),
                  );
              Navigator.pop(dialogContext);
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}

class _StatusIcon extends StatelessWidget {
  final TransactionStatus status;

  const _StatusIcon({required this.status});

  @override
  Widget build(BuildContext context) {
    return switch (status) {
      TransactionStatus.completed => const Icon(
          Icons.check_circle,
          color: Colors.green,
        ),
      TransactionStatus.failed => const Icon(
          Icons.error,
          color: Colors.red,
        ),
      TransactionStatus.pending => const Icon(
          Icons.pending,
          color: Colors.orange,
        ),
    };
  }
}
```

---

## Step 5: Dependency Injection

### 5.1 Run Code Generation

```bash
# Generate code for Freezed, Json, and Injectable
flutter pub run build_runner build --delete-conflicting-outputs
```

This generates:
- `transaction_model.freezed.dart`
- `transaction_model.g.dart`
- `injection.config.dart` (updated with new dependencies)

### 5.2 Verify DI Registration

Check `lib/di/injection.config.dart` - your dependencies should be auto-registered because you used `@injectable` and `@LazySingleton`.

---

## Step 6: Navigation & Integration

### 6.1 Add Route

If using named routes:

```dart
// In main.dart or routes file
routes: {
  '/transactions': (context) => const TransactionListPage(),
}
```

### 6.2 Navigate to Feature

```dart
// From any screen
Navigator.pushNamed(context, '/transactions');
```

---

## Step 7: Testing

### 7.1 Test Use Case

**File:** `test/features/transaction/domain/usecases/get_transaction_usecase_test.dart`

```dart
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTransactionRepository extends Mock implements TransactionRepository {}

void main() {
  late GetTransactionUseCase useCase;
  late MockTransactionRepository mockRepository;

  setUp(() {
    mockRepository = MockTransactionRepository();
    useCase = GetTransactionUseCase(mockRepository);
  });

  final tTransaction = TransactionEntity(
    id: '1',
    fromAddress: '0x123',
    toAddress: '0x456',
    amount: 100.0,
    currency: 'USD',
    timestamp: DateTime.now(),
    status: TransactionStatus.completed,
  );

  test('should return transaction when repository succeeds', () async {
    // Arrange
    when(() => mockRepository.getTransaction(any()))
        .thenAnswer((_) async => Right(tTransaction));

    // Act
    final result = await useCase('1');

    // Assert
    expect(result, Right(tTransaction));
    verify(() => mockRepository.getTransaction('1')).called(1);
  });

  test('should return failure when repository fails', () async {
    // Arrange
    when(() => mockRepository.getTransaction(any()))
        .thenAnswer((_) async => Left(ServerFailure(message: 'Error')));

    // Act
    final result = await useCase('1');

    // Assert
    expect(result, Left(ServerFailure(message: 'Error')));
  });
}
```

### 7.2 Test BLoC

```dart
// Run tests
flutter test
```

---

## Common Pitfalls

### ❌ Mistake 1: Importing Flutter in Domain

```dart
// ❌ WRONG - Domain layer should be pure Dart
import 'package:flutter/material.dart';

class TransactionEntity {
  final Color statusColor; // Flutter type!
}
```

```dart
// ✅ CORRECT
class TransactionEntity {
  final TransactionStatus status; // Pure Dart enum
}
```

### ❌ Mistake 2: Multiple Entry Points

```dart
// ❌ WRONG
context.read<TransactionBloc>().add(LoadTransactionsAction());
context.read<TransactionBloc>().loadTransactions(); // Multiple ways!
```

```dart
// ✅ CORRECT - Single entry point
context.read<TransactionBloc>().onAction(LoadAllTransactionsAction());
```

### ❌ Mistake 3: Business Logic in View

```dart
// ❌ WRONG
if (amount > 0 && fromAddress != toAddress) {
  bloc.onAction(CreateTransactionAction(...));
}
```

```dart
// ✅ CORRECT - Validation in Use Case
// Just call the action, validation happens in UseCase
bloc.onAction(CreateTransactionAction(...));
```

### ❌ Mistake 4: Using State for Navigation

```dart
// ❌ WRONG
class TransactionSuccessState {
  final bool shouldNavigate;
}
```

```dart
// ✅ CORRECT - Use Events for one-time actions
class TransactionCreatedSuccessfully extends TransactionEvent {}
```

---

## Checklist

### Before Submitting

- [ ] Domain layer has no Flutter imports
- [ ] All use cases have `@injectable`
- [ ] Repository implements Domain interface
- [ ] Models have `toEntity()` and `fromEntity()`
- [ ] Data sources handle exceptions properly
- [ ] BLoC uses single entry point: `onAction()`
- [ ] Page listens to both State and Events
- [ ] Code generation ran successfully
- [ ] Tests written (at least for use cases)
- [ ] Code formatted: `flutter format .`
- [ ] **No linter errors: `flutter analyze --no-fatal-infos`**
- [ ] **Analyzer shows: "No issues found!"**

### 🔍 Critical Double Check Step

**Run these commands before considering the task complete:**

```bash
# 1. Format all code
flutter format .

# 2. Run analyzer (MUST show "No issues found!")
flutter analyze --no-fatal-infos

# Expected output:
Analyzing bloc_digital_wallet...
No issues found! (ran in X.Xs)

# 3. If ANY errors, warnings, or info messages:
#    - Read each message
#    - Fix the issue
#    - Run flutter analyze again
#    - Repeat until "No issues found!"

# 4. Run tests
flutter test
```

**Success Criteria:**
- ✅ `flutter analyze` output: **"No issues found!"**
- ✅ Exit code: **0**
- ✅ Tests passing
- ✅ All files formatted

### Architecture Compliance

- [ ] **Unidirectional Flow:** View → BLoC → UseCase → Repository → DataSource
- [ ] **Dependency Rule:** Presentation → Domain ← Data
- [ ] **Single Responsibility:** Each class does one thing
- [ ] **Pure Domain:** No framework dependencies
- [ ] **State vs Event:** State is persistent, Event is transient
- [ ] **Feature-First:** Code organized by feature

---

## Summary

**You've learned to:**

1. ✅ Generate feature structure with Mason
2. ✅ Define pure Domain layer (Entity, Repository, UseCase)
3. ✅ Implement Data layer (Model, DataSource, Repository)
4. ✅ Implement Presentation layer (Action, State, Event, BLoC, Page)
5. ✅ Set up Dependency Injection
6. ✅ Handle navigation and integration
7. ✅ Write tests

**Remember:**
- **Action** = User Input (View → BLoC)
- **State** = UI Data (BLoC → View, Persistent)
- **Event** = Side Effect (BLoC → View, One-time)
- **Single Entry Point** = `onAction(action)`
- **Pure Domain** = No Flutter imports

---

**Need help?** Check:
- [ARCHITECTURE.md](../architecture/ARCHITECTURE.md) - Architecture overview
- [docs/architecture/VISUAL_GUIDE.md](../architecture/VISUAL_GUIDE.md) - Visual diagrams
- [docs/architecture/CLEAN_MVI_SUMMARY.md](../architecture/CLEAN_MVI_SUMMARY.md) - Quick reference

**Happy coding! 🚀**
