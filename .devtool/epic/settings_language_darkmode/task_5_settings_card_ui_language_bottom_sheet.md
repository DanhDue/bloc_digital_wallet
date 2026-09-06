---
id: "task_5_settings_card_ui_language_bottom_sheet"
status: "done"
priority: "high"
assignee: null
epic: "settings_language_darkmode"
dueDate: null
created: "2026-09-06T02:37:10+07:00"
modified: "2026-09-06T23:57:00+07:00"
completedAt: "2026-09-06T23:57:00+07:00"
labels: ["architecture", "feature"]
order: "a5"
---

# Task 5: Settings Card UI & Language Bottom Sheet

Epic: [settings_language_darkmode](../epic/settings_language_darkmode/settings_language_darkmode.en.md)

## Requirement Analysis
The UI must achieve 100% visual fidelity with the reference design:
1. Card Grouping Structure:
   - Account Section: Edit Profile, Change Password, 2FA.
   - Preferences Section: Dark Mode (Toggle Switch), Language (Chevron + current language title), Currency (USD).
   - Developer Section: Developer Options.
   - App Info Section: Contact Support, About App.
   - Standalone Red Logout Button: centered with surface background and red text.
2. Reusable Visual Components:
   - `SettingsSectionWidget`: Rounded container (`borderRadius: BorderRadius.circular(16)`).
   - `SettingsItemWidget`: Contains pastel circular icon background, title, optional subtitle, and trailing widget (Switch, Arrow, or Text).
   - `LanguagePickerBottomSheet`: ModalBottomSheet with a list of languages, showing native language title and a checkmark icon on the selected language.
3. Localization Strategy:
   - Bundled static languages: English and Vietnamese in Slang translations (`packages/core/i18n/` and `features/settings/i18n/`).
   - Dynamic OTA languages: Remote languages resolved dynamically at runtime through `LocalizationManager` and remote OTA endpoints.

## Relevant Files & Context Pointers
- `features/settings/lib/presentation/settings/settings_page.dart`
- `features/settings/lib/presentation/settings/widgets/settings_section_widget.dart`
- `features/settings/lib/presentation/settings/widgets/settings_item_widget.dart`
- `features/settings/lib/presentation/settings/widgets/language_picker_bottom_sheet.dart`
- `features/settings/test/presentation/settings/settings_page_test.dart`
- `features/settings/test/presentation/settings/widgets/language_picker_bottom_sheet_test.dart`

## Design Rationale & Refinements
- Leverage Material 3 design tokens (`MaterialTheme.colorScheme`, `MaterialTheme.typography`).
- Composables must be stateless, receiving state and emitting actions (`(SettingsAction) -> Unit`).
- UI elements must support dark and light theme seamlessly.
- **Strict OTA Specification Alignment**:
  - Confirmed that Japanese and Korean are delivered solely via Over-The-Air translation endpoints. All UI labels in `SettingsScreen` and reusable widgets use `appStringResource()`, allowing dynamic OTA strings to override or provide values for non-bundled locales.
- **ModalBottomSheet State Isolation**:
  - The bottom sheet visibility lifecycle is driven purely by explicit user actions (`OpenLanguagePicker`, `DismissLanguagePicker`, `SelectLanguage`). Background delta translation downloads operate decoupled from sheet visibility state.

## TDD Checklist
- [x] **RED**: Write Compose UI / screenshot / logic tests:
  - Verify `SettingsScreen` renders 4 cards and 1 logout button.
  - Verify tapping Dark Mode switch dispatches `ToggleDarkMode`.
  - Verify tapping Language row dispatches `OpenLanguagePicker`.
  - Verify bottom sheet displays language list with checkmark on current selection.
- [x] **GREEN**: Implement minimal Compose components and screens.
- [x] **REFACTOR**: Ensure no hardcoded colors, spacing uses 8.dp grid, previews support Dark and Light themes.

## Definition of Done (DoD)
- Screen matches visual screenshots accurately.
- Tested on both Light and Dark themes.
- No hardcoded string literals (bundled in `strings.xml` for `en`/`vi`, dynamically resolved via OTA for other languages).
- Language picker sheet opens and closes stably during rapid language selection.

## Dependencies & Blockers
- Blocked by [Task 4](task_4_settings_presentation_mvi_viewmodel.md)

## References & Rollback
- Epic HLD: [settings_language_darkmode.en.md](../epic/settings_language_darkmode/settings_language_darkmode.en.md)
- Rollback: Revert UI components in `features/settings/src/main/kotlin/com/danhdue/settings/presentation/components/`.
