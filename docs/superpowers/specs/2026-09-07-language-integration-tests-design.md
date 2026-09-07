# Design Spec: Language Switching Integration Test Suite (Use Cases & Edge Cases)

**Date**: 2026-09-07  
**Status**: Approved (Brainstorming Design Spec)  
**Authors**: Antigravity & DanhDue ExOICTIF  
**Target Architecture**: Flutter Integration Test Framework (`integration_test`, `flutter_test`, `flutter_driver`)  
**Epic Parity Reference**: `.devtool/epic/settings_language_darkmode/settings_language_darkmode.en.md`

---

## 1. Context & Motivation

The application features an Over-The-Air (OTA) dynamic localization system supporting bundled core languages (`en`, `vi`) and on-demand downloadable remote languages (`ja_JP`, `ko_KR`). The functional and architectural specifications are defined in the `settings_language_darkmode` Epic.

To ensure production stability, high regression coverage, and tri-platform parity with the reference implementation, this design specifies a comprehensive, modular **Integration Test Suite** executing against the **Staging environment** on the **iPhone 16e** simulator.

The suite is structured into two focused test files:
1. **Standard Use Cases (`change_language_test.dart`)**: Happy path flows covering instant cached switching, uncached remote downloads, and same-language no-ops.
2. **Edge Cases & Resilience (`language_edge_cases_test.dart`)**: Complex edge cases including race condition handling, network error rollbacks, bottom sheet recomposition stability, and cold-start frame-0 persistence.

---

## 2. Test Suite Architecture & File Structure

```
integration_test/
├── helpers/
│   └── language_test_helper.dart      # Shared test harness (app boot, settings navigation, visual pacing)
├── change_language_test.dart          # Suite 1: Standard Core Use Cases (UC-01, UC-03A, UC-03B, UC-03C)
└── language_edge_cases_test.dart      # Suite 2: Advanced Edge Cases & Resilience (BDD-01, BDD-07, BDD-08, Bug #2)
```

### Shared Helper: `LanguageTestHelper`
- **`startAppAndOpenSettings(WidgetTester tester)`**: Resets GetIt DI container, calls `app.main()`, settles frames, normalizes locale to English, navigates to the Settings screen via bottom nav bar, and verifies screen readiness.
- **`openLanguagePicker(WidgetTester tester)`**: Taps the Language settings row and waits for `LanguagePickerBottomSheet` to mount.
- **`stepDelay([Duration duration])`**: Introduces configurable visual pauses (`800ms - 1500ms`) allowing developers to visibly observe live UI changes on the simulator.

---

## 3. Test Cases Specification

### Suite 1: Standard Use Cases (`change_language_test.dart`)

| Test Case | Ref Use Case | Precondition | Actions | Expected Outcomes |
| :--- | :--- | :--- | :--- | :--- |
| **Case 1: Same-Language No-Op** | UC-03C, BDD-05 | App active in `en` | Open picker, tap `language_option_en` | BottomSheet dismisses immediately. No loading spinner. No network calls. Locale remains `en`. |
| **Case 2: Uncached Remote OTA Download** | UC-03B, BDD-06 | `ja_JP` uncached | Open picker, tap `language_option_ja` | `CustomLoadingWidget` dialog appears. Request `GET /api/v1/translations/ja_JP` succeeds. Dialog closes. Locale updates to `ja`. Preferences saved to `SharedPreferences`. |
| **Case 3: Bundled/Cached Optimistic Switch** | UC-03A, BDD-04 | App active in `ja` | Open picker, tap `language_option_en` | Immediate optimistic update without blocking loading dialog. UI and locale revert to `en`. SharedPreferences persists `en`. |
| **Case 4: Bundled Vietnamese Switch** | UC-03A, BDD-04 | App active in `en` | Open picker, tap `language_option_vi` | UI updates smoothly to Vietnamese without modal loading. Persistence verified. Reverts cleanly to `en`. |

---

### Suite 2: Advanced Edge Cases & Resilience (`language_edge_cases_test.dart`)

| Test Case | Ref Scenario | Precondition | Actions | Expected Outcomes |
| :--- | :--- | :--- | :--- | :--- |
| **Edge Case 1: Rapid Switching Race Condition** | BDD-08 | Language picker open | Rapidly tap `language_option_ko` then immediately tap `language_option_ja` | Initial `ko` in-flight job is superseded/cancelled by `SettingsBloc`. App strictly converges on latest selection (`ja`). No state corruption. |
| **Edge Case 2: Remote Download Failure Rollback** | BDD-07 | App active in `en` | Attempt to fetch remote language with network failure simulation or invalid language | Loading dialog dismisses. `SettingsEvent.showError` surfaces SnackBar. Active language safely rolls back/retains `en`. No blank screen or crash. |
| **Edge Case 3: Re-opening BottomSheet Immediately** | Bug #2 (Epic Log) | Language picker open | Tap language $\rightarrow$ BottomSheet closes $\rightarrow$ Immediately tap language row again | BottomSheet opens cleanly while background delta sync runs. Correct active checkmark displayed. No accidental dismissal or recomposition crash. |
| **Edge Case 4: Cold-Start Frame-0 Restoration** | UC-05, BDD-01 | Language set to `ja_JP` | Simulate fresh process cold start (`app.main()` in clean lifecycle without manual locale reset) | `LocalizationManager` synchronously loads saved language from `SharedPreferences`. Frame-0 renders with Japanese strings without flashing default English. |

---

## 4. Execution & Validation Strategy

### Execution Command (Staging Environment & iPhone 16e Simulator)
```bash
# Bring Simulator window to front
open -a Simulator

# Run Suite 1: Standard Use Cases
fvm flutter test integration_test/change_language_test.dart \
  --dart-define-from-file=secureFiles/stg/environment-configs.json \
  --flavor=stg \
  -d 2848286B-009D-4B8E-8C06-F6D243E917D7

# Run Suite 2: Edge Cases & Resilience
fvm flutter test integration_test/language_edge_cases_test.dart \
  --dart-define-from-file=secureFiles/stg/environment-configs.json \
  --flavor=stg \
  -d 2848286B-009D-4B8E-8C06-F6D243E917D7
```

### Verification Criteria
1. **Zero Failures**: All test cases in both suites exit with code `0`.
2. **Static Analysis**: `fvm flutter analyze` returns `No issues found!`.
3. **Module Boundaries**: `./scripts/check_module_boundaries.sh` passes without violations.
4. **Code Quality**: Formatted according to project conventions with line length 99 (`dart format -l 99`).
