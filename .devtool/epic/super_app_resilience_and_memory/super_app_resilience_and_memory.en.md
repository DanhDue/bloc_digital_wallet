# Epic: Super App Resilience & Memory Management

## 1. Meta Data
- **Epic Name:** `super_app_resilience_and_memory`
- **Status:** Completed
- **Target Release:** v1.0.0
- **Source Spec:** [2026-09-11-super-app-resilience-and-memory-design.md](2026-09-11-super-app-resilience-and-memory-design.md)
- **Owners / Lead:** Mobile Engineering & Architecture

---

## 2. Background
In a large-scale, multi-package **Super App** architecture, Mini Apps (feature modules) run inside a shared host process and consume shared runtime resources. Without proactive defenses, four fatal failure modes jeopardize system reliability:
1. **Unconstrained Image Decoding (OOM):** Loading full-resolution remote images into small UI slots causes Flutter's rendering engine (Skia / Impeller) to unpack massive uncompressed bitmaps into graphical RAM, triggering Out-Of-Memory (OOM) crashes on low/mid-tier devices.
2. **Cascading Render Crashes:** An unhandled error or render overflow within a single Mini App causes Flutter to show the Red/Grey Screen of Death, rendering the entire Super App Shell unusable.
3. **Unmonitored OS Low Memory Pressure:** When Android or iOS signals low memory warnings (`didHaveMemoryPressure`), the app fails to trim image caches and broadcast alerts, leading to immediate process termination by the OS Low Memory Killer.
4. **Disrupted Offline Experience:** Unhandled network dropouts cause silent API failures and broken UI states when screens lack dedicated offline status awareness.

This epic introduces a 4-pillar resilience framework to safeguard the Super App against memory exhaustion, cascading failures, and network volatility.

---

## 3. Goals & Non-Goals

### Goals
- **Automated RAM Downsampling:** Provide `AppCachedImage` in `packages/ui_kit` that computes `memCacheWidth` / `memCacheHeight` based on `devicePixelRatio` at decode time, integrated with `shimmer` skeleton loading and broken-image fallbacks.
- **Global Memory Cap:** Enforce a hard ceiling on Flutter's global `PaintingBinding.instance.imageCache` (max 50MB, max 100 entries) in `AppInitializer`.
- **Mini App Crash Isolation:** Provide `MiniAppErrorBoundary` in `packages/ui_kit` wrapping mini-app entry points, displaying an in-place recovery UI with "Retry" and "Go Home" actions without disrupting other tabs or the host shell.
- **OS Low Memory Response:** Implement `MemoryPressureObserver` in `packages/core` to purge memory caches and broadcast `LowMemoryEvent` across `packages/platform`'s `AppEventBus`.
- **Decoupled Network Awareness:** Provide `NetworkConnectivityService` in `packages/core` and a standalone `OfflineBanner` / `OfflineBannerWrapper` in `packages/ui_kit` for opt-in screen-level offline notifications.

### Non-Goals
- Building an automated dynamic feature module (DFM) download manager (handled in a future phase).
- Replacing HTTP clients or network retry policies (managed by `packages/network`'s `DioFactory`).
- Enforcing mandatory global offline banners across all screens (the user explicitly approved standalone opt-in composition).

---

## 4. Architecture & Technical Design

### 4.1. High-Level Architecture

```mermaid
flowchart TD
    subgraph CorePkg ["packages/core (Foundational Infrastructure)"]
        MemObserver["MemoryPressureObserver<br/>(WidgetsBindingObserver)"]
        NetService["NetworkConnectivityService<br/>(connectivity_plus + internet_connection_checker_plus)"]
        Init["AppInitializer<br/>(ImageCache Cap: 50MB / 100 items)"]
    end

    subgraph PlatformPkg ["packages/platform (IPC Bridge)"]
        EventBus["AppEventBus"]
        LowMemEvent["LowMemoryEvent (AppEvent)"]
    end

    subgraph UIKitPkg ["packages/ui_kit (Design System & Reusable Widgets)"]
        CachedImage["AppCachedImage<br/>(Downsampling by DevicePixelRatio)"]
        ShimmerBox["ShimmerLoadingBox<br/>(Skeleton Shimmer Placeholder)"]
        ErrorBoundary["MiniAppErrorBoundary<br/>(Crash Isolation & In-Place Fallback)"]
        OfflineWidget["OfflineBanner / OfflineBannerWrapper<br/>(Standalone Component)"]
    end

    subgraph HostApp ["Flutter Super App Host (lib/shell/)"]
        ShellTabs["ShellPage (3 Tabs: Home, Scanner, Settings)<br/>(Protected by ErrorBoundary)"]
    end

    MemObserver -->|Publish| LowMemEvent --> EventBus
    Init -->|Configures Memory Cap| CachedImage
    ShellTabs --> ErrorBoundary
```

### 4.2. Use Cases

```mermaid
flowchart TD
    User([End User / Device OS])

    subgraph UC1 ["Use Case 1: Image Loading with Downsampling"]
        BrowseImages["User scrolls feed with images"]
        ComputePixels["Compute physical decode bounds (memCacheWidth/Height)"]
        RenderShimmer["Show Shimmer skeleton while downloading"]
        DisplayImage["Render memory-capped bitmap"]
        BrowseImages --> ComputePixels --> RenderShimmer --> DisplayImage
    end

    subgraph UC2 ["Use Case 2: Mini App Crash Isolation"]
        OpenMiniApp["User opens Mini App / Tab"]
        ThrowCrash["Mini App encounters runtime/render exception"]
        CatchCrash["MiniAppErrorBoundary intercepts crash"]
        ShowFallback["Display In-Place Fallback (Retry / Go Home)"]
        OpenMiniApp --> ThrowCrash --> CatchCrash --> ShowFallback
    end

    subgraph UC3 ["Use Case 3: OS Low Memory Pressure"]
        OSSignal["OS sends didHaveMemoryPressure()"]
        PurgeCache["Purge ImageCache (clear & clearLiveImages)"]
        EmitEvent["Publish LowMemoryEvent via AppEventBus"]
        OSSignal --> PurgeCache --> EmitEvent
    end

    subgraph UC4 ["Use Case 4: Network Disconnection Alert"]
        DropNetwork["Device loses internet connection"]
        DetectDrop["NetworkConnectivityService emits offline status"]
        ShowBanner["OfflineBanner slides down on subscribed screens"]
        DropNetwork --> DetectDrop --> ShowBanner
    end

    User --> BrowseImages
    User --> OpenMiniApp
    User --> OSSignal
    User --> DropNetwork
```

### 4.3. Sequence Diagram

```mermaid
sequenceDiagram
    autonumber
    actor User as User / OS
    participant Shell as ShellPage
    participant Boundary as MiniAppErrorBoundary
    participant MiniApp as MiniApp Screen
    participant CachedImg as AppCachedImage
    participant Cache as Flutter ImageCache
    participant MemObs as MemoryPressureObserver
    participant Bus as AppEventBus

    %% Normal flow with Downsampling
    User->>Shell: Open Tab (e.g. Scanner / Settings)
    Shell->>Boundary: Mount Screen inside Boundary
    Boundary->>MiniApp: Build MiniApp Widget
    MiniApp->>CachedImg: Render thumbnail (width: 60, height: 60)
    CachedImg->>Cache: Decode with memCacheWidth: 180 (60 * 3 DPR)
    Cache-->>CachedImg: Return compact 180px bitmap (90KB vs 16MB)

    %% Crash Isolation
    Note over MiniApp,Boundary: Mini App throws unhandled rendering error
    MiniApp--xBoundary: Exception during build()
    Boundary->>Boundary: Catch error & state = hasError
    Boundary-->>User: Display In-Place Fallback UI (Retry / Go Home)
    Note over Shell: Shell BottomBar & other tabs remain fully responsive!

    %% OS Low Memory Pressure
    Note over User,MemObs: Device OS issues low memory warning
    User->>MemObs: didHaveMemoryPressure()
    MemObs->>Cache: clear() & clearLiveImages()
    MemObs->>Bus: publish(LowMemoryEvent())
    Bus-->>MiniApp: Optional cache evictions in repositories
```

### 4.4. Comprehensive BDD Test Scenarios & Living Documentation

All behavioral test specifications for this Epic are formally documented in standard Gherkin syntax (`Given - When - Then`) in:
👉 **[bdd_scenarios.md](bdd_scenarios.md)**

This document acts as:
1. **Living Documentation for Developers**: Rapid onboarding and unambiguous understanding of business logic, boundary conditions, state machines, and resilience mechanisms.
2. **AI Agent Context Injection**: Instant prompt ingestion for testing subagents during `epic-implementation` Phase 2 (QA Persona) to generate 100% deterministic test suites with zero hallucination.

---

## 5. Rollout Strategy & Mitigation

- **Zero Breaking Changes:** `AppCachedImage`, `MiniAppErrorBoundary`, and `OfflineBanner` are additive components in `packages/ui_kit`. Existing code continues to work without disruption.
- **Fail-Safe Fallbacks:**
  - If `devicePixelRatio` cannot be determined, `AppCachedImage` gracefully falls back to unconstrained decoding without crashing.
  - In `MiniAppErrorBoundary`, clicking "Retry" re-instantiates the child tree. If the error persists, the user can safely click "Go Home" to navigate to the default landing tab.
- **Gradual Adoption:**
  1. Phase 1: Deploy foundation components in `packages/core`, `packages/platform`, and `packages/ui_kit`.
  2. Phase 2: Wrap the 3 Shell tabs (`Home`, `Scanner`, `Settings`) in `MiniAppErrorBoundary`.
  3. Phase 3: Integrate `MiniAppErrorBoundary` into the `pac_mvi_feature` Mason brick so newly generated Mini Apps are safe by default.

---

## 6. Kanban Tasks Breakdown

- [ ] [Task 1: Image Cache Optimization & Downsampling Helper](task_1_app_cached_image_and_ram_cap.md) ([Kanban Board Link](../../features/task_1_app_cached_image_and_ram_cap.md))
- [ ] [Task 2: Mini App Crash Isolation & Error Boundary](task_2_mini_app_error_boundary.md) ([Kanban Board Link](../../features/task_2_mini_app_error_boundary.md))
- [ ] [Task 3: Memory Pressure Observer & Low Memory Event](task_3_memory_pressure_observer.md) ([Kanban Board Link](../../features/task_3_memory_pressure_observer.md))
- [ ] [Task 4: Network Connectivity Service & Standalone Offline Banner](task_4_network_connectivity_service_and_offline_banner.md) ([Kanban Board Link](../../features/task_4_network_connectivity_service_and_offline_banner.md))

