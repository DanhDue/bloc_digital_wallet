# Mason & MVI Architecture Guide

This project leverages [Mason](https://pub.dev/packages/mason) to automate the creation of features and subfeatures following the **Clean Architecture + MVI** pattern.

## ⚡ Quick Reference

| Command | Description |
|---|---|
| `mason make mvi_feature --feature_name <name>` | Create a new feature module |
| `mason make mvi_subfeature` | Add a subfeature to a module (interactive prompts) |
| `mason make remove_feature --feature_name <name>` | Remove a feature module |
| `mason make remove_subfeature --module_name <mod> --subfeature_name <name>` | Remove a subfeature |

### `mvi_subfeature` Variables

| Variable | Type | Required | Default | Description |
|----------|------|----------|---------|-------------|
| `module_name` | string | ✅ | - | Parent module name (e.g., `authentication`) |
| `subfeature_name` | string | ✅ | - | Subfeature name (e.g., `forgot_password`) |
| `entity_name` | string | ❌ | `""` | Entity name (leave empty to use module's entity) |
| `needs_model` | boolean | ❌ | `true` | Create a new data model? |
| `needs_entity` | boolean | ❌ | `true` | Create a new entity? |

## 📋 Table of Contents

- [Setup](#setup)
- [Available Bricks](#available-bricks)
  - [mvi_feature](#1-mvi_feature---create-new-module)
  - [mvi_subfeature](#2-mvi_subfeature---add-to-existing-module)
  - [remove_feature](#3-remove_feature---remove-module)
  - [remove_subfeature](#4-remove_subfeature---remove-subfeature)
- [Automated Workflows](#automated-workflows)
- [Decision Tree](#decision-tree)
- [Clean Architecture Structure](#clean-architecture-structure)
- [Troubleshooting](#troubleshooting)

---

## 🚀 Setup

Mason is configured in the project. If you haven't installed the CLI globally:

```bash
dart pub global activate mason_cli
```

To fetch the latest bricks defined in `mason.yaml`:

```bash
mason get
```

---

## 🧱 Available Bricks

### 1. `mvi_feature` - Create New Module

Generates a complete new module (Clean Architecture + MVI) with its own domain, data, and presentation layers.

**Command:**
```bash
mason make mvi_feature --feature_name <name>
```

**What It Does:**
- Creates `lib/features/<name>/` structure.
- **Automatically adds** the route to `lib/app_router.dart`.
- **Automatically runs** `build_runner` and `dart format`.

**Structure:**
```
lib/features/<name>/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
└── presentation/
    ├── <name>/ (main page and bloc)
    └── models/
```

### 2. `mvi_subfeature` - Add to Existing Module

Adds a nested feature (e.g., `forgot_password` inside `authentication`) using the parent's infrastructure where possible.

**Command (Interactive):**
```bash
mason make mvi_subfeature
# → What is the module name? authentication
# → What is the subfeature name? forgot_password
# → Entity name (press Enter to use module's main entity)? [Enter]
# → Create a new data model? false
# → Create a new entity? false
```

**Command (Non-Interactive):**
```bash
mason make mvi_subfeature \
  --module_name authentication \
  --subfeature_name forgot_password \
  --entity_name "" \
  --needs_model false \
  --needs_entity false
```

**What Gets Generated:**
```
lib/features/{module_name}/
  domain/usecases/
    {subfeature_name}_usecase.dart          # Always created
  presentation/pages/
    {subfeature_name}_page.dart             # Always created
  presentation/widgets/
    {subfeature_name}_widget.dart           # Always created
  
  # Optional (if needs_entity = true)
  domain/entities/
    {subfeature_name}_entity.dart
  
  # Optional (if needs_model = true)
  data/models/
    {subfeature_name}_model.dart
```

**What It Does:**
- Adds files to `lib/features/<parent>/`.
- **Automatically adds** the route to `lib/app_router.dart`.
- **Automatically runs** `build_runner` and `dart format`.

### 3. `remove_feature` - Remove Module

Destructively removes a feature module and cleans up.

**Command:**
```bash
mason make remove_feature --feature_name <name>
```

**What It Does:**
- **Deletes** `lib/features/<name>/`.
- **Removes** routes and imports from `lib/app_router.dart`.
- **Runs** `build_runner` to clean up.

### 4. `remove_subfeature` - Remove Subfeature

Destructively removes a subfeature from a module.

**Command:**
```bash
mason make remove_subfeature --module_name <parent> --subfeature_name <name>
```

**What It Does:**
- **Deletes** specific subfeature files (Page, Bloc, UseCase, etc.).
- **Removes** routes and imports from `lib/app_router.dart`.
- **Runs** `build_runner`.

---

## 🤖 Automated Workflows

Our bricks define `post_gen` hooks that handle the manual labor for you.

| Manual Step | Now Automated? | Description |
|---|---|---|
| Creating files | ✅ | Mason creates all necessary files. |
| Registering Route | ✅ | Hooks inject the route into `app_router.dart` automatically. |
| Dependency Injection | ❌ | **Manual Step.** You must still register new repositories/usecases in `lib/di/injection.dart`. |
| Code Generation | ✅ | `build_runner` runs automatically after generation. |
| Formatting | ✅ | `dart format` runs automatically. |

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
│  │
│  └─ NO → Use mvi_feature
│            Examples:
│            - Create authentication module
│            - Create wallet module
```

---

## 🏗️ Clean Architecture Structure

### 1. Domain Layer (Business Logic)
- **Entities**: Pure Dart objects.
- **Use Cases**: Single business actions (e.g., `LoginWithEmailUseCase`).
- **Repositories**: Abstract interfaces.

### 2. Data Layer (Implementation)
- **Models**: DTOs with JSON serialization (`freezed`).
- **Repositories**: Implementation of domain repositories.
- **Data Sources**: API or local DB calls.

### 3. Presentation Layer (UI)
- **MviBloc**: Handles Actions -> States & Events.
- **Pages**: UI Widgets (`@RoutePage`).
- **Actions**: Inputs to the Bloc.

---

## 🛠️ Troubleshooting

### "Option not found" error
Ensure you are using the correct arguments:
- `mvi_feature`: `--feature_name`
- `mvi_subfeature`: `--module_name`, `--subfeature_name`

### "Generated files not found"
If `build_runner` failed:
1. Check the terminal output for errors.
2. Run manually: `melos genAlls` or `dart run build_runner build --delete-conflicting-outputs`.

### "Route not found"
If routing fails:
1. Check `lib/app_router.dart` to see if the route was added.
2. Ensure `@RoutePage()` annotation exists on your Page class.
3. Run `melos genAlls`.
