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

## 🛠️ Skill Triggers

- **API Integration**: Triggered by CURL, JSON response, or "integrate API" requests. Use `.agent/skills/api_integration/SKILL.md`.
- **Model Generation**: Triggered by JSON and "generate models" requests. Use `.agent/skills/json_to_freezed_model/SKILL.md`.
- **Feature Creation**: Triggered by "add/create feature" requests. Use `.agent/skills/create_new_feature/SKILL.md`.

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