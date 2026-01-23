# App Initializer Pattern

## Overview
The `AppInitializer` pattern is a structural design used to manage the application's startup logic in a modular, testable, and deterministic way. Instead of cluttering `main.dart` with various initialization calls (Logging, Firebase, Analytics, etc.), we encapsulate each initialization logic into its own class.

## Why use it?
1.  **Decoupling**: `main.dart` becomes clean and focused only on bootstrapping the app. It doesn't need to know *how* logging or analytics are set up.
2.  **Order of Execution**: Initializers can be orchestrated to run in a specific order (e.g., Logging -> Crash Reporting -> Analytics).
3.  **Dependency Injection**: Since initializers are registered in the DI graph using `AppModule`, they can easily inject their own dependencies (like `Talker`, `NetworkConfig`, etc.).
4.  **Testability**: You can easily unit test individual initializers or swap them out for mocks during testing.

## How to use it?

### 1. Define a new Initializer
Create a class that implements `AppInitializer`.
located in `lib/core/app_initializer/`.

```dart
// lib/core/app_initializer/my_service_initializer.dart
import 'app_initializer.dart';

class MyServiceInitializer implements AppInitializer {
  final MyDependency _dependency;

  MyServiceInitializer(this._dependency);

  @override
  Future<void> init() async {
    await _dependency.initialize();
  }
}
```

### 2. Register in DI Module
Add your initializer to `lib/di/app_module.dart`.

```dart
@module
abstract class AppModule {
  // 1. Provide the specific initializer
  @singleton
  MyServiceInitializer get myServiceInitializer => MyServiceInitializer(getIt());

  // 2. Add it to the composite provider
  @singleton
  AppInitializer provideAppInitializer(
    LoggingInitializer loggingInitializer,
    MyServiceInitializer myServiceInitializer, // Inject here
  ) {
    return AppInitializerImpl([
      loggingInitializer,
      myServiceInitializer, // Add to list
    ]);
  }
}
```
*Note: The order in the list determines the execution order.*

### 3. Execution
`main.dart` automatically runs the composite initializer provided by `AppModule`.

```dart
void main() async {
  configureDependencies();
  await getIt<AppInitializer>().init(); // Runs all registered initializers
  runApp(const MyApp());
}
```
