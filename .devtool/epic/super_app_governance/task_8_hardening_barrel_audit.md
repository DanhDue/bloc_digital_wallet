---
id: "task_8_hardening_barrel_audit"
status: "done"
priority: "medium"
assignee: null
epic: "super_app_governance"
dueDate: null
created: "2026-08-26T10:00:00.000Z"
modified: "2026-08-27T01:14:18.000Z"
completedAt: "2026-08-27T01:14:18.000Z"
labels: ["governance", "hardening", "ci"]
order: "a8"
---
# Task 8: Hardening — barrel audit & whitelist removal

Epic: [super_app_governance](../epic/super_app_governance/super_app_governance.en.md)

## Requirement Analysis
By the end of Task 7, most known cross-feature-import violations are resolved — **except `onboard→settings`, which Task 6 found does NOT fit this epic's scope** (it's a business-logic/DTO dependency, not navigation-shaped; see Task 6's redefined scope and the epic ledger). So `scripts/module_boundary_whitelist.txt` will have exactly **one** remaining entry, not zero, at the start of this task. This closing task hardens what's left: confirm every feature package's public barrel still only exports `domain/**`/`presentation/**`/DI-init/router (never `data/**`/`*_impl.dart`), tighten the CI Gate's deep-import check accordingly, and **keep** the whitelist file (with its one remaining, documented entry) rather than deleting it — the gate's whitelist-lookup mechanism itself is still needed and correct, it just isn't empty.

## Relevant Files & Context Pointers
- Every feature package's barrel: `packages/{authentication,onboard,wallet,transaction,trends,scanner,settings}/lib/{name}.dart`.
- `scripts/check_module_boundaries.sh` — do NOT remove the whitelist-lookup branch (still needed for the remaining `onboard→settings` entry); only tighten/verify the deep-import check.
- `scripts/module_boundary_whitelist.txt` — confirm it contains exactly `onboard→settings` (and nothing else) at the start of this task; add a comment above that line noting it's an accepted, out-of-epic-scope exception (reference Task 6's ledger entry), not forgotten cleanup. Do not delete this file.
- `.gitlab-ci.yml` — no structural change, just confirm the script still runs in `CIChecking`.

## Design Rationale
This is the "close the loop" task from the source spec's Phase 3 — it doesn't migrate any new package (that already happened via Tasks 6 and 7), it audits and locks in what's already true. See the source spec's "DI / export discipline" section for the exact rule being enforced.

## TDD Adaptation
Audit + config-tightening, not new behavior:
1. For each of the 7 feature packages, `grep` its barrel file for any export path under `data/` or matching `*_impl.dart` — must find none.
2. Confirm `scripts/module_boundary_whitelist.txt` contains exactly one entry, `onboard→settings` — not zero, per Task 6's redefined scope. Add a documenting comment above it.
3. Leave the whitelist-lookup branch in `check_module_boundaries.sh` in place (still functionally needed); only verify/tighten the deep-import check path.
4. Re-run the fixture tests from Task 3 against the script to confirm they still pass unchanged.

## Definition of Done (DoD)
- [ ] All 7 feature package barrels confirmed clean (no `data/**`/`*_impl.dart` exports).
- [ ] `scripts/module_boundary_whitelist.txt` contains exactly `onboard→settings`, with a comment explaining it's an accepted out-of-epic-scope exception (not stale/forgotten).
- [ ] `check_module_boundaries.sh`'s whitelist mechanism intact and still correctly gates only that one entry; Task 3's fixture tests still pass against it.
- [ ] CI pipeline green on the current `develop` with the gate as-is.

## Dependencies & Blockers
Blocked by [Task 6](task_6_migrate_settings_pilot.md) (redefined — confirmed `onboard→settings` stays whitelisted, not resolved by this epic) and [Task 7](task_7_relocate_shell.md) (must resolve the five `home→*` entries before this task's audit).

## References & Rollback
- Source spec: [Phase 3 — Remaining packages](../epic/super_app_governance/2026-08-26-super-app-governance-design.md#migration-plan-incremental).
- Rollback: restore `module_boundary_whitelist.txt` (even empty) and the whitelist-lookup branch in the script — no functional risk either way since it was already passing unconditionally at this point.
