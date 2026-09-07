---
description: Guide for generating a new feature using Mason + MVI logic
---
# Feature Generation Workflow

Use this workflow to generate a complete feature structure using Mason, then implement the MVI logic.

## 1. Preparation
- **Determine**: Is it a `mvi_feature` (new module) or `mvi_subfeature` (existing module)?
- **Names**: Confirm `feature_name` (e.g., `wallet`) or `subfeature_name` (e.g., `send_money`).

## 2. Generation (Mason)
Run the appropriate command:

**New Module:**
```bash
mason make mvi_feature --feature_name <name>
```

**Subfeature:**
```bash
mason make mvi_subfeature --module_name <module> --subfeature_name <subfeature>
```

## 3. Registration
1.  **DI**: The `lib/di/injection.dart` should only contain `configureModuleDependencies()`. Network DI (Retrofit clients) goes in `data/di/network_module.dart` with class name `{Feature}NetworkModule`.
2.  **Router**: Add entry to `lib/app_router.dart`.
3.  **Strings**: Add keys to `assets/locales/en.i18n.json`.

## 4. Implementation Loop
1.  **Domain**: Define `Entity` (@freezed + `foundation.dart`) -> `Repository` (interface) -> `UseCase`.
2.  **Data**: Define `Model` (@freezed + `foundation.dart`) -> `RemoteDataSource` (API) -> `RepositoryImpl`.
3.  **Presentation**:
    - Define `Action` (User intent).
    - Define `State` (View state).
    - Implement `Bloc` logic (transform Action -> State).
    - Build `Page` UI.

> **Note**: All @freezed classes require both imports:
> ```dart
> import 'package:flutter/foundation.dart';
> import 'package:freezed_annotation/freezed_annotation.dart';
> ```

## 5. Verification
- `melos genAlls`
- `fvm flutter analyze --no-fatal-infos`
