# AI Agent Quick Checklist

**Ultra-Fast Reference for AI Agents**

---

## 🚀 Before Starting Any Task

```
[ ] Read user request carefully
[ ] Identify feature/component affected
[ ] Check if feature exists: ls lib/features/
[ ] Review architecture: cat AI_AGENT_CONTEXT.md (if first time)
[ ] Determine layer: Domain / Data / Presentation
[ ] ⚠️ CRITICAL: If creating feature, check if module exists first!
```

---

## ⚠️ CRITICAL: Feature Creation Decision

```
[ ] User requests "create a feature" or "add a feature"
[ ] ❓ Is module context clear?
    
    [ ] NO → ANALYZE and PRESENT:
        [ ] 1. ANALYZE:
            [ ] Check lib/features/ for existing modules
            [ ] Determine if feature belongs to existing module
            [ ] Or if it's new domain concept
            [ ] Identify best approach
        
        [ ] 2. PRESENT PLAN:
            [ ] Show Option 1: New module (when/what/benefits)
            [ ] Show Option 2: Subfeature (when/what/benefits)
            [ ] Include recommendation with reasoning
            [ ] Explain architecture implications
        
        [ ] 3. PREPARE TASK ASSIGNMENT TEMPLATE & ASK FOR MODULE INFO AND CONFIRMATION:
            [ ] Prepare structured information request template
            [ ] Use format from docs/task-prompt-templates/README.md
            [ ] Include sections:
                [ ] MODULE INFORMATION (module, subfeature, functionality, UI)
                [ ] TECHNICAL DETAILS (API, validation, error handling)
                [ ] ADDITIONAL REQUIREMENTS (translations, routing, etc.)
                [ ] CONFIRMATION (clear yes/no question)
            [ ] Request missing details in organized format
            [ ] Confirm chosen approach
            [ ] Wait for user response with all required information
        
        [ ] 4. THEN PROCEED:
            [ ] Execute confirmed workflow
    
    [ ] YES → Determine template:
        [ ] New domain concept? → Use mvi_feature
        [ ] Add to existing? → Use mvi_subfeature
```

**Workflow Examples**:
- "Create authentication" → Analyze → Present → Confirm → mvi_feature
- "Add forgot password" → Analyze → Present (recommend subfeature) → Confirm → mvi_subfeature
- "Add feature X" → **Analyze → Present options → Ask → Proceed**

---

## ✅ Task: Create New Module (mvi_feature)

```
[ ] Confirm this is a NEW domain concept
[ ] Extract feature name (snake_case)
[ ] Run: mason make mvi_feature --feature_name {name}
[ ] Update Entity (domain/entities/)
    [ ] Add properties
    [ ] Update props getter
    [ ] NO Flutter imports
[ ] Update Repository Interface (domain/repositories/)
    [ ] Define method signatures
    [ ] Return Either<Failure, Success>
[ ] Create Use Cases (domain/usecases/)
    [ ] Add @injectable
    [ ] Add business validation
    [ ] Call repository
[ ] Create Model (data/models/)
    [ ] Add @freezed
    [ ] Add toEntity()
    [ ] Add fromEntity()
[ ] Implement Data Sources (data/datasources/)
    [ ] Add @LazySingleton(as: Interface)
    [ ] Throw Exceptions, not return Failures
    [ ] Handle Dio errors
[ ] Implement Repository (data/repositories/)
    [ ] Add @LazySingleton(as: Interface)
    [ ] Convert Exceptions to Failures
    [ ] Return Either<Failure, Success>
[ ] Define Actions (presentation/{name}/{name}_action.dart)
    [ ] Extend BaseAction
    [ ] Sealed class
[ ] Define States (presentation/{name}/{name}_state.dart)
    [ ] Extend BaseState + EquatableMixin
    [ ] Sealed class
    [ ] Add props getter
[ ] Define Events (presentation/{name}/{name}_event.dart)
    [ ] Extend BaseEvent
    [ ] Sealed class
[ ] Implement BLoC (presentation/{name}/{name}_bloc.dart)
    [ ] Extend MviBloc<Action, State, Event>
    [ ] Add @injectable
    [ ] Inject Use Cases in constructor
    [ ] Implement onAction() with switch
    [ ] Use emit() for states
    [ ] Use emitEvent() for events
[ ] Create Page (presentation/pages/{name}_page.dart)
    [ ] Use BlocProvider
    [ ] Use BlocConsumer
    [ ] Listen to events
    [ ] Build UI based on states
    [ ] Dispatch actions via bloc.onAction()
[ ] Run: flutter pub run build_runner build --delete-conflicting-outputs
[ ] Run: flutter format .
[ ] Run: flutter analyze
[ ] Fix any errors
[ ] Report to user
```

---

## ✅ Task: Add Subfeature to Existing Module (mvi_subfeature)

```
[ ] Confirm module exists: lib/features/{module}/
[ ] Extract module name (snake_case): e.g., authentication
[ ] Extract subfeature name (snake_case): e.g., forgot_password
[ ] Run: mason make mvi_subfeature
    Prompts:
    [ ] Module name: {existing_module}
    [ ] Subfeature name: {subfeature_name}
    [ ] Entity name: [Press Enter to reuse module's entity]
    [ ] Create new model: N (usually)
    [ ] Create new entity: N (usually)

Generated Files:
[ ] Review: domain/usecases/{subfeature}_usecase.dart
[ ] Review: presentation/pages/{subfeature}_page.dart
[ ] Review: presentation/widgets/{subfeature}_widget.dart

Implement Use Case:
[ ] Open: domain/usecases/{subfeature}_usecase.dart
[ ] Replace TODO with business logic
[ ] Add validation
[ ] Call repository method

Add Action to Bloc:
[ ] Open: presentation/{module}/{module}_action.dart
[ ] Add: class {Subfeature}Action extends {Module}Action
[ ] Define required fields

Handle Action in Bloc:
[ ] Open: presentation/{module}/{module}_bloc.dart
[ ] Inject use case in constructor
[ ] Add case in onAction() switch
[ ] Emit states and events

Update Repository:
[ ] Interface: domain/repositories/{module}_repository.dart
    [ ] Add method signature
[ ] Implementation: data/repositories/{module}_repository_impl.dart
    [ ] Implement method
    [ ] Handle exceptions → failures

Update Data Source (if needed):
[ ] Open: data/datasources/{module}_remote_datasource.dart
[ ] Add method signature
[ ] Implement API call

Add Translations:
[ ] Edit: assets/locales/en.i18n.json
    [ ] Add {module}{Subfeature}* keys
[ ] Edit: assets/locales/vi.i18n.json
    [ ] Add translations

Implement Page UI:
[ ] Open: presentation/pages/{subfeature}_page.dart
[ ] Use context.t for translations
[ ] Use context.appThemes for styling
[ ] Use BlocBuilder/BlocProvider
[ ] Listen to events stream

Add Route:
[ ] Edit: lib/app_router.dart
[ ] Add: AutoRoute(page: {Subfeature}Route.page, path: '/path')

Code Generation:
[ ] Run: melos genAlls
[ ] Run: dart format lib/
[ ] Run: flutter analyze --no-fatal-infos
[ ] Fix any issues (must be 0)

Test:
[ ] Navigate to new page
[ ] Verify functionality
[ ] Test error cases

Report:
[ ] List created files
[ ] List modified files
[ ] Provide navigation example
```

---

## ✅ Task: Add New Use Case

```
[ ] Identify feature: lib/features/{feature}/
[ ] Create use case file: domain/usecases/{verb}_{feature}_usecase.dart
[ ] Add @injectable
[ ] Inject repository
[ ] Implement call() method
[ ] Add business validation
[ ] Update repository interface (if new method needed)
[ ] Implement in repository (data layer)
[ ] Implement in data source (if new endpoint)
[ ] Add corresponding Action
[ ] Add corresponding State/Event (if needed)
[ ] Add action handler in BLoC
[ ] Inject use case in BLoC constructor
[ ] Run: flutter pub run build_runner build --delete-conflicting-outputs
[ ] Test
```

---

## ✅ Task: Fix Bug

```
[ ] Read error message / user description
[ ] Identify layer:
    [ ] UI not updating? → Presentation (BLoC/State)
    [ ] Wrong data? → Data (Repository/DataSource)
    [ ] Wrong logic? → Domain (UseCase)
[ ] Locate file
[ ] Add debug logging (if needed)
[ ] Fix issue
[ ] Verify:
    [ ] emit() is called
    [ ] State has props
    [ ] Action is dispatched correctly
    [ ] Repository returns Entity, not Model
[ ] Run: flutter analyze
[ ] Run: flutter test (if tests exist)
[ ] Report fix with root cause
```

---

## ✅ Task: Add API Endpoint

```
[ ] Identify endpoint: method + URL
[ ] Find/create feature
[ ] Update/create Model (if new)
    [ ] Add @freezed
    [ ] Update fromJson
[ ] Update Remote Data Source
    [ ] Add method to interface
    [ ] Implement with Dio
    [ ] Throw ServerException/NetworkException
[ ] Update Repository
    [ ] Add method to interface (domain)
    [ ] Implement in repository impl (data)
    [ ] Convert exceptions to failures
[ ] Create/update Use Case
[ ] Add to BLoC
[ ] Run: flutter pub run build_runner build --delete-conflicting-outputs
[ ] Test endpoint
```

---

## ✅ Task: Update Entity/Model

```
[ ] Update Entity (domain/entities/)
    [ ] Add new field
    [ ] Update constructor
    [ ] Update props getter
[ ] Update Model (data/models/)
    [ ] Add new field
    [ ] Update toEntity()
    [ ] Update fromEntity()
[ ] Run: flutter pub run build_runner build --delete-conflicting-outputs
[ ] Update UI (if displaying new field)
[ ] Update tests (if exist)
[ ] Run: flutter test
```

---

## ✅ Task: Debug State Not Updating

```
[ ] Check BlocProvider exists
[ ] Check BlocBuilder/BlocConsumer is used
[ ] Check State extends Equatable
[ ] Check State.props includes all fields
[ ] Check emit() is called in BLoC
[ ] Check Action is dispatched: bloc.onAction()
[ ] Check State uses const constructors
[ ] Add debug logging
[ ] Check BLoC not disposed early
```

---

## ✅ Task: Handle Dependency Conflict

```
[ ] Read error message
[ ] Run: flutter pub outdated
[ ] Identify conflicting package
[ ] Check if update available
[ ] Update pubspec.yaml
[ ] Run: flutter pub get
[ ] If still fails, use dependency_overrides (last resort)
[ ] Run: flutter analyze
[ ] Run: flutter test
[ ] Report resolution
```

---

## ✅ Task: Add Tests

```
[ ] Create test file: test/features/{feature}/...
[ ] Import mocktail
[ ] Create Mock classes
[ ] Set up setUp()
[ ] Write test cases:
    [ ] Success case
    [ ] Failure case
    [ ] Validation case
[ ] Run: flutter test {file}
[ ] Check coverage: flutter test --coverage
[ ] Ensure ≥80% coverage
```

---

## ✅ Task: Refactor Code

```
[ ] Identify refactoring goal
[ ] Create new structure
[ ] Move code gradually
[ ] Update imports
[ ] Update DI
[ ] Run: flutter pub run build_runner build --delete-conflicting-outputs
[ ] Run: flutter analyze
[ ] Run: flutter test
[ ] Verify no regressions
[ ] Report changes + benefits
```

---

## 🚨 Common Errors & Quick Fixes

### "GetIt: Object not registered"
```
[ ] Check @injectable or @LazySingleton annotation
[ ] Run: flutter pub run build_runner build --delete-conflicting-outputs
[ ] Check lib/di/injection.config.dart
[ ] Verify configureDependencies() called in main.dart
```

### "Part file doesn't exist"
```
[ ] Run: flutter pub run build_runner build --delete-conflicting-outputs
[ ] Check part declaration matches filename
[ ] Ensure @freezed or @JsonSerializable present
```

### "Type 'XModel' is not a subtype of 'XEntity'"
```
[ ] Use .toEntity() when returning from Repository
[ ] Check Repository returns Entity, not Model
[ ] Verify conversion methods exist
```

### "State not updating"
```
[ ] Add field to State.props
[ ] Ensure emit() is called
[ ] Use const constructors
[ ] Check BlocProvider is present
```

### "Flutter imports in domain"
```
[ ] Remove all package:flutter/* from domain/
[ ] Use pure Dart only
[ ] Domain should have NO UI concerns
```

---

## 🎨 Theme & Styling Rules (MANDATORY)

### ✅ Always Use Theme Tailor

```yaml
Text Styles:
  ❌ NEVER: Theme.of(context).textTheme.bodyMedium
  ✅ ALWAYS: context.appThemes.bodyMedium
  
  ❌ NEVER: Theme.of(context).textTheme.headlineSmall?.copyWith(...)
  ✅ ALWAYS: context.appThemes.headlineSmall.copyWith(...)

Colors:
  ❌ NEVER: Theme.of(context).colorScheme.surface
  ✅ ALWAYS: context.appThemes.surfaceColor
  
  ❌ NEVER: Colors.red, Colors.green, Color(0xFF123456)
  ✅ ALWAYS: context.appThemes.primaryColor, context.appThemes.errorColor

Combined:
  ❌ NEVER: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant
            )
  ✅ ALWAYS: context.appThemes.bodyMedium.copyWith(
              color: context.appThemes.textSecondaryColor
            )
```

### Adding New Colors Checklist

```
[ ] Add color to assets/colors/colors.xml
[ ] Add field to AppThemes class (lib/config/theme/app_themes.dart)
[ ] Initialize in AppThemes.light
[ ] Initialize in AppThemes.dark
[ ] Run: melos genAlls
[ ] Use via context.appThemes.yourColorName
```

---

## 📝 Naming Conventions Quick Reference

```yaml
Files: snake_case
  - wallet_entity.dart
  - transaction_model.dart
  - user_bloc.dart

Classes: PascalCase
  - WalletEntity
  - TransactionModel
  - UserBloc

Actions: VerbNounAction
  - LoadWalletAction
  - CreateTransactionAction

States: NounAdjective/Status
  - WalletLoading
  - WalletLoaded
  - WalletError

Events: VerbNoun or Show/Navigate
  - ShowSuccessMessage
  - NavigateToHome
  - TransactionCreated

Use Cases: VerbNounUseCase
  - GetWalletUseCase
  - CreateTransactionUseCase
```

---

## 🔧 Essential Commands

```bash
# Generate code
flutter pub run build_runner build --delete-conflicting-outputs

# Format code
flutter format .

# Analyze code
flutter analyze

# Run tests
flutter test

# Run specific test
flutter test test/path/to/test.dart

# Run with coverage
flutter test --coverage

# Get dependencies
flutter pub get

# Check outdated
flutter pub outdated

# Clean project
flutter clean && flutter pub get

# Generate Mason feature
mason make mvi_feature --feature_name {name}

# Install Mason bricks
mason get
```

---

## 🎯 Layer Decision Tree

```
Where to add code?

Business Rule / Validation?
  → Domain / Use Case

Data Fetching / API Call?
  → Data / Data Source

Caching Strategy?
  → Data / Repository

Data Transformation (JSON ↔ Object)?
  → Data / Model

State Management?
  → Presentation / BLoC

User Interaction?
  → Presentation / Action

UI Rendering?
  → Presentation / Page/Widget

One-time UI Effect (Toast/Navigation)?
  → Presentation / Event
```

---

## 📊 Architecture Rules (Remember!)

```
1. Dependency Direction:
   Presentation → Domain ← Data
   
2. Return Types:
   Domain/Data Repository: Either<Failure, Success>
   Data Source: Throw Exceptions
   
3. Conversions:
   Data → Domain: Use toEntity()
   Domain → Data: Use fromEntity()
   
4. Purity:
   Domain: NO Flutter imports
   
5. Single Entry:
   BLoC: Only onAction() method
   
6. State vs Event:
   State: Persistent UI data
   Event: One-time side effects
```

---

## ✅ Before Reporting to User

```
[ ] Code generation completed
[ ] No analyzer errors: flutter analyze --no-fatal-infos
[ ] Code formatted: flutter format .
[ ] Tests pass (if exist): flutter test
[ ] Imports organized
[ ] No unused code
[ ] Architecture compliance verified
[ ] All linter errors fixed (0 issues)
```

### 🔍 **CRITICAL: Double Check Steps (Run After Every Task)**

**Always run these commands before reporting completion:**

```bash
# 1. Format all code
flutter format .

# 2. Run analyzer (MUST show "No issues found!")
flutter analyze --no-fatal-infos

# 3. If any issues found:
#    - Read the error messages carefully
#    - Fix each issue
#    - Run flutter analyze again
#    - Repeat until "No issues found!"

# 4. Run tests (if applicable)
flutter test

# 5. Verify build (optional but recommended)
flutter build apk --debug
```

**Expected Output:**
```
Analyzing bloc_digital_wallet...
No issues found! (ran in X.Xs)
```

**If you see errors:**
1. ✅ Read each error message
2. ✅ Fix the issue in the file
3. ✅ Run `flutter analyze` again
4. ✅ Repeat until clean
5. ✅ DO NOT report to user until 0 issues

---

## 📋 Report Template

```markdown
✅ Task completed: {description}

Changes:
- {file1}: {what changed}
- {file2}: {what changed}

Files Created/Modified:
- lib/features/{feature}/...

Commands Run:
- flutter pub run build_runner build --delete-conflicting-outputs
- flutter analyze

Status:
- ✅ No errors
- ✅ Tests passing
- ✅ Architecture compliant

Next Steps (if any):
- {suggestion 1}
- {suggestion 2}
```

---

**For detailed workflows, see: AI_AGENT_WORKFLOWS.md**  
**For context, see: AI_AGENT_CONTEXT.md**
