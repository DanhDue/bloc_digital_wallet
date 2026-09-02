---
id: "task_1_buildsrc_port"
status: "todo"
priority: "high"
assignee: null
epic: "template_android"
dueDate: null
created: "2026-08-29T00:00:00.000Z"
modified: "2026-08-29T00:00:00.000Z"
completedAt: null
labels: ["gradle", "buildsrc", "tooling"]
order: "a1"
---
# Task 1: Port `android/buildSrc`

Epic: [template_android](../epic/template_android/template_android.en.md)

## Requirement Analysis
Port the reusable parts of `android_digital_wallet/buildSrc` into `android/buildSrc` of this repo: the quality convention plugin (Spotless/ktlint + Detekt, one shared ruleset) and the Hilt+Compose convention plugin, trimmed of app-specific bits (Crashlytics, Firebase, `EnvConfigs` wallet-specific fields). This is the foundation every later task in this epic applies to.

## Relevant Files & Context Pointers
- Source (read-only reference): `/Users/danhdue/AllProjects/digital_wallet/android_digital_wallet/buildSrc/src/main/kotlin/codeanalyzetools/{quality,spotless,detekt-check}.gradle.kts`, `config/detekt/{detekt.yml,baseline.xml}`, `config/ktlint/.editorconfig`, `copyright.kt`.
- Source (Hilt/Compose, only for `has_ui=true` modules): `commons/{android-library,android-feature,dagger-hilt}.gradle.kts`, `AndroidCoreLibraryPlugin.kt`, `Versions.kt`/`Deps.kt`/`AppConfig.kt` (trim to only the constants this template actually needs).
- Destination: `android/buildSrc/build.gradle.kts` (register the precompiled script plugins), `android/buildSrc/src/main/kotlin/...` mirroring the source layout.
- `android/build.gradle.kts` — no changes expected (buildSrc is auto-discovered by Gradle), but verify plugin resolution.

## Design Rationale
See design doc §3.1–3.2. Feasibility rests on: Flutter's `dev.flutter.flutter-plugin-loader` includes every plugin package as a subproject of the same root Gradle build as the host app at build time, so plugin IDs declared in the host's `buildSrc` resolve inside plugin packages too — no `includeBuild`/composite-build complexity needed. Split into two convention plugins (quality-only vs. quality+Hilt+Compose) so plugin packages (Task 4/5, this epic) apply only the first, staying DI-framework-agnostic.

## TDD Checklist

**TDD Adaptation**: this is Gradle/Xcode tooling configuration, not application logic — verified via the concrete steps below (a real build applying the convention/lint config) rather than RED/GREEN/REFACTOR.

- [ ] Create `android/buildSrc/build.gradle.kts` (`kotlin-dsl`, register plugin IDs).
- [ ] Port `codeanalyzetools.{quality,spotless,detekt-check}` verbatim, adjusting file paths (`$rootDir/buildSrc/...`) for this repo's layout.
- [ ] Port the shared `detekt.yml`/ktlint `.editorconfig`/`copyright.kt` (adjust the license header to this template's placeholder).
- [ ] Port `commons.android-feature`/`dagger-hilt` convention plugins, trimmed of Crashlytics/Firebase/wallet-specific `EnvConfigs` fields.
- [ ] Verify `./gradlew :app:spotlessCheck :app:detekt` runs against the (currently empty) `android/app` module without error.

## Definition of Done (DoD)
- [ ] `android/buildSrc` builds successfully as part of a normal `flutter build apk` invocation.
- [ ] `id("codeanalyzetools.spotless")`/`id("codeanalyzetools.detekt-check")` are resolvable from a test `build.gradle` outside `android/app` (prerequisite verified informally here; formally exercised in Task 4).
- [ ] `id("commons.android-feature")` (Hilt+Compose) is resolvable and does not break a `has_ui=false` module that never applies it.

## Dependencies & Blockers
- **Dependencies**: None — first task of this epic.
- **Blockers**: None.

## References & Rollback
- **References**: [template_android.en.md](../epic/template_android/template_android.en.md), design doc §3.1–3.2, `android_digital_wallet/buildSrc` (read-only source).
- **Rollback Plan**: `git revert`; `android/buildSrc` is additive, doesn't modify existing `native_security`/`logger_native_bridge` build files until Task 4/5 apply it.
