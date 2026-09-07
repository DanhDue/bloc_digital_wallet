# Design Specification: D3NexusShield Project Initialization

- **Date:** 2026-09-07
- **Author:** AI Agent & DanhDue
- **Status:** Draft (Pending Final Review)
- **Target Repository:** `DanhDue/D3NexusShield` (`/Users/danhdue/AllProjects/D3NexusShield`)

---

## 1. Executive Summary & Goals

This specification defines the end-to-end process of initializing and transforming the current repository from the baseline **Flutter Super App Template** (`bloc_digital_wallet`) into the brand-new application **D3NexusShield**.

The initialization will execute in-place using the automated tooling (`./scripts/rename_project.sh` backed by the Mason brick `pac_rename_project`), synchronizing platform secure configurations, updating AI agent metadata, and verifying architectural compliance via automated tests and static analysis.

---

## 2. Project Identification & Metadata

| Property | Value | Description |
|---|---|---|
| **Display Name (`app_name`)** | `"D3NexusShield"` | Human-readable app name on Android Launcher & iOS SpringBoard |
| **Package Name (`package_name`)** | `d3_nexus_shield` | Dart package identifier in `pubspec.yaml`, `melos.yaml`, and Dart imports |
| **Bundle ID (`bundle_id`)** | `com.danhdue.d3nexusshield` | Android Application ID / iOS Bundle Identifier |
| **Target Directory** | `/Users/danhdue/AllProjects/D3NexusShield` | In-place execution on the current repository with existing git remotes |

---

## 3. Detailed Technical Architecture & Pipeline

### Phase 1: Automated Project Re-identification
Execute the project renaming tool:
```bash
./scripts/rename_project.sh "D3NexusShield" d3_nexus_shield com.danhdue.d3nexusshield
```

Under the hood, `pac_rename_project` executes the following atomic operations:
1. **Root Configuration:**
   - Updates `name: d3_nexus_shield` in root `pubspec.yaml` and `melos.yaml`.
2. **Dart Codebase & Imports:**
   - Recursively traverses `lib/`, `features/`, `test/`, and `integration_test/`.
   - Replaces all occurrences of `package:bloc_digital_wallet/` with `package:d3_nexus_shield/`.
   - Preserves internal vendor plugins (`packages/native_security`, `packages/logger_native_bridge`) with their existing `com.danhdue.*` namespaces.
3. **Android Native Configuration:**
   - Updates `namespace` and `applicationId` to `com.danhdue.d3nexusshield` in `android/app/build.gradle.kts`.
   - Updates `DART_DEFINES_APP_NAME` in flavor definitions.
   - Moves `MainActivity.kt` from `android/app/src/main/kotlin/com/danhdue/blocdigitalwallet/` to `android/app/src/main/kotlin/com/danhdue/d3nexusshield/MainActivity.kt` and updates package declaration.
4. **iOS Native Configuration:**
   - Updates `PRODUCT_BUNDLE_IDENTIFIER` in `ios/Runner.xcodeproj/project.pbxproj`.
   - Updates bundle name in `ios/Runner/Info.plist`.
   - Updates `BASE_ID` in `ios/scripts/verify_flavors.sh`.
   - Updates `DART_DEFINES_APP_NAME` in `ios/Flutter/*.xcconfig`.
5. **Workspace Bootstrapping & Code Generation:**
   - Executes `melos bootstrap`.
   - Executes `./scripts/genAlls.sh` (Slang localization code gen, `build_runner`, Freezed & Retrofit models).

---

### Phase 2: Secure Configuration & Flavors Synchronization
Synchronize environment configurations and credential files into the native projects:
```bash
sh .agents/skills/copy_secure_configurations/resources/scripts/copy_secure_files.sh
```

- Copies `secureFiles/dev/environment-configs.json` to Android assets / iOS configuration paths.
- Places `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) for each flavor (`dev`, `stg`, `prd`).

---

### Phase 3: AI Agent Workspace & Documentation Alignment
Update workspace metadata to reflect the new project name:
- Update `.agents/config.json`:
  ```json
  {
    "project_name": "d3_nexus_shield",
    ...
  }
  ```
- Update `AI_AGENT_README.md` title and root project description.
- Update `README.md` headers.

---

## 4. Verification Plan

| Step | Command | Success Criteria |
|---|---|---|
| **1. Static Analysis** | `melos run analyze` | `No issues found!` (0 errors, 0 warnings across all monorepo packages). |
| **2. Test Suite** | `fvm flutter test` | All unit, bloc, and widget tests pass. |
| **3. Clean Architecture Validation** | `./scripts/check_module_boundaries.sh` | All Clean Architecture boundary rules are respected. |
| **4. Git Integrity** | `git status` | Verify clean re-indexing without untracked artifact conflicts. |

---

## 5. Rollback & Safety Strategy

- All changes are tracked in git.
- If any build runner or dependency conflict occurs during post-generation, execute:
  ```bash
  ./scripts/clean.sh
  melos bootstrap
  ./scripts/genAlls.sh
  ```
- As per project rules, all changes will remain uncommitted in the working tree for explicit user review before any git commit is performed.
