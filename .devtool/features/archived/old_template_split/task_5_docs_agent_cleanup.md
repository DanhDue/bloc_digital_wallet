---
id: "task_5_docs_agent_cleanup"
status: "todo"
priority: "medium"
assignee: null
epic: "template_flutter"
dueDate: null
created: "2026-08-29T00:00:00.000Z"
modified: "2026-08-29T00:00:00.000Z"
completedAt: null
labels: ["docs", "agent-config"]
order: "a5"
---
# Task 5: Docs & `.agents`/AI-config Cleanup

Epic: [template_flutter](../epic/template_flutter/template_flutter.en.md)

## Requirement Analysis
Keep the Superpowers `.agents/` layer (rules/patterns/workflows are largely project-agnostic already), but scrub hard-coded `bloc_digital_wallet` references and reset session-specific state. Trim `.devtool/epic/` and `docs/` down to genuinely reusable architecture material. Consolidate the multi-IDE AI-assistant config sprawl to Claude Code + VS Code only.

## Relevant Files & Context Pointers
- `.agents/config.json`, `.agents/README.md`, `.agents/rules/*.md` — replace literal `bloc_digital_wallet` project-name references with a generic placeholder or the new template's name (coordinate with Task 7's rename script — decide whether this task hard-codes a placeholder now and the rename script updates it later, or leaves it templated).
- `.agents/contexts/project_state.md`, `.agents/contexts/active_context.md` — reset to empty/generic starting state.
- `.devtool/epic/` — keep only `flutter_super_app_template/` (this epic's own source spec) and `super_app_governance/` (the architecture the template is built on); delete `logging_refactor/` and `.devtool/features/` (project-specific execution history, not reusable).
- `docs/` — keep `architecture/`, `mason/`, `getting-started/`, `development/`; delete `docs/superpowers/specs`/`plans` (stale), `localization_analysis.md`, `implementation_guide.md`, `ORGANIZATION_PROPOSAL.md`.
- `.kiro/`, `.github/copilot-instructions.md`, `.cursorrules` — delete entirely.
- Keep `.agents/`, `.vscode/`, `.devcontainer/` (generic dev environment, only needs name updates via Task 7).

## Design Rationale
See `flutter_super_app_template.en.md` and design doc §4.5. The Superpowers `.agents/` layer is kept because its rules/patterns are architecture-level (Clean Architecture, MVI, code style) rather than digital-wallet-specific — removing it would strip real value from the template. `.devtool/epic/super_app_governance` is kept specifically as the authoritative "why the architecture looks like this" reference a new team inherits with the template.

## TDD Checklist

**TDD Adaptation**: structural cleanup/rewiring with no new business logic to drive with a failing test — RED/GREEN/REFACTOR does not apply. Verified instead via the concrete steps below plus `melos run analyze`/`melos run test` for regressions.

- [ ] Grep `.agents/` for `bloc_digital_wallet` and replace per the coordination decision above.
- [ ] Reset `.agents/contexts/*.md` to empty/generic templates.
- [ ] Delete `.devtool/epic/logging_refactor/` and `.devtool/features/`.
- [ ] Delete the listed stale `docs/` files/folders.
- [ ] Delete `.kiro/`, `.github/copilot-instructions.md`, `.cursorrules`.

## Definition of Done (DoD)
- [ ] `grep -r bloc_digital_wallet .agents/` returns no project-specific hits requiring a rename-script pass (or all remaining hits are confirmed to be handled by Task 7).
- [ ] `.devtool/epic/` contains only `flutter_super_app_template/` and `super_app_governance/`.
- [ ] `.kiro/`, `.github/copilot-instructions.md`, `.cursorrules` no longer exist.

## Dependencies & Blockers
- **Dependencies**: Coordinate wording with [Task 7](task_7_rename_script.md) (rename script) on which project-name references it auto-replaces vs. which this task leaves as manual placeholders.
- **Blockers**: None.

## References & Rollback
- **References**: [flutter_super_app_template.en.md](../epic/flutter_super_app_template/flutter_super_app_template.en.md), design doc §4.5.
- **Rollback Plan**: `git revert`; all deletions are documentation/config, fully recoverable from git history.
