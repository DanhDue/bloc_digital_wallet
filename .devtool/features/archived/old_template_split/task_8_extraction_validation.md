---
id: "task_8_extraction_validation"
status: "todo"
priority: "high"
assignee: null
epic: "template_flutter"
dueDate: null
created: "2026-08-29T00:00:00.000Z"
modified: "2026-08-29T00:00:00.000Z"
completedAt: null
labels: ["worktree", "validation"]
order: "a8"
---
# Task 8: Worktree Setup & End-to-End Validation

Epic: [template_flutter](../epic/template_flutter/template_flutter.en.md)

## Requirement Analysis
**Decision (2026-08-29): the template work happens on a git worktree of this same `bloc_digital_wallet`
repo**, not a separately `git init`'d repository — that earlier plan is deferred. This task sets up the
dedicated worktree/branch, and once Tasks 1–7 (and the native work from `template_android`/`template_ios`)
have landed on it, runs the full rename → generate → build loop end to end as the epic's acceptance test.

## Relevant Files & Context Pointers
- New git worktree, e.g.:
  ```bash
  git worktree add .worktrees/flutter_super_app_template -b epic/flutter-super-app-template
  ```
  (matches this repo's existing `.worktrees/` convention). All of Tasks 1–7's changes land as commits on
  the `epic/flutter-super-app-template` branch, checked out at that worktree path.
- Everything under the worktree's root except VCS/IDE-local state (`.git`, `.idea/`, `build/`, `.dart_tool/`,
  etc.) is in scope for the trimming work.

## Design Rationale
See design doc §6 item 1 and `template_flutter.en.md` "Working location" note. A worktree keeps the
trimming work fully isolated from `develop`/other branches (no risk of half-trimmed state leaking) while
avoiding the overhead of a second git history/remote until there's an actual need to distribute the
template as its own repo — that decision is deferred, not abandoned.

## TDD Checklist

**TDD Adaptation**: this task validates existing behavior end-to-end rather than introducing new testable behavior of its own — see the concrete validation steps below.

- [ ] Create the worktree/branch (see command above).
- [ ] Confirm Tasks 1–7 of this epic have landed as commits on the worktree's branch.
- [ ] From within the worktree, run `scripts/rename_project.sh` with a throwaway project name to validate
  the rename flow (this can be done on a disposable second worktree cloned off the first, so the
  epic's own worktree stays in its "clone-ready" trimmed state rather than being renamed itself).
- [ ] Run `melos bootstrap && melos genAlls`.
- [ ] Build and run on Android and iOS from the renamed validation worktree.
- [ ] Run `mason make pac_mvi_feature` for a throwaway feature and confirm it wires correctly (validates
  Task 4's hook fix in the final trimmed context).

## Definition of Done (DoD)
- [ ] The `flutter_super_app_template` worktree contains the fully trimmed tree from Tasks 1–7 (and, once
  available, the native work from `template_android`/`template_ios`).
- [ ] A disposable rename-validation pass (script run on a throwaway copy) builds and runs on both
  platforms with zero manual fixups.
- [ ] `mason make pac_mvi_feature` on the validation copy produces a correctly-wired package.
- [ ] `melos run analyze`, `melos run test`, and `./scripts/check_module_boundaries.sh` all pass on the
  worktree.

## Dependencies & Blockers
- **Dependencies**: [Task 1](task_1_trim_package_inventory.md)–[Task 7](task_7_rename_script.md) of this epic, plus the native work of `template_android`/`template_ios` for a fully representative validation (if those epics aren't done yet, validate the Flutter/Dart half only and re-run once native lands).
- **Blockers**: None.

## References & Rollback
- **References**: [flutter_super_app_template.en.md](../epic/flutter_super_app_template/flutter_super_app_template.en.md), design doc §6.
- **Rollback Plan**: `git worktree remove` the worktree and delete its branch if the approach needs to restart; no impact on `develop` or other branches.
