# Build Setup Guide

This document guides you on which workflow to choose based on the current state of your project.

## 1. Initial Setup (No Build Variants)
**Condition**: The project does NOT have build variants (`dev`, `stg`, `prd`) configured yet.

**Action**: Use the **Setup Build Variants** workflow.
- **Workflow**: `setup_build_variants`
- **File**: `.agents/workflows/setup_build_variants.md`
- **What it does**:
  1. Checks/Initializes `secureFiles` template.
  2. Sets up Android Flavors and Signing Configs.
  3. Sets up iOS Schemes, XCConfigs, and Podfile.
  4. Creates VS Code launch configurations.

---

## 2. Routine Build & Verification (Ready to Build)
**Condition**: The project ALREADY has build variants set up, and you have populated the `secureFiles` directory with valid data.

**Action**: Use the **Setup Build** workflow.
- **Workflow**: `setup_build`
- **File**: `.agents/workflows/setup_build.md`
- **What it does**:
  1. Verifies that `secureFiles` are present and valid (using `@check-secure-files` skill).
  2. Copies the secure configurations to the native project locations.
  3. Runs a quick build verification (`gradle assemble`, `pod install`).
