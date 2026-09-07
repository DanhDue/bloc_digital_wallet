# Migration from .agents to .kiro

**Date**: 2026-01-22  
**Status**: ✅ Complete

## Overview

This document explains how the `.agents` folder structure has been integrated with Kiro's `.kiro` configuration.

## What Was Migrated

### 1. Rules → Steering Files

| .agents/rules/ | .kiro/steering/ | Status |
|---------------|-----------------|--------|
| `critical-rules.md` | `project-conventions.md` | ✅ Migrated |
| `project-conventions.md` | `project-conventions.md` | ✅ Migrated |
| `tech-stack.md` | `mvi-architecture.md` | ✅ Migrated |
| `coding-standards.md` | `project-conventions.md` | ✅ Merged |
| N/A | `mason-workflows.md` | ✅ Created |

### 2. Workflows → Specs

| .agents/workflows/ | .kiro/specs/ | Status |
|-------------------|--------------|--------|
| `create-new-feature.md` | `mason-workflows.md` | ✅ Migrated |
| `session-init.md` | N/A | ⚠️ Agent-specific |
| `feature-gen.md` | `mason-workflows.md` | ✅ Migrated |

### 3. Patterns → Architecture Docs

| .agents/patterns/ | .kiro/steering/ | Status |
|------------------|-----------------|--------|
| `mvi-patterns.md` | `mvi-architecture.md` | ✅ Migrated |
| `clean-architecture.md` | `mvi-architecture.md` | ✅ Merged |

### 4. Skills → Workflows

| .agents/skills/ | .kiro/steering/ | Status |
|----------------|-----------------|--------|
| `create_new_feature/` | `mason-workflows.md` | ✅ Migrated |
| `api_integration/` | `mvi-architecture.md` | ✅ Documented |
| `json_to_freezed_model/` | `project-conventions.md` | ✅ Documented |
| `setup_variants/` | N/A | ⚠️ Build-specific |

## Key Differences

### .agents Folder (AI Agent Specific)
- **Purpose**: AI agent automation and context
- **Audience**: AI agents (Claude, Jules, etc.)
- **Format**: Detailed step-by-step instructions
- **Execution**: Automated workflows and skills
- **Location**: `.agents/`

### .kiro Folder (Kiro IDE Integration)
- **Purpose**: Kiro IDE configuration and steering
- **Audience**: Developers + Kiro IDE
- **Format**: Steering files (auto-included context)
- **Execution**: Spec-driven development
- **Location**: `.kiro/`

## Steering Files Created

### 1. project-conventions.md
**Migrated from**: `.agents/rules/critical-rules.md`, `.agents/rules/project-conventions.md`

**Contains**:
- Import conventions (full package paths)
- Freezed model patterns
- One object per file rule
- Retrofit client conventions
- Enum dot shorthands
- Theme usage rules
- Localization rules
- MVI single entry point
- File naming conventions
- Code generation commands

### 2. mvi-architecture.md
**Migrated from**: `.agents/patterns/mvi-patterns.md`, `.agents/rules/tech-stack.md`

**Contains**:
- MVI flow diagram
- Action/State/Event patterns
- BLoC implementation
- Page implementation
- Clean Architecture layers
- Dependency rules
- Common patterns (pagination, optimistic updates)
- Testing patterns

### 3. mason-workflows.md
**Migrated from**: `.agents/workflows/create-new-feature.md`, `.agents/skills/create_new_feature/`

**Contains**:
- Available Mason bricks
- Decision tree for brick selection
- Step-by-step workflows
- Common patterns
- Best practices
- Troubleshooting

### 4. flutter-bloc-patterns.md
**Status**: Legacy (kept for compatibility)

**Note**: This file is now superseded by:
- `project-conventions.md` (conventions)
- `mvi-architecture.md` (architecture)
- `mason-workflows.md` (workflows)

## What Stays in .agents

The following remain in `.agents` as they are AI agent-specific:

### 1. Agent Context
- `.agents/contexts/project_state.md` - Project memory
- `.agents/contexts/active_context.md` - Session scratchpad

### 2. Agent Personas
- `.agents/personas/architect.md` - Design role
- `.agents/personas/tech_lead.md` - QC role
- `.agents/personas/qa_engineer.md` - Testing role

### 3. Agent Workflows
- `.agents/workflows/session-init.md` - Session initialization
- `.agents/workflows/melos-sync.md` - Melos operations
- `.agents/workflows/secrets-env.md` - Secrets management

### 4. Agent Skills
- `.agents/skills/api_integration/` - API automation
- `.agents/skills/json_to_freezed_model/` - JSON parsing
- `.agents/skills/setup_variants/` - Build variants
- `.agents/skills/copy_secure_configurations/` - Config copying

### 5. Agent Configuration
- `.agents/config.json` - AI model optimization
- `.agents/JULES_GUIDE.md` - Master agent index
- `.agents/skills_manifest.md` - Skills index

## Integration Points

### How .agents and .kiro Work Together

```
Developer Request
       ↓
   Kiro IDE
       ↓
   ┌─────────────────┐
   │ .kiro/steering/ │ ← Auto-included context
   └─────────────────┘
       ↓
   AI Agent (Claude/Jules)
       ↓
   ┌─────────────────┐
   │ .agents/skills/  │ ← Automation workflows
   └─────────────────┘
       ↓
   Code Generation
```

### Workflow Example: Create New Feature

1. **Developer**: "Create wallet feature"
2. **Kiro**: Includes steering files automatically
   - `project-conventions.md` (rules)
   - `mvi-architecture.md` (patterns)
   - `mason-workflows.md` (generation)
3. **AI Agent**: Reads `.agents/skills/create_new_feature/`
4. **Execution**:
   - Runs `mason make mvi_feature --feature_name wallet`
   - Implements following steering file rules
   - Uses patterns from architecture docs
5. **Result**: Feature created following all conventions

## Usage Guidelines

### When to Use .kiro
- Creating feature specs
- Following architecture patterns
- Understanding conventions
- Learning project structure
- Implementing features manually

### When to Use .agents
- Automating repetitive tasks
- AI agent-driven development
- Complex multi-step workflows
- Build and deployment automation
- Session management

### When to Use Both
- Feature development (specs + automation)
- API integration (patterns + skills)
- Code generation (conventions + Mason)
- Quality assurance (rules + testing)

## Migration Benefits

### 1. Better IDE Integration
- Steering files auto-included in Kiro
- Context-aware suggestions
- Consistent rule enforcement

### 2. Clearer Separation
- Development rules in `.kiro`
- Automation in `.agents`
- No duplication

### 3. Improved Discoverability
- Single source of truth (INDEX.md)
- Clear navigation (README.md)
- Quick start guide (QUICK_START.md)

### 4. Spec-Driven Development
- Structured feature planning
- Requirements → Design → Tasks
- Property-based testing
- Incremental implementation

## Backward Compatibility

### .agents Files Still Work
All existing `.agents` files remain functional:
- Skills can still be triggered
- Workflows still execute
- Personas still available
- Context still maintained

### No Breaking Changes
- Existing AI agent workflows unchanged
- Skills reference updated docs
- Patterns point to steering files
- Rules consolidated but accessible

## Next Steps

### For Developers
1. Read [.kiro/INDEX.md](.kiro/INDEX.md)
2. Review [.kiro/QUICK_START.md](.kiro/QUICK_START.md)
3. Follow steering files for development
4. Use `.agents` skills for automation

### For AI Agents
1. Read [.agents/JULES_GUIDE.md](../.agents/JULES_GUIDE.md)
2. Reference `.kiro/steering/` for rules
3. Use `.agents/skills/` for automation
4. Maintain context in `.agents/contexts/`

### For Project Maintenance
1. Update steering files (not .agents rules)
2. Keep .agents skills for automation
3. Add new specs to `.kiro/specs/`
4. Document patterns in steering files

## Summary

| Aspect | .agents | .kiro |
|--------|--------|-------|
| **Purpose** | AI automation | IDE configuration |
| **Audience** | AI agents | Developers + IDE |
| **Content** | Skills, workflows | Rules, patterns |
| **Format** | Step-by-step | Steering files |
| **Usage** | Automation | Development |
| **Status** | Active | Active |

Both folders work together to provide:
- ✅ Consistent development patterns
- ✅ Automated workflows
- ✅ Clear documentation
- ✅ IDE integration
- ✅ AI agent support

---

**Migration Date**: 2026-01-22  
**Status**: ✅ Complete  
**Compatibility**: ✅ Backward compatible  
**Next Review**: As needed
