---
id: "task_1_app_cached_image_and_ram_cap"
status: "todo"
priority: "high"
assignee: null
epic: "super_app_resilience_and_memory"
dueDate: null
created: "2026-09-11T03:43:30+07:00"
modified: "2026-09-11T03:49:00+07:00"
completedAt: null
labels: ["performance", "memory", "ui_kit", "bdd", "tdd"]
order: "a1"
---

# Task 1: Image Cache Optimization & Downsampling Helper

Epic: [super_app_resilience_and_memory](../epic/super_app_resilience_and_memory/super_app_resilience_and_memory.en.md)

## Requirement Analysis
In high-density feeds and multi-package layouts, loading full-resolution remote images into small thumbnail widgets forces the Flutter Engine to decode uncompressed bitmaps directly into memory (e.g. 2000x2000 px = ~16MB RAM/image), quickly exhausting graphical memory and causing Out-Of-Memory (OOM) crashes on low/mid-tier devices.

Key Requirements:
1. Create `AppCachedImage` in `packages/ui_kit/lib/widgets/app_cached_image.dart` wrapping `cached_network_image`:
   - Compute physical pixel decode boundaries: `memCacheWidth = (width * devicePixelRatio).round()` and `memCacheHeight = (height * devicePixelRatio).round()`.
   - Provide clean parameter defaults (`fit = BoxFit.cover`, optional `borderRadius`).
   - Integrate `ShimmerLoadingBox` as the default loading placeholder when `enableShimmer: true`.
   - Provide a safe, non-crashing broken-image error fallback widget when loading fails.
2. Create `ShimmerLoadingBox` in `packages/ui_kit/lib/widgets/shimmer_loading_box.dart` using the existing `shimmer` package.
3. Configure global Flutter `ImageCache` limits in `packages/core/lib/app_initializer/app_initializer.dart`:
   - Set `PaintingBinding.instance.imageCache.maximumSize = 100` (max cached entries).
   - Set `PaintingBinding.instance.imageCache.maximumSizeBytes = 50 * 1024 * 1024` (50MB hard ceiling).
4. Export components through `packages/ui_kit/lib/ui_kit.dart`.

## Relevant Files & Context Pointers
- `packages/ui_kit/lib/widgets/app_cached_image.dart` — [NEW] Optimized downsampling cached image widget.
- `packages/ui_kit/lib/widgets/shimmer_loading_box.dart` — [NEW] Reusable shimmer placeholder box.
- `packages/ui_kit/lib/ui_kit.dart` — Public barrel export for `packages/ui_kit`.
- `packages/core/lib/app_initializer/app_initializer.dart` — Core initialization orchestrator.
- `packages/ui_kit/test/app_cached_image_test.dart` — [NEW] Widget test suite.
- `packages/ui_kit/test/shimmer_loading_box_test.dart` — [NEW] Widget test suite.

## Design Rationale
- **Memory Downsampling at Decode Time:** Passing `memCacheWidth` and `memCacheHeight` instructs the underlying image codec to scale the image as it decodes, rather than buffering the full resolution into RAM. For a 50x50 UI avatar, RAM drops from 16MB to ~90KB (over 99% savings).
- **Skill Pointer:** Developers or agents implementing this task should refer to `.agents/skills/mobile-uiux-promax/SKILL.md` for polished shimmer placeholders and smooth fade-in animations.

### BDD SCENARIOS

**Mandatory Self-Review Checklist:**
- [x] Cross-checked against Sequence Diagram: `MiniApp -> CachedImg -> Cache: Decode with memCacheWidth: 180 (60 * 3 DPR)` in `super_app_resilience_and_memory.en.md`.
- [x] Verified zero unhandled exceptions for edge cases (null dimensions, malformed URLs).

#### Scenario 1: Happy Path — Auto-Calculated Physical Pixel Downsampling
- **Given** a valid image URL `https://example.com/photo.png`, specified logical dimensions `width = 60`, `height = 60`, and device pixel ratio `devicePixelRatio = 3.0`
- **When** `AppCachedImage` is built into the widget tree
- **Then** it must configure the underlying image provider with `memCacheWidth = 180` and `memCacheHeight = 180`
- **And** memory consumption scales to the 180px thumbnail rather than original image bitmap.

#### Scenario 2: Happy Path — Shimmer Loading Placeholder
- **Given** `enableShimmer: true` and an image fetch in progress
- **When** `AppCachedImage` is in loading state
- **Then** `ShimmerLoadingBox` is rendered with matching dimensions and configured border radius
- **And** when the network fetch completes, the image smoothly transitions into view.

#### Scenario 3: Edge Case — Unconstrained / Null Dimensions & Zero DPR
- **Given** an image rendered without explicit width or height (`width = null`, `height = null`)
- **When** `AppCachedImage` builds
- **Then** `memCacheWidth` and `memCacheHeight` default safely to `null` without throwing a runtime exception or crash
- **And** if `devicePixelRatio <= 0`, it gracefully clamps to `1.0`.

#### Scenario 4: Edge Case — Malformed URL or Empty String
- **Given** an empty image URL `""` or invalid URI scheme `htp:/broken`
- **When** `AppCachedImage` builds and attempts resolution
- **Then** it catches the failure gracefully and renders the fallback error widget (broken image icon) without crashing the screen.

#### Scenario 5: Async / Race Condition — Fast Scrolling & Rapid URL Switching
- **Given** a list view where `AppCachedImage` receives a new URL before the previous network image has finished loading
- **When** the widget updates with new properties
- **Then** the previous image fetch/decode is cancelled cleanly
- **And** no stale image is displayed, nor memory leaked.

#### Scenario 6: Global Image Cache Initialization Ceiling
- **Given** application startup executed via `AppInitializer.init()`
- **When** the initialization completes
- **Then** `PaintingBinding.instance.imageCache.maximumSize` equals 100
- **And** `PaintingBinding.instance.imageCache.maximumSizeBytes` equals `50 * 1024 * 1024` (50MB).

## TDD Checklist (The Dev Persona)
- [ ] **RED**: Write failing widget tests in `packages/ui_kit/test/app_cached_image_test.dart` and `shimmer_loading_box_test.dart`:
  - Test physical pixel calculation with various `devicePixelRatio` values (1.0, 2.0, 3.0).
  - Test placeholder rendering with shimmer enabled and disabled.
  - Test error widget display when image loading fails or URL is malformed.
  - Test global `ImageCache` limits configuration in `packages/core/test/app_initializer_test.dart`.
- [ ] **GREEN**: Implement minimal code:
  - Create `ShimmerLoadingBox` in `packages/ui_kit/lib/widgets/shimmer_loading_box.dart`.
  - Create `AppCachedImage` in `packages/ui_kit/lib/widgets/app_cached_image.dart`.
  - Update `AppInitializer` in `packages/core/lib/app_initializer/app_initializer.dart` to set the 50MB / 100 entries ceiling.
  - Verify all tests pass.
- [ ] **REFACTOR**:
  - Export components in `packages/ui_kit/lib/ui_kit.dart`.
  - Format with `dart format -l 99`.
  - Verify zero lint or analysis warnings with `melos run analyze`.

## Definition of Done (DoD)
- [ ] 100% test coverage across all BDD scenarios in `app_cached_image_test.dart`.
- [ ] `AppCachedImage` automatically calculates physical downsample boundaries based on `devicePixelRatio`.
- [ ] Global `ImageCache` cap (50MB / 100 items) is configured on startup.
- [ ] Conforms strictly to project conventions (line length 99, no relative imports).

## Dependencies & Blockers
- Blocked by: None. Can be implemented immediately as the foundational UI memory layer.
- Blocks: None.

## References & Rollback
- References: Flutter `PaintingBinding.instance.imageCache`, `cached_network_image` documentation.
- Rollback Strategy: Revert `app_initializer.dart` changes and remove new widgets from `packages/ui_kit/lib/widgets/`.
