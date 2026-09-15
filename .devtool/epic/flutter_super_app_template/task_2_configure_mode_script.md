---
id: "task_2_configure_mode_script"
status: "done"
priority: "high"
assignee: null
epic: "flutter_super_app_template"
dueDate: null
created: "2026-09-15T13:20:00Z"
modified: "2026-09-15T06:47:52Z"
completedAt: "2026-09-15T06:47:52Z"
labels: ["tooling", "scripts", "mode-switching", "cli"]
order: "a2"
---

# Task 2: Mode Configuration CLI (`configure_mode.sh`)

Epic: [flutter_super_app_template](flutter_super_app_template.en.md)

## Requirement Analysis
Implement `scripts/configure_mode.sh` to automate switching between `enterprise` and `lean` modes:
1. **Contract**:
   ```bash
   scripts/configure_mode.sh <enterprise|lean> [--prune] [--force] [--root-dir=<path>]
   ```
2. **Enterprise Mode Actions**:
   - Uncomment all marker regions in `shell_page.dart`, `app_router.dart`, `injection.dart`, and `deep_link_registry.dart`.
   - Restore tab count to 3.
   - Run `melos bootstrap` and `melos run analyze`.
3. **Lean Mode Actions**:
   - Comment out scanner marker regions in `shell_page.dart`, `app_router.dart`, `injection.dart`, and `deep_link_registry.dart`.
   - Set tab count to 2.
   - If `--prune` is passed:
     - Check `git status --porcelain`. If dirty and `--force` not supplied, abort with an actionable error.
     - Remove `features/scanner` directory from disk.
     - Remove `features/scanner` entry from root `pubspec.yaml` and `melos.yaml`.
   - Run `melos bootstrap` and `melos run analyze`.
4. **Idempotency & Safety**:
   - Re-running `configure_mode.sh enterprise` on an enterprise setup leaves files unmodified.
   - Re-running `configure_mode.sh lean` on a lean setup leaves files unmodified.
   - Comprehensive bash unit/integration test in `test/scripts/configure_mode_test.sh`.

## Relevant Files & Context Pointers
- `scripts/configure_mode.sh` [NEW]
- `test/scripts/configure_mode_test.sh` [NEW]
- `lib/shell/shell_page.dart`
- `lib/app_router.dart`
- `lib/di/injection.dart`
- `packages/platform/lib/deeplink/deep_link_registry.dart`
- `pubspec.yaml`
- `melos.yaml`

## Design Rationale
- **Cross-Platform Shell Scripting**: Use portable POSIX/Bash syntax that runs seamlessly on macOS (BSD sed/awk) and Linux (GNU sed/awk) without syntax errors.
- **Fail-Fast Safety**: Protecting developers' uncommitted work by strictly enforcing git status checks before any destructive deletion (`--prune`).
- **Applicable Skills**: `writing-skills`, `verification-before-completion`.

## Impact Analysis & Blast Radius
- **Target Files & Symbols**: `scripts/configure_mode.sh`.
- **Downstream Callers**: `scripts/rename_project.sh`, developer CLI usage, CI pipelines.
- **Cross-Platform Bridges**: None.
- **Target Test Coverage Threshold**: 100% pass rate on round-trip mode transitions in test runner.

### BDD SCENARIOS

#### Scenario 2.1: [Tier A - Unit] Switch to Lean Mode (Non-Prune)
```gherkin
Given a repository in "enterprise" mode
When the developer runs "./scripts/configure_mode.sh lean"
Then all scanner marker regions are commented out
And "melos bootstrap" exits with code 0
And "melos run analyze" reports 0 errors
```

#### Scenario 2.2: [Tier A - Unit] Round-Trip Transition (Enterprise -> Lean -> Enterprise)
```gherkin
Given a repository switched to "lean" mode
When the developer runs "./scripts/configure_mode.sh enterprise"
Then all marker regions are uncommented
And git diff shows zero net change compared to the original enterprise state
```

#### Scenario 2.3: [Tier A - Unit] Prune Abort on Dirty Working Tree
```gherkin
Given modified uncommitted files in git status
When the developer executes "./scripts/configure_mode.sh lean --prune" without "--force"
Then the script terminates with exit code 1
And prints "Working tree has uncommitted changes. Use --force to override."
And "features/scanner" remains untouched on disk
```

#### Scenario 2.4: [Tier A - Unit] Prune Clean Removal
```gherkin
Given a clean working tree
When the developer executes "./scripts/configure_mode.sh lean --prune"
Then "features/scanner" is deleted
And "pubspec.yaml" and "melos.yaml" have "features/scanner" removed
And "melos bootstrap" succeeds without missing workspace package errors
```

#### Scenario 2.5: [Tier C - Integration] Verification of Idempotency
```gherkin
Given a repository already in "lean" mode
When running "./scripts/configure_mode.sh lean" twice in succession
Then the second run exits with 0 and modifies 0 files
```

## Test & Verification Checklist
- [x] **RED**: Create `test/scripts/configure_mode_test.sh` asserting mode transitions and error states on a temporary git fixture.
- [x] **GREEN**: Implement `scripts/configure_mode.sh` with robust sed/awk marker manipulation.
- [x] **REFACTOR**: Ensure script passes `shellcheck` if available, and executable bit is set (`chmod +x`).
- [x] **Tier C (Integration)**: Execute round-trip on current workspace, verifying `melos bootstrap` and `melos run analyze` pass cleanly.

## Definition of Done (DoD)
- [x] `scripts/configure_mode.sh` supports `enterprise`, `lean`, `--prune`, `--force`.
- [x] Script passes round-trip tests with 100% clean diff.
- [x] Execution is idempotent and safely guards against dirty worktree pruning.

## Dependencies & Blockers
- Blocked by [Task 1](task_1_dual_mode_host_and_markers.md) (requires marker regions to exist).

## References & Rollback
- References: Spec Section 3.1 & 3.2, HLD Section 4.
- Rollback: `rm -f scripts/configure_mode.sh test/scripts/configure_mode_test.sh`.
