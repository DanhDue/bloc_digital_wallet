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
    B --> UC[ChangeLanguageUseCase]
    
    UC --> UC1[CheckLanguageCachedUseCase]
    UC --> UC2[GetDynamicLocalizationUseCase]
    UC --> UC3[UpdateUserLanguageUseCase]
    UC --> LM[LocalizationManager]
    
    UC1 --> REPO[SettingsRepository]
    UC2 --> REPO
    UC3 --> REPO
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
    participant UC as ChangeLanguageUseCase
    participant LM as LocalizationManager
    
    User->>Bloc: Change to 'ja'
    Bloc->>UC: call('ja')
    UC->>UC: Check if 'ja' is same language
    alt is same language
        UC->>UC: Fetch API (Delta only)
        UC-->>Bloc: completion
    else not same language
        UC->>UC: Check if 'ja' is cached
        alt is cached
            UC->>LM: setLocaleFromCode('ja')
            UC-->>Bloc: yield cachedApplied
            Bloc->>Bloc: emit(Success)
            UC->>UC: Fetch API
            UC-->>Bloc: yield success
        else not cached`
            UC-->>Bloc: yield loading
            Bloc->>Bloc: emit(Loading)
            UC->>UC: Fetch API
            UC->>LM: setLocaleFromCode('ja')
            UC-->>Bloc: yield success
            Bloc->>Bloc: emit(Success)
        end
    end
```

## 5. Rollout Strategy & Mitigation
- Standard deployment.

## 6. Kanban Tasks Breakdown
- [Task 11: Fix Language Race Condition](../../features/task_11_language_race_condition.md)
- [Task 12: Refactor Language Sync Orchestration](../../features/task_12_refactor_language_sync.md)
