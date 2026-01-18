# 🚀 AI Agent Task Assignment Guide

**Project**: bloc_digital_wallet  
**Architecture**: Clean Architecture + MVI Pattern  
**Purpose**: Efficient task assignment for AI agents with ready-to-use templates

---

## 📋 Table of Contents

1. [How to Use This Guide](#-how-to-use-this-guide)
2. [Available Templates](#-available-templates)
3. [Critical Rules](#️-critical-rules-ai-agent-must-follow)
4. [Mission Breakdown](#-mission-breakdown)
5. [Task-Specific Templates](#-task-specific-templates)
6. [Complete Examples](#-complete-examples)
7. [Quality Checklist](#-quality-checklist)
8. [Success Metrics](#-success-metrics)
9. [Common Mistakes](#-common-mistakes-to-avoid)

---

## 📋 How to Use This Guide

### Quick Start (6 Steps):

> [!IMPORTANT]
> **Import Convention**: Always use **full package paths** (e.g., `import 'package:bloc_digital_wallet/core/network/app_uri.dart';`) instead of relative imports (e.g., `import '../../core/network/app_uri.dart';`).

1. **Choose Template** - Select based on task type (create, fix, refactor, update)
2. **Copy Structure** - Use the template from the appropriate file
3. **Fill Details** - Replace placeholders with your requirements
4. **Attach Files** - Use @file or @folder for context
5. **Submit to AI** - Provide completed prompt to AI agent
6. **Review Plan** - Check AI's analysis before proceeding

---

## 📂 Available Templates

### 1. [Create New Feature](./create-new-feature.md)
**Use for**: Creating new modules or adding subfeatures to existing modules

**When to use**:
- ✅ Creating authentication, wallet, profile modules (new module)
- ✅ Adding forgot_password, transfer_money features (subfeature)
- ✅ Any new functionality

**Includes**:
- Template structure
- **Example 1**: Add Forgot Password (subfeature)
- **Example 2**: Create Notifications Module (new module)
- Step-by-step guidance
- Success criteria

**Size**: 10 KB | **Lines**: 300+

---

### 2. [Fix Bug](./fix-bug.md)
**Use for**: Fixing bugs, errors, or unexpected behavior

**When to use**:
- ✅ Button not responding
- ✅ Data not updating
- ✅ Navigation issues
- ✅ Any bug or error fix

**Includes**:
- Template structure
- **Example 1**: Fix Login Button Not Responding
- **Example 2**: Fix Transaction List Not Updating
- Bug analysis checklist
- Test scenarios

**Size**: 8.3 KB | **Lines**: 297

---

### 3. [Refactor Code](./refactor-code.md)
**Use for**: Improving code quality without changing functionality

**When to use**:
- ✅ Reducing complexity
- ✅ Eliminating duplication
- ✅ Improving performance
- ✅ Better organization

**Includes**:
- Template structure
- **Example 1**: Refactor Authentication BLoC
- **Example 2**: Optimize Widget Tree for Performance
- Refactoring checklist
- Before/after metrics

**Size**: 12 KB | **Lines**: 446

---

### 4. [Update UI](./update-ui.md)
**Use for**: Updating user interface, styling, or visual improvements

**When to use**:
- ✅ Redesigning screens
- ✅ Updating styling
- ✅ Improving UX
- ✅ Material Design updates

**Includes**:
- Template structure
- **Example 1**: Update Login Page Design
- **Example 2**: Redesign Wallet Balance Card
- Theme compliance rules
- Accessibility guidelines

**Size**: 13 KB | **Lines**: 540+

---

## ⚠️ CRITICAL RULES (AI Agent MUST Follow)

### 1. Feature Creation - Proactive Workflow

**IF** task is "create a feature" WITHOUT clear module context:

**THEN** follow this workflow:

```
1. ANALYZE
   └─ Check lib/features/ for existing modules proactively
   └─ Determine if feature belongs to existing module
   └─ Identify best approach

2. PRESENT PLAN
   └─ Show options with recommendation:
      • Option 1: Create as new module (mvi_feature)
      • Option 2: Add as subfeature (mvi_subfeature)
   └─ Include: What will be created/modified, benefits

3. PREPARE TASK ASSIGNMENT TEMPLATE & ASK FOR MODULE INFO AND CONFIRMATION
   └─ Use structured template to collect missing information:
   
   MODULE INFORMATION:
   - Target module: [recommended]
   - Feature/Subfeature name: [suggested]
   - Functionality: [what it does]
   - UI requirements: [screens/components needed]
   
   TECHNICAL DETAILS:
   - API endpoints: [if applicable]
   - Validation rules: [requirements]
   - Error handling: [approach]
   - Success flow: [what happens after]
   
   ADDITIONAL REQUIREMENTS:
   - Translations: [keys to add]
   - Routing: [paths to configure]
   - Dependencies: [any new packages]
   
   CONFIRMATION:
   Should I proceed with [recommended option]?

4. THEN PROCEED
   └─ After receiving confirmation with all details
   └─ Use appropriate template (mvi_feature or mvi_subfeature)
```

**Decision Guide**:
- New domain concept? → Use `mvi_feature` (e.g., create wallet module)
- Extends existing module? → Use `mvi_subfeature` (e.g., add forgot_password to authentication)

---

### 2. Theme & Styling (MANDATORY)

```dart
✅ ALWAYS USE:
- context.appThemes.bodyMedium (for text styles)
- context.appThemes.primaryColor (for colors)
- context.appThemes.surfaceColor (for backgrounds)

❌ NEVER USE:
- Theme.of(context).textTheme.bodyMedium
- Theme.of(context).colorScheme.primary
- Colors.red or Color(0xFF...)
```

**Adding New Colors**:
1. Add to `assets/colors/colors.xml`
2. Add field to `lib/config/theme/app_themes.dart`
3. Initialize in light & dark themes
4. Run: `melos genAlls`

---

### 3. Translations (MANDATORY)

```dart
✅ ALWAYS USE:
- context.t.authLogin (for all user-facing text)
- context.t.profileEditButton

❌ NEVER USE:
- Text('Login') or hardcoded strings
```

**Adding Translations**:
1. Add to `assets/locales/en.i18n.json`
2. Add to `assets/locales/vi.i18n.json`
3. Run: `melos genAlls`
4. Use: `context.t.yourNewKey`

**Naming**: `{module}{Description}` (e.g., authWelcomeBack, walletBalance)

---

### 4. MVI Pattern

```dart
COMPONENTS:
- Action: User inputs (VerbNounAction) - sealed class
- State: Persistent UI data (NounAdjective) - sealed class with Equatable
- Event: One-time effects (ShowX, NavigateX) - sealed class
- BLoC: Extends MviBloc<Action, State, Event>

SINGLE ENTRY POINT:
✅ bloc.onAction(const LoadDataAction())
❌ bloc.add(SomeEvent()) - WRONG PATTERN

EMIT:
- States: emit(MyLoadedState(data))
- Events: emitEvent(ShowSuccessMessage('Done'))
```

---

## 🛠 Mission Breakdown

### Step 1: Analysis (Required)
```
[ ] Check existing code at @[file/folder]
[ ] IF creating feature: Check lib/features/ for related modules
[ ] Identify dependencies and impacts
[ ] Review relevant documentation:
    [ ] .cursorrules (critical rules)
    [ ] docs/ai-agents/AI_AGENT_WORKFLOWS.md (workflows)
    [ ] docs/mason/MASON_TEMPLATES_OVERVIEW.md (if creating feature)
```

### Step 2: Plan Presentation (Required)
```
[ ] Present clear plan showing:
    [ ] What will be created
    [ ] What will be modified
    [ ] Which template/approach will be used
    [ ] Estimated steps
[ ] IF feature creation: Show analysis and recommendation
[ ] Ask for confirmation before proceeding
```

### Step 3: Implementation
```
[ ] Execute confirmed plan
[ ] Follow Clean Architecture layers:
    [ ] Domain: Entities (@freezed with abstract class and @JsonKey), Use Cases, Repository Interfaces (pure Dart)
    [ ] Data: Models (@freezed with abstract class and @JsonKey), DataSources, Repository Impl
    [ ] ⚠️ IMPORTANT: All entities and models will use freezed with @JsonKey(name: 'field_name') annotations
    [ ] Presentation: Actions, States, Events, BLoC, Pages
[ ] Use correct patterns:
    [ ] context.appThemes for styling
    [ ] context.t for translations
    [ ] bloc.onAction() for dispatching actions
```

### Step 4: Code Generation & Verification
```
[ ] Run code generation: melos genAlls
[ ] Format code: dart format lib/
[ ] Analyze code: fvm flutter analyze --no-fatal-infos
[ ] Fix ALL issues until output shows: "No issues found!"
[ ] Verify no linter errors
```

---

## 🎯 Task-Specific Templates

### Template A: Create New Feature
**Full Guide**: [create-new-feature.md](./create-new-feature.md)

**Quick Structure**:
```markdown
TASK: Create [feature_name] feature

REQUIREMENTS:
- Feature type: [New Module / Subfeature]
- Target module: [if subfeature]
- Functionality: [what it does]
- UI requirements: [screens/components]
- API endpoints: [if applicable]

DELIVERABLES:
[ ] Generated structure (mason)
[ ] Business logic implemented
[ ] UI with theme/translations
[ ] Routes configured
[ ] Code generation done
[ ] 0 issues
```

---

### Template B: Fix Bug
**Full Guide**: [fix-bug.md](./fix-bug.md)

**Quick Structure**:
```markdown
TASK: Fix [bug description]

SYMPTOMS:
- What's happening: [bug behavior]
- Expected: [correct behavior]
- Steps to reproduce: [how to trigger]

AFFECTED FILES: @[files]

DELIVERABLES:
[ ] Root cause identified
[ ] Minimal fix applied
[ ] Bug resolved
[ ] No regressions
[ ] 0 issues
```

---

### Template C: Refactor Code
**Full Guide**: [refactor-code.md](./refactor-code.md)

**Quick Structure**:
```markdown
TASK: Refactor [component]

CURRENT STATE:
- Problems: [code smells, issues]
- Metrics: [complexity, duplication]

GOAL:
- Improvements: [better patterns, performance]

DELIVERABLES:
[ ] Plan approved
[ ] Code refactored
[ ] Functionality preserved
[ ] Quality improved
[ ] 0 issues
```

---

### Template D: Update UI
**Full Guide**: [update-ui.md](./update-ui.md)

**Quick Structure**:
```markdown
TASK: Update UI for [screen]

REQUIREMENTS:
- Changes: [visual updates]
- Design reference: [if available]

MANDATORY:
[ ] context.appThemes (NOT Theme.of)
[ ] context.t (NOT hardcoded)
[ ] Light/dark themes tested
[ ] Responsive design
[ ] 0 issues
```

---

## 🎨 Complete Examples

All examples with full implementation details:

### Create New Feature:
1. **[Add Forgot Password](./create-new-feature.md#example-1-add-forgot-password-feature-subfeature)** (subfeature)
2. **[Create Notifications Module](./create-new-feature.md#example-2-create-notifications-module-new-module)** (new module)

### Fix Bug:
3. **[Fix Login Button Not Responding](./fix-bug.md#example-1-fix-login-button-not-responding)**
4. **[Fix Transaction List Not Updating](./fix-bug.md#example-2-fix-transaction-list-not-updating)**

### Refactor Code:
5. **[Refactor Authentication BLoC](./refactor-code.md#example-1-refactor-authentication-bloc)**
6. **[Optimize Widget Tree Performance](./refactor-code.md#example-2-refactor-widget-tree-for-performance)**

### Update UI:
7. **[Update Login Page Design](./update-ui.md#example-1-update-login-page-design)**
8. **[Redesign Wallet Balance Card](./update-ui.md#example-2-update-wallet-balance-card-ui)**

**Total**: 8 complete, production-ready examples

---

## ✅ Quality Checklist (AI Agent Must Complete)

### Before Starting:
```
[ ] Understood the task clearly
[ ] Reviewed relevant files
[ ] Identified potential issues
[ ] IF feature creation: Checked for existing modules
```

### During Implementation:
```
[ ] Following Clean Architecture + MVI pattern
[ ] Using context.appThemes (not Theme.of(context))
[ ] Using context.t (not hardcoded strings)
[ ] Proper action/state/event pattern
[ ] Injectable dependency injection
[ ] Proper error handling (Either<Failure, Success>)
```

### After Implementation:
```
[ ] Ran: melos genAlls
[ ] Ran: dart format lib/
[ ] Ran: fvm flutter analyze --no-fatal-infos
[ ] Output shows: "No issues found!"
[ ] All files properly formatted
[ ] No unused imports/variables
[ ] Code follows project patterns
```

### Reporting:
```
[ ] Listed all created files
[ ] Listed all modified files
[ ] Explained changes made
[ ] Provided usage examples
[ ] Noted any pending tasks
```

---

## 📊 Success Metrics

A well-completed task should result in:

- ✅ **0 Issues**: `fvm flutter analyze --no-fatal-infos` shows "No issues found!"
- ✅ **Formatted**: All code properly formatted with `dart format lib/`
- ✅ **Patterns**: Follows Clean Architecture + MVI
- ✅ **Themes**: Uses `context.appThemes` everywhere
- ✅ **Translations**: Uses `context.t` everywhere
- ✅ **Generated**: All code generation completed successfully
- ✅ **Tested**: Functionality works as expected
- ✅ **Documented**: Changes are clear and explained

---

## 💡 Tips for Effective Task Assignment

### 1. Be Specific
```
❌ "Fix the authentication"
✅ "Fix login button not responding on first tap in login_page.dart"
```

### 2. Provide Context
```
❌ "Add a feature"
✅ "Add forgot_password as subfeature to authentication module"
```

### 3. Attach Relevant Files
```
Use @file or @folder to give AI agent direct access:
@lib/features/authentication
@.cursorrules
```

### 4. Specify Constraints
```
- Don't modify: [specific files]
- Must use: [specific patterns]
- Performance: [requirements]
```

### 5. Define Success Criteria
```
DONE WHEN:
- Feature works as described
- All tests pass
- Code analysis shows 0 issues
- Documentation updated
```

---

## 🚨 Common Mistakes to Avoid

### For Task Assigners:
```
❌ Vague requirements: "Make it better"
❌ No context provided
❌ Forgetting to attach relevant files
❌ Not specifying constraints
❌ Unclear success criteria

✅ Clear, specific requirements
✅ Context and current state explained
✅ Relevant files attached
✅ Constraints clearly stated
✅ Success criteria defined
```

### For AI Agents:
```
❌ Starting implementation without analysis
❌ Not following the proactive workflow
❌ Using Theme.of(context) instead of context.appThemes
❌ Using hardcoded strings instead of context.t
❌ Not running code generation and verification
❌ Implementing without confirmation on ambiguous tasks

✅ Analyze first
✅ Present plan before implementing
✅ Follow all CRITICAL RULES
✅ Use correct patterns
✅ Verify thoroughly
✅ Ask for confirmation when needed
```

---

## 📊 Template Comparison

| Template | Use Case | Complexity | Time | Example |
|----------|----------|------------|------|---------|
| **Create New Feature** | New functionality | Medium-High | 2-4h | Add forgot password |
| **Fix Bug** | Resolve issues | Low-Medium | 30min-2h | Fix button not working |
| **Refactor Code** | Improve quality | Medium | 1-3h | Optimize performance |
| **Update UI** | Visual changes | Low-Medium | 1-2h | Redesign login page |

---

## 🎯 Quick Reference: Template Selection

```
Need to:
│
├─ Add new functionality?
│  └─ Use: Create New Feature Template
│
├─ Fix something broken?
│  └─ Use: Fix Bug Template
│
├─ Improve code quality?
│  └─ Use: Refactor Code Template
│
└─ Update appearance?
   └─ Use: Update UI Template
```

---

## 📚 Related Documentation

### For AI Agents:
- [AI Agent Workflows](../ai-agents/AI_AGENT_WORKFLOWS.md) - Complete step-by-step workflows
- [AI Agent Context](../ai-agents/AI_AGENT_CONTEXT.md) - Architecture and patterns
- [AI Agent Checklist](../ai-agents/AI_AGENT_CHECKLIST.md) - Quick reference checklists

### For Features:
- [Mason Templates Overview](../mason/MASON_TEMPLATES_OVERVIEW.md) - Template decision guide
- [MVI Subfeature Guide](../mason/MVI_SUBFEATURE_GUIDE.md) - Subfeature implementation
- [Workflow Quick Reference](../../.docs/WORKFLOW_QUICK_REF.md) - One-page guide

### For Development:
- [Implementation Guide](../development/IMPLEMENTATION_GUIDE.md) - Complete implementation guide
- [Architecture Overview](../architecture/ARCHITECTURE.md) - Architecture details
- [Cursor Rules](../../.cursorrules) - Critical project rules

---

## 🔍 Need Help?

### Can't find the right template?
→ Use `create-new-feature.md` and adapt it

### Template unclear?
→ Check the complete examples in each template file

### AI agent confused?
→ Review `.cursorrules` and provide more context with @file

### Task too complex?
→ Break into smaller tasks using multiple templates

### Not sure which template?
→ See comparison table above or ask in project chat

---

## 🎓 Advanced Usage

### For New Module Creation:
1. Start with [create-new-feature.md](./create-new-feature.md)
2. Use Example 2 (notifications) as reference
3. Follow complete workflow
4. Run: `mason make mvi_feature`

### For Adding to Existing Module:
1. Start with [create-new-feature.md](./create-new-feature.md)
2. Use Example 1 (forgot password) as reference
3. Follow subfeature workflow
4. Run: `mason make mvi_subfeature`

### For Bug Fixes:
1. Start with [fix-bug.md](./fix-bug.md)
2. Choose similar example
3. Analyze root cause first
4. Apply minimal fix

### For Refactoring:
1. Start with [refactor-code.md](./refactor-code.md)
2. Plan changes first
3. Get approval for major refactors
4. Test after each step

### For UI Updates:
1. Start with [update-ui.md](./update-ui.md)
2. Ensure theme compliance
3. Add translations
4. Test light/dark themes

---

## 📈 File Structure

```
docs/task-prompt-templates/
├── README.md                    # This file - main guide
├── create-new-feature.md        # Template A + examples
├── fix-bug.md                   # Template B + examples
├── refactor-code.md             # Template C + examples
└── update-ui.md                 # Template D + examples

Total: 5 files, 49.4 KB
Total Examples: 8 complete examples
```

---

## 🚀 Quick Start Example

**Task**: Add forgot password to authentication

```markdown
1. Open: docs/task-prompt-templates/create-new-feature.md
2. Copy: Template structure
3. Fill: 
   - Module: authentication
   - Subfeature: forgot_password
   - Files: @lib/features/authentication
4. Submit to AI agent
5. Review plan
6. Confirm and proceed
```

---

## ✅ Final Checklist for Task Completion

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
[ ] No unused imports/variables

Documentation:
[ ] Changes explained clearly
[ ] Created files listed
[ ] Modified files listed
[ ] Usage examples provided

Testing:
[ ] Feature works as expected
[ ] No regressions introduced
[ ] Edge cases handled
```

---

**Last Updated**: 2026-01-12  
**Version**: 2.0  
**Status**: Production Ready ✅

---

**Quick Links**:
- [Create New Feature Template](./create-new-feature.md) - 10 KB, 2 examples
- [Fix Bug Template](./fix-bug.md) - 8.3 KB, 2 examples
- [Refactor Code Template](./refactor-code.md) - 12 KB, 2 examples
- [Update UI Template](./update-ui.md) - 13 KB, 2 examples

---

**Total Resources**: 5 template files | 8 complete examples | 49.4 KB of comprehensive guides
