---
id: "task_4_network_connectivity_service_and_offline_banner"
status: "todo"
priority: "high"
assignee: null
epic: "super_app_resilience_and_memory"
dueDate: null
created: "2026-09-11T03:43:30+07:00"
modified: "2026-09-11T03:50:00+07:00"
completedAt: null
labels: ["network", "connectivity", "ui_kit", "core", "bdd", "tdd"]
order: "a4"
---

# Task 4: Network Connectivity Service & Standalone Offline Banner

Epic: [super_app_resilience_and_memory](../epic/super_app_resilience_and_memory/super_app_resilience_and_memory.en.md)  
BDD Specifications: [bdd_scenarios.md](../epic/super_app_resilience_and_memory/bdd_scenarios.md)

## Requirement Analysis
In mobile environments, apps frequently encounter intermittent connectivity, Wi-Fi captive portals with no real internet access, or sudden link drops. Without reachability verification, users experience frozen screens or cryptic network errors.

Key Requirements:
1. Add `internet_connection_checker_plus` to `packages/core/pubspec.yaml`.
2. Define `NetworkStatus` enum (`online`, `offline`, `unknown`) and contract `INetworkConnectivityService` in `packages/core/lib/services/network_connectivity_service.dart`:
   - `Stream<NetworkStatus> get onStatusChanged`
   - `Future<bool> get isConnected`
   - Hybrid reachability logic: Listen to `connectivity_plus` stream for OS network interface changes, followed by `internet_connection_checker_plus.hasInternetAccess` to verify true connectivity (100% immune to captive portals).
3. Register `NetworkConnectivityService` as a singleton in `packages/core/lib/di/core_module.dart`.
4. Create standalone `OfflineBanner` and `OfflineBannerWrapper` in `packages/ui_kit/lib/widgets/offline_banner.dart`:
   - Standalone opt-in component (Option B): Mini App screens wrap their content with `OfflineBannerWrapper` or drop `OfflineBanner` into their layouts.
   - Smooth slide & fade transition between offline and online states.
   - Distinct design adhering to UI Kit typography and colors (e.g. red/warning amber ribbon with offline icon and retry prompt).
5. Export service and widget through `packages/core/lib/core.dart` and `packages/ui_kit/lib/ui_kit.dart`.

## Relevant Files & Context Pointers
- `packages/core/pubspec.yaml` — Add `internet_connection_checker_plus`.
- `packages/core/lib/services/network_connectivity_service.dart` — [NEW] Hybrid connectivity service.
- `packages/core/lib/di/core_module.dart` — Core DI module registration.
- `packages/core/lib/core.dart` — Public barrel export for `packages/core`.
- `packages/ui_kit/lib/widgets/offline_banner.dart` — [NEW] Standalone offline banner & wrapper widget.
- `packages/ui_kit/lib/ui_kit.dart` — Public barrel export for `packages/ui_kit`.
- `packages/core/test/network_connectivity_service_test.dart` — [NEW] Unit test suite.
- `packages/ui_kit/test/offline_banner_test.dart` — [NEW] Widget test suite.

## Design Rationale
- **Hybrid Verification Strategy:** `connectivity_plus` operates at the OS hardware level (detecting Wi-Fi/Cellular/None) but cannot tell if a Wi-Fi network actually has internet access. Coupling it with `internet_connection_checker_plus` provides zero-latency event notifications with true reachability validation.
- **Standalone Opt-In UI:** Screen-level integration gives individual Mini Apps granular control over how and where offline states are displayed without imposing a rigid global shell overlay across all features.
- **Skill Pointer:** Refer to `.agents/skills/mobile-uiux-promax/SKILL.md` for smooth animation curves and accessible color contrast.

### BDD SCENARIOS

**Mandatory Self-Review Checklist:**
- [x] Cross-checked against HLD Use Cases: Hybrid reachability model with `internet_connection_checker_plus` eliminates 100% captive portal false positives.
- [x] Verified stream subscriptions in `OfflineBannerWrapper` are disposed to prevent memory leaks.

#### Scenario 1: Happy Path — True Internet Reachability on Wi-Fi/Cellular
- **Given** an active device connected to Wi-Fi or Cellular network
- **When** `connectivity_plus` signals available network interface
- **And** `internet_connection_checker_plus.hasInternetAccess` verifies endpoint reachability
- **Then** `NetworkConnectivityService` emits `NetworkStatus.online`
- **And** `isConnected` returns `true`.

#### Scenario 2: Edge Case — Wi-Fi Captive Portal / Dead Router (False Positive Immunity)
- **Given** device connected to a public Wi-Fi access point without internet access
- **When** `connectivity_plus` signals `ConnectivityResult.wifi`
- **But** `internet_connection_checker_plus.hasInternetAccess` probe fails (returns false)
- **Then** `NetworkConnectivityService` emits `NetworkStatus.offline`
- **And** `isConnected` returns `false`
- **And** no false-positive online state is broadcasted to the app.

#### Scenario 3: Immediate Reaction — Hardware Link Disconnect
- **Given** user enables Airplane Mode or disconnects hardware interfaces
- **When** `connectivity_plus` emits `ConnectivityResult.none`
- **Then** `NetworkConnectivityService` immediately emits `NetworkStatus.offline` without awaiting socket probe timeouts.

#### Scenario 4: UI Animation — Standalone OfflineBannerWrapper on Network Loss
- **Given** a Mini App screen wrapped inside `OfflineBannerWrapper` in online state
- **When** `NetworkConnectivityService` emits `NetworkStatus.offline`
- **Then** the offline banner smoothly slides down into view at the top of the screen
- **And** displays an offline icon and warning text: "Không có kết nối mạng".

#### Scenario 5: UI Animation — Auto-Dismiss on Network Recovery
- **Given** `OfflineBannerWrapper` currently presenting the offline banner
- **When** internet reachability is restored and `NetworkStatus.online` is emitted
- **Then** the banner smoothly slides up and fades out
- **And** the child content returns to normal layout without flicker.

#### Scenario 6: Async / Race Condition — Rapid Flapping Debounce
- **Given** device connection flapping rapidly (e.g. elevator transition: on/off 5 times in 2 seconds)
- **When** multiple raw connectivity events arrive in rapid succession
- **Then** `NetworkConnectivityService` debounces probe checks
- **And** emits only verified, settled state changes
- **And** avoids rapid flashing of the UI banner.

## TDD Checklist (The Dev Persona)
- [ ] **RED**: Write failing tests:
  - In `packages/core/test/network_connectivity_service_test.dart`:
    - Test status emits `NetworkStatus.offline` when `connectivity_plus` reports none.
    - Test status emits `NetworkStatus.offline` when `connectivity_plus` reports wifi but `internet_connection_checker_plus` returns false (captive portal).
    - Test status emits `NetworkStatus.online` when both report available and reachable.
    - Test debouncing under rapid connectivity flapping.
  - In `packages/ui_kit/test/offline_banner_test.dart`:
    - Test `OfflineBanner` renders with message when offline.
    - Test `OfflineBannerWrapper` shows child normally and displays banner only upon offline stream event.
    - Test banner auto-dismisses when stream emits online.
- [ ] **GREEN**: Implement minimal code:
  - Add dependency in `packages/core/pubspec.yaml`.
  - Implement `NetworkConnectivityService` in `packages/core/lib/services/network_connectivity_service.dart`.
  - Register in `packages/core/lib/di/core_module.dart`.
  - Implement `OfflineBanner` and `OfflineBannerWrapper` in `packages/ui_kit/lib/widgets/offline_banner.dart`.
  - Verify all tests pass.
- [ ] **REFACTOR**:
  - Export from `packages/core/lib/core.dart` and `packages/ui_kit/lib/ui_kit.dart`.
  - Format with `dart format -l 99`.
  - Verify zero lint warnings with `melos run analyze`.

## Definition of Done (DoD)
- [ ] 100% test pass rate covering all BDD scenarios.
- [ ] Captive portal false positive immunity verified.
- [ ] Offline banner smoothly animates in and out.
- [ ] Conforms strictly to project conventions.

## Dependencies & Blockers
- Blocked by: None.
- Blocks: None.

## References & Rollback
- References: `internet_connection_checker_plus`, `connectivity_plus`.
- Rollback Strategy: Revert `core_module.dart` and remove `network_connectivity_service.dart`.
