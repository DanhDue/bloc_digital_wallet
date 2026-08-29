---
id: "task_3_asset_locale_cleanup"
status: "todo"
priority: "medium"
assignee: null
epic: "template_flutter"
dueDate: null
created: "2026-08-29T00:00:00.000Z"
modified: "2026-08-29T00:00:00.000Z"
completedAt: null
labels: ["assets", "localization"]
order: "a3"
---
# Task 3: Asset & Locale Cleanup

Epic: [template_flutter](../epic/template_flutter/template_flutter.en.md)

## Requirement Analysis
Remove digital-wallet-domain-specific assets while explicitly keeping the full 90-locale localization setup and the SF Compact Display font family, per the finalized decision (no trimming of locales or fonts — only wallet-specific content goes).

## Relevant Files & Context Pointers
- `assets/jsons/test_wallets.json`, `assets/jsons/user_object.json` — delete (wallet-domain test fixtures).
- `assets/images/`, `assets/lotties/` — audit and remove anything wallet/transaction/scanner-domain-specific (card art, wallet icons, transaction lotties); keep generic/placeholder assets.
- `assets/locales/*.i18n.json` (90 files) — **keep all**, no changes.
- `assets/fonts/SF_Compact_Display_*.ttf` — **keep**, no changes (per decision: license risk accepted, not this epic's concern).
- `assets/colors/colors.xml` — keep structure; audit for wallet-brand-specific color names only if trivially identifiable, otherwise leave as-is (not worth deep auditing for a template).
- Package-level `assets/` under `packages/scanner/` (post Task 1 regeneration) inherits the brick's placeholder assets already — no action needed here.

## Design Rationale
See `flutter_super_app_template.en.md` §"Applying it" and design doc §4.3. Locale/font trimming was explicitly decided against — keeping 90 locales means any new project can drop in translations without touching `slang.yaml` structure; keeping SF Compact avoids an unnecessary font-swap decision this epic isn't scoped to make.

## TDD Checklist

**TDD Adaptation**: structural cleanup/rewiring with no new business logic to drive with a failing test — RED/GREEN/REFACTOR does not apply. Verified instead via the concrete steps below plus `melos run analyze`/`melos run test` for regressions.

- [ ] Delete `assets/jsons/test_wallets.json`, `assets/jsons/user_object.json`.
- [ ] Audit `assets/images/` and `assets/lotties/` for wallet-domain content; delete.
- [ ] Run `melos genAlls` to confirm asset generation (`assets.gen.dart`) still succeeds after deletions.
- [ ] Confirm `assets/locales/` still has all 90 `*.i18n.json` files (no accidental deletion).

## Definition of Done (DoD)
- [ ] No wallet/transaction/scanner-domain image, lottie, or JSON fixture remains under `assets/`.
- [ ] `assets/locales/` still contains 90 locale files; `fvm dart run slang` succeeds.
- [ ] `fluttergen -c pubspec.yaml` succeeds with no dangling asset references.

## Dependencies & Blockers
- **Dependencies**: None (can run in parallel with [Task 1](task_1_trim_package_inventory.md)/[Task 2](task_2_rebuild_host_shell.md)).
- **Blockers**: None.

## References & Rollback
- **References**: [flutter_super_app_template.en.md](../epic/flutter_super_app_template/flutter_super_app_template.en.md).
- **Rollback Plan**: `git revert`; assets are binary/text files with no downstream code generation side effects beyond `melos genAlls`, safe to restore wholesale.
