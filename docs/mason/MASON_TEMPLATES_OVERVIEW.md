# Mason Templates Overview

Quick reference guide for using Mason templates in this project.

## 📦 Available Templates

### 1. mvi_feature - Create New Module

**Purpose:** Generate a complete new module with full Clean Architecture + MVI structure

**When to Use:**
- ✅ Creating an entirely new module from scratch
- ✅ Feature has completely different domain concepts
- ✅ Feature needs its own repository and data sources

**Examples:** Authentication, Wallet, Profile, Settings, Notifications

**Command:**
```bash
mason make mvi_feature
```

**What It Creates:**
- Complete domain layer (entities, repositories, use cases)
- Complete data layer (models, data sources, repository impl)
- Complete presentation layer (action, state, event, bloc, page)

---

### 2. mvi_subfeature - Add to Existing Module

**Purpose:** Add a new feature to an existing module, reusing its infrastructure

**When to Use:**
- ✅ Module already exists
- ✅ Adding related feature that shares same domain/data
- ✅ Want to reuse existing repository and bloc

**Examples:**
- **Authentication**: forgot_password, email_verification, change_password
- **Wallet**: transfer_money, transaction_history, top_up
- **Profile**: edit_profile, change_avatar, privacy_settings

**Command:**
```bash
mason make mvi_subfeature
```

**What It Creates:**
- New use case in existing module
- New page using existing bloc
- New widget component
- Optionally: new entity and model (if needed)

---

## 🎯 Decision Tree

```
Need to add new functionality?
│
├─ Is there an existing module for this domain?
│  │
│  ├─ YES → Use mvi_subfeature
│  │         Examples:
│  │         - Add "Forgot Password" to authentication
│  │         - Add "Transfer Money" to wallet
│  │         - Add "Edit Profile" to profile
│  │
│  └─ NO → Use mvi_feature
│            Examples:
│            - Create authentication module
│            - Create wallet module
│            - Create profile module
```

---

## 📋 Quick Comparison

| Aspect | mvi_feature | mvi_subfeature |
|--------|-------------|----------------|
| **Creates** | Entire module | Files in existing module |
| **Repository** | New | Reuses existing |
| **Bloc** | New | Reuses existing |
| **Data Sources** | New | Reuses existing |
| **Use Cases** | Multiple generic | Single specific |
| **Best For** | New domain | Related feature |

---

## 🚀 Quick Start Examples

### Example 1: Create Wallet Module

```bash
# Step 1: Generate module
mason make mvi_feature
# → What is the feature name? wallet

# Step 2: Run code generation
melos genAlls

# Step 3: Implement your business logic
# Edit the generated files in lib/features/wallet/
```

### Example 2: Add Transfer Feature to Wallet

```bash
# Step 1: Generate subfeature
mason make mvi_subfeature
# → Module name? wallet
# → Subfeature name? transfer_money
# → Entity name? [Press Enter to use wallet's entity]
# → Create new data model? N
# → Create new entity? N

# Step 2: Add action to WalletBloc
# Edit lib/features/wallet/presentation/mvi/wallet_action.dart
# Add: class TransferMoneyAction extends WalletAction { ... }

# Step 3: Handle action in bloc
# Edit lib/features/wallet/presentation/mvi/wallet_bloc.dart
# Add: case TransferMoneyAction: ...

# Step 4: Run code generation
melos genAlls
```

### Example 3: Add Forgot Password to Authentication

```bash
# Step 1: Generate subfeature
mason make mvi_subfeature
# → Module name? authentication
# → Subfeature name? forgot_password
# → Entity name? [Press Enter]
# → Create new data model? N
# → Create new entity? N

# Step 2: Add repository method
# Edit lib/features/authentication/domain/repositories/authentication_repository.dart
# Add: Future<Either<Failure, void>> sendPasswordResetEmail(String email);

# Step 3: Implement repository method
# Edit lib/features/authentication/data/repositories/authentication_repository_impl.dart

# Step 4: Add action and handler to bloc
# Edit action, bloc files

# Step 5: Run code generation
melos genAlls
```

---

## 📚 Detailed Documentation

For comprehensive guides, see:

- **mvi_feature**: See `bricks/mvi_feature/README.md`
- **mvi_subfeature**: See `bricks/mvi_subfeature/README.md` or `docs/mason/MVI_SUBFEATURE_GUIDE.md`
- **General Mason**: See `docs/mason/MASON_GUIDE.md`

---

## 🔧 Common Commands

```bash
# List available templates
mason list

# Generate new module
mason make mvi_feature

# Generate subfeature
mason make mvi_subfeature

# Run code generation after creating files
melos genAlls

# Format code
dart format lib/

# Verify no issues (MUST be 0)
flutter analyze --no-fatal-infos
```

---

## ⚡ Post-Generation Checklist

After generating with either template:

- [ ] Implement use case logic
- [ ] Add actions to bloc (if using mvi_subfeature)
- [ ] Handle actions in bloc
- [ ] Update repository interface and implementation (if needed)
- [ ] Add translations (`assets/locales/*.i18n.json`)
- [ ] Implement page UI
- [ ] Add route to `app_router.dart`
- [ ] Run `melos genAlls`
- [ ] Run `dart format lib/`
- [ ] Run `flutter analyze --no-fatal-infos` (must be 0 issues)

---

## 💡 Tips

1. **Start with mvi_feature** for any new domain concept
2. **Use mvi_subfeature** for variations/extensions of existing modules
3. **Reuse entities** when possible (press Enter for entity name)
4. **Create new entities** only when subfeature has different data structure
5. **Always run melos genAlls** after generation
6. **Check existing code** for consistency and patterns

---

## 🎨 Architecture Pattern

Both templates follow **Clean Architecture + MVI**:

```
Presentation Layer (UI, BLoC, Actions, States, Events)
        ↓
Domain Layer (Entities, Use Cases, Repository Interfaces)
        ↓
Data Layer (Models, Data Sources, Repository Implementations)
```

**Key Principles:**
- Single entry point: `bloc.onAction()`
- Unidirectional data flow
- Clear separation of concerns
- Testable at every layer

---

**Last Updated:** 2026-01-12  
**For Questions:** See detailed guides in `docs/mason/` or brick READMEs
