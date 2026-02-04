# UI Kit Package

Shared UI components, themes, and design system for the Bloc Digital Wallet.

## Features

- **Theme System** - AppThemes with light/dark mode support
- **Widgets** - Reusable UI components (buttons, dialogs, loading indicators)
- **Extensions** - BuildContext and Widget extensions
- **Assets** - Generated asset accessors (images, fonts, colors)

## Usage

```dart
import 'package:ui_kit/ui_kit.dart';

// Access theme
final theme = appThemes;
final primaryColor = theme.primaryColor;

// Use widgets
CustomFilledButton(
  title: 'Submit',
  onPressed: () {},
)
```

## Structure

```
lib/
├── ui_kit.dart         # Main barrel export
└── src/
    ├── theme/          # Theme definitions
    ├── widgets/        # Reusable widgets
    ├── extensions/     # UI extensions
    └── generated/      # Generated assets
```
