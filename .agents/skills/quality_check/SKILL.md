---
name: Quality Check
description: Runs ./gradlew check to identify code quality issues (ktlint, detekt, Spotless, tests) and automatically fixes all problems found.
---

# Quality Check Skill

> [!IMPORTANT]
> **Resource Cleanup**: After completing quality checks, **ALWAYS** run `cleanup-java` (alias for `pkill -9 java`) as the **FINAL STEP** to stop all background Java/Gradle daemon threads and release system resources.

> [!IMPORTANT]
> **Role**: You are a Senior Android Developer responsible for maintaining code quality standards.
> Your task is to run quality checks and fix all identified issues.

## Technology Stack

| Tool          | Purpose                                      |
|---------------|----------------------------------------------|
| **ktlint**    | Kotlin code style enforcement                |
| **detekt**    | Static code analysis                         |
| **Spotless**  | Code formatting                              |
| **Unit Tests**| JUnit 4, MockK, Robolectric                  |

---

## Workflow

> [!TIP]
> The `./gradlew check` task is configured in `quality.gradle.kts` to automatically run:
> 1. `spotlessApply` - Auto-fixes formatting issues
> 2. `spotlessCheck` - Verifies formatting
> 3. `detekt` - Static code analysis

### Step 1: Run Gradle Check

```bash
./gradlew check
```

This single command will:
- ✅ **Auto-fix** Spotless formatting issues (no manual step needed)
- ✅ Run detekt for code smells
- ✅ Run unit tests

### Step 2: Analyze Output

If the check fails, parse the output and categorize issues by type:

| Issue Type       | Tool       | Action Required                             |
|------------------|------------|---------------------------------------------|
| **Formatting**   | Spotless   | ✅ Auto-fixed by `./gradlew check`          |
| **Code Smells**  | detekt     | Manual fix based on rule violations         |
| **Test Failures**| JUnit      | Debug and fix failing tests                 |
| **Compilation**  | Kotlin     | Fix syntax/type errors                      |

### Step 3: Manual Fixes

For issues that cannot be auto-fixed:

1. **Detekt Violations**: Follow the rule description to refactor code
2. **Compilation Errors**: Fix type mismatches, missing imports, etc.
3. **Test Failures**: Debug tests, mock missing dependencies

After fixing, re-run:
```bash
./gradlew check
```

### Step 4: Build Verification

> [!IMPORTANT]
> Build the project to ensure all changes compile and work correctly.

```bash
./gradlew assembleDebug
```

This verifies:
- ✅ All code compiles successfully
- ✅ Resources are processed correctly
- ✅ Hilt/KSP code generation works
- ✅ No runtime configuration issues

### Step 5: Resource Cleanup (MANDATORY - FINAL STEP)

> [!CAUTION]
> **ALWAYS** run this as the **FINAL STEP** to stop all background Java/Gradle daemon threads and release system resources for your PC.

```bash
# Stop all Java/Gradle daemon processes
cleanup-java
# Or directly: pkill -9 java
```

---

## Common Detekt Rules & Fixes

| Rule | Description | Fix Strategy |
|------|-------------|--------------|
| `LongMethod` | Method exceeds line limit | Extract to smaller functions |
| `ComplexCondition` | Complex boolean expressions | Extract to named variables |
| `MagicNumber` | Hardcoded numbers | Extract to named constants |
| `TooManyFunctions` | Class has too many functions | Split into multiple classes |
| `UnusedPrivateMember` | Unused private field/function | Remove or use |
| `MaxLineLength` | Line exceeds character limit | Break line or refactor |
| `FunctionNaming` | Composable naming violation | Use PascalCase for Composables |

---

## Input

No explicit input required. The skill operates on the current project state.

---

## Output Format

Your response **MUST** be structured as follows:

```markdown
### 🔧 Gradle Check Results

**Status**: ✅ PASSED / ❌ FAILED

### 📊 Issues Found

| Type | Count | Module | Status |
|------|-------|--------|--------|
| ktlint | X | :module | Fixed/Pending |
| detekt | X | :module | Fixed/Pending |
| Spotless | X | :module | Fixed/Pending |
| Tests | X | :module | Fixed/Pending |

### 🛠️ Fixes Applied

1. **[File:Line]**: [Description of fix]

### ⚠️ Manual Intervention Required

- **[File:Line]**: [Issue description] → [Suggested fix]

### ✅ Final Status

(Choose one: 🟢 All Checks Passing / 🟡 Partial Fix / 🔴 Needs Manual Fix)
```

---

## Example Usage

```markdown
Use the @quality_check skill to fix all code quality issues.
```

Or step-by-step:
```markdown
1. Run @quality_check
2. Fix all detekt violations in :features:home module
```

---

## Important Notes

> [!WARNING]
> **Memory Management**: Gradle daemons can consume significant memory. Always run `cleanup-java` after extended development sessions or before major check runs.

> [!TIP]
> **Quick Format**: Use `./gradlew spotlessApply` for fast formatting fixes before running full check.

> [!NOTE]
> **CI Alignment**: This skill mirrors CI pipeline checks. Passing locally ensures PR checks will pass.
