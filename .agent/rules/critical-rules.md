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
5.  **AI AGENT WORKFLOW** - Before creating a PR, MUST run `melos genAlls` AND use `@pr-review` skill.
    *   **`melos genAlls`**: Handles code generation, formatting, and license headers.
    *   **`@pr-review` skill**: Runs code quality checks following OWASP, Clean Architecture, and security standards.
    *   **Note**: `melos genAlls` executes `build_runner` internally. **DO NOT** run `build_runner` separately.
6.  **SKILL MODIFICATION POLICY** - 🚨 **AI agents MUST NOT edit any files in `.agent/skills/` unless explicitly requested by the user.**
    *   ❌ **NEVER** modify skill files proactively
    *   ❌ **NEVER** "improve" or "update" skills without direct user instruction
    *   ✅ **ONLY** edit skills when user explicitly says "update skill X" or "modify skill Y"
    *   **Reason**: Skills are carefully crafted instructions. Unsolicited changes can break agent behavior.
7.  **SHELL ALIASES** - Commands **MUST** use the aliases defined in `.agent/config.json` > `project_settings` > `shell_aliases` (e.g., use `fvm flutter` instead of `flutter`).
8.  **FREEZED EVERYWHERE** - 🚨 **All data classes MUST use `@freezed` annotation.**
    *   **Applies to**:
        *   Data Models (`lib/features/*/data/models/`)
        *   Domain Entities (`lib/features/*/domain/entities/`)
        *   BLoC States (`lib/features/*/presentation/*/*_state.dart`)
        *   BLoC Events (`lib/features/*/presentation/*/*_event.dart`)
    *   **Required Imports**:
        ```dart
        import 'package:flutter/foundation.dart';
        import 'package:freezed_annotation/freezed_annotation.dart';
        ```
    *   **Rationale**: Ensures immutability, value equality, `copyWith` support, and `debugFillProperties` across all layers.
    *   **Pattern**:
        ```dart
        import 'package:flutter/foundation.dart';
        import 'package:freezed_annotation/freezed_annotation.dart';

        part 'my_model.freezed.dart';
        part 'my_model.g.dart';

        @freezed
        abstract class MyModel with _$MyModel {
          const MyModel._();
          const factory MyModel({...}) = _MyModel;
          factory MyModel.fromJson(Map<String, Object?> json) => _$MyModelFromJson(json);
        }
        ```