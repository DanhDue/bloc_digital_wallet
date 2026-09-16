---
id: "task_15_host_app_integration_3tier_verification"
status: "todo"
priority: "high"
assignee: null
epic: "settings-bugfixes"
dueDate: null
created: "2026-09-16T13:36:00+07:00"
modified: "2026-09-16T13:36:00+07:00"
completedAt: null
labels: ["integration", "testing", "governance", "acceptance"]
order: "a3"
---

# Task 15: Host App Integration & 3-Tier Verification

Epic: [settings_bugfixes](../epic/settings_bugfixes/settings_bugfixes.en.md)

## Requirement Analysis
This task connects the domain, data, and presentation bugfixes into the Host App composition root and executes the complete 3-Tier verification suite:
1. **Host App Initializer (`LocalizationInitializer`)**:
   Ensure `lib/core/app_initializer/localization_initializer.dart` handles device locale fallback robustly, applying default English translations without errors or unhandled asynchronous states.
2. **Tier B (Tooling & Governance)**:
   - Module boundaries: `./scripts/check_module_boundaries.sh`
   - License headers: `./scripts/check_license_header.sh`
   - Static analysis: `melos run analyze`
   - Formatting: `fvm dart format --set-exit-if-changed .`
3. **Tier C (Acceptance & End-to-End Verification)**:
   - Verify full language lifecycle:
     - Fresh install English -> switch to Vietnamese -> switch back to English (verify zero loading dialogs).
     - Switch to remote OTA language (verify loading dialog appears, downloads, applies, and dismisses cleanly).
   - Ensure all tests across all packages pass cleanly.

## Relevant Files & Context Pointers
- `lib/core/app_initializer/localization_initializer.dart`
- `test/core/app_initializer/localization_initializer_test.dart` (NEW / enhanced)
- `scripts/check_module_boundaries.sh`
- `scripts/check_license_header.sh`

## Design Rationale
- The Host App composition root is where `LocalizationInitializer` coordinates app startup locale resolution.
- Running the full 3-Tier verification suite guarantees that no regressions were introduced to architecture boundaries, license policies, or existing features.

## Impact Analysis & Blast Radius
- **Target Files & Symbols**:
  - `LocalizationInitializer._loadSavedLocale`
- **Downstream Callers**: `AppInitializer`, `main.dart`.
- **Cross-Platform Bridges**: None.
- **Target Test Coverage Threshold**: 100% 3-Tier test pass rate.

### BDD SCENARIOS

#### [Tier A - Unit] Scenario 1: LocalizationInitializer initializes with device locale cleanly
```gherkin
Given no saved language code exists in SharedPreferences
When LocalizationInitializer._loadSavedLocale is executed
Then LocaleSettings.useDeviceLocale is properly invoked
And LocalizationManager.instance.setLocaleFromCode is called with the device language tag
```

#### [Tier C - Integration] Scenario 2: End-to-end bundled language switching roundtrip
```gherkin
Given the app is booted with initial locale "en"
When the user switches to "vi"
Then the locale switches to Vietnamese with zero loading dialog
When the user switches back to "en_US"
Then the locale switches back to English with zero loading dialog
```

## Test & Verification Checklist
- [ ] **Tier A**: Verify `LocalizationInitializer` unit tests pass.
- [ ] **Tier B**: Run `./scripts/check_module_boundaries.sh`, `./scripts/check_license_header.sh`, and `melos run analyze`. Ensure zero errors.
- [ ] **Tier C**: Run `fvm flutter test` across all affected packages.
- [ ] Verify clean git status and format.
