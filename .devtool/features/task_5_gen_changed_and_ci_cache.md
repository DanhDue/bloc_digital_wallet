---
id: "task_5_gen_changed_and_ci_cache"
status: "done"
priority: "medium"
assignee: null
epic: "super_app_governance"
dueDate: null
created: "2026-08-26T10:00:00.000Z"
modified: "2026-08-26T18:28:15.000Z"
completedAt: "2026-08-26T18:28:15.000Z"
labels: ["tooling", "ci", "build-performance"]
order: "a5"
---
# Task 5: `genChanged.sh` + `.dart_tool/` CI cache

Epic: [super_app_governance](../epic/super_app_governance/super_app_governance.en.md)

## Requirement Analysis
`scripts/genAlls.sh` regenerates all 13 packages + root app unconditionally on every run. `.gitlab-ci.yml`'s `cache:` block lists `.gradle`/`build`/`app/build`/`build-caches` but omits `.dart_tool/`, so `build_runner`'s own content-hash incremental cache is discarded every CI run even though nothing about it is git-diff-dependent. This task adds an opt-in local convenience script and a correctness-safe CI cache fix — kept deliberately separate, since a git-diff-based skip mechanism was considered and rejected for anything correctness-sensitive (see Design Rationale).

## Relevant Files & Context Pointers
- `scripts/genChanged.sh` (new).
- `scripts/genAlls.sh` — reference only, not modified.
- `.gitlab-ci.yml` — add `.dart_tool/` (root) and `packages/*/.dart_tool/` to `cache: paths:`, keyed by a hash of `pubspec.lock`.
- `scripts/githooks/pre-commit` — reference only, not modified (still calls full `melos genAlls`).

## Design Rationale
`genChanged.sh [ref]` wraps `melos exec --diff=<ref:-develop> --include-dependents -- fvm flutter pub run build_runner build --delete-conflicting-outputs` (plus the same slang/format steps `genAlls.sh` runs). It must ship with an inline usage comment explaining why it is local-only: a git diff proves *source* changed, it cannot prove generated output is currently in sync with source — if an earlier commit (even one already on `develop`) changed source without regenerating output, no later diff against any ref will ever catch that gap. This was flagged by the user during design (see source spec's "Approach E — rejected" and "Dev Scripts & Build Caching" sections) — do not wire this script into the pre-commit hook or CI. The `.dart_tool/` CI cache fix has no such gap: `build_runner` decides what to regenerate from content hashes of files actually present, not git history, so restoring cached `.dart_tool/build/` state and re-running is always correct, just faster when nothing changed.

## TDD Adaptation
Tooling/config change, no application business logic:
1. Make a throwaway local commit changing one package's source (`melos exec --diff=<ref>` resolves to a commit-to-commit `git diff`, so a merely staged/uncommitted change won't be picked up — verify this the first time you hit it, don't assume); run `genChanged.sh`; confirm only that package and its transitive dependents (via `--include-dependents`) regenerate; then discard the throwaway commit.
2. Run the CI pipeline twice on the same commit; confirm the second run cache-hits `.dart_tool/` and completes faster than the first.
3. Bump a dependency version in `pubspec.lock`; confirm the CI cache key changes and the next run is a cache miss (not silently reusing stale generated code against new dependency versions).
4. Confirm `scripts/githooks/pre-commit` is unmodified and still runs full `genAlls`.

## Definition of Done (DoD)
- [ ] `scripts/genChanged.sh` is executable, defaults to `develop` when no `ref` argument is given, and its usage comment documents the staleness-gap caveat.
- [ ] `.gitlab-ci.yml` caches `.dart_tool/` (root + per-package), keyed by `pubspec.lock` hash.
- [ ] A same-commit re-run of CI is measurably faster than a cold run.
- [ ] A `pubspec.lock` change correctly invalidates the cache.
- [ ] `scripts/githooks/pre-commit` and `scripts/genAlls.sh` are unchanged.

## Dependencies & Blockers
None — independent of Tasks 1–4, Phase 0 work.

## References & Rollback
- Source spec: [Dev Scripts & Build Caching section](../epic/super_app_governance/2026-08-26-super-app-governance-design.md#dev-scripts--build-caching), [Approach E — rejected](../epic/super_app_governance/2026-08-26-super-app-governance-design.md#alternatives-considered).
- Rollback: remove `genChanged.sh` and revert the `.gitlab-ci.yml` cache block — no effect on `genAlls.sh` or the pre-commit hook either way.
