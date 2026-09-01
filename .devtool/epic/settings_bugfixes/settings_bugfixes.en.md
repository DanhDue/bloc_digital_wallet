---
epic: "settings-bugfixes"
---

# Settings Bugfixes

## 1. Meta Data
- **Status:** Queued (backlog)
- **Target Release:** Next Minor
- **Source Spec:** N/A

## 2. Background
Settings module bugs that need fixing, specifically the language switch race conditions. When the user changes language rapidly, optimistic UI forces un-cached languages to display immediately, and concurrent API fetches overwrite the current locale when they finish out-of-order.

## 3. Goals & Non-Goals
**Goals:**
- Fix the race condition when user rapid-clicks multiple languages.
- Apply state-aware Optimistic UI (only immediate for default/cached languages).

**Non-Goals:**
- Refactor the entire Settings module.

## 4. Architecture & Technical Design

### High-Level Architecture
```mermaid
graph TD
    UI[Settings Page] -->|Change Language| B[SettingsBloc]
    B --> UC1[CheckLanguageCachedUseCase]
    B --> UC2[GetDynamicLocalizationUseCase]
    B --> LM[LocalizationManager]
    
    UC1 --> REPO[SettingsRepository]
    UC2 --> REPO
```

### Use Cases
```mermaid
flowchart LR
    User -->|Selects Language| UI
    UI -->|Triggers SettingsActionChangeLanguage| Bloc
```

### Sequence Diagram
```mermaid
sequenceDiagram
    actor User
    participant Bloc as SettingsBloc
    participant LM as LocalizationManager
    
    User->>Bloc: Change to 'ja'
    Bloc->>Bloc: Check if 'ja' is cached
    alt is cached
        Bloc->>LM: setLocaleFromCode('ja')
    else not cached
        Bloc->>Bloc: emit(Loading)
        Bloc->>Bloc: Fetch API
        Bloc->>LM: setLocaleFromCode('ja')
        Bloc->>Bloc: emit(Success)
    end
```

## 5. Rollout Strategy & Mitigation
- Standard deployment.

## 6. Kanban Tasks Breakdown
- [Task 11: Fix Language Race Condition](../../features/task_11_language_race_condition.md)
