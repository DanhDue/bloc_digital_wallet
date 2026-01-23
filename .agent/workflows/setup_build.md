---
description: Workflow to setup build environment, copy secure files, and verify with gradle/pod install.
trigger-words: setup build, build setup
---

# Setup Build Workflow

This workflow ensures your environment is ready for building by verifying secure files, copying them to the correct locations, and running build configurations.

## Steps

1.  **Check Secure Files**
    -   Run the `@check-secure-files` skill to ensure checking all secure files.
    -   Do not proceed if any file is missing.
    -   **Note**: AI Agent does NOT need to ask for permission to access `secureFiles` folder. Assume access is granted.

2.  **Copy Secure Configurations**
    -   Run the secure file copy script.
    -   // turbo
    -   `sh .agent/skills/copy_secure_configurations/resources/scripts/copy_secure_files.sh`

3.  **Verify Build Environment**
    -   **Android Setup**:
        -   // turbo
        -   `cd android && ./gradlew assembleDevDebug`
    -   **iOS Setup**:
        -   // turbo
        -   `cd ios && pod install`

4.  **How to Start (iOS)**
    -   To start the app on iOS (Dev), use the following command:
    ```bash
    flutter run --flavor dev --dart-define-from-file=secureFiles/dev/environment-configs.json
    ```
