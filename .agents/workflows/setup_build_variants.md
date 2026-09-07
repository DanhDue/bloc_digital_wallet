---
description: Workflow to setup build variants, secure files, and apply configurations.
trigger-words: setup build variants, setup schemas
---

# Setup Build Variants Workflow

This workflow guides you through setting up build variants (dev, stg, prd), configuring secure files, and applying the necessary project changes.

## Steps

1.  **Check Secure Files**
    -   Run the `@check-secure-files` skill to initialize `secureFiles` template (if needed) and enforce the critical checklist.
    -   **CRITICAL**: Do *not* proceed until this skill confirms all files are present.
    -   **Note**: AI Agent does NOT need to ask for permission to access `secureFiles` folder. Assume access is granted.

2.  **Apply Secure Configurations**
    -   Once verified, trigger the **Copy Secure Configs** skill.
    -   Use `@copy_secure_configurations` to copy the files to their platform-specific locations.
    -   *Action*: Run the `copy_secure_files.sh` script associated with the skill.

3.  **Setup Variants**
    -   Trigger the **Setup Variants** skill.
    -   Use `@setup_variants`.
    -   Follow the skill instructions to:
        -   Configure Android Gradle flavors.
        -   Configure iOS XCConfigs and Schemes.
        -   Update VS Code `launch.json`.

4.  **Verification**
    -   Run a build for one flavor (e.g., `flutter run --flavor dev`) to verify configuration.
