---
id: "task_10_spm_only_packaging"
status: "todo"
priority: "high"
assignee: null
epic: "template_ios"
dueDate: null
created: "2026-08-29T00:00:00.000Z"
modified: "2026-08-29T00:00:00.000Z"
completedAt: null
labels: ["ios", "spm", "packaging"]
order: "a10"
---
# Task 10: SPM-Only Packaging (No `.podspec`)

Epic: [template_ios](../epic/template_ios/template_ios.en.md)

## Requirement Analysis
**Decision (2026-08-29): `native_security`, `logger_native_bridge`, and the `native_ios_package` brick
package exclusively via Swift Package Manager (`Package.swift`) — no `.podspec` at all**, deviating from
Flutter's own "keep both during transition" guidance for public plugin authors. Justified because: (1)
this repo pins **Flutter 3.41.1** (`.fvmrc`), well past SPM-for-plugins' preview introduction (~3.24),
so tooling maturity isn't a concern; (2) CocoaPods' spec registry goes **read-only 2026-12-02** — about 3
months out from this decision — so there is no value in adding CocoaPods support to any *new* plugin
packaging going forward; (3) these two plugins are owned entirely by this template, so there's no unknown
external consumer on an old Flutter SDK to preserve compatibility for, unlike a publicly-published pub.dev
plugin.

**Explicit scope boundary — do not conflate with "app has no CocoaPods"**: this task removes CocoaPods
packaging from these specific plugins only. The Host app's `ios/Podfile` **stays** — Flutter aggregates
every plugin/pub-package's iOS dependency (including third-party ones like `flutter_svg`,
`cached_network_image`, `google_sign_in`, etc. used elsewhere in this workspace) into one Podfile if *any*
of them still requires CocoaPods, which is outside this epic's control. Communicate this boundary clearly
in any docs/README touching this decision so "we migrated to SPM" isn't misread as "the app has zero
CocoaPods usage."

## Relevant Files & Context Pointers
- `packages/native_security/ios/native_security.podspec` — **delete**.
- `packages/logger_native_bridge/ios/logger_native_bridge.podspec` — **delete**.
- New: `packages/native_security/ios/native_security/Package.swift` + `Sources/native_security/` (moved
  from `ios/Classes/`, following the folder convention Flutter's SPM-plugin support expects:
  `<plugin>/ios/<plugin>/Package.swift` + `<plugin>/ios/<plugin>/Sources/<plugin>/`).
- New: `packages/logger_native_bridge/ios/logger_native_bridge/Package.swift` + `Sources/logger_native_bridge/`
  (same convention; note the pinned `pigeon: 26.3.2` constraint from this package's `pubspec.yaml` is
  unaffected by this change — it's a Dart-side dev dependency, not related to iOS packaging).
- `pubspec.yaml` of both packages — **no changes needed**: per Flutter's own docs, plugin platform
  declaration is unchanged; Flutter auto-detects `Package.swift` and uses SPM once enabled.
- Project/CI-level: confirm `flutter config --enable-swift-package-manager` is set wherever this template
  is built (document in the template's own setup instructions / `docs/getting-started/`).
- `bricks/native_ios_package/` (`template_ios` Task 6) — generate `Package.swift` only, never a `.podspec`,
  for every newly-created package from this brick.

## Design Rationale
See design doc §3.5.1. This task exists because `template_ios` Task 4/5/6/7 were all originally scoped
around `.podspec`-based packaging (matching the plugins' current state) — this task is the deliberate,
explicit pivot away from that, landing *before* Tasks 4–7 touch these files so they aren't refactored twice
(once into the old `platform/domain/data` layout under `.podspec`, then again into SPM). Recommended
sequencing: do this task's folder/packaging move first, then Tasks 4/5's `Platform/Domain/Data` layering
on top of the new SPM structure — not the other way around.

## TDD Checklist

**TDD Adaptation**: this is a packaging/build-config migration, not application logic — verified via the concrete steps below (a real build via SPM) rather than RED/GREEN/REFACTOR.

- [ ] Verify `flutter config --enable-swift-package-manager` works cleanly with the pinned Flutter 3.41.1
  toolchain on a scratch build.
- [ ] Move `native_security`'s `ios/Classes/*` into the new `ios/native_security/Sources/native_security/`
  structure; write `Package.swift`; delete the `.podspec`.
- [ ] Same for `logger_native_bridge`.
- [ ] Update Pigeon output paths (`logger_native_bridge` uses Pigeon) to the new `Sources/` location.
- [ ] Confirm `flutter build ios`/`flutter run` picks up both plugins via SPM (verify "Package Dependencies"
  appears in Xcode's Project Navigator, no CocoaPods `Pods/` entries for these two plugins).
- [ ] Update `bricks/native_ios_package`'s `__brick__/` templates (`template_ios` Task 6) to generate the
  SPM structure directly — no podspec template at all.
- [ ] Document the scope boundary (plugins-only, not app-wide) in `docs/getting-started/`.

## Definition of Done (DoD)
- [ ] Neither `native_security` nor `logger_native_bridge` has a `.podspec` anywhere in their `ios/` folder.
- [ ] Both build and run correctly via SPM on the pinned Flutter version.
- [ ] `native_ios_package` brick output never contains a `.podspec`.
- [ ] `ios/Podfile` at the app root is unmodified by this task (still present, still serving other
  dependencies) — explicitly verified, not just assumed.
- [ ] A short note in `docs/getting-started/` states the exact scope of "SPM-only" (these 2 plugins +
  brick output, not the whole app).

## Dependencies & Blockers
- **Dependencies**: None to start; [Task 4](task_4_refactor_native_security_ios.md)/[Task 5](task_5_refactor_logger_native_bridge_ios.md)/[Task 6](task_6_native_package_brick_ios.md) of this epic should sequence *after* this task (see Design Rationale) to avoid refactoring the same files twice.
- **Blockers**: None — Flutter version confirmed compatible (3.41.1 pinned).

## References & Rollback
- **References**: [template_ios.en.md](../epic/template_ios/template_ios.en.md), design doc §3.5.1, [Flutter SPM plugin-author docs](https://docs.flutter.dev/packages-and-plugins/swift-package-manager/for-plugin-authors).
- **Rollback Plan**: `git revert`; if SPM proves unstable on the pinned Flutter version, restore the deleted `.podspec` files from git history and revert the folder move — no Dart-facing API changes, so no ripple beyond `ios/`.
