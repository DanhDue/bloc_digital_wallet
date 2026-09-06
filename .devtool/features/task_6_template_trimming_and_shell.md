---
id: "task_6_template_trimming_and_shell"
status: "todo"
priority: "high"
assignee: null
epic: "flutter_super_app_template"
dueDate: null
created: "2026-09-06T18:05:00.000Z"
modified: "2026-09-06T18:05:00.000Z"
completedAt: null
labels: ["architecture", "refactor", "cleanup"]
order: "a6"
---

# Task 6: Template Trimming & Host Shell Reconstitution

Epic: [flutter_super_app_template](../epic/flutter_super_app_template/flutter_super_app_template.en.md)

## Requirement Analysis
To transform the current banking/wallet repository into a reusable Flutter Super App Template, domain-specific digital wallet packages and assets must be purged, while the Host composition root (`lib/`) is reconstituted around a lightweight, generic 3-tab Shell.

Requirements:
1. Purge the 5 wallet domain packages:
   - `packages/authentication/`
   - `packages/onboard/`
   - `packages/wallet/`
   - `packages/transaction/`
   - `packages/trends/`
   - Remove their entries from root `pubspec.yaml` and `melos.yaml`.
2. Reconstitute `lib/shell/`:
   - Reconfigure `ShellPage` with a 3-tab layout: `Home` (lightweight stub dashboard page within shell), `Scanner` (embedding `features/scanner`), and `Settings` (embedding `features/settings`).
   - Default tab focus is set to `Settings`.
   - Remove the custom splash screen and `AuthNavigationInitializer`; app opens directly into `ShellPage`.
3. Update Composition Root wiring:
   - `lib/app_router.dart`: Retain only Shell, Settings, and Scanner route entries.
   - `lib/di/injection.dart`: Remove module initializations for deleted packages; keep Shell, Settings, and Scanner.
4. Clean Domain Assets:
   - Remove wallet-specific JSONs (`assets/jsons/test_wallets.json`, `user_object.json`), wallet lottie animations, and payment iconography.
   - Retain all 90 Slang locale translation files and the SF Compact Display font family.
5. Update CI Gate:
   - In `scripts/check_module_boundaries.sh`, update scan directories to inspect `features/*` and ensure no cross-feature imports exist.
   - Clear obsolete entries from `scripts/module_boundary_whitelist.txt`.

## Relevant Files & Context Pointers
- `lib/shell/shell_page.dart`
- `lib/app_router.dart`
- `lib/di/injection.dart`
- `pubspec.yaml`
- `melos.yaml`
- `scripts/check_module_boundaries.sh`
- `scripts/module_boundary_whitelist.txt`

## Design Rationale
Removing domain-specific code leaves behind a pristine, compile-ready Super App skeleton. Keeping `features/settings` provides a complete reference for Clean Architecture + MVI with real data, while `features/scanner` demonstrates an empty, ready-to-fill mini-app.
Applicable skill: `subagent-driven-development`.

## TDD Checklist
*TDD Adaptation:* Mass deletion of domain packages and shell refactoring.
- [ ] **PRE-CHECK**: Verify tests pass in `settings` and `core` prior to removal.
- [ ] **TRIM**:
  - [ ] Delete `packages/{authentication,onboard,wallet,transaction,trends}`.
  - [ ] Update root `pubspec.yaml` workspace list.
  - [ ] Update `lib/shell/shell_page.dart` to 3 tabs (Home, Scanner, Settings) with Settings as default.
  - [ ] Update `lib/app_router.dart` and `lib/di/injection.dart`.
  - [ ] Remove domain-specific assets while preserving 90 locales.
  - [ ] Update `scripts/check_module_boundaries.sh` and clear whitelist.
- [ ] **VERIFY**:
  - [ ] Run `melos bootstrap`.
  - [ ] Run `melos genAlls`.
  - [ ] Run `melos run analyze` -> 0 errors.
  - [ ] Run `fvm flutter test` across all remaining packages and root host.
  - [ ] Run `scripts/check_module_boundaries.sh` -> PASS.

## Definition of Done (DoD)
1. Repository contains only 8 infrastructure packages in `packages/` and 2 features in `features/` (`settings`, `scanner`).
2. Host app opens directly to `ShellPage` on the Settings tab.
3. Zero references to deleted packages remain in `lib/`, `pubspec.yaml`, or scripts.
4. `melos genAlls`, `dart analyze`, and `scripts/check_module_boundaries.sh` all pass cleanly.

## Dependencies & Blockers
- Blocked by: [Task 1](task_1_monorepo_restructuring.md), [Task 2](task_2_pac_mvi_feature_brick.md)
- Blocks: [Task 7](task_7_obsolete_cleanups.md), [Task 8](task_8_rename_project_brick_and_validation.md)

## References & Rollback
- Source Spec: [2026-09-06-flutter-super-app-template-design.md](../epic/flutter_super_app_template/2026-09-06-flutter-super-app-template-design.md) §3.3 & §4.1
- Rollback: `git checkout` the branch before package deletion.
