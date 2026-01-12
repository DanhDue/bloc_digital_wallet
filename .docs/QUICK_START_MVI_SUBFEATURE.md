# Quick Start: MVI Subfeature Template

## 🎯 What Is This?

A Mason template to add new features to existing modules without recreating the entire module structure.

---

## 🚀 Quick Start (30 seconds)

```bash
# 1. Run the template
mason make mvi_subfeature

# 2. Answer 5 questions
# → Module name? authentication
# → Subfeature name? forgot_password
# → Entity name? [Press Enter]
# → Create new data model? N
# → Create new entity? N

# 3. Done! Files created in lib/features/authentication/
```

---

## 📁 What Gets Created?

```
lib/features/{module_name}/
  domain/usecases/
    {subfeature}_usecase.dart        ✨ NEW - Business logic
  presentation/pages/
    {subfeature}_page.dart           ✨ NEW - UI screen
  presentation/widgets/
    {subfeature}_widget.dart         ✨ NEW - Reusable component
```

---

## 💡 Real Examples

### Example 1: Add "Forgot Password" to Authentication

```bash
mason make mvi_subfeature
# → authentication
# → forgot_password
# → [Enter]
# → N
# → N
```

### Example 2: Add "Transfer Money" to Wallet

```bash
mason make mvi_subfeature
# → wallet
# → transfer_money
# → [Enter]
# → N
# → N
```

### Example 3: Add "Edit Profile" to Profile

```bash
mason make mvi_subfeature
# → profile
# → edit_profile
# → [Enter]
# → N
# → N
```

---

## ✅ After Generation (Required Steps)

### 1. Add Action to Bloc (30 seconds)

**File:** `lib/features/{module}/presentation/mvi/{module}_action.dart`

```dart
// Add this:
class ForgotPasswordAction extends AuthenticationAction {
  final String email;
  const ForgotPasswordAction(this.email);
}
```

### 2. Handle Action in Bloc (1 minute)

**File:** `lib/features/{module}/presentation/mvi/{module}_bloc.dart`

```dart
// Add this in onAction():
case ForgotPasswordAction(:final email):
  emit(const AuthenticationLoading());
  final result = await _forgotPasswordUseCase(email);
  result.fold(
    (failure) => emitEvent(ShowErrorMessage(failure.message)),
    (_) => emitEvent(const ShowSuccessMessage('Email sent!')),
  );
```

### 3. Update Repository (2 minutes)

**Interface:** `lib/features/{module}/domain/repositories/{module}_repository.dart`

```dart
// Add method signature:
Future<Either<Failure, void>> sendPasswordResetEmail(String email);
```

**Implementation:** `lib/features/{module}/data/repositories/{module}_repository_impl.dart`

```dart
// Implement method:
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

### 4. Implement Use Case (1 minute)

**File:** `lib/features/{module}/domain/usecases/{subfeature}_usecase.dart`

```dart
// Replace the TODO with your logic:
Future<Either<Failure, void>> call(String email) async {
  if (email.isEmpty) {
    return Left(ValidationFailure('Email required'));
  }
  return await _repository.sendPasswordResetEmail(email);
}
```

### 5. Run Code Generation (30 seconds)

```bash
melos genAlls
dart format lib/
flutter analyze --no-fatal-infos
```

---

## 🎨 When to Use What?

| Scenario | Use This |
|----------|----------|
| Creating brand new feature (auth, wallet, profile) | `mason make mvi_feature` |
| Adding feature to existing module | `mason make mvi_subfeature` ✅ |

**Simple Rule:** If the module exists → use `mvi_subfeature`

---

## 📚 Need More Details?

- **Comprehensive Guide**: `docs/mason/MVI_SUBFEATURE_GUIDE.md`
- **Template Overview**: `docs/mason/MASON_TEMPLATES_OVERVIEW.md`
- **Full Summary**: `.docs/MVI_SUBFEATURE_TEMPLATE_SUMMARY.md`

---

## 🎯 Common Use Cases

### Authentication Module
```bash
mason make mvi_subfeature  # forgot_password
mason make mvi_subfeature  # email_verification
mason make mvi_subfeature  # change_password
mason make mvi_subfeature  # two_factor_auth
```

### Wallet Module
```bash
mason make mvi_subfeature  # transfer_money
mason make mvi_subfeature  # transaction_history
mason make mvi_subfeature  # top_up
mason make mvi_subfeature  # withdraw
```

### Profile Module
```bash
mason make mvi_subfeature  # edit_profile
mason make mvi_subfeature  # change_avatar
mason make mvi_subfeature  # privacy_settings
mason make mvi_subfeature  # security_settings
```

---

## ⚡ Pro Tips

1. **Press Enter** for entity name to reuse module's entity
2. **Say "N"** to model/entity unless you need different data structure
3. **Check existing features** in the module for patterns
4. **Always run** `melos genAlls` after generation
5. **Must have 0 issues** with `flutter analyze --no-fatal-infos`

---

## 🔥 You're Ready!

```bash
# Try it now:
mason make mvi_subfeature
```

Happy coding! 🚀
