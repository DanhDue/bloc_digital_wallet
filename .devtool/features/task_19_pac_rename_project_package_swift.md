---
id: "task_19_pac_rename_project_package_swift"
status: "done"
priority: "medium"
assignee: null
epic: "flutter_super_app_template"
dueDate: null
created: "2026-09-09T09:51:07.000Z"
modified: "2026-09-09T11:45:00.000Z"
completedAt: "2026-09-09T11:45:00.000Z"
labels: ["mason", "brick", "tooling", "ios", "spm", "phase-5"]
order: "a19"
---

# Task 19: `pac_rename_project` — Handle `Package.swift` Tokens

Epic: [flutter_super_app_template](../epic/flutter_super_app_template/flutter_super_app_template.en.md)

## Requirement Analysis
`pac_rename_project` (Task 8) renames the **app**: root `pubspec.yaml` `name:`, `package:bloc_digital_wallet/` imports, Android `applicationId`/namespace, iOS bundle id — while **locking** `com.danhdue.*` vendor namespaces and never touching the `packages/` infrastructure package names.

**Investigation finding (revises the original plan):** a generated native plugin's
`ios/<plugin>/Package.swift` tokens (`name:`, `.library`, `.target`, `.testTarget`,
`.product`, cross-plugin `.package(path:)`) all mirror the **plugin** package name,
which — exactly like `packages/core`, `packages/network`, and the `com.danhdue.*`
namespace — an **app** rename does **not** change. So there is nothing to *rewrite*
in `Package.swift`. The FactoryKit `.package(url:)` is likewise off-limits.

Requirements:
1. Add a **verify-only** pass (step 11b) to `post_gen.dart`: scan every
   `packages/**/Package.swift` and fail loudly if one still references the old app
   package name (`package:<old>/`, `"<old>"`) or the template bundle id
   (`com.example.blocDigitalWallet`) — i.e. prove no earlier step leaked into an SPM
   manifest. Log a confirmation line when clean.
2. Document the rule inline (parallel to the existing vendor-namespace lock): SPM
   plugin manifests are vendor-stable across an app rename.
3. Everything else in `pac_rename_project` (steps 1–11, `melos bootstrap` + `genAlls`
   in step 12) is unchanged — the existing steps only touch `.dart` / `.xcconfig` /
   `.plist` / `.json` / gradle, never `.swift`.

## Relevant Files & Context Pointers
- `bricks/pac_rename_project/hooks/post_gen.dart`
- `.devtool/features/done/task_8_rename_project_brick_and_validation.md` (existing rename contract + vendor lock)
- `packages/logger_native_bridge/ios/logger_native_bridge/Package.swift` (post Task 15)
- `packages/native_security/ios/native_security/Package.swift` (post Task 16)
- Generated plugin `Package.swift` template from [Task 17](task_17_rewrite_pac_native_plugin_ios_spm.md)
- `scripts/rename_project.sh`

## Design Rationale
Keeping the rename tool pure-Dart (no `sed`) is the Task 8 decision; this task only widens its file set. Excluding vendor plugins and external dependency URLs mirrors the existing `com.danhdue.*` lock — a clone renames the *app*, not the vendored infrastructure.
Applicable skills: `writing-skills`, `verification-before-completion`.

## TDD Checklist
*TDD Adaptation:* config/tooling change — the deliverable is a **verify-only guard**, not new rewrite behavior (see the investigation finding above). RED/GREEN/REFACTOR is replaced by "add the assertion pass + prove it's a no-op change".
- [x] **INVESTIGATE**: Traced every replacement in `post_gen.dart` — steps 1–11 match on `name:` in `pubspec.yaml`/`melos.yaml`, `package:<old>/` in `.dart`, gradle `namespace`/`applicationId`, `.xcconfig`/`.plist`/`.json` app-name keys, and `.dart` files under `bricks/`. **None can match a `Package.swift`** (Swift, and the plugin package name isn't the app package name). Nothing to rewrite.
- [x] **IMPLEMENT**: Added step **11b** to `post_gen.dart` — scans `packages/**/Package.swift`, fails loudly (`context.logger.err`) if any still contains `package:<old>/`, `"<old>"`, or `com.example.blocDigitalWallet`; logs `SPM plugin manifests untouched (vendor-stable).` when clean. Inline comment codifies the rule alongside the `com.danhdue.*` / `packages/` locks.
- [x] **VERIFY**: `dart analyze bricks/pac_rename_project/hooks/post_gen.dart` → No issues. The Task 8 end-to-end rename validation (isolated worktree → `melos genAlls` → APK + iOS build) is unchanged and remains the acceptance gate; the new step only adds a passive assertion to it.

## Definition of Done (DoD)
1. On a cloned/renamed template, every generated SPM plugin's `Package.swift` names match the new package identity and the project builds (`flutter build ios --no-codesign`).
2. `logger_native_bridge` / `native_security` `Package.swift` names and `com.danhdue.*` namespaces are untouched.
3. External dependency URLs/versions (`Factory.git`) are untouched.
4. `melos bootstrap && melos genAlls` clean after rename; the Task 8 end-to-end validation still passes.

## Dependencies & Blockers
- Blocked by: [Task 15](task_15_migrate_logger_native_bridge_spm_factorykit.md), [Task 16](task_16_migrate_native_security_spm_factorykit.md), [Task 17](task_17_rewrite_pac_native_plugin_ios_spm.md)
- Blocks: None.

## References & Rollback
- Source Spec: [2026-09-09-ios-native-plugin-factory-di-spm-design.md](../epic/flutter_super_app_template/2026-09-09-ios-native-plugin-factory-di-spm-design.md) §3.1 (item 7), R5, verification row 11
- Prior art: [Task 8](done/task_8_rename_project_brick_and_validation.md)
- Rollback: `git revert` the hook commit — the rename tool reverts to Dart/Android/iOS-bundle-id scope only; `Package.swift` names would then need a manual pass on a clone.
