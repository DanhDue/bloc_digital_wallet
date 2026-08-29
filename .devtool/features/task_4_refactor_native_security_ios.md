---
id: "task_4_refactor_native_security"
status: "todo"
priority: "medium"
assignee: null
epic: "template_ios"
dueDate: null
created: "2026-08-29T00:00:00.000Z"
modified: "2026-08-29T00:00:00.000Z"
completedAt: null
labels: ["ios", "refactor", "native_security"]
order: "a4"
---
# Task 4: Refactor `native_security` (iOS side)

Epic: [template_ios](../epic/template_ios/template_ios.en.md)

## Requirement Analysis
**Sequencing note**: run this task *after* Task 10 (SPM-only packaging) so the source is already at its
new `ios/native_security/Sources/native_security/` location before being split into `Platform/Domain/Data`
— avoids reorganizing the same files twice. References to `native_security.podspec` below become
`Package.swift` post-Task-10.

Reorganize `native_security`'s flat Swift source into `Platform/Domain/Data`, matching Android's `platform/domain/data` naming 1:1 (capitalized per Swift convention) for cross-platform cross-reference, and wire in `ios/core` (Task 2).

## Relevant Files & Context Pointers
- `packages/native_security/ios/native_security/Sources/native_security/{NativeSecurityPlugin.swift,DatadogNativeAppender.swift,native_security.{cpp,h}}` (post-Task-10 SPM location) — classify: `NativeSecurityPlugin.swift` (plugin registration, method-channel handling) → `Platform/`; any pure logic → `Domain/`; storage/adapter code → `Data/`. Mixed Swift/C++ needs an explicit C target in `Package.swift` — verify the exact SPM mixed-language target shape before moving files, so the C++ build isn't broken.
- `packages/native_security/ios/native_security/Tests/native_securityTests/DatadogNativeAppenderHeadlessTests.swift` — move alongside its corresponding source, update paths.
- `packages/native_security/ios/native_security/Package.swift` — add target paths for the reorganized folders; add `ios/core` as a package dependency.

## Design Rationale
See design doc §3.3 (Android) applied identically to iOS, and the Ô1 diagram (`flutter_super_app_template.en.md` §5, Case 2/3). This is the iOS counterpart of `template_android` Task 4 — both should land with matching folder names so the two are trivially cross-referenced.

## TDD Checklist

**TDD Adaptation**: this is a structural reorganization of existing, already-tested code — no new behavior to drive with a failing test. Existing unit tests are ported unchanged and must keep passing; see steps below.

- [ ] Map every existing Swift file to `Platform/Domain/Data`; move and update.
- [ ] Verify the `.cpp`/`.h` FFI source location matches the mixed-language target declared in `Package.swift` after the Swift reorg.
- [ ] Add `ios/core` as a package dependency in `Package.swift`.
- [ ] Move/update existing tests.
- [ ] Run SwiftLint/SwiftFormat (Task 3), fix all violations for a clean baseline.

## Definition of Done (DoD)
- [ ] `packages/native_security/ios/native_security/Sources/native_security/{Platform,Domain,Data}/` layout exists, matching Android's folder names.
- [ ] `Package.swift` builds correctly with the new layout (FFI `.cpp`/`.h` sources unaffected).
- [ ] SwiftLint/SwiftFormat + existing XCTest suite all pass.

## Dependencies & Blockers
- **Dependencies**: [Task 2](task_2_native_core_module_ios.md) (`ios/core`), [Task 3](task_3_quality_tooling.md) (quality tooling), [Task 10](task_10_spm_only_packaging.md) (SPM-only packaging — sequence after).
- **Blockers**: None.

## References & Rollback
- **References**: [template_ios.en.md](../epic/template_ios/template_ios.en.md), design doc §3.3, `flutter_super_app_template.en.md` §5 (Case 2/3).
- **Rollback Plan**: `git revert`; Dart-facing API of `native_security` is unchanged, no Dart-side ripple.
