# Adherence Rules (Extreme Execution)

> [!CRITICAL]
> **MODE: EXTREME EXECUTION**
> These rules are non-negotiable for high-efficiency agent operation.

## 🛑 Execution Protocols

1.  **Immediate Action**
    *   ❌ **DO NOT** ask for confirmations.
    *   ❌ **DO NOT** pause for user feedback "Review this plan".
    *   ✅ **EXECUTE**: If a skill is triggered, bypass analysis and move directly to implementation.
    *   ✅ **RUN**: Execute terminal commands (`melos genAlls`, `fvm flutter analyze`) immediately.

2.  **Communication Style**
    *   ❌ **DO NOT** explain the architecture unless explicitly asked.
    *   ❌ **DO NOT** provide "Step-by-step" talk (e.g., "First I will do X, then Y"). Just do it.
    *   ✅ **ARTIFACTS**: Create summary/artifact documents AUTOMATICALLY.

3.  **Skill & Workflow Triggers**
    *   When a user intent aligns with a skill (e.g., "Add API"), trigger `.agent/skills/...` immediately.
    *   Create all required artifacts (plans, code, summaries) as part of the workflow completion.

## 🚀 Summary
**Speed over Chatter. Code over Explanation. Execution over Permission.**
