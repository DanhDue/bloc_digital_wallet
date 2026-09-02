---
id: "task_4_mason_bricks_cleanup"
status: "todo"
priority: "high"
assignee: null
epic: "template_flutter"
dueDate: null
created: "2026-08-29T00:00:00.000Z"
modified: "2026-08-29T00:00:00.000Z"
completedAt: null
labels: ["mason", "bricks"]
order: "a4"
---
# Task 4: Mason Bricks — Hook Fix (Old Bricks Kept As-Is)

Epic: [template_flutter](../epic/template_flutter/template_flutter.en.md)

## Requirement Analysis
**Decision (2026-08-29): the deprecated `lib/features/`-targeting bricks (`mvi_feature`, `mvi_subfeature`,
`remove_feature`, `remove_subfeature`, `sample`, `remove_sample`, `test_brick`) are kept, not deleted** —
even though they're currently unused (superseded by the package-per-feature `pac_*` bricks), a future
project might not adopt package-first organization and would need them. This narrows the task to the one
real bug Task 1's package removal introduces: `pac_mvi_feature`'s `post_gen.dart` hook hard-codes `onboard`
as the text anchor for every insertion point (root `pubspec.yaml`, `injection.dart`, `app_router.dart`,
translation providers, `AppUri`). Once `onboard` is deleted, those anchor-based string replacements
silently no-op instead of erroring, so every future `mason make pac_mvi_feature` run would produce an
unwired package.

## Relevant Files & Context Pointers
- `bricks/pac_mvi_feature/hooks/post_gen.dart` — every `_update*` function (`_updateRootPubspec`,
  `_updateInjection`, `_updateTranslationProviders`, `_updateLocalizationInitializer`, `_updateAppRouter`,
  `_updateFeaturePublicRoutes`, `_updateAppUri`) uses an `onboard`-based marker string. Replace each anchor
  with `settings` (the one surviving feature package) or, where more robust, a structural insertion (e.g.
  "insert after the last `import 'package:.*';` line" via the existing regex fallback already present in
  `_updateInjection`) instead of a name-specific string match.
- `bricks/pac_mvi_subfeature/`, `bricks/remove_pac_feature/`, `bricks/remove_pac_subfeature/` — audit for
  the same `onboard`-anchor pattern; fix identically if found.
- `mason.yaml` — no removals; leave the deprecated bricks' entries in place.
- `melos.yaml` — the `mason_make_feature`/`mason_make_subfeature`/`mason_remove_pac_feature`/
  `mason_remove_pac_subfeature` script descriptions may still say "deprecated" in comments; that's accurate
  and fine to leave — the bricks are deprecated in the sense of "not the current default," just not deleted.

## Design Rationale
See design doc §4.4 (updated 2026-08-29) and §6 item 2. The hook fix remains mandatory regardless of the
keep-vs-delete decision on the old bricks — it's a correctness bug this epic's own Task 1 introduces, not
optional cleanup. Fixing the anchor to `settings` (rather than inventing a new marker convention) keeps the
fix minimal and consistent with the brick's existing "known-good anchor package" pattern.

## TDD Checklist

**TDD Adaptation**: this is a bug fix in code-generation tooling (a Mason hook), not new application behavior — verified via a concrete before/after brick-generation run (see steps) rather than RED/GREEN/REFACTOR.

- [ ] In `pac_mvi_feature/hooks/post_gen.dart`, replace every `onboard`-based anchor string with
  `settings`'s equivalent line, verifying each function still finds its marker post-Task-1.
- [ ] Audit `pac_mvi_subfeature`/`remove_pac_feature`/`remove_pac_subfeature` hooks for the same pattern.
- [ ] Run `mason make pac_mvi_feature` end-to-end with a throwaway `name=test_feature` and confirm all 6
  insertion points (`pubspec.yaml`, `injection.dart`, `app_translation_providers.dart`,
  `localization_initializer.dart`, `app_router.dart`, `AppUri`) are correctly wired; then run
  `remove_pac_feature` to clean it back up.
- [ ] Confirm `mason list` still shows all 11 bricks (4 `pac_*` + 7 deprecated `lib/features/`-era ones) —
  no deletions.

## Definition of Done (DoD)
- [ ] A throwaway `mason make pac_mvi_feature` run produces a fully-wired package (verified against the 6
  insertion points above), with no silent no-op.
- [ ] `remove_pac_feature`/`remove_pac_subfeature` still round-trip cleanly after the anchor fix.
- [ ] No brick directory was deleted; `mason.yaml`'s brick list is unchanged in size.

## Dependencies & Blockers
- **Dependencies**: Should land before or alongside [Task 1](task_1_trim_package_inventory.md)'s `scanner` regeneration (Task 1 explicitly calls this out — sequence this task first, or hand-fix Task 1's wiring).
- **Blockers**: None.

## References & Rollback
- **References**: [flutter_super_app_template.en.md §3](../epic/flutter_super_app_template/flutter_super_app_template.en.md), design doc §4.4, §6.
- **Rollback Plan**: `git revert`; only `post_gen.dart` files are touched, no brick directories deleted.
