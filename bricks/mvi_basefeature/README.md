# MVI Base Feature Brick

Generate a minimal MVI feature with all 3 layers containing skeleton code and developer guidance.

## Usage

```bash
mason make mvi_basefeature --feature_name dashboard
```

## Generated Structure

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
    └── {feature_name}/
        ├── {feature_name}_action.dart
        ├── {feature_name}_bloc.dart
        ├── {feature_name}_event.dart
        ├── {feature_name}_page.dart
        └── {feature_name}_state.dart
```

## States

This brick generates only **Initial** state. Add more states as needed.

## Difference from mvi_feature

| Brick | States | Use Case |
|-------|--------|----------|
| **mvi_feature** | Init, Loading, Success, Error | Network features |
| **mvi_basefeature** | Initial only | Simple UI features |

## Next Steps

1. Define entity properties
2. Add states (Loading, Success, Error)
3. Add actions for user interactions
4. Implement use case logic
5. Connect repository to datasources
