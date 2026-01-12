# Cursor Rules for bloc_digital_wallet

**Architecture**: Clean Architecture + MVI Pattern 
**Framework**: Flutter/Dart 
**Organization**: Feature-first structure

---

## ⚠️ CRITICAL: Plan Before Creating Features

### MANDATORY RULE: When User Requests Feature Without Module Context

**IF** user says "create a feature" or "add a feature" **WITHOUT** clearly specifying:
- Whether it's a new module (e.g., "create authentication module")
- OR a subfeature of existing module (e.g., "add forgot password to authentication")

**THEN** you MUST follow this workflow:

1. **ANALYZE** - Check if related module exists in `lib/features/`
   - List existing modules
   - Determine if this feature belongs to existing module
   - Or if it's a new domain concept

2. **PRESENT PLAN** - Show clear options with recommendations:
   - **Option 1**: Create as new module (if no related module exists)
     - Use `mvi_feature`
     - What will be created: complete module structure
   - **Option 2**: Add as subfeature (if related module exists)
     - Use `mvi_subfeature`
     - What will be created: use case, page, widget
     - What will be modified: bloc, repository, etc.
   - Include your **recommendation** based on analysis

3. **PREPARE TASK ASSIGNMENT TEMPLATE & ASK FOR MODULE INFORMATION AND CONFIRMATION**
   - Prepare structured template (see docs/task-prompt-templates/README.md format)
   - Present organized information request:
     ```
     MODULE INFORMATION:
     - Target module: [recommended]
     - Feature name: [suggested]
     - Functionality: [scope]
     - UI requirements: [screens/components]
     
     TECHNICAL DETAILS:
     - API endpoints: [if applicable]
     - Validation: [requirements]
     - Error handling: [approach]
     
     CONFIRMATION:
     Should I proceed with [recommended option]?
     ```
   - Wait for user response with confirmations/corrections

4. **THEN PROCEED** - After receiving confirmation, execute the appropriate workflow

### Example Workflow

```
User: "Create a forgot password feature"

AI Response:
"I'll analyze the codebase and present implementation options:

ANALYSIS:
- Found existing module: lib/features/authentication/
- Forgot password is related to authentication domain
- Current auth module has: login, register use cases

RECOMMENDATION: Add as subfeature to authentication module

OPTION 1 (Recommended): Add Subfeature
- Template: mvi_subfeature
- Module: authentication
- Creates: forgot_password_usecase.dart, forgot_password_page.dart, widget
- Modifies: authentication_action.dart, authentication_bloc.dart, repository
- Benefit: Reuses existing AuthenticationRepository, AuthenticationBloc

OPTION 2: Create New Module
- Template: mvi_feature
- Creates: Complete new forgot_password module
- Note: Would duplicate authentication infrastructure (not recommended)

Which option should I proceed with? (Option 1 recommended)

---

To proceed, I need to confirm:

MODULE INFORMATION:
- Target module: authentication
- Subfeature: forgot_password
- Functionality: Password reset via email
- UI: New page from login screen

TECHNICAL DETAILS:
- API: POST /auth/forgot-password (confirm?)
- Validation: Email format
- Flow: Input → API call → Success message → Back to login

CONFIRMATION:
Proceed with Option 1 (subfeature)?
Please confirm or provide corrections."

[WAITS FOR CONFIRMATION]
```

### Decision Matrix

| User Request | Module Exists? | Recommended | Action |
|-------------|----------------|-------------|---------|
| "Create authentication" | ❌ No | `mvi_feature` | Analyze → Present → Confirm → Proceed |
| "Add forgot password" | ✅ authentication | `mvi_subfeature` | Analyze → Present → Confirm → Proceed |
| "Add feature X" | ❓ Unknown | **Analyze first** | Analyze → Present → Ask → Proceed |

### Quick Reference

**New Module** (`mvi_feature`):
- ✅ Completely new domain concept
- ✅ No existing related module
- ✅ Examples: authentication (first time), wallet (first time), profile (first time)

**Subfeature** (`mvi_subfeature`):
- ✅ Related module already exists
- ✅ Extends existing functionality
- ✅ Examples: forgot_password (to authentication), transfer_money (to wallet)

---

## 🎯 CRITICAL RULES (Always Follow)

### 1. Architecture Pattern: Clean + MVI

```yaml
Domain Layer (lib/features/{feature}/domain/):
  - Entities: Pure Dart classes with Equatable
  - Repositories: Abstract interfaces
  - Use Cases: Single responsibility, returns Either<Failure, Success>
  - NO Flutter imports allowed

Data Layer (lib/features/{feature}/data/):
  - Models: @freezed with toEntity()/fromEntity()
  - DataSources: Throw Exceptions
  - Repository Impl: Converts Exceptions → Failures, returns Either

Presentation Layer (lib/features/{feature}/presentation/):
  - Action: User inputs (VerbNounAction)
  - State: Persistent UI data (NounAdjective)
  - Event: One-time effects (ShowX, NavigateX)
  - BLoC: Extends MviBloc<Action, State, Event>
  - Page: Uses BlocProvider + listen to events stream
```

### 2. MVI Implementation

```dart
// ✅ CORRECT Pattern
class MyBloc extends MviBloc<MyAction, MyState, MyEvent> {
  MyBloc() : super(const MyInitial());

  @override
  Future<void> onAction(MyAction action) async {
    switch (action) {
      case LoadDataAction():
        emit(const MyLoading());
        final result = await _useCase.execute();
        result.fold(
          (failure) => emit(MyError(failure.message)),
          (data) => emit(MyLoaded(data)),
        );
      case SubmitFormAction():
        emitEvent(const ShowSuccessMessage('Form submitted!'));
    }
  }
}

// In Widget
_bloc.onAction(const LoadDataAction());  // ✅ ONLY way to send action
_bloc.events.listen((event) { /* handle one-time events */ });
```

### 3. Theme & Styling

```dart
// ❌ NEVER
Theme.of(context).textTheme.bodyMedium
Theme.of(context).colorScheme.surface
Colors.red

// ✅ ALWAYS
context.appThemes.bodyMedium
context.appThemes.surfaceColor
context.appThemes.primaryColor
context.appThemes.bodyMedium.copyWith(color: context.appThemes.textSecondaryColor)
```

**Adding Colors**: `assets/colors/colors.xml` → `lib/config/theme/app_themes.dart` → `melos genAlls`

---

## 🎯 UI Development Strategy

### CRITICAL: Figma as Source of Truth

**BEFORE implementing ANY UI**, you MUST:

1. **Fetch Figma Design First**:
   ```
   Use: mcp_figma-dev-mode-mcp-server_get_design_context
   Extract nodeId from Figma URL:
   Example: https://figma.com/design/:fileKey/:fileName?node-id=1-2
   Extract: nodeId = "1:2"
   ```

2. **Never Guess Specifications**:
   - ❌ DON'T assume colors, spacing, or typography
   - ✅ DO fetch exact values from Figma using MCP
   - ✅ DO reference Figma for all visual specifications
   
3. **Priority Order**:
   - **1st**: Figma design specs (via MCP)
   - **2nd**: `context.appThemes` for mapped theme values
   - **3rd**: Material Design 3 guidelines (only if Figma not available)

### Available Figma MCP Tools

```dart
// Get design context and code for a specific node
mcp_figma-dev-mode-mcp-server_get_design_context(
  nodeId: "1:2",  // Extract from Figma URL
  clientLanguages: "dart",
  clientFrameworks: "flutter"
)

// Get screenshot for visual reference
mcp_figma-dev-mode-mcp-server_get_screenshot(
  nodeId: "1:2"
)

// Get metadata/structure overview
mcp_figma-dev-mode-mcp-server_get_metadata(
  nodeId: "1:2"
)

// Get variable definitions (colors, etc.)
mcp_figma-dev-mode-mcp-server_get_variable_defs(
  nodeId: "1:2"
)
```

### Workflow for UI Implementation

```markdown
1. FETCH DESIGN:
   [ ] Extract nodeId from Figma URL
   [ ] Call get_design_context or get_screenshot
   [ ] Review colors, spacing, typography specs
   
2. MAP TO THEME:
   [ ] Map Figma colors → context.appThemes colors
   [ ] If new color needed: Add to assets/colors/colors.xml
   [ ] Map Figma text styles → context.appThemes text styles
   
3. IMPLEMENT:
   [ ] Use exact spacing values from Figma
   [ ] Use exact color values (via appThemes)
   [ ] Use exact typography (via appThemes)
   [ ] Maintain responsive behavior
   
4. VERIFY:
   [ ] Compare implementation with Figma screenshot
   [ ] Check all measurements match
   [ ] Verify colors in both light/dark themes
```

### Example: Implementing from Figma

```dart
// ❌ WRONG: Guessing values
Container(
  padding: EdgeInsets.all(16),  // Guessed
  decoration: BoxDecoration(
    color: Colors.blue,  // Hardcoded guess
    borderRadius: BorderRadius.circular(8),  // Guessed
  ),
  child: Text(
    'Login',
    style: TextStyle(fontSize: 16),  // Guessed
  ),
)

// ✅ CORRECT: Using Figma specs via MCP
// After fetching design context for node "1:5":
// - Padding: 24px (from Figma)
// - Background: Primary color (from Figma variables)
// - Border radius: 12px (from Figma)
// - Text: Title Medium style (from Figma)
Container(
  padding: const EdgeInsets.all(24),  // From Figma
  decoration: BoxDecoration(
    color: context.appThemes.primaryColor,  // Mapped from Figma
    borderRadius: BorderRadius.circular(12),  // From Figma
  ),
  child: Text(
    context.t.authLogin,  // Localized
    style: context.appThemes.titleMedium,  // Mapped from Figma
  ),
)
```

---

### 4. Localization

```dart
// ❌ NEVER
Text('Welcome Back')
const Text('Login')

// ✅ ALWAYS
Text(context.t.authWelcomeBack)
Text(context.t.authLogin)
```

**Adding Translations**: 
1. `assets/locales/en.i18n.json` + `assets/locales/vi.i18n.json`
2. `melos genAlls`
3. If duplicate file: `rm lib/generated/translations` (no .dart extension)
4. `context.t.yourNewKey`

**Key Naming**: `{module}{Description}` (e.g., `authWelcomeBack`, `profileEditButton`)

---

## 📝 Naming Conventions

```yaml
Files: snake_case
  - wallet_entity.dart
  - transaction_bloc.dart

Classes: PascalCase
  - WalletEntity
  - TransactionBloc

Actions: VerbNounAction
  - LoadWalletAction
  - CreateTransactionAction

States: NounAdjective
  - WalletLoading
  - WalletLoaded
  - WalletError

Events: VerbNoun or Show/Navigate
  - ShowSuccessMessage
  - NavigateToDetail
  - TransactionCreated

Use Cases: VerbNounUseCase
  - GetWalletUseCase
  - CreateTransactionUseCase
```

---

## 🔧 Code Generation Commands

```bash
# Generate ALL (theme, assets, translations, DI, models)
melos genAlls

# OR individual commands
flutter pub run build_runner build --delete-conflicting-outputs  # Models, DI, Translations

# If duplicate translations file exists (rare)
rm lib/generated/translations  # Remove file without .dart extension

# Mason (generate feature)
mason make mvi_feature --feature_name wallet
```

---

## 🏗️ Feature Creation Workflow

### Using Mason (Recommended)

#### Create New Module (mvi_feature)
```bash
# 1. Generate complete module scaffold
mason make mvi_feature
# → What is the feature name? my_feature

# 2. Verify generated files
lib/features/my_feature/
 domain/...
 data/...
 presentation/...

# 3. Run code generation
melos genAlls

# 4. Register in DI (if needed - usually auto-registered)
# Check lib/di/injection.config.dart

# 5. Add route (if page)
lib/app_router.dart → @AutoRouterConfig
```

#### Add Subfeature to Existing Module (mvi_subfeature)
```bash
# 1. Generate subfeature (e.g., forgot_password in authentication)
mason make mvi_subfeature
# → Module name? authentication
# → Subfeature name? forgot_password
# → Entity name? [Press Enter to reuse module's entity]
# → Create new data model? N
# → Create new entity? N

# 2. Verify generated files
lib/features/authentication/
 domain/usecases/forgot_password_usecase.dart
 presentation/pages/forgot_password_page.dart
 presentation/widgets/forgot_password_widget.dart

# 3. Add action to module bloc
# Edit: lib/features/authentication/presentation/mvi/authentication_action.dart

# 4. Handle action in bloc
# Edit: lib/features/authentication/presentation/mvi/authentication_bloc.dart

# 5. Update repository (if needed)
# Edit: domain/repositories/ and data/repositories/

# 6. Run code generation
melos genAlls

# 7. Add route (if needed)
lib/app_router.dart → @AutoRouterConfig
```

### Manual Creation Pattern

```
lib/features/{feature}/
  domain/
    entities/{feature}_entity.dart
    repositories/{feature}_repository.dart
    usecases/{verb}_{feature}_usecase.dart
  data/
    models/{feature}_model.dart
    datasources/{feature}_remote_datasource.dart
    repositories/{feature}_repository_impl.dart
  presentation/
    mvi/
      {feature}_action.dart
      {feature}_state.dart
      {feature}_event.dart
      {feature}_bloc.dart
    pages/{feature}_page.dart
    widgets/{feature}_widget.dart
```

---

## ⚡ Quick Patterns

### Domain Entity
```dart
class WalletEntity extends Equatable {
  final String id;
  final double balance;
  
  const WalletEntity({required this.id, required this.balance});
  
  @override
  List<Object?> get props => [id, balance];
}
```

### Data Model
```dart
@freezed
class WalletModel with _$WalletModel {
  const factory WalletModel({
    required String id,
    required double balance,
  }) = _WalletModel;
  
  factory WalletModel.fromJson(Map<String, dynamic> json) => 
    _$WalletModelFromJson(json);
  
  const WalletModel._();
  
  WalletEntity toEntity() => WalletEntity(id: id, balance: balance);
  
  factory WalletModel.fromEntity(WalletEntity entity) => 
    WalletModel(id: entity.id, balance: entity.balance);
}
```

### Use Case
```dart
@injectable
class GetWalletUseCase {
  final WalletRepository _repository;
  
  const GetWalletUseCase(this._repository);
  
  Future<Either<Failure, WalletEntity>> call(String id) async {
    return _repository.getWallet(id);
  }
}
```

### Repository Implementation
```dart
@Injectable(as: WalletRepository)
class WalletRepositoryImpl implements WalletRepository {
  final WalletRemoteDataSource _remoteDataSource;
  
  const WalletRepositoryImpl(this._remoteDataSource);
  
  @override
  Future<Either<Failure, WalletEntity>> getWallet(String id) async {
    try {
      final model = await _remoteDataSource.getWallet(id);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unknown error: $e'));
    }
  }
}
```

### BLoC
```dart
@injectable
class WalletBloc extends MviBloc<WalletAction, WalletState, WalletEvent> {
  final GetWalletUseCase _getWalletUseCase;
  
  WalletBloc(this._getWalletUseCase) : super(const WalletInitial());
  
  @override
  Future<void> onAction(WalletAction action) async {
    switch (action) {
      case LoadWalletAction(:final id):
        emit(const WalletLoading());
        final result = await _getWalletUseCase(id);
        result.fold(
          (failure) => emit(WalletError(failure.message)),
          (wallet) => emit(WalletLoaded(wallet)),
        );
    }
  }
}
```

### Page
```dart
@RoutePage()
class WalletPage extends StatefulWidget {
  const WalletPage({super.key});
  
  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  late final WalletBloc _bloc;
  late final StreamSubscription<WalletEvent> _eventSub;
  
  @override
  void initState() {
    super.initState();
    _bloc = getIt<WalletBloc>();
    _eventSub = _bloc.events.listen((event) {
      if (!mounted) return;
      switch (event) {
        case ShowWalletErrorMessage(:final message):
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
      }
    });
    _bloc.onAction(const LoadWalletAction('123'));
  }
  
  @override
  void dispose() {
    _eventSub.cancel();
    _bloc.close();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        body: BlocBuilder<WalletBloc, WalletState>(
          builder: (context, state) {
            return switch (state) {
              WalletLoading() => const CircularProgressIndicator(),
              WalletLoaded(:final wallet) => Text('Balance: ${wallet.balance}'),
              WalletError(:final message) => Text('Error: $message'),
              _ => const SizedBox.shrink(),
            };
          },
        ),
      ),
    );
  }
}
```

---

## ✅ Before Submitting (MANDATORY)

```bash
# 1. Format code
dart format lib/

# 2. Analyze (MUST have 0 issues)
flutter analyze --no-fatal-infos

# 3. Expected output
# "No issues found!"

# If issues found:
# - Fix all errors
# - Fix all warnings
# - Re-run until 0 issues
```

---

## 🚫 Common Mistakes to Avoid

### ❌ DON'T
```dart
// 1. Hardcoded strings
Text('Welcome')

// 2. Direct Theme.of(context)
Theme.of(context).colorScheme.primary

// 3. Multiple ways to interact with BLoC
_bloc.add(SomeEvent());  // Wrong - this is not MVI!
context.read<MyBloc>().someMethod();  // Wrong

// 4. Flutter imports in domain
import 'package:flutter/material.dart';  // In domain layer

// 5. Ignoring Either result
await _useCase();  // Missing .fold()

// 6. State logic in widgets
if (someCondition) _bloc.onAction(...);  // Logic should be in BLoC
```

### ✅ DO
```dart
// 1. Use translations
Text(context.t.authWelcome)

// 2. Use theme_tailor
context.appThemes.primaryColor

// 3. Single action entry point
_bloc.onAction(const LoadDataAction());

// 4. Pure Dart in domain
// No Flutter imports

// 5. Handle Either properly
result.fold(
  (failure) => emit(ErrorState(failure.message)),
  (data) => emit(LoadedState(data)),
);

// 6. Business logic in BLoC
// Widget only dispatches actions based on user interaction
```

---

## 📚 Key Files Reference

```yaml
Architecture:
  - lib/core/architecture/mvi_base.dart
  - lib/core/architecture/mvi_bloc.dart

DI Setup:
  - lib/di/injection.dart
  - lib/di/injection.config.dart (generated)

Theme:
  - lib/config/theme/app_themes.dart
  - lib/config/theme/app_text_styles.dart
  - assets/colors/colors.xml

Localization:
  - assets/locales/en.i18n.json
  - assets/locales/vi.i18n.json
  - lib/generated/translations.dart (generated)

Routing:
  - lib/app_router.dart
  - lib/app_router.gr.dart (generated)

Mason Bricks:
 - bricks/mvi_feature/ (create new module)
 - bricks/mvi_subfeature/ (add to existing module)
```

---

## 🔍 Documentation Lookup

```yaml
Quick References:
  - .cursorrules (this file)
  - docs/getting-started/QUICK_REFERENCE.md

Detailed Guides:
 - docs/architecture/ARCHITECTURE_OVERVIEW.md
 - docs/development/IMPLEMENTATION_GUIDE.md
 - docs/development/THEME_TAILOR_GUIDE.md
 - docs/development/SLANG_LOCALIZATION_GUIDE.md
 - docs/mason/MASON_TEMPLATES_OVERVIEW.md (quick reference)
 - docs/mason/MVI_SUBFEATURE_GUIDE.md (comprehensive guide)
 - docs/mason/MASON_GUIDE.md

For AI Agents:
  - docs/ai-agents/AI_AGENT_CONTEXT.md (comprehensive)
  - docs/ai-agents/AI_AGENT_CHECKLIST.md (quick lookup)
  - docs/ai-agents/AI_AGENT_WORKFLOWS.md (step-by-step)
  - docs/ai-agents/DOUBLE_CHECK_GUIDE.md (⚠️ MANDATORY after changes)
```

---

## 🎯 Task Implementation Checklist

- [ ] Understand feature requirements
- [ ] Generate scaffold: `mason make mvi_feature --feature_name X`
- [ ] Implement domain (entities, use cases, repository interface)
- [ ] Implement data (models, data sources, repository impl)
- [ ] Implement presentation (actions, states, events, bloc, page)
- [ ] Use `context.appThemes` for all colors/styles
- [ ] Use `context.t` for all user-facing text
- [ ] Add routes to `app_router.dart` if needed
- [ ] Run `melos genAlls` for code generation
- [ ] Run `dart format lib/`
- [ ] Run `flutter analyze --no-fatal-infos` → **MUST be 0 issues**
- [ ] Test the feature manually
- [ ] Document any new patterns or special cases

---

## 💡 Pro Tips

1. **Start with Domain**: Always implement domain layer first (entities, use cases)
2. **Use Mason**: Let it generate the boilerplate, then customize
3. **Listen to Events**: Don't forget to listen to `_bloc.events.listen()` for one-time effects
4. **Dispose Properly**: Always cancel event subscriptions and close blocs
5. **Check Examples**: Look at existing features (authentication) for patterns
6. **Run genAlls Often**: After any model/theme/translation changes
7. **Fix File Extension**: If `translations` has no `.dart`, rename it
8. **Use Freezed**: For data models with toEntity/fromEntity
9. **Injectable DI**: Use `@injectable` and let it auto-register
10. **Type Safety**: Let slang and theme_tailor catch errors at compile time

---

## 🚀 Speed Optimization

### For Quick Fixes
```bash
# Change existing text → Add translation → Regenerate → Use context.t
# Change color → Add to colors.xml → Update app_themes.dart → genAlls → Use context.appThemes

# Quick check
fvm flutter analyze --no-fatal-infos  # Must show "No issues found!"
```

### For New Features
```bash
# 1. Mason generate (1 min)
mason make mvi_feature --feature_name wallet

# 2. Implement logic (variable time)
# domain → data → presentation

# 3. Generate & verify (30 sec)
melos genAlls
dart format lib/
fvm flutter analyze --no-fatal-infos

# 4. Test (variable time)
```

---

**Last Updated**: 2026-01-12  
**Version**: 1.0  
**Status**: Production Ready ✅

**Quick Help**: If stuck, check `docs/ai-agents/AI_AGENT_WORKFLOWS.md` for detailed step-by-step workflows.
