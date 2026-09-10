---
id: "task_20_phase5_docs_sync"
status: "done"
priority: "medium"
assignee: null
epic: "flutter_super_app_template"
dueDate: null
created: "2026-09-09T09:51:07.000Z"
modified: "2026-09-09T11:55:00.000Z"
completedAt: "2026-09-09T11:55:00.000Z"
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
- [x] **UPDATE**:
  - [x] `2026-09-06-…-design.md`: §3.1 dir tree + §3.3 annotate `logger_native_bridge`/`native_security` as Flutter SPM + FactoryKit; §4.3 replace the `ios/` podspec tree with the SPM `ios/{{name}}/Package.swift` + `Sources/{{name}}/{Plugin,Container,Platform,Domain,Data,Presentation}` layout + a "iOS DI (Phase 5)" callout; §4.3 "Self-contained" rule updated (Android constructor injection / iOS per-plugin FactoryKit `SharedContainer`); §4.4 `pac_add_native_ui` iOS steps → SPM paths + closure-based factory + "no `Package.swift` edit"; §8 verification rows 5–7 → SPM commands/criteria.
  - [x] Epic HLD `.en.md` + `.vi.md`: Status → "Phase 5 complete … Deferred: Phase 2". Architecture subgraph / Use Cases O3-O4 / sequence diagram / Rollout Phase 5 / risks / Kanban rows were already added during epic-designer + task_14 and match the shipped code.
  - [x] Brick README: `bricks/pac_native_plugin/__brick__/.../README.md` rewritten in task_17 (SPM-only requirement, `{{Name}}Container` workflow, test override). `pac_add_native_ui` has no README (unchanged).
  - [x] `docs/getting-started/create-new-project-from-template.{en,vi}.md`: the `pac_add_native_ui` "patches … Podfile" line → "SPM layout, no Podfile change"; Step 4 `flutter config --enable-swift-package-manager` was added in task_13.
- [x] **VERIFY**:
  - [x] `grep -rn "podspec\|ios/Classes" docs .devtool/epic/flutter_super_app_template` → remaining hits are the hybrid host's `setup_build_variants` Podfile (still real — 3rd-party pods) and a Troubleshooting `pod install --repo-update` entry (still valid for the hybrid host); nothing stale for native-plugin *scaffolding*.
  - [x] `.en.md` / `.vi.md` structurally identical (same section list, same diagram nodes, same Phase 5 Kanban table).
  - [x] Every `mason make …` / `flutter build ios` path in the updated docs matches Phase 5 spec §11 and was actually run in tasks 13–19.
  - [x] Task 14 spike returned **GO** (no podspec fallback) — all docs reflect the go path.

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
