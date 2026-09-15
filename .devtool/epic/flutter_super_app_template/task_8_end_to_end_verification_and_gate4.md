---
id: "task_8_end_to_end_verification_and_gate4"
status: "done"
priority: "high"
assignee: null
epic: "flutter_super_app_template"
dueDate: null
created: "2026-09-15T13:20:00Z"
modified: "2026-09-15T10:32:45Z"
completedAt: "2026-09-15T10:32:45Z"
labels: ["verification", "quality-gate", "gate4", "e2e", "acceptance"]
order: "a8"
---

# Task 8: End-to-End Verification & Gate 4 Quality Check

Epic: [flutter_super_app_template](flutter_super_app_template.en.md)

## Requirement Analysis
Execute the final comprehensive validation and quality audit to satisfy Gate 4 machine criteria:
1. **Dual-Mode Round-Trip Verification**:
   - Run `./scripts/configure_mode.sh lean` -> verify 2-tab Shell, clean analysis, green tests.
   - Run `./scripts/configure_mode.sh enterprise` -> verify 3-tab Shell, clean analysis, green tests.
   - Run `./scripts/configure_mode.sh lean --prune` on a clean test branch -> verify clean removal of `features/scanner` with zero orphan references.
2. **Mason Bricks Generation & Compilation Verification**:
   - Scaffold test headless plugin: `mason make pac_native_plugin --name test_headless --has_ui false`.
   - Scaffold test UI plugin: `mason make pac_native_plugin --name test_ui --has_ui true`.
   - Upgrade headless to UI: `mason make pac_add_native_ui --name test_headless`.
   - Compile both on Android (`./gradlew compileDebugKotlin`) and iOS (`xcodebuild` / SwiftPM build).
3. **Renaming Tool Verification**:
   - Clone to a temporary scratch directory.
   - Execute `./scripts/rename_project.sh "SampleApp" sample_app com.sample.app --mode lean`.
   - Verify renamed project passes `melos bootstrap` and compiles.
4. **Shift-Right Bookend Verification (Check 2)**:
   - Run `check_code_impact.py` against base branch, ensuring zero unexpected divergence and all seams protected.
5. **Quality Check Execution (`quality_check`)**:
   - Run full 3-Tier test suite: Tier A (Unit), Tier B (Tooling/Governance), Tier C (Integration).
   - Execute 4 Semantic Audits (Security, Architecture, UI, Code Health) with zero blockers.
   - Clean archival of completed tasks.

## Relevant Files & Context Pointers
- `scripts/configure_mode.sh`
- `scripts/rename_project.sh`
- `bricks/**`
- `packages/**`
- `features/**`
- `lib/**`

## Design Rationale
- **Absolute Quality Confidence**: No feature is complete until verified end-to-end against real build environments across all supported modes and scaffolding configurations.
- **Applicable Skills**: `quality_check`, `verification-before-completion`, `finishing-a-development-branch`.

## Impact Analysis & Blast Radius
- **Target Files & Symbols**: Entire repository.
- **Downstream Callers**: All developers cloning or maintaining this template.
- **Cross-Platform Bridges**: Verified on Android Gradle and iOS Xcode/SPM.
- **Target Test Coverage Threshold**: 100% test pass; zero regressions.

### BDD SCENARIOS

#### Scenario 8.1: [Tier C - Integration] Full Mode Switching and Host Acceptance
```gherkin
Given a fresh checkout of the template
When switching between "enterprise" and "lean" modes
Then all unit, widget, and integration tests pass in both configurations
And no orphan references remain in "pubspec.yaml" or "melos.yaml"
```

#### Scenario 8.2: [Tier C - Integration] Full Brick Matrix Compilation
```gherkin
Given all updated Mason Bricks in "bricks/"
When generating plugins with all parameter permutations:
  | Brick | has_ui | Target OS | Result |
  | pac_native_plugin | false | Android + iOS | Compiles clean |
  | pac_native_plugin | true | Android + iOS | Compiles clean |
  | pac_add_native_ui | n/a | Android + iOS | Compiles clean |
Then every generated package builds without compiler or linker errors
```

#### Scenario 8.3: [Tier C - Integration] Gate 4 LGTM Machine Verdict
```gherkin
When "quality_check" runs across the workspace
Then Tier A, B, and C tests pass 100%
And 4 Semantic Audits report 0 blockers
And Check 2 Shift-Right bookend verifies zero unprotected modified files
Then Gate 4 outputs "🟢 LGTM"
```

## Test & Verification Checklist
- [x] **RED**: Assert failure if any test in either mode fails or if any generated brick fails compilation.
- [x] **GREEN**: Fix any edge-case findings identified during end-to-end testing.
- [x] **REFACTOR**: Clean up all temporary test packages and restore git working tree.
- [x] **Tier C (Integration)**: Run `./scripts/testWithCoverage.sh` and execute `quality_check`.

## Definition of Done (DoD)
- Gate 4 machine criteria satisfied 100%.
- All 8 tasks verified and archived.
- Merge-ready branch prepared.

## Dependencies & Blockers
- Blocked by [Task 1](task_1_dual_mode_host_and_markers.md), [Task 2](task_2_configure_mode_script.md), [Task 3](task_3_rename_project_mode_flag.md), [Task 4](task_4_pac_native_plugin_android_dagger_workmanager.md), [Task 5](task_5_pac_native_plugin_ios_bgtask.md), [Task 6](task_6_pac_add_native_ui_sync.md), [Task 7](task_7_sync_shipped_native_plugins.md).

## References & Rollback
- References: Spec Section 8 & 9, HLD Section 5.
- Rollback: `git reset --hard HEAD`.
