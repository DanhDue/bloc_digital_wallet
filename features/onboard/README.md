# Onboard Package

The Onboard feature package for the Bloc Digital Wallet application.

## Features

*   **Splash Screen**: Initial loading screen with health checks.
*   **Onboarding Flow**: User introductory screens.

## Architecture

This package follows the Clean Architecture + MVI pattern.

*   `data/`: Data sources, models, and repositories.
*   `domain/`: Entities, repositories (interfaces), and use cases.
*   `presentation/`: BLoCs, UI models, and widgets.

## Usage

Import the package and use the `OnboardRouter` for navigation.

```dart
import 'package:onboard/onboard.dart';
```
