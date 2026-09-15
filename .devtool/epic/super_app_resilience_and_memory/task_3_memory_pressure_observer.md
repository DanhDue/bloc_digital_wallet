---
id: "task_3_memory_pressure_observer"
status: "done"
priority: "high"
assignee: null
epic: "super_app_resilience_and_memory"
dueDate: null
created: "2026-09-11T03:43:30+07:00"
modified: "2026-09-11T11:10:00+07:00"
completedAt: "2026-09-11T11:10:00+07:00"
labels: ["lifecycle", "memory", "event_bus", "core", "platform", "bdd", "tdd"]
order: "a3"
---

# Task 3: Memory Pressure Observer & Low Memory Event

Epic: [super_app_resilience_and_memory](super_app_resilience_and_memory.en.md)  
BDD Specifications: [bdd_scenarios.md](bdd_scenarios.md)

## Requirement Analysis
When mobile devices experience tight memory conditions, the operating system (Android Low Memory Killer or iOS Jetsam) dispatches memory pressure signals to active processes. If an app ignores these signals, the OS terminates the process immediately.

Key Requirements:
1. Define `LowMemoryEvent` in `packages/platform/lib/app_event_bus.dart`:
   - Extends `AppEvent`.
   - Immutable data class supporting value equality and hashing.
2. Implement `MemoryPressureObserver` in `packages/core/lib/services/memory_pressure_observer.dart`:
   - Implements `WidgetsBindingObserver`.
   - Overrides `didHaveMemoryPressure()`:
     1. Automatically purges Flutter's global image cache:
        ```dart
        PaintingBinding.instance.imageCache.clear();
        PaintingBinding.instance.imageCache.clearLiveImages();
        ```
     2. Dispatches `const LowMemoryEvent()` via `AppEventBus` to notify all subscribed Mini Apps and repositories.
3. Wire observer into `AppInitializer`:
   - Register `WidgetsBinding.instance.addObserver(MemoryPressureObserver())` during `AppInitializer.init()`.
4. Export through `packages/core/lib/core.dart`.

## Relevant Files & Context Pointers
- `packages/platform/lib/app_event_bus.dart` — Event bus contract to define `LowMemoryEvent`.
- `packages/core/lib/services/memory_pressure_observer.dart` — [NEW] Memory pressure listener.
- `packages/core/lib/app_initializer/app_initializer.dart` — Core initialization sequence.
- `packages/core/lib/core.dart` — Public barrel export for `packages/core`.
- `packages/core/test/memory_pressure_observer_test.dart` — [NEW] Unit test suite.
- `packages/platform/test/app_event_bus_test.dart` — Unit test suite for event dispatch.

## Design Rationale
- **Decoupled Eviction Architecture:** `MemoryPressureObserver` in `core` directly clears framework-level graphics cache, while publishing an asynchronous event over `AppEventBus`. Mini Apps and data layers can independently subscribe to `LowMemoryEvent` to drop large in-memory caches without introducing tight coupling to system lifecycle APIs.
- **Skill Pointer:** Refer to `.agents/skills/test-driven-development/SKILL.md` for establishing mock bindings and stream verification.

### BDD SCENARIOS

**Mandatory Self-Review Checklist:**
- [x] Cross-checked against Sequence Diagram: `User/OS -> MemObs: didHaveMemoryPressure()` -> `MemObs -> Cache: clear() & clearLiveImages()` -> `MemObs -> Bus: publish(LowMemoryEvent())` -> `Bus -> MiniApp: cache evictions` in `super_app_resilience_and_memory.en.md`.
- [x] Verified decoupled event bus dispatching doesn't crash if a subscriber throws.

#### Scenario 1: Happy Path — Immediate Flutter ImageCache Purge on Memory Pressure
- **Given** an active application session with cached image bitmaps
- **When** the mobile operating system dispatches `didHaveMemoryPressure()`
- **Then** `PaintingBinding.instance.imageCache.clear()` is called
- **And** `PaintingBinding.instance.imageCache.clearLiveImages()` is called
- **And** graphical memory is reclaimed instantly.

#### Scenario 2: Happy Path — Publish LowMemoryEvent onto AppEventBus
- **Given** repositories or Mini Apps subscribed to `AppEventBus.on<LowMemoryEvent>()`
- **When** `MemoryPressureObserver` receives `didHaveMemoryPressure()`
- **Then** `const LowMemoryEvent()` is published onto the event bus
- **And** all registered listeners receive the event
- **And** can release feature-specific ephemeral caches (e.g. uncompressed camera frames or in-memory lists).

#### Scenario 3: Edge Case — Safe Handling When ImageCache is Already Empty
- **Given** an empty `imageCache`
- **When** `didHaveMemoryPressure()` is triggered
- **Then** `clear()` and `clearLiveImages()` execute safely without throwing `StateError` or runtime exceptions.

#### Scenario 4: Edge Case — Zero Registered Listeners on AppEventBus
- **Given** no active subscribers for `LowMemoryEvent`
- **When** `LowMemoryEvent` is published
- **Then** the event is broadcasted without error, buffer overflow, or memory leak.

#### Scenario 5: Resilience — Subscriber Exception Isolation
- **Given** multiple listeners subscribed to `LowMemoryEvent`
- **When** one listener throws an unhandled exception inside its callback
- **Then** the event bus logs the failure cleanly
- **And** the remaining listeners continue receiving their eviction signals.

## TDD Checklist (The Dev Persona)
- [x] **RED**: Write failing tests:
  - In `packages/platform/test/app_event_bus_test.dart`: verify `LowMemoryEvent` can be published and filtered through `on<LowMemoryEvent>()`.
  - In `packages/core/test/services/memory_pressure_observer_test.dart`: verify `didHaveMemoryPressure()` triggers `imageCache.clear()` and publishes `LowMemoryEvent`.
- [x] **GREEN**: Implement minimal code:
  - Add `LowMemoryEvent` class to `packages/platform/lib/app_event_bus.dart`.
  - Implement `MemoryPressureObserver` in `packages/core/lib/services/memory_pressure_observer.dart`.
  - Wire registration in `AppInitializer.init()`.
  - Verify all tests pass.
- [x] **REFACTOR**:
  - Export in `packages/core/lib/core.dart`.
  - Format with `dart format -l 99`.
  - Verify zero lint warnings with `melos run analyze`.

## Definition of Done (DoD)
- [x] 100% test coverage across all BDD scenarios.
- [x] `LowMemoryEvent` exported from `packages/platform/lib/platform.dart`.
- [x] Image cache purged and event broadcast verified on OS memory pressure.
- [x] Conforms strictly to project conventions.

## Dependencies & Blockers
- Blocked by: None.
- Blocks: None.

## References & Rollback
- References: Flutter `WidgetsBindingObserver.didHaveMemoryPressure`.
- Rollback Strategy: Revert `app_initializer.dart` registration and remove `memory_pressure_observer.dart`.
