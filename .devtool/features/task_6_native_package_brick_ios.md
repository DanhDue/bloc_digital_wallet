---
id: "task_6_native_package_brick_ios"
status: "todo"
priority: "high"
assignee: null
epic: "template_ios"
dueDate: null
created: "2026-08-29T00:00:00.000Z"
modified: "2026-08-29T00:00:00.000Z"
completedAt: null
labels: ["mason", "ios"]
order: "a6"
---
# Task 6: `native_ios_package` Mason Brick

Epic: [template_ios](../epic/template_ios/template_ios.en.md)

## Requirement Analysis
Build a standalone Mason brick, `native_ios_package(name, trigger, has_ui)`, covering all 4 quadrants (Ô1–Ô4) of iOS-side native scaffolding — a **separate brick from Android's** `native_android_package` (`template_android` Task 6), per the "tách riêng lệnh hết" decision. Both target the same `packages/{{name}}/` folder independently: a package needing both platforms runs both bricks against the same `name`; a package needing only iOS-side native code runs just this one.

## Relevant Files & Context Pointers
- New: `bricks/native_ios_package/brick.yaml` — vars `name` (string), `trigger` (enum `passive`|`os_triggered`), `has_ui` (boolean) — same var shape as `native_android_package` for consistency, even though the two bricks are invoked separately.
- New: `bricks/native_ios_package/__brick__/packages/{{name.snakeCase()}}/ios/Classes/{Platform,Domain,Data,Presentation}/` — a plugin/method-channel template for `Platform`, a background-task template pre-wrapped in `core.SafeExecution` for `os_triggered`, a SwiftUI View + Swift `MviViewModel` subclass for `Presentation`.
- New: `bricks/native_ios_package/__brick__/packages/{{name.snakeCase()}}/ios/{{name.snakeCase()}}/Package.swift` template (**SPM only, no `.podspec`** — per Task 10) — always wires the SwiftLint/SwiftFormat Run Script; no Hilt-equivalent gating needed (no forced DI-framework choice on iOS).
- New: `bricks/native_ios_package/hooks/post_gen.dart` — deletes `Presentation/` when `has_ui=false`; the background-task template and `ReplayQueue` wiring when `trigger=passive`. If `packages/{{name}}/` doesn't exist yet, scaffold the minimal Dart-facing plugin shell (declaring only the `ios:` platform block); if it already exists (Android side generated first), only add the `ios:` platform declaration.
- `mason.yaml` — register `native_ios_package`.

## Design Rationale
See design doc §3.4 and §4, applied to iOS — superseding the design doc's original "one shared brick" phrasing with the "tách riêng lệnh hết" decision. Matching var names/shape with `native_android_package` (without sharing an invocation) keeps the two bricks easy to reason about together even though they're run separately.

## TDD Checklist

**TDD Adaptation**: this task produces a code generator (Mason brick), not application behavior — correctness is verified by generating all flag combinations and inspecting/building the output (see steps), not classic RED/GREEN/REFACTOR.

- [ ] Scaffold `brick.yaml` with the 3 vars, matching `native_android_package`'s shape.
- [ ] Author the `__brick__/` templates for all 4 quadrants' iOS content.
- [ ] Implement `post_gen.dart`'s conditional deletion logic, plus the "create vs. merge into existing package" branch.
- [ ] Test all 4 flag combinations end to end, verifying against the Ô1–Ô4 diagrams in `flutter_super_app_template.en.md` §5.
- [ ] Test running this brick against a package that already has an Android-only native side (from `native_android_package`) to confirm the merge path works.

## Definition of Done (DoD)
- [ ] All 4 flag combinations generate iOS scaffolding matching the corresponding diagram.
- [ ] `has_ui=true` packages include a SwiftUI View + `MviViewModel` subclass; `has_ui=false` packages don't.
- [ ] Generated `os_triggered` entry-points are pre-wrapped in `core.SafeExecution`.
- [ ] Running against a package that already has an Android-only native side merges cleanly (adds the `ios:` platform block, doesn't clobber the existing `android:` block).

## Dependencies & Blockers
- **Dependencies**: [Task 1](task_1_swift_mvi_viewmodel.md) (Swift `MviViewModel`), [Task 2](task_2_native_core_module_ios.md) (`ios/core`), [Task 3](task_3_quality_tooling.md) (quality tooling), [Task 10](task_10_spm_only_packaging.md) (SPM-only packaging — this brick must never emit a `.podspec`).
- **Blockers**: None — resolved as a separate brick from Android's, per the "tách riêng lệnh hết" decision.

## References & Rollback
- **References**: [template_ios.en.md](../epic/template_ios/template_ios.en.md), design doc §3.4, `flutter_super_app_template.en.md` §5.
- **Rollback Plan**: `git revert`; brick is additive, no existing package depends on it.
