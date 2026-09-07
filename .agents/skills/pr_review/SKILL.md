---
name: PR Review
description: Performs comprehensive Pull Request reviews for this project, focusing on Clean Architecture, Jetpack Compose, Security, and Fintech standards.
---

# PR Review Skill

> [!IMPORTANT]
> **Prerequisite**: Before reviewing any PR, use the `@quality_check` skill to run local quality tools.
> This ensures code passes ktlint, detekt, and Spotless before manual review begins.

> [!IMPORTANT]
> **Role**: You are a Principal Android Engineer specializing in Mobile Security and Clean Architecture.
> Your task is to review Pull Requests for this project.

> [!TIP]
> **Pro Tip**: Update/Load all principles immediately during triggering the local `@quality_check` skill to ensure you have the latest context. While wait for `@quality_check` skill processing.

> [!NOTE]
>Above tip ensures that AI Agents can run `@quality_check` skill and update/load all principles concurrently.
> 1. Trigger `@quality_check` to run `./gradlew check` in the background.
> 2. Load Principles while waiting(`@quality_check` skill processing).

## ROLE

You are a Principal Android Engineer specializing in Mobile Security and Clean Architecture.
Your task is to review the Pull Request for this project.

## TECHNOLOGY STACK

- **Language**: Kotlin (Strictly following Effective Kotlin guidelines)
- **UI**: Jetpack Compose (Material3)
- **Architecture**: Clean Architecture (Data, Domain, Presentation) + Feature First
- **State Management**: MVI (StateFlow, SharedFlow)
- **Code Generation**: Hilt, KSP, Retrofit
- **Quality Tools**: ktlint, detekt, Spotless

## GUIDING PRINCIPLES

- [**Effective Kotlin**](https://github.com/VitekKlugi/Effective-Kotlin-Examples)
- [**Code Smells**](https://refactoring.guru/refactoring/smells)
- [**OWASP Mobile Top 10**](https://owasp.org/www-project-mobile-top-10/)
- [**Clean Code**](https://www.oreilly.com/library/view/clean-code-a/9780132350884/)
- [**SOLID Principles**](https://en.wikipedia.org/wiki/SOLID)
- [**Defensive Programming**](https://en.wikipedia.org/wiki/Defensive_programming)
- [**Reactive Programming**](https://www.reactivemanifesto.org/)

---

## Review Guidelines

Evaluate the provided Diff based on the following criteria:

---

### 1. Naming Conventions (Intent & Clarity)

| Rule | Description |
|------|-------------|
| **Intention-Revealing Names** | Variable/function names must answer: Why it exists, what it does, and how it is used |
| **MVI Action Semantics** | Actions must use intent-based names (e.g., `SubmitTopUp`, `ChangePin`, `LoadBalance`) |
| **MVI State Semantics** | States must describe the current UI status (e.g., `BalanceLoading`, `PaymentSuccess`) |
| **Searchable Names** | Avoid "Magic Numbers" or "Magic Strings". Use named constants (e.g., `MAX_PIN_ATTEMPTS` instead of `3`) |
| **Kotlin Style** | **4 spaces** indentation, max **120 chars** line length, **no wildcard imports** (`import a.*`), use **trailing commas** |

**Examples:**
```kotlin
// ❌ BAD
var d: Int // days elapsed

// ✅ GOOD
var daysSinceLastTransaction: Int
```

---

### 2. Functions & Logic (The Power of Small)

| Rule | Requirement |
|------|-------------|
| **Small & Single Responsibility (SRP)** | Max **20 lines** per function. If it has "And", split it |
| **Monadic/Dyadic Arguments** | Max **2 arguments**. If 3+, wrap into a Data Class |
| **Command Query Separation (CQS)** | A function should either perform an action (Command) OR return data (Query), **never both** |

**Examples:**
```kotlin
// ❌ BAD - Does too many things
fun processPaymentAndUpdateBalance(amount: BigDecimal, userId: String, notify: Boolean) { ... }

// ✅ GOOD - Single responsibility
fun processPayment(request: PaymentRequest): PaymentResult { ... }
fun updateBalance(userId: String, amount: BigDecimal) { ... }
```

---

### 3. Architecture & Layers (Isolation)

> [!CAUTION]
> The Domain layer is the core of the application and must remain **pure**.

| Rule | Description |
|------|-------------|
| **Law of Demeter** | Modules should not know the inner details of objects they manipulate |
| **Layer Purity (Domain)** | Strictly **NO imports** from `android.*`, `androidx.*`, or external SDKs (except `@Inject`) |
| **Layer Purity (Data)** | Must map DTOs (JSON) to Domain Entities before returning to Repository |
| **Tell, Don't Ask** | Don't pull data out to process it. Tell the object to perform its own logic |

**Layer Constraints:**

| Layer | Constraints |
|-------|-------------|
| **Domain** | Zero dependencies on Android Framework, Compose, or external libraries |
| **Data** | Must contain DTOs and Mappers to convert API responses into Domain Entities |
| **Presentation** | ViewModel must only expose UI State via `StateFlow`. No direct View references |

**Examples:**
```kotlin
// ❌ BAD - Violates Law of Demeter
user.wallet.balance.currency.symbol

// ✅ GOOD
user.getCurrencySymbol()
```

#### Feature Isolation
- Each feature (e.g., `features/transfer`) must be **self-contained**
- Feature A must **NOT** depend on Feature B's internal implementation
- Use a **public API** or **Domain layer** for inter-feature communication

#### Dependency Flow
- Dependencies point inwards: `Presentation` → `Domain` ← `Data`
- Data layer should implement Domain interfaces (Repository pattern)

---

### 4. MVI & State Management

| Rule | Description |
|------|-------------|
| **Strict Immutability** | All states must use `data class` with `val` properties. Never mutate; always use `copy()` or `reduce {}` |
| **Functional Error Handling** | Use `DataState<T>` or `Result<T>` for UseCases. Force the caller to handle failures |
| **Side Effect Isolation** | Use `Event` for navigation/dialogs/toasts. Keep UI rendering pure based on `State` only |

#### ViewModel Responsibility
- Must not hold references to `View`, `Context`, or `Activity`
- Must not handle low-level business logic (delegate to UseCases)
- Must inherit from `MviViewModel<State, Action, Event>`

#### State Management Pattern
```kotlin
// ✅ CORRECT - Immutable state with thread-safe updates
data class TransferState(
    val isLoading: Boolean = false,
    val balance: BigDecimal = BigDecimal.ZERO,
    val error: UiText? = null
)

// Update using reduce {} or update {}
reduce { state -> state.copy(isLoading = true) }
```

#### Dispatcher Discipline

| Dispatcher | Use Case |
|------------|----------|
| `Dispatchers.IO` | Networking, Database, File I/O |
| `Dispatchers.Default` | Heavy computation, sorting, parsing |
| `Dispatchers.Main` | UI updates only |

> [!WARNING]
> **Never block the Main thread** with `runBlocking` or synchronous network calls.

---

### 5. Error Handling & Null Safety

| Rule | Description |
|------|-------------|
| **Don't Return/Pass Null** | Return empty collections `emptyList()` or sealed classes instead of `null` |
| **Contextual Exceptions** | Throw domain-specific exceptions (e.g., `InsufficientFundsException`) over generic errors |
| **No Force Unwrap** | Avoid `!!` operator. Use `requireNotNull()`, `checkNotNull()`, or safe calls with meaningful fallbacks |

**Examples:**
```kotlin
// ❌ BAD - Force unwrap
val user = getUser()!!

// ✅ GOOD - Safe handling
val user = getUser() ?: return DataState.Error(UserNotFoundError)

// ✅ GOOD - Explicit requirement
val user = requireNotNull(getUser()) { "User must be logged in" }
```

---

### 6. Security & OWASP Mobile Top 10 (2024)

> [!CAUTION]
> **CRITICAL**: These are non-negotiable security requirements for a Digital Wallet application.
> Security violations are **blocking issues**.
> Reference: [OWASP Mobile Top 10 2024](https://owasp.org/www-project-mobile-top-10/)

---

#### M1: Improper Credential Usage

| Check | Verification |
|-------|-------------|
| **No Hardcoded Credentials** | Scan for API keys, secrets, passwords in source code or config files |
| **Secure Credential Storage** | Use `SecureCacheStore`, `EncryptedSharedPreferences`, or Android Keystore |
| **Revocable Tokens** | Use short-lived, device-specific access tokens that can be revoked |
| **No Password Storage** | Never store passwords locally; use secure tokens instead |

**Patterns to Flag:**
```kotlin
// ❌ CRITICAL - Hardcoded credentials
private const val API_KEY = "sk_live_abc123..."

// ❌ CRITICAL - Insecure storage
sharedPreferences.putString("access_token", token)

// ✅ CORRECT - Secure storage
secureCacheStore.write(KEY_ACCESS_TOKEN, token)
```

---

#### M2: Inadequate Supply Chain Security

| Check | Verification |
|-------|-------------|
| **Dependency Audit** | All third-party libraries are vetted and from trusted sources |
| **Version Pinning** | Use exact versions, not `+` or `latest` in dependencies |
| **Vulnerability Scanning** | Regular dependency vulnerability scans (Dependabot, Snyk) |

---

#### M3: Insecure Authentication/Authorization

| Check | Verification |
|-------|-------------|
| **Server-Side Auth** | All authentication requests validated on backend |
| **No Client-Side Auth Bypass** | Avoid local-only authentication that can be bypassed |
| **IDOR Prevention** | No user roles/permissions sent from mobile device |
| **Strong Session Management** | Secure, randomly generated session tokens with proper timeouts |

**Patterns to Flag:**
```kotlin
// ❌ BAD - Client-side only authorization
if (currentUser.role == "admin") { showAdminPanel() }

// ✅ CORRECT - Backend validates permissions
apiService.getAdminData(accessToken) // Backend checks token's roles
```

---

#### M4: Insufficient Input/Output Validation

| Check | Verification |
|-------|-------------|
| **Input Validation** | All user inputs validated before processing |
| **Output Encoding** | Data properly encoded before display (prevent injection) |
| **Deeplink Validation** | All deeplink parameters validated and sanitized |

---

#### M5: Insecure Communication

| Check | Verification |
|-------|-------------|
| **HTTPS Only** | No HTTP connections; all traffic over TLS 1.2+ |
| **Certificate Pinning** | Implement certificate or public key pinning |
| **No SSL Bypass** | No `TrustAllCerts`, `AllowAllHostnameVerifier`, or disabled SSL checks |

**Patterns to Flag:**
```kotlin
// ❌ CRITICAL - SSL bypass
SSLSocketFactory.ALLOW_ALL_HOSTNAME_VERIFIER
.hostnameVerifier { _, _ -> true }

// ✅ CORRECT - Certificate pinning
CertificatePinner.Builder()
    .add("api.example.com", "sha256/AAAAAAA...")
    .build()
```

---

#### M6: Inadequate Privacy Controls

| Check | Verification |
|-------|-------------|
| **No PII Logging** | ABSOLUTELY NO logging of PII, Card Numbers, PINs, OTPs |
| **Data Minimization** | Collect only necessary data |
| **Screenshot Prevention** | Use `FLAG_SECURE` on sensitive screens |

---

#### M7: Insufficient Binary Protections

| Check | Verification |
|-------|-------------|
| **ProGuard/R8** | Code obfuscation enabled for release builds |
| **Root Detection** | Detect jailbroken/rooted devices for sensitive operations |
| **Debug Detection** | Disable debug features in production |

---

#### M8: Security Misconfiguration

| Check | Verification |
|-------|-------------|
| **Debug Disabled** | `android:debuggable="false"` in release |
| **Backup Disabled** | `android:allowBackup="false"` or encrypted backups |
| **Export Controls** | Activities/Services not exported unless necessary |

---

#### M9: Insecure Data Storage

| Check | Verification |
|-------|-------------|
| **Encrypted Storage** | Use `EncryptedSharedPreferences`, `SecureCacheStore`, or Room with SQLCipher |
| **No External Storage** | Never store sensitive data on external/shared storage |
| **Keystore Usage** | Cryptographic keys stored in Android Keystore |

**Patterns to Flag:**
```kotlin
// ❌ CRITICAL - Plain SharedPreferences for secrets
sharedPrefs.edit().putString("refresh_token", token).apply()

// ✅ CORRECT - Encrypted storage
secureCacheStore.write(KEY_REFRESH_TOKEN, token)
```

---

#### M10: Insufficient Cryptography

| Check | Verification |
|-------|-------------|
| **Strong Algorithms** | Use AES-256-GCM, SHA-256+; No MD5, SHA1, DES |
| **Secure Key Management** | Keys in Android Keystore, not hardcoded |
| **No Custom Crypto** | Use established libraries (Tink, AndroidX Security) |

**Patterns to Flag:**
```kotlin
// ❌ BAD - Weak cryptography
MessageDigest.getInstance("MD5")
val key = "hardcoded_secret_key".toByteArray()

// ✅ CORRECT
MessageDigest.getInstance("SHA-256")
val key = keyStore.getKey("alias", null)
```

---

#### Financial Precision

> [!WARNING]
> **Never use `Double` or `Float` for money calculations.**

| Correct | Incorrect |
|---------|-----------|
| `BigDecimal` | `Double` |
| `Long` (in cents) | `Float` |

---

### 7. Unit Test Standards (F.I.R.S.T)

| Principle | Description |
|-----------|-------------|
| **Fast** | Tests must run quickly (< 100ms per test) |
| **Independent** | Tests should not depend on each other |
| **Repeatable** | Must pass in any environment (Local/CI) |
| **Self-Validating** | Clear Boolean output (Pass/Fail) |
| **Timely** | Write tests alongside or before code (TDD mindset) |

**Testing Requirements:**
- New logic must be accompanied by Unit Tests
- Test coverage expected for UseCases and ViewModels
- Use MockK for mocking, JUnit 4 for assertions, Turbine for Flow testing

---

### 8. Jetpack Compose & Code Quality

#### Stateless Composables
- Use **State Hoisting** pattern
- Composables should receive data and emit events (lambdas)
- Pattern: `Screen(state: State, onAction: (Action) -> Unit)`

#### Stability & Recomposition
- Avoid passing **unstable types** to Composables
- Use `@Stable` or `@Immutable` annotations where necessary
- Check for:
  - Unstable parameters causing unnecessary recompositions
  - Proper usage of `remember`, `derivedStateOf`, `rememberUpdatedState`
  - `LaunchedEffect` with correct keys

#### Theming
- Strict usage of Material3 Design System
- No hardcoded colors (`0xFFRRGGBB`) or dimensions
- Use `MaterialTheme.colorScheme` and `MaterialTheme.typography`

#### Code Quality Checklist

| Aspect | Verification |
|--------|--------------|
| **Immutable Models** | All entities use `data class` with `val` properties, or use `@Immutable` annotation |
| **Import Convention** | Use **full package paths** for cross-module imports |
| **Boilerplate** | Identify code that could be generated using Mason Bricks (`mvi_feature`, `mvi_subfeature`) |
| **Testing Coverage** | New logic is accompanied by Unit Tests for UseCases/ViewModels |
| **Naming Conventions** | Contract: `[Feature]State`, `[Feature]Action`, `[Feature]Event`. ViewModel: `[Feature]ViewModel`. UseCase: `[Action][Feature]UseCase`. DTOs: `*Dto` suffix |

---

### 9. Android Kotlin-First Standards
(Reference: [Android Kotlin-First Guide](https://developer.android.com/kotlin/first))

#### 9.1 Expressive and Concise
(Reference: [Docs](https://developer.android.com/kotlin/first#expressive))
Kotlin reduces boilerplate. Ensure code utilizes modern language features effectively.
| Check | Requirement |
|-------|-------------|
| **Data Classes** | Use `data class` for model objects to get `equals`, `hashCode`, `toString` for free. |
| **Extension Functions** | Use extension functions to extend existing classes without inheriting (e.g., `View.visible()`). |
| **String Templates** | Use `$var` or `${expression}` instead of `String.format` or concatenation. |
| **SAM Conversions** | Use lambda syntax for single-abstract-method interfaces (e.g., `OnClickListener { ... }`). |
| **Default Arguments** | Use default parameter values to avoid method overloading boilerplate. |

```kotlin
// ❌ BAD (Java style)
val str = String.format("Hello %s", name)

// ✅ CORRECT (Expressive)
val str = "Hello $name"
```

#### 9.2 Safer Code
(Reference: [Docs](https://developer.android.com/kotlin/first#safer-code))
Kotlin's type system is designed to eliminate `NullPointerException` and common errors.
| Check | Requirement |
|-------|-------------|
| **Null Safety** | Define variables as non-nullable (`String`) whenever possible. Use `String?` only when necessary. |
| **Safe Calls** | Use `?.` for safe access and `?:` (Elvis operator) for fallback values. |
| **No Force Unwrap** | **Strictly Ban** the use of `!!`. Use `requireNotNull` or standard scoping functions (`let`, `run`) if needed. |
| **Immutability** | Prefer `val` (read-only) over `var` (mutable). |

```kotlin
// ❌ BAD
val len = text!!.length

// ✅ CORRECT
val len = text?.length ?: 0
```

#### 9.3 Interoperable
(Reference: [Docs](https://developer.android.com/kotlin/first#interoperable))
Code should be interoperable with Java where necessary, but idiomatic Kotlin is prioritized.
| Check | Requirement |
|-------|-------------|
| **Jvm Overloads** | Use `@JvmOverloads` for functions with default arguments called from Java. |
| **Object/Static** | Use `companion object` for static members. Use `@JvmStatic` if exposing to Java. |

#### 9.4 Structured Concurrency (Coroutines)
(Reference: [Docs](https://developer.android.com/kotlin/first#structured-concurrency))
Use Kotlin Coroutines for asynchronous programming, simpler and cleaner than RxJava or AsyncTasks.

| Check | Best Practice |
|-------|---------------|
| **Dispatcher Injection** | ALWAYS inject Dispatchers (e.g., `CoroutineDispatcher`) into ViewModels/Repositories. **NEVER** hardcode `Dispatchers.IO`. |
| **Scopes** | Use `viewModelScope` or `lifecycleScope`. **NEVER** use `GlobalScope`. |
| **Suspend Functions** | Use `suspend` for one-shot operations. Do NOT return `Flow` from a `suspend` function. |
| **Flow vs LiveData** | Prefer `StateFlow` and `SharedFlow` over `LiveData` for architectural layers. |

```kotlin
// ❌ BAD - Unstructured & Hardcoded
GlobalScope.launch { ... }

// ✅ CORRECT - Structured & Injected
class MyViewModel(private val ioDispatcher: CoroutineDispatcher) : ViewModel() {
    fun load() {
        viewModelScope.launch(ioDispatcher) { ... }
    }
}
```

---

## Input

The skill accepts **two input methods**:

| Input Type     | Description                                                    | Command to Fetch                        |
|----------------|----------------------------------------------------------------|-----------------------------------------|
| **COMMIT_ID**  | A specific commit hash to review changes from                  | `git show <COMMIT_ID>` or `git diff <COMMIT_ID>~1 <COMMIT_ID>` |
| **PR_DIFF**    | The Pull Request diff (from GitHub or pasted directly)         | `gh pr diff <PR_NUMBER>`                |

> [!TIP]
> You can provide either one. If a commit ID is provided, the diff will be fetched automatically using `git show`.

---

## Output Format

Your response **MUST** be structured as follows:

```markdown
### 📝 Summary of Changes
(A brief description of what this PR introduces)

### 🚨 Critical Issues (Architecture/Security/Logic)
- **[File Name]:[Line Number]**: [Issue Description] → [Suggested Fix]

### 💡 Refactoring & Style (Compose/Kotlin)
- [Suggestions for cleaner code, better performance, or UI optimization]

### ⚠️ OWASP Mobile Top 10 Security Review
| Risk | Status | Notes |
|------|--------|-------|
| M1: Improper Credential Usage | ✅/❌ | |
| M2: Inadequate Supply Chain | ✅/❌ | |
| M3: Insecure Auth/Authorization | ✅/❌ | |
| M4: Input/Output Validation | ✅/❌ | |
| M5: Insecure Communication | ✅/❌ | |
| M6: Privacy Controls | ✅/❌ | |
| M7: Binary Protections | ✅/❌ | |
| M8: Security Misconfiguration | ✅/❌ | |
| M9: Insecure Data Storage | ✅/❌ | |
| M10: Insufficient Cryptography | ✅/❌ | |

### ✅ Final Verdict
(Choose one: 🟢 LGTM / 🟡 Needs Work / 🔴 Request Changes)
```

---

## Example Usage

### Option 1: Using Commit ID
```markdown
Use the @pr_review skill to review commit: abc123def
```

### Option 2: Using PR Diff (Pasted)
```markdown
Use the @pr_review skill to review this PR:

<PASTE PR DIFF HERE>
```

### Option 3: Using GitHub CLI
```bash
# Fetch PR diff and copy to clipboard
gh pr diff <PR_NUMBER> | pbcopy

# Then paste into your request
```

### Option 4: Using Git Commands
```bash
# Review a specific commit
git show <COMMIT_ID>

# Review changes between commits
git diff <BASE_COMMIT> <HEAD_COMMIT>
```

