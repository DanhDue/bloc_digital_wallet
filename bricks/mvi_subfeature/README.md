# MVI Subfeature Brick

A Mason brick to generate a new subfeature within an existing module in a Clean Architecture + MVI Flutter app.

## Purpose

This brick helps you add new features to an existing module without creating a completely new module structure. It reuses the existing module's:
- Repository (domain & implementation)
- Bloc (Action, State, Event)
- Entities (optionally create new ones)
- Folder structure

## Use Cases

Perfect for adding related features to an existing module:

### Authentication Module Examples:
- ✅ Add "Forgot Password" feature to authentication module
- ✅ Add "Email Verification" feature to authentication module
- ✅ Add "Change Password" feature to authentication module
- ✅ Add "Two-Factor Auth" feature to authentication module

### Wallet Module Examples:
- ✅ Add "Transfer Money" feature to wallet module
- ✅ Add "Transaction History" feature to wallet module
- ✅ Add "Top Up" feature to wallet module

### Profile Module Examples:
- ✅ Add "Edit Profile" feature to profile module
- ✅ Add "Change Avatar" feature to profile module
- ✅ Add "Privacy Settings" feature to profile module

## When to Use

Use `mvi_subfeature` when:
- ✅ The module already exists (e.g., authentication, wallet, profile)
- ✅ You want to add a new page/screen to the module
- ✅ You want to reuse the existing repository and bloc
- ✅ The new feature shares the same data/domain concepts

Use `mvi_feature` when:
- ❌ You're creating a completely new module from scratch
- ❌ The feature has entirely different domain concepts
- ❌ The feature needs its own repository and data sources

## What It Generates

### Always Generated:
```
lib/features/{module_name}/
  domain/usecases/
    {subfeature_name}_usecase.dart          # New use case
  presentation/pages/
    {subfeature_name}_page.dart             # New page
  presentation/widgets/
    {subfeature_name}_widget.dart           # New widget
```

### Optionally Generated:
```
# If needs_entity = true
  domain/entities/
    {subfeature_name}_entity.dart           # New entity

# If needs_model = true
  data/models/
    {subfeature_name}_model.dart            # New model
```

## Usage

### Basic Example: Add Forgot Password to Authentication

```bash
# Navigate to project root
cd /path/to/bloc_digital_wallet

# Run mason
mason make mvi_subfeature \
  --module_name authentication \
  --subfeature_name forgot_password \
  --needs_model false \
  --needs_entity false

# Or use interactive mode
mason make mvi_subfeature
# → What is the module name? authentication
# → What is the subfeature name? forgot_password
# → Entity name (press Enter to use module's main entity)? [press Enter]
# → Create a new data model? false
# → Create a new entity? false
```

This will generate:
```
lib/features/authentication/
  domain/usecases/
    forgot_password_usecase.dart
  presentation/pages/
    forgot_password_page.dart
  presentation/widgets/
    forgot_password_widget.dart
```

### Advanced Example: Add Transaction History with New Entity

```bash
mason make mvi_subfeature \
  --module_name wallet \
  --subfeature_name transaction_history \
  --entity_name transaction \
  --needs_model true \
  --needs_entity true
```

This will generate:
```
lib/features/wallet/
  domain/entities/
    transaction_history_entity.dart         # New entity
  domain/usecases/
    transaction_history_usecase.dart
  data/models/
    transaction_history_model.dart          # New model
  presentation/pages/
    transaction_history_page.dart
  presentation/widgets/
    transaction_history_widget.dart
```

## Generated Files Details

### 1. Use Case (`{subfeature_name}_usecase.dart`)
- Injectable use case class
- References existing module repository
- Single responsibility: implements the subfeature's business logic
- Returns `Either<Failure, Entity>`

### 2. Page (`{subfeature_name}_page.dart`)
- StatefulWidget with `@RoutePage()` annotation
- Uses existing module's Bloc
- Listens to events stream for side effects
- Proper lifecycle management (dispose subscription)
- Uses `getIt` for dependency injection
- Pattern-matched state handling with `switch`

### 3. Widget (`{subfeature_name}_widget.dart`)
- Reusable widget component
- Can be used in the page or other features
- Stateless by default

### 4. Entity (Optional - `{subfeature_name}_entity.dart`)
- Pure Dart class with Equatable
- Immutable domain model
- No Flutter dependencies
- Includes copyWith method

### 5. Model (Optional - `{subfeature_name}_model.dart`)
- Freezed data model with JSON serialization
- toEntity() and fromEntity() methods
- Maps between data and domain layers

## Post-Generation Steps

### 1. Implement the Use Case
```dart
// In {subfeature_name}_usecase.dart
Future<Either<Failure, Entity>> call(String param) async {
  // Add your business logic
  return await _repository.yourMethod(param);
}
```

### 2. Add Action to Module Bloc (if needed)
```dart
// In {module_name}_action.dart
sealed class AuthenticationAction extends MviAction {
  const AuthenticationAction();
}

// Add your new action
class ForgotPasswordAction extends AuthenticationAction {
  final String email;
  const ForgotPasswordAction(this.email);
}
```

### 3. Handle Action in Bloc (if needed)
```dart
// In {module_name}_bloc.dart
@override
Future<void> onAction(AuthenticationAction action) async {
  switch (action) {
    case ForgotPasswordAction(:final email):
      final result = await _forgotPasswordUseCase(email);
      result.fold(
        (failure) => emitEvent(ShowErrorMessage(failure.message)),
        (success) => emitEvent(ShowSuccessMessage('Password reset email sent')),
      );
  }
}
```

### 4. Add Route (if needed)
```dart
// In app_router.dart
@AutoRouterConfig()
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: ForgotPasswordRoute.page, path: '/forgot-password'),
    // ...
  ];
}
```

### 5. Update Repository Interface (if needed)
```dart
// In {module_name}_repository.dart
abstract class AuthenticationRepository {
  Future<Either<Failure, void>> forgotPassword(String email);
  // Add new method signature
}
```

### 6. Implement Repository Method (if needed)
```dart
// In {module_name}_repository_impl.dart
@override
Future<Either<Failure, void>> forgotPassword(String email) async {
  try {
    await _remoteDataSource.forgotPassword(email);
    return const Right(null);
  } on ServerException catch (e) {
    return Left(ServerFailure(e.message));
  }
}
```

### 7. Run Code Generation
```bash
# Generate all (freezed, injectable, routes, etc.)
melos genAlls

# Or individually
flutter pub run build_runner build --delete-conflicting-outputs
```

### 8. Add Translations
```json
// In assets/locales/en.i18n.json
{
  "authForgotPasswordTitle": "Forgot Password",
  "authForgotPasswordDescription": "Enter your email to reset password",
  "authForgotPasswordButton": "Send Reset Link"
}
```

Then run `melos genAlls` and use:
```dart
Text(context.t.authForgotPasswordTitle)
```

### 9. Add to Navigation
```dart
// From another page
context.router.push(const ForgotPasswordRoute());

// Or from Bloc event
case NavigateToForgotPassword():
  context.router.push(const ForgotPasswordRoute());
```

### 10. Verify
```bash
# Format code
dart format lib/

# Check for issues (must be 0)
flutter analyze --no-fatal-infos
```

## Architecture Pattern

The generated subfeature follows Clean Architecture + MVI:

```
┌─────────────────────────────────────────────────────┐
│                 Presentation Layer                   │
│  ┌──────────────────────────────────────────────┐   │
│  │ {subfeature_name}_page.dart                  │   │
│  │  - Uses existing {module_name}_bloc.dart     │   │
│  │  - Listens to events stream                  │   │
│  │  - Dispatches actions                        │   │
│  └──────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────┐
│                   Domain Layer                       │
│  ┌──────────────────────────────────────────────┐   │
│  │ {subfeature_name}_usecase.dart               │   │
│  │  - References existing repository            │   │
│  │  - Business logic for subfeature             │   │
│  └──────────────────────────────────────────────┘   │
│                                                      │
│  Reuses existing:                                    │
│  - {module_name}_repository.dart (interface)         │
│  - {module_name}_entity.dart (or create new)         │
└─────────────────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────┐
│                    Data Layer                        │
│  Reuses existing:                                    │
│  - {module_name}_repository_impl.dart                │
│  - {module_name}_remote_datasource.dart              │
│  - {module_name}_model.dart (or create new)          │
└─────────────────────────────────────────────────────┘
```

## Examples

### Example 1: Email Verification (Reuses Everything)
```bash
mason make mvi_subfeature \
  --module_name authentication \
  --subfeature_name email_verification \
  --needs_model false \
  --needs_entity false
```

Generated use case will use existing `AuthUserEntity` and `AuthenticationRepository`.

### Example 2: Transaction Detail (New Entity)
```bash
mason make mvi_subfeature \
  --module_name wallet \
  --subfeature_name transaction_detail \
  --entity_name transaction \
  --needs_model true \
  --needs_entity true
```

Generates new `TransactionEntity` and `TransactionModel` separate from main wallet entities.

### Example 3: Change Password (Minimal Generation)
```bash
mason make mvi_subfeature \
  --module_name authentication \
  --subfeature_name change_password
# Press Enter for entity (uses module's entity)
# Select 'false' for model and entity
```

Minimal generation: just use case, page, and widget.

## Tips

1. **Naming Convention**: Use descriptive names (e.g., `forgot_password`, not just `forgot`)
2. **Entity Reuse**: Usually you can reuse the module's main entity (press Enter when prompted)
3. **New Entities**: Only create new entities if the subfeature has different data structure
4. **Bloc Actions**: After generation, add new actions to the module's action file
5. **Repository Methods**: Add new methods to repository interface and implementation
6. **Code Generation**: Always run `melos genAlls` after generation
7. **Check Existing**: Look at similar subfeatures in the module for consistency

## Comparison: mvi_feature vs mvi_subfeature

| Aspect | mvi_feature | mvi_subfeature |
|--------|-------------|----------------|
| **Purpose** | Create new module | Add to existing module |
| **Structure** | Full module structure | Only use case + page + widget |
| **Repository** | Creates new | Reuses existing |
| **Bloc** | Creates new | Reuses existing |
| **Data Sources** | Creates new | Reuses existing |
| **Use Case** | Multiple use cases | Single use case |
| **When to Use** | New domain concept | Related feature |

## Troubleshooting

### Module Not Found
**Error**: "Warning: Module 'xyz' does not exist"
**Solution**: Make sure the module exists at `lib/features/{module_name}/`

### Import Errors
**Error**: Cannot find '{module_name}_bloc.dart'
**Solution**: Ensure the module has a bloc file at `presentation/mvi/{module_name}_bloc.dart`

### Entity Not Found
**Error**: Cannot resolve '{entity_name}_entity.dart'
**Solution**: 
- Check if entity exists in `domain/entities/`
- Or set `needs_entity: true` to create new one

### Build Runner Errors
**Error**: Freezed/Injectable generation fails
**Solution**: 
```bash
flutter clean
flutter pub get
melos genAlls
```

## License

Copyright (c) 2026, DanhDue ExOICTIF projects. All rights reserved.
