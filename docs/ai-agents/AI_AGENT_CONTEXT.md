# AI Agent Context Guide

**Project**: bloc_digital_wallet  
**Architecture**: Clean Architecture + MVI Pattern  
**Framework**: Flutter  
**Language**: Dart  

---

## 🎯 Critical Information for AI Agents

### Project Identity
- **Type**: Flutter mobile application (Digital Wallet)
- **Architecture**: Clean Architecture (3 layers) + MVI presentation pattern
- **Code Organization**: Feature-first structure
- **State Management**: flutter_bloc with MVI adaptation
- **Dependency Injection**: GetIt + Injectable (auto-registration)
- **Code Generation**: Mason (features), build_runner (models, DI)

### Root Directory
```
/Users/danhdue/AllProjects/sample/bloc_digital_wallet/
```

---

## 📁 File Structure Patterns

### Pattern Recognition Rules

```yaml
Domain Layer (Pure Dart):
  - Path: lib/features/{feature}/domain/
  - Entities: lib/features/{feature}/domain/entities/{feature}_entity.dart
  - Repositories: lib/features/{feature}/domain/repositories/{feature}_repository.dart
  - Use Cases: lib/features/{feature}/domain/usecases/{verb}_{feature}_usecase.dart
  - Rules:
    - NO Flutter imports (package:flutter/*)
    - NO Material imports
    - Uses: equatable, dartz
    - Pure business logic only

Data Layer (Implementation):
  - Path: lib/features/{feature}/data/
  - Models: lib/features/{feature}/data/models/{feature}_model.dart
  - Remote DS: lib/features/{feature}/data/datasources/{feature}_remote_datasource.dart
  - Local DS: lib/features/{feature}/data/datasources/{feature}_local_datasource.dart
  - Repository: lib/features/{feature}/data/repositories/{feature}_repository_impl.dart
  - Rules:
    - Models use @freezed annotation
    - Models have toEntity() and fromEntity() methods
    - DataSources throw Exceptions
    - Repository converts Exceptions to Failures
    - Repository returns Either<Failure, Success>

Presentation Layer (UI):
  - Path: lib/features/{feature}/presentation/
  - Action: lib/features/{feature}/presentation/mvi/{feature}_action.dart
  - State: lib/features/{feature}/presentation/mvi/{feature}_state.dart
  - Event: lib/features/{feature}/presentation/mvi/{feature}_event.dart
  - BLoC: lib/features/{feature}/presentation/mvi/{feature}_bloc.dart
  - Page: lib/features/{feature}/presentation/pages/{feature}_page.dart
  - Widgets: lib/features/{feature}/presentation/widgets/{feature}_{widget_name}.dart
  - Rules:
    - Action extends BaseAction (user inputs)
    - State extends BaseState (persistent UI data)
    - Event extends BaseEvent (one-time side effects)
    - BLoC extends MviBloc<Action, State, Event>
    - Page uses BlocProvider + BlocConsumer

Core:
  - Architecture: lib/core/architecture/ (MVI base classes)
  - Errors: lib/core/errors/ (Failures, Exceptions)
  - Network: lib/core/network/ (Dio config, interceptors)
  - Storage: lib/core/storage/ (Hive, SharedPreferences)
  - Utils: lib/core/utils/ (helpers, extensions)

DI:
  - Config: lib/di/injection.dart
  - Generated: lib/di/injection.config.dart (auto-generated)

Generated:
  - Assets: lib/generated/assets.gen.dart
  - Colors: lib/generated/colors.gen.dart
  - Fonts: lib/generated/fonts.gen.dart
```

---

## 🎨 Theme & Styling Rules (CRITICAL)

### Using Theme Tailor

This project uses `theme_tailor` for centralized theme management. **ALWAYS** use `context.appThemes` for colors and text styles.

#### ❌ NEVER Do This:
```dart
// ❌ Using Theme.of(context) directly
Theme.of(context).textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant)
Theme.of(context).colorScheme.surface
Theme.of(context).colorScheme.primary

// ❌ Hardcoded colors
Colors.red
Colors.green
Color(0xFF123456)
```

#### ✅ ALWAYS Do This:
```dart
// ✅ Using context.appThemes for text styles
context.appThemes.bodyMedium.copyWith(color: context.appThemes.textSecondaryColor)
context.appThemes.headlineSmall

// ✅ Using context.appThemes for colors
context.appThemes.surfaceColor
context.appThemes.primaryColor
context.appThemes.errorColor
context.appThemes.authTextSecondary
```

### Adding New Colors to Theme

1. **Add to colors.xml**: `assets/colors/colors.xml`
```xml
<color name="your_color_name">#HEX_CODE</color>
```

2. **Add field to AppThemes**: `lib/config/theme/app_themes.dart`
```dart
@override
final Color yourColorName;
```

3. **Initialize in light/dark themes**: Add to both `AppThemes.light` and `AppThemes.dark`
```dart
static final light = AppThemes(
  // ... existing colors ...
  yourColorName: AppColors.yourColorName,
  // ...
);
```

4. **Generate code**: Run `melos genAlls` or `flutter pub run build_runner build --delete-conflicting-outputs`

5. **Use in UI**: Access via `context.appThemes.yourColorName`

### Using Text Styles

```dart
// ✅ Material 3 text styles available:
context.appThemes.displayLarge     // 57sp, Regular
context.appThemes.headlineSmall    // 24sp, Regular
context.appThemes.titleMedium      // 16sp, Medium
context.appThemes.bodyMedium       // 14sp, Regular
context.appThemes.labelLarge       // 14sp, Medium

// ✅ Emphasized variants:
context.appThemes.bodyMediumEmphasized   // 14sp, Medium
context.appThemes.titleLargeEmphasized   // 22sp, Medium

// ✅ With color:
context.appThemes.bodyMedium.copyWith(color: context.appThemes.textSecondaryColor)
```

---

## 🏗️ Architecture Rules (CRITICAL)

### MVI Pattern Components

```yaml
Action (formerly Intent):
  - Purpose: User interactions or external events
  - Base: BaseAction
  - Naming: {Verb}{Noun}Action
  - Examples: LoadWalletAction, CreateTransactionAction
  - Flow: View → BLoC
  - Properties: sealed class, const constructors

State:
  - Purpose: Persistent UI data
  - Base: BaseState
  - Naming: {Noun}{Adjective/Status}
  - Examples: WalletLoading, WalletLoaded, WalletError
  - Flow: BLoC → View (rebuild)
  - Properties: sealed class, extends Equatable

Event (formerly SideEffect):
  - Purpose: One-time UI reactions
  - Base: BaseEvent
  - Naming: {Verb}{Noun} or Show/Navigate{What}
  - Examples: ShowSuccessMessage, NavigateToDetail
  - Flow: BLoC → View (once)
  - Properties: sealed class, const constructors

MviBloc:
  - Base: MviBloc<Action, State, Event>
  - Entry Point: onAction(action) - ONLY method View should call
  - State Updates: emit(newState)
  - Event Emission: emitEvent(event)
  - Event Stream: events (Stream<Event>)
  - DI: @injectable annotation
```

### Layer Dependency Rules

```
Allowed Dependencies:
  Presentation → Domain
  Data → Domain
  Domain → (no dependencies on other layers)

Forbidden:
  Domain → Presentation
  Domain → Data
  Domain → Flutter/Material
```

### Data Flow (Unidirectional)

```
User Action:
  View → dispatch Action → BLoC.onAction()
                              ↓
                         Process in BLoC
                              ↓
                    Call UseCase (Domain)
                              ↓
                    Call Repository (Data)
                              ↓
                    Return Either<Failure, Success>
                              ↓
                         Update State (emit)
                         + Emit Event (emitEvent)
                              ↓
                         View rebuilds + reacts
```

---

## 🔧 Common Tasks for AI Agents

### Task 1: Create New Feature

```yaml
Command:
  mason make mvi_feature --feature_name {feature_name}

Post-Generation Steps:
  1. Navigate to: lib/features/{feature_name}/
  2. Update Domain:
     - entities/{feature_name}_entity.dart: Define properties
     - repositories/{feature_name}_repository.dart: Define methods
     - usecases/: Create use case files
  3. Update Data:
     - models/{feature_name}_model.dart: Add @freezed, toEntity(), fromEntity()
     - datasources/: Implement remote and local data sources
     - repositories/{feature_name}_repository_impl.dart: Implement repository
  4. Update Presentation:
     - mvi/{feature_name}_action.dart: Define user actions
     - mvi/{feature_name}_state.dart: Define UI states
     - mvi/{feature_name}_event.dart: Define one-time events
     - mvi/{feature_name}_bloc.dart: Implement action handlers
     - pages/{feature_name}_page.dart: Build UI with BlocConsumer
  5. Run code generation:
     flutter pub run build_runner build --delete-conflicting-outputs
  6. Verify DI registration in: lib/di/injection.config.dart

Generated Files Location:
  lib/features/{feature_name}/
```

### Task 2: Add New Use Case

```yaml
File Path:
  lib/features/{feature}/domain/usecases/{verb}_{feature}_usecase.dart

Template:
  ```dart
  import 'package:dartz/dartz.dart';
  import 'package:injectable/injectable.dart';
  import '../../../../core/errors/failures.dart';
  import '../entities/{feature}_entity.dart';
  import '../repositories/{feature}_repository.dart';

  @injectable
  class {Verb}{Feature}UseCase {
    final {Feature}Repository repository;

    {Verb}{Feature}UseCase(this.repository);

    Future<Either<Failure, {ReturnType}>> call({params}) async {
      // Business logic validation here
      return await repository.{method}({args});
    }
  }
  ```

Post-Creation:
  1. Run: flutter pub run build_runner build --delete-conflicting-outputs
  2. Add to BLoC constructor
  3. Create corresponding Action in presentation layer
  4. Add action handler in BLoC
```

### Task 3: Fix Linter Errors

```yaml
Check Errors:
  Command: flutter analyze
  OR: Read from IDE diagnostics

Common Issues:
  1. Missing imports:
     - Check if file exists
     - Add import statement
  2. Missing generated files:
     - Run: flutter pub run build_runner build --delete-conflicting-outputs
  3. Type mismatches:
     - Check Domain vs Data types (Entity vs Model)
     - Ensure proper conversion (toEntity, fromEntity)
  4. Unused imports:
     - Remove or ignore with: // ignore: unused_import
  5. Flutter imports in Domain:
     - Remove all package:flutter/* imports
     - Use pure Dart alternatives

Format Code:
  Command: flutter format .
```

### Task 4: Add New Dependency

```yaml
Steps:
  1. Add to pubspec.yaml under dependencies: or dev_dependencies:
  2. Run: flutter pub get
  3. If conflicts occur:
     - Check version constraints
     - Update conflicting packages
     - Use: flutter pub upgrade {package}
  4. If code generation package:
     - Run: flutter pub run build_runner build --delete-conflicting-outputs

Common Packages:
  State Management: flutter_bloc, bloc
  DI: get_it, injectable
  Network: dio, retrofit
  Storage: hive, shared_preferences, flutter_secure_storage
  Code Gen: freezed, json_serializable, build_runner
  FP: dartz
  Testing: mocktail, bloc_test
```

### Task 5: Run Tests

```yaml
All Tests:
  Command: flutter test

Specific Test:
  Command: flutter test test/path/to/test_file.dart

With Coverage:
  Command: ./scripts/testWithCoverage.sh
  Output: coverage/lcov.info

Test Structure:
  test/features/{feature}/domain/usecases/
  test/features/{feature}/data/repositories/
  test/features/{feature}/presentation/bloc/

Test Template (Use Case):
  ```dart
  import 'package:dartz/dartz.dart';
  import 'package:flutter_test/flutter_test.dart';
  import 'package:mocktail/mocktail.dart';

  class Mock{Feature}Repository extends Mock implements {Feature}Repository {}

  void main() {
    late {Verb}{Feature}UseCase useCase;
    late Mock{Feature}Repository mockRepository;

    setUp(() {
      mockRepository = Mock{Feature}Repository();
      useCase = {Verb}{Feature}UseCase(mockRepository);
    });

    test('should return {entity} when repository succeeds', () async {
      when(() => mockRepository.{method}(any()))
          .thenAnswer((_) async => Right(t{Entity}));

      final result = await useCase({params});

      expect(result, Right(t{Entity}));
      verify(() => mockRepository.{method}({params})).called(1);
    });
  }
  ```
```

### Task 6: Debug BLoC Issues

```yaml
Check Points:
  1. BLoC Registration:
     - File: lib/di/injection.config.dart
     - Look for: $initGet<{Feature}Bloc>
     - If missing: Run build_runner

  2. Action Dispatching:
     - Correct: context.read<{Feature}Bloc>().onAction({Action}())
     - Wrong: context.read<{Feature}Bloc>().add({Action}())

  3. State Changes:
     - Use: emit(newState) in BLoC
     - Check: BlocConsumer rebuilds on state change

  4. Event Listening:
     - Setup: context.read<{Feature}Bloc>().events.listen((event) { ... })
     - Inside: BlocConsumer listener callback

  5. Action Handlers:
     - Pattern: Future<void> _on{ActionName}({Action} action, Emitter<State> emit)
     - Register: In BLoC constructor with on<{Action}>

Common Errors:
  - "BLoC not found": Missing BlocProvider
  - "State not updating": Check emit() is called
  - "Events not firing": Check emitEvent() is called and listener is set up
  - "Type error": Check Action/State/Event type parameters
```

---

## 🧩 Code Patterns (Templates)

### Pattern 1: Entity (Domain)

```dart
// File: lib/features/{feature}/domain/entities/{feature}_entity.dart
import 'package:equatable/equatable.dart';

class {Feature}Entity extends Equatable {
  final String id;
  final String name;
  // Add properties

  const {Feature}Entity({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}
```

### Pattern 2: Repository Interface (Domain)

```dart
// File: lib/features/{feature}/domain/repositories/{feature}_repository.dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/{feature}_entity.dart';

abstract class {Feature}Repository {
  Future<Either<Failure, {Feature}Entity>> get{Feature}(String id);
  Future<Either<Failure, List<{Feature}Entity>>> getAll{Feature}s();
}
```

### Pattern 3: Use Case (Domain)

```dart
// File: lib/features/{feature}/domain/usecases/{verb}_{feature}_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/{feature}_entity.dart';
import '../repositories/{feature}_repository.dart';

@injectable
class {Verb}{Feature}UseCase {
  final {Feature}Repository repository;

  {Verb}{Feature}UseCase(this.repository);

  Future<Either<Failure, {ReturnType}>> call({params}) async {
    return await repository.{method}({args});
  }
}
```

### Pattern 4: Model (Data)

```dart
// File: lib/features/{feature}/data/models/{feature}_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/{feature}_entity.dart';

part '{feature}_model.freezed.dart';
part '{feature}_model.g.dart';

@freezed
class {Feature}Model with _${Feature}Model {
  const {Feature}Model._();

  const factory {Feature}Model({
    required String id,
    required String name,
  }) = _{Feature}Model;

  factory {Feature}Model.fromJson(Map<String, dynamic> json) =>
      _${Feature}ModelFromJson(json);

  {Feature}Entity toEntity() => {Feature}Entity(
        id: id,
        name: name,
      );

  factory {Feature}Model.fromEntity({Feature}Entity entity) => {Feature}Model(
        id: entity.id,
        name: entity.name,
      );
}
```

### Pattern 5: Remote Data Source (Data)

```dart
// File: lib/features/{feature}/data/datasources/{feature}_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/{feature}_model.dart';

abstract class {Feature}RemoteDataSource {
  Future<{Feature}Model> get{Feature}(String id);
}

@LazySingleton(as: {Feature}RemoteDataSource)
class {Feature}RemoteDataSourceImpl implements {Feature}RemoteDataSource {
  final Dio dio;

  const {Feature}RemoteDataSourceImpl(this.dio);

  @override
  Future<{Feature}Model> get{Feature}(String id) async {
    try {
      final response = await dio.get('/{features}/$id');
      if (response.statusCode == 200) {
        return {Feature}Model.fromJson(response.data);
      } else {
        throw ServerException(message: 'Failed', code: response.statusCode);
      }
    } on DioException catch (e) {
      throw NetworkException(message: e.message ?? 'Network error', originalException: e);
    }
  }
}
```

### Pattern 6: Repository Implementation (Data)

```dart
// File: lib/features/{feature}/data/repositories/{feature}_repository_impl.dart
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/{feature}_entity.dart';
import '../../domain/repositories/{feature}_repository.dart';
import '../datasources/{feature}_local_datasource.dart';
import '../datasources/{feature}_remote_datasource.dart';

@LazySingleton(as: {Feature}Repository)
class {Feature}RepositoryImpl implements {Feature}Repository {
  final {Feature}RemoteDataSource remoteDataSource;
  final {Feature}LocalDataSource localDataSource;

  {Feature}RepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, {Feature}Entity>> get{Feature}(String id) async {
    try {
      final remoteData = await remoteDataSource.get{Feature}(id);
      await localDataSource.cache{Feature}(remoteData);
      return Right(remoteData.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, code: e.code));
    }
  }
}
```

### Pattern 7: Action (Presentation)

```dart
// File: lib/features/{feature}/presentation/mvi/{feature}_action.dart
import '../../../../core/architecture/architecture.dart';

sealed class {Feature}Action extends BaseAction {
  const {Feature}Action();
}

class Load{Feature}Action extends {Feature}Action {
  final String id;
  const Load{Feature}Action(this.id);
}
```

### Pattern 8: State (Presentation)

```dart
// File: lib/features/{feature}/presentation/mvi/{feature}_state.dart
import 'package:equatable/equatable.dart';
import '../../../../core/architecture/architecture.dart';
import '../../domain/entities/{feature}_entity.dart';

sealed class {Feature}State extends BaseState with EquatableMixin {
  const {Feature}State();
}

class {Feature}Initial extends {Feature}State {
  const {Feature}Initial();
  @override
  List<Object?> get props => [];
}

class {Feature}Loading extends {Feature}State {
  const {Feature}Loading();
  @override
  List<Object?> get props => [];
}

class {Feature}Loaded extends {Feature}State {
  final {Feature}Entity {feature};
  const {Feature}Loaded(this.{feature});
  @override
  List<Object?> get props => [{feature}];
}

class {Feature}Error extends {Feature}State {
  final String message;
  const {Feature}Error(this.message);
  @override
  List<Object?> get props => [message];
}
```

### Pattern 9: Event (Presentation)

```dart
// File: lib/features/{feature}/presentation/mvi/{feature}_event.dart
import '../../../../core/architecture/architecture.dart';

sealed class {Feature}Event extends BaseEvent {
  const {Feature}Event();
}

class ShowSuccessMessage extends {Feature}Event {
  final String message;
  const ShowSuccessMessage(this.message);
}

class NavigateTo{Feature}Detail extends {Feature}Event {
  final String id;
  const NavigateTo{Feature}Detail(this.id);
}
```

### Pattern 10: BLoC (Presentation)

```dart
// File: lib/features/{feature}/presentation/mvi/{feature}_bloc.dart
import 'package:injectable/injectable.dart';
import '../../../../core/architecture/architecture.dart';
import '../../domain/usecases/get_{feature}_usecase.dart';
import '{feature}_action.dart';
import '{feature}_state.dart';
import '{feature}_event.dart';

@injectable
class {Feature}Bloc extends MviBloc<{Feature}Action, {Feature}State, {Feature}Event> {
  final Get{Feature}UseCase get{Feature}UseCase;

  {Feature}Bloc({required this.get{Feature}UseCase}) : super(const {Feature}Initial());

  @override
  Future<void> onAction({Feature}Action action, Emitter<{Feature}State> emit) async {
    switch (action) {
      case Load{Feature}Action(:final id):
        emit(const {Feature}Loading());
        final result = await get{Feature}UseCase(id);
        result.fold(
          (failure) {
            emit({Feature}Error(failure.message));
            emitEvent(ShowErrorMessage(failure.message));
          },
          ({feature}) {
            emit({Feature}Loaded({feature}));
            emitEvent(const ShowSuccessMessage('Loaded!'));
          },
        );
    }
  }
}
```

### Pattern 11: Page (Presentation)

```dart
// File: lib/features/{feature}/presentation/pages/{feature}_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../di/injection.dart';
import '../mvi/{feature}_bloc.dart';
import '../mvi/{feature}_action.dart';
import '../mvi/{feature}_state.dart';
import '../mvi/{feature}_event.dart';

class {Feature}Page extends StatelessWidget {
  const {Feature}Page({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<{Feature}Bloc>(),
      child: const _{Feature}View(),
    );
  }
}

class _{Feature}View extends StatelessWidget {
  const _{Feature}View();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('{Feature}')),
      body: BlocConsumer<{Feature}Bloc, {Feature}State>(
        listener: (context, state) {
          context.read<{Feature}Bloc>().events.listen((event) {
            switch (event) {
              case ShowSuccessMessage(:final message):
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(message)),
                );
            }
          });
        },
        builder: (context, state) {
          return switch (state) {
            {Feature}Loading() => const CircularProgressIndicator(),
            {Feature}Loaded(:final {feature}) => Text({feature}.name),
            {Feature}Error(:final message) => Text('Error: $message'),
            _ => const SizedBox(),
          };
        },
      ),
    );
  }
}
```

---

## 🚨 Error Resolution Patterns

### Error Type: Dependency Not Found

```yaml
Symptoms:
  - "GetIt: Object/factory with type X is not registered"
  - "No provider found for X"

Resolution:
  1. Check file has @injectable or @LazySingleton annotation
  2. Run: flutter pub run build_runner build --delete-conflicting-outputs
  3. Check lib/di/injection.config.dart for registration
  4. Ensure configureDependencies() is called in main.dart
```

### Error Type: State Not Updating

```yaml
Symptoms:
  - BLoC emits state but UI doesn't rebuild
  - "setState() or markNeedsBuild() called during build"

Resolution:
  1. Ensure BlocProvider wraps the widget tree
  2. Check BlocBuilder/BlocConsumer is used correctly
  3. Verify emit() is called in BLoC
  4. Check State extends Equatable with correct props
  5. Use const constructors for States
```

### Error Type: Generated Files Missing

```yaml
Symptoms:
  - "Part file doesn't exist"
  - "*.freezed.dart" or "*.g.dart" not found

Resolution:
  1. Run: flutter pub run build_runner build --delete-conflicting-outputs
  2. Check part declarations match file name
  3. Ensure @freezed or @JsonSerializable annotations are present
  4. Clean and rebuild: flutter clean && flutter pub get
```

### Error Type: Type Mismatch

```yaml
Symptoms:
  - "Type 'XModel' is not a subtype of type 'XEntity'"
  - "The argument type 'Either<Failure, XModel>' can't be assigned"

Resolution:
  1. Check conversion: Use .toEntity() when returning from Repository
  2. Domain layer returns Entity, not Model
  3. Use .fromEntity() when passing Entity to DataSource
  4. Verify Repository signature returns Entity
```

### Error Type: Flutter Imports in Domain

```yaml
Symptoms:
  - "Don't import 'package:flutter/material.dart' in domain"

Resolution:
  1. Remove all package:flutter/* imports from domain/
  2. Use pure Dart alternatives:
     - Color → String (hex) or enum
     - BuildContext → pass required data explicitly
     - Widget → return data, not UI
  3. Domain should have NO UI concerns
```

---

## 📊 Decision Trees for AI Agents

### Decision: Where to Add Business Logic?

```
Is it validation/calculation/business rule?
  YES → UseCase (Domain)
  NO ↓

Is it data fetching/caching logic?
  YES → Repository (Data)
  NO ↓

Is it API call/database query?
  YES → DataSource (Data)
  NO ↓

Is it UI state management?
  YES → BLoC (Presentation)
  NO ↓

Is it widget rendering logic?
  YES → Widget/Page (Presentation)
```

### Decision: When to Create New File?

```
New business operation?
  → Create UseCase in domain/usecases/

New entity/value object?
  → Create Entity in domain/entities/

New data source?
  → Create DataSource in data/datasources/

New API endpoint integration?
  → Add method to existing RemoteDataSource OR create new one

New UI screen?
  → Create Page in presentation/pages/

New reusable UI component?
  → Create Widget in presentation/widgets/

New user interaction?
  → Add Action in presentation/mvi/{feature}_action.dart

New UI state?
  → Add State in presentation/mvi/{feature}_state.dart

New one-time UI effect?
  → Add Event in presentation/mvi/{feature}_event.dart
```

### Decision: When to Run Code Generation?

```
After adding/modifying:
  - @freezed class → Run build_runner
  - @JsonSerializable class → Run build_runner
  - @injectable class → Run build_runner
  - @LazySingleton class → Run build_runner
  - Any model with .g.dart or .freezed.dart → Run build_runner
  - New dependency in pubspec.yaml → Run pub get
  - Mason brick → Run mason get

Command:
  flutter pub run build_runner build --delete-conflicting-outputs
```

---

## 🔍 Context Discovery Commands

### Find Feature Implementation

```bash
# List all features
ls -la lib/features/

# Find all files for a feature
find lib/features/{feature_name} -type f

# Search for a specific class
grep -r "class {ClassName}" lib/
```

### Find Dependencies

```bash
# Check what imports a file
grep -r "import.*{file_name}" lib/

# Find all uses of a class
grep -r "{ClassName}" lib/

# Find BLoC registrations
grep -r "@injectable" lib/features/
```

### Check Project Health

```bash
# Check for errors
flutter analyze

# Check formatting
flutter format --set-exit-if-changed .

# Run tests
flutter test

# Check dependencies
flutter pub outdated
```

---

## 💡 AI Agent Best Practices

### Before Making Changes

1. **Read Architecture First**: Read lib/core/architecture/ files
2. **Check Existing Patterns**: Look at similar features for consistency
3. **Verify Layer**: Ensure changes are in correct layer (Domain/Data/Presentation)
4. **Check Dependencies**: Verify dependency direction (Presentation → Domain ← Data)

### During Implementation

1. **Follow Naming Conventions**: Use established patterns
2. **Use Code Generation**: Don't manually create .g.dart or .freezed.dart files
3. **Add DI Annotations**: Always add @injectable or @LazySingleton
4. **Maintain Immutability**: Use const constructors, final fields
5. **Handle Errors**: Use Either<Failure, Success> in repositories

### After Making Changes

**🔍 CRITICAL: Double Check Steps (MANDATORY after EVERY task)**

1. **Format Code**: `flutter format .`
2. **Analyze Code**: `flutter analyze --no-fatal-infos`
   - **MUST show**: `"No issues found!"`
   - **MUST have**: Exit code 0
   - **If errors found**: Fix them and re-analyze
   - **Repeat until**: 0 issues
3. **Run Tests**: `flutter test` (if tests exist)
4. **Run Code Generation** (if models/DI changed): `flutter pub run build_runner build --delete-conflicting-outputs`
5. **Verify Build**: `flutter build apk --debug` (optional)

**Expected Output:**
```bash
$ flutter analyze --no-fatal-infos
Analyzing bloc_digital_wallet...
No issues found! (ran in X.Xs)
```

**Success Criteria:**
- ✅ `flutter analyze` shows **"No issues found!"**
- ✅ Exit code: **0**
- ✅ No errors, warnings, or info messages
- ✅ All files formatted
- ✅ Tests passing (if exist)

**⚠️ DO NOT report to user until all checks pass!**

### Communication with Users

1. **Be Specific**: Reference exact file paths and line numbers
2. **Explain Architecture**: Relate changes to Clean Architecture + MVI
3. **Provide Commands**: Give exact terminal commands to run
4. **Show Alternatives**: If multiple approaches exist, present trade-offs
5. **Confirm Understanding**: Ask clarifying questions if requirements are ambiguous

---

## 📝 Helpful Documentation Locations

```yaml
Architecture Overview: /ARCHITECTURE.md
Implementation Tutorial: /IMPLEMENTATION_GUIDE.md
Quick Reference: /QUICK_REFERENCE.md
This Guide: /AI_AGENT_CONTEXT.md
Workflows: /AI_AGENT_WORKFLOWS.md (companion document)

Project README: /README.md
Package Config: /pubspec.yaml
DI Config: /lib/di/injection.dart
Mason Config: /mason.yaml
Melos Config: /melos.yaml

Core Architecture: /lib/core/architecture/
Error Handling: /lib/core/errors/
Generated Assets: /lib/generated/
```

---

## 🎯 Summary for Quick Context

**3-Second Context**:
- Flutter app with Clean Architecture + MVI
- Feature-first structure in `lib/features/`
- Use Mason for code generation: `mason make mvi_feature`

**30-Second Context**:
- 3 layers: Domain (pure Dart), Data (implementation), Presentation (UI)
- MVI components: Action (input), State (persistent), Event (one-time)
- BLoC single entry: `bloc.onAction(action)`
- DI: Injectable + GetIt (auto-registration)
- Code gen: build_runner for models/DI, mason for features

**5-Minute Context**:
- Read the Decision Trees and Common Tasks sections above
- Check File Structure Patterns for navigation
- Review Code Patterns for templates
- Follow Best Practices when making changes

---

**For detailed workflows, see: AI_AGENT_WORKFLOWS.md**
