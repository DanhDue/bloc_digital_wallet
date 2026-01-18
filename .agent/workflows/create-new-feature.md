---
description: Create a new feature or subfeature based on a simplified prompt.
---
# Create New Feature Workflow

This workflow automates the creation of a new feature or subfeature.

> [!IMPORTANT]
> **Import Convention**: Always use **full package paths** (e.g., `import 'package:bloc_digital_wallet/core/network/app_uri.dart';`) instead of relative imports (e.g., `import '../../core/network/app_uri.dart';`).

## 1. Analyze Request
Analyze the `GOAL`, `Figma Design`, `Functionality`, and `Requirements` provided in the prompt.
- **Determine Type**: Is it a [New Module] or a [Subfeature]?
- **Identify Name**: What is the feature name (snake_case)?
- **Identify Parent**: If subfeature, what is the parent module?

## 2. Generate Structure (Mason)

### If [New Module]:
Run the following command (replace `{{feature_name}}` with the actual name):
```bash
// turbo
mason make mvi_feature --feature_name {{feature_name}}
```

### If [Subfeature]:
Run the following command (replace `{{module_name}}` and `{{subfeature_name}}`):
```bash
// turbo
mason make mvi_subfeature --module_name {{module_name}} --subfeature_name {{subfeature_name}}
```

## 3. Implement Domain Layer
- Create/Update Entities with `@freezed`, `abstract class`, and `@JsonKey` annotations.
  - Import `freezed_annotation` and `foundation.dart`
  - Use `@JsonKey(name: 'field_name')` for each field
  - ⚠️ **IMPORTANT**: All entities and models will use freezed with `@JsonKey` annotations.
- Create/Update Repository Interfaces.
- Create Use Cases matching the `Functionality` requirements.

## 4. Implement Data Layer
- Create/Update Models (DTOs) with `@freezed`, `abstract class`, and `@JsonKey` annotations.
  - Import `freezed_annotation` and `foundation.dart`
  - Use `@JsonKey(name: 'field_name')` for each field
  - ⚠️ **IMPORTANT**: All entities and models will use freezed with `@JsonKey` annotations.
- Implement Remote Data Source (API calls).
- Implement Repository.

## 5. Implement Presentation Layer (MVI)
- **Actions**: Define user actions (e.g., `SubmitEmail`, `LoadData`).
- **States**: Define UI states (e.g., `Loading`, `Success`, `Error`).
- **Events**: Define one-off events (e.g., `Navigation`, `ShowSnackBar`).
- **BLoC**: Implement logic handling Actions -> UseCases -> States/Events.
- **Pages**: Implement UI using `context.appThemes` and `context.t`.
  - **IMPORTANT**: Use `figma-dev-mode-mcp-server` to fetch design specs if a Figma link is provided.
  - **IMPORTANT**: Ensure proper navigation and routing in `app_router.dart`.

## 6. Configuration & Verification
- Add translations to `en.i18n.json` and `vi.i18n.json`.
- Add routes to `AppRouter` (`lib/app_router.dart`).
- Run code generation:
```bash
// turbo
melos genAlls
```
- Format code:
```bash
// turbo
dart format lib/
```
- Analyze code:
```bash
// turbo
fvm flutter analyze --no-fatal-infos
```

## 7. Final Verification
- Verify that all `Requirements` are met.
- Verify that the standard `GenericFailure` handling is used (via `SafeCallApiMixin` if applicable).
