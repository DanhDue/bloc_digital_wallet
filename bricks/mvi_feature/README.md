# MVI Feature Brick

Generate a complete feature following **Clean Architecture + MVI** pattern with feature-first organization.

## 🎯 Purpose

This Mason brick scaffolds a new feature with all necessary layers:
- **Domain Layer**: Entities, repositories (interfaces), and use cases
- **Data Layer**: Models, data sources (local/remote), and repository implementations
- **Presentation Layer**: MVI components (Action, State, Event, BLoC) and UI pages

## 📦 Usage

### Basic Usage

```bash
mason make mvi_feature
```

You'll be prompted for:
- `feature_name`: The name of your feature (e.g., `transaction`, `wallet`, `profile`)
- `year`: Copyright year (auto-set to current year, press Enter to accept)

### Non-Interactive Usage

```bash
mason make mvi_feature --feature_name transaction --year 2025
```

## 🎨 Generated Structure

```
lib/features/{feature_name}/
├── data/
│   ├── datasources/
│   │   ├── {feature_name}_local_datasource.dart
│   │   └── {feature_name}_remote_datasource.dart
│   ├── models/
│   │   └── {feature_name}_model.dart
│   └── repositories/
│       └── {feature_name}_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── {feature_name}_entity.dart
│   ├── repositories/
│   │   └── {feature_name}_repository.dart
│   └── usecases/
│       └── get_{feature_name}_usecase.dart
└── presentation/
    ├── models/
    │   └── {feature_name}_ui_model.dart
    └── {feature_name}/
        ├── {feature_name}_action.dart
        ├── {feature_name}_bloc.dart
        ├── {feature_name}_event.dart
        ├── {feature_name}_page.dart
        └── {feature_name}_state.dart
```

## 🔧 Variables

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `feature_name` | string | (required) | The name of the feature (snake_case recommended) |
| `year` | number | Current year | Copyright year (auto-set via `pre_gen.dart` hook) |

## 🪝 Hooks

### `pre_gen.dart`

Automatically sets the `year` variable to the current year if not provided by the user. This ensures copyright headers always have the correct year.

```dart
Future<void> run(HookContext context) async {
  if (!context.vars.containsKey('year') || context.vars['year'] == null) {
    context.vars['year'] = DateTime.now().year;
  }
}
```

## 📝 Generated Files Details

### Domain Layer (Pure Dart)

- **Entity**: Immutable data class using Equatable
- **Repository Interface**: Abstract contract for data operations
- **Use Cases**: Business logic isolated from UI and data sources

### Data Layer

- **Model**: Entity + JSON serialization (`freezed`, `json_serializable`)
- **Data Sources**: Local (Hive, SharedPreferences) and Remote (Retrofit, Dio)
- **Repository Implementation**: Implements domain repository, handles errors with `Either`

### Presentation Layer (MVI)

- **Action**: User interactions (e.g., button clicks, input changes)
- **State**: UI state (Loading, Success, Error, etc.)
- **Event**: One-time side effects (e.g., navigation, snackbar, dialog)
- **BLoC**: Processes Actions → emits States & Events
- **Page**: Flutter widget with `BlocConsumer` for State & Event handling

## 🎯 MVI Architecture Principles

### Unidirectional Data Flow

```
User Action → BLoC (onAction) → Domain → Data → BLoC (emit State/Event) → UI
```

### Key Concepts

- **Action**: What user wants to do (e.g., `LoadData`, `SubmitForm`)
- **State**: Current UI state (e.g., `Loading`, `Success`, `Error`)
- **Event**: One-time effects (e.g., `NavigateToDetail`, `ShowError`)

### Android Alignment

This MVI implementation mirrors Android architecture:
- **Action** = Android's Intent/Action
- **State** = StateFlow pattern
- **Event** = Channel pattern (one-shot)

## 📚 Next Steps After Generation

1. **Define Entity Properties**: Update entity with actual fields
2. **Implement Use Cases**: Add business logic
3. **Implement Data Sources**: Connect to APIs or local storage
4. **Define Actions/States/Events**: Create specific actions and states for your feature
5. **Implement BLoC Logic**: Handle actions and emit states
6. **Build UI**: Create the page layout and widgets
7. **Add Dependency Injection**: Register in `di/injection.dart`
8. **Add Navigation**: Register route in `config/router.dart`
9. **Write Tests**: Unit tests for use cases, BLoC, and repositories

## 📖 Documentation References

- **Architecture Guide**: `/docs/ARCHITECTURE.md`
- **Implementation Guide**: `/IMPLEMENTATION_GUIDE.md`
- **Quick Reference**: `/QUICK_REFERENCE.md`
- **AI Agent Workflows**: `/AI_AGENT_WORKFLOWS.md`

## 🔍 Example Usage

### Creating a Transaction Feature

```bash
# Generate the feature
mason make mvi_feature --feature_name transaction

# The brick creates:
# - lib/features/transaction/...
# - All necessary files with:
#   - Copyright (c) 2025, one of DanhDue ExOICTIF projects. All rights reserved.
#   - Proper MVI structure
#   - TODO comments for customization
```

## 🚨 Important Notes

1. **Naming Convention**: Use `snake_case` for feature names (e.g., `user_profile`, not `UserProfile`)
2. **Domain Layer Purity**: Never import Flutter packages in domain layer
3. **MVI Pattern**: Follow Action → State transformation strictly
4. **Events for Side Effects**: Use Events for navigation, dialogs, snackbars
5. **Copyright Year**: Automatically set to current year, no manual update needed

## 🛠 Troubleshooting

### Generated files are empty
- Ensure you're running Mason from the project root
- Check that `mason.yaml` is properly configured

### Copyright year is wrong
- The `pre_gen.dart` hook should auto-set the year
- Manually specify: `--year 2025`
- Check that `hooks/pre_gen.dart` exists and is executable

### Files not generated in correct location
- Run from project root
- Feature files should generate in `lib/features/{feature_name}/`

## 📄 License

Copyright (c) 2025, one of DanhDue ExOICTIF projects. All rights reserved.
