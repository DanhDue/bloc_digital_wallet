---
id: "task_9_standalone_extraction"
status: "todo"
priority: "medium"
assignee: null
epic: "template_ios"
dueDate: null
created: "2026-08-29T00:00:00.000Z"
modified: "2026-08-29T00:00:00.000Z"
completedAt: null
labels: ["ios", "extraction", "standalone"]
order: "a9"
---
# Task 9: Standalone-Repo Extraction (iOS)

Epic: [template_ios](../epic/template_ios/template_ios.en.md)

## Requirement Analysis
iOS counterpart of `template_android` Task 9. `ios/core` and `ios/framework` (Tasks 1–2) are already Flutter-independent (plain Swift, no `Flutter.framework` dependency). This task extracts them plus a freshly-generated minimal standalone Xcode project/app target into a new directory, so a developer can build a pure native iOS app skeleton with no Flutter involvement.

Same constraint as Android: the Flutter template's `ios/Runner.xcodeproj` is managed by Flutter tooling and can't double as a general-purpose app shell in place — this is an extraction (copy-out-and-regenerate), not a dual-purpose file.

## Relevant Files & Context Pointers
- New: `scripts/extract_native_standalone_ios.sh <output_dir>` — copies `ios/{core,framework,quality}` into `<output_dir>`, generates a new minimal standalone Xcode project (a single App target, no Flutter embedding, no `Flutter.framework`/`Runner-Bridging-Header.h`): one SwiftUI screen wired to a throwaway demo Swift `MviViewModel` from `framework`.
- No pre-existing iOS reference to mirror (unlike Android's `android_digital_wallet`) — the standalone shell's shape is designed fresh in this task, kept intentionally minimal (one screen) since its only purpose is proving `core`/`framework` work with zero Flutter coupling, not demonstrating a full app.
- Explicitly **not** extracted: `native_security`, `logger_native_bridge` (Flutter plugins by design) — documented in the script's usage text, matching Android's Task 9.

## Design Rationale
Same rationale as `template_android` Task 9: `core`/`framework` were already required to have zero Flutter dependency (design doc §3, "native `core`"/"native `framework`" bullets), so this task is mechanical extraction, not redesign. Kept as a script (not an in-place dual file layout) for the same reason Xcode's generated project files can't safely serve two purposes at once.

## TDD Checklist

**TDD Adaptation**: this task produces a standalone shell script, not application behavior under test — verified via the concrete dry-run steps below rather than RED/GREEN/REFACTOR.

- [ ] Implement `scripts/extract_native_standalone_ios.sh`, independent of Android's `extract_native_standalone_android.sh` (separate script per platform, per the "tách riêng lệnh hết" decision).
- [ ] Generate the minimal standalone Xcode project/app target template.
- [ ] Write the minimal demo screen + demo `MviViewModel`.
- [ ] Run the script against a scratch output directory; `git init` it; confirm it builds and runs in the simulator with zero Flutter/CocoaPods-for-Flutter involvement.

## Definition of Done (DoD)
- [ ] A freshly extracted directory builds and runs a working (if minimal) native iOS app with no `Flutter.framework`, no `Runner-Bridging-Header.h`, no Flutter-generated `.xcconfig` includes.
- [ ] `core`/`framework` in the extracted copy are byte-identical to the source.
- [ ] The script's usage text documents that plugin packages are intentionally excluded.

## Dependencies & Blockers
- **Dependencies**: [Task 1](task_1_swift_mvi_viewmodel.md) (Swift `MviViewModel`/`framework`), [Task 2](task_2_native_core_module_ios.md) (`ios/core`).
- **Blockers**: None — resolved as a separate script from Android's, per the "tách riêng lệnh hết" decision.

## References & Rollback
- **References**: [template_ios.en.md](../epic/template_ios/template_ios.en.md), `template_android` Task 9 (shared pattern), `template_flutter` Task 7 (`rename_project.sh` precedent).
- **Rollback Plan**: `git revert`; script only, no changes to existing `ios/core`/`framework`/plugin packages.
