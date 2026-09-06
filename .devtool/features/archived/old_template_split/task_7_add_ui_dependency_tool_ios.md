---
id: "task_7_add_ui_dependency_tool_ios"
status: "todo"
priority: "medium"
assignee: null
epic: "template_ios"
dueDate: null
created: "2026-08-29T00:00:00.000Z"
modified: "2026-08-29T00:00:00.000Z"
completedAt: null
labels: ["scripts", "ios"]
order: "a7"
---
# Task 7: `native_add_ui_dependency` — iOS Side

Epic: [template_ios](../epic/template_ios/template_ios.en.md)

## Requirement Analysis
iOS counterpart of `template_android` Task 7's "upgrade an existing no-UI package to add UI later" tool — a **separate script**, not a shared one with Android (per the "tách riêng lệnh hết" decision: every platform-specific command gets its own script/brick, never a shared entrypoint gated by a platform argument). On iOS this is lighter than Android's Hilt-bridge problem: adding a `Presentation/` layer mostly means adding the `ios/framework` (Task 1) dependency to the target's `Package.swift` (SPM-only, per Task 10 — no podspec involved) and, for a `PlatformView`-embedded case, registering a `FlutterPlatformViewFactory`.

## Relevant Files & Context Pointers
- New, standalone script: `scripts/native_add_ui_dependency_ios.sh <package_name>` (independent of Android's `native_add_ui_dependency_android.sh` — same conceptual job, separate command, separate file): patches the target package's `Package.swift` to add `ios/framework` as a dependency and confirms the SwiftLint/SwiftFormat wiring (already present from Task 3) doesn't need duplication.
- Manual checklist addition (same doc as `template_android` Task 7): create `Presentation/` (SwiftUI View + Swift `MviViewModel` subclass); for `trigger=passive`, register `FlutterPlatformViewFactory` in the existing `*Plugin.swift`'s `register(with:)`; for `trigger=os_triggered`, a new App Extension target is Xcode-project-file work, done manually (not scriptable via text templating, same constraint noted for Android's new-Activity case).

## Design Rationale
See design doc §4.1, applied to iOS. iOS has no DI-framework equivalent to Android's Hilt-bridge complexity (no build-time annotation processor decision), so this task is narrower in scope than its Android sibling — mainly a dependency-graph edit plus documentation, not a code-generation problem.

## TDD Checklist

**TDD Adaptation**: this task produces a standalone shell script, not application behavior under test — verified via the concrete dry-run steps below rather than RED/GREEN/REFACTOR.

- [ ] Implement `scripts/native_add_ui_dependency_ios.sh`.
- [ ] Verify idempotency (safe to re-run).
- [ ] Extend the shared manual checklist doc with the iOS-specific steps.
- [ ] Dry-run against `native_security` (scratch branch) to confirm the patched `Package.swift` still builds with `ios/framework` available.

## Definition of Done (DoD)
- [ ] Running `native_add_ui_dependency_ios.sh` against a `has_ui=false` package adds `ios/framework` without breaking the existing build.
- [ ] Re-running is a no-op (idempotent).
- [ ] The shared manual checklist doc covers both platforms' remaining manual steps.

## Dependencies & Blockers
- **Dependencies**: [Task 1](task_1_swift_mvi_viewmodel.md) (Swift `MviViewModel`/`ios/framework`). No dependency on `template_android`'s [Task 7](task_7_add_ui_dependency_tool_android.md) — the two scripts are independent by design.
- **Blockers**: None.

## References & Rollback
- **References**: [template_ios.en.md](../epic/template_ios/template_ios.en.md), design doc §4.1.
- **Rollback Plan**: `git revert`; script only patches the target package's `Package.swift`.
