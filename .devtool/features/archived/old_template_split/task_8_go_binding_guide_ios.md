---
id: "task_8_go_binding_guide_ios"
status: "todo"
priority: "low"
assignee: null
epic: "template_ios"
dueDate: null
created: "2026-08-29T00:00:00.000Z"
modified: "2026-08-29T00:00:00.000Z"
completedAt: null
labels: ["docs", "go", "ios"]
order: "a8"
---
# Task 8: Go Binding Guide — iOS Half

Epic: [template_ios](../epic/template_ios/template_ios.en.md)

## Requirement Analysis
Add the iOS section to `docs/architecture/native-go-binding.md` (Android section from `template_android` Task 8): how to wire a gomobile-produced `.xcframework` into a native package's `Data/` layer, with a mandatory panic-recovery snippet at the Swift/cgo boundary.

## Relevant Files & Context Pointers
- Extends: `docs/architecture/native-go-binding.md` (created in `template_android` Task 8) — add the iOS/`.xcframework` section.
- Reference: design doc §3.6 — panic must be recovered and converted to a Swift `Error` at the boundary, never propagated up.
- Reference: `flutter_super_app_template.en.md` §2, rows 3/5 (same use cases as the Android guide — E2EE while a screen is open, decrypting a push-notification preview in the background).

## Design Rationale
See design doc §3.6 and §4 ("Needs a Go binding" row) — same rationale as `template_android` Task 8: documentation, not a brick flag, because a Go binding's API shape is library-specific.

## TDD Checklist

**TDD Adaptation**: this task is documentation only — TDD does not apply. Verified via the concrete steps below.

- [ ] Document how to embed a gomobile `.xcframework` and link it into a native package's `Package.swift` (binary target).
- [ ] Write the panic-recovery wrapper snippet for the Swift/cgo boundary.
- [ ] Cross-reference `ios/core.DataState<T>` as the return-type convention for any Go-backed call.
- [ ] Note the `os_triggered` constraint: call Go directly from Swift in that case, never via a headless Flutter engine (there is no iOS equivalent headless-engine pattern worth inventing solely to reach Go).

## Definition of Done (DoD)
- [ ] `docs/architecture/native-go-binding.md`'s iOS section is complete with a runnable-looking Swift snippet (verified by inspection).
- [ ] The doc states the panic-recovery-at-boundary rule as mandatory for iOS, matching the Android section's framing.

## Dependencies & Blockers
- **Dependencies**: [Task 2](task_2_native_core_module_ios.md) (`ios/core`, for `DataState<T>`), `template_android`'s [Task 8](task_8_go_binding_guide_android.md) (shared doc file).
- **Blockers**: None — documentation-only.

## References & Rollback
- **References**: [template_ios.en.md](../epic/template_ios/template_ios.en.md), design doc §3.6.
- **Rollback Plan**: `git revert`; documentation-only, no code impact.
