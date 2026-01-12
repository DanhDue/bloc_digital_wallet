# MVI Subfeature Mason Template Guide

## Overview

The `mvi_subfeature` Mason template allows you to add new features to existing modules without creating a completely separate module structure. It's perfect for adding related features that share the same repository, bloc, and domain concepts.

## When to Use

### ✅ Use `mvi_subfeature` When:

- The parent module already exists (e.g., `authentication`, `wallet`, `profile`)
- You want to add a related feature that shares the same data/domain layer
- You want to reuse the existing repository and bloc
- The new feature is a variation or extension of the module's core functionality

### ❌ Use `mvi_feature` Instead When:

- You're creating an entirely new module from scratch
- The feature has completely different domain concepts
- The feature needs its own repository and data sources
- The feature is unrelated to any existing module

## Real-World Examples

### Authentication Module
```bash
# Add "Forgot Password" feature
mason make mvi_subfeature

# Add "Email Verification" feature
mason make mvi_subfeature

# Add "Two-Factor Authentication" feature
mason make mvi_subfeature

# Add "Change Password" feature
mason make mvi_subfeature
```

### Wallet Module
```bash
# Add "Transfer Money" feature
mason make mvi_subfeature

# Add "Transaction History" feature
mason make mvi_subfeature

# Add "Top Up Balance" feature
mason make mvi_subfeature

# Add "Request Money" feature
mason make mvi_subfeature
```

### Profile Module
```bash
# Add "Edit Profile" feature
mason make mvi_subfeature

# Add "Change Avatar" feature
mason make mvi_subfeature

# Add "Privacy Settings" feature
mason make mvi_subfeature

# Add "Account Settings" feature
mason make mvi_subfeature
```

## What Gets Generated

### Always Created:
```
lib/features/{module_name}/
  domain/usecases/
    {subfeature_name}_usecase.dart          # Business logic
  presentation/pages/
    {subfeature_name}_page.dart             # UI page
  presentation/widgets/
    {subfeature_name}_widget.dart           # Reusable widget
```

### Optionally Created:
```
# If needs_entity = true
  domain/entities/
    {subfeature_name}_entity.dart

# If needs_model = true
  data/models/
    {subfeature_name}_model.dart
```

## Usage Examples

### Example 1: Basic Subfeature (No New Entity/Model)

**Scenario**: Add "Forgot Password" to authentication module

```bash
mason make mvi_subfeature
```

**Interactive Prompts**:
```
? What is the module name? authentication
? What is the subfeature name? forgot_password
? Entity name (press Enter to use module's main entity)? [Press Enter]
? Create a new data model? (y/N) N
? Create a new entity? (y/N) N
```

**Generated Structure**:
```
lib/features/authentication/
  domain/usecases/
    ✨ forgot_password_usecase.dart
  presentation/pages/
    ✨ forgot_password_page.dart
  presentation/widgets/
    ✨ forgot_password_widget.dart
```

**Use Case Generated**:
```dart
@injectable
class ForgotPasswordUseCase {
  final AuthenticationRepository _repository;

  ForgotPasswordUseCase(this._repository);

  Future<Either<Failure, AuthUserEntity>> call(String id) async {
    // TODO: Implement your business logic
    throw UnimplementedError();
  }
}
```

**Page Generated**:
```dart
@RoutePage()
class ForgotPasswordPage extends StatefulWidget {
  // Uses existing AuthenticationBloc
  // Listens to events stream
  // Proper lifecycle management
}
```

### Example 2: Subfeature with New Entity and Model

**Scenario**: Add "Transaction History" to wallet module with its own data structure

```bash
mason make mvi_subfeature
```

**Interactive Prompts**:
```
? What is the module name? wallet
? What is the subfeature name? transaction_history
? Entity name (press Enter to use module's main entity)? transaction
? Create a new data model? (y/N) Y
? Create a new entity? (y/N) Y
```

**Generated Structure**:
```
lib/features/wallet/
  domain/entities/
    ✨ transaction_history_entity.dart
  domain/usecases/
    ✨ transaction_history_usecase.dart
  data/models/
    ✨ transaction_history_model.dart
  presentation/pages/
    ✨ transaction_history_page.dart
  presentation/widgets/
    ✨ transaction_history_widget.dart
```

### Example 3: Using Non-Interactive Mode (Config File)

Create a config file:

```json
// config.json
{
  "module_name": "authentication",
  "subfeature_name": "email_verification",
  "entity_name": "",
  "needs_model": false,
  "needs_entity": false
}
```

Run with config:
```bash
mason make mvi_subfeature --config-path config.json -o lib/features
```

## Post-Generation Steps

### Step 1: Implement the Use Case

**File**: `lib/features/{module}/domain/usecases/{subfeature}_usecase.dart`

```dart
@injectable
class ForgotPasswordUseCase {
  final AuthenticationRepository _repository;

  ForgotPasswordUseCase(this._repository);

  Future<Either<Failure, void>> call(String email) async {
    // ✅ Implement your business logic
    if (email.isEmpty) {
      return Left(ValidationFailure('Email cannot be empty'));
    }
    
    return await _repository.sendPasswordResetEmail(email);
  }
}
```

### Step 2: Add Action to Module Bloc

**File**: `lib/features/{module}/presentation/mvi/{module}_action.dart`

```dart
sealed class AuthenticationAction extends MviAction {
  const AuthenticationAction();
}

// ✅ Add your new action
class ForgotPasswordAction extends AuthenticationAction {
  final String email;
  const ForgotPasswordAction(this.email);
}
```

### Step 3: Handle Action in Bloc

**File**: `lib/features/{module}/presentation/mvi/{module}_bloc.dart`

```dart
@override
Future<void> onAction(AuthenticationAction action) async {
  switch (action) {
    // ✅ Add your action handler
    case ForgotPasswordAction(:final email):
      emit(const AuthenticationLoading());
      final result = await _forgotPasswordUseCase(email);
      result.fold(
        (failure) {
          emit(AuthenticationError(failure.message));
          emitEvent(ShowErrorMessage(failure.message));
        },
        (_) {
          emit(const AuthenticationInitial());
          emitEvent(const ShowSuccessMessage('Password reset email sent'));
        },
      );
      
    // ... other actions
  }
}
```

### Step 4: Update Repository Interface

**File**: `lib/features/{module}/domain/repositories/{module}_repository.dart`

```dart
abstract class AuthenticationRepository {
  // ✅ Add new method signature
  Future<Either<Failure, void>> sendPasswordResetEmail(String email);
  
  // ... existing methods
}
```

### Step 5: Implement Repository Method

**File**: `lib/features/{module}/data/repositories/{module}_repository_impl.dart`

```dart
@Injectable(as: AuthenticationRepository)
class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final AuthRemoteDataSource _remoteDataSource;

  // ✅ Implement the new method
  @override
  Future<Either<Failure, void>> sendPasswordResetEmail(String email) async {
    try {
      await _remoteDataSource.sendPasswordResetEmail(email);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Failed to send reset email: $e'));
    }
  }
  
  // ... other methods
}
```

### Step 6: Update Data Source

**File**: `lib/features/{module}/data/datasources/{module}_remote_datasource.dart`

```dart
abstract class AuthRemoteDataSource {
  // ✅ Add method signature
  Future<void> sendPasswordResetEmail(String email);
  
  // ... existing methods
}

@Injectable(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;

  // ✅ Implement the method
  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      final response = await _dio.post('/auth/forgot-password', data: {
        'email': email,
      });
      
      if (response.statusCode != 200) {
        throw ServerException('Failed to send reset email');
      }
    } catch (e) {
      throw ServerException('Network error: $e');
    }
  }
  
  // ... other methods
}
```

### Step 7: Add Localization

**File**: `assets/locales/en.i18n.json`

```json
{
  "authForgotPasswordTitle": "Forgot Password",
  "authForgotPasswordDescription": "Enter your email address and we'll send you a link to reset your password",
  "authForgotPasswordEmailLabel": "Email Address",
  "authForgotPasswordEmailHint": "Enter your email",
  "authForgotPasswordSubmitButton": "Send Reset Link",
  "authForgotPasswordSuccessMessage": "Password reset email sent! Check your inbox.",
  "authForgotPasswordErrorMessage": "Failed to send reset email. Please try again."
}
```

**File**: `assets/locales/vi.i18n.json`

```json
{
  "authForgotPasswordTitle": "Quên Mật Khẩu",
  "authForgotPasswordDescription": "Nhập địa chỉ email và chúng tôi sẽ gửi cho bạn liên kết đặt lại mật khẩu",
  "authForgotPasswordEmailLabel": "Địa Chỉ Email",
  "authForgotPasswordEmailHint": "Nhập email của bạn",
  "authForgotPasswordSubmitButton": "Gửi Liên Kết Đặt Lại",
  "authForgotPasswordSuccessMessage": "Email đặt lại mật khẩu đã được gửi! Kiểm tra hộp thư của bạn.",
  "authForgotPasswordErrorMessage": "Không thể gửi email đặt lại. Vui lòng thử lại."
}
```

### Step 8: Implement the Page UI

**File**: `lib/features/{module}/presentation/pages/{subfeature}_page.dart`

```dart
@override
Widget build(BuildContext context) {
  return BlocProvider.value(
    value: _bloc,
    child: Scaffold(
      appBar: AppBar(
        title: Text(context.t.authForgotPasswordTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              context.t.authForgotPasswordDescription,
              style: context.appThemes.bodyMedium,
            ),
            const SizedBox(height: 32),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: context.t.authForgotPasswordEmailLabel,
                hintText: context.t.authForgotPasswordEmailHint,
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 24),
            BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (context, state) {
                return ElevatedButton(
                  onPressed: state is AuthenticationLoading
                      ? null
                      : () {
                          _bloc.onAction(
                            ForgotPasswordAction(_emailController.text),
                          );
                        },
                  child: state is AuthenticationLoading
                      ? const CircularProgressIndicator()
                      : Text(context.t.authForgotPasswordSubmitButton),
                );
              },
            ),
          ],
        ),
      ),
    ),
  );
}
```

### Step 9: Add Route

**File**: `lib/app_router.dart`

```dart
@AutoRouterConfig()
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes => [
    // ✅ Add your new route
    AutoRoute(
      page: ForgotPasswordRoute.page,
      path: '/forgot-password',
    ),
    
    // ... other routes
  ];
}
```

**Navigate to the page**:
```dart
// From another page
context.router.push(const ForgotPasswordRoute());

// Or from a Bloc event
case NavigateToForgotPassword():
  context.router.push(const ForgotPasswordRoute());
```

### Step 10: Run Code Generation

```bash
# Generate all code (freezed, injectable, routes, translations)
melos genAlls

# Or run individually
flutter pub run build_runner build --delete-conflicting-outputs
```

### Step 11: Verify

```bash
# Format code
dart format lib/

# Analyze (must be 0 issues)
flutter analyze --no-fatal-infos
```

## Architecture Flow

```
┌─────────────────────────────────────────────────────┐
│              User Interaction                        │
│  ┌──────────────────────────────────────────────┐   │
│  │ ForgotPasswordPage                            │   │
│  │  - TextFormField (email input)                │   │
│  │  - ElevatedButton (submit)                    │   │
│  └──────────────────────────────────────────────┘   │
└────────────────────┬────────────────────────────────┘
                     │ onPressed
                     ▼
┌─────────────────────────────────────────────────────┐
│              Dispatch Action                         │
│  _bloc.onAction(ForgotPasswordAction(email))        │
└────────────────────┬────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────┐
│           AuthenticationBloc                         │
│  ┌──────────────────────────────────────────────┐   │
│  │ onAction(action)                              │   │
│  │  case ForgotPasswordAction:                   │   │
│  │    emit(AuthenticationLoading())              │   │
│  │    result = await _forgotPasswordUseCase()    │   │
│  │    result.fold(...)                           │   │
│  └──────────────────────────────────────────────┘   │
└────────────────────┬────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────┐
│          ForgotPasswordUseCase                       │
│  ┌──────────────────────────────────────────────┐   │
│  │ call(email)                                   │   │
│  │  - Validate email                             │   │
│  │  - Call repository                            │   │
│  │  - Return Either<Failure, Success>            │   │
│  └──────────────────────────────────────────────┘   │
└────────────────────┬────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────┐
│       AuthenticationRepository                       │
│  ┌──────────────────────────────────────────────┐   │
│  │ sendPasswordResetEmail(email)                 │   │
│  │  - Try: call data source                      │   │
│  │  - Catch: convert exception to failure        │   │
│  │  - Return Either<Failure, Success>            │   │
│  └──────────────────────────────────────────────┘   │
└────────────────────┬────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────┐
│       AuthRemoteDataSource                           │
│  ┌──────────────────────────────────────────────┐   │
│  │ sendPasswordResetEmail(email)                 │   │
│  │  - Make API call                              │   │
│  │  - Throw exception on error                   │   │
│  └──────────────────────────────────────────────┘   │
└────────────────────┬────────────────────────────────┘
                     │
                     ▼
                  Backend API
```

## Comparison: mvi_feature vs mvi_subfeature

| Aspect | mvi_feature | mvi_subfeature |
|--------|-------------|----------------|
| **Creates Module** | ✅ Yes | ❌ No (adds to existing) |
| **Repository** | Creates new | Reuses existing |
| **Bloc** | Creates new | Reuses existing |
| **Data Sources** | Creates new | Reuses existing |
| **Use Cases** | Multiple generic | Single specific |
| **Pages** | Single generic | Single specific |
| **Entities** | Always creates | Optional |
| **Models** | Always creates | Optional |
| **When to Use** | New domain concept | Related feature |

## Best Practices

### 1. Naming Conventions

```bash
# ✅ Good names (descriptive, specific)
forgot_password
email_verification
change_password
transaction_history
edit_profile

# ❌ Bad names (too generic, unclear)
forgot
verify
change
history
edit
```

### 2. Entity Reuse

- **Default**: Press Enter to use the module's main entity
- **New Entity**: Only when subfeature has different data structure
- **Example**: 
  - Forgot Password → Use `AuthUserEntity` ✅
  - Transaction History → Create `TransactionEntity` ✅

### 3. Module Organization

```
lib/features/authentication/
  domain/
    entities/
      auth_user_entity.dart           # Main entity
      email_verification_entity.dart   # Specific entity (if needed)
    usecases/
      login_usecase.dart
      register_usecase.dart
      forgot_password_usecase.dart     # ✅ Added by mvi_subfeature
      email_verification_usecase.dart  # ✅ Added by mvi_subfeature
  presentation/
    pages/
      login_page.dart
      register_page.dart
      forgot_password_page.dart        # ✅ Added by mvi_subfeature
      email_verification_page.dart     # ✅ Added by mvi_subfeature
```

### 4. Action Naming

```dart
// ✅ Good action names
class ForgotPasswordAction extends AuthenticationAction {
  final String email;
  const ForgotPasswordAction(this.email);
}

class VerifyEmailCodeAction extends AuthenticationAction {
  final String code;
  const VerifyEmailCodeAction(this.code);
}

// ❌ Bad action names (too generic)
class SubmitAction extends AuthenticationAction {}
class ProcessAction extends AuthenticationAction {}
```

## Troubleshooting

### Error: Module Not Found

**Problem**: "Warning: Module 'xyz' does not exist"

**Solution**:
1. Check if module exists: `lib/features/{module_name}/`
2. Verify module structure has: `domain/`, `data/`, `presentation/`
3. If module doesn't exist, use `mvi_feature` first

### Error: Cannot Import Bloc

**Problem**: "Cannot find '{module}_bloc.dart'"

**Solution**:
1. Ensure module has: `presentation/mvi/{module}_bloc.dart`
2. Check bloc follows MVI pattern
3. Verify bloc is @injectable

### Error: Entity Not Found

**Problem**: "Cannot resolve '{entity}_entity.dart'"

**Solution**:
1. Check if entity exists in `domain/entities/`
2. Or set `needs_entity: true` to create new one
3. Verify import paths in generated files

### Error: Build Runner Fails

**Problem**: Freezed/Injectable generation fails

**Solution**:
```bash
flutter clean
flutter pub get
rm -rf .dart_tool
melos genAlls
```

### Error: Duplicate Routes

**Problem**: Route already exists in router

**Solution**:
1. Choose unique route path
2. Check existing routes in `app_router.dart`
3. Remove duplicate `@RoutePage()` annotations

## Quick Reference Commands

```bash
# List available bricks
mason list

# Generate subfeature (interactive)
mason make mvi_subfeature

# Generate with config file
mason make mvi_subfeature --config-path config.json -o lib/features

# Run code generation
melos genAlls

# Format code
dart format lib/

# Analyze code (must be 0 issues)
flutter analyze --no-fatal-infos

# Run tests
flutter test
```

## Example Configs for Common Scenarios

### 1. Forgot Password (No New Entities)

```json
{
  "module_name": "authentication",
  "subfeature_name": "forgot_password",
  "entity_name": "",
  "needs_model": false,
  "needs_entity": false
}
```

### 2. Transaction History (With New Entity and Model)

```json
{
  "module_name": "wallet",
  "subfeature_name": "transaction_history",
  "entity_name": "transaction",
  "needs_model": true,
  "needs_entity": true
}
```

### 3. Edit Profile (No New Entities)

```json
{
  "module_name": "profile",
  "subfeature_name": "edit_profile",
  "entity_name": "",
  "needs_model": false,
  "needs_entity": false
}
```

## Summary

The `mvi_subfeature` template is your tool for extending existing modules with new features while maintaining clean architecture and reusing existing infrastructure. Use it whenever you need to add a related feature to an existing module, and let it handle the boilerplate while you focus on the business logic.

**Remember**:
- ✅ Use for related features within existing modules
- ✅ Reuse existing repository, bloc, and entities when possible
- ✅ Follow Clean Architecture + MVI pattern
- ✅ Always run code generation after creating files
- ✅ Add translations for user-facing text
- ✅ Verify with `flutter analyze --no-fatal-infos`

Happy coding! 🚀
