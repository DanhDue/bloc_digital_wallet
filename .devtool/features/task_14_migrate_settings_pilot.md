---
id: "task_14_migrate_settings_pilot"
status: "done"
priority: "high"
assignee: null
epic: "super_app_governance"
dueDate: null
created: "2026-08-26T10:00:00.000Z"
modified: "2026-08-26T18:50:32.000Z"
completedAt: "2026-08-26T18:50:32.000Z"
labels: ["migration", "pilot", "settings", "onboard", "redefined"]
order: "a14"
---
# Task 14: Migrate pilot package `settings` (`onboard→settings`) — REDEFINED

Epic: [super_app_governance](../epic/super_app_governance/super_app_governance.en.md)

## Requirement Analysis — original premise was wrong, redefined below

**Original premise (invalidated during implementation):** this task assumed `onboard`'s import of `settings` was "a genuine push-navigation after onboarding completes" that could be swapped onto `DeepLinkRoutes.settingsRoute`.

**What implementation actually found (verified independently by the orchestrator, not just the implementer's claim):** `packages/onboard/lib/presentation/splash/splash_page.dart` does not import `settings` at all — its post-health-check navigation already goes through `DeepLinkRoutes.homeRoute` (`splash_page.dart:135`), migrated by Task 9. There is no `SettingsPage`/`settingsRoute` reference anywhere in `packages/onboard/`, and git history confirms this route target has never been a raw `settings` import even before this epic. The actual `onboard→settings` import is in `splash_bloc.dart:14`, and it's a **business-logic/DTO dependency** (`BootstrapUseCase`, `FetchTranslationUseCase`, `SyncBootstrapResponse`, `BootstrapTranslationItem` — all `settings`-domain types), not navigation. Confirmed by the CI Gate itself: `./scripts/check_module_boundaries.sh` traces both real `onboard→settings` warnings to `splash_bloc.dart:14` and its generated DI registration — zero warnings trace to `splash_page.dart`.

**Why `DeepLinkRoutes`/`AppEventBus` don't fit:** `DeepLinkRoutes` is route constants only, no way to represent "call a use case, get a typed domain response back." `AppEventBus` is fire-and-forget broadcast pub/sub, wrong shape for the synchronous request/response `_performBootstrapAndHealthCheck` needs. Forcing either would mean inventing a speculative, awkward mechanism — exactly what this task's original Design Rationale warned against.

**Redefined scope:** this task is now a documentation-only closure, not a code migration:
1. Confirm (already done, see above) that no navigation-shaped coupling exists to migrate in `onboard`.
2. Confirm the pilot's actual validation goal — proving `DeepLinkRoutes` works end-to-end before Tasks 15/16 rely on it — was already satisfied by Task 9's own `splash_page.dart` → `DeepLinkRoutes.homeRoute` migration (implemented and reviewed as part of Task 9).
3. Leave `onboard→settings` in `scripts/module_boundary_whitelist.txt` — it stays whitelisted indefinitely within this epic's scope. A real fix (Dependency Inversion, following this codebase's existing `TokenRefresher` precedent — `abstract interface class` in `core`, `@LazySingleton(as: Interface)` implementation in `settings`, with the bootstrap+translation-sync orchestration logic relocated out of `splash_bloc.dart`) is a legitimate follow-up, but it's a real architectural decision (interface placement, logic relocation) out of this epic's current scope — not something to invent under a "smallest slice" pilot task.
4. Update this epic's spec/HLD Migration Plan and Task 16 to reflect that the whitelist will NOT end up empty at the end of this epic — one entry (`onboard→settings`) remains by design.

## Relevant Files & Context Pointers
- `packages/onboard/lib/presentation/splash/splash_bloc.dart` — read-only reference, confirms the real coupling (not touched, no code change).
- `packages/onboard/lib/presentation/splash/splash_page.dart` — read-only reference, confirms navigation already uses `DeepLinkRoutes.homeRoute` (not touched, no code change).
- `scripts/module_boundary_whitelist.txt` — no line removed; `onboard→settings` stays.
- `.devtool/features/task_16_hardening_barrel_audit.md` — updated (separately) to account for the whitelist not reaching zero entries.
- `.devtool/epic/super_app_governance/2026-08-26-super-app-governance-design.md` and the HLD (en/vi) — updated (separately) to correct the Migration Plan's Phase 1 description.

## Design Rationale
See the epic ledger (`.superpowers/sdd/super_app_governance.en/progress.md`, "Task 14: Ruling") for the full investigation and reasoning. This is a case of a task's premise being invalidated by what implementation actually found — handled per this epic's process by stopping, investigating, and ruling rather than forcing a fix that doesn't match reality.

## TDD Adaptation
No code changes, so RED/GREEN/REFACTOR doesn't apply. Verification is the investigation itself, already completed and independently double-checked:
1. Confirm `splash_page.dart` has zero `settings`/`SettingsPage`/`settingsRoute` references (`grep -rn "SettingsPage\|settingsRoute\|SettingsRoute" packages/onboard/` → no hits outside `splash_bloc.dart`'s unrelated business-logic import).
2. Confirm `splash_page.dart:135` navigates via `DeepLinkRoutes.homeRoute`.
3. Confirm `./scripts/check_module_boundaries.sh`'s two `onboard→settings` warnings both trace to `splash_bloc.dart:14`/its generated DI config, not to any navigation code.

## Definition of Done (DoD)
- [x] Confirmed (independently, not just implementer-claimed) that `onboard`'s post-onboarding navigation does not import `settings` and already uses `DeepLinkRoutes.homeRoute`.
- [x] Confirmed the real `onboard→settings` coupling is business-logic-shaped, not navigation-shaped, and out of this task's original scope.
- [x] `onboard→settings` remains in `scripts/module_boundary_whitelist.txt`, unchanged.
- [x] `home→settings` remains whitelisted and untouched — still out of scope for this task, per the original (still-valid) reasoning.
- [x] Epic spec/HLD Migration Plan and Task 16 updated to reflect the whitelist will not reach zero entries within this epic.
- [ ] ~~`packages/onboard` no longer imports `settings` directly~~ — dropped, premise invalidated.
- [ ] ~~Manual smoke test: onboarding flow navigates to Settings~~ — dropped, was never true; onboarding navigates to Home, always has.

## Dependencies & Blockers
Blocked by [Task 9](task_9_create_platform_package.md) (needed `DeepLinkRoutes` to evaluate whether it fit — it didn't, for this coupling) and [Task 11](task_11_ci_module_boundary_gate.md) (needed the whitelist/gate to confirm the real coupling's exact location).

## References & Rollback
- Source spec: corrected [Phase 1 — Pilot section](../epic/super_app_governance/2026-08-26-super-app-governance-design.md#migration-plan-incremental) (updated alongside this task).
- Epic ledger: `.superpowers/sdd/super_app_governance.en/progress.md`, "Task 14: Ruling" — full investigation record.
- Rollback: N/A — no code changes were made; nothing to roll back.
