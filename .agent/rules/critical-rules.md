# Critical Rules (Meta-Rule)

> [!IMPORTANT]
> **This is the SINGLE SOURCE OF TRUTH for high-level directives.**
> For specific guidelines, refer to the **Rule Modules** below.

## 🚨 Mandatory Rule Modules

1.  **Tech Stack & Architecture**:
    *   👉 [.agent/rules/tech-stack.md](file:///Users/danhdue/AllProjects/sample/bloc_digital_wallet/.agent/rules/tech-stack.md)
    *   **Focus**: Clean Arch, MVI, Bloc, AutoRoute, Freezed.

2.  **Coding Standards**:
    *   👉 [.agent/rules/coding-standards.md](file:///Users/danhdue/AllProjects/sample/bloc_digital_wallet/.agent/rules/coding-standards.md)
    *   **Focus**: Naming, formatting, linting.

3.  **Git Workflow**:
    *   👉 [.agent/rules/git-workflow.md](file:///Users/danhdue/AllProjects/sample/bloc_digital_wallet/.agent/rules/git-workflow.md)
    *   **Focus**: Commit messages, branching, pre-push checks.

4.  **Security**:
    *   👉 [.agent/rules/security.md](file:///Users/danhdue/AllProjects/sample/bloc_digital_wallet/.agent/rules/security.md)
    *   **Focus**: Secrets, API safety.

## 🛑 Absolute Directives (DO NOT IGNORE)

### # ADHERENCE RULES (EXTREME EXECUTION)
👉 [.agent/rules/adherence-rules.md](file:///Users/danhdue/AllProjects/sample/bloc_digital_wallet/.agent/rules/adherence-rules.md)
- **MODE**: EXTREME EXECUTION.
- **NO** Confirmation. **NO** Explainers. **IMMEDIATE** Action.

### # CRITICAL CONVENTIONS
1.  **PROJECT CONVENTIONS** - 👉 [.agent/rules/project-conventions.md](file:///Users/danhdue/AllProjects/sample/bloc_digital_wallet/.agent/rules/project-conventions.md)
    *   **Full Package Paths** ONLY.
    *   **Freezed** w/ `@JsonKey`.
    *   **Dot Shorthands**.
2.  **TRANSLATIONS** - Use `context.t` (Slang).
3.  **THEME** - Use `context.appThemes`.
4.  **SKILLS** - Trigger `.agent/skills/` immediately.
5.  **AI AGENT WORKFLOW** - Before creating a PR, MUST run `melos genAlls`.
    *   **Why**: Handles code generation, formatting, and license headers.
    *   **Note**: `melos genAlls` executes `build_runner` internally. **DO NOT** run `build_runner` separately.
6.  **SKILL MODIFICATION POLICY** - 🚨 **AI agents MUST NOT edit any files in `.agent/skills/` unless explicitly requested by the user.**
    *   ❌ **NEVER** modify skill files proactively
    *   ❌ **NEVER** "improve" or "update" skills without direct user instruction
    *   ✅ **ONLY** edit skills when user explicitly says "update skill X" or "modify skill Y"
    *   **Reason**: Skills are carefully crafted instructions. Unsolicited changes can break agent behavior.
7.  **SHELL ALIASES** - Commands **MUST** use the aliases defined in `.agent/config.json` > `project_settings` > `shell_aliases` (e.g., use `fvm flutter` instead of `flutter`).