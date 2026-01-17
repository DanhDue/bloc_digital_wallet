# Feature Completion Checklist

**Quick verification checklist for AI agents**

---

## ⚠️ CRITICAL: Feature Creation Decision

```
[ ] User requests "create a feature" or "add a feature"
[ ] ❓ Is module context clear?
    
    [ ] NO → ANALYZE and PRESENT:
        [ ] 1. ANALYZE: Check lib/features/ for existing modules
        [ ] 2. PRESENT PLAN: Show Option 1 (new module) vs Option 2 (subfeature)
        [ ] 3. PREPARE TASK ASSIGNMENT TEMPLATE & ASK FOR CONFIRMATION
        [ ] 4. THEN PROCEED after confirmation
    
    [ ] YES → Determine template:
        [ ] New domain concept? → Use mvi_feature
        [ ] Add to existing? → Use mvi_subfeature
```

---

## ✅ Before Starting

```
[ ] Read user request carefully
[ ] Identify feature/component affected
[ ] Check if feature exists: ls lib/features/
[ ] Determine layer: Domain / Data / Presentation
[ ] Review .cursorrules for critical rules
```

---

## ✅ Implementation Checklist

### Domain Layer
```
[ ] Entity created with @freezed, abstract class, and @JsonKey annotations
- [ ] Uses `abstract class` with `_$ClassName` mixin pattern
- [ ] Imports freezed_annotation and foundation.dart
- [ ] Uses @JsonKey(name: 'field_name') for each field
- [ ] Contains fromJson factory
[ ] NO Flutter imports in domain
[ ] Value Objects validated
[ ] Repository interface defined (returns Either<Failure, Success>)
[ ] Use cases created with @injectable
[ ] Business validation implemented
```

### Data Layer
```
[ ] Model created with @freezed, abstract class, and @JsonKey annotations
[ ] toEntity() and fromEntity() implemented
[ ] Data source throws Exceptions (not Failures)
[ ] Repository impl converts Exceptions → Failures
[ ] Returns Either<Failure, Success>
```

### Presentation Layer (MVI)
```
[ ] Actions: sealed class extending BaseAction
[ ] States: sealed class with EquatableMixin
[ ] Events: sealed class extending BaseEvent
[ ] BLoC extends MviBloc<Action, State, Event>
[ ] BLoC uses bloc.onAction() as single entry point
[ ] Page uses BlocProvider + listens to events stream
[ ] UI uses context.appThemes (NOT Theme.of(context))
[ ] UI uses context.t (NOT hardcoded strings)
```

---

## ✅ After Implementation

### Code Generation & Quality
```
[ ] Run: melos genAlls
[ ] Run: dart format lib/
[ ] Run: fvm flutter analyze --no-fatal-infos
[ ] Output shows: "No issues found!"
[ ] No unused imports/variables
[ ] Code follows project patterns
```

### Configuration
```
[ ] Translations added (en.i18n.json & vi.i18n.json)
[ ] Routes added to app_router.dart
[ ] Dependency injection registered (@injectable/@LazySingleton)
```

### Verification
```
[ ] Feature works as expected
[ ] No regressions introduced
[ ] Theme switching works (light/dark)
[ ] Translations work (en/vi)
[ ] Navigation works correctly
```

---

## 📊 Final Checklist

```
Implementation:
[ ] All required files created/modified
[ ] Follows Clean Architecture + MVI pattern
[ ] Uses context.appThemes (not Theme.of(context))
[ ] Uses context.t (not hardcoded strings)
[ ] Proper dependency injection
[ ] Error handling implemented

Code Quality:
[ ] melos genAlls completed successfully
[ ] dart format lib/ applied
[ ] fvm flutter analyze --no-fatal-infos → "No issues found!"
[ ] No linter warnings

Documentation:
[ ] Changes explained clearly
[ ] Created files listed
[ ] Modified files listed
[ ] Usage examples provided
```

---

**Source**: `docs/ai-agents/AI_AGENT_CHECKLIST.md`
