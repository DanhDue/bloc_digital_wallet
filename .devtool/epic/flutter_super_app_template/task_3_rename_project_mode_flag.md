---
id: "task_3_rename_project_mode_flag"
status: "done"
priority: "medium"
assignee: null
epic: "flutter_super_app_template"
dueDate: null
created: "2026-09-15T13:20:00Z"
modified: "2026-09-15T06:49:50Z"
completedAt: "2026-09-15T06:49:50Z"
labels: ["tooling", "scripts", "renaming", "mason"]
order: "a3"
---

# Task 3: Project Renamer `--mode` Flag Integration

Epic: [flutter_super_app_template](flutter_super_app_template.en.md)

## Requirement Analysis
Upgrade `scripts/rename_project.sh` and the underlying Mason brick `bricks/pac_rename_project` to accept a `--mode` parameter:
1. **Contract**:
   ```bash
   scripts/rename_project.sh <NewAppName> <new_package_name> <new.bundle.id> [--mode <enterprise|lean>] [--force] [--dry-run]
   ```
   - Default value for `--mode` is `enterprise`.
2. **Behavior**:
   - Executes standard project renaming (application id, bundle identifier, app name, Dart imports).
   - Preserves internal vendor native plugin namespaces (`com.danhdue.*`).
   - Delegates mode configuration to `scripts/configure_mode.sh <mode>` immediately following file token replacements.
   - If `--mode lean` is passed, automatically runs `./scripts/configure_mode.sh lean`.
   - Validates the resulting renamed project by running `melos bootstrap` and `melos run analyze`.

## Relevant Files & Context Pointers
- `scripts/rename_project.sh`
- `bricks/pac_rename_project/brick.yaml`
- `bricks/pac_rename_project/hooks/post_gen.dart`
- `scripts/configure_mode.sh`
- `test/scripts/rename_project_test.sh` [NEW]

## Design Rationale
- **One-Command Project Provisioning**: Allows a team cloning the template to provision a completely renamed, mode-configured project in a single command, eliminating multi-step manual onboarding.
- **Mason Hook Delegation**: Keep renaming logic portable across OS environments via the Dart hook in `pac_rename_project`, calling `configure_mode.sh` as a finalization phase.
- **Applicable Skills**: `writing-skills`, `verification-before-completion`.

## Impact Analysis & Blast Radius
- **Target Files & Symbols**: `scripts/rename_project.sh`, `bricks/pac_rename_project/**`.
- **Downstream Callers**: Developer initial project setup, CI template validation.
- **Cross-Platform Bridges**: Preserves `com.danhdue.native_security` and `com.danhdue.logger_native_bridge`.
- **Target Test Coverage Threshold**: 100% pass on renaming integration test.

### BDD SCENARIOS

#### Scenario 3.1: [Tier A - Unit] Parse `--mode lean` Argument
```gherkin
Given developer runs "./scripts/rename_project.sh 'DemoApp' demo_app com.demo.app --mode lean"
When parameter parsing completes
Then the mode variable is captured as "lean"
And renaming proceeds with package "demo_app" and bundle id "com.demo.app"
And "scripts/configure_mode.sh lean" is invoked automatically
```

#### Scenario 3.2: [Tier A - Unit] Default to Enterprise Mode when `--mode` is Omitted
```gherkin
Given developer runs "./scripts/rename_project.sh 'DemoApp' demo_app com.demo.app"
When parameter parsing completes
Then the mode variable defaults to "enterprise"
And "scripts/configure_mode.sh enterprise" is invoked
```

#### Scenario 3.3: [Tier A - Unit] Reject Invalid Mode Argument
```gherkin
When developer runs "./scripts/rename_project.sh 'DemoApp' demo_app com.demo.app --mode invalid_mode"
Then the script terminates with error code 1
And prints "Error: Unsupported mode 'invalid_mode'. Choose 'enterprise' or 'lean'."
```

#### Scenario 3.4: [Tier C - Integration] Complete Clone, Rename, and Build in Lean Mode
```gherkin
Given an isolated temporary clone of the template
When executing "./scripts/rename_project.sh 'FastMVP' fast_mvp com.fast.mvp --mode lean"
Then all imports match "package:fast_mvp/..."
And the Shell displays 2 tabs (Home and Settings)
And "melos bootstrap" passes with 0 errors
And "fvm flutter test" passes cleanly
```

## Test & Verification Checklist
- [x] **RED**: Create `test/scripts/rename_project_test.sh` asserting argument parsing and mode delegation on a mock repository.
- [x] **GREEN**: Update `scripts/rename_project.sh` and `bricks/pac_rename_project/hooks/post_gen.dart` with `--mode` parameter.
- [x] **REFACTOR**: Verify argument validations and error messaging.
- [x] **Tier C (Integration)**: Run test renaming in a scratch clone, verifying compilation and clean git diff.

## Definition of Done (DoD)
- [x] `scripts/rename_project.sh` supports `--mode <enterprise|lean>`.
- [x] Project is renamed and configured to the desired mode in one step.
- [x] Internal plugin namespaces (`com.danhdue.*`) remain unchanged.

## Dependencies & Blockers
- Blocked by [Task 2](task_2_configure_mode_script.md) (requires `configure_mode.sh`).

## References & Rollback
- References: Spec Section 6.3, HLD Section 4.
- Rollback: `git checkout HEAD -- scripts/rename_project.sh bricks/pac_rename_project/`.
