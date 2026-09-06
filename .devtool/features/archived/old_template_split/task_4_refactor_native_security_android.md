---
id: "task_4_refactor_native_security"
status: "todo"
priority: "medium"
assignee: null
epic: "template_android"
dueDate: null
created: "2026-08-29T00:00:00.000Z"
modified: "2026-08-29T00:00:00.000Z"
completedAt: null
labels: ["android", "refactor", "native_security"]
order: "a4"
---
# Task 4: Refactor `native_security` (Android side)

Epic: [template_android](../epic/template_android/template_android.en.md)

## Requirement Analysis
Reorganize `packages/native_security/android`'s flat Kotlin source into `platform/domain/data`, depending on native `core` (Task 2), and remove its duplicated `kotlin_version`/AGP declarations in favor of the shared version catalog from Task 1's `buildSrc` port.

## Relevant Files & Context Pointers
- `packages/native_security/android/src/main/kotlin/com/danhdue/native_security/DatadogNativeAppender.kt` → classify by responsibility and move: plugin registration/channel handling → `platform/`; any pure logic → `domain/`; storage/adapter code → `data/`.
- `packages/native_security/android/build.gradle` — currently Groovy, hard-codes `kotlin_version = '2.1.0'`, `com.android.tools.build:gradle:8.13.2`; migrate to reference Task 1's shared version constants, apply `codeanalyzetools.{spotless,detekt-check}` (no Hilt — this stays a manual-DI, framework-agnostic plugin per epic goal G3/G7 of the parent spec).
- `packages/native_security/android/src/test/kotlin/...` (existing `DatadogNativeAppenderHeadlessTest.kt`, `FakeSharedPreferences.kt`) — move alongside their corresponding `data/`/`domain/` source, update package paths.
- Add `android/core` as a dependency in `native_security`'s `build.gradle`.

## Design Rationale
See design doc §3.3 and the per-use-case diagram for Ô1 (`flutter_super_app_template.en.md` §5, Case 2/3). `native_security` is the archetype for `has_ui=false`/passive plugins — this task is the first concrete instance of the layering convention, so its outcome doubles as the reference other plugins (and Task 6's brick) are checked against.

## TDD Checklist

**TDD Adaptation**: this is a structural reorganization of existing, already-tested code — no new behavior to drive with a failing test. Existing unit tests are ported unchanged and must keep passing; see steps below.

- [ ] Map every existing file to `platform/domain/data`; move and update package declarations/imports.
- [ ] Rewrite `build.gradle` to reference Task 1's shared version constants; apply `codeanalyzetools.{spotless,detekt-check}`.
- [ ] Add `android/core` dependency; replace any ad hoc exception handling with `core.SafeExecution` where applicable.
- [ ] Move/update existing unit tests to match the new layout.
- [ ] Run `detekt`/`spotlessApply` once, fix all resulting violations for a clean baseline.

## Definition of Done (DoD)
- [ ] `packages/native_security/android/src/main/kotlin/.../{platform,domain,data}/` layout exists with no files remaining at the old flat root.
- [ ] `build.gradle` has zero duplicated `kotlin_version`/AGP literals; both come from the shared version catalog.
- [ ] `./gradlew :native_security:detekt :native_security:spotlessCheck :native_security:testDebugUnitTest` all pass.

## Dependencies & Blockers
- **Dependencies**: [Task 1](task_1_buildsrc_port.md) (buildSrc), [Task 2](task_2_native_core_module_android.md) (native `core`).
- **Blockers**: None.

## References & Rollback
- **References**: [template_android.en.md](../epic/template_android/template_android.en.md), design doc §3.3, `flutter_super_app_template.en.md` §5 (Case 2/3 diagram).
- **Rollback Plan**: `git revert`; Dart-facing API of `native_security` is unchanged, so no Dart-side ripple if this task is reverted.
