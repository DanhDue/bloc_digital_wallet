# BLOC DIGITAL WALLET

A modern digital wallet app built with **Flutter**, following **Clean Architecture** and **MVI (Model-View-Intent)** pattern.

## 🏗️ Architecture

- ✅ **Clean Architecture** - Domain, Data, Presentation layers
- ✅ **MVI Pattern** - Model-View-Intent for predictable state management
- ✅ **Feature-First** - Code organized by features
- ✅ **Modern Flutter Stack** - Latest best practices and packages

## 📚 Documentation

### 📘 For Beginners
- **[Implementation Guide](IMPLEMENTATION_GUIDE.md)** - Step-by-step feature creation guide
- **[Quick Reference](QUICK_REFERENCE.md)** - Cheat sheet with code templates
- **[Quick Start](docs/QUICK_START.md)** - Get started in 5 minutes
- **[Double Check Guide](DOUBLE_CHECK_GUIDE.md)** ⚠️ **MUST READ** - Verification steps

### 📗 For Advanced Developers
- **[Architecture Guide](ARCHITECTURE.md)** - Complete architecture overview
- **[Visual Guide](docs/VISUAL_GUIDE.md)** - Architecture diagrams
- **[Mason Guide](docs/MASON_GUIDE.md)** - Code generation guide

### 🤖 For AI Agents
- **[AI Agent README](AI_AGENT_README.md)** - Start here! Complete guide index
- **[AI Agent Context](AI_AGENT_CONTEXT.md)** - Architecture context & patterns
- **[AI Agent Workflows](AI_AGENT_WORKFLOWS.md)** - Step-by-step task workflows
- **[AI Agent Checklist](AI_AGENT_CHECKLIST.md)** - Quick reference checklist
- **[Double Check Guide](DOUBLE_CHECK_GUIDE.md)** ⚠️ **MANDATORY** - Verification steps

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

- Light/Dark mode support
- Multi-language (en_US, vn_VI)
- Type-safe theme access

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

- **[Implementation Guide](IMPLEMENTATION_GUIDE.md)** - Complete tutorial for creating features
- **[Quick Reference](QUICK_REFERENCE.md)** - Cheat sheet with code templates
- **[Architecture Guide](ARCHITECTURE.md)** - Clean Architecture + MVI overview
- **[MVI Flow](ARCHITECTURE.md#2-presentation-layer-flutter)** - Understanding Action, State, Event
- **[Visual Guide](docs/VISUAL_GUIDE.md)** - Architecture diagrams
- **[Mason Usage](docs/MASON_GUIDE.md)** - Code generation guide

## 📝 License

Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

---

Built with ❤️ using Clean Architecture + MVI
