# Implementation Guide: Creating a New Feature

**Step-by-Step Guide for Creating Features with Clean Architecture + MVI**

This guide will walk you through creating a complete feature from scratch, following the MVI architecture pattern.

---

## 📋 Table of Contents

- [I. Prerequisites](#i-prerequisites)
- [II. Working with AI Agents? Use Task Templates!](#ii-working-with-ai-agents-use-task-templates)
- [III. Deciding: New Module vs Subfeature](#iii-deciding-new-module-vs-subfeature)
- [IV. Option A: Create New Module](#iv-option-a-create-new-module)
- [V. Option B: Add Subfeature to Existing Module](#v-option-b-add-subfeature-to-existing-module)
- [VI. Step 1: Generate Feature Structure](#vi-step-1-generate-feature-structure)
- [VII. Step 2: Define Domain Layer](#vii-step-2-define-domain-layer)
- [VIII. Step 3: Implement Data Layer](#viii-step-3-implement-data-layer)
- [IX. Step 4: Implement Presentation Layer (MVI)](#ix-step-4-implement-presentation-layer-mvi)
- [X. Step 5: Dependency Injection](#x-step-5-dependency-injection)
- [XI. Step 6: Navigation & Integration](#xi-step-6-navigation--integration)
- [XII. Step 7: Testing](#xii-step-7-testing)
- [XIII. Common Pitfalls](#xiii-common-pitfalls)
- [XIV. Checklist](#xiv-checklist)

---

## I. Prerequisites

Before starting, ensure you have:

- [ ] Flutter SDK installed
- [ ] Project dependencies installed: `flutter pub get`
- [ ] Mason CLI installed: `mason get`
- [ ] Basic understanding of Clean Architecture
- [ ] Basic understanding of MVI pattern (read [ARCHITECTURE.md](../architecture/ARCHITECTURE.md))
- [ ] Understanding of Theme Tailor usage (see below)

---

## II. Working with AI Agents? Use Task Templates!

**⭐ IMPORTANT**: If you're working with AI agents (Cursor, GitHub Copilot, ChatGPT, etc.), use our **Task Prompt Templates** for better results:

👉 **[Task Prompt Templates Guide](../task-prompt-templates/README.md)**

### 1. Why Use Templates?

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

### 2. Available Templates:

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

### 3. Quick Start with Templates:

```bash
# 1. Choose the right template based on your task
# 2. Open the template file
# 3. Copy the template structure
# 4. Fill in your specific requirements
# 5. Attach relevant files using @file or @folder
# 6. Submit to AI agent
# 7. Review the AI's plan before proceeding
```

### 4. Example: Assigning "Add Forgot Password" Task

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

### 5. 💡 Pro Tip:

**Always use task templates when:**
- 🎯 Creating any new feature or subfeature
- 🐛 Fixing bugs (especially complex ones)
- 🔧 Refactoring code
- 🎨 Updating UI/styling
- 🤖 Working with AI agents

**This saves time and ensures quality!**

---

## III. Theme & Styling Guidelines

### 1. Using Theme Tailor (MANDATORY)

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

#### 2. Adding New Colors

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

#### 3. Available Text Styles

- Display: `displayLarge`, `displayMedium`, `displaySmall`
- Headline: `headlineLarge`, `headlineMedium`, `headlineSmall`
- Title: `titleLarge`, `titleMedium`, `titleSmall`
- Body: `bodyLarge`, `bodyMedium`, `bodySmall`
- Label: `labelLarge`, `labelMedium`, `labelSmall`
- Emphasized variants: Add `Emphasized` suffix (e.g., `bodyMediumEmphasized`)

---

## III. Deciding: New Module vs Subfeature

Before creating a feature, analyze the codebase and determine whether you need a new module or a subfeature:

### 1. Decision Workflow

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

### 2. Use `mvi_feature` (New Module) When:

- ✅ Creating a completely new domain concept
- ✅ Feature has entirely different data and business logic
- ✅ Feature needs its own repository and data sources
- ✅ No existing module handles this domain
- ✅ Feature is independent from other modules

**Examples**: Authentication (first time), Wallet (first time), Profile (first time), Settings, Notifications

### 3. Use `mvi_subfeature` (Add to Existing Module) When:

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

### 4. Decision Tree

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

### 5. Quick Reference

| Scenario | Module Exists? | Template | Example |
|----------|----------------|----------|---------|
| Create auth system | ❌ No | `mvi_feature` | New authentication module |
| Add forgot password | ✅ auth exists | `mvi_subfeature` | Add to authentication |
| Create wallet | ❌ No | `mvi_feature` | New wallet module |
| Add transfer money | ✅ wallet exists | `mvi_subfeature` | Add to wallet |
| Create profile | ❌ No | `mvi_feature` | New profile module |
| Add edit profile | ✅ profile exists | `mvi_subfeature` | Add to profile |

---

## IV. Option A: Create New Module

Follow these steps when creating a new module with `mvi_feature`:

*(Details continue as per standard Mason usage...)*

---

## V. Option B: Add Subfeature to Existing Module

Follow these steps when adding a subfeature with `mvi_subfeature`:

### 1. Generate Subfeature Structure

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

### 2. Implement Use Case

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

### 3. Add Action to Bloc

Open `lib/features/{module}/presentation/{module}/{module}_action.dart`:

```dart
// Add new action
class ForgotPasswordAction extends AuthenticationAction {
  final String email;
  const ForgotPasswordAction(this.email);
}
```

### 4. Handle Action in Bloc

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

### 5. Update Repository

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

### 6. Update Data Source

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

### 7. Add Translations

Add to `assets/locales/en.i18n.json` and `assets/locales/vi.i18n.json`:

```json
{
  "authForgotPasswordTitle": "Forgot Password",
  "authForgotPasswordButton": "Send Reset Link"
}
```

### 8. Implement Page UI

Edit `lib/features/{module}/presentation/pages/{subfeature}_page.dart` to implement your UI using:
- ✅ `context.t` for translations
- ✅ `context.appThemes` for styling
- ✅ BlocBuilder/BlocProvider for state management

### 9. Add Route

Add route in `lib/app_router.dart`:

```dart
AutoRoute(page: ForgotPasswordRoute.page, path: '/forgot-password'),
```

### 10. Run Code Generation

```bash
melos genAlls
dart format lib/
flutter analyze --no-fatal-infos  # Must be 0 issues
```

**For detailed subfeature guide, see**: `docs/mason/MASON_GUIDE.md`

---

## VI. Step 1: Generate Feature Structure

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

## VII. Step 2: Define Domain Layer

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

## VIII. Step 3: Implement Data Layer

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

  TransactionRemoteDataSourceImpl(this.dio);

  @override
  Future<TransactionModel> getTransaction(String id) async {
    try {
      final response = await dio.get('/transactions/$id');
      if (response.statusCode == 200) {
        return TransactionModel.fromJson(response.data);
      } else {
        throw ServerException('Failed to load transaction');
      }
    } catch (e) {
      throw ServerException(e.toString());
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
        throw ServerException('Failed to load transactions');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<TransactionModel> createTransaction(TransactionModel model) async {
    try {
      final response = await dio.post('/transactions', data: model.toJson());
      if (response.statusCode == 201) {
        return TransactionModel.fromJson(response.data);
      } else {
        throw ServerException('Failed to create transaction');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
```

### 3.3 Implement Repository

**File:** `lib/features/transaction/data/repositories/transaction_repository_impl.dart`

```dart
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasources/transaction_remote_datasource.dart';
import '../models/transaction_model.dart';

@LazySingleton(as: TransactionRepository)
class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDataSource remoteDataSource;

  TransactionRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, TransactionEntity>> getTransaction(String id) async {
    try {
      final model = await remoteDataSource.getTransaction(id);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TransactionEntity>>> getAllTransactions() async {
    try {
      final models = await remoteDataSource.getAllTransactions();
      final entities = models.map((m) => m.toEntity()).toList();
      return Right(entities);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, TransactionEntity>> createTransaction(TransactionEntity entity) async {
    try {
      final model = TransactionModel.fromEntity(entity);
      final createdModel = await remoteDataSource.createTransaction(model);
      return Right(createdModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
```

---

## IX. Step 4: Implement Presentation Layer (MVI)

### 4.1 Define State

**File:** `lib/features/transaction/presentation/transaction/transaction_state.dart`

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/architecture/mvi_base.dart';
import '../../domain/entities/transaction_entity.dart';

part 'transaction_state.freezed.dart';

@freezed
class TransactionState extends BaseState with _$TransactionState {
  const factory TransactionState.initial() = TransactionInitial;
  const factory TransactionState.loading() = TransactionLoading;
  const factory TransactionState.loaded({required List<TransactionEntity> transactions}) = TransactionLoaded;
  const factory TransactionState.error({required String message}) = TransactionError;
}
```

### 4.2 Define Action

**File:** `lib/features/transaction/presentation/transaction/transaction_action.dart`

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/architecture/mvi_base.dart';

part 'transaction_action.freezed.dart';

@freezed
class TransactionAction extends BaseAction with _$TransactionAction {
  const factory TransactionAction.loadTransactions() = LoadTransactions;
  const factory TransactionAction.createTransaction({
    required double amount,
    required String toAddress,
  }) = CreateTransaction;
}
```

### 4.3 Define Event (Side Effects)

**File:** `lib/features/transaction/presentation/transaction/transaction_event.dart`

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/architecture/mvi_base.dart';

part 'transaction_event.freezed.dart';

@freezed
class TransactionEvent extends BaseEvent with _$TransactionEvent {
  const factory TransactionEvent.showSuccess({required String message}) = ShowSuccess;
  const factory TransactionEvent.showError({required String message}) = ShowError;
  const factory TransactionEvent.navigateToDetails({required String transactionId}) = NavigateToDetails;
}
```

### 4.4 Implement BLoC

**File:** `lib/features/transaction/presentation/transaction/transaction_bloc.dart`

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/architecture/mvi_bloc.dart';
import '../../domain/usecases/get_transaction_usecase.dart';
import '../../domain/usecases/create_transaction_usecase.dart';
import 'transaction_action.dart';
import 'transaction_state.dart';
import 'transaction_event.dart';

@injectable
class TransactionBloc extends MviBloc<TransactionAction, TransactionState, TransactionEvent> {
  final GetTransactionUseCase _getTransactionUseCase;
  final CreateTransactionUseCase _createTransactionUseCase;

  TransactionBloc(
    this._getTransactionUseCase,
    this._createTransactionUseCase,
  ) : super(const TransactionState.initial());

  @override
  Future<void> onAction(TransactionAction action) async {
    action.when(
      loadTransactions: () async {
        emit(const TransactionState.loading());
        // Simulating getting all transactions (assuming usecase exists)
        // In real app, you would call getAllTransactionsUseCase
        await Future.delayed(const Duration(seconds: 1));
        emit(const TransactionState.loaded(transactions: []));
      },
      createTransaction: (amount, toAddress) async {
        emit(const TransactionState.loading());
        
        final result = await _createTransactionUseCase(
          amount: amount,
          toAddress: toAddress,
          fromAddress: 'me', // Hardcoded for example
          currency: 'USD',
        );

        result.fold(
          (failure) {
            emit(TransactionState.error(message: failure.message));
            emitEvent(TransactionEvent.showError(message: failure.message));
          },
          (transaction) {
            emit(TransactionState.loaded(transactions: [transaction]));
            emitEvent(const TransactionEvent.showSuccess(message: 'Transaction created!'));
          },
        );
      },
    );
  }
}
```

---

## X. Step 5: Dependency Injection

Verify that all your classes have proper `@injectable` annotations.

1.  **Run build runner:**
    ```bash
    flutter pub run build_runner build --delete-conflicting-outputs
    ```
    
2.  **Verify `lib/di/injection.config.dart`** contains your new classes.

---

## XI. Step 6: Navigation & Integration

### 1. Add Route to AppRouter

**File:** `lib/app_router.dart`

```dart
@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  
  @override
  List<AutoRoute> get routes => [
    // ... existing routes
    AutoRoute(page: TransactionRoute.page, path: '/transaction'),
  ];
}
```

### 2. Add Entry Point

Add a button in Home page to navigate to your new feature:

```dart
ElevatedButton(
  onPressed: () => context.router.push(const TransactionRoute()),
  child: const Text('Go to Transactions'),
)
```

---

## XII. Step 7: Testing

### 1. Unit Tests (Bloc)

**File:** `test/features/transaction/presentation/transaction_bloc_test.dart`

```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:your_app/features/transaction/presentation/transaction/transaction_bloc.dart';

void main() {
  group('TransactionBloc', () {
    late TransactionBloc bloc;
    late MockCreateTransactionUseCase mockCreateTransactionUseCase;

    setUp(() {
      mockCreateTransactionUseCase = MockCreateTransactionUseCase();
      bloc = TransactionBloc(..., mockCreateTransactionUseCase);
    });

    blocTest<TransactionBloc, TransactionState>(
      'emits [Loading, Loaded] when CreateTransaction is added and succeeds',
      build: () {
        when(mockCreateTransactionUseCase(...))
            .thenAnswer((_) async => Right(tTransaction));
        return bloc;
      },
      act: (bloc) => bloc.add(const TransactionAction.createTransaction(...)),
      expect: () => [
        const TransactionState.loading(),
        const TransactionState.loaded(transactions: [tTransaction]),
      ],
    );
  });
}
```

---

## XIII. Common Pitfalls

1.  **Forgetting `@injectable`**: If DI fails, check if you added the annotation.
2.  **Importing Flutter in Domain**: Check imports in domain layer.
3.  **Mutable State**: Ensure State classes are immutable (using `@freezed`).
4.  **Business Logic in UI**: UI should only dispatch Actions and render State.

---

## XIV. Checklist

- [ ] Domain entities created (Pure Dart)
- [ ] Repository interface defined
- [ ] Use cases implemented and tested
- [ ] Data models created (DTOs with `fromJson`)
- [ ] Remote data source implemented
- [ ] Repository implementation completed
- [ ] State, Action, Event defined
- [ ] Bloc implemented with error handling
- [ ] DI configured and generated
- [ ] UI implemented using MVI pattern
- [ ] Navigation route added
