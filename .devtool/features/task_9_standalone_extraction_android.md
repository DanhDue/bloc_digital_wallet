---
id: "task_9_standalone_extraction"
status: "todo"
priority: "medium"
assignee: null
epic: "template_android"
dueDate: null
created: "2026-08-29T00:00:00.000Z"
modified: "2026-08-29T00:00:00.000Z"
completedAt: null
labels: ["android", "extraction", "standalone"]
order: "a9"
---
# Task 9: Standalone-Repo Extraction (Android)

Epic: [template_android](../epic/template_android/template_android.en.md)

## Requirement Analysis
`android/core`, `android/framework`, `android/buildSrc` are already Flutter-independent (plain Kotlin/Gradle, no Flutter SDK dependency) as a result of Tasks 1–3. This task makes that fact usable: a script that extracts those 3 modules plus a freshly-generated minimal `app/` shell + standalone `settings.gradle.kts` into a brand-new directory, so a developer who wants to build a *pure* native Android app (no Flutter at all — the `android_digital_wallet` use case) can `git init` it and start immediately, without carrying any Flutter-plugin-loader machinery.

Note the constraint this works around: inside the Flutter template, `android/settings.gradle.kts` and `android/app/` are generated/managed by Flutter's own tooling and can't be repurposed as a general multi-module app shell in place — so this is an *extraction* (copy-out-and-regenerate), not an in-place dual-purpose file.

## Relevant Files & Context Pointers
- New: `scripts/extract_native_standalone_android.sh <output_dir>` — copies `android/{core,framework,buildSrc}` into `<output_dir>`, writes a new standalone `<output_dir>/settings.gradle.kts` (`include(":app", ":core", ":framework")`, no Flutter plugin-loader block), a new `<output_dir>/build.gradle.kts` (root, mirroring `android_digital_wallet`'s minus wallet-specific bits), and a new `<output_dir>/app/` module: one `MainActivity` + one Compose screen wired to a throwaway demo `MviViewModel` from `framework`, `build.gradle.kts` applying `commons.android-feature`.
- Reference (structure to mirror, trimmed): `android_digital_wallet/settings.gradle.kts`, `android_digital_wallet/build.gradle.kts`, `android_digital_wallet/app/`.
- Explicitly **not** extracted: `native_security`, `logger_native_bridge` (they are Flutter plugins by design, not part of a pure-native app skeleton) — call this out in the script's `--help` text so it's not mistaken for an oversight.

## Design Rationale
Because Tasks 1–3 already enforced "no Flutter SDK dependency" as an architectural constraint on `core`/`framework`/`buildSrc`, this task is purely mechanical — it doesn't require any redesign of those modules. Structuring it as a script (mirroring `template_flutter`'s `rename_project.sh` pattern) rather than a permanently-dual-purpose file layout keeps the Flutter-embedded `android/` and any spun-off standalone repo from fighting over the same `settings.gradle.kts`.

## TDD Checklist

**TDD Adaptation**: this task produces a standalone shell script, not application behavior under test — verified via the concrete dry-run steps below rather than RED/GREEN/REFACTOR.

- [ ] Implement `scripts/extract_native_standalone_android.sh <output_dir>`.
- [ ] Write the standalone `settings.gradle.kts`/root `build.gradle.kts` templates.
- [ ] Write the minimal demo `app/` module (one screen, one `MviViewModel`).
- [ ] Run the script against a scratch output directory; `git init` it; confirm `./gradlew :app:assembleDebug` succeeds with zero Flutter involvement.

## Definition of Done (DoD)
- [ ] A freshly extracted directory builds and installs a working (if minimal) native Android app with no Flutter SDK, no `local.properties` `flutter.sdk` requirement, and no `dev.flutter.flutter-plugin-loader` reference anywhere in its Gradle files.
- [ ] `core`/`framework`/`buildSrc` in the extracted copy are byte-identical to the source (verifying no hidden Flutter-coupling was introduced in Tasks 1–3).
- [ ] The script's `--help`/README note explicitly documents that plugin packages are intentionally excluded.

## Dependencies & Blockers
- **Dependencies**: [Task 1](task_1_buildsrc_port.md)–[Task 3](task_3_native_framework_module.md) (buildSrc, core, framework must exist and be verified Flutter-independent).
- **Blockers**: None.

## References & Rollback
- **References**: [template_android.en.md](../epic/template_android/template_android.en.md), `android_digital_wallet` (structure reference), `template_flutter` Task 7 (`rename_project.sh`, the analogous extraction-script pattern).
- **Rollback Plan**: `git revert`; script only, no changes to existing `android/core`/`framework`/`buildSrc`/plugin packages.
