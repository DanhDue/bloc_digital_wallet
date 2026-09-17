# Epic: Cold Start & Graphics Optimization (HLD)

## 1. Meta Data
- **Epic Name**: `cold_start_optimization`
- **Status**: Done
- **Target Release**: `v1.1.0`
- **Platform**: `Flutter` (Melos Monorepo)
- **Source Spec**: [2026-09-17-cold-start-optimization-design.md](2026-09-17-cold-start-optimization-design.md)

---

## 2. Background
In the Flutter Super-App (`d3_nexus_shield`), application launch (cold start) experiences perceptible delays before rendering interactive UI. Analysis reveals two root causes:
1. **Pre-`runApp` Serial I/O Bottlenecks**: `lib/main.dart` sequentially awaits multiple asynchronous services before invoking `runApp()`. This blocks the Flutter engine from displaying Frame 0 while disk I/O (`SharedPreferences`), JSON translation file parsing, and platform channel queries (`app_links`) execute serially.
2. **First-Frame GPU Convolution & Eager Mounting**:
   - `ShellPage` uses `IndexedStack`, which eagerly mounts the widget and BLoC trees of all 3 tabs (`HomeDashboardPage`, `ScannerPage`, `SettingsPage`) on Frame 0, despite default landing on tab 2 (`SettingsPage`).
   - The active `SettingsPage` and `CustomBottomNavBar` feature multiple soft `BoxShadow` definitions with heavy `blurRadius` (10–12px). Without `RepaintBoundary` isolation, Flutter's rendering engine (Impeller/Skia) creates multiple offscreen buffers and Gaussian convolution passes in Frame 0, and recalculates these convolutions during scrolling or toggle state changes.

---

## 3. Goals & Non-Goals

### 3.1. Goals
- **TTID (Time to Initial Display)**: Reduce cold start time from ~1,500ms to **< 450ms**.
- **First Frame GPU Raster Time**: Reduce first-frame raster duration from > 35ms to **< 12ms**.
- **Eager Widget Mount Reduction**: Lazily instantiate only the active tab in `ShellPage`, reducing initial shell element allocation by **~66%**.
- **GPU Raster Isolation**: Wrap `CustomBottomNavBar` and `SettingsSectionWidget` in `RepaintBoundary` to leverage GPU layer caching and eliminate jank during scrolling and toggle transitions.
- **Non-blocking Bootstrapping**: Parallelize critical startup path and defer non-critical initialization (`LoggingInitializer`, dynamic translation overrides, `DeepLinkCoordinator`) to run post-Frame 0 via `addPostFrameCallback`.
- **100% Visual Preservation**: Retain exact design aesthetics, soft shadows, rounded borders, and blue glow effects without visual degradation.

### 3.2. Non-Goals
- Modifying UI layouts, color palettes, or deleting shadows.
- Altering business logic in domain use cases or BLoC state schemas.
- Upgrading Flutter SDK version or modifying native engine embedding.

---

## 4. Architecture & Technical Design

### 4.1. High-Level Architecture
```mermaid
graph TD
    subgraph PreRunApp ["1. Critical Bootstrapping (main.dart)"]
        A["main() Entry"] --> B["WidgetsFlutterBinding.ensureInitialized()"]
        B --> C["Future.wait()"]
        C --> D["Single SharedPreferences.getInstance()"]
        C --> E["Minimal Core DI Registration"]
        C --> F["core.ThemeManager.init(sharedPrefs)"]
        C --> G["Static Bundled Locale Init (Slang)"]
    end

    C --> H["runApp(AppRootWidget)"]

    subgraph Frame0 ["2. Frame 0 Render & Lazy Shell"]
        H --> I["MaterialApp.router"]
        I --> J["ShellPage"]
        J --> K["LazyIndexedStack"]
        K --> L["Active Tab Only (SettingsPage)"]
        K -.->|"Deferred until tapped"| M["Home & Scanner Tabs (SizedBox.shrink)"]
        L --> N["RepaintBoundary Isolated Cards"]
        J --> O["RepaintBoundary Isolated BottomNavBar"]
    end

    subgraph PostFrame ["3. Deferred Background Workers"]
        H -.-> P["WidgetsBinding.instance.addPostFrameCallback"]
        P --> Q["Parallel Background Initializers"]
        Q --> R["LoggingInitializer (Talker & Native Log Bridge)"]
        Q --> S["Localization: Cached Dynamic JSON Override"]
        Q --> T["DeepLinkCoordinator.initialize()"]
        Q --> U["MemoryPressureObserver & EnvironmentInitializer"]
    end
```

### 4.2. Use Cases Flowchart
```mermaid
flowchart TD
    User([App Launch Triggered]) --> LaunchApp[Launch App Cold Start]
    LaunchApp --> FastBoot[Execute Minimal Critical Path]
    FastBoot --> RenderFrame0[Render Frame 0 Shell & Active Tab]
    
    RenderFrame0 --> DisplayUI[User Views Interactive Settings Screen]
    RenderFrame0 -.-> RunWorkers[Run Deferred Background Workers]
    
    User --> TabTap{User Taps Tab?}
    TabTap -->|Tap Scanner Tab 1| MountScanner[Mount ScannerPage on demand & Cache]
    TabTap -->|Tap Home Tab 0| MountHome[Mount HomeDashboardPage on demand & Cache]
    TabTap -->|Scroll Settings| ScrollSmooth[Scroll without GPU Shadow Re-rasterization]
    
    User --> ToggleSwitch[Toggle Dark Mode / Debug Mode]
    ToggleSwitch --> IsolateRepaint[Repaint only modified row; Card shadow cached]
```

### 4.3. Sequence Diagram (Cold Start Lifecycle)
```mermaid
sequenceDiagram
    autonumber
    actor User
    participant OS as Operating System
    participant Main as main.dart
    participant Engine as Flutter Engine
    participant Shell as ShellPage
    participant Lazy as LazyIndexedStack
    participant Post as PostFrameQueue
    participant Worker as BackgroundInitializers

    User->>OS: Tap App Icon
    OS->>Main: Execute main()
    Main->>Main: WidgetsFlutterBinding.ensureInitialized()
    Main->>Main: Future.wait([SharedPreferences, Minimal DI, ThemeManager])
    Main->>Engine: runApp(AppRootWidget)
    Engine->>Shell: Mount ShellPage
    Shell->>Lazy: Build LazyIndexedStack(index: 2)
    Lazy->>Lazy: Instantiate Tab 2 (SettingsPage) ONLY
    Note over Lazy: Tabs 0 & 1 render SizedBox.shrink()
    Engine-->>User: Frame 0 Displayed (Interactive Settings UI) < 450ms
    Engine->>Post: Trigger addPostFrameCallback
    Post->>Worker: Future.wait([Logging, Dynamic JSON, DeepLink])
    Worker-->>Post: Background Workers Completed
```

### 4.4. Shift-Left Impact Analysis (Check 1)
- **Planned Target Files**:
  - `lib/main.dart`
  - `packages/ui_kit/lib/widgets/lazy_indexed_stack.dart` [NEW]
  - `lib/shell/shell_page.dart`
  - `lib/shell/widgets/custom_bottom_nav_bar.dart`
  - `features/settings/lib/presentation/settings/widgets/settings_section_widget.dart`
- **Blast Radius**: Isolated to startup orchestration, navigation shell container, and UI decoration layer. Zero breaking API changes to domain use cases or data repositories.
- **Cross-Platform Bridges**: Zero mutations to MethodChannel signatures.

---

## 5. Comprehensive BDD Test Scenarios

The complete 5-dimension BDD specification is maintained in [bdd_scenarios.md](bdd_scenarios.md).

Summary of Scenarios:
1. **Happy Paths**:
   - `Scenario: Cold start renders Frame 0 within 450ms with active tab only`
   - `Scenario: Switching tabs lazily mounts target tab and preserves state`
2. **Edge Cases & Boundaries**:
   - `Scenario: Initial index out of bounds clamped to valid tab range`
   - `Scenario: Rapid tab switching does not duplicate mounted widgets`
3. **State Transitions**:
   - `Scenario: Toggling dark mode re-renders isolated section without repainting other cards`
4. **Async & Race Conditions**:
   - `Scenario: Deep link arrives before background coordinator initialization finishes`
5. **Failures & Storage Resilience**:
   - `Scenario: Background dynamic translation JSON load fails gracefully to static Slang`

---

## 6. Rollout Strategy & Mitigation

- **Graceful Fallback**: If background dynamic translation fails, bundled static localizations keep the UI operational.
- **Buffering Inbound Deep Links**: Deep links arriving before `DeepLinkCoordinator` completes are queued in memory and dispatched when the router is marked ready.
- **Safety Rollback**: Because `LazyIndexedStack` conforms to `IndexedStack`'s signature, rolling back to eager mounting requires only a single widget name change if regressions occur.

---

## 7. Kanban Tasks Breakdown

The work is partitioned into 4 granular, test-driven tasks:
- **[Task 1: Lazy Navigation Shell (`LazyIndexedStack`)](task_01_lazy_indexed_stack_and_shell_navigation.md)**: Create `LazyIndexedStack` in `packages/ui_kit`, integrate into `ShellPage`, and verify lazy mount behavior.
- **[Task 2: GPU Layer & RepaintBoundary Optimization](task_02_repaint_boundary_and_gpu_shadow_caching.md)**: Add `RepaintBoundary` to `CustomBottomNavBar` and `SettingsSectionWidget`, and cache decoration objects.
- **[Task 3: Non-blocking Bootstrapping & Deferred I/O](task_03_non_blocking_bootstrapping_and_deferred_io.md)**: Parallelize `main.dart`, share single `SharedPreferences` instance, and defer dynamic localization and logging.
- **[Task 4: Host Acceptance Tests & Performance Benchmark](task_04_host_acceptance_tests_and_performance_benchmark.md)**: Profile cold start timeline, verify TTID < 450ms, and execute full `@quality_check` suite.
