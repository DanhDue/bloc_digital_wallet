# Tech Stack & Architecture Rules

## 🏗️ Architecture: Clean Architecture + MVI

### 1. Separation of Concerns
- **Domain**: Pure Dart. NO Flutter widgets. Contains Entries (Freezed), Use Cases, and Repository Interfaces.
- **Data**: Models (Freezed + JsonSerializable), Datasources (Retrofit), and Repository Implementations.
- **Presentation**: BLoC (MVI), Pages, and Widgets.

### 2. State Management (BLoC)
- **MVI Pattern**: Actions in -> State out.
- **Events**: Use `Action` for user intent, `Event` for one-time side effects (navigation, toasts).
- **Registration**: All BLoCs must be registered in DI (`lib/di/`) and provided via `BlocProvider`.

### 3. Navigation (AutoRoute)
- **Routes**: Defined in `app_router.dart`.
- **Annotations**: Use `@RoutePage()` for all screen widgets.
- **Navigation**: Use `context.router.push(...)`.

### 4. Dependency Injection (GetIt + Injectable)
- **Services/Repos**: Annotated with `@singleton` or `@lazySingleton`.
- **Clients**: Annotated with `@module` providers.
- **Usage**: Constructor injection only. NO `GetIt.I.get()` inside classes.

## 📦 Key Libraries
- `flutter_bloc`
- `freezed` / `json_serializable`
- `auto_route`
- `retrofit` / `dio`
- `slang` (i18n)
