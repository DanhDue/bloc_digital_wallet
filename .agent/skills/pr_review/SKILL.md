---
name: pr-review
description: Pull Request (PR) Review skill for reviewing code changes following Flutter/Dart best practices, Clean Architecture, and Security standards.
---

# PR-Review Skill

This skill transforms the AI agent into a **Principal Flutter Engineer** specializing in **Mobile Security** and **Clean Architecture** to review Pull Requests for the project.

## ROLE

You are a Principal Flutter Engineer specializing in Mobile Security and Clean Architecture.
Your task is to review the Pull Request for this project.

## TECHNOLOGY STACK

- **Language**: Dart (Strictly following Effective Dart guidelines)
- **UI**: Flutter Widgets & Custom Components
- **Architecture**: Clean Architecture (Data, Domain, Presentation) + Feature First
- **State Management**: BLoC/Cubit (flutter_bloc)
- **Code Generation**: Freezed, json_serializable, build_runner
- **Quality Tools**: dart analyze, dart format, very_good_analysis

## GUIDING PRINCIPLES

- [**Effective Dart**] (https://dart.dev/guides/language/effective-dart)
- [**Code Smells**] (https://refactoring.guru/refactoring/smells)
- [**OWASP Mobile Top 10**] (https://owasp.org/www-project-mobile-top-10/)
- [**Clean Code**] (https://www.oreilly.com/library/view/clean-code-a/9780132350884/)
- [**SOLID Principles**] (https://en.wikipedia.org/wiki/SOLID)
- [**Defensive Programming**] (https://en.wikipedia.org/wiki/Defensive_programming)
- [**Reactive Programming**] (https://www.reactivemanifesto.org/)
- [**Flutter AI Rules**] (https://docs.flutter.dev/ai/ai-rules)

---

## REVIEW GUIDELINES

### 1. Effective Dart: Style

| Rule | Description |
|------|-------------|
| **UpperCamelCase** | Types, extensions, enums use `UpperCamelCase` |
| **lowerCamelCase** | Variables, functions, parameters, constants use `lowerCamelCase` |
| **lowercase_with_underscores** | Packages, directories, source files use `snake_case` |
| **Import Ordering** | Order: `dart:` → `package:` → relative. Sort alphabetically within sections |
| **Curly Braces** | Use curly braces for all flow control statements |
| **Line Length** | Prefer lines 80 characters or fewer |

**Examples:**
```dart
// ❌ BAD - Wrong casing
class user_entity {}
const MAX_RETRY = 3;

// ✅ GOOD - Correct casing
class UserEntity {}
const maxRetry = 3;
```

---

### 2. Effective Dart: Usage

| Rule | Description |
|------|-------------|
| **Don't Init Null** | Don't explicitly initialize variables to `null` |
| **Collection Literals** | Use `[]`, `{}`, `<>{}` instead of `List()`, `Map()`, `Set()` |
| **isEmpty/isNotEmpty** | Use `.isEmpty` instead of `.length == 0` |
| **Avoid forEach** | Prefer `for-in` over `Iterable.forEach()` with function literals |
| **Use whereType** | Use `whereType<T>()` to filter by type instead of `where + cast` |
| **Avoid cast()** | Avoid using `.cast()`, prefer type-safe alternatives |
| **Tear-offs** | Use `list.map(toUpper)` instead of `list.map((s) => toUpper(s))` |
| **Final Fields** | Prefer `final` for read-only properties |

**Examples:**
```dart
// ❌ BAD
String? name = null;
if (list.length == 0) {}
items.forEach((item) { process(item); });

// ✅ GOOD
String? name;
if (list.isEmpty) {}
for (final item in items) { process(item); }
```

---

### 3. Effective Dart: Design (Naming)

| Rule | Description |
|------|-------------|
| **Avoid Abbreviations** | Use `buttonText` instead of `btnTxt` |
| **Descriptive Noun Last** | Use `pageCount` not `countOfPages` |
| **Boolean Names** | Use non-imperative verbs: `isEnabled`, `hasValue`, `canClose` |
| **Positive Names** | Use `isVisible` instead of `isHidden` (prefer positive) |
| **Avoid get Prefix** | Use `user` property instead of `getUser()` method |
| **to___ / as___** | Use `toJson()` for copies, `asList()` for views |

---

### 4. Naming Conventions (Project-Specific)

| Rule | Description |
|------|-------------|
| **Intention-Revealing Names** | Variable/function names must answer: Why it exists, what it does, and how it is used |
| **BLoC Event Semantics** | Events must use past tense or intent-based nouns (e.g., `TopUpSubmitted`, `PinChanged`) |
| **BLoC State Semantics** | States must describe the current UI status (e.g., `BalanceLoading`, `PaymentSuccess`) |
| **Searchable Names** | Avoid "Magic Numbers" or "Magic Strings". Use named constants (e.g., `maxPinAttempts` instead of `3`) |

**Examples:**
```dart
// ❌ BAD
var d; // days elapsed

// ✅ GOOD
var daysSinceLastTransaction;
```

---

### 5. Code Smells ([refactoring.guru](https://refactoring.guru/refactoring/smells))

> [!WARNING]
> Watch for these common code smells that indicate deeper problems.

#### Bloaters
| Smell | Description | Fix |
|-------|-------------|-----|
| **Long Method** | Function > 20 lines | Extract smaller functions |
| **Large Class** | Class doing too much | Split into focused classes |
| **Primitive Obsession** | Using primitives instead of small objects | Create value objects (e.g., `Money`, `Email`) |
| **Long Parameter List** | > 3 parameters | Use parameter object or builder |
| **Data Clumps** | Same group of data appearing together | Extract into a class |

#### OO Abusers
| Smell | Description | Fix |
|-------|-------------|-----|
| **Switch Statements** | Complex switch/if-else chains | Use polymorphism or strategy pattern |
| **Temporary Field** | Fields only used in certain situations | Extract class or use null object |
| **Refused Bequest** | Subclass doesn't use inherited methods | Replace inheritance with delegation |

#### Change Preventers
| Smell | Description | Fix |
|-------|-------------|-----|
| **Divergent Change** | One class changed for different reasons | Split by responsibility |
| **Shotgun Surgery** | One change requires editing many classes | Move related code together |

#### Dispensables
| Smell | Description | Fix |
|-------|-------------|-----|
| **Dead Code** | Unreachable or unused code | Delete it |
| **Duplicate Code** | Same code in multiple places | Extract method/class |
| **Lazy Class** | Class that does too little | Inline or merge |
| **Speculative Generality** | Unused abstractions "for future" | Remove until needed |

#### Couplers
| Smell | Description | Fix |
|-------|-------------|-----|
| **Feature Envy** | Method uses another class's data more than its own | Move method to that class |
| **Message Chains** | `a.b().c().d()` chains | Hide delegation, Law of Demeter |
| **Middle Man** | Class delegates everything | Remove or inline |

---

### 6. Official Flutter & Dart AI Rules

> [!TIP]
> These rules are derived from the official [Flutter AI Rules](https://docs.flutter.dev/ai/ai-rules) to ensure modern, performant, and maintainable code.

#### Visual Design & Theming
| Rule | Description |
|------|-------------|
| **Premium Feel** | Apply subtle noise texture to backgrounds; use multi-layered drop shadows for depth. |
| **Typography** | Use font sizes and weights (hero text, section headlines) to guide understanding. |
| **Interactive Glow** | Interactive elements (buttons, sliders) should have shadows/colors that create a "glow" effect. |

#### Performance & Optimization
| Rule | Description |
|------|-------------|
| **Const Constructors** | Use `const` variables and constructors extensively to reduce widget rebuilds. |
| **List Performance** | Always use `ListView.builder` or `SliverList` for long/lazy-loaded lists. |
| **Isolates** | Use `compute()` for expensive calculations (e.g., JSON parsing) to avoid blocking the UI. |
| **Build Method** | Keep `build()` pure and fast. Move complex logic or network calls out of `build()`. |

#### Best Practices
| Rule | Description |
|------|-------------|
| **Composition** | Favor composition over inheritance. Build complex UIs from smaller, private `Widget` classes (not helper methods). |
| **Immutability** | Widgets (especially `StatelessWidget`) should be immutable. |
| **State Management** | Separate ephemeral state (UI) from app state (Business Logic). Use `Bloc`/`Cubit` for app state as per project standard. |
| **Testing** | Prefer `package:checks` for expressive assertions if applicable. Write code with testing in mind. |

---

### 7. Functions & Logic (The Power of Small)

| Rule | Requirement |
|------|-------------|
| **Small & Single Responsibility (SRP)** | Max **20 lines** per function. If it has "And", split it |
| **Monadic/Dyadic Arguments** | Max **2 arguments**. If 3+, wrap into a Data Class/Entity |
| **Command Query Separation (CQS)** | A function should either perform an action (Command) OR return data (Query), **never both** |

---

### 8. Architecture & Layers (Isolation)

| Rule | Description |
|------|-------------|
| **Law of Demeter** | Modules should not know the inner details of objects they manipulate |
| **Layer Purity (Domain)** | Strictly **NO imports** from `package:flutter/material.dart` or external SDKs |
| **Layer Purity (Data)** | Must map DTOs (JSON) to Domain Entities before returning to Repository |
| **Tell, Don't Ask** | Don't pull data out to process it. Tell the object to perform its own logic |

**Examples:**
```dart
// ❌ BAD - Violates Law of Demeter
user.wallet.balance.currency.symbol

// ✅ GOOD
user.getCurrencySymbol()
```

---

### 9. BLoC & State Management

| Rule | Description |
|------|-------------|
| **Strict Immutability** | All states must be `final`. Use `@freezed` or `Equatable`. Never mutate; always `copyWith` |
| **Functional Error Handling** | Use `Either<Failure, Success>` for UseCases. Force the caller to handle failures |
| **Side Effect Isolation** | Use `BlocListener` for navigation/dialogs. Keep `BlocBuilder` pure for UI rendering |

---

### 10. Error Handling & Null Safety

| Rule | Description |
|------|-------------|
| **Don't Return/Pass Null** | Return empty collections `[]` or Null Objects instead of `null` |
| **Contextual Exceptions** | Throw domain-specific exceptions (e.g., `InsufficientFundsException`) over generic errors |
| **Type Safety on Dynamic Data** | Always verify type before casting from `Map<String, dynamic>` or JSON data |

**Examples:**
```dart
// ❌ BAD - No type check, can throw runtime error
if (data.containsKey('message')) {
  message = data['message']; // Fails if value is int, null, etc.
}

// ✅ GOOD - Type-safe access
if (data['message'] is String) {
  message = data['message'] as String;
}
```

---

### 11. Security: OWASP Mobile Top 10 (2024)

> [!CAUTION]
> **CRITICAL**: These are non-negotiable security requirements based on [OWASP Mobile Top 10](https://owasp.org/www-project-mobile-top-10/).

| Risk | Description | Verification |
|------|-------------|--------------|
| **M1: Improper Credential Usage** | Hardcoded secrets, API keys in code | No secrets in source code; use env vars or secure storage |
| **M2: Supply Chain Security** | Vulnerable dependencies | Run `flutter pub outdated`; audit third-party packages |
| **M3: Insecure Auth/AuthZ** | Weak authentication flows | Use proper token management; validate on server-side |
| **M4: Input/Output Validation** | Injection, XSS, path traversal | Sanitize all user inputs; validate before processing |
| **M5: Insecure Communication** | HTTP, no cert pinning | HTTPS only; implement certificate pinning |
| **M6: Inadequate Privacy** | Excessive data collection, PII exposure | No logging of PII, card numbers, wallet addresses |
| **M7: Binary Protection** | Reverse engineering, tampering | Enable code obfuscation (`--obfuscate`) |
| **M8: Security Misconfiguration** | Debug mode in production, insecure defaults | Disable debug flags; review AndroidManifest/Info.plist |
| **M9: Insecure Data Storage** | Plaintext sensitive data | Use `flutter_secure_storage` for all secrets/tokens |
| **M10: Insufficient Cryptography** | Weak algorithms, hardcoded keys | Use platform crypto; never hardcode encryption keys |

**Flutter-Specific Checks:**
```dart
// ❌ BAD - Hardcoded API key (M1)
const apiKey = 'sk_live_abc123...';

// ✅ GOOD - From secure storage
final apiKey = await secureStorage.read(key: 'api_key');
```

---

### 12. Unit Test Standards (F.I.R.S.T)

| Principle | Description |
|-----------|-------------|
| **Fast** | Tests must run quickly |
| **Independent** | Tests should not depend on each other |
| **Repeatable** | Must pass in any environment (Local/CI) |
| **Self-Validating** | Clear Boolean output (Pass/Fail) |
| **Timely** | Write tests alongside or before code (TDD mindset) |

---

### 13. Code Quality

| Aspect | Verification |
|--------|--------------|
| **Freezed Models** | All entities and models use `@freezed` with proper `@JsonKey` annotations |
| **Import Convention** | Always use **full package paths** (e.g., `import 'package:bloc_digital_wallet/...'`) instead of relative imports |
| **Boilerplate** | Identify code that could be generated using Mason Bricks (`mvi_feature`, `mvi_subfeature`) |
| **Testing Coverage** | New logic is accompanied by Unit Tests for UseCases/BLoCs |

---

## HOW TO USE

### Option 1: Using Commit ID

```markdown
Use the @pr-review skill to review commit: abc123def
```

The agent will run `git show <COMMIT_ID>` to fetch the diff and review it.

---

### Option 2: Using PR Diff (Pasted)

```markdown
Use the @pr-review skill to review this PR:

<PASTE PR DIFF HERE>
```

Paste the diff content directly into your request.

---

### Option 3: Using GitHub CLI

```bash
# Fetch PR diff and copy to clipboard
gh pr diff <PR_NUMBER> | pbcopy

# Then paste into your request with the skill trigger
```

---

### Option 4: Using Git Commands

```bash
# Review a specific commit
git show <COMMIT_ID>

# Review changes between commits
git diff <BASE_COMMIT> <HEAD_COMMIT>

# Review changes between branches
git diff main..feature-branch
```

Copy the output and paste into your review request.

---

### Workflow

1. **Provide the Diff**: Use one of the options above to provide code changes.
2. **Analyze**: Agent reviews each file according to the guidelines.
3. **Report**: Agent generates the structured output format.

---

## OUTPUT FORMAT

Your response **MUST** be structured exactly as follows:

```markdown
### 📝 Summary of Changes
(A brief description of what this PR introduces)

### 🚨 Critical Issues (Architecture/Security/Logic)
- **[File Name] : [Line Number]**: [Issue Description] -> [Suggested Fix]

### 💡 Refactoring & Style (Flutter/Dart)
- [Suggestions for cleaner code, better performance, or UI optimization]

### ✅ Final Verdict
(Choose one: 🟢 LGTM / 🟡 Needs Work / 🔴 Request Changes)
```

---

## EXAMPLES

### Example Critical Issues

```markdown
### 🚨 Critical Issues (Architecture/Security/Logic)

- **wallet_bloc.dart : Line 45**: Logging wallet address value -> Remove `debugPrint('Address: $walletAddress')` or mask sensitive data

- **transfer_usecase.dart : Line 23**: UseCase imports Flutter's BuildContext -> Move context-dependent logic to Presentation layer

- **home_page.dart : Line 112**: Hardcoded color `Color(0xFF123456)` -> Use `context.appThemes.colorScheme.primary`

- **auth_repository_impl.dart : Line 67**: Token stored in SharedPreferences -> Use `FlutterSecureStorage` for sensitive credentials

- **payment_bloc.dart : Line 34**: Magic number `3` used for retry count -> Use named constant `MAX_RETRY_ATTEMPTS`

- **user_entity.dart : Line 15**: Law of Demeter violation `user.wallet.balance.amount` -> Create `user.getBalanceAmount()` method
```

### Example Refactoring Suggestions

```markdown
### 💡 Refactoring & Style (Flutter/Dart)

- Consider using `const` constructor for `TransactionCard` widget at `transaction_card.dart:15` to prevent unnecessary rebuilds

- The `TransactionEntity` could be generated via freezed. Current manual implementation at `transaction_entity.dart` increases maintenance burden

- Replace `BlocBuilder` with `BlocSelector` at `home_page.dart:78` to only rebuild when specific state property changes

- Use `context.t.homeTitle` instead of hardcoded string "Home" at `home_page.dart:45`

- Function `processPaymentAndUpdateBalance()` at `payment_usecase.dart:28` violates SRP - split into `processPayment()` and `updateBalance()`

- Event name `Load` at `home_bloc.dart:12` is too generic -> Rename to `HomeDataRequested` for clarity
```

### Example Final Verdicts

```markdown
### ✅ Final Verdict

🟢 **LGTM** - Code follows best practices, no critical issues found.

🟡 **Needs Work** - Minor issues found that should be addressed before merging.

🔴 **Request Changes** - Critical security/architecture violations must be fixed.
```
