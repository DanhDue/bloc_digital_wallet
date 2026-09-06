---
id: "task_7_rename_script"
status: "todo"
priority: "high"
assignee: null
epic: "template_flutter"
dueDate: null
created: "2026-08-29T00:00:00.000Z"
modified: "2026-08-29T00:00:00.000Z"
completedAt: null
labels: ["scripts", "rename"]
order: "a7"
---
# Task 7: `scripts/rename_project.sh`

Epic: [template_flutter](../epic/template_flutter/template_flutter.en.md)

## Requirement Analysis
Ship the single entrypoint a new project runs after cloning the template: `scripts/rename_project.sh <new_app_name> [<bundle_id>]`. This is the concrete fulfillment of "clone về đổi package thôi" — everything else in this epic exists so this one script is sufficient.

## Relevant Files & Context Pointers
- Root `pubspec.yaml` (`name:`), `melos.yaml` — rename the root package.
- Every `import 'package:bloc_digital_wallet/...'` under `lib/` — find/replace to the new package name.
- `android/app/build.gradle.kts` (`applicationId`), `ios/Runner.xcodeproj/project.pbxproj` / `ios/Flutter/*.xcconfig` (bundle id) — update if `<bundle_id>` is provided.
- `lib/config/app_config.dart`, `flutter_native_splash.yaml`, `android/app/src/main/AndroidManifest.xml` (`android:label`), `ios/Runner/Info.plist` (`CFBundleDisplayName`) — update app display name.
- Kotlin/Swift namespace of `native_security`/`logger_native_bridge` (`com.danhdue.native_security`, `com.danhdue.logger_native_bridge`) — **decided 2026-08-29: kept fixed, never rewritten by this script.** This pair is treated as a "vendor namespace" belonging to the plugin implementation itself, independent of whatever org/bundle-id the consuming project uses.
- End of script: call `melos genAlls` to regenerate router/DI/theme/translation code under the new name.

## Design Rationale
See design doc §5. A single script, not a checklist, because the whole point of a template is that renaming is mechanical and never skipped/half-done. `melos genAlls` at the end guarantees generated code (`*.gr.dart`, `*.config.dart`) matches the new name immediately, not on the next manual regen.

## TDD Checklist

**TDD Adaptation**: this task produces a standalone shell script, not application behavior under test — verified via the concrete dry-run steps below rather than RED/GREEN/REFACTOR.

- [ ] Implement `pubspec.yaml`/`melos.yaml` root rename.
- [ ] Implement `lib/` import rewrite (`package:bloc_digital_wallet/` → `package:<new_name>/`).
- [ ] Implement Android `applicationId` + display name rewrite.
- [ ] Implement iOS bundle id + display name rewrite.
- [ ] Explicitly skip native plugin namespace rewrite — add a guard/comment in the script noting `com.danhdue.*` for `native_security`/`logger_native_bridge` is intentionally out of scope for this script.
- [ ] Call `melos bootstrap && melos genAlls` at the end; script exits non-zero on any generation failure.
- [ ] Dry-run against a scratch clone of the trimmed template end to end.

## Definition of Done (DoD)
- [ ] Running the script with a new name on a fresh clone produces a project that builds and runs on both Android and iOS with the new name/bundle id everywhere a user would see it.
- [ ] No leftover `bloc_digital_wallet` string anywhere in `lib/`, `pubspec.yaml`, `melos.yaml`, or platform manifests after the run.
- [ ] Script is idempotent-safe to inspect (fails loudly, doesn't half-apply, on any step error).

## Dependencies & Blockers
- **Dependencies**: [Task 1](task_1_trim_package_inventory.md)–[Task 6](task_6_ci_simplification.md) should be complete first so the script operates on the final trimmed tree, not a moving target.
- **Blockers**: None — native namespace policy resolved (kept fixed, see above).

## References & Rollback
- **References**: [flutter_super_app_template.en.md](../epic/flutter_super_app_template/flutter_super_app_template.en.md), design doc §5.
- **Rollback Plan**: run against a scratch git clone only, never the canonical template repo directly; `git reset --hard` on the scratch clone if a run misbehaves.
