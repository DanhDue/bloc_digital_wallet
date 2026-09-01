---
epic: "settings-bugfixes"
---

# Settings Bugfixes

## 1. Meta Data
- **Status:** Queued (backlog)
- **Target Release:** Next Minor
- **Source Spec:** N/A

## 2. Background (Bối cảnh)
Lỗi module Settings liên quan đến race conditions khi chuyển đổi ngôn ngữ. Khi người dùng thay đổi ngôn ngữ liên tục, optimistic UI khiến ngôn ngữ chưa được tải về hiển thị ngay lập tức, và các tiến trình API song song sẽ đè locale hiện tại khi chúng chạy xong không theo thứ tự.

## 3. Goals & Non-Goals
**Goals:**
- Sửa lỗi race condition khi người dùng click đổi nhiều ngôn ngữ liên tục.
- Áp dụng state-aware Optimistic UI (chỉ update tức thì cho các ngôn ngữ mặc định/đã cache).

**Non-Goals:**
- Refactor toàn bộ module Settings.

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
