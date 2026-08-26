# Platform Package

Shared cross-feature platform infrastructure for the Bloc Digital Wallet: the mechanism Mini App packages use to interact with each other without importing each other's internals.

## Features

- **`DeepLinkRoutes`** - name-string `PageRouteInfo` constants for cross-package navigation (relocated from `core/utils/feature_public_routes.dart`). Callers navigate via `context.router.push(DeepLinkRoutes.settingsRoute)` without importing the target package's router/page classes.

## Usage

```dart
import 'package:app_platform/platform.dart';

context.router.push(DeepLinkRoutes.settingsRoute);
```

## Package name

> **Note:** this package's pubspec `name:` is `app_platform`, not `platform`, even though it lives at `packages/platform/`. A bare `platform` collides with the [`platform`](https://pub.dev/packages/platform) package on pub.dev (an existing transitive dependency of this workspace, pulled in via `path_provider_platform_interface`), which breaks `pub get` version solving. Consumers typically import it aliased as `platform` (`import 'package:app_platform/platform.dart' as platform;`) so call sites still read naturally, and a dependency on it is declared as `app_platform: {path: ../platform}`.
