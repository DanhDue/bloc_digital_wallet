# D3NexusShield Project Initialization Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Transform and initialize the current repository into the **D3NexusShield** application from the Flutter Super App Template, updating project identification, Dart package namespace, platform configurations, and validating with full test suites.

**Architecture:** Monorepo using Melos, Clean Architecture + MVI pattern. Project re-identification is automated via the Mason brick `pac_rename_project` which atomically refactors package metadata, Dart imports, Android/iOS configurations, runs `melos bootstrap`, code generators, and links secure flavor files.

**Tech Stack:** Flutter / Dart, Melos, Mason CLI, Kotlin (Android), Swift (iOS).

---

### Task 1: Execute Automated Project Renaming (`pac_rename_project`)

**Files:**
- Modify: `pubspec.yaml`
- Modify: `melos.yaml`
- Modify: `android/app/build.gradle.kts`
- Move & Modify: `android/app/src/main/kotlin/com/danhdue/blocdigitalwallet/MainActivity.kt` -> `android/app/src/main/kotlin/com/danhdue/d3nexusshield/MainActivity.kt`
- Modify: `ios/Runner.xcodeproj/project.pbxproj`
- Modify: `ios/Runner/Info.plist`
- Modify: `ios/scripts/verify_flavors.sh`
- Modify: `ios/Flutter/App-dev.xcconfig`, `ios/Flutter/App-stg.xcconfig`, `ios/Flutter/App-prd.xcconfig`
- Modify: All `package:bloc_digital_wallet/` imports in `lib/`, `features/`, `test/`, `integration_test/`

- [x] **Step 1: Execute the automated rename script**

Run:
```bash
./scripts/rename_project.sh "D3NexusShield" d3_nexus_shield com.danhdue.d3nexusshield
```
Expected output:
- `Renaming project to "D3NexusShield" (d3_nexus_shield)...`
- `Updating pubspec.yaml...`
- `Updating melos.yaml...`
- `Updating Dart imports...`
- `Updating Android native config...`
- `Updating iOS native config...`
- `Running melos bootstrap & code generation...`

- [x] **Step 2: Verify root pubspec.yaml and melos.yaml**

Run:
```bash
grep "name: d3_nexus_shield" pubspec.yaml melos.yaml
```
Expected output:
```
pubspec.yaml:name: d3_nexus_shield
melos.yaml:name: d3_nexus_shield
```

- [x] **Step 3: Verify no remaining `package:bloc_digital_wallet/` references**

Run:
```bash
git grep "package:bloc_digital_wallet/" lib/ features/ test/ integration_test/ || true
```
Expected output: 0 matches.

- [x] **Step 4: Check git status and auto_commit check**

Check `.agents/config.yml` for `auto_commit` setting.
If `auto_commit: false`: skip commit and staging. Print: "Skipping commit (auto_commit: false)."

---

### Task 2: Synchronize Secure Configurations and Flavors

**Files:**
- Destination files in `android/app/src/{dev,stg,prd}/`
- Destination files in `ios/Runner/Firebase/{dev,stg,prd}/`

- [x] **Step 1: Run copy_secure_files.sh**

Run:
```bash
sh .agents/skills/copy_secure_configurations/resources/scripts/copy_secure_files.sh
```
Expected output:
- Confirmation of copied `google-services.json`, `GoogleService-Info.plist`, and `environment-configs.json` for `dev`, `stg`, and `prd` without errors.

- [x] **Step 2: Verify Android and iOS target configurations exist**

Run:
```bash
ls -la android/app/src/dev/google-services.json ios/Runner/Firebase/dev/GoogleService-Info.plist
```
Expected output: Files exist with non-zero size.

- [x] **Step 3: Check auto_commit setting**

Check `.agents/config.yml` for `auto_commit` setting.
If `auto_commit: false`: skip commit and staging. Print: "Skipping commit (auto_commit: false)."

---

### Task 3: Update AI Agent Configuration & Project Documentation

**Files:**
- Modify: `.agents/config.json`
- Modify: `AI_AGENT_README.md`
- Modify: `README.md`

- [x] **Step 1: Update `.agents/config.json` project name**

In `.agents/config.json`, change:
```json
"project_name": "bloc_digital_wallet"
```
to:
```json
"project_name": "d3_nexus_shield"
```

- [x] **Step 2: Update AI_AGENT_README.md and README.md project titles**

In `AI_AGENT_README.md`:
Update header: `# 🤖 AI Agent Entry Point - D3NexusShield`

In `README.md`:
Update header: `# D3NexusShield`

- [x] **Step 3: Verify changes**

Run:
```bash
git diff .agents/config.json AI_AGENT_README.md README.md
```
Expected: Clean updates to project names.

- [x] **Step 4: Check auto_commit setting**

Check `.agents/config.yml` for `auto_commit` setting.
If `auto_commit: false`: skip commit and staging. Print: "Skipping commit (auto_commit: false)."

---

### Task 4: Comprehensive Verification & Static Analysis

**Files:**
- Entire repository

- [x] **Step 1: Run Melos static analysis**

Run:
```bash
melos run analyze
```
Expected: `No issues found!` across all packages.

- [x] **Step 2: Run Flutter test suite**

Run:
```bash
fvm flutter test
```
Expected: All unit and widget tests pass with 0 failures.

- [x] **Step 3: Run Clean Architecture boundary checks**

Run:
```bash
./scripts/check_module_boundaries.sh
```
Expected: Pass without boundary violation warnings.

- [x] **Step 4: Verify working tree status**

Run:
```bash
git status
```
Ensure no broken untracked files exist.
