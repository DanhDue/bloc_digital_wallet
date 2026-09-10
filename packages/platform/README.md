# Platform Package (`app_platform`)

Shared cross-feature platform infrastructure for the Bloc Digital Wallet Super App. This package provides the decoupled mechanism and protocols for Mini App packages (`features/*`) to interact with each other without importing each other's internals.

---

## Architecture & Directory Structure

```
packages/platform/
├── lib/
│   ├── deeplink/
│   │   ├── deep_link_routes.dart     # Public cross-package route constants & PageRouteInfo stubs
│   │   ├── deep_link_payload.dart    # Strongly typed, immutable parsed deep link payload
│   │   ├── deep_link_registry.dart   # Central registry mapping route paths to shell tabs & auth guards
│   │   └── deep_link_parser.dart     # Pure Dart parser for custom schemes and App/Universal Links
│   ├── di/
│   │   ├── injection.dart            # Platform module DI initialization
│   │   └── injection.config.dart
│   ├── app_event_bus.dart            # Reactive, broadcast stream event bus for cross-feature IPC
│   └── platform.dart                 # Central barrel export file
└── test/
    ├── app_event_bus_test.dart
    ├── deep_link_parser_test.dart
    └── theme_and_localization_events_test.dart
```

---

## Features

### 1. Cross-Feature Deep Link Protocol (`lib/deeplink/`)

- **`DeepLinkRoutes`**: Type-safe `PageRouteInfo` constants for navigating to entry screens of other packages without importing their router or page classes.
- **`DeepLinkPayload`**: Immutable representation of parsed URI data including normalized route path, query parameters, target shell tab index, and authentication requirement.
- **`DeepLinkRegistry`**: Catalog of registered routes, providing prefix-matching and target tab resolution.
- **`DeepLinkParser`**: Pure Dart parser supporting custom schemes (`d3nexus://`, `d3nexusshield://`) and Universal Links (`https://app.d3nexus.com/`).

### 2. Cross-Feature App Event Bus (`lib/app_event_bus.dart`)

- **`AppEventBus`**: Lightweight pub/sub broadcast bus for inter-mini-app communication.
- **Standard Events**:
  - `ThemeModeChanged`: Emitted when theme mode changes, allowing mini-apps to adapt.
  - `AppLanguageChanged`: Emitted when active language changes.

---

## Usage

### Navigation via `DeepLinkRoutes`

```dart
import 'package:app_platform/platform.dart';

// Type-safe cross-feature push without importing settings package
context.router.push(DeepLinkRoutes.settingsRoute);
```

### Parsing Deep Links

```dart
import 'package:app_platform/platform.dart';

final parser = const DeepLinkParser();
final payload = parser.parse(Uri.parse('d3nexus://scanner?ref=banner'));

print(payload.path);       // '/scanner'
print(payload.targetTab);  // 1
```

### Listening to & Publishing Events

```dart
import 'package:app_platform/platform.dart';

// Subscribe
final subscription = eventBus.on<ThemeModeChanged>().listen((event) {
  print('Is dark mode: ${event.isDarkMode}');
});

// Publish
eventBus.publish(ThemeModeChanged(isDarkMode: true));
```

---

## Package Name Note

> **Note:** This package's pubspec `name:` is `app_platform`, not `platform`, even though it lives at `packages/platform/`. A bare `platform` collides with the [`platform`](https://pub.dev/packages/platform) package on pub.dev, which breaks `pub get` version solving. Consumers typically import it via barrel:
> ```dart
> import 'package:app_platform/platform.dart';
> ```
