# BDD Scenarios: Settings Bugfixes - Language Switching & Bundled Cache Resolution

## Feature: Bundled Language Identification and Optimistic Switching
As a mobile user of the Digital Wallet Super App
I want switching between default bundled languages (English and Vietnamese) to be instantaneous
So that I never see a downloading dialog when selecting bundled languages, regardless of locale tag formats.

### Scenario 1: Initial App Launch with System English Locale
  Given the application is freshly installed on a device with system locale "en_US"
  When the application initializes via LocalizationInitializer
  Then the active locale is resolved to English ("en")
  And both "en_US" (or "en") and "vi" are marked as isCached = true in the available languages list

### Scenario 2: Switching from English to Vietnamese (Bundled to Bundled)
  Given the current active language is English ("en" or "en_US")
  When the user opens the Language Selection sheet and taps "Tiếng Việt" ("vi" or "vi_VN")
  Then ChangeLanguageUseCase detects baseCode "vi" as a bundled language
  And ChangeLanguageUseCase immediately yields LanguageSyncStatus.cachedApplied
  And the active locale instantly updates to Vietnamese without showing any loading dialog
  And a silent background delta check is performed
  And ChangeLanguageUseCase yields LanguageSyncStatus.success

### Scenario 3: Switching from Vietnamese back to English (Bundled with Region Tag to Bundled)
  Given the current active language is Vietnamese ("vi")
  When the user opens the Language Selection sheet and taps "English (US)" ("en_US" or "en-US")
  Then ChangeLanguageUseCase normalizes "en_US" to baseCode "en"
  And ChangeLanguageUseCase identifies baseCode "en" as a bundled language
  And ChangeLanguageUseCase treats the language as cached (isCached = true)
  And ChangeLanguageUseCase immediately yields LanguageSyncStatus.cachedApplied
  And the UI updates to English immediately
  And NO CustomLoadingWidget downloading dialog is shown
  And a background delta check runs silently
  And ChangeLanguageUseCase yields LanguageSyncStatus.success

### Scenario 4: Switching to an Uncached Remote OTA Language (e.g. Japanese "ja")
  Given the current active language is English ("en")
  And "ja" has never been downloaded and has no cached translation in local storage
  When the user opens the Language Selection sheet and taps "日本語" ("ja")
  Then ChangeLanguageUseCase detects baseCode "ja" is neither bundled nor cached
  And ChangeLanguageUseCase yields LanguageSyncStatus.loading
  And the UI displays the modal CustomLoadingWidget downloading dialog
  When the dynamic translation JSON finishes downloading from the backend
  Then the new translations are applied and the active locale switches to "ja"
  And ChangeLanguageUseCase yields LanguageSyncStatus.success
  And the CustomLoadingWidget downloading dialog is dismissed

### Scenario 5: Rapid Switching between Bundled and Remote Languages (Race Guard)
  Given the user rapidly taps "ja" (uncached remote) and immediately taps "en_US" (bundled)
  When the network response for "ja" returns after "en_US" has been applied
  Then the stale "ja" response is discarded by the race guard
  And the active locale remains English ("en")
  And the downloading dialog is not reopened
