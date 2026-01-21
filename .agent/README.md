# .agent/ Folder - AI Agent Resources

**Purpose**: Quick-reference resources optimized for AI agents working with bloc_digital_wallet

> [!IMPORTANT]
> **Import Convention**: Always use **full package paths** (e.g., `import 'package:bloc_digital_wallet/core/network/app_uri.dart';`) instead of relative imports (e.g., `import '../../core/network/app_uri.dart';`).

---

## 🛠️ Skills Index

| Skill | Trigger | Description | File |
|-------|---------|-------------|------|
| **API Integration** | `@api_integration` | Automate API handling (Model/Client/DS) | [SKILL.md](skills/api_integration/SKILL.md) |
| **Feature Creation** | `@create_new_feature` | Guide for New Modules & Subfeatures | [SKILL.md](skills/create_new_feature/SKILL.md) |
| **JSON to Freezed** | `@json_to_freezed_model` | Parse JSON → Freezed Models | [SKILL.md](skills/json_to_freezed_model/SKILL.md) |

---

## 🏗️ Build Environment
This project uses **Dev Containers** to ensure consistency between developers and AI Agents.
- **Config**: [.devcontainer/devcontainer.json](file:///Users/danhdue/AllProjects/sample/bloc_digital_wallet/.devcontainer/devcontainer.json)
- **Setup**: Run `bash .devcontainer/setup.sh` to initialize all CLI tools.
- **Secrets**: Requires environment variable `SECURE_FILES` (base64) for git-ignored files.
- **Entry Point**: See [AI_AGENT_README.md](file:///Users/danhdue/AllProjects/sample/bloc_digital_wallet/AI_AGENT_README.md) at the root.

---

## 📁 Folder Structure

```
.agent/
├── README.md               # This file
├── contexts/               # 🧠 Persistent Memory
│   ├── project_state.md    # Architecture & Milestones
│   └── active_context.md   # Current session scratchpad
├── personas/               # 🎭 Role-based Instructions
│   ├── architect.md        # Design & Strategy
│   ├── tech_lead.md        # QC & Refactoring
│   └── qa_engineer.md      # Testing & Edge Cases
├── skills/                 # Detailed skill guides
│   ├── api_integration/    # @api_integration
│   ├── create_new_feature/ # @create_new_feature
│   └── json_to_freezed_model/ # @json_to_freezed_model
├── workflows/              # Step-by-step procedures
├── templates/              # Task prompt templates
├── patterns/               # Code & Architecture patterns
├── rules/                  # Mandatory Project Rules
│   ├── critical-rules.md   # 🚨 META-RULE (Start Here)
│   ├── adherence-rules.md  # ⚡ Extreme Execution Rules
│   ├── project-conventions.md # 🛠️ Strict Tech Constraints
│   ├── tech-stack.md       # Flutter/Bloc/Arch rules
│   ├── coding-standards.md # Formatting & Naming
│   ├── git-workflow.md     # Commits & PRs
│   └── security.md         # Secrets & Safety
└── checklists/             # Verification Checklists
```

---

## 🎯 Resource Guide

### 📚 `skills/`
**Purpose**: Automation for complex, repetitive tasks.  
**Usage**: Triggered by user intent (e.g., "Add API", "New Feature").  
**Protocol**: Execute immediately, NO review required (unless specified).

### ⚙️ `workflows/`
**Purpose**: Step-by-step manual guides for routine operations.  
**Usage**: Follow when a skill doesn't apply.

### ⚠️ `rules/`
**Purpose**: MANDATORY project conventions.  
**Usage**: Must be referenced before ANY implementation.

### 🏗️ `patterns/`
**Purpose**: Architecture reference.  
**Usage**: Consult for structural consistency (MVI, Clean Arch).

---

## 🔄 Relationship to `docs/`

The `.agent/` folder is the **Single Source of Truth** for AI Agents.

| Category | `.agent/` (Agent-Optimized) | `docs/` (Human-Readable) |
|----------|---------------------------|--------------------------|
| **Rules** | `rules/` | `ai-agents/` |
| **Patterns** | `patterns/` | `architecture/` |
| **Tasks** | `templates/` | `task-prompt-templates/` |

**Last Updated**: 2026-01-21
**Status**: Active ✅
