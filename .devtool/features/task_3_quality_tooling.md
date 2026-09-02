---
id: "task_3_quality_tooling"
status: "todo"
priority: "high"
assignee: null
epic: "template_ios"
dueDate: null
created: "2026-08-29T00:00:00.000Z"
modified: "2026-08-29T00:00:00.000Z"
completedAt: null
labels: ["ios", "tooling", "lint"]
order: "a3"
---
# Task 3: Shared SwiftLint + SwiftFormat Config

Epic: [template_ios](../epic/template_ios/template_ios.en.md)

## Requirement Analysis
The iOS equivalent of `template_android`'s Task 1 (`buildSrc` quality convention): one shared `.swiftlint.yml` + `.swiftformat` config, referenced by every native module (plugin packages and any future `has_ui=true` package), wired into each target's build via a Run Script Phase.

## Relevant Files & Context Pointers
- New: `ios/quality/.swiftlint.yml`, `ios/quality/.swiftformat` — one ruleset, no per-package duplication.
- `packages/native_security/ios/native_security/Package.swift`, `packages/logger_native_bridge/ios/logger_native_bridge/Package.swift` (post-Task-10, SPM-only — no `.podspec`) — wire a SwiftLint/SwiftFormat build tool plugin or a `.plugin`-based pre-build step invoking `swiftlint`/`swiftformat --lint` with `--config ../../../../ios/quality/.swiftlint.yml` (relative path from each package's `Package.swift` location).
- Root `ios/Runner.xcodeproj` — no change expected in this task (Runner itself has no custom Swift business logic yet); document the same Run Script Phase pattern for when it does.

## Design Rationale
See design doc §3, "iOS equivalent: shared `.swiftformat`/`.swiftlint.yml`" bullet. One shared ruleset (not per-package) is the direct iOS analog of Android's single `detekt.yml` — the goal is that a new native package inherits identical lint rules by construction, not by copy-pasting a config file that can drift.

## TDD Checklist

**TDD Adaptation**: this is Gradle/Xcode tooling configuration, not application logic — verified via the concrete steps below (a real build applying the convention/lint config) rather than RED/GREEN/REFACTOR.

- [ ] Author `ios/quality/.swiftlint.yml` (baseline ruleset — can start from SwiftLint's default with repo-specific overrides as needed) and `ios/quality/.swiftformat`.
- [ ] Wire the lint/format step into each package's `Package.swift` (SPM plugin or a documented manual pre-build step — SPM's build-tool-plugin story for arbitrary shell tools is less mature than Xcode's classic Run Script Phase, verify what's actually workable on this Flutter/Xcode toolchain before committing to one approach).
- [ ] Verify `swiftlint`/`swiftformat --lint` run clean (or produce an initial, deliberately-fixed set of violations) against the current `ios/Classes/` source of both packages, ahead of Task 4/5's refactor.

## Definition of Done (DoD)
- [ ] `ios/quality/.swiftlint.yml`/`.swiftformat` exist and are referenced (not copied) by both existing plugin packages.
- [ ] A build of either plugin package runs SwiftLint/SwiftFormat as part of its build phase and fails the build on violations (or warns, per the chosen severity policy — confirm with user).

## Dependencies & Blockers
- **Dependencies**: None — can run in parallel with [Task 1](task_1_swift_mvi_viewmodel.md)/[Task 2](task_2_native_core_module_ios.md).
- **Blockers**: None.

## References & Rollback
- **References**: [template_ios.en.md](../epic/template_ios/template_ios.en.md), design doc §3.
- **Rollback Plan**: `git revert`; lint/format wiring removal reverts each package's `Package.swift` independently.
