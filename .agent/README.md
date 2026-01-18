# .agent/ Folder - AI Agent Resources

**Purpose**: Quick-reference resources optimized for AI agents working with bloc_digital_wallet

> [!IMPORTANT]
> **Import Convention**: Always use **full package paths** (e.g., `import 'package:bloc_digital_wallet/core/network/app_uri.dart';`) instead of relative imports (e.g., `import '../../core/network/app_uri.dart';`).

---

## 📁 Folder Structure

```
.agent/
├── README.md              # This file - overview
├── skills/                # Detailed skill guides (step-by-step)
│   ├── create_new_feature/
│   └── json_to_freezed_model/
├── workflows/             # Automated workflows
│   ├── create-new-feature.md
│   └── session-init.md
├── templates/             # Task prompt templates (mirrors docs/task-prompt-templates/)
│   ├── create-new-feature.md
│   ├── fix-bug.md
│   ├── refactor-code.md
│   └── update-ui.md
├── patterns/              # Code patterns and architecture (from docs/architecture, docs/development)
│   ├── mvi-patterns.md
│   ├── clean-architecture.md
│   └── ui-patterns.md
├── rules/                 # Critical rules and standards (from .cursorrules, docs/ai-agents/)
│   ├── coding-standards.md
│   └── critical-rules.md
├── checklists/            # Verification checklists (from docs/ai-agents/)
│   ├── feature-completion.md
│   └── code-quality.md
└── references/            # Quick reference guides (from docs/getting-started/)
    └── quick-reference.md
```

---

## 🎯 Purpose of Each Folder

### 📚 `skills/` - Detailed Skill Guides
**Use for**: Step-by-step instructions for complex tasks  
**Format**: Comprehensive guides with confirmation steps  
**Example**: `create_new_feature/SKILL.md`

### ⚙️ `workflows/` - Automated Workflows
**Use for**: Streamlined execution paths for routine tasks  
**Format**: Action-oriented steps  
**Example**: `create-new-feature.md`, `session-init.md`

### 📋 `templates/` - Task Prompt Templates
**Use for**: Ready-to-use task assignment templates  
**Format**: Copy-paste templates with placeholders  
**Mirrors**: `docs/task-prompt-templates/`

### 🏗️ `patterns/` - Code Patterns
**Use for**: Quick lookup of architecture and code patterns  
**Format**: Code examples and patterns  
**Source**: `docs/architecture/`, `docs/development/`

### ⚠️ `rules/` - Critical Rules
**Use for**: Coding standards and mandatory rules  
**Format**: Rules with do/don't examples  
**Source**: `.cursorrules`, `docs/ai-agents/AI_AGENT_RULES.md`

### ✅ `checklists/` - Verification Checklists
**Use for**: Task verification and quality checks  
**Format**: Checkbox lists  
**Source**: `docs/ai-agents/AI_AGENT_CHECKLIST.md`

### 📖 `references/` - Quick References
**Use for**: Fast lookup of commands and syntax  
**Format**: Cheat sheets  
**Source**: `docs/getting-started/QUICK_REFERENCE.md`

---

## 🔍 How Agents Use These Files

1. **Skills/Workflows**: Follow step-by-step for complex tasks
2. **Templates**: Copy structure and fill placeholders for task assignment
3. **Patterns**: Reference code examples when implementing
4. **Rules**: Check compliance before submitting code
5. **Checklists**: Verify completeness after implementation
6. **References**: Quick lookup for commands and syntax

---

## 📊 Quick Navigation

**Need to create a feature?**
→ `skills/create_new_feature/` or `workflows/create-new-feature.md`

**Need a task template?**
→ `templates/create-new-feature.md`

**Need code pattern?**
→ `patterns/mvi-patterns.md`

**Need to verify rules?**
→ `rules/critical-rules.md`

**Need verification checklist?**
→ `checklists/feature-completion.md`

**Need quick command?**
→ `references/quick-reference.md`

---

## 🔄 Relationship to `docs/` Folder

The `.agent/` folder contains **agent-optimized** versions of documentation:

| `docs/` | `.agent/` | Purpose |
|---------|-----------|---------|
| `task-prompt-templates/` | `templates/` | Task templates |
| `ai-agents/AI_AGENT_*` | `rules/`, `checklists/` | Rules and verification |
| `architecture/` | `patterns/` | Architecture patterns |
| `development/` | `patterns/` | Implementation patterns |
| `getting-started/QUICK_REFERENCE.md` | `references/` | Quick lookup |

**Key Difference**: `.agent/` files are condensed, action-oriented, and optimized for quick lookup by AI agents, while `docs/` contains comprehensive documentation for humans.

---

**Last Updated**: 2026-01-13  
**Status**: Active ✅
