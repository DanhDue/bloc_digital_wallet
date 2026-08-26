---
id: "task_11_ci_module_boundary_gate"
status: "done"
priority: "high"
assignee: null
epic: "super_app_governance"
dueDate: null
created: "2026-08-26T10:00:00.000Z"
modified: "2026-08-26T18:13:20.000Z"
completedAt: "2026-08-26T18:13:20.000Z"
labels: ["ci", "governance", "tooling"]
order: "a11"
---
# Task 11: CI Gate — module boundary script

Epic: [super_app_governance](../epic/super_app_governance/super_app_governance.en.md)

## Requirement Analysis
Nothing today prevents a feature package from importing another feature package directly, or from deep-importing another package's internal `data/`/`*_impl.dart` files bypassing its public barrel — that's exactly how `home→{wallet,transaction,scanner,trends,settings}` and `onboard→settings` happened. This task adds an automated CI Gate that hard-blocks any *new* violation while allowing the known, pre-existing ones to pass via an explicit whitelist that shrinks as later tasks (14, 15, 16) migrate each package.

## Relevant Files & Context Pointers
- `scripts/check_module_boundaries.sh` (new).
- `scripts/module_boundary_whitelist.txt` (new) — seed with `home→wallet`, `home→transaction`, `home→scanner`, `home→trends`, `home→settings`, `onboard→settings`.
- `.gitlab-ci.yml` — add the script as a step in the existing `CIChecking` stage's `script:` list.
- Feature package roots to scan: `packages/{authentication,onboard,wallet,transaction,trends,scanner,settings}/lib/**/*.dart`. `home`/`platform` and infra packages (`core`, `network`, `ui_kit`, `framework`, `native_security`) are exempt from the feature-to-feature check.

## Design Rationale
Two checks in one script: (1) `import 'package:<other-feature>/'` where both sides are feature packages, matched against the whitelist; (2) deep-import of `package:<pkg>/data/` or any `*_impl.dart` path from outside `<pkg>` itself (no whitelist needed here — no known deep-import violations exist today per the barrel-export audit in the source spec). See the source spec's "CI Gate" section for the exact whitelist semantics: entries pass with a logged warning, anything else fails the build.

## TDD Adaptation
This is a standalone shell script, not app business logic, but it has clear pass/fail behavior to verify directly rather than via `bloc_test`:
1. Write two fixture directories under a scratch location: one with a deliberate unwhitelisted cross-feature import (script must exit non-zero), one clean (script must exit zero).
2. Run the script against the real repo as-is: the 6 seeded whitelist entries must pass with warnings, everything else must be silent/clean.
3. Temporarily reintroduce a non-whitelisted violation in a scratch branch to confirm the CI stage actually fails end-to-end, then revert.

## Definition of Done (DoD)
- [ ] `scripts/check_module_boundaries.sh` is executable and runs standalone (`./scripts/check_module_boundaries.sh`).
- [ ] Fixture tests (violation → non-zero exit, clean → zero exit) pass.
- [ ] Running against the current repo state exits zero (all 6 known violations whitelisted, nothing else flagged).
- [ ] `.gitlab-ci.yml`'s `CIChecking` stage runs the script and the pipeline stays green on the current commit.
- [ ] A deliberately reintroduced non-whitelisted violation makes the CI stage fail (verified once, then reverted).

## Dependencies & Blockers
None — independent of Tasks 9/10, can be done in parallel with them (both are Phase 0 foundation work).

## References & Rollback
- Source spec: [CI Gate section](../epic/super_app_governance/2026-08-26-super-app-governance-design.md#ci-gate).
- Rollback: remove the script's invocation from `.gitlab-ci.yml`'s `script:` list; the script file itself can stay unused with no effect on the pipeline.
