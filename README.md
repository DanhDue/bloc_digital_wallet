# BLOC DIGITAL WALLET

A modern digital wallet app built with **Flutter**, following **Clean Architecture** and **MVI (Model-View-Intent)** pattern.

## 🏗️ Architecture

- ✅ **Clean Architecture** - Domain, Data, Presentation layers
- ✅ **MVI Pattern** - Model-View-Intent for predictable state management
- ✅ **Feature-First** - Code organized by features
- ✅ **Modern Flutter Stack** - Latest best practices and packages

## 📚 Documentation

👉 **[DOCUMENTATION_INDEX.md](DOCUMENTATION_INDEX.md)** - Complete documentation navigation  
⚡ **[.cursorrules](.cursorrules)** - Quick development rules & patterns (for Cursor AI)

### 📘 For Beginners
- **[Implementation Guide](docs/development/IMPLEMENTATION_GUIDE.md)** - Step-by-step feature creation guide
- **[Quick Reference](docs/getting-started/QUICK_REFERENCE.md)** - Cheat sheet with code templates
- **[Quick Start](docs/getting-started/QUICK_START.md)** - Get started in 5 minutes
- **[Double Check Guide](docs/ai-agents/DOUBLE_CHECK_GUIDE.md)** ⚠️ **MUST READ** - Verification steps

### 📗 For Advanced Developers
- **[Architecture Guide](docs/architecture/ARCHITECTURE.md)** - Complete architecture overview
- **[Architecture Diagrams](docs/architecture/ARCHITECTURE.md#1-clean-architecture--mvi-diagram)** - Visual guides
- **[Mason Guide](docs/mason/MASON_GUIDE.md)** - Code generation guide

### 🤖 For AI Agents
- **[AI Agent README](docs/ai-agents/AI_AGENT_README.md)** - Start here! Complete guide index
- **[AI Agent Context](docs/ai-agents/AI_AGENT_CONTEXT.md)** - Architecture context & patterns
- **[AI Agent Workflows](docs/ai-agents/AI_AGENT_WORKFLOWS.md)** - Step-by-step task workflows
- **[AI Agent Checklist](docs/ai-agents/AI_AGENT_CHECKLIST.md)** - Quick reference checklist
- **[Double Check Guide](docs/ai-agents/DOUBLE_CHECK_GUIDE.md)** ⚠️ **MANDATORY** - Verification steps

### 📝 Task Assignment Templates
- **[Task Prompt Templates](docs/task-prompt-templates/README.md)** ⭐ **NEW** - Ready-to-use templates for AI agents
  - **[Create New Feature](docs/task-prompt-templates/create-new-feature.md)** - For new modules/subfeatures
  - **[Fix Bug](docs/task-prompt-templates/fix-bug.md)** - For bug fixes
  - **[Refactor Code](docs/task-prompt-templates/refactor-code.md)** - For code improvements
  - **[Update UI](docs/task-prompt-templates/update-ui.md)** - For UI/styling updates

**💡 Why Use Templates?**
- ✅ Consistent task structure
- ✅ All critical rules included
- ✅ Complete examples (8 real-world scenarios)
- ✅ Better AI agent performance
- ✅ Fewer errors and iterations

## ⚡ Quick Development Rules

**For fastest development, follow these critical rules:**

```dart
// 1. Theme & Styling - ALWAYS use context.appThemes
Text('Hello', style: context.appThemes.bodyMedium)
Container(color: context.appThemes.surfaceColor)

// 2. Localization - ALWAYS use context.t
Text(context.t.authWelcomeBack)
Text(context.t.authEmail)

// 3. MVI Pattern - Single entry point
_bloc.onAction(const LoadDataAction());  // ✅ Only way
_bloc.events.listen((event) { /* handle one-time effects */ });

// 4. Before submitting - MANDATORY
dart format lib/
flutter analyze --no-fatal-infos  // Must show "No issues found!"
```

📖 **Complete rules**: See [.cursorrules](.cursorrules) file

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK ^3.10.4
- Dart SDK ^3.10.4
- FVM (recommended)

### Quick Start Options

#### Option 1: Using DevContainer (Recommended for AI Agents)

```bash
# Using GitHub Codespaces
1. Click "Code" → "Codespaces" → "Create codespace"
2. Wait for container to build
3. Ready to code!

# Using VS Code Dev Containers
1. Install "Dev Containers" extension
2. Open in VS Code
3. Cmd/Ctrl + Shift + P → "Reopen in Container"
4. Environment automatically configured!
```

📖 **For AI Agents**: See [.devcontainer/README.md](.devcontainer/README.md) for complete setup guide.

#### Option 2: Local Installation

```bash
# Install dependencies
fvm flutter pub get

# Install Mason bricks
mason get

# Generate code
flutter pub run build_runner build --delete-conflicting-outputs
```

### Run the app
```bash
fvm flutter run
```

## 🧱 Generate New Feature

Using Mason to generate Clean Architecture + MVI feature:

```bash
mason make mvi_feature --feature_name wallet
```

This generates:
- Domain layer (entities, repositories, use cases)
- Data layer (models, data sources, repository impl)
- Presentation layer (MVI: intents, states, side effects, BLoC, pages)

## 📁 Project Structure

```
lib/
├── core/                    # Shared code
│   ├── architecture/        # MVI base classes
│   ├── errors/             # Failures & exceptions
│   ├── network/            # API clients
│   └── storage/            # Local storage
├── features/               # Feature modules (generated)
│   └── {feature_name}/
│       ├── data/           # Data layer
│       ├── domain/         # Business logic
│       └── presentation/   # UI (MVI)
└── di/                     # Dependency injection
```

## 🎯 MVI Pattern

**Intent** → **BLoC** → **State** + **Side Effects** → **View**

```dart
// User taps button
context.read<WalletBloc>().add(LoadWalletIntent('address'));

// BLoC processes intent
emit(WalletLoading());
final result = await useCase('address');
emit(WalletLoaded(wallet));
emitSideEffect(ShowSuccessMessage('Loaded!'));

// View rebuilds
BlocBuilder<WalletBloc, WalletState>(
  builder: (context, state) {
    return switch (state) {
      WalletLoading() => CircularProgressIndicator(),
      WalletLoaded(:final wallet) => WalletView(wallet),
      WalletError(:final message) => ErrorView(message),
    };
  },
)
```

## 🛠️ Modern Stack

### State Management
- flutter_bloc + bloc_concurrency

### Dependency Injection
- get_it + injectable

### Networking
- dio + retrofit

### Storage
- hive + shared_preferences + flutter_secure_storage

### Code Generation
- freezed + json_serializable + build_runner + mason

### Functional Programming
- dartz (Either, Option)

## 📦 Key Features

- ✅ Clean Architecture layers
- ✅ MVI pattern for UI
- ✅ Feature-first organization
- ✅ Dependency injection ready
- ✅ Error handling with Either
- ✅ Immutable models (Freezed)
- ✅ Type-safe API clients (Retrofit)
- ✅ Local caching strategy
- ✅ Side effects for one-time events
- ✅ Code generation with Mason

## 🧪 Testing

```bash
# Run tests
flutter test

# Run with coverage
./scripts/testWithCoverage.sh
```

## 🎨 Theme & Localization

- **Light/Dark mode** support
- **Multi-language** (en_US, vn_VI)
- **Type-safe theme** access via `theme_tailor`

### Theme Usage (IMPORTANT)

**Always use `context.appThemes` for colors and styles:**

```dart
// ✅ Correct way
Text(
  'Hello',
  style: context.appThemes.bodyMedium.copyWith(
    color: context.appThemes.textSecondaryColor,
  ),
)

Container(color: context.appThemes.surfaceColor)

// ❌ Never do this
Text('Hello', style: Theme.of(context).textTheme.bodyMedium)
Container(color: Theme.of(context).colorScheme.surface)
Container(color: Colors.red) // No hardcoded colors!
```

**Adding new colors:**
1. Add to `assets/colors/colors.xml`
2. Add field to `lib/config/theme/app_themes.dart`
3. Initialize in both light and dark themes
4. Run `melos genAlls`
5. Use via `context.appThemes.yourColorName`

## 📝 Available Scripts

```bash
melos mason_get              # Install Mason bricks
melos mason_make_feature     # Generate feature
melos build_runner           # Run code generation
melos dartfmt                # Format code
melos test                   # Run tests
melos build_apk             # Build Android APK
```

## 🌟 Benefits

- **Scalable**: Easy to add new features
- **Maintainable**: Clear separation of concerns
- **Testable**: Each layer independently testable
- **Consistent**: Same structure for all features
- **Modern**: Latest Flutter best practices

## 📖 Learn More

### Core Documentation
- **[Documentation Index](DOCUMENTATION_INDEX.md)** - Complete documentation navigation
- **[Implementation Guide](docs/development/IMPLEMENTATION_GUIDE.md)** - Complete tutorial for creating features
- **[Quick Reference](docs/getting-started/QUICK_REFERENCE.md)** - Cheat sheet with code templates
- **[Architecture Guide](docs/architecture/ARCHITECTURE_OVERVIEW.md)** - Clean Architecture + MVI overview
- **[Visual Guide](docs/architecture/VISUAL_GUIDE.md)** - Architecture diagrams
- **[Mason Usage](docs/mason/MASON_GUIDE.md)** - Code generation guide
- **[Environment Setup](docs/environment/FLAVORS_SETUP_COMPLETE.md)** - Environment & flavors configuration

### Working with AI Agents
- **[Task Prompt Templates](docs/task-prompt-templates/README.md)** ⭐ - Structured templates for AI task assignment
  - Use these templates when assigning tasks to AI agents (Cursor, GitHub Copilot, etc.)
  - Ensures consistent, high-quality results
  - Includes 8 complete real-world examples

## 📝 License

Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

---

Built with ❤️ using Clean Architecture + MVI
