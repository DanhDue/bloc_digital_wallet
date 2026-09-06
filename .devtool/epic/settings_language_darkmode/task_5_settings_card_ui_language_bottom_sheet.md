---
id: "task_5_settings_card_ui_language_bottom_sheet"
status: "done"
priority: "high"
assignee: null
epic: "settings_language_darkmode"
dueDate: null
created: "2026-09-06T02:37:10+07:00"
modified: "2026-09-06T15:55:00+07:00"
completedAt: "2026-09-06T02:58:30+07:00"
labels: ["architecture", "feature"]
order: "a5"
---

# Task 5: Settings Card UI & Language Bottom Sheet

Epic: [settings_language_darkmode](../epic/settings_language_darkmode/settings_language_darkmode.en.md)

## Requirement Analysis
The UI must achieve 100% visual fidelity with the reference design screenshots:
1. Card Grouping Structure:
   - Account Section: Edit Profile, Change Password, 2FA.
   - Preferences Section: Dark Mode (Toggle Switch), Language (Chevron + current language title), Currency (USD).
   - Developer Section: Developer Options.
   - App Info Section: Privacy Policy, Terms of Service, About.
   - Standalone Red Logout Button: centered with red border/background.
2. Reusable Visual Components:
   - `SettingsSectionCard`: Rounded Material 3 card container (`shape = RoundedCornerShape(16.dp)`).
   - `SettingsItemRow`: Contains pastel circular icon background, title, optional subtitle, and trailing widget (Switch, Chevron, or Text).
   - `LanguagePickerBottomSheet`: ModalBottomSheet with a list of languages, showing title, localized subtitle, and a checkmark icon on the selected language.
   - `LoadingDialog`: Non-dismissible modal progress indicator with "Switching language..." message when downloading uncached languages.
3. String Resources & OTA Strategy:
   - Bundled static languages: Provide complete English strings in `features/settings/src/main/res/values/strings.xml` and Vietnamese in `features/settings/src/main/res/values-vi/strings.xml`.
   - Dynamic OTA languages: Remote languages (e.g. Japanese `ja_JP`, Korean `ko_KR`) are NOT bundled in XML (no `values-ja` or `values-ko` folders). They are resolved dynamically at runtime through `AppLocalizationManager` and remote OTA JSON endpoints per specification.

## Relevant Files & Context Pointers
- `features/settings/src/main/kotlin/com/danhdue/settings/presentation/SettingsScreen.kt`
- `features/settings/src/main/kotlin/com/danhdue/settings/presentation/components/SettingsSectionCard.kt`
- `features/settings/src/main/kotlin/com/danhdue/settings/presentation/components/SettingsItemRow.kt`
- `features/settings/src/main/kotlin/com/danhdue/settings/presentation/components/LanguagePickerBottomSheet.kt`
- `features/settings/src/main/kotlin/com/danhdue/settings/presentation/components/LoadingDialog.kt`
- `features/settings/src/main/res/values/strings.xml`
- `features/settings/src/main/res/values-vi/strings.xml`

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
