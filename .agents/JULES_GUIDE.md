# 🧠 JULES_GUIDE - Master Agent Index

Welcome, Jules! This is your **Single Source of Truth** for working on the `bloc_digital_wallet` project. Follow these links to master the project's architecture, rules, and automation.

---

## 🚨 Critical Rules (Mental Model)

Before writing a single line of code, you MUST be aware of these foundational rules:

1.  **Meta-Rule**: [critical-rules.md](file:///Users/danhdue/AllProjects/sample/bloc_digital_wallet/.agents/rules/critical-rules.md) - The high-level directive.
2.  **Strict Conventions**: [project-conventions.md](file:///Users/danhdue/AllProjects/sample/bloc_digital_wallet/.agents/rules/project-conventions.md)
    *   **Full Package Paths** ONLY.
    *   **One Object, One File** for Freezed models.
    *   **Explicit baseUrl** for Retrofit clients.
3.  **Freezed Everywhere**: All @freezed classes MUST import `foundation.dart` + `freezed_annotation`.
4.  **Adherence**: [adherence-rules.md](file:///Users/danhdue/AllProjects/sample/bloc_digital_wallet/.agents/rules/adherence-rules.md) - Extreme execution protocols.
5.  🚨 **Skill Protection**: **NEVER** edit files in `.agents/skills/` unless explicitly requested. See [config.json > skill_modification_policy](file:///Users/danhdue/AllProjects/sample/bloc_digital_wallet/.agents/config.json) and [critical-rules.md #6](file:///Users/danhdue/AllProjects/sample/bloc_digital_wallet/.agents/rules/critical-rules.md).

---

## 🤖 AI Configuration (Model Opt)

*   **Model Config**: [config.json](file:///Users/danhdue/AllProjects/sample/bloc_digital_wallet/.agents/config.json) - Optimization rules.

---

## 🛠️ AI Skills (Automation)

Trigger these skills for repetitive or complex tasks. They are your primary "autopilot".

| Skill | Trigger | Description |
| :--- | :--- | :--- |
| **Complete API Integration** | `@api_integration` | [SKILL.md](file:///Users/danhdue/AllProjects/sample/bloc_digital_wallet/.agents/skills/api_integration/SKILL.md) |
| **New Feature Gen** | `@create_new_feature` | [SKILL.md](file:///Users/danhdue/AllProjects/sample/bloc_digital_wallet/.agents/skills/create_new_feature/SKILL.md) |
| **JSON to Freezed** | `@json_to_freezed_model` | [SKILL.md](file:///Users/danhdue/AllProjects/sample/bloc_digital_wallet/.agents/skills/json_to_freezed_model/SKILL.md) |
| **Setup Variants** | `@setup_variants` | [SKILL.md](file:///Users/danhdue/AllProjects/sample/bloc_digital_wallet/.agents/skills/setup_variants/SKILL.md) |

---

## 🏗️ Architecture & Patterns

Consistency is key. Refer to these to maintain structural integrity.

- **MVI Guide**: [mvi-patterns.md](file:///Users/danhdue/AllProjects/sample/bloc_digital_wallet/.agents/patterns/mvi-patterns.md) - Action → BLoC → State/Event.
- **Clean Architecture**: [clean-architecture.md](file:///Users/danhdue/AllProjects/sample/bloc_digital_wallet/.agents/patterns/clean-architecture.md) - Layer separation.
- **Tech Stack**: [tech-stack.md](file:///Users/danhdue/AllProjects/sample/bloc_digital_wallet/.agents/rules/tech-stack.md) - Official project libraries.

---

## ⚙️ Workflows (Manual Procedures)

When a skill doesn't apply, follow these step-by-step guides.

- **Session Start**: [session-init.md](file:///Users/danhdue/AllProjects/sample/bloc_digital_wallet/.agents/workflows/session-init.md)
- **Feature Gen**: [feature-gen.md](file:///Users/danhdue/AllProjects/sample/bloc_digital_wallet/.agents/workflows/feature-gen.md)
- **Melos Sync**: [melos-sync.md](file:///Users/danhdue/AllProjects/sample/bloc_digital_wallet/.agents/workflows/melos-sync.md)
- **Secrets Management**: [secrets-env.md](file:///Users/danhdue/AllProjects/sample/bloc_digital_wallet/.agents/workflows/secrets-env.md)

---

## 🎭 Personas (Role Focus)

Switch modes to ensure high-quality output based on the task:
- [Architect](file:///Users/danhdue/AllProjects/sample/bloc_digital_wallet/.agents/personas/architect.md) - Design & Strategy.
- [Tech Lead](file:///Users/danhdue/AllProjects/sample/bloc_digital_wallet/.agents/personas/tech_lead.md) - QC & Refactoring.
- [QA Engineer](file:///Users/danhdue/AllProjects/sample/bloc_digital_wallet/.agents/personas/qa_engineer.md) - Testing & Edge Cases.

---

## 🧠 Persistent Memory

- **Project State**: [project_state.md](file:///Users/danhdue/AllProjects/sample/bloc_digital_wallet/.agents/contexts/project_state.md)
- **Quick Reference**: [quick-reference.md](file:///Users/danhdue/AllProjects/sample/bloc_digital_wallet/.agents/references/quick-reference.md)

---

**Last Synced**: 2026-01-21
**Status**: Active & Optimized for Jules ✅
