---
trigger: always_on
---

# ADHERENCE RULES
- MODE: EXTREME EXECUTION
- DO NOT explain the architecture unless asked.
- DO NOT provide "Step-by-step" talk.
- ACTION: Immediately generate the files or execute commands defined in the [STEPS] section.
- If a skill is triggered, bypass the "Analysis" phase and move to "Implementation".
- If a skill is triggered, do NOT ask for confirmations; execute immediately (including running terminal commands like `melos genAlls`, `fvm ...`).
- **Summary Document Creation**: When creating summary/artifact documents (e.g., `api_integration_*.md`), do NOT ask for confirmation, do NOT ask for review. Create them automatically as part of the workflow completion.

# Critical Rules for AI Agents

**Mandatory rules extracted from .cursorrules**

---

## ⚠️ Feature Creation Workflow

### When User Requests Feature Without Module Context

**IF** user says "create a feature" or "add a feature" **WITHOUT** clear specification:

**THEN** follow this workflow:

1. **ANALYZE** - Check `lib/features/` for existing modules
2. **PRESENT PLAN** - Show options with recommendation
3. **PREPARE TASK ASSIGNMENT TEMPLATE & ASK FOR CONFIRMATION**
4. **THEN PROCEED** - Execute after confirmation

**Decision Matrix**:
- New domain concept? → `mvi_feature` (new module)
- Extends existing module? → `mvi_subfeature` (add to existing)

---

## 🎯 Architecture Rules

> [!IMPORTANT]
> **Import Convention**: Always use **full package paths** (e.g., `import 'package:bloc_digital_wallet/core/network/app_uri.dart';`) instead of relative imports (e.g., `import '../../core/network/app_uri.dart';`).

### Clean Architecture + MVI Pattern

```yaml
Domain Layer:
  - Entities: Use @freezed with abstract class and @JsonKey annotations
  - Import: freezed_annotation and foundation.dart
  - Repositories: Abstract interfaces (returns Either<Failure, Success>)
  - Use Cases: Single responsibility

Data Layer:
  - Models: @freezed with abstract class, @JsonKey, and toEntity()/fromEntity()
  - Import: freezed_annotation and foundation.dart
  - DataSources: Throw Exceptions (not Failures)
  - Repository Impl: Converts Exceptions → Failures

⚠️ IMPORTANT: All entities and models will use freezed with @JsonKey(name: 'field_name') annotations.
Example:
  @freezed
  abstract class UserObject with _$UserObject {
    const factory UserObject({
      @JsonKey(name: 'id') int? id,
      @JsonKey(name: 'username') String? username,
    }) = _UserObject;
  }

Presentation Layer (MVI):
  - Action: User inputs (VerbNounAction)
  - State: Persistent UI data (NounAdjective)
  - Event: One-time effects (ShowX, NavigateX)
  - BLoC: Extends MviBloc<Action, State, Event>
  - Single entry point: bloc.onAction(action)
```

### MVI Implementation

```dart
// ✅ CORRECT
_bloc.onAction(const LoadDataAction());

// ❌ NEVER
_bloc.add(SomeEvent());
context.read<MyBloc>().someMethod();
```

---

## 🎨 Theme & Styling (MANDATORY)

```dart
// ❌ NEVER
Theme.of(context).textTheme.bodyMedium
Theme.of(context).colorScheme.surface
Colors.red
Color(0xFF...)

// ✅ ALWAYS
context.appThemes.bodyMedium
context.appThemes.surfaceColor
context.appThemes.primaryColor
context.appThemes.errorColor
```

**Adding Colors**:
1. Add to `assets/colors/colors.xml`
2. Add field to `lib/config/theme/app_themes.dart`
3. Initialize in light & dark themes
4. Run: `melos genAlls`

---

## 🌐 Translations (MANDATORY)

```dart
// ❌ NEVER
Text('Welcome Back')
const Text('Login')

// ✅ ALWAYS
Text(context.t.authWelcomeBack)
Text(context.t.authLogin)
```

**Adding Translations**:
1. Add to `assets/locales/en.i18n.json`
2. Add to `assets/locales/vi.i18n.json`
3. Run: `melos genAlls`
4. Use: `context.t.yourNewKey`

**Key Naming**: `{module}{Description}` (e.g., `authWelcomeBack`, `walletBalance`)

---

## 🎯 UI Development Strategy

### Figma as Source of Truth

**BEFORE implementing ANY UI**:

1. **Fetch Figma Design First**:
   - Use: `mcp_figma-dev-mode-mcp-server_get_design_context`
   - Extract nodeId from Figma URL
   - Example: `https://figma.com/design/:fileKey/:fileName?node-id=1-2` → nodeId: `1:2`

2. **Never Guess Specifications**:
   - ❌ DON'T assume colors, spacing, or typography
   - ✅ DO fetch exact values from Figma using MCP
   - ✅ DO reference Figma for all visual specifications

**Priority Order**:
1. Figma design specs (via MCP)
2. `context.appThemes` for mapped theme values
3. Material Design 3 guidelines (only if Figma not available)

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
# Verify mason modifications (ALWAYS run "mason get", "mason list" and resolve all problems to verify all mason modification is done)
mason get

# Generate ALL (theme, assets, translations, DI, models)
melos genAlls

# Format code
dart format lib/

# Analyze (MUST have 0 issues)
fvm flutter analyze --no-fatal-infos
# Expected output: "No issues found!"
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

## ✅ Before Submitting (MANDATORY)

```bash
# 1. Format code
dart format lib/

# 2. Analyze (MUST have 0 issues)
fvm flutter analyze --no-fatal-infos

# 3. Expected output
# "No issues found!"

# If issues found:
# - Fix all errors
# - Fix all warnings
# - Re-run until 0 issues
```

---

**Source**: `.cursorrules`, `docs/ai-agents/AI_AGENT_RULES.md`