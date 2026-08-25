---
id: "task_6_settings_ui"
status: "todo"
priority: "medium"
assignee: null
epic: "logging-refactor"
dueDate: null
created: "2026-08-25T19:00:00.000Z"
modified: "2026-08-25T19:00:00.000Z"
completedAt: null
labels: ["ui", "settings", "tdd"]
order: "a6"
---
# Task 6: Settings UI — Module & Appender Toggles

Epic: [logging_refactor](../epic/logging_refactor/logging_refactor.en.md)

## Requirement Analysis
QA/Dev need a runtime UI to mute noisy modules on the local Talker screen, and Ops/QA need a separate, clearly distinct control to fully disable a telemetry backend (Datadog/Otel) at runtime. Both must persist across app restarts.

## Relevant Files & Context Pointers
- `packages/settings/lib/presentation/settings/` — existing Settings screen/bloc to extend.
- `packages/settings/lib/data/` — existing local persistence layer (secure storage) for the new `logging.module_toggles` and `logging.appender_toggles` keys.
- `packages/logger/lib/d3nexus_logger.dart` — exposes `setModuleEnabled`/`setAppenderEnabled` this UI calls into.
- `packages/settings/test/` — existing test directory for bloc/widget tests.

## Design Rationale
**Two visually distinct sections, one persistence pattern**: module toggles (debug convenience) live in a standard Settings section; appender toggles (production-impacting) live in a separate "Advanced/Telemetry" section, so a QA engineer can't accidentally disable Datadog while trying to mute a noisy module's local logs. Both persist through the existing `packages/settings` storage layer rather than introducing a new persistence mechanism.

Relevant project skills: `frontend-developer` and `mobile-uiux-promax` (`.agent/skills/`) for this repo's Settings screen UI conventions; `i18n-localization` since new toggle labels need translation entries.

## TDD Checklist
- [ ] **RED**: Write bloc tests for loading persisted toggles on init, toggling a module, and toggling an appender (asserting the correct `D3NexusLogger` method is called and the new state is persisted). Write widget tests for the module-toggle list and the Advanced/Telemetry appender-toggle section rendering and reacting to taps.
- [ ] **GREEN**: Implement the bloc events/states and UI to pass the tests, wired to `D3NexusLogger.setModuleEnabled`/`setAppenderEnabled`.
- [ ] **REFACTOR**: Extract shared toggle-row widget if module and appender toggle rows end up duplicating layout code.

## Definition of Done (DoD)
- [ ] Bloc and widget test coverage for both toggle sections.
- [ ] Toggles persist across app restart (verified in integration or bloc test with a fake persisted store).
- [ ] New UI strings added to the i18n translation files (see `i18n-localization` skill).

## Dependencies & Blockers
- **Dependencies**: Blocked by [Task 3](task_3_log_manager.md) (`setModuleEnabled`/`setAppenderEnabled` must exist on `D3NexusLogger`).

## References & Rollback
- **References**: Epic HLD — [Module Enable/Disable & Appender Enable/Disable sections](../../../docs/superpowers/specs/2026-08-25-logging-module-design.md).
- **Rollback Plan**: Revert this task's commit; toggles simply won't be user-facing yet, `D3NexusLogger` still defaults every module/appender to enabled.
