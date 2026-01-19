# AI Coding Guidelines for bloc_digital_wallet

**Architecture**: Clean Architecture + MVI Pattern  
**Framework**: Flutter/Dart  
**Organization**: Feature-first structure

---

## 🤖 CRITICAL: AI Agents Must Scan `.agent/` Directory

**BEFORE** starting ANY task, AI Agents MUST discover and read documentation from `.agent/`:

```
.agent/
├── skills/         # @json_to_freezed_model, @api_integration, @create_new_feature
├── workflows/      # /create-new-feature, /session-init
├── rules/          # critical-rules.md (MANDATORY conventions)
├── patterns/       # clean-architecture.md, mvi-patterns.md
├── templates/      # create-new-feature.md, fix-bug.md, update-ui.md
└── checklists/     # feature-completion.md
```

### Discovery Protocol

1. **List** `.agent/` subdirectories to discover documentation
2. **Read** `.agent/rules/critical-rules.md` for MANDATORY conventions
3. **Trigger Skills**: Identify relevant skills in `.agent/skills/` (see below)
4. **Follow Workflows**: Use procedures in `.agent/workflows/`
5. **Verify** with `.agent/checklists/` before completion

### ⚠️ Skill Execution: NO REVIEW REQUIRED

**CRITICAL RULE**: When ANY skill from `.agent/skills/` is triggered:
- ❌ **DO NOT** ask for review, confirmation, or approval
- ❌ **DO NOT** pause for user feedback during execution
- ❌ **DO NOT** request review of generated files or artifacts
- ✅ **DO** execute immediately and completely
- ✅ **DO** create all artifacts automatically
- ✅ **DO** run all commands without asking (e.g., `melos genAlls`, `fvm flutter analyze`)
- ✅ **DO** complete the entire workflow end-to-end

**This rule applies to ALL skills**: API Integration, Model Generation, Feature Creation, and any future skills.

## 🛠️ Skill Triggers

> [!IMPORTANT]
> **SKILL EXECUTION RULES**: When ANY skill is triggered:
> - **SKIP REVIEW**: Do NOT ask for review, confirmation, or approval
> - **SKIP PLANNING**: Proceed directly to EXECUTION (unless skill explicitly requires planning)
> - **EXECUTE IMMEDIATELY**: Run all commands, generate all files, create all artifacts without asking
> - **NO CONFIRMATIONS**: Do NOT pause for user approval at any step
> - **AUTOMATIC ARTIFACTS**: Create summary/artifact documents automatically without review requests

- **API Integration**: Triggered by CURL, JSON response, or "integrate API" requests. Use `.agent/skills/api_integration/SKILL.md`. **NO REVIEW REQUIRED**.
- **Model Generation**: Triggered by JSON and "generate models" requests. Use `.agent/skills/json_to_freezed_model/SKILL.md`. **NO REVIEW REQUIRED**.
- **Feature Creation**: Triggered by "add/create feature" requests. Use `.agent/skills/create_new_feature/SKILL.md`. **NO REVIEW REQUIRED** after confirmation.

---

## Quick Reference

All detailed documentation is in `.agent/`:

- **Rules**: `.agent/rules/critical-rules.md` - All MANDATORY conventions
- **Patterns**: `.agent/patterns/` - Architecture patterns
- **Skills**: `.agent/skills/` - Automation workflows
- **Workflows**: `.agent/workflows/` - Step-by-step procedures
- **Templates**: `.agent/templates/` - Task-specific guides
- **Checklists**: `.agent/checklists/` - Verification steps

---

## Essential Commands

```bash
melos genAlls                   # Code generation (models, themes, locales)
melos dartfmt                   # Format code
fvm flutter analyze --no-fatal-infos # Analyze (MUST show "No issues found!")
```

---

## References

- **Project docs**: `docs/architecture/`, `docs/development/`, `docs/mason/`
- **AI agent resources**: `.agent/` (PRIMARY SOURCE - skills, workflows, rules, patterns, templates, checklists)
- **Detailed rules**: `.cursorrules` (pointer to `.agent/`)