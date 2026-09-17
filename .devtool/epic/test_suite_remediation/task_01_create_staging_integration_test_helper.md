---
id: "task_01_create_staging_integration_test_helper"
status: "todo"
priority: "high"
assignee: null
epic: "test_suite_remediation"
dueDate: null
created: "2026-09-17T14:40:00Z"
modified: "2026-09-17T14:40:00Z"
completedAt: null
labels: ["testing", "integration", "infrastructure"]
order: "a1"
---

# Task 01: Create Staging IntegrationTestHelper and Update LanguageTestHelper

Epic: [test_suite_remediation](test_suite_remediation.en.md)

## 1. Requirement Analysis
Running UI integration tests on Staging (`secureFiles/stg/environment-configs.json`) against Heroku causes severe cold-start delays (up to 45 seconds). The initial `POST /api/v1/settings/sync/bootstrap` triggers background OTA synchronization, leading to timeout failures during `pumpUntil` or `pumpAndSettle`.
This task introduces a dedicated `IntegrationTestHelper` that:
- Provides platform mocking (`setupPlatformMocks()`, `teardownPlatformMocks()`).
- Injects a `Dio` interceptor to intercept `bootstrap` requests on Staging and resolve immediately with `stale_translations: []` while preserving live network paths for critical user-initiated translation actions.
- Resets the `LocalizationManager` locale to `'en'` in `onDependenciesConfigured` before application boot.
- Provides robust, polling-based waiting routines (`pumpUntil`, `pumpUntilDisappeared`, `waitUntil`, `switchTab`).
- Refactors `LanguageTestHelper` to leverage `IntegrationTestHelper`.

## 2. Relevant Files & Context Pointers
- `integration_test/helpers/integration_test_helper.dart` (NEW)
- `integration_test/helpers/language_test_helper.dart` (MODIFY)
- `secureFiles/stg/environment-configs.json` (REFERENCE)

## 3. Design Rationale
- Centralizing mock and wait logic into `IntegrationTestHelper` prevents duplication across test suites.
- By intercepting only `POST /api/v1/settings/sync/bootstrap`, the app boots instantaneously into `ShellPage`, while live backend tests (e.g. Use Case 2 OTA Japanese download) continue to hit the real Heroku staging server E2E.
- Polling via `pumpUntil(100ms)` eliminates fragile fixed duration sleeps.

## 4. Impact Analysis & Blast Radius
- **Target Files & Symbols**: `IntegrationTestHelper`, `LanguageTestHelper`.
- **Downstream Callers**: `change_language_test.dart`, `language_edge_cases_test.dart`, `deep_link_flow_test.dart`.
- **Cross-Platform Bridges**: Pigeon `logger_native_bridge`, `AppLinks` method channels.
- **Target Test Coverage Threshold**: 100% compilation and pass rate in integration tests.

## 5. BDD Scenarios & Acceptance Criteria

### BDD SCENARIOS

#### Scenario 1: Clean Application Boot into Shell with Isolated English Locale
- **Tags**: `[Tier C - Integration]`, `[HappyPath]`
- **Given** the test runner initializes `IntegrationTestHelper.launchApp()`
- **And** platform mocks for PackageInfo, NativeLogHostApi, and AppLinks are active
- **When** the Flutter application initializes dependencies in `onDependenciesConfigured`
- **Then** `LocalizationManager.instance.currentLocale` is reset to `'en'`
- **And** the `ShellPage` is mounted within the 15-second startup timeout.

#### Scenario 2: Heroku Bootstrap Cold-Start Interception
- **Tags**: `[Tier C - Integration]`, `[Resilience]`
- **Given** integration tests are running against the Staging environment
- **When** `Dio` receives a request targeting `/api/v1/settings/sync/bootstrap`
- **Then** `IntegrationTestHelper`'s interceptor intercepts the call
- **And** resolves immediately with HTTP 200 containing `stale_translations: []`
- **And** prevents background OTA download loops from stalling UI pumps.

## 6. Test & Verification Checklist
- [ ] **RED**: Verify that launching tests without `IntegrationTestHelper` suffers from Heroku bootstrap delay.
- [ ] **GREEN**: Create `IntegrationTestHelper` and update `LanguageTestHelper`.
- [ ] **REFACTOR**: Ensure zero warnings with `fvm flutter analyze integration_test/`.
- [ ] **Tier C (Integration)**: Verify `LanguageTestHelper.startAppAndOpenSettings()` boots cleanly on iOS Simulator.

## 7. Definition of Done (DoD)
- `IntegrationTestHelper` implemented with platform mocks, Dio interceptor, and condition wait methods.
- `LanguageTestHelper` updated to use `IntegrationTestHelper`.
- Analyzer reports clean on `integration_test/helpers/`.

## 8. Dependencies & Blockers
- Blocks: [Task 03](task_03_remediate_language_integration_tests.md), [Task 04](task_04_remediate_deep_link_integration_test.md).

## 9. References & Rollback
- Source Spec: [2026-09-17-test-suite-remediation-design.md](2026-09-17-test-suite-remediation-design.md)
- Rollback: Revert `integration_test/helpers/`.
