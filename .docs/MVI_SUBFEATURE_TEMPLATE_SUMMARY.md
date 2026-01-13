# MVI Subfeature Template - Implementation Summary

## 🎉 What Was Created

A new Mason template (`mvi_subfeature`) that allows you to add new features to existing modules while reusing their infrastructure (repository, bloc, entities, etc.).

---

## 📦 Files Created

### Mason Template Structure

```
bricks/mvi_subfeature/
├── brick.yaml                          # Template configuration
├── hooks/
│   └── pre_gen.dart                    # Pre-generation validation
├── __brick__/
│   └── {{{module_name.snakeCase()}}}/
│       ├── domain/
│       │   ├── entities/
│       │   │   └── (optional) {subfeature}_entity.dart
│       │   └── usecases/
│       │       └── {subfeature}_usecase.dart     ✨ ALWAYS CREATED
│       ├── data/
│       │   └── models/
│       │       └── (optional) {subfeature}_model.dart
│       └── presentation/
│           ├── pages/
│           │   └── {subfeature}_page.dart        ✨ ALWAYS CREATED
│           └── widgets/
│               └── {subfeature}_widget.dart      ✨ ALWAYS CREATED
├── README.md                           # Comprehensive documentation
├── LICENSE                             # MIT License
└── CHANGELOG.md                        # Version history
```

### Documentation Created

```
docs/mason/
├── MVI_SUBFEATURE_GUIDE.md            # Detailed step-by-step guide
└── MASON_TEMPLATES_OVERVIEW.md        # Quick reference for all templates

.docs/
└── MVI_SUBFEATURE_TEMPLATE_SUMMARY.md # This file
```

### Configuration Updated

```
mason.yaml                              # Registered new brick
.cursorrules                            # Updated with new template usage
```

---

## 🎯 Key Features

### 1. Smart Reuse
- ✅ Reuses existing module's repository
- ✅ Reuses existing module's bloc
- ✅ Reuses existing module's entities (by default)
- ✅ Only creates what's needed

### 2. Flexible Generation
- ✅ Optionally create new entity (if subfeature needs different data)
- ✅ Optionally create new model (if subfeature needs different API structure)
- ✅ Auto-validates module existence
- ✅ Auto-sets copyright year

### 3. Architecture Compliant
- ✅ Follows Clean Architecture + MVI pattern
- ✅ Uses @injectable for DI
- ✅ Uses @RoutePage for routing
- ✅ Proper event subscription handling
- ✅ Pattern-matched state handling

### 4. Developer Friendly
- ✅ TODO comments for guidance
- ✅ Comprehensive documentation
- ✅ Real-world examples
- ✅ Post-generation checklists

---

## 🚀 How to Use

### Quick Start

```bash
# Step 1: Run Mason template
mason make mvi_subfeature

# Step 2: Answer prompts
# → Module name? authentication
# → Subfeature name? forgot_password
# → Entity name? [Press Enter]
# → Create new data model? N
# → Create new entity? N

# Step 3: Implement logic in generated files
# Step 4: Add action to bloc
# Step 5: Handle action in bloc
# Step 6: Update repository (if needed)
# Step 7: Run code generation
melos genAlls

# Step 8: Verify
flutter analyze --no-fatal-infos
```

### Real-World Examples

#### Example 1: Forgot Password Feature

```bash
mason make mvi_subfeature
```

**Prompts:**
- Module name: `authentication`
- Subfeature name: `forgot_password`
- Entity name: _(press Enter to use AuthUserEntity)_
- Create new model: `N`
- Create new entity: `N`

**Generated:**
```
lib/features/authentication/
  domain/usecases/
    forgot_password_usecase.dart        ✨ NEW
  presentation/pages/
    forgot_password_page.dart           ✨ NEW
  presentation/widgets/
    forgot_password_widget.dart         ✨ NEW
```

#### Example 2: Transaction History (with new entity)

```bash
mason make mvi_subfeature
```

**Prompts:**
- Module name: `wallet`
- Subfeature name: `transaction_history`
- Entity name: `transaction`
- Create new model: `Y`
- Create new entity: `Y`

**Generated:**
```
lib/features/wallet/
  domain/entities/
    transaction_history_entity.dart     ✨ NEW
  domain/usecases/
    transaction_history_usecase.dart    ✨ NEW
  data/models/
    transaction_history_model.dart      ✨ NEW
  presentation/pages/
    transaction_history_page.dart       ✨ NEW
  presentation/widgets/
    transaction_history_widget.dart     ✨ NEW
```

---

## 📋 Template Variables

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `module_name` | string | required | Existing module (e.g., authentication) |
| `subfeature_name` | string | required | New feature (e.g., forgot_password) |
| `entity_name` | string | "" | Entity to use (empty = module's main entity) |
| `needs_model` | boolean | false | Create new data model? |
| `needs_entity` | boolean | false | Create new entity? |
| `year` | number | auto | Copyright year (auto-set) |

---

## 🎨 Generated Code Patterns

### Use Case Template

```dart
@injectable
class ForgotPasswordUseCase {
  final AuthenticationRepository _repository;

  ForgotPasswordUseCase(this._repository);

  Future<Either<Failure, AuthUserEntity>> call(String id) async {
    // TODO: Implement business logic
    throw UnimplementedError();
  }
}
```

### Page Template

```dart
@RoutePage()
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  late final AuthenticationBloc _bloc;
  late final StreamSubscription<AuthenticationEvent> _eventSubscription;

  @override
  void initState() {
    super.initState();
    _bloc = getIt<AuthenticationBloc>();
    
    // Listen to one-time events
    _eventSubscription = _bloc.events.listen((event) {
      if (!mounted) return;
      // Handle events...
    });
  }

  @override
  void dispose() {
    _eventSubscription.cancel();
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        // UI implementation...
      ),
    );
  }
}
```

---

## 📚 Documentation

### Comprehensive Guides

1. **Quick Reference**: `docs/mason/MASON_TEMPLATES_OVERVIEW.md`
   - Decision tree: which template to use
   - Quick comparison
   - Common commands

2. **Detailed Guide**: `docs/mason/MVI_SUBFEATURE_GUIDE.md`
   - Step-by-step usage
   - Real-world examples
   - Post-generation steps
   - Complete implementation workflow
   - Troubleshooting

3. **Template README**: `bricks/mvi_subfeature/README.md`
   - Template-specific details
   - Configuration options
   - Examples

### Updated Documentation

- ✅ `.cursorrules` - Added mvi_subfeature workflow
- ✅ `mason.yaml` - Registered new brick
- ✅ Created comprehensive guides

---

## ✅ Post-Generation Workflow

After generating a subfeature, follow these steps:

### 1. Implement Use Case
```dart
// lib/features/{module}/domain/usecases/{subfeature}_usecase.dart
@injectable
class ForgotPasswordUseCase {
  final AuthenticationRepository _repository;

  Future<Either<Failure, void>> call(String email) async {
    // ✅ Add validation
    if (email.isEmpty) return Left(ValidationFailure('Email required'));
    
    // ✅ Call repository
    return await _repository.sendPasswordResetEmail(email);
  }
}
```

### 2. Add Action to Bloc
```dart
// lib/features/{module}/presentation/mvi/{module}_action.dart
sealed class AuthenticationAction extends MviAction {
  const AuthenticationAction();
}

// ✅ Add new action
class ForgotPasswordAction extends AuthenticationAction {
  final String email;
  const ForgotPasswordAction(this.email);
}
```

### 3. Handle Action in Bloc
```dart
// lib/features/{module}/presentation/mvi/{module}_bloc.dart
@override
Future<void> onAction(AuthenticationAction action) async {
  switch (action) {
    // ✅ Handle new action
    case ForgotPasswordAction(:final email):
      emit(const AuthenticationLoading());
      final result = await _forgotPasswordUseCase(email);
      result.fold(
        (failure) => emitEvent(ShowErrorMessage(failure.message)),
        (_) => emitEvent(const ShowSuccessMessage('Email sent!')),
      );
  }
}
```

### 4. Update Repository
```dart
// Domain: lib/features/{module}/domain/repositories/{module}_repository.dart
abstract class AuthenticationRepository {
  // ✅ Add method signature
  Future<Either<Failure, void>> sendPasswordResetEmail(String email);
}

// Data: lib/features/{module}/data/repositories/{module}_repository_impl.dart
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

### 5. Add Translations
```json
// assets/locales/en.i18n.json
{
  "authForgotPasswordTitle": "Forgot Password",
  "authForgotPasswordButton": "Send Reset Link"
}
```

### 6. Implement UI
```dart
// Use context.t for translations
Text(context.t.authForgotPasswordTitle)

// Use context.appThemes for styling
style: context.appThemes.bodyMedium
```

### 7. Add Route
```dart
// lib/app_router.dart
AutoRoute(page: ForgotPasswordRoute.page, path: '/forgot-password'),
```

### 8. Run Code Generation
```bash
melos genAlls
dart format lib/
flutter analyze --no-fatal-infos  # Must be 0 issues
```

---

## 🎯 Use Cases

### Authentication Module
- ✅ Forgot Password
- ✅ Email Verification
- ✅ Change Password
- ✅ Two-Factor Authentication
- ✅ Social Login (Facebook, Google, Apple)

### Wallet Module
- ✅ Transfer Money
- ✅ Transaction History
- ✅ Top Up Balance
- ✅ Request Money
- ✅ Withdraw Funds
- ✅ Payment QR Code

### Profile Module
- ✅ Edit Profile
- ✅ Change Avatar
- ✅ Privacy Settings
- ✅ Account Settings
- ✅ Security Settings
- ✅ Notification Preferences

---

## 🔄 Comparison: mvi_feature vs mvi_subfeature

| Aspect | mvi_feature | mvi_subfeature |
|--------|-------------|----------------|
| **Purpose** | Create new module | Add to existing module |
| **Repository** | Creates new | Reuses existing |
| **Bloc** | Creates new | Reuses existing |
| **Data Sources** | Creates new | Reuses existing |
| **Use Cases** | Multiple generic | Single specific |
| **Entities** | Always creates | Optional |
| **Models** | Always creates | Optional |
| **When to Use** | New domain concept | Related feature |

---

## 💡 Best Practices

### 1. Naming
```bash
# ✅ Good names
forgot_password
email_verification
transaction_history
edit_profile

# ❌ Bad names
forgot
verify
history
edit
```

### 2. Entity Reuse
- Default: Press Enter to use module's entity ✅
- New entity: Only when data structure is different ✅

### 3. Keep Related Features Together
```
lib/features/authentication/
  domain/usecases/
    login_usecase.dart
    register_usecase.dart
    forgot_password_usecase.dart         ✅ Related features
    email_verification_usecase.dart      ✅ in same module
    change_password_usecase.dart         ✅
```

---

## 🚨 Common Issues & Solutions

### Issue: Module Not Found
**Solution**: Ensure module exists at `lib/features/{module_name}/`

### Issue: Import Errors
**Solution**: Verify module structure has required files (bloc, repository, etc.)

### Issue: Build Runner Fails
**Solution**: Run `flutter clean && flutter pub get && melos genAlls`

---

## 📊 Project Status

✅ **Template Created**: mvi_subfeature brick  
✅ **Documentation**: Comprehensive guides written  
✅ **Integration**: Registered in mason.yaml  
✅ **Rules Updated**: .cursorrules includes new workflow  
✅ **Testing**: Verified Mason recognizes the template  
✅ **Ready to Use**: Fully functional and documented

---

## 🎓 Learning Resources

1. **Start Here**: `docs/mason/MASON_TEMPLATES_OVERVIEW.md`
2. **Deep Dive**: `docs/mason/MVI_SUBFEATURE_GUIDE.md`
3. **Examples**: Check authentication module for patterns
4. **Architecture**: `docs/architecture/ARCHITECTURE.md`

---

## 🎉 Summary

You now have a powerful tool to:
- ✅ Add features to existing modules efficiently
- ✅ Maintain clean architecture and MVI pattern
- ✅ Reuse infrastructure (repository, bloc, entities)
- ✅ Generate boilerplate with best practices
- ✅ Focus on business logic, not setup

**Next Steps:**
1. Try generating a subfeature: `mason make mvi_subfeature`
2. Follow the post-generation workflow
3. Check the comprehensive guide for detailed examples
4. Build amazing features! 🚀

---

**Created:** 2026-01-12  
**Version:** 1.0.0  
**Status:** Production Ready ✅
