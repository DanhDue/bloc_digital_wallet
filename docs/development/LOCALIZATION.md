# Localization Best Practices with Slang

This document outlines the strategy for handling localization in a multi-package Flutter architecture using `slang`.

## Overview

In a modular architecture, localization can be handled in two main ways:
1.  **Centralized**: All strings live in the main App layer. Packages receive strings as parameters (Parametric UI).
2.  **Decentralized**: Each package has its own localization setup (Isolated Modules).

## Recommended Strategy: Parametric UI (Centralized)

For `ui_kit` and `core` widgets, **Parametric UI** is preferred.
- **Why**: Widgets should be "dumb" and reusable. They shouldn't know about specific localized text.
- **How**: Pass strings as arguments to widgets.

### Example
```dart
// Bad (Package depends on App's localization)
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(t.close); // Compile error: t is not defined in package
  }
}

// Good (Parametric)
class MyWidget extends StatelessWidget {
  final String label;
  const MyWidget({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(label);
  }
}

// Usage in App
MyWidget(label: t.close)
```

## Strategy for Feature Packages (Decentralized/Shared)

If you have feature packages (e.g., `packages/features/login`) that contain screens with many strings, passing everything as parameters is tedious.

### Option A: Shared Localization Package (Recommended for large apps)
Create a `packages/localization` package.
1.  Move `assets/locales` and `slang.yaml` to this package.
2.  Generate translations inside this package.
3.  Export `translations.dart`.
4.  All other packages depend on `packages/localization`.

### Option B: Per-Package Localization
Each package has its own `slang` setup.
1.  Each package has `assets/locales` and `slang.yaml`.
2.  `slang.yaml` must define a unique class name (e.g., `LoginTranslations`) to avoid conflicts.
3.  **Config**:
    ```yaml
    # packages/login/slang.yaml
    class_name: LoginTranslations
    output_file_name: login_translations.dart
    ```

## Project Configuration

We are currently using a **Centralized** approach in `lib/generated/translations.dart`.

### Adding a New Locale
1.  Create `assets/locales/strings_[locale].i18n.json` (e.g., `strings_vi.i18n.json`).
2.  Run generation command.

### Generation
Run the following command to regenerate translations:
```bash
./scripts/genAlls.sh
# OR
flutter pub run build_runner build --delete-conflicting-outputs
```
