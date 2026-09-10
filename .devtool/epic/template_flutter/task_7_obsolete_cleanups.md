---
id: "task_7_obsolete_cleanups"
status: "done"
priority: "medium"
assignee: null
epic: "flutter_super_app_template"
dueDate: null
created: "2026-09-06T18:05:00.000Z"
modified: "2026-09-06T18:57:00.000Z"
completedAt: "2026-09-06T18:57:00.000Z"
labels: ["cleanup", "tooling"]
order: "a7"
---

# Task 7: Obsolete Bricks & Standalone Scripts Cleanup

Epic: [flutter_super_app_template](../epic/flutter_super_app_template/flutter_super_app_template.en.md)

## Requirement Analysis
The repository currently contains experimental and deprecated artifacts that clutter the developer experience:
1. Obsolete experimental Mason bricks: `bricks/sample`, `bricks/remove_sample`, `bricks/test_brick`.
2. Outdated epic design folders: `.devtool/epic/template_android` and `.devtool/epic/template_ios` (which attempted to generate standalone native projects from Flutter before the two independent native repositories were established).
3. Any scripts or references targeting standalone Android/iOS extraction.

Requirements:
1. Remove `bricks/sample`, `bricks/remove_sample`, and `bricks/test_brick`.
2. Remove their entries from `mason.yaml`.
3. Verify that the legacy `lib/features/` bricks (`mvi_feature`, `mvi_subfeature`, `remove_feature`, `remove_subfeature`) have `[DEPRECATED]` in their `brick.yaml` descriptions.
4. Clean up `.devtool/epic/template_android` and `.devtool/epic/template_ios`.
5. Ensure `mason.yaml` lists only the official supported bricks:
   - `pac_mvi_feature`, `pac_mvi_subfeature`, `remove_pac_feature`, `remove_pac_subfeature`
   - `pac_library`
   - `pac_native_plugin`
   - `pac_add_native_ui`
   - `pac_rename_project`
   - (Plus the 4 deprecated legacy monolith bricks).

## Relevant Files & Context Pointers
- `mason.yaml`
- `bricks/sample/`
- `bricks/remove_sample/`
- `bricks/test_brick/`
- `.devtool/epic/template_android/`
- `.devtool/epic/template_ios/`

## Design Rationale
A pristine template must not present dead-end or confusing commands to contributors. Cleaning out obsolete bricks keeps `mason list` focused on active capabilities.
Applicable skill: `systematic-debugging`.

## TDD Checklist
*TDD Adaptation:* File removal and configuration synchronization.
- [x] **CLEAN**:
  - [x] Delete `bricks/sample`, `bricks/remove_sample`, and `bricks/test_brick`.
  - [x] Update `mason.yaml` to unregister removed bricks.
  - [x] Delete `.devtool/epic/template_android` and `.devtool/epic/template_ios`.
- [x] **VERIFY**:
  - [x] Run `mason get`.
  - [x] Run `mason list` and confirm only active bricks and deprecated legacy bricks are displayed.
  - [x] Confirm no broken links or missing references in repository docs.

## Definition of Done (DoD)
1. `mason.yaml` contains zero broken or deleted brick references.
2. `mason get` executes with zero warnings or errors.
3. Obsolete experimental brick folders are removed from git tracking.

## Dependencies & Blockers
- Blocked by: [Task 6](task_6_template_trimming_and_shell.md)
- Blocks: [Task 8](task_8_rename_project_brick_and_validation.md)

## References & Rollback
- Source Spec: [2026-09-06-flutter-super-app-template-design.md](../epic/flutter_super_app_template/2026-09-06-flutter-super-app-template-design.md) §5
- Rollback: `git checkout` to restore deleted directories if needed.
