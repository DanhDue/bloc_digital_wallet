---
id: "task_15_relocate_shell"
status: "backlog"
priority: "high"
assignee: null
epic: "super_app_governance"
dueDate: null
created: "2026-08-26T10:00:00.000Z"
modified: "2026-08-26T10:00:00.000Z"
completedAt: null
labels: ["migration", "shell", "architecture"]
order: "a15"
---
# Task 15: Relocate Shell out of `home`

Epic: [super_app_governance](../epic/super_app_governance/super_app_governance.en.md)

## Requirement Analysis
`packages/home` has no `domain/`/`data/` layers of its own — it is Shell/Host logic (tab index state, bottom-nav composition) misplaced inside a feature package. `home_page.dart` embeds `WalletPage()`, `TransactionPage()`, `ScannerPage()`, `TrendsPage()`, `SettingsPage()` directly as `IndexedStack` children, which is exactly the kind of static composition a real Host is allowed to do — the problem is only that it's happening inside a disguised "feature" instead of the actual Host (`lib/`). This task moves it to where it belongs, resolving the remaining 5 whitelist entries (`home→wallet/transaction/scanner/trends/settings`) as a side effect.

## Relevant Files & Context Pointers
- `packages/home/lib/presentation/home/home_bloc.dart`, `home_page.dart`, `home_action.dart`, `home_state.dart`, `home_event.dart` → move to `lib/shell/` and rename `Home*` → `Shell*`.
- `packages/home/lib/presentation/home/widgets/custom_bottom_nav_bar.dart` → move to `lib/shell/widgets/`.
- `lib/app_router.dart`, `lib/di/injection.dart` — remove `home` package wiring, add the moved Shell's own routing/DI entry (the root app already legitimately imports `wallet`/`transaction`/`scanner`/`trends`/`settings`, so `ShellPage`'s imports of them are correct once here).
- `packages/home/` — remove from `pubspec.yaml` workspace/dependencies and `melos.yaml` once the move is verified; delete the package directory.
- `scripts/module_boundary_whitelist.txt` — remove `home→wallet`, `home→transaction`, `home→scanner`, `home→trends`, `home→settings`.

## Design Rationale
See the source spec's "Host/Shell relocation" section. This is a pure move + rename, not a rewrite — `ShellPage`'s `IndexedStack` composition, tab-index `BLoC`, and bottom nav widget behave identically to `HomePage` today, just living in the Host's own `lib/` instead of a feature package. Do not add dashboard content or change tab behavior — that's explicitly out of scope (see epic Non-Goals).

## TDD Adaptation
This is a structural move of already-tested code (existing `home` package has its own test suite) plus a workspace/DI wiring change — RED/GREEN/REFACTOR doesn't add value here. Concrete verification steps instead:
1. Move files, rename identifiers, update imports; move/adapt the existing `packages/home/test/` suite alongside into `test/shell/` (or root `test/`) so coverage isn't lost.
2. Run `melos bootstrap` after removing `home` from the workspace — must succeed.
3. Run `flutter analyze` (root) — clean, no dangling `package:home/` references anywhere.
4. Manual smoke test: full bottom-nav flow (all 5 tabs render and switch correctly, back-press/exit-toast behavior from the original `HomeEvent` handling still works).

## Definition of Done (DoD)
- [ ] `packages/home` is deleted and removed from `pubspec.yaml`/`melos.yaml`.
- [ ] `lib/shell/` contains the relocated, renamed Shell code with its test suite passing.
- [ ] `home→wallet/transaction/scanner/trends/settings` all removed from `scripts/module_boundary_whitelist.txt`.
- [ ] `./scripts/check_module_boundaries.sh` passes with the whitelist now containing zero `home→*` entries.
- [ ] Manual smoke test of the full bottom-nav flow passes.
- [ ] `melos bootstrap` and `flutter analyze` both clean.

## Dependencies & Blockers
Blocked by [Task 9](task_9_create_platform_package.md) (root app / Shell may reference `platform` conventions going forward) and independently should land after [Task 14](task_14_migrate_settings_pilot.md) so the pilot pattern is proven before this larger move — not a hard technical blocker, but the intended sequencing per the source spec's Migration Plan.

## References & Rollback
- Source spec: [Phase 2 — Shell relocation](../epic/super_app_governance/2026-08-26-super-app-governance-design.md#migration-plan-incremental).
- Rollback: this is the highest-risk task in the epic (touches root app composition + deletes a package) — rollback via `git revert` of the move commit; keep the `packages/home` deletion and the Shell creation in a single commit specifically so revert is atomic.
