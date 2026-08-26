---
id: "task_16_hardening_barrel_audit"
status: "backlog"
priority: "medium"
assignee: null
epic: "super_app_governance"
dueDate: null
created: "2026-08-26T10:00:00.000Z"
modified: "2026-08-26T10:00:00.000Z"
completedAt: null
labels: ["governance", "hardening", "ci"]
order: "a16"
---
# Task 16: Hardening — barrel audit & whitelist removal

Epic: [super_app_governance](../epic/super_app_governance/super_app_governance.en.md)

## Requirement Analysis
By the end of Task 15, all known cross-feature-import violations are resolved and `scripts/module_boundary_whitelist.txt` should be empty. This closing task hardens what's left: confirm every feature package's public barrel still only exports `domain/**`/`presentation/**`/DI-init/router (never `data/**`/`*_impl.dart`), tighten the CI Gate's deep-import check accordingly, and remove the now-empty whitelist file so the gate becomes unconditional.

## Relevant Files & Context Pointers
- Every feature package's barrel: `packages/{authentication,onboard,wallet,transaction,trends,scanner,settings}/lib/{name}.dart`.
- `scripts/check_module_boundaries.sh` — remove the whitelist-lookup branch once the file is empty, so any deep-import or cross-feature import fails unconditionally.
- `scripts/module_boundary_whitelist.txt` — delete once confirmed empty.
- `.gitlab-ci.yml` — no structural change, just confirm the (now-simplified) script still runs in `CIChecking`.

## Design Rationale
This is the "close the loop" task from the source spec's Phase 3 — it doesn't migrate any new package (that already happened via Tasks 14 and 15), it audits and locks in what's already true. See the source spec's "DI / export discipline" section for the exact rule being enforced.

## TDD Adaptation
Audit + config-tightening, not new behavior:
1. For each of the 7 feature packages, `grep` its barrel file for any export path under `data/` or matching `*_impl.dart` — must find none.
2. Confirm `scripts/module_boundary_whitelist.txt` is empty; delete it.
3. Simplify `check_module_boundaries.sh` to drop the whitelist-lookup branch (any match is now an unconditional failure).
4. Re-run the fixture tests from Task 11 against the simplified script to confirm they still pass.

## Definition of Done (DoD)
- [ ] All 7 feature package barrels confirmed clean (no `data/**`/`*_impl.dart` exports).
- [ ] `scripts/module_boundary_whitelist.txt` deleted.
- [ ] `check_module_boundaries.sh` simplified to unconditional failure on any match; Task 11's fixture tests still pass against it.
- [ ] CI pipeline green on the current `develop` with the simplified gate.

## Dependencies & Blockers
Blocked by [Task 14](task_14_migrate_settings_pilot.md) and [Task 15](task_15_relocate_shell.md) — the whitelist must actually be empty before this task's removal step makes sense.

## References & Rollback
- Source spec: [Phase 3 — Remaining packages](../epic/super_app_governance/2026-08-26-super-app-governance-design.md#migration-plan-incremental).
- Rollback: restore `module_boundary_whitelist.txt` (even empty) and the whitelist-lookup branch in the script — no functional risk either way since it was already passing unconditionally at this point.
