---
id: "task_2_rebuild_host_shell"
status: "todo"
priority: "high"
assignee: null
epic: "template_flutter"
dueDate: null
created: "2026-08-29T00:00:00.000Z"
modified: "2026-08-29T00:00:00.000Z"
completedAt: null
labels: ["host", "shell", "router", "di"]
order: "a2"
---
# Task 2: Rebuild Host Shell, Router, DI

Epic: [template_flutter](../epic/template_flutter/template_flutter.en.md)

## Requirement Analysis
With `authentication`/`onboard`/`wallet`/`transaction`/`trends` removed (Task 1), the Host `lib/` still references them in the router, DI, localization wiring, and the splash flow. This task rebuilds `lib/shell/` around exactly 3 tabs (home stub, scanner, settings), removes the custom splash entirely (native Flutter splash instead), and makes `settings` the landing tab.

## Relevant Files & Context Pointers
- `lib/app_router.dart` — remove `auth`/`onboard`/`wallet`/`transaction`/`trends` imports, exports, router instances, routes; keep `ShellRoute` + `settings`/`scanner` routers; `ShellRoute` becomes `initial: true`.
- `lib/di/injection.dart` — remove the same modules' `configureModuleDependencies` calls.
- `lib/shell/shell_page.dart`, `shell_bloc.dart`, `shell_state.dart`, `shell_action.dart`, `shell_event.dart`, `widgets/custom_bottom_nav_bar.dart` — reduce to 3 tabs; add a new `home` stub page (plain placeholder widget, lives in `lib/shell/widgets/` or a new `lib/shell/tabs/home_stub_page.dart`); default/focused tab index = settings.
- `lib/core/app_initializer/auth_navigation_initializer.dart` — no more auth to navigate to; delete or stub with a comment explaining how to re-enable when a project adds auth.
- `lib/core/localization/app_translation_providers.dart`, `lib/core/app_initializer/localization_initializer.dart` — remove `onboard`/`authentication`/`wallet`/`transaction`/`trends` translation provider entries; keep `settings`/`scanner`/`core`/`ui_kit`.
- `lib/main.dart` — remove any splash-specific wiring if present (verify none remains after `onboard` deletion).

## Design Rationale
See design doc §4.2. The Shell is the centerpiece of the super-app-governance architecture (Host composes Mini Apps as tabs) — kept at 3 tabs specifically so the template still demonstrates that pattern instead of collapsing to a single screen. `home` is a stub (no package) because it has no reusable content; `scanner` is an empty package specifically to prove the composition pattern works with a second real package, not just `settings`.

## TDD Checklist

**TDD Adaptation**: structural cleanup/rewiring with no new business logic to drive with a failing test — RED/GREEN/REFACTOR does not apply. Verified instead via the concrete steps below plus `melos run analyze`/`melos run test` for regressions.

- [ ] Remove deleted-feature imports/exports/routes from `app_router.dart`; set `ShellRoute` as `initial: true`.
- [ ] Remove deleted-feature `configureModuleDependencies` calls from `injection.dart`.
- [ ] Rewrite `lib/shell/*` for 3 tabs (home stub / scanner / settings), settings focused by default.
- [ ] Add the `home` stub page.
- [ ] Delete or stub `auth_navigation_initializer.dart`; remove its registration from `AppInitializer` if applicable.
- [ ] Trim `app_translation_providers.dart`/`localization_initializer.dart` to `settings`/`scanner`/`core`/`ui_kit` only.
- [ ] `flutter run` boots directly into the Shell with Settings focused, no custom splash screen.

## Definition of Done (DoD)
- [ ] App launches to native Flutter splash, then directly to Shell with Settings tab active.
- [ ] `melos run analyze` on the Host app passes with zero errors.
- [ ] No remaining import of `authentication`/`onboard`/`wallet`/`transaction`/`trends` anywhere under `lib/`.

## Dependencies & Blockers
- **Dependencies**: [Task 1](task_1_trim_package_inventory.md) (packages must already be removed).
- **Blockers**: None.

## References & Rollback
- **References**: [flutter_super_app_template.en.md §4](../epic/flutter_super_app_template/flutter_super_app_template.en.md), design doc §4.2.
- **Rollback Plan**: `git revert`; Shell/router/DI files are self-contained, no external migration needed to undo.
