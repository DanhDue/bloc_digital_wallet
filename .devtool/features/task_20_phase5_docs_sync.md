---
id: "task_20_phase5_docs_sync"
status: "todo"
priority: "medium"
assignee: null
epic: "flutter_super_app_template"
dueDate: null
created: "2026-09-09T09:51:07.000Z"
modified: "2026-09-09T09:51:07.000Z"
completedAt: null
labels: ["docs", "phase-5"]
order: "a20"
---

# Task 20: Phase 5 Docs Sync — Design Spec, Epic HLD, Brick READMEs

Epic: [flutter_super_app_template](../epic/flutter_super_app_template/flutter_super_app_template.en.md)

## Requirement Analysis
Once Tasks 13–19 land, the template's own reference docs must describe the SPM + FactoryKit reality so a developer cloning the template is not misled by the old podspec/constructor-injection descriptions.

Requirements:
1. **`.devtool/epic/flutter_super_app_template/2026-09-06-flutter-super-app-template-design.md`**:
   - §3.1 / §3.3 — note `logger_native_bridge` and `native_security` are Flutter SPM + FactoryKit; the "8 infrastructure packages" wording stays (count unchanged) but the two native ones are annotated.
   - §4.3 — replace the `ios/` podspec + `Classes/**` layout with the SPM layout (`ios/{{name}}/Package.swift` + `Sources/{{name}}/{Platform,Domain,Data,Presentation}`); state "iOS DI = FactoryKit per-plugin `SharedContainer`; SPM-only, no `.podspec`".
   - §4.4 — `pac_add_native_ui` iOS steps updated to the SPM `Sources/` paths.
   - §8 — verification table rows for the native-plugin bricks updated to the SPM commands/criteria from the Phase 5 spec §11.
2. **Epic HLD** (`flutter_super_app_template.en.md` first, then `.vi.md` in sync): confirm the Phase 5 additions (architecture subgraph annotation, Use Cases O3/O4, sequence diagram iOS paths, Phase 5 rollout entry, risks, Kanban rows) match what actually shipped; adjust any drift. Flip the epic **Status** if Phase 5 is complete.
3. **Brick READMEs**: `bricks/pac_native_plugin/__brick__/.../README.md` and `bricks/pac_add_native_ui/` docs — SPM-only requirement, adding a dependency to `{{Name}}Container`, overriding in tests (cross-check against the Phase 5 spec §12).
4. Grep the repo for stale mentions of native-plugin `.podspec` / `ios/Classes/` in `docs/`, `README.md`, `AGENTS.md`, `.agents/skills/*/SKILL.md` and fix or annotate.

## Relevant Files & Context Pointers
- `.devtool/epic/flutter_super_app_template/2026-09-06-flutter-super-app-template-design.md`
- `.devtool/epic/flutter_super_app_template/flutter_super_app_template.en.md` / `.vi.md`
- `.devtool/epic/flutter_super_app_template/2026-09-09-ios-native-plugin-factory-di-spm-design.md` (source of truth for the new state)
- `bricks/pac_native_plugin/__brick__/packages/{{name.snakeCase()}}/README.md`
- `bricks/pac_add_native_ui/` docs
- `README.md`, `AGENTS.md`, `docs/`

## Design Rationale
Docs are part of the template's product surface — a clone that reads "podspec" while the brick emits `Package.swift` wastes the next developer's time. Doing this as a terminal task (after the code lands) avoids documenting a design that then shifts during implementation (e.g. if the Task 14 spike forces the `native_security` podspec fallback).
Applicable skills: `verification-before-completion`.

## TDD Checklist
*TDD Adaptation:* Documentation-only. No tests; verification is a consistency review against the shipped code.
- [ ] **UPDATE**: Apply items 1–4 above.
- [ ] **VERIFY**:
  - [ ] `grep -rn "podspec\|ios/Classes" docs .devtool/epic/flutter_super_app_template AGENTS.md README.md` returns nothing stale for native-plugin scaffolding (shipped-plugin history references may remain if clearly historical).
  - [ ] `.en.md` and `.vi.md` are structurally identical and factually equal (section count, diagram nodes, Kanban rows).
  - [ ] Every code path described (`mason make …`, `flutter build ios`) matches Phase 5 spec §11 and actually runs.
  - [ ] If the Task 14 spike forced the podspec fallback for `native_security`, every doc reflects that (not the go-path text).

## Definition of Done (DoD)
1. `2026-09-06-…-design.md` §3.1/§3.3/§4.3/§4.4/§8 describe the SPM + FactoryKit state.
2. Epic HLD (both languages) is in sync with shipped code; Status updated.
3. Brick READMEs document the SPM-only constraint and container workflow.
4. No stale `podspec`/`ios/Classes/` guidance for native-plugin scaffolding remains in template docs.

## Dependencies & Blockers
- Blocked by: [Task 15](task_15_migrate_logger_native_bridge_spm_factorykit.md), [Task 16](task_16_migrate_native_security_spm_factorykit.md), [Task 17](task_17_rewrite_pac_native_plugin_ios_spm.md), [Task 18](task_18_update_pac_add_native_ui_ios_spm.md), [Task 19](task_19_pac_rename_project_package_swift.md)
- Blocks: None (terminal task of Phase 5).

## References & Rollback
- Source Spec: [2026-09-09-ios-native-plugin-factory-di-spm-design.md](../epic/flutter_super_app_template/2026-09-09-ios-native-plugin-factory-di-spm-design.md) §12
- Rollback: docs-only — `git revert` the docs commit.
