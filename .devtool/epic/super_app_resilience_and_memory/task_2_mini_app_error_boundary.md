---
id: "task_2_mini_app_error_boundary"
status: "todo"
priority: "high"
assignee: null
epic: "super_app_resilience_and_memory"
dueDate: null
created: "2026-09-11T03:43:30+07:00"
modified: "2026-09-11T03:50:00+07:00"
completedAt: null
labels: ["resilience", "error_boundary", "ui_kit", "shell", "bdd", "tdd"]
order: "a2"
---

# Task 2: Mini App Crash Isolation & Error Boundary

Epic: [super_app_resilience_and_memory](../epic/super_app_resilience_and_memory/super_app_resilience_and_memory.en.md)  
BDD Specifications: [bdd_scenarios.md](../epic/super_app_resilience_and_memory/bdd_scenarios.md)

## Requirement Analysis
In a modular Super App, third-party or autonomous feature modules can experience unhandled exceptions or rendering errors during `build()`. Without an error boundary, Flutter renders a fatal Red/Grey Screen of Death that crashes the entire host shell and freezes user navigation.

Key Requirements:
1. Implement `MiniAppErrorBoundary` in `packages/ui_kit/lib/widgets/mini_app_error_boundary.dart`:
   - Intercept runtime and rendering exceptions thrown in its subtree.
   - Present an **In-Place Full-Screen Fallback UI** preserving the outer shell and tabs.
   - Fallback UI must include:
     - Warning icon & informative title (e.g. "Tính năng tạm thời gián đoạn").
     - **"Thử lại"** (Retry) button: resets boundary state and attempts to re-mount the child widget.
     - **"Về Trang Chủ"** (Go Home) button: invokes provided callback or navigates safely to the default tab.
     - Debug Accordion (visible only in `kDebugMode`): expandable panel showing the exception and stack trace for developer troubleshooting.
2. Integrate `MiniAppErrorBoundary` into the Super App Host:
   - Wrap all 3 root tabs (`Home`, `Scanner`, `Settings`) in `lib/shell/shell_page.dart`.
3. Update Mason brick `pac_mvi_feature`:
   - Update template so newly generated Mini Apps automatically include `MiniAppErrorBoundary` wrapping their root page view.
4. Export through `packages/ui_kit/lib/ui_kit.dart`.

## Relevant Files & Context Pointers
- `packages/ui_kit/lib/widgets/mini_app_error_boundary.dart` — [NEW] Crash isolation boundary widget.
- `packages/ui_kit/lib/ui_kit.dart` — Public barrel export for `packages/ui_kit`.
- `lib/shell/shell_page.dart` — Super App Shell hosting bottom navigation tabs.
- `bricks/pac_mvi_feature/__brick__/lib/features/{{{name.snakeCase()}}}/presentation/page/{{{name.snakeCase()}}}_page.dart` — Mason template to update.
- `packages/ui_kit/test/mini_app_error_boundary_test.dart` — [NEW] Widget test suite.

## Design Rationale
- **In-Place Fault Isolation:** By catching errors within a dedicated `StatefulWidget` error boundary, only the faulty Mini App is replaced by the fallback view. The host's bottom navigation bar, notification tray, and sibling tabs remain completely functional.
- **Skill Pointer:** Refer to `.agents/skills/mobile-uiux-promax/SKILL.md` for a clean, user-friendly fallback design with appropriate spacing and theme tokens.

### BDD SCENARIOS

**Mandatory Self-Review Checklist:**
- [x] Cross-checked against Sequence Diagram: `MiniApp --x Boundary: Exception during build()` -> `Boundary: Catch error & state = hasError` -> `Display In-Place Fallback UI (Retry / Go Home)` -> `Shell BottomBar remains active` in `super_app_resilience_and_memory.en.md`.
- [x] Verified debug stack trace exposure is completely stripped in `kReleaseMode`.

#### Scenario 1: Happy Path — Healthy Mini App Child Widget
- **Given** a normal child widget with no runtime errors
- **When** wrapped in `MiniAppErrorBoundary` and mounted in the tree
- **Then** the child widget renders directly without interference or performance overhead.

#### Scenario 2: Error Interception — Crash Isolation & In-Place Fallback UI
- **Given** a child widget that throws a synchronous exception or `FlutterError` during `build()`
- **When** `MiniAppErrorBoundary` catches the error
- **Then** it isolates the crash to its own subtree and sets `hasError = true`
- **And** the parent Shell, bottom navigation bar, and other tabs remain fully functional
- **And** an in-place fallback UI renders with warning icon, title, "Thử lại", and "Về Trang Chủ" buttons.

#### Scenario 3: Recovery Action — "Thử lại" (Retry) Button
- **Given** an error boundary currently showing the fallback UI
- **When** the user taps the "Thử lại" button
- **Then** `hasError` is reset to false and child widget rebuild is re-triggered
- **And** if the underlying transient issue has resolved, the healthy child view restores cleanly.

#### Scenario 4: Recovery Action — "Về Trang Chủ" (Go Home) Button
- **Given** an error boundary displaying the fallback UI
- **When** the user taps "Về Trang Chủ"
- **Then** the `onGoHome` callback is invoked (or active tab switches to Tab 0: Home)
- **And** the user safely exits the broken screen.

#### Scenario 5: Security / Privacy — Debug Accordion Visibility
- **Given** an intercepted crash with full stack trace
- **When** running in `kDebugMode`
- **Then** an expandable "Chi tiết lỗi (Debug)" accordion is rendered displaying the error message and stack trace
- **When** running in `kReleaseMode` (production)
- **Then** the debug accordion is completely omitted to protect sensitive internal symbols.

## TDD Checklist (The Dev Persona)
- [ ] **RED**: Write failing widget tests in `packages/ui_kit/test/mini_app_error_boundary_test.dart`:
  - Test healthy child renders without fallback UI.
  - Test throwing child triggers fallback UI and contains "Thử lại" & "Về Trang Chủ" buttons.
  - Test tapping "Thử lại" triggers rebuild attempt.
  - Test tapping "Về Trang Chủ" invokes `onGoHome` callback.
  - Test stack trace accordion renders in debug mode and is absent in release mode.
- [ ] **GREEN**: Implement minimal code:
  - Create `MiniAppErrorBoundary` in `packages/ui_kit/lib/widgets/mini_app_error_boundary.dart`.
  - Wrap tabs in `lib/shell/shell_page.dart`.
  - Update `pac_mvi_feature` template.
  - Verify all tests pass.
- [ ] **REFACTOR**:
  - Export component in `packages/ui_kit/lib/ui_kit.dart`.
  - Format with `dart format -l 99`.
  - Verify zero lint warnings with `melos run analyze`.

## Definition of Done (DoD)
- [ ] 100% test coverage on `mini_app_error_boundary_test.dart` matching all BDD scenarios.
- [ ] Mini App exceptions are 100% isolated; host shell navigation never freezes.
- [ ] Stack trace accordion securely hidden in release builds.
- [ ] Conforms strictly to project conventions.

## Dependencies & Blockers
- Blocked by: None.
- Blocks: None.

## References & Rollback
- References: Flutter `ErrorWidget.builder`, `FlutterErrorDetails`.
- Rollback Strategy: Revert `lib/shell/shell_page.dart` and delete `mini_app_error_boundary.dart`.
