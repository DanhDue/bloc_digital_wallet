# Double Check Guide

**Mandatory Verification Steps for Every Task**

---

## 🎯 Purpose

This document explains the **critical double-check process** that must be performed after completing any coding task in this project. These steps ensure code quality, prevent errors, and maintain architecture compliance.

---

## ⚠️ When to Use This

**Run these steps after:**
- ✅ Creating a new feature
- ✅ Adding new code
- ✅ Modifying existing code
- ✅ Fixing bugs
- ✅ Refactoring
- ✅ Adding tests
- ✅ Updating dependencies
- ✅ **ANY code changes whatsoever**

**Before:**
- ⚠️ Reporting completion to user
- ⚠️ Committing code
- ⚠️ Creating pull request
- ⚠️ Marking task as done

---

## 📋 The Double Check Process

### Step 1: Format Code

```bash
flutter format .
```

**What it does:**
- Formats all Dart code according to Dart style guide
- Fixes indentation, spacing, line length
- Ensures consistent code style

**Expected output:**
```
Formatted 15 files (3 changed) in 0.5 seconds.
```

**Success:** All files formatted, no errors

---

### Step 2: Run Analyzer (MOST CRITICAL)

```bash
flutter analyze --no-fatal-infos
```

**What it does:**
- Analyzes all Dart code for errors, warnings, and issues
- Checks for syntax errors
- Checks for type errors
- Checks for unused code
- Checks for missing annotations
- Validates imports

**Expected output:**
```
Analyzing bloc_digital_wallet...
No issues found! (ran in 1.5s)
```

**Success Criteria:**
- ✅ Output shows: **"No issues found!"**
- ✅ Exit code: **0**
- ✅ No errors listed
- ✅ No warnings listed
- ✅ No info messages listed

**⚠️ STOP if you see ANY issues!** Must fix before proceeding.

---

### Step 3: Fix Any Issues Found

**If Step 2 shows issues:**

**Example Error:**
```
Analyzing bloc_digital_wallet...

   error • lib/features/wallet/data/models/wallet_model.dart:15:7 • Missing type annotation • strict_top_level_inference
   info • lib/core/utils/helpers.dart:23:5 • Unused import • unused_import

2 issues found.
```

**Fix Process:**

1. **Read the error message:**
   - File: `lib/features/wallet/data/models/wallet_model.dart`
   - Line: 15, Column: 7
   - Issue: "Missing type annotation"
   - Rule: `strict_top_level_inference`

2. **Open the file** and go to the line

3. **Fix the issue:**
   ```dart
   // Before (Line 15)
   static get walletName => 'My Wallet';
   
   // After (Fixed)
   static String get walletName => 'My Wallet';
   ```

4. **Run analyzer again:**
   ```bash
   flutter analyze --no-fatal-infos
   ```

5. **Repeat until "No issues found!"**

---

### Step 4: Run Tests (If Applicable)

```bash
flutter test
```

**What it does:**
- Runs all unit tests
- Runs all widget tests
- Verifies code functionality

**Expected output:**
```
00:03 +15: All tests passed!
```

**Success:** All tests passing

**If tests fail:**
1. Read error message
2. Fix the issue
3. Run tests again
4. Repeat until all pass

---

### Step 5: Run Code Generation (If Needed)

**Run if you modified:**
- Models with `@freezed`
- Models with `@JsonSerializable`
- Classes with `@injectable` or `@LazySingleton`

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

**What it does:**
- Generates `.freezed.dart` files
- Generates `.g.dart` files
- Updates `injection.config.dart`

**After generation:**
- Go back to Step 2 and run analyzer again

---

## 🎯 Success Checklist

Before reporting completion, verify:

```
✅ Step 1: flutter format . completed
✅ Step 2: flutter analyze shows "No issues found!"
✅ Step 3: All issues fixed (if any were found)
✅ Step 4: Tests pass (if applicable)
✅ Step 5: Code generation done (if needed)
✅ Step 6: All files saved
✅ Exit code: 0
```

---

## 🚨 Common Issues & Quick Fixes

### Issue: Missing Type Annotation

**Error:**
```
error • Missing type annotation • strict_top_level_inference
```

**Fix:**
```dart
// ❌ Before
static get myValue => 'hello';

// ✅ After
static String get myValue => 'hello';
```

---

### Issue: Unused Import

**Error:**
```
info • Unused import • unused_import
```

**Fix:**
```dart
// ❌ Before
import 'package:flutter/material.dart'; // Not used

// ✅ After
// Remove the import
```

---

### Issue: Angle Brackets in Doc Comment

**Error:**
```
info • Angle brackets will be interpreted as HTML • unintended_html_in_doc_comment
```

**Fix:**
```dart
// ❌ Before
/// Similar to Android's Channel<Event>

// ✅ After
/// Similar to Android's Channel of Event
```

---

### Issue: Missing @override

**Error:**
```
warning • Missing @override annotation • annotate_overrides
```

**Fix:**
```dart
// ❌ Before
Widget build(BuildContext context) { ... }

// ✅ After
@override
Widget build(BuildContext context) { ... }
```

---

### Issue: Undefined Name

**Error:**
```
error • Undefined name 'MyClass' • undefined_identifier
```

**Fix:**
```dart
// ❌ Before
final result = MyClass();

// ✅ After
import 'package:my_package/my_class.dart';
final result = MyClass();
```

---

## 💡 Pro Tips

### For AI Agents

1. **Always run `flutter analyze --no-fatal-infos`** - This is the most important step
2. **Never skip this step** - Even if you think the code is perfect
3. **Fix all issues** - Don't report completion with any errors
4. **Re-analyze after fixing** - One fix might reveal another issue
5. **Include verification in report** - Tell user you ran analyzer

### For Human Developers

1. **Run before every commit** - Catches issues early
2. **Set up pre-commit hook** - Automate the check
3. **Use IDE linter** - See issues in real-time
4. **Run full check before PR** - Ensure clean code

---

## 📝 Example Reports

### ✅ Good Report (No Issues)

```
✅ Task completed: Created wallet feature

Changes:
- Created domain layer (entity, repository, use case)
- Implemented data layer (model, data source, repository impl)
- Built presentation layer (action, state, event, BLoC, page)

Verification:
✅ flutter format . - All files formatted
✅ flutter analyze - No issues found!
✅ flutter test - All 12 tests passing
✅ Architecture compliance verified

Files created: 15 files
```

### ✅ Good Report (Issues Fixed)

```
✅ Task completed: Created wallet feature

Changes:
- Created domain layer (entity, repository, use case)
- Implemented data layer (model, data source, repository impl)
- Built presentation layer (action, state, event, BLoC, page)

Issues Fixed:
- Fixed 3 missing type annotations in use cases
- Removed 1 unused import from model
- Fixed doc comment formatting in BLoC

Verification:
✅ flutter format . - All files formatted
✅ flutter analyze - No issues found! (after fixes)
✅ flutter test - All 12 tests passing
✅ Architecture compliance verified

Files created: 15 files
```

### ❌ Bad Report (Issues Not Fixed)

```
❌ Task completed: Created wallet feature

Changes:
- Created feature files

Verification:
- Code formatted
- Tests not run
- Analyzer not run

⚠️ PROBLEM: No verification of code quality!
```

---

## 🎓 Why This Matters

### Code Quality
- ✅ Prevents bugs from entering codebase
- ✅ Ensures consistent code style
- ✅ Maintains type safety

### Team Efficiency
- ✅ Reduces code review time
- ✅ Prevents CI/CD failures
- ✅ Avoids merge conflicts

### Architecture Compliance
- ✅ Ensures rules are followed
- ✅ Maintains clean architecture
- ✅ Keeps codebase healthy

### AI Agent Performance
- ✅ Produces production-ready code
- ✅ Reduces back-and-forth with users
- ✅ Builds trust and confidence

---

## 🔧 Automation Options

### Pre-commit Hook

Create `.git/hooks/pre-commit`:

```bash
#!/bin/bash

echo "🔍 Running pre-commit checks..."

# Format
echo "✨ Formatting code..."
flutter format .

# Analyze
echo "🔍 Analyzing code..."
flutter analyze --no-fatal-infos

if [ $? -ne 0 ]; then
  echo "❌ Analyzer found issues. Fix them before committing."
  exit 1
fi

# Tests
echo "🧪 Running tests..."
flutter test

if [ $? -ne 0 ]; then
  echo "❌ Tests failed. Fix them before committing."
  exit 1
fi

echo "✅ All checks passed!"
exit 0
```

### Melos Script

Add to `melos.yaml`:

```yaml
scripts:
  double-check:
    run: |
      echo "🔍 Running double check..."
      flutter format .
      flutter analyze --no-fatal-infos
      flutter test
    description: Run all verification checks
```

Then run:
```bash
melos double-check
```

---

## 📚 Related Documentation

- [AI_AGENT_CHECKLIST.md](AI_AGENT_CHECKLIST.md) - Checklist for AI Agents
- [AI_AGENT_WORKFLOWS.md](AI_AGENT_WORKFLOWS.md) - Step-by-step workflows
- [IMPLEMENTATION_GUIDE.md](IMPLEMENTATION_GUIDE.md) - Complete tutorial

---

## 🎯 Remember

1. **Format** → `flutter format .`
2. **Analyze** → `flutter analyze --no-fatal-infos`
3. **Fix** → Until "No issues found!"
4. **Test** → `flutter test`
5. **Report** → Include verification results

**Zero tolerance for analyzer errors!**

---

**Last Updated**: 2026-01-11  
**Maintained By**: DanhDue ExOICTIF

---

**This is a MANDATORY step. No exceptions! 🚀**
