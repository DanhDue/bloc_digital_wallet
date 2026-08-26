---
id: "task_14_migrate_settings_pilot"
status: "todo"
priority: "high"
assignee: null
epic: "super_app_governance"
dueDate: null
created: "2026-08-26T10:00:00.000Z"
modified: "2026-08-26T16:51:29.000Z"
completedAt: null
labels: ["migration", "pilot", "settings", "onboard"]
order: "a14"
---
# Task 14: Migrate pilot package `settings` (`onboard→settings`)

Epic: [super_app_governance](../epic/super_app_governance/super_app_governance.en.md)

## Requirement Analysis
`settings` is imported directly by two packages today: `onboard` (a genuine push-navigation after onboarding completes) and `home` (an `IndexedStack` tab embed). This task migrates only the `onboard→settings` case, since it's the one that actually fits `DeepLinkRoutes` (a pushed route) — `home→settings` is a tab embed, not a pushed route, and is out of scope here; it's resolved together with `home`'s other four tab embeds in Task 15. This is deliberately the smallest possible slice that proves the new `platform` mechanism end-to-end (DeepLinkRoutes at minimum, AppEventBus if a concrete cross-feature signal need is found during implementation) before the pattern is relied on for the larger Task 15/16 migrations.

## Relevant Files & Context Pointers
- `packages/onboard/lib/presentation/splash/splash_page.dart` — already uses `DeepLinkRoutes`/`FeaturePublicRoutes` for splash routing per Task 9; locate and update its post-onboarding navigation call to `settings` to also go through `DeepLinkRoutes.settingsRoute` instead of any direct `settings` package import.
- `packages/onboard/pubspec.yaml` — remove the `settings` dependency once no direct import remains (`app_platform: {path: ../platform}` is already present from Task 9's onboard usage — see Task 9's naming ruling: pubspec key is `app_platform`, imported `as platform`).
- `scripts/module_boundary_whitelist.txt` — remove the `onboard→settings` line.
- `packages/settings/` — no structural change expected; only the caller side changes.

## Design Rationale
Reference the source spec's corrected Phase 1 description and Task 9's `DeepLinkRoutes` mechanism. If, during implementation, a genuine need surfaces for `settings` to signal `onboard` back (not just one-way navigation), use `AppEventBus` (Task 10) rather than reintroducing a direct import — but don't invent a speculative event just to exercise the bus; only add one if there's a real signal to carry.

## TDD Checklist
- [ ] **RED**: Write/extend a widget or navigation test asserting `onboard`'s post-onboarding flow pushes `DeepLinkRoutes.settingsRoute` (via a router mock), not a concrete `SettingsPage`/`settings` package type.
- [ ] **GREEN**: Update `splash_page.dart` (or wherever the post-onboarding navigation call lives) to use `DeepLinkRoutes.settingsRoute`; remove the direct `settings` import and pubspec dependency.
- [ ] **REFACTOR**: Confirm no remaining `import 'package:settings/` in `packages/onboard/`.

## Definition of Done (DoD)
- [ ] `packages/onboard` no longer imports `settings` directly (`grep -r "package:settings" packages/onboard/lib` returns nothing).
- [ ] `onboard→settings` removed from `scripts/module_boundary_whitelist.txt`.
- [ ] `./scripts/check_module_boundaries.sh` passes with one fewer whitelist entry.
- [ ] Manually verified: reintroducing a direct `settings` import in `onboard` makes the CI Gate fail (verify once, then revert/don't commit it).
- [ ] Manual smoke test: onboarding flow still correctly navigates to Settings.
- [ ] `home→settings` remains whitelisted and untouched — confirmed out of scope for this task.

## Dependencies & Blockers
Blocked by [Task 9](task_9_create_platform_package.md) (needs `DeepLinkRoutes`) and [Task 11](task_11_ci_module_boundary_gate.md) (needs the whitelist mechanism to remove an entry from).

## References & Rollback
- Source spec: corrected [Phase 1 — Pilot section](../epic/super_app_governance/2026-08-26-super-app-governance-design.md#migration-plan-incremental).
- Rollback: re-add `onboard→settings` to the whitelist and revert `splash_page.dart`'s navigation call — low risk, single call site.
