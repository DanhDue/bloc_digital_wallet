# AI Coding Guidelines for bloc_digital_wallet

## Project Overview
This is a Flutter-based digital wallet application using the BLoC pattern for state management. The app leverages code generation extensively for models, APIs, themes, assets, and localization to maintain consistency and reduce boilerplate.

## Architecture
- **State Management**: BLoC pattern with blocs handling business logic and UI state
- **Data Layer**: Repositories abstract data sources; Retrofit for API clients with Dio HTTP client
- **Models**: Immutable data classes generated with Freezed and JSON serialization
- **Navigation**: Auto Route for declarative routing
- **Theming**: Theme Tailor for type-safe theme generation
- **Assets**: Flutter Gen generates type-safe accessors for images, colors (from XML), fonts, and Lottie animations
- **Localization**: JSON-based locales with custom generation script

## Key Workflows
- **Setup**: Run `fvm flutter pub get` to install dependencies (FVM manages Flutter version)
- **Code Generation**: Execute `melos genAlls` to run all generators: build_runner (Freezed/Retrofit), Flutter Gen (assets), locales, formatting, and license headers
- **Asset Generation**: Use `melos genImages`, `genColors`, `genLocales` for specific asset types
- **Build**: `fvm flutter pub run build_runner build --delete-conflicting-outputs` for code generation
- **Formatting**: Line length set to 99 characters; use `melos dartfmt` for consistent formatting

## Conventions
- **Imports**: Organize with Flutter imports first, then third-party, then local
- **Models**: Use Freezed for all data models with `fromJson`/`toJson` for API serialization
- **API**: Define Retrofit clients in separate files with `@RestApi` annotation
- **Assets**: Place in `assets/` subdirs; access via generated `Assets` class (e.g., `Assets.images.logo`)
- **Colors**: Define in `assets/colors/colors.xml`; access via `AppColors` class
- **Fonts**: SF Compact Display family; access via `AppFontFamily`
- **Localization**: Keys in `assets/locales/*.json`; generate with `get generate locales assets/locales`
- **Logging**: Use Talker for logging with Dio interceptor for API requests
- **Permissions**: Handle with permission_handler package
- **Date/Time**: Use Jiffy for date manipulation

## Examples
- **Freezed Model**: Annotate classes with `@freezed` and part files for generation
- **Retrofit API**: `@RestApi(baseUrl: "...") class ApiClient { @GET("/endpoint") Future<Model> getData(); }`
- **BLoC**: Extend `Bloc<Event, State>` with event handlers and state emissions
- **Asset Usage**: `Image.asset(Assets.images.icon.path)` or `AppColors.primary` for colors

## Dependencies
- Core: flutter, bloc (implied), dio, retrofit, freezed
- UI: flutter_svg, theme_tailor, auto_route
- Utils: talker, permission_handler, jiffy, google_sign_in

Focus on generating code with build_runner and maintaining generated files in sync.</content>
<parameter name="filePath">/Users/danhdue/AllProjects/sample/bloc_digital_wallet/.github/copilot-instructions.md