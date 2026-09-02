---
id: "task_6_native_package_brick"
status: "todo"
priority: "high"
assignee: null
epic: "template_android"
dueDate: null
created: "2026-08-29T00:00:00.000Z"
modified: "2026-08-29T00:00:00.000Z"
completedAt: null
labels: ["mason", "android"]
order: "a6"
---
# Task 6: `native_android_package` Mason Brick

Epic: [template_android](../epic/template_android/template_android.en.md)

## Requirement Analysis
Build a standalone Mason brick, `native_android_package(name, trigger, has_ui)`, covering all 4 quadrants (Ô1–Ô4) of Android-side native scaffolding from one `__brick__/` source, with `post_gen.dart` deleting what the chosen flags don't need. This is a **separate brick from iOS's** (`template_ios` Task 6's `native_ios_package`) — per the "tách riêng lệnh hết" decision, there is no single brick that generates both platforms in one invocation. A package needing both platforms' native code runs both bricks against the same `name`, independently; a package needing only Android-side native code runs just this one.

## Relevant Files & Context Pointers
- New: `bricks/native_android_package/brick.yaml` — vars `name` (string), `trigger` (enum `passive`|`os_triggered`), `has_ui` (boolean).
- New: `bricks/native_android_package/__brick__/packages/{{name.snakeCase()}}/android/src/main/kotlin/.../{platform,domain,data,presentation}/` — every possible file (a plugin/method-channel template for `platform`, a `Receiver`/`Service`/`Worker` template pre-wrapped in `core.SafeExecution` for `os_triggered`, a Compose View + `MviViewModel` subclass template for `presentation`).
- New: `bricks/native_android_package/__brick__/packages/{{name.snakeCase()}}/android/build.gradle.kts` template — always applies `codeanalyzetools.{spotless,detekt-check}`; conditionally applies `commons.android-feature` (Hilt+Compose) only when `has_ui=true`.
- New: `bricks/native_android_package/hooks/post_gen.dart` — deletes: `presentation/` and the Compose/Hilt `build.gradle` block when `has_ui=false`; the `Receiver`/`Service`/`Worker` template and `ReplayQueue` wiring when `trigger=passive`. If `packages/{{name}}/` doesn't exist yet, scaffold the minimal Dart-facing plugin `pubspec.yaml`/`lib/` shell too (declaring only the `android:` platform block); if it already exists (e.g. iOS side was generated first via `native_ios_package`), only add the `android:` platform declaration to the existing `pubspec.yaml`. Also registers the package into root `pubspec.yaml` (`workspace:`/`dependencies:`) if not already present — no router/DI/translation wiring, since native packages are infra, not Dart-facing features.
- `mason.yaml` — register `native_android_package`.

## Design Rationale
See design doc §3.4 and §4 ("Solution", "One parameterized Mason brick" bullet) — note the design doc's original phrasing described one shared brick; this task supersedes that with the "tách riêng lệnh hết" decision (see `template_flutter`-adjacent conversation record): one brick per platform, both targeting the same `packages/{{name}}/` folder, callable independently. This also enables a package with asymmetric platform support (e.g. an Android-only native feature with no iOS equivalent) without an awkward "skip this platform" flag.

## TDD Checklist

**TDD Adaptation**: this task produces a code generator (Mason brick), not application behavior — correctness is verified by generating all flag combinations and inspecting/building the output (see steps), not classic RED/GREEN/REFACTOR.

- [ ] Scaffold `brick.yaml` with the 3 vars.
- [ ] Author the `__brick__/` templates for all 4 quadrants' Android content in one tree.
- [ ] Implement `post_gen.dart`'s conditional deletion logic per the flags, plus the "create vs. merge into existing package" branch.
- [ ] Test all 4 flag combinations end to end: `mason make native_android_package` with each of `(passive,false)`, `(passive,true)`, `(os_triggered,false)`, `(os_triggered,true)`; verify against the corresponding Ô1–Ô4 diagram in `flutter_super_app_template.en.md` §5.
- [ ] Test running this brick against a package that already has an iOS-only native side (generated first via `template_ios` Task 6's `native_ios_package`) to confirm the merge path works.

## Definition of Done (DoD)
- [ ] All 4 flag combinations generate a package that compiles, applies the correct convention plugins, and has no leftover unused-quadrant files.
- [ ] `has_ui=false` packages never pull in Hilt/Compose; `has_ui=true` packages always do.
- [ ] `trigger=os_triggered` packages have their entry-point pre-wrapped in `core.SafeExecution` in the generated template.
- [ ] Running against a package that already has an iOS-only native side merges cleanly (adds the `android:` platform block, doesn't clobber the existing `ios:` block).

## Dependencies & Blockers
- **Dependencies**: [Task 1](task_1_buildsrc_port.md) (buildSrc), [Task 2](task_2_native_core_module_android.md) (native `core`), [Task 3](task_3_native_framework_module.md) (native `framework`, for the `has_ui=true` case).
- **Blockers**: None — resolved as a separate brick from iOS's, per the "tách riêng lệnh hết" decision.

## References & Rollback
- **References**: [template_android.en.md](../epic/template_android/template_android.en.md), design doc §3.4, `flutter_super_app_template.en.md` §5.
- **Rollback Plan**: `git revert`; brick is additive, no existing package depends on it.
