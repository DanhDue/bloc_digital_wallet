# Core Package

Core utilities, errors, extensions, and shared infrastructure for the Bloc Digital Wallet.

## Features

- **Dependency Injection** - Injectable modules and GetIt configuration
- **Networking** - Dio configuration, Retrofit base setup
- **State Management** - BLoC utilities and base classes
- **Localization** - Shared translations (`coreT`) for common strings
- **Extensions** - Common Dart/Flutter extensions
- **Constants** - App-wide constants and configurations

## Usage

```dart
import 'package:core/core.dart';

// Access shared translations
final closeText = coreT.close;

// Access DI container
final service = getIt<MyService>();
```

## Structure

```
lib/
├── core.dart           # Main barrel export
└── src/
    ├── di/             # Dependency injection modules
    ├── errors/         # Error types and handlers
    ├── extensions/     # Dart/Flutter extensions
    ├── generated/      # Generated translations
    └── utils/          # Utility classes
```
