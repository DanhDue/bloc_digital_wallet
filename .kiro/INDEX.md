# Kiro Configuration Index

**Project**: BLOC Digital Wallet  
**Last Updated**: 2026-01-22  
**Status**: ✅ Active

## Quick Start

New to this project? Start here:

1. **[README.md](.kiro/README.md)** - Overview and navigation
2. **[QUICK_START.md](.kiro/QUICK_START.md)** - 5-minute setup guide
3. **[Project Conventions](steering/project-conventions.md)** - Critical rules
4. **[MVI Architecture](steering/mvi-architecture.md)** - Architecture patterns

## Directory Structure

```
.kiro/
├── INDEX.md                          # This file - Master index
├── README.md                         # Main navigation hub
├── QUICK_START.md                    # Quick start guide
├── SETUP_SUMMARY.md                  # Setup documentation
├── settings/
│   └── mcp.json                      # MCP server configuration
├── steering/                         # Development rules (always included)
│   ├── flutter-bloc-patterns.md      # Flutter BLOC patterns
│   ├── spec-guidelines.md            # Spec workflow
│   ├── project-conventions.md        # Critical conventions
│   ├── mvi-architecture.md           # MVI pattern guide
│   └── mason-workflows.md            # Mason brick workflows
└── specs/                            # Feature specifications
    ├── README.md                     # Specs workflow guide
    └── {feature_name}/               # Individual feature specs
        ├── requirements.md           # Requirements
        ├── design.md                 # Design
        └── tasks.md                  # Implementation tasks
```

## Steering Files

Steering files provide context and rules that are automatically included in your workflow.

| File | Purpose | When to Reference |
|------|---------|-------------------|
| **[flutter-bloc-patterns.md](steering/flutter-bloc-patterns.md)** | Flutter BLOC architecture rules | Creating features, following patterns |
| **[spec-guidelines.md](steering/spec-guidelines.md)** | Spec-driven development workflow | Creating specs, planning features |
| **[project-conventions.md](steering/project-conventions.md)** | Critical project conventions | All code - imports, freezed, theme, i18n |
| **[mvi-architecture.md](steering/mvi-architecture.md)** | MVI pattern implementation | State management, BLoC implementation |
| **[mason-workflows.md](steering/mason-workflows.md)** | Mason brick usage | Feature generation, scaffolding |

## Critical Conventions

### Must Follow (Always)

1. **Imports**: Full package paths only
   ```dart
   import 'package:bloc_digital_wallet/core/network/app_uri.dart';
   ```

2. **Freezed**: All entities/models use `@freezed` + `@JsonKey`
   ```dart
   @freezed
   abstract class WalletEntity with _$WalletEntity {
     const factory WalletEntity({
       @JsonKey(name: 'id') required String id,
     }) = _WalletEntity;
   }
   ```

3. **Theme**: Always use `context.appThemes`
   ```dart
   Container(color: context.appThemes.primaryColor)
   ```

4. **Localization**: Always use `context.t`
   ```dart
   Text(context.t.walletTitle)
   ```

5. **MVI**: Single entry point with `bloc.onAction()`
   ```dart
   bloc.onAction(const LoadWalletAction());
   ```

## Common Workflows

### Create New Feature

1. **Determine type**: New module or subfeature?
2. **Run Mason**:
   - New module: `mason make mvi_feature --feature_name {name}`
   - Subfeature: `mason make mvi_subfeature --module_name {module} --subfeature_name {name}`
3. **Implement layers**: Domain → Data → Presentation
4. **Configure**: Translations, routes, DI
5. **Generate**: `melos genAlls && dart format lib/ && flutter analyze --no-fatal-infos`

See: [mason-workflows.md](steering/mason-workflows.md)

### Create Feature Spec

1. **Create directory**: `.kiro/specs/{feature_name}/`
2. **Write requirements.md**: User stories with EARS patterns
3. **Write design.md**: Architecture and correctness properties
4. **Write tasks.md**: Implementation checklist
5. **Execute incrementally**: Follow tasks with testing

See: [specs/README.md](specs/README.md)

### Add API Integration

1. **Define entity** with `@freezed` and `@JsonKey`
2. **Define model** with `@freezed` and `@JsonKey`
3. **Create Retrofit client** with explicit baseUrl
4. **Implement data source** with `SafeCallApiMixin`
5. **Implement repository**
6. **Create use case**
7. **Add to BLoC**: Action → State → Event
8. **Update UI**: Use `context.appThemes` and `context.t`
9. **Generate**: `melos genAlls`

See: [mvi-architecture.md](steering/mvi-architecture.md)

## Architecture Overview

### MVI Pattern Flow
```
User Action → Intent (Action) → BLoC → State + Side Effects → UI Update
```

### Clean Architecture Layers
```
Presentation → Domain ← Data
     ↓           ↓        ↓
   BLoC    Use Cases  Repository Impl
     ↓           ↓        ↓
  Pages     Entities   Models
```

### File Structure
```
lib/features/{feature_name}/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
└── presentation/
    ├── bloc/
    ├── pages/
    └── widgets/
```

See: [mvi-architecture.md](steering/mvi-architecture.md)

## Code Generation Commands

```bash
# Generate all code (models, routes, translations, assets, theme)
melos genAlls

# Format code
dart format lib/

# Analyze code (must show "No issues found!")
flutter analyze --no-fatal-infos

# Run tests
flutter test

# Clean and regenerate
flutter clean && flutter pub get && melos genAlls
```

## Mason Bricks

| Brick | Command | Purpose |
|-------|---------|---------|
| **mvi_feature** | `mason make mvi_feature --feature_name {name}` | Create new module |
| **mvi_subfeature** | `mason make mvi_subfeature --module_name {module} --subfeature_name {name}` | Add to existing module |
| **remove_feature** | `mason make remove_feature --feature_name {name}` | Remove module |
| **remove_subfeature** | `mason make remove_subfeature --module_name {module} --subfeature_name {name}` | Remove subfeature |
| **sample** | `mason make sample --feature_name {name}` | Create demo feature |

See: [mason-workflows.md](steering/mason-workflows.md)

## Spec-Driven Development

### Workflow Phases

1. **Requirements**: User stories with EARS patterns
2. **Design**: Architecture and correctness properties
3. **Tasks**: Implementation checklist
4. **Implementation**: Execute tasks incrementally

### EARS Patterns

- **Ubiquitous**: `THE <system> SHALL <response>`
- **Event-driven**: `WHEN <trigger>, THE <system> SHALL <response>`
- **State-driven**: `WHILE <condition>, THE <system> SHALL <response>`
- **Unwanted event**: `IF <condition>, THEN THE <system> SHALL <response>`
- **Optional feature**: `WHERE <option>, THE <system> SHALL <response>`

See: [specs/README.md](specs/README.md)

## Integration with .agent Folder

The `.agent` folder contains AI agent-specific documentation and skills. Kiro steering files complement this:

| .agent | .kiro | Purpose |
|--------|-------|---------|
| `.agent/rules/` | `.kiro/steering/` | Development rules |
| `.agent/workflows/` | `.kiro/specs/` | Feature workflows |
| `.agent/skills/` | `.kiro/steering/mason-workflows.md` | Code generation |
| `.agent/patterns/` | `.kiro/steering/mvi-architecture.md` | Architecture patterns |

## Documentation Map

```
Project Root
├── .kiro/                              # Kiro configuration
│   ├── INDEX.md                        # This file
│   ├── README.md                       # Main navigation
│   ├── QUICK_START.md                  # Quick start
│   ├── steering/                       # Development rules
│   │   ├── project-conventions.md      # Critical conventions
│   │   ├── mvi-architecture.md         # MVI patterns
│   │   ├── mason-workflows.md          # Mason bricks
│   │   ├── flutter-bloc-patterns.md    # Flutter BLOC
│   │   └── spec-guidelines.md          # Spec workflow
│   └── specs/                          # Feature specs
│       └── README.md                   # Specs guide
├── .agent/                             # AI agent resources
│   ├── README.md                       # Agent overview
│   ├── JULES_GUIDE.md                  # Master agent index
│   ├── rules/                          # Agent rules
│   ├── workflows/                      # Agent workflows
│   ├── skills/                         # Agent skills
│   └── patterns/                       # Code patterns
└── docs/                               # Project documentation
    ├── ai-agents/                      # AI agent docs
    ├── architecture/                   # Architecture docs
    ├── development/                    # Development guides
    └── getting-started/                # Quick start guides
```

## Key Concepts

### Freezed Models
All entities and models use:
- `@freezed` annotation
- `abstract class` with `_$ClassName` mixin
- `@JsonKey(name: 'field_name')` for every field

### MVI Components
- **Actions**: User intents (e.g., `LoadWalletAction`)
- **States**: UI states (e.g., `WalletLoadedState`)
- **Events**: Side effects (e.g., `ShowSuccessEvent`)
- **BLoC**: Logic coordinator

### Clean Architecture
- **Domain**: Business logic (entities, repositories, use cases)
- **Data**: Data handling (models, data sources, repository impl)
- **Presentation**: UI (BLoC, pages, widgets)

## Troubleshooting

### Import Errors
```dart
// ✅ Use full package paths
import 'package:bloc_digital_wallet/core/network/app_uri.dart';

// ❌ Don't use relative imports
import '../../core/network/app_uri.dart';
```

### Code Generation Errors
```bash
# Clean and regenerate
flutter clean
flutter pub get
melos genAlls
```

### Analysis Errors
```bash
# Must show "No issues found!"
flutter analyze --no-fatal-infos

# If errors persist, check:
# 1. All imports use full package paths
# 2. All entities/models use @freezed with @JsonKey
# 3. Code generation completed successfully
```

### Theme/Localization Errors
```dart
// ✅ Always use context extensions
Text(context.t.walletTitle)
Container(color: context.appThemes.primaryColor)

// ❌ Never hardcode
Text('Wallet')
Container(color: Colors.blue)
```

## Resources

### Internal Documentation
- [.kiro/README.md](README.md) - Main navigation
- [.kiro/QUICK_START.md](QUICK_START.md) - Quick start guide
- [.kiro/specs/README.md](specs/README.md) - Specs workflow
- [.agent/README.md](../.agent/README.md) - AI agent resources
- [.agent/JULES_GUIDE.md](../.agent/JULES_GUIDE.md) - Master agent index

### Project Documentation
- [docs/ai-agents/AI_AGENT_CONTEXT.md](../docs/ai-agents/AI_AGENT_CONTEXT.md) - Code patterns
- [docs/development/IMPLEMENTATION_GUIDE.md](../docs/development/IMPLEMENTATION_GUIDE.md) - Tutorial
- [docs/architecture/ARCHITECTURE.md](../docs/architecture/ARCHITECTURE.md) - Architecture
- [docs/getting-started/QUICK_REFERENCE.md](../docs/getting-started/QUICK_REFERENCE.md) - Templates

### External Resources
- [Flutter Documentation](https://flutter.dev)
- [BLoC Documentation](https://bloclibrary.dev)
- [Mason Documentation](https://github.com/felangel/mason)
- [Freezed Documentation](https://pub.dev/packages/freezed)

## Quick Reference

### File Naming
- Files: `snake_case.dart`
- Classes: `PascalCase`
- Variables: `camelCase`
- Booleans: `isLoading`, `hasError`, `canSubmit`

### Common Commands
```bash
# Feature generation
mason make mvi_feature --feature_name wallet

# Code generation
melos genAlls

# Format
dart format lib/

# Analyze
flutter analyze --no-fatal-infos

# Test
flutter test
```

### Common Patterns
```dart
// Action
const factory WalletAction.load() = LoadWalletAction;

// State
const factory WalletState.loaded({required List<Wallet> wallets}) = WalletLoadedState;

// Event
const factory WalletEvent.showSuccess(String message) = ShowSuccessEvent;

// BLoC usage
bloc.onAction(const WalletAction.load());

// Theme
context.appThemes.primaryColor

// Localization
context.t.walletTitle
```

## Getting Help

### For Questions About
- **Getting started**: [QUICK_START.md](QUICK_START.md)
- **Architecture**: [mvi-architecture.md](steering/mvi-architecture.md)
- **Conventions**: [project-conventions.md](steering/project-conventions.md)
- **Mason bricks**: [mason-workflows.md](steering/mason-workflows.md)
- **Specs**: [specs/README.md](specs/README.md)
- **Code patterns**: [docs/ai-agents/AI_AGENT_CONTEXT.md](../docs/ai-agents/AI_AGENT_CONTEXT.md)

### Common Issues
1. **Import errors**: Use full package paths
2. **Generation errors**: Run `melos genAlls`
3. **Analysis errors**: Check conventions
4. **Theme errors**: Use `context.appThemes`
5. **i18n errors**: Use `context.t`

---

**Version**: 1.0.0  
**Last Updated**: 2026-01-22  
**Status**: ✅ Active and Complete
