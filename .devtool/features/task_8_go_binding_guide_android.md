---
id: "task_8_go_binding_guide"
status: "todo"
priority: "low"
assignee: null
epic: "template_android"
dueDate: null
created: "2026-08-29T00:00:00.000Z"
modified: "2026-08-29T00:00:00.000Z"
completedAt: null
labels: ["docs", "go", "android"]
order: "a8"
---
# Task 8: Go Binding Guide — Android Half

Epic: [template_android](../epic/template_android/template_android.en.md)

## Requirement Analysis
Write the Android half of `docs/architecture/native-go-binding.md`: how to wire a gomobile-produced `.aar` into a native package's `data/` layer, with a mandatory panic-recovery snippet at the JNI boundary. This is documentation + a copy-paste snippet, not a brick — Go integration is too library-specific to bake into code generation (per design doc §3/§4, "Go integration" bullet).

## Relevant Files & Context Pointers
- New: `docs/architecture/native-go-binding.md` (Android section; `template_ios` task 8 adds the iOS section to the same file).
- Reference: design doc §3.6 ("Native tích hợp Go") — panic must be recovered and converted to a Kotlin exception at the JNI boundary, never propagated up.
- Reference: `flutter_super_app_template.en.md` §2, rows 3/5 (Case 3, Case 5 — the concrete use cases this guide serves: E2EE encrypt/decrypt while a screen is open, and decrypting a push-notification preview in the background).

## Design Rationale
See design doc §3.6 and §4 ("Needs a Go binding" row). Kept out of the `native_package` brick deliberately — a Go binding's shape depends entirely on the specific `.aar`'s generated API, which a generic template can't anticipate; a documented, copy-paste-able pattern gets the same standardization benefit (a new dev follows one known-good shape) without forcing brick complexity that would rarely be used.

## TDD Checklist

**TDD Adaptation**: this task is documentation only — TDD does not apply. Verified via the concrete steps below.

- [ ] Document how to place a gomobile `.aar` into a native package's `data/` (module-level dependency, not `android/buildSrc`).
- [ ] Write the panic-recovery wrapper snippet (Kotlin `try`/`catch` around the JNI call boundary, converting Go panics surfaced as exceptions into a typed Kotlin error).
- [ ] Cross-reference `core.DataState<T>` as the return type convention for any Go-backed call.
- [ ] Note the `os_triggered` constraint from design doc §4: call Go directly from Kotlin in that case, never via a headless Flutter engine.

## Definition of Done (DoD)
- [ ] `docs/architecture/native-go-binding.md` exists with a complete, runnable-looking Android snippet (verified by inspection, no real gomobile library needed for this task).
- [ ] The doc explicitly states the panic-recovery-at-boundary rule as mandatory, not optional.

## Dependencies & Blockers
- **Dependencies**: [Task 2](task_2_native_core_module_android.md) (native `core`, for `DataState<T>` as the documented return-type convention).
- **Blockers**: None — this task is documentation-only, no gomobile library is integrated as part of this epic.

## References & Rollback
- **References**: [template_android.en.md](../epic/template_android/template_android.en.md), design doc §3.6.
- **Rollback Plan**: `git revert`; documentation-only, no code impact.
