---
title: Mason Workflows
description: Mason brick templates for feature generation
inclusion: always
---

# Mason Workflows

> [!IMPORTANT]
> This project uses Mason for code generation and feature scaffolding.

## Available Bricks

### 1. mvi_feature (New Module)
Creates a complete new feature module with Clean Architecture + MVI pattern.

**Usage:**
```bash
mason make mvi_feature --feature_name wallet
```

**Generates:**
```
lib/features/wallet/
├── data/
│   ├── datasources/
│   │   └── wallet_remote_datasource.dart
│   ├── models/
│   │   └── wallet_model.dart
│   └── repositories/
│       └── wallet_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── wallet_entity.dart
│   ├── repositories/
│   │   └── wallet_repository.dart
│   └── usecases/
│       └── get_wallet_usecase.dart
└── presentation/
    ├── bloc/
    │   ├── wallet_bloc.dart
    │   ├── wallet_action.dart
    │   ├── wallet_state.dart
    │   └── wallet_event.dart
    ├── pages/
    │   └── wallet_page.dart
    └── widgets/
        └── wallet_widget.dart
```

**When to use:**
- Creating a completely new feature domain
- New top-level module (e.g., notifications, chat, profile)
- Feature has its own business logic and data layer

### 2. mvi_subfeature (Add to Existing Module)
Adds a subfeature to an existing module.

**Usage:**
```bash
mason make mvi_subfeature --module_name authentication --subfeature_name forgot_password
```

**Generates:**
```
lib/features/authentication/
├── domain/
│   └── usecases/
│       └── forgot_password_usecase.dart
├── presentation/
│   └── pages/
│       └── forgot_password_page.dart
```

**When to use:**
- Adding functionality to existing module
- Feature shares domain/data layer with parent module
- Extending existing feature (e.g., forgot password in auth module)

### 3. remove_feature
Removes a feature module completely.

**Usage:**
```bash
mason make remove_feature --feature_name wallet
```

**When to use:**
- Cleaning up unused features
- Removing deprecated modules

### 4. remove_subfeature
Removes a subfeature from a module.

**Usage:**
```bash
mason make remove_subfeature --module_name authentication --subfeature_name forgot_password
```

**When to use:**
- Removing specific functionality from a module
- Cleaning up deprecated subfeatures

### 5. sample
Creates sample/demo features for testing.

**Usage:**
```bash
mason make sample --feature_name demo
```

**When to use:**
- Creating demo features
- Testing architecture patterns
- Prototyping

## Decision Tree: Which Brick to Use?

```
Is this a new feature?
├─ YES → Does it have its own business domain?
│        ├─ YES → Use mvi_feature
│        └─ NO → Use mvi_subfeature (add to existing module)
└─ NO → Are you removing a feature?
         ├─ YES → Is it a complete module?
         │        ├─ YES → Use remove_feature
         │        └─ NO → Use remove_subfeature
         └─ NO → Manual implementation
```

## Workflow: Create New Feature

### Step 1: Analyze Request
Determine if it's a new module or subfeature:

**New Module Examples:**
- Notifications system
- Chat feature
- User profile management
- Payment processing

**Subfeature Examples:**
- Forgot password (in authentication)
- Transaction history (in wallet)
- Filter options (in search)

### Step 2: Run Mason Command

**For New Module:**
```bash
mason make mvi_feature --feature_name {feature_name}
```

**For Subfeature:**
```bash
mason make mvi_subfeature --module_name {module_name} --subfeature_name {subfeature_name}
```

### Step 3: Implement Business Logic

1. **Domain Layer:**
   - Update entities with `@freezed` and `@JsonKey`
   - Define repository interfaces
   - Create use cases

2. **Data Layer:**
   - Update models with `@freezed` and `@JsonKey`
   - Implement data sources (API clients)
   - Implement repositories

3. **Presentation Layer:**
   - Define actions (user intents)
   - Define states (UI states)
   - Define events (side effects)
   - Implement BLoC logic
   - Implement UI pages

### Step 4: Configuration

1. **Add Translations:**
   ```json
   // assets/locales/en.i18n.json
   {
     "walletTitle": "My Wallet",
     "walletBalance": "Balance",
     "walletEmpty": "No wallets found"
   }
   ```

2. **Add Routes:**
   ```dart
   // lib/app_router.dart
   @AutoRouterConfig()
   class AppRouter extends RootStackRouter {
     @override
     List<AutoRoute> get routes => [
       AutoRoute(page: WalletRoute.page, path: '/wallet'),
       // ... other routes
     ];
   }
   ```

3. **Register Dependencies:**
   ```dart
   // lib/di/injection.dart
   @module
   abstract class FeatureModule {
     @injectable
     WalletBloc walletBloc(GetWalletUseCase useCase) => WalletBloc(useCase);
   }
   ```

### Step 5: Code Generation

```bash
# Generate all code (models, routes, translations, etc.)
melos genAlls

# Format code
dart format lib/

# Verify no issues
flutter analyze --no-fatal-infos
```

## Common Patterns

### Pattern 1: Simple CRUD Feature

```bash
# 1. Generate structure
mason make mvi_feature --feature_name products

# 2. Implement domain
# - Create ProductEntity with @freezed
# - Define ProductRepository interface
# - Create GetProductsUseCase, CreateProductUseCase, etc.

# 3. Implement data
# - Create ProductModel with @freezed
# - Implement ProductRemoteDataSource
# - Implement ProductRepositoryImpl

# 4. Implement presentation
# - Define ProductAction (load, create, update, delete)
# - Define ProductState (initial, loading, loaded, error)
# - Define ProductEvent (showSuccess, showError, navigate)
# - Implement ProductBloc
# - Implement ProductPage

# 5. Configure
# - Add translations
# - Add routes
# - Run melos genAlls
```

### Pattern 2: Add Authentication Flow

```bash
# 1. Generate structure
mason make mvi_feature --feature_name authentication

# 2. Add login subfeature
mason make mvi_subfeature --module_name authentication --subfeature_name login

# 3. Add register subfeature
mason make mvi_subfeature --module_name authentication --subfeature_name register

# 4. Add forgot password subfeature
mason make mvi_subfeature --module_name authentication --subfeature_name forgot_password

# 5. Implement shared domain/data layer
# - AuthEntity, TokenEntity
# - AuthRepository
# - LoginUseCase, RegisterUseCase, ForgotPasswordUseCase

# 6. Implement each subfeature UI
# - LoginPage, RegisterPage, ForgotPasswordPage

# 7. Configure and generate
# - Add translations
# - Add routes
# - Run melos genAlls
```

### Pattern 3: Extend Existing Feature

```bash
# Add transaction history to existing wallet module
mason make mvi_subfeature --module_name wallet --subfeature_name transaction_history

# Implement
# - TransactionHistoryUseCase (reuses WalletRepository)
# - TransactionHistoryPage
# - Add to WalletBloc or create separate TransactionHistoryBloc

# Configure
# - Add translations
# - Add routes
# - Run melos genAlls
```

## Best Practices

### 1. Naming Conventions
```bash
# ✅ Correct - snake_case
mason make mvi_feature --feature_name user_profile
mason make mvi_subfeature --module_name authentication --subfeature_name forgot_password

# ❌ Wrong - camelCase or PascalCase
mason make mvi_feature --feature_name userProfile
mason make mvi_feature --feature_name UserProfile
```

### 2. Module Organization
```
# ✅ Correct - Logical grouping
lib/features/
├── authentication/      # Auth-related features
├── wallet/             # Wallet-related features
├── transaction/        # Transaction-related features
└── settings/           # Settings-related features

# ❌ Wrong - Too granular
lib/features/
├── login/
├── register/
├── forgot_password/    # Should be subfeatures of authentication
└── change_password/
```

### 3. Subfeature vs New Module
```
# ✅ Use subfeature when sharing domain/data
authentication/
├── domain/
│   ├── entities/auth_entity.dart        # Shared
│   ├── repositories/auth_repository.dart # Shared
│   └── usecases/
│       ├── login_usecase.dart
│       ├── register_usecase.dart
│       └── forgot_password_usecase.dart
└── presentation/
    └── pages/
        ├── login_page.dart
        ├── register_page.dart
        └── forgot_password_page.dart

# ✅ Use new module when separate domain
lib/features/
├── authentication/     # Auth domain
├── wallet/            # Wallet domain (separate)
└── notifications/     # Notifications domain (separate)
```

### 4. Post-Generation Checklist
```bash
# After running mason make:
[ ] Update entities with proper @JsonKey annotations
[ ] Update models with proper @JsonKey annotations
[ ] Implement repository interfaces
[ ] Implement use cases
[ ] Implement data sources
[ ] Define actions, states, events
[ ] Implement BLoC logic
[ ] Implement UI pages
[ ] Add translations (en.i18n.json, vi.i18n.json)
[ ] Add routes (app_router.dart)
[ ] Register dependencies (injection.dart)
[ ] Run: melos genAlls
[ ] Run: dart format lib/
[ ] Run: flutter analyze --no-fatal-infos
[ ] Verify: "No issues found!"
```

## Troubleshooting

### Issue: Mason command not found
```bash
# Install Mason CLI
dart pub global activate mason_cli

# Verify installation
mason --version
```

### Issue: Brick not found
```bash
# Get bricks from mason.yaml
mason get

# List available bricks
mason list
```

### Issue: Generated code has errors
```bash
# Run code generation
melos genAlls

# If still errors, clean and regenerate
flutter clean
flutter pub get
melos genAlls
```

### Issue: Import errors after generation
```bash
# Ensure using full package paths
# ✅ Correct
import 'package:bloc_digital_wallet/features/wallet/domain/entities/wallet_entity.dart';

# ❌ Wrong
import '../domain/entities/wallet_entity.dart';
```

## Summary

| Brick | Purpose | Command |
|-------|---------|---------|
| **mvi_feature** | New module | `mason make mvi_feature --feature_name {name}` |
| **mvi_subfeature** | Add to module | `mason make mvi_subfeature --module_name {module} --subfeature_name {name}` |
| **remove_feature** | Remove module | `mason make remove_feature --feature_name {name}` |
| **remove_subfeature** | Remove subfeature | `mason make remove_subfeature --module_name {module} --subfeature_name {name}` |
| **sample** | Demo feature | `mason make sample --feature_name {name}` |

---

**Last Updated**: 2026-01-22  
**Status**: Active ✅
