---
inclusion: always
---

# Flutter BLOC Digital Wallet - Development Patterns

This project uses **Clean Architecture** with **MVI (Model-View-Intent)** pattern for state management.

## Critical Architecture Rules

### 1. Layer Organization
- **Domain**: Business logic, entities, repositories (abstract)
- **Data**: API clients, models, repository implementations
- **Presentation**: UI, BLoC, pages, widgets

### 2. MVI Pattern Flow
```
User Action → Intent → BLoC → State + Side Effects → UI Update
```

### 3. File Structure Pattern
```
lib/features/{feature_name}/
├── data/
│   ├── datasources/
│   │   ├── {feature}_remote_datasource.dart
│   │   └── {feature}_local_datasource.dart
│   ├── models/
│   │   └── {entity}_model.dart
│   └── repositories/
│       └── {feature}_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── {entity}.dart
│   ├── repositories/
│   │   └── {feature}_repository.dart
│   └── usecases/
│       └── {usecase}_usecase.dart
└── presentation/
    ├── bloc/
    │   ├── {feature}_bloc.dart
    │   ├── {feature}_event.dart
    │   ├── {feature}_state.dart
    │   └── {feature}_side_effect.dart
    ├── pages/
    │   └── {feature}_page.dart
    └── widgets/
        └── {widget_name}_widget.dart
```

### 4. Naming Conventions
- **Classes**: PascalCase (e.g., `WalletBloc`, `LoadWalletIntent`)
- **Files**: snake_case (e.g., `wallet_bloc.dart`)
- **Constants**: camelCase (e.g., `walletTimeout`)
- **Booleans**: Start with `is`, `has`, `can` (e.g., `isLoading`, `hasError`)

### 5. Theme & Styling - ALWAYS Use context.appThemes

#### Color Usage: Strict 4-Step Workflow

**Step 1: Define** - Add color to `assets/colors/colors.xml`
```xml
<color name="primaryColor">#FF6200EE</color>
```

**Step 2: Expose** - Add field to `lib/config/theme/app_themes.dart`
```dart
class AppThemes {
  final Color primaryColor;
  
  const AppThemes({
    required this.primaryColor,
    // ... other fields
  });
  
  AppThemes copyWith({Color? primaryColor}) => AppThemes(
    primaryColor: primaryColor ?? this.primaryColor,
    // ... other fields
  );
  
  static const AppThemes light = AppThemes(
    primaryColor: Color(0xFF6200EE),
    // ... other colors
  );
  
  static const AppThemes dark = AppThemes(
    primaryColor: Color(0xFF6200EE),
    // ... other colors
  );
}
```

**Step 3: Generate** - Run code generation
```bash
melos genAlls
```

**Step 4: Use** - Access via context.appThemes
```dart
// ✅ Correct
Text('Hello', style: context.appThemes.bodyMedium)
Container(color: context.appThemes.primaryColor)
Text('Hello', style: TextStyle(color: context.appThemes.textColor))

// ❌ Never hardcode colors
Container(color: Colors.red)
Container(color: Color(0xFF6200EE))
Text('Hello', style: TextStyle(color: Colors.blue))
```

#### Dot Shorthands for Enums
Use dot shorthands for Enums and static members to reduce verbosity:
```dart
// ✅ Preferred
BoxFit fit = .contain
BlendMode mode = .srcIn
BottomNavigationBarType type = .fixed

// ❌ Avoid
BoxFit fit = BoxFit.contain
BlendMode mode = BlendMode.srcIn
BottomNavigationBarType type = BottomNavigationBarType.fixed
```

### 6. Localization - ALWAYS Use context.t
```dart
// ✅ Correct
Text(context.t.authWelcomeBack)

// ❌ Never hardcode strings
Text('Welcome Back')
```

### 7. State Management - Single Entry Point
```dart
// ✅ Only way to trigger actions
_bloc.onAction(const LoadDataAction());

// ❌ Never add events directly
_bloc.add(LoadDataEvent());  // Wrong!
```

### 8. Code Generation
Run before committing:
```bash
melos genAlls  # Generates models, APIs, themes, assets, localization
```

## Common Patterns

### Creating a New Feature
1. Use Mason: `mason make mvi_feature --feature_name wallet`
2. Implement domain layer (entities, repositories, usecases)
3. Implement data layer (models, datasources, repository impl)
4. Implement presentation layer (BLoC, pages, widgets)
5. Register in DI container
6. Add routes in AutoRoute

### Adding New API Endpoint
1. Add method to Retrofit client in `data/datasources/`
2. Create model with `@freezed` and `@JsonSerializable`
3. Implement in repository
4. Create usecase
5. Add intent/state to BLoC
6. Update UI

### Error Handling
- Use `Either<Failure, Success>` from dartz
- Define custom failures in `core/errors/failures.dart`
- Handle in BLoC and emit error state
- Show user-friendly messages via localization

## Testing Requirements
- Unit tests for usecases and repositories
- Widget tests for UI components
- Mock external dependencies with mocktail
- Aim for >80% code coverage

## Before Submitting Code
```bash
dart format lib/
flutter analyze --no-fatal-infos  # Must show "No issues found!"
flutter test
```

## Key Dependencies
- **State Management**: flutter_bloc, bloc
- **DI**: get_it, injectable
- **Networking**: dio, retrofit
- **Storage**: hive, shared_preferences
- **Code Gen**: freezed, json_serializable, build_runner
- **Functional**: dartz (Either, Option)
- **Routing**: auto_route
- **Localization**: slang
- **Theme**: theme_tailor

## Documentation References
- [AI Agent Context](docs/ai-agents/AI_AGENT_CONTEXT.md) - Architecture patterns
- [Implementation Guide](docs/development/IMPLEMENTATION_GUIDE.md) - Step-by-step tutorial
- [Architecture Guide](docs/architecture/ARCHITECTURE.md) - Detailed architecture
- [Quick Reference](docs/getting-started/QUICK_REFERENCE.md) - Code templates
