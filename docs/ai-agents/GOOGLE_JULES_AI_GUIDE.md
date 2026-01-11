# Google Jules AI Setup Guide

**Complete guide for Google Jules AI to work on bloc_digital_wallet**

---

## 🎯 For Google Jules AI

This project is **fully optimized** for AI Agents like Google Jules AI. Everything you need is pre-configured and documented.

---

## 🚀 Quick Start (3 Steps)

### Step 1: Environment Setup

**Option A: Using GitHub Codespaces (Recommended)**
1. This repository has a `.devcontainer` configuration
2. When opened in GitHub Codespaces, it will automatically:
   - Install Flutter (via FVM)
   - Install all dependencies
   - Set up development tools
   - Configure helper scripts
   - Load all documentation

**Option B: Local DevContainer**
1. Open in VS Code with "Dev Containers" extension
2. Select "Reopen in Container"
3. Wait for automatic setup (~5-10 minutes first time)

**Option C: Manual Setup**
1. Ensure Flutter SDK installed via FVM
2. Run: `fvm flutter pub get`
3. Run: `mason get`
4. Run: `flutter pub run build_runner build --delete-conflicting-outputs`

### Step 2: Read Documentation

```bash
# Start here - navigation guide
cat AI_AGENT_README.md

# Then - complete architecture context
cat AI_AGENT_CONTEXT.md

# Reference - step-by-step workflows
cat AI_AGENT_WORKFLOWS.md

# Quick lookup - checklists and commands
cat AI_AGENT_CHECKLIST.md
```

**Reading time**: ~15 minutes to absorb complete context

### Step 3: Verify Setup

```bash
# If in devcontainer
verify-setup.sh

# Or manually
flutter doctor -v
mason --version
```

---

## 📚 Documentation Structure for Jules AI

### Priority Order

1. **[AI_AGENT_README.md](AI_AGENT_README.md)** ⭐ START HERE
   - Purpose: Navigation and overview
   - Time: 2 minutes
   - What you get: Understanding of documentation structure

2. **[AI_AGENT_CONTEXT.md](AI_AGENT_CONTEXT.md)** 📖 CORE KNOWLEDGE
   - Purpose: Complete architectural context
   - Time: 15 minutes
   - What you get:
     - Project structure patterns
     - Architecture rules (Clean + MVI)
     - 11 code templates (ready to use)
     - 3 decision trees
     - Error resolution patterns
   - **Most important for understanding HOW to work**

3. **[AI_AGENT_WORKFLOWS.md](AI_AGENT_WORKFLOWS.md)** 🛠️ IMPLEMENTATION
   - Purpose: Step-by-step task workflows
   - Time: Reference as needed
   - What you get:
     - 10 complete workflows
     - Step-by-step instructions
     - Complete code examples
   - **Most important for DOING tasks**

4. **[AI_AGENT_CHECKLIST.md](AI_AGENT_CHECKLIST.md)** ✅ VERIFICATION
   - Purpose: Quick reference and checklists
   - Time: 2 minutes per task
   - What you get:
     - Task checklists
     - Quick error fixes
     - Essential commands
   - **Most important for VERIFYING work**

---

## 🎓 Learning Path for Jules AI

### First Task (15 minutes reading + task time)

```
1. Read AI_AGENT_README.md (2 min)
   └─ Understand documentation structure

2. Read AI_AGENT_CONTEXT.md (15 min)
   ├─ Project Identity
   ├─ File Structure Patterns
   ├─ Architecture Rules
   ├─ MVI Components (Action/State/Event)
   ├─ Code Templates (all 11)
   ├─ Decision Trees
   └─ Error Patterns

3. Scan AI_AGENT_WORKFLOWS.md (5 min)
   └─ Know what workflows are available

4. Ready to work!
   └─ Total: 22 minutes → Fully productive
```

### Subsequent Tasks (2-5 minutes setup)

```
1. Identify task type
2. Open AI_AGENT_WORKFLOWS.md → Find relevant workflow
3. Follow steps
4. Use AI_AGENT_CHECKLIST.md to verify
5. Report completion
```

---

## 🔧 Available Tools & Commands

### In DevContainer

All these commands are pre-configured:

```bash
# Feature creation
create-feature.sh <feature_name>

# Quick fixes
quick-fix.sh             # Format + analyze

# Code generation
build-gen                # Run build_runner

# Testing
test                     # Run Flutter tests

# Information
show-info.sh             # Project information
verify-setup.sh          # Verify environment
project-info             # Documentation overview

# Navigation
goto-features            # cd to lib/features
goto-core                # cd to lib/core
```

### Aliases Available

```bash
flutter, dart, pub-get, pub-upgrade,
format, analyze, test, clean, doctor,
mason-get, mason-list, mason-feature,
melos-bs, melos-clean, melos-test
```

---

## 📋 Common Tasks for Jules AI

### Task 1: Create New Feature

```bash
# Use helper script (easiest)
create-feature.sh transaction_history

# Or follow workflow
# 1. Open AI_AGENT_WORKFLOWS.md
# 2. Go to: "Workflow: Create Complete New Feature"
# 3. Follow step-by-step (10 steps)
# 4. Verify with AI_AGENT_CHECKLIST.md
```

**Time**: ~30 minutes for complete feature

### Task 2: Fix Bug

```bash
# 1. Check AI_AGENT_CHECKLIST.md → "Common Errors"
# 2. Apply quick fix if available
# 3. If complex, follow AI_AGENT_WORKFLOWS.md → "Workflow 3: Fix Bug"
# 4. Report fix
```

**Time**: ~5-15 minutes

### Task 3: Add New Use Case

```bash
# Follow AI_AGENT_WORKFLOWS.md → "Workflow 4: Add New Use Case"
# 8 steps with code examples
```

**Time**: ~15 minutes

### Task 4: Update Entity/Model

```bash
# Follow AI_AGENT_WORKFLOWS.md → "Workflow 5: Update Entity/Model"
# 5 steps
```

**Time**: ~10 minutes

---

## 🏗️ Architecture Quick Reference

### Layer Rules

```
Dependency Direction:
  Presentation → Domain ← Data

Never:
  Domain → Presentation ❌
  Domain → Data ❌
  Domain → Flutter imports ❌
```

### MVI Components

```yaml
Action (User Input):
  - Extends: BaseAction
  - Example: LoadWalletAction, CreateTransactionAction
  - Flow: View → BLoC

State (Persistent Data):
  - Extends: BaseState with EquatableMixin
  - Example: WalletLoading, WalletLoaded
  - Flow: BLoC → View (rebuild)

Event (One-time Effect):
  - Extends: BaseEvent
  - Example: ShowSuccessMessage, NavigateToDetail
  - Flow: BLoC → View (once)
```

### Single Entry Point

```dart
// ✅ CORRECT - Only way to dispatch actions
context.read<WalletBloc>().onAction(LoadWalletAction());

// ❌ WRONG - Never use
context.read<WalletBloc>().add(LoadWalletAction());
```

---

## 🎯 Decision Trees

### Where to Add Code?

```
Business Logic? → Domain / UseCase
API Call? → Data / DataSource
Caching? → Data / Repository
JSON Conversion? → Data / Model
State Management? → Presentation / BLoC
User Action? → Presentation / Action
UI Rendering? → Presentation / Page
One-time Effect? → Presentation / Event
```

### When to Run Code Generation?

```
After:
- Adding @freezed class
- Adding @JsonSerializable
- Adding @injectable/@LazySingleton
- Modifying any model

Command: build-gen
```

---

## 💡 Best Practices for Jules AI

### 1. Always Read Context First
```bash
cat AI_AGENT_CONTEXT.md  # Comprehensive understanding
```

### 2. Follow Workflows
```bash
cat AI_AGENT_WORKFLOWS.md  # Step-by-step guidance
```

### 3. Use Checklists
```bash
cat AI_AGENT_CHECKLIST.md  # Verify nothing missed
```

### 4. Use Helper Scripts
```bash
create-feature.sh <name>    # Not: mason make...
quick-fix.sh                # Not: flutter format && ...
```

### 5. Verify Before Reporting (CRITICAL STEP)

**⚠️ MANDATORY: Run these commands after EVERY task**

```bash
# Step 1: Format code
flutter format .

# Step 2: Analyze (MUST show "No issues found!")
flutter analyze --no-fatal-infos

# Expected output:
# Analyzing bloc_digital_wallet...
# No issues found! (ran in X.Xs)

# Step 3: If errors, fix and re-analyze
# Repeat until 0 issues

# Step 4: Run tests (if applicable)
flutter test
```

**DO NOT report to user until `flutter analyze` shows "No issues found!"**

---

## 🚨 Common Issues & Solutions

### Issue: "GetIt: Object not registered"
```bash
# Solution:
build-gen  # Regenerate DI
```

### Issue: "Part file doesn't exist"
```bash
# Solution:
build-gen  # Generate freezed/json_serializable files
```

### Issue: "State not updating"
```bash
# Check:
1. State extends Equatable? ✓
2. State.props includes field? ✓
3. emit() is called? ✓
4. BlocProvider exists? ✓
```

### Issue: "Flutter imports in domain"
```bash
# Solution:
# Remove all package:flutter/* from domain/
# Domain must be pure Dart
```

---

## 📊 Expected Performance

Jules AI should achieve:

- ✅ Context loading: 15 minutes (first time)
- ✅ Feature creation: 30 minutes
- ✅ Bug fix: 5-15 minutes
- ✅ Add use case: 15 minutes
- ✅ Update entity: 10 minutes
- ✅ Consistent architecture compliance
- ✅ Zero manual guidance needed

---

## 📖 Complete Documentation Index

```
AI Agent Documentation:
├── AI_AGENT_README.md          # Navigation hub
├── AI_AGENT_CONTEXT.md         # Core knowledge (~2000 lines)
├── AI_AGENT_WORKFLOWS.md       # 10 workflows (~2500 lines)
├── AI_AGENT_CHECKLIST.md       # Quick reference (~500 lines)
└── .devcontainer/README.md     # DevContainer setup

Human Documentation:
├── ARCHITECTURE.md             # Architecture details
├── IMPLEMENTATION_GUIDE.md     # Tutorial for humans
├── QUICK_REFERENCE.md          # Human cheat sheet
└── README.md                   # Project overview

Project Files:
├── lib/core/architecture/      # MVI base classes
├── lib/features/               # Feature modules
├── bricks/mvi_feature/         # Mason template
└── scripts/                    # Build scripts
```

---

## 🎉 Ready to Code!

Your environment is fully configured. Jules AI has everything needed to:

1. ✅ Understand the architecture
2. ✅ Create new features
3. ✅ Fix bugs
4. ✅ Add functionality
5. ✅ Maintain code quality
6. ✅ Generate consistent code

**Start with**: `cat AI_AGENT_README.md`

---

## 📮 Support

### For Jules AI

**If unclear about:**
- Architecture → Read `AI_AGENT_CONTEXT.md`
- How to do X → Read `AI_AGENT_WORKFLOWS.md`
- Quick reference → Read `AI_AGENT_CHECKLIST.md`
- Navigation → Read `AI_AGENT_README.md`

**If environment issue:**
```bash
verify-setup.sh          # Check setup
show-info.sh             # Show configuration
cat ~/.ai-agent-info.json # Raw metadata
```

**If code issue:**
```bash
quick-fix.sh             # Format + analyze
doctor                   # Flutter doctor
build-gen                # Regenerate code
```

---

## 🌟 Success Criteria

Jules AI working successfully when:

- ✅ Can create features without guidance
- ✅ Code follows architecture rules
- ✅ Tests pass
- ✅ No linter errors
- ✅ Consistent naming conventions
- ✅ Proper use of MVI pattern
- ✅ Clean Architecture maintained

---

**Welcome, Jules AI! Let's build something amazing! 🚀**

---

**Last Updated**: 2026-01-11  
**Maintained By**: DanhDue ExOICTIF  
**Version**: 1.0.0
