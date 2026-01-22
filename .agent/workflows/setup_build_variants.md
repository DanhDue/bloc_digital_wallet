---
description: Workflow to setup build variants, secure files, and apply configurations.
trigger-words: setup build variants, setup schemas
---

# Setup Build Variants Workflow

This workflow guides you through setting up build variants (dev, stg, prd), configuring secure files, and applying the necessary project changes.

## Steps

1.  **Initialize Secure Files**
    -   Check if the `secureFiles` directory exists in the project root.
    -   If not, create it manually or copy the template from `.agent/skills/setup_variants/resources/secureFiles`.
    -   Ensure the following structure exists:
        ```text
        secureFiles/
        ├── dev/
        │   ├── environment-configs.json
        │   ├── google-services.json
        │   └── GoogleService-Info.plist
        ├── stg/
        │   ├── environment-configs.json
        │   ├── google-services.json
        │   └── GoogleService-Info.plist
        └── prd/
            ├── environment-configs.json
            ├── google-services.json
            └── GoogleService-Info.plist
        ```

2.  **Data Entry Plan**
    -   Create a `setup_plan.md` (or update `task.md`) with a checklist for the user to provide the actual values for the files above.
    -   **CRITICAL**: Do *not* proceed until the user confirms they have populated these files with real data (or placeholders they accept).
    -   Ask the user: "Please populate the `secureFiles` directory with your real configuration data. Let me know when you are ready to proceed."

3.  **Apply Secure Configurations**
    -   Once the user confirms, trigger the **Copy Secure Configs** skill.
    -   Use `@copy_secure_configurations`.
    -   *Action*: Run the `copy_secure_files.sh` script to verify files are copied correctly.

4.  **Setup Variants**
    -   Trigger the **Setup Variants** skill.
    -   Use `@setup_variants`.
    -   Follow the skill instructions to:
        -   Configure Android Gradle flavors.
        -   Configure iOS XCConfigs and Schemes.
        -   Update VS Code `launch.json`.

5.  **Verification**
    -   Run a build for one flavor (e.g., `flutter run --flavor dev`) to verify configuration.
