---
id: "task_7_add_ui_dependency_tool"
status: "todo"
priority: "medium"
assignee: null
epic: "template_android"
dueDate: null
created: "2026-08-29T00:00:00.000Z"
modified: "2026-08-29T00:00:00.000Z"
completedAt: null
labels: ["scripts", "android", "hilt"]
order: "a7"
---
# Task 7: `scripts/native_add_ui_dependency_android.sh` (Android)

Epic: [template_android](../epic/template_android/template_android.en.md)

## Requirement Analysis
Build the tool half of "upgrade an existing no-UI package to add UI later" (design doc §4.1): a script that adds the `framework` dependency + applies the Hilt+Compose convention plugin to an already-generated `has_ui=false` package's `build.gradle`, plus a thin Hilt `@Module`/`@Provides` bridging its existing manual `Container` instances into Hilt's graph. Scaffolding `presentation/` itself and wiring the `PlatformView`/`Activity` boundary stay a manual checklist (not this task) per the explicit "tách" decision.

## Relevant Files & Context Pointers
- New: `scripts/native_add_ui_dependency_android.sh <package_name>` — patches `packages/<package_name>/android/build.gradle.kts`: adds `id("commons.android-feature")` alongside the existing `codeanalyzetools.{spotless,detekt-check}`; adds `android/framework` as a dependency.
- New: a Hilt `@Module` template (`di/ContainerBridgeModule.kt`) generated into the target package, with `@Provides`/`@Binds` methods stubbed for the package's existing `Container`-provided types (the script can only stub these — actual type wiring needs a human, since `Container`'s registered types aren't statically discoverable by a shell script without parsing Kotlin).
- Manual checklist (documented in `docs/architecture/`, not scripted): create `presentation/`, register `PlatformViewFactory` (passive) or declare `Activity`/overlay (os_triggered) — per design doc §4.1.

## Design Rationale
See design doc §4.1 and the "tách" (split) decision — the dependency+convention-plugin step is the one most likely to be forgotten or done wrong (missing convention → confusing compile error; bad Hilt bridge → duplicate instances), so it alone is worth tooling; the rest varies too much per package to be worth a rigid brick.

## TDD Checklist

**TDD Adaptation**: this task produces a standalone shell script, not application behavior under test — verified via the concrete dry-run steps below rather than RED/GREEN/REFACTOR.

- [ ] Implement the `build.gradle.kts` patch (idempotent — safe to re-run, no duplicate plugin-application if run twice).
- [ ] Implement the `ContainerBridgeModule.kt` stub generator.
- [ ] Write the manual checklist doc referenced above.
- [ ] Dry-run against `native_security` (temporarily, in a scratch branch) to confirm the patched module still compiles with Hilt available, without actually keeping `native_security` UI-enabled afterward.

## Definition of Done (DoD)
- [ ] Running the script against a `has_ui=false` package adds the Hilt+Compose convention and `framework` dependency without breaking the existing build.
- [ ] Running the script twice on the same package is a no-op the second time (idempotent).
- [ ] The manual checklist doc exists and cross-references design doc §4.1.

## Dependencies & Blockers
- **Dependencies**: [Task 1](task_1_buildsrc_port.md) (buildSrc, for `commons.android-feature`), [Task 3](task_3_native_framework_module.md) (native `framework`).
- **Blockers**: None.

## References & Rollback
- **References**: [template_android.en.md](../epic/template_android/template_android.en.md), design doc §4.1.
- **Rollback Plan**: `git revert`; script only patches the target package's `build.gradle.kts` and adds one new file — trivially revertible per-package.
