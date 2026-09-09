---
id: "task_19_pac_rename_project_package_swift"
status: "todo"
priority: "medium"
assignee: null
epic: "flutter_super_app_template"
dueDate: null
created: "2026-09-09T09:51:07.000Z"
modified: "2026-09-09T09:51:07.000Z"
completedAt: null
labels: ["mason", "brick", "tooling", "ios", "spm", "phase-5"]
order: "a19"
---

# Task 19: `pac_rename_project` — Handle `Package.swift` Tokens

Epic: [flutter_super_app_template](../epic/flutter_super_app_template/flutter_super_app_template.en.md)

## Requirement Analysis
`pac_rename_project` (Task 8) rewrites Dart package names, imports, Android `applicationId`, and iOS bundle IDs, while locking `com.danhdue.*` vendor namespaces. After Phase 5, iOS-native packages carry a `Package.swift` with `name` / library-product tokens that also need rewriting on a template clone.

Requirements:
1. In `bricks/pac_rename_project/hooks/post_gen.dart`, extend the pure-Dart rewrite to every `packages/*/ios/*/Package.swift` and any nested FFI target manifest:
   - `Package(name: "<old>")` → new package token where the SwiftPM package name mirrors the Dart package name.
   - `.library(name: "<old-param-case>", targets: ["<old-snake>"])` → new param-case / snake tokens.
   - `.target(name:)` / `.testTarget(name:)` and `.product(name:..., package:...)` internal references.
   - `.package(path: "../../<old>/ios/<old>")` cross-plugin path references (e.g. `native_security` → `logger_native_bridge`).
2. **Do not** touch `.package(url: "https://github.com/hmlongco/Factory.git", ...)` or any external dependency URL/version.
3. **Preserve** `com.danhdue.*` — the `native_view` `withId:` strings and any Swift namespace stay as-is for vendor plugins, consistent with Task 8's vendor lock.
4. The two migrated plugins (`logger_native_bridge`, `native_security`) keep their names (vendor-locked) — assert the rename leaves their `Package.swift` `name` untouched, same rule as their `com.danhdue.*` namespace today.
5. Keep triggering `melos genAlls` at the end (unchanged).

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
- [ ] **RED**: Extend the Task 8 isolated-rename test — after `mason make pac_rename_project --app_name "Demo App" --package_name demo_app --bundle_id com.example.demoapp`, assert: (a) a **generated** plugin's `Package.swift` `name` / product tokens are rewritten, (b) `logger_native_bridge` / `native_security` `Package.swift` `name` are **unchanged**, (c) the `Factory.git` URL is **unchanged**, (d) `.package(path:)` cross-refs still resolve. Fails before the hook change.
- [ ] **GREEN**: Implement the `Package.swift` token rewrite in `post_gen.dart` with the vendor/URL exclusions.
- [ ] **REFACTOR**: Share the token-derivation helpers with the existing Dart-package rename logic; no duplicated case-conversion code.

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
