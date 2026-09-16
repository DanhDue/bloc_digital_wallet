# BDD Scenarios: Documentation Restructure

Epic: [docs_restructure](docs_restructure.en.md)

---

## UC-1: Discover Technical Analysis

### Scenario 1.1 — Happy Path: Developer finds Governance doc
```gherkin
[Tier C - Integration]
Given a developer opens docs/technical-analysis/
When they look for the Super App Governance architecture
Then they find SUPER_APP_GOVERNANCE.en.md and SUPER_APP_GOVERNANCE.vi.md
And the file contains the full HLD content with 4-pillar framework
And the file has a header note indicating source epic and status
```

### Scenario 1.2 — Happy Path: Developer finds Deeplink Engine doc
```gherkin
[Tier C - Integration]
Given a developer opens docs/technical-analysis/
When they look for the DeepLink routing architecture
Then they find DEEPLINK_ENGINE.en.md and DEEPLINK_ENGINE.vi.md
And the files are NOT found in .devtool/epic/deeplink_router_engine/ (moved)
```

### Scenario 1.3 — Edge Case: Original HLD files removed from epic directory
```gherkin
[Tier C - Integration]
Given the migration is complete
When listing .devtool/epic/logging_refactor/
Then logging_refactor.en.md is NOT present
And logging_refactor.vi.md is NOT present
And the design spec files (YYYY-MM-DD-*.md) ARE still present
```

---

## UC-2: Understand Super App Requirements

### Scenario 2.1 — Happy Path: All 4 pillars documented with status
```gherkin
[Tier A - Unit]
Given docs/technical-analysis/SUPER_APP_REQUIREMENTS.md exists
When a developer reads the file
Then they see all 4 governance pillars documented
And each pillar has concrete requirements with status (✅/🔄/📋)
And each requirement links to the relevant epic or implementation
```

### Scenario 2.2 — Happy Path: Logging requirements show as Planned
```gherkin
[Tier A - Unit]
Given SUPER_APP_REQUIREMENTS.md is written
When reading the Logging & Observability section
Then all logging requirements show status "📋 Planned"
And they reference the logging_refactor epic
```

### Scenario 2.3 — Happy Path: Resilience requirements show as Implemented
```gherkin
[Tier A - Unit]
Given SUPER_APP_REQUIREMENTS.md is written
When reading the Resilience & Memory section
Then OOM prevention shows "✅ Implemented"
And MiniAppErrorBoundary shows "✅ Implemented"
And MemoryPressureObserver shows "✅ Implemented"
```

---

## UC-3: Run Quality Audit with Consolidated Rules

### Scenario 3.1 — Happy Path: Cheat sheet has all 8 rule sets
```gherkin
[Tier A - Unit]
Given docs/cheat-sheets/FLUTTER_QUALITY_RULES.md exists
When reading the file
Then it contains MVI Naming Conventions section
And it contains Architecture Layer Rules section
And it contains Common Anti-Patterns section
And it contains Theme Usage Rules section
And it contains Localization Rules section
And it contains Networking Rules section
And it contains Security Rules section
And it contains Dependency Injection Rules section
```

### Scenario 3.2 — Happy Path: Theme rule "never use Theme.of(context)" is present
```gherkin
[Tier A - Unit]
Given FLUTTER_QUALITY_RULES.md is written with theme rules
When an agent invokes flutter-ui-audit on a file using Theme.of(context)
Then the rule violation is flagged
And the correct alternative (context.appThemes) is recommended
```

### Scenario 3.3 — Edge Case: No duplicate rules between cheat-sheet and guide docs
```gherkin
[Tier A - Unit]
Given FLUTTER_QUALITY_RULES.md contains the do/dont theme rules
When reading THEME_TAILOR_GUIDE.md (trimmed version)
Then the do/dont patterns are NOT duplicated in THEME_TAILOR_GUIDE.md
And THEME_TAILOR_GUIDE.md contains only how-to and API reference content
```

---

## UC-4: Quick Commands Reference

### Scenario 4.1 — Happy Path: QUICK_REFERENCE has Mason commands
```gherkin
[Tier A - Unit]
Given QUICK_REFERENCE.md has been slimmed
When a developer opens QUICK_REFERENCE.md
Then they find Mason brick commands (pac_mvi_feature, pac_native_plugin)
And they find Melos commands (genAlls, genFeature, integrateFeatureToApp)
And they find Code Generation commands (build_runner, slang)
```

### Scenario 4.2 — Edge Case: Architecture section removed, link added
```gherkin
[Tier A - Unit]
Given QUICK_REFERENCE.md has been slimmed
When reading the file
Then there is NO "Core Concepts" section duplicating ARCHITECTURE.md
And there IS a link pointing to docs/architecture/ARCHITECTURE.md
```

### Scenario 4.3 — Edge Case: Common Mistakes table removed from QUICK_REFERENCE
```gherkin
[Tier A - Unit]
Given FLUTTER_QUALITY_RULES.md contains the Common Anti-Patterns
And QUICK_REFERENCE.md has been slimmed
When reading QUICK_REFERENCE.md
Then the "Common Mistakes" anti-pattern table is NOT present
And there IS a link pointing to docs/cheat-sheets/FLUTTER_QUALITY_RULES.md
```

---

## UC-5: Onboard with epic-lifecycle

### Scenario 5.1 — Happy Path: epic-lifecycle section is prominent in README
```gherkin
[Tier C - Integration]
Given docs/README.md has been updated
When a developer opens the README
Then they see a dedicated "Development Workflow (/epic-lifecycle)" section
And it is NOT at the bottom — it appears before the file listing sections
And it contains a table with 4 stages (brainstorming, epic-designer, epic-implementation, quality_check)
```

### Scenario 5.2 — Happy Path: Tri-platform table shown
```gherkin
[Tier C - Integration]
Given docs/README.md has been updated
When reading the epic-lifecycle section
Then they see a table showing Flutter, Android Native, and iOS Native rows
And each row shows the relevant toolchain (Melos+Mason / Gradle+Dagger2 / SPM+FactoryKit)
```

---

## Folder Consolidation

### Scenario 6.1 — Happy Path: system-design folder eliminated
```gherkin
[Tier C - Integration]
Given the migration is complete
When listing docs/
Then the system-design/ folder does NOT exist
And docs/architecture/REFRESH_TOKEN_DESIGN.md DOES exist
And its content is identical to the original system-design/refresh_token.md
```

### Scenario 6.2 — Happy Path: environment folder eliminated
```gherkin
[Tier C - Integration]
Given the migration is complete
When listing docs/
Then the environment/ folder does NOT exist
And docs/development/ENVIRONMENT_SETUP.md DOES exist
```

### Scenario 6.3 — Edge Case: No broken links after folder consolidation
```gherkin
[Tier C - Integration]
Given all file moves are complete
When running: find docs/ -name "*.md" -exec grep -l "system-design\|environment/" {} \;
Then zero files contain links to the old paths
```

---

## No Content Loss

### Scenario 7.1 — Critical: Git history preserved for all moved files
```gherkin
[Tier C - Integration]
Given all moves used git mv (not cp + rm)
When running git log --follow docs/architecture/REFRESH_TOKEN_DESIGN.md
Then the commit history includes commits from before the move
```

### Scenario 7.2 — Critical: Zero files lost during restructure
```gherkin
[Tier C - Integration]
Given the restructure is complete
When running: git diff --name-status HEAD~8..HEAD
Then no file shows as deleted (D) without a corresponding add (A) or rename (R)
```
