# Dynamic Copyright Year Implementation Summary

## 🎯 Overview

Updated the `mvi_feature` Mason brick to dynamically set the copyright year based on the current year, replacing the hardcoded "2026" value.

## 📝 Changes Made

### 1. **Added `year` Variable to Brick Configuration**

**File**: `bricks/mvi_feature/brick.yaml`

```yaml
vars:
  feature_name:
    type: string
    description: The name of the feature (e.g., authentication, wallet, profile)
    prompt: What is the feature name?
  year:
    type: number
    description: Copyright year (auto-set to current year by pre_gen hook)
    prompt: Copyright year?
```

### 2. **Created Pre-Generation Hook**

**File**: `bricks/mvi_feature/hooks/pre_gen.dart`

```dart
import 'package:mason/mason.dart';

Future<void> run(HookContext context) async {
  // Automatically set the year to the current year if not provided
  if (!context.vars.containsKey('year') || context.vars['year'] == null) {
    context.vars['year'] = DateTime.now().year;
  }
}
```

**Purpose**: Automatically sets the `year` variable to `DateTime.now().year` when files are generated, unless the user explicitly provides a different year.

### 3. **Updated All Template Files**

Replaced hardcoded `2026` with dynamic `{{year}}` in all 15 template files:

#### Domain Layer (3 files)
- `{{{feature_name.snakeCase()}}}/domain/entities/{{{feature_name.snakeCase()}}}_entity.dart`
- `{{{feature_name.snakeCase()}}}/domain/repositories/{{{feature_name.snakeCase()}}}_repository.dart`
- `{{{feature_name.snakeCase()}}}/domain/usecases/get_{{{feature_name.snakeCase()}}}_usecase.dart`
- `{{{feature_name.snakeCase()}}}/domain/usecases/get_all_{{{feature_name.snakeCase()}}s_usecase.dart`

#### Data Layer (4 files)
- `{{{feature_name.snakeCase()}}}/data/models/{{{feature_name.snakeCase()}}}_model.dart`
- `{{{feature_name.snakeCase()}}}/data/datasources/{{{feature_name.snakeCase()}}}_local_datasource.dart`
- `{{{feature_name.snakeCase()}}}/data/datasources/{{{feature_name.snakeCase()}}}_remote_datasource.dart`
- `{{{feature_name.snakeCase()}}}/data/repositories/{{{feature_name.snakeCase()}}}_repository_impl.dart`

#### Presentation Layer (7 files)
- `{{{feature_name.snakeCase()}}}/presentation/mvi/{{{feature_name.snakeCase()}}}_action.dart`
- `{{{feature_name.snakeCase()}}}/presentation/mvi/{{{feature_name.snakeCase()}}}_state.dart`
- `{{{feature_name.snakeCase()}}}/presentation/mvi/{{{feature_name.snakeCase()}}}_event.dart`
- `{{{feature_name.snakeCase()}}}/presentation/mvi/{{{feature_name.snakeCase()}}}_bloc.dart`
- `{{{feature_name.snakeCase()}}}/presentation/pages/{{{feature_name.snakeCase()}}}_page.dart`
- `{{{feature_name.snakeCase()}}}/presentation/mvi/{{{feature_name.snakeCase()}}}_intent.dart` (obsolete)
- `{{{feature_name.snakeCase()}}}/presentation/mvi/{{{feature_name.snakeCase()}}}_side_effect.dart` (obsolete)

**Before:**
```dart
// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.
```

**After:**
```dart
// Copyright (c) {{year}}, one of DanhDue ExOICTIF projects. All rights reserved.
```

### 4. **Updated Documentation**

#### IMPLEMENTATION_GUIDE.md

Added note about automatic year setting:

```markdown
> **Note:** The copyright year in generated files is automatically set to the current year via a pre-generation hook. You can also manually specify the year with `--year 2025` if needed.
```

#### AI_AGENT_WORKFLOWS.md

Added note for AI agents:

```markdown
> **Note**: Copyright year is auto-set to current year via `pre_gen.dart` hook.
```

#### Created README.md for mvi_feature Brick

**File**: `bricks/mvi_feature/README.md`

Comprehensive documentation covering:
- Purpose and usage
- Variables and hooks
- Generated structure
- MVI architecture principles
- Next steps and troubleshooting

## 🚀 How It Works

### Generation Process

1. User runs: `mason make mvi_feature --feature_name transaction`
2. Mason calls `hooks/pre_gen.dart` **before** generating files
3. Hook checks if `year` is provided:
   - If not provided → sets `year = DateTime.now().year`
   - If provided → uses the provided value
4. Mason generates all template files with the `{{year}}` variable replaced

### Example Output (2025)

```dart
// Copyright (c) 2025, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:equatable/equatable.dart';

class TransactionEntity extends Equatable {
  // ...
}
```

### Manual Year Override (Optional)

Users can still manually specify a different year:

```bash
mason make mvi_feature --feature_name transaction --year 2024
```

This generates files with:
```dart
// Copyright (c) 2024, one of DanhDue ExOICTIF projects. All rights reserved.
```

## ✅ Verification

### Commands Run

```bash
# Format all Dart files
dart format .

# Analyze code (no issues found)
flutter analyze --no-fatal-infos
```

**Result**: ✅ No issues found! (ran in 1.3s)

## 📚 Benefits

1. **Always Current**: Copyright year matches the year files are created
2. **Automated**: No manual updates needed
3. **Flexible**: Can be overridden if needed (e.g., for legal reasons)
4. **Maintainable**: Single hook manages all templates
5. **Documented**: Clear documentation for users and AI agents

## 🔮 Future Improvements (Optional)

- Add year to `test_brick` if copyright headers are added
- Create similar hooks for other metadata (author, organization, etc.)
- Add year validation (e.g., must be between 2020 and current year + 1)

## 📖 Related Documentation

- **Main README**: `/README.md`
- **Implementation Guide**: `/IMPLEMENTATION_GUIDE.md`
- **AI Agent Workflows**: `/AI_AGENT_WORKFLOWS.md`
- **Brick README**: `/bricks/mvi_feature/README.md`

---

**Date**: January 11, 2025  
**Status**: ✅ Completed and Verified
