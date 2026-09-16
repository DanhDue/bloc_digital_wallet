---
id: "task_14_presentation_bloc_loading_dialog_guard"
status: "todo"
priority: "high"
assignee: null
epic: "settings-bugfixes"
dueDate: null
created: "2026-09-16T13:36:00+07:00"
modified: "2026-09-16T13:36:00+07:00"
completedAt: null
labels: ["presentation", "bloc", "ui", "bugfix"]
order: "a2"
---

# Task 14: Presentation & Bloc - Optimistic Switching & Loading Dialog Suppression

Epic: [settings_bugfixes](../epic/settings_bugfixes/settings_bugfixes.en.md)

## Requirement Analysis
In the Presentation layer, `SettingsBloc` handles `SettingsActionChangeLanguage` by subscribing to `ChangeLanguageUseCase`.
When a user selects a bundled language (`en`, `vi`, `en_US`, `vi_VN`):
- `SettingsBloc` must transition immediately to updated language state via `cachedApplied`.
- The UI layer (`LanguagePickerBottomSheet` or `SettingsPage`) must NOT display any modal loading indicator / `CustomLoadingWidget`.
- When an uncached remote OTA language (`ja`, `ko`) is selected:
  - `SettingsBloc` emits `SettingsState.loading()` or equivalent language-sync-loading state.
  - The UI displays the downloading dialog until `LanguageSyncStatus.success` is received.

This task verifies and guards `SettingsBloc` and `LanguagePickerBottomSheet` to ensure:
1. Selecting `en_US` or `vi_VN` does not trigger the loading dialog.
2. Selecting uncached `ja` still triggers the loading dialog.
3. Rapid clicking between languages adheres to the race guard and does not leave orphaned loading dialogs.

## Relevant Files & Context Pointers
- `features/settings/lib/presentation/bloc/settings_bloc.dart`
- `features/settings/lib/presentation/pages/widgets/language_picker_bottom_sheet.dart`
- `features/settings/test/presentation/bloc/settings_bloc_test.dart`
- `features/settings/test/presentation/pages/widgets/language_picker_bottom_sheet_test.dart`

## Design Rationale
- The Presentation layer relies on the contract of `ChangeLanguageUseCase`.
- For bundled languages, `ChangeLanguageUseCase` only emits `cachedApplied` followed by `success`.
- `SettingsBloc` maps `cachedApplied` to an immediate state update, and `LanguagePickerBottomSheet` reflects the active selection without showing `CustomLoadingWidget`.
- By verifying this at the BLoC and Widget levels, we ensure no regression in user-facing dialogs.

## Impact Analysis & Blast Radius
- **Target Files & Symbols**:
  - `SettingsBloc._onChangeLanguage`
  - `LanguagePickerBottomSheet`
- **Downstream Callers**: User navigation from Settings Page.
- **Cross-Platform Bridges**: None.
- **Target Test Coverage Threshold**: $\ge 80\%$ for BLoC and Presentation components.

### BDD SCENARIOS

#### [Tier A - Unit] Scenario 1: SettingsBloc handles change to en_US without emitting loading state
```gherkin
Given SettingsBloc is initialized with current language "vi"
When SettingsActionChangeLanguage('en_US') is dispatched
Then SettingsBloc emits state with activeLanguage "en_US" without any intermediate loading state
```

#### [Tier A - Unit] Scenario 2: SettingsBloc handles uncached remote language with loading state
```gherkin
Given SettingsBloc is initialized with current language "en"
When SettingsActionChangeLanguage('ja') is dispatched for an uncached language
Then SettingsBloc emits loading state
And then emits success state with activeLanguage "ja" when download completes
```

#### [Tier C - Integration] Scenario 3: LanguagePickerBottomSheet does not show loading dialog for bundled languages
```gherkin
Given LanguagePickerBottomSheet is displayed on screen
When the user taps "English (US)"
Then no modal CustomLoadingWidget is pushed onto the Navigator
And the selection checkmark moves immediately to "English (US)"
```

## Test & Verification Checklist
- [ ] **RED**: Write BLoC test in `settings_bloc_test.dart` verifying that `SettingsActionChangeLanguage('en_US')` transitions directly to updated locale without loading.
- [ ] **GREEN**: Ensure `SettingsBloc` correctly processes `LanguageSyncStatus.cachedApplied`.
- [ ] **Widget Verification**: Run widget test verifying `LanguagePickerBottomSheet` behavior for bundled vs remote languages.
- [ ] Format and lint check via `melos analyze`.
