# Epic: DeepLink Router Engine

> **Source Epic:** `.devtool/epic/deeplink_router_engine` — **Status:** Implemented  
> Moved to `docs/technical-analysis/` for developer discoverability.

## Table of Contents
1. [Meta Data](#meta-data)
2. [Background](#background)
3. [Goals & Non-Goals](#goals--non-goals)
4. [Architecture & Technical Design](#architecture--technical-design)
   - [High-Level Architecture](#high-level-architecture)
   - [Use Cases](#use-cases)
   - [Sequence Diagram](#sequence-diagram)
5. [Rollout Strategy & Mitigation](#rollout-strategy--mitigation)
6. [Kanban Tasks Breakdown](#kanban-tasks-breakdown)

---

## Meta Data
- **Epic Name:** `deeplink_router_engine`
- **Status:** `implemented`
- **Target Release:** Flutter Super App Template v1.1
- **Source Spec:** [2026-09-11-external-deeplink-engine-design.md](2026-09-11-external-deeplink-engine-design.md)
- **Reference Implementations:**
  - Android: `android_digital_wallet/.devtool/epic/deeplink_router_engine/`
  - iOS: `iOSDigitalWallet/.devtool/epic/deeplink_router_engine/`

---

## Background
In a modular **Super App** architecture, Mini Apps (feature modules) must remain completely decoupled ("blind" to each other). While internal navigation between packages was previously established using route string constants (`DeepLinkRoutes` in `packages/platform`), the application lacked an **External Deep Link & Central Routing Engine**.

As a consequence:
1. The app could not handle OS-level deep link intents such as Custom URL Schemes (`d3nexus://...`), Android App Links, or iOS Universal Links (`https://app.d3nexus.com/...`).
2. There was no mechanism to handle Cold Start timing safely (preventing dropped links while the Flutter Engine and Router initialize).
3. There was no centralized Auth Guard with Pending Deep Link preservation to resume navigation after user authentication.
4. There was no Smart Hybrid Navigation to coordinate switching `ShellPage` tabs versus pushing sub-routes onto the `AutoRoute` stack.

This epic establishes a centralized, platform-grade Deep Link Gateway to fulfill Pillar 2 ("Centralized Communication & Routing") of the Super App Governance Framework.

---

## Goals & Non-Goals

### Goals
- **Protocol & Parsing Separation:** Implement `DeepLinkPayload`, `DeepLinkParser`, and `DeepLinkRegistry` in `packages/platform` (Pure Dart, 100% testable without Flutter UI dependencies).
- **Multi-Protocol Support:** Support Custom Scheme (`d3nexus://...`) and HTTPS Universal/App Links (`https://app.d3nexus.com/...`).
- **Timing & Lifecycle Management:**
  - Cold Start: Buffer initial link in `_stagedInitialLink` until `ShellPage` signals `markRouterReady()`.
  - Warm Start: Stream links with deduplication (< 1000ms threshold).
- **Centralized Auth Guard:** Intercept protected routes when unauthenticated, cache `PendingDeepLink`, redirect to Login, and auto-resume upon `LoginSuccessEvent`.
- **Smart Hybrid Navigation:** Automatically switch `ShellPage` tab index if target is a root tab (Home, Scanner, Settings); push onto `AutoRoute` stack if target is a nested screen.
- **Mason Brick Auto-Wiring:** Update `pac_mvi_feature` post-gen hook to register newly created features into `DeepLinkRegistry` automatically.

### Non-Goals
- Replacing `auto_route` with custom Navigator 2.0.
- Dynamic runtime code loading (Flutter compiles ahead-of-time into a single binary).
- Web browser history synchronization for Flutter Web.

---

## Architecture & Technical Design

### High-Level Architecture
```mermaid
graph TD
    subgraph OS ["Operating System (Android / iOS)"]
        RawUri["URL Scheme: d3nexus://...<br/>App / Universal Links: https://..."]
    end

    subgraph HostApp ["Flutter Host App (lib/) — Composition Root"]
        AppLinks["app_links Plugin"]
        Coordinator["DeepLinkCoordinator<br/>(Lifecycle & Deduplication)"]
        AuthGuard["DeepLinkAuthGuard<br/>(Auth Check & Pending Store)"]
        Navigator["DeepLinkNavigator<br/>(Smart Hybrid Executor)"]
        ShellBloc["ShellBloc (IndexedStack Tab Controller)"]
        AppRouter["AppRouter (AutoRoute Stack)"]
    end

    subgraph PlatformPkg ["packages/platform — Governance & Protocol"]
        Parser["DeepLinkParser<br/>(Pure Dart URI Normalizer)"]
        Payload["DeepLinkPayload<br/>(path, queryParams, targetTab, isProtected)"]
        Registry["DeepLinkRegistry<br/>(Path to PageRouteInfo & TabIndex Map)"]
    end

    RawUri --> AppLinks
    AppLinks --> Coordinator
    Coordinator --> Parser
    Parser --> Registry
    Registry --> Payload
    Coordinator --> AuthGuard
    AuthGuard -->|Authenticated or Public| Navigator
    AuthGuard -->|Unauthenticated| PendingStore[("PendingDeepLink Cache")]
    Navigator -->|Root Tab Target| ShellBloc
    Navigator -->|Nested Screen Target| AppRouter
```

### Use Cases
```mermaid
flowchart TD
    User(["Mobile User"])
    Marketing(["Marketing Campaign / Web"])
    PushNotification(["Push Notification Service"])

    User -->|Taps QR code or Custom Scheme| LinkAction["Open d3nexus://scanner?auto_scan=true"]
    Marketing -->|Clicks Universal Link| WebLink["Open https://app.d3nexus.com/settings/languages"]
    PushNotification -->|Taps Notification| PushLink["Open d3nexus://wallet/transfer?amount=100"]

    LinkAction --> Gateway["DeepLink Gateway Engine"]
    WebLink --> Gateway
    PushLink --> Gateway

    Gateway --> UC1{"Is User Authenticated?"}
    UC1 -->|Yes / Public Route| UC2{"Is Target a Root Tab?"}
    UC1 -->|No & Protected Route| UC3["Save Pending Link & Route to Login"]
    
    UC3 -->|Post Login Success| UC2
    UC2 -->|Yes| ActionTab["Switch Shell Tab Index"]
    UC2 -->|No| ActionStack["Push Nested Route to AutoRoute Stack"]
```

### Sequence Diagram
```mermaid
sequenceDiagram
    autonumber
    actor User as User / External Source
    participant OS as Mobile OS
    participant AppLinks as app_links
    participant Coord as DeepLinkCoordinator
    participant Parser as DeepLinkParser
    participant Guard as DeepLinkAuthGuard
    participant Nav as DeepLinkNavigator
    participant Shell as ShellBloc / ShellPage
    participant Router as AppRouter

    User->>OS: Tap link d3nexus://scanner?auto_scan=true
    OS->>AppLinks: Deliver URI (Cold/Warm)
    AppLinks->>Coord: onUriReceived(uri)
    Coord->>Coord: Check deduplication (<1000ms)
    
    alt Cold Start (Router not ready)
        Coord->>Coord: Store in _stagedInitialLink
        Shell-->>Coord: markRouterReady() post-frame
    end

    Coord->>Parser: parse(uri)
    Parser-->>Coord: DeepLinkPayload(path: '/scanner', targetTab: 1)
    
    Coord->>Guard: evaluate(payload)
    alt Route is Protected & Not Authenticated
        Guard->>Guard: Cache _pendingPayload
        Guard->>Router: push(LoginRoute)
        Note over Guard,Router: User completes login
        Guard->>Nav: resumePending()
    else Public or Authenticated
        Guard->>Nav: execute(payload)
    end

    alt targetTab != null (Root Tab)
        Nav->>Shell: onAction(ShellAction.tabChanged(1))
    else Nested Route
        Nav->>Router: push(targetPageRouteInfo)
    end
```

---

## Rollout Strategy & Mitigation

### Phased Rollout
1. **Phase 1: Foundation (Protocol & Parsing)**: Implement pure Dart parser and registry in `packages/platform`. Zero runtime risk to host app.
2. **Phase 2: Native Manifest & Dependency Setup**: Wire `app_links` in host app with minimal intent filters.
3. **Phase 3: Coordinator & Navigation Core**: Integrate `DeepLinkCoordinator` and `DeepLinkNavigator` with `ShellBloc`.
4. **Phase 4: Tooling & Automation**: Update `pac_mvi_feature` Mason brick to automate route registration.

### Mitigation & Fallback
- **Unknown Routes:** If a malformed or unregistered URI is received, `DeepLinkParser` gracefully falls back to `DeepLinkRoutes.home` (Tab 0) and emits a non-fatal warning log via `D3NexusLogger`.
- **Safe Staging:** Cold start links are only dispatched after the router signals readiness, preventing `NavigatorState` detachment.

---

## Kanban Tasks Breakdown
- [x] [Task 1: Platform DeepLink Protocol, Parser & Registry](../../features/done/task_1_deeplink_protocol_and_parser.md)
- [x] [Task 2: Native OS Configuration & AppLinks Integration](../../features/done/task_2_native_os_and_app_links.md)
- [x] [Task 3: DeepLink Coordinator, Auth Guard & Deduplication](../../features/done/task_3_deeplink_coordinator_and_auth_guard.md)
- [x] [Task 4: Shell Lifecycle Integration & Smart Hybrid Navigation](../../features/done/task_4_shell_lifecycle_and_hybrid_navigation.md)
- [x] [Task 5: Mason Brick Automation & E2E Integration Tests](../../features/done/task_5_mason_brick_and_integration_tests.md)
