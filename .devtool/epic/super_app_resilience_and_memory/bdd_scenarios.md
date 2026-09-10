# BDD Behavioral Test Specifications: Super App Resilience & Memory Management

**Epic:** [super_app_resilience_and_memory](super_app_resilience_and_memory.en.md)  
**Status:** Living Documentation & AI Agent Context Injection Contract  
**Created:** 2026-09-11  

---

## 1. Living Documentation Overview

This document provides a single, unambiguous behavioral contract for the **Super App Resilience & Memory Management** epic. Written in standard Gherkin syntax (`Given - When - Then`), it bridges business intent, quality assurance, and architecture.
- **For Human Maintainers:** Rapidly understand the business boundaries, edge-case handling, fail-safe mechanisms, and memory lifecycle without diving into implementation code.
- **For AI Agents:** Directly inject this file into agent context to drive test generation, code validation, and regression prevention with zero hallucinations.

---

## 2. Pillar 1: Image Cache Optimization & Downsampling

```gherkin
Feature: Image Cache Optimization & Physical Pixel Decode Downsampling
  As a mobile app user on a low-to-mid tier device
  I want remote images to be automatically scaled down to their display size upon decoding
  So that graphical RAM consumption is minimized by >95% and Out-Of-Memory (OOM) crashes are prevented

  # ==========================================
  # Group 1.1: Physical Pixel Downsampling
  # ==========================================
  Scenario: [BDD-IMG-01] Auto-calculate physical decode boundaries from logical size and DPR
    Given a remote image URL "https://cdn.d3nexus.com/avatar.png" (actual size: 2000x2000 px, ~16MB uncompressed)
    And an AppCachedImage widget configured with logical dimensions: width = 60, height = 60
    And running on a mobile display with devicePixelRatio = 3.0
    When the widget requests image decoding from the underlying engine
    Then memCacheWidth is computed as 180 (60 * 3.0)
    And memCacheHeight is computed as 180 (60 * 3.0)
    And the image codec allocates approximately 90KB in GPU RAM instead of 16MB

  Scenario: [BDD-IMG-02] Graceful fallback when dimensions or DPR are unconstrained
    Given an AppCachedImage rendered with width = null or height = null
    When the image builds into the tree
    Then memCacheWidth and memCacheHeight default safely to null without throwing exceptions
    And if devicePixelRatio is reported as <= 0 or invalid, it gracefully clamps to 1.0

  # ==========================================
  # Group 1.2: Shimmer Loading & Error Handling
  # ==========================================
  Scenario: [BDD-IMG-03] Shimmer placeholder animation during network fetch
    Given an AppCachedImage configured with enableShimmer = true
    When the network fetch is active and bytes are being downloaded
    Then a ShimmerLoadingBox widget is rendered with the exact target width, height, and borderRadius
    And upon successful fetch completion, the image cross-fades smoothly into view

  Scenario: [BDD-IMG-04] Broken URL or Network Failure fallback
    Given an invalid URL "htp://broken-link" or a server returning HTTP 404/500
    When the image provider fails to resolve
    Then AppCachedImage intercepts the error gracefully
    And renders a fallback error widget with a broken image icon
    And no unhandled FlutterError or Red Screen of Death is emitted

  # ==========================================
  # Group 1.3: Fast Scrolling & Global RAM Ceiling
  # ==========================================
  Scenario: [BDD-IMG-05] Rapid scrolling and URL switching (Race Condition)
    Given an AppCachedImage in a fast-scrolling list
    When the widget is recycled and its URL changes before the prior image finishes decoding
    Then the previous decoding task is cancelled immediately
    And no stale image frame or memory leak occurs

  Scenario: [BDD-IMG-06] Global ImageCache hard limits on startup
    Given the application bootstrapping via AppInitializer.init()
    When startup finishes
    Then PaintingBinding.instance.imageCache.maximumSize equals 100 entries
    And PaintingBinding.instance.imageCache.maximumSizeBytes equals 52428800 bytes (50MB)
```

---

## 3. Pillar 2: Mini App Crash Isolation & Error Boundary

```gherkin
Feature: Mini App Crash Isolation & Error Boundary
  As a Super App user
  I want a crash in an individual Mini App tab to be isolated within its view
  So that the Shell bottom navigation bar and other Mini Apps remain 100% interactive

  # ==========================================
  # Group 2.1: In-Place Crash Isolation
  # ==========================================
  Scenario: [BDD-ERR-01] Healthy child widget renders without interference
    Given a valid MiniApp screen wrapped inside MiniAppErrorBoundary
    When the screen builds successfully
    Then MiniAppErrorBoundary renders the child directly with zero performance overhead

  Scenario: [BDD-ERR-02] Isolate fatal build exception and show In-Place Fallback UI
    Given the Scanner Mini App wrapped inside MiniAppErrorBoundary
    When a null pointer exception or unhandled error is thrown during build()
    Then MiniAppErrorBoundary intercepts the error before reaching the Flutter Engine root
    And the Scanner tab is replaced by an in-place fallback UI
    And the Shell bottom navigation bar remains fully interactive
    And switching to the Home or Settings tab functions normally without crash

  # ==========================================
  # Group 2.2: Recovery & Navigation Actions
  # ==========================================
  Scenario: [BDD-ERR-03] User taps "Thử lại" (Retry) button
    Given an error boundary currently displaying the in-place fallback UI
    When the user taps the "Thử lại" button
    Then the boundary resets hasError to false
    And re-mounts the child subtree
    And if the underlying issue is resolved, the normal screen renders cleanly

  Scenario: [BDD-ERR-04] User taps "Về Trang Chủ" (Go Home) button
    Given an error boundary displaying the fallback UI
    When the user taps "Về Trang Chủ"
    Then the onGoHome callback is invoked
    And the Shell switches active tab to Home (index 0)

  # ==========================================
  # Group 2.3: Security & Debuggability
  # ==========================================
  Scenario: [BDD-ERR-05] Debug Accordion visibility based on environment
    Given an error boundary capturing an exception with a 30-line stack trace
    When rendered in kDebugMode (development)
    Then an expandable "Chi tiết lỗi (Debug)" accordion is shown with raw error and stack trace
    When rendered in kReleaseMode (production)
    Then the raw stack trace is completely hidden to protect internal system paths
```

---

## 4. Pillar 3: OS Memory Pressure & Eviction Broadcast

```gherkin
Feature: Operating System Memory Pressure & Eviction Broadcast
  As a mobile operating system under heavy memory load
  I want the app to respond to low memory pressure warnings immediately
  So that background RAM is reclaimed and the app is not terminated by the OS Low Memory Killer / Jetsam

  # ==========================================
  # Group 3.1: Framework Cache Purge
  # ==========================================
  Scenario: [BDD-MEM-01] Purge Flutter image cache on memory pressure
    Given MemoryPressureObserver registered with WidgetsBinding
    When the mobile OS triggers didHaveMemoryPressure()
    Then PaintingBinding.instance.imageCache.clear() is invoked immediately
    And PaintingBinding.instance.imageCache.clearLiveImages() is invoked
    And all unreferenced decoded bitmaps are released from RAM

  # ==========================================
  # Group 3.2: Decoupled Event Bus Broadcast
  # ==========================================
  Scenario: [BDD-MEM-02] Dispatch LowMemoryEvent to modular subscribers
    Given repositories and Mini Apps subscribed to AppEventBus.on<LowMemoryEvent>()
    When MemoryPressureObserver intercepts didHaveMemoryPressure()
    Then a const LowMemoryEvent() is published onto the AppEventBus
    And all active subscribers receive the event in order
    And Mini Apps purge local memory caches (e.g. temporary scanner frames, search history)

  Scenario: [BDD-MEM-03] Resilient event handling under subscriber exceptions
    Given multiple subscribers listening to LowMemoryEvent
    When one subscriber throws an unhandled exception during eviction
    Then the error is caught and logged safely
    And other subscribers continue processing their cache cleanups without interruption
```

---

## 5. Pillar 4: Network Connectivity Verification & Standalone Offline Banner

```gherkin
Feature: Network Connectivity Verification & Standalone Offline Banner
  As a digital wallet user in variable network conditions (Wi-Fi, Cellular, Captive Portals)
  I want reliable detection of true internet reachability and non-intrusive offline warnings
  So that I am clearly informed when offline without false positive warnings or blocked UI

  # ==========================================
  # Group 4.1: Hybrid Reachability (Captive Portal Immunity)
  # ==========================================
  Scenario: [BDD-NET-01] True internet verification on Wi-Fi connection
    Given the device connects to a Wi-Fi network
    When connectivity_plus emits ConnectivityResult.wifi
    And internet_connection_checker_plus performs probe and returns true
    Then NetworkConnectivityService emits NetworkStatus.online
    And isConnected returns true

  Scenario: [BDD-NET-02] Wi-Fi captive portal / No internet access (False Positive Immunity)
    Given the device is connected to a public Wi-Fi access point with no internet access (Captive Portal)
    When connectivity_plus emits ConnectivityResult.wifi
    And internet_connection_checker_plus probe fails (returns false)
    Then NetworkConnectivityService emits NetworkStatus.offline
    And isConnected returns false

  Scenario: [BDD-NET-03] Hardware interface disconnected
    Given the user turns on Airplane Mode or disables all networks
    When connectivity_plus emits ConnectivityResult.none
    Then NetworkConnectivityService immediately emits NetworkStatus.offline without waiting for probe timeout

  # ==========================================
  # Group 4.2: Standalone Offline Banner Widget
  # ==========================================
  Scenario: [BDD-NET-04] OfflineBannerWrapper smooth transition on network loss
    Given a Mini App screen wrapped inside OfflineBannerWrapper
    And current state is online (banner is hidden)
    When NetworkConnectivityService emits NetworkStatus.offline
    Then the offline banner smoothly slides down into view at the top of the screen
    And displays the offline warning icon and message: "Không có kết nối mạng"

  Scenario: [BDD-NET-05] Auto-dismiss on connection restored
    Given OfflineBannerWrapper currently showing the offline ribbon
    When NetworkConnectivityService verifies true reachability and emits NetworkStatus.online
    Then the banner smoothly slides up and fades out of view
    And the underlying screen layout adjusts cleanly without jarring flicker

  Scenario: [BDD-NET-06] Rapid network flapping (Race Condition Debounce)
    Given network fluctuates between online and offline 5 times within 1 second
    When connectivity events arrive rapidly
    Then NetworkConnectivityService debounces probe checks
    And emits only stable, verified status transitions
    And the UI does not stutter or rapidly flash the banner
```
