---
id: "task_6_ci_simplification"
status: "todo"
priority: "medium"
assignee: null
epic: "template_flutter"
dueDate: null
created: "2026-08-29T00:00:00.000Z"
modified: "2026-08-29T00:00:00.000Z"
completedAt: null
labels: ["ci"]
order: "a6"
---
# Task 6: CI Config Sync (Old CI Kept As a Sample)

Epic: [template_flutter](../epic/template_flutter/template_flutter.en.md)

## Requirement Analysis
**Decision (2026-08-29): `.gitlab-ci.yml` is kept as-is**, including the `secureFiles`/
`google-services.json`/`GoogleService-Info.plist` copy steps and `melos buildIPA` — as a worked reference
sample a new project adapts to its own secrets/signing, rather than being stripped to a minimal skeleton.
This narrows the task to what's actually broken by Task 1's package removal: the module-boundary CI gate's
config must stay accurate to the trimmed package set, or it silently checks packages that no longer exist.

## Relevant Files & Context Pointers
- `.gitlab-ci.yml` — **no structural changes**. Only addition: wire in the `native_lint`/`native_format`
  melos scripts once `template_android`/`template_ios` land (tracked here as a follow-up note, not blocking
  this task's completion if those epics aren't done yet).
- `scripts/check_module_boundaries.sh` — the `FEATURE_PACKAGES=(authentication onboard wallet transaction
  trends scanner settings)` array must shrink to `(settings scanner)` to match Task 1's trimmed package set.
- `scripts/module_boundary_whitelist.txt` — remove the `onboard→settings` entry (both packages no longer
  coexist in the trimmed set).

## Design Rationale
See design doc §4.6 (updated 2026-08-29) and §6 item 3. Firebase secrets and IPA signing steps are
project-specific by nature — keeping them as a reference sample (rather than deleting them, as the earlier
draft of this task proposed) gives a new project a concrete, working example to adapt instead of an empty
placeholder. The `FEATURE_PACKAGES`/whitelist sync is unrelated to that decision — it's required regardless,
since the module-boundary gate must reflect which packages actually exist.

## TDD Checklist

**TDD Adaptation**: structural cleanup/rewiring with no new business logic to drive with a failing test — RED/GREEN/REFACTOR does not apply. Verified instead via the concrete steps below plus `melos run analyze`/`melos run test` for regressions.

- [ ] Confirm `.gitlab-ci.yml` requires no edits beyond the native-lint hook-in (deferred if native epics
  aren't done yet).
- [ ] Update `FEATURE_PACKAGES` in `check_module_boundaries.sh` to `(settings scanner)`.
- [ ] Remove the `onboard→settings` line from `module_boundary_whitelist.txt`.
- [ ] Run `./scripts/check_module_boundaries.sh` locally against the trimmed `packages/` tree and confirm
  it passes with zero violations.

## Definition of Done (DoD)
- [ ] `.gitlab-ci.yml` is unchanged in structure from the pre-trim version (verified by diff), aside from
  the native-lint addition once available.
- [ ] `module_boundary_whitelist.txt` no longer references `onboard`.
- [ ] `check_module_boundaries.sh` passes clean against the trimmed package tree.

## Dependencies & Blockers
- **Dependencies**: [Task 1](task_1_trim_package_inventory.md) (package set must already be trimmed for `FEATURE_PACKAGES` to be accurate).
- **Blockers**: None.

## References & Rollback
- **References**: [flutter_super_app_template.en.md](../epic/flutter_super_app_template/flutter_super_app_template.en.md), design doc §4.6, §6.
- **Rollback Plan**: `git revert`; CI config only, no code impact.
