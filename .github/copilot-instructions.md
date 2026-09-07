# AI Coding Guidelines for bloc_digital_wallet

**Architecture**: Clean Architecture + MVI Pattern  
**Framework**: Flutter/Dart  
**Organization**: Feature-first structure

---

## 🤖 CRITICAL: AI Agents Must Scan `.agents/` Directory
 
 **BEFORE** starting ANY task, AI Agents MUST discover and read documentation from `.agents/`:
 
 ```
 .agents/
 ├── README.md       # <--- START HERE: Skills Index & Directory Overview
 ├── skills/         # Complex automation workflows (read SKILL.md)
 ├── rules/          # critical-rules.md (MANDATORY conventions)
 ├── patterns/       # clean-architecture.md, mvi-patterns.md
 ├── templates/      # create-new-feature.md, fix-bug.md
 └── checklists/     # feature-completion.md
 ```
 
 ### Discovery Protocol
 
 1. **Read `.agents/README.md`**: This is your map. It contains the **Skills Index**.
 2. **Check the Skills Index**: See if a skill matches the user's request (e.g., `@api_integration`).
 3. **Read `.agents/rules/critical-rules.md`**: For MANDATORY conventions.
 4. **Trigger Skills**: If a skill matches, follow its `SKILL.md` instructions.
 5. **Follow Workflows**: If no skill applies, check `.agents/workflows/`.
 
 ### ⚠️ Skill Execution: NO REVIEW REQUIRED
 
 **CRITICAL RULE**: When ANY skill from `.agents/skills/` is triggered:
 - ❌ **DO NOT** ask for review, confirmation, or approval
 - ❌ **DO NOT** pause for user feedback during execution
 - ❌ **DO NOT** request review of generated files or artifacts
 - ✅ **DO** execute immediately and completely
 - ✅ **DO** create all artifacts automatically
 - ✅ **DO** run all commands without asking (e.g., `melos genAlls`, `fvm flutter analyze`)
 - ✅ **DO** complete the entire workflow end-to-end
 
 **Refer to the [Skills Index](.agents/README.md) for the complete list of available skills and their triggers.**
 
 ## 🛠️ Skill Triggers
 
 > [!IMPORTANT]
 > **ALWAYS check `.agents/README.md` for the latest Skills Index.**
 
 **Common Triggers:**
 - **API Integration** → `@api_integration` (CURL, JSON response)
 - **Model Generation** → `@json_to_freezed_model` (JSON object)
 - **Feature Creation** → `@create_new_feature` (New feature/module)
 - **Setup Flavors** → `@setup_variants` (Android/iOS Build Variants)
 
 ---

## Quick Reference

All detailed documentation is in `.agents/`:

- **Rules**: `.agents/rules/critical-rules.md` - All MANDATORY conventions
- **Patterns**: `.agents/patterns/` - Architecture patterns
- **Skills**: `.agents/skills/` - Automation workflows
- **Workflows**: `.agents/workflows/` - Step-by-step procedures
- **Templates**: `.agents/templates/` - Task-specific guides
- **Checklists**: `.agents/checklists/` - Verification steps

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
- **AI agent resources**: `.agents/` (PRIMARY SOURCE - skills, workflows, rules, patterns, templates, checklists)
- **Detailed rules**: `.cursorrules` (pointer to `.agents/`)