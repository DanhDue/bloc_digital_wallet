# 🤖 AI Agent Entry Point - bloc_digital_wallet

Welcome! This file provides the essential context for building and developing this project.

## 🏗️ Build Environment (CRITICAL)
This project is optimized for **Dev Containers**. To mirror the developer's local environment, you **MUST** use the provided configuration.

1.  **Environment**: Use `.devcontainer/devcontainer.json`.
2.  **Initialization**: Run the setup script to install CLI tools (FVM, Mason, Melos, Ruby, etc.):
    ```bash
    bash .devcontainer/setup.sh
    ```
3.  **Permissions**: Global git safe directory is configured to prevent ownership errors.
4.  **Secrets (Environment Override)**:
    - Automatically decoded from `SECURE_FILES` during `setup.sh`.
    - **How to verify**: Run `ls -d secureFiles/` or the alias `verify-secrets` to ensure the folder exists.
    - **Manual Decoding**: If automatic decoding fails, run:
      ```bash
      echo "$SECURE_FILES" | base64 -d | tar -xz
      ```
    - To generate this value locally, run: `bash scripts/secrets_ops.sh encode`
    - See [Secrets ENV Workflow](file:///.agent/workflows/secrets-env.md) for details.

## 📚 Resources & Rules
All detailed rules, skills, and workflows are located in the `.agent/` directory.

- **🚨 Critical Rules**: [.agent/rules/critical-rules.md](file:///.agent/rules/critical-rules.md)
- **🛠️ AI Skills**: [.agent/README.md](file:///.agent/README.md) (Use `@api_integration`, `@create_new_feature`)
- **🏗️ Patterns**: [.agent/patterns/](file:///.agent/patterns/) (Clean Architecture + MVI)

## 🔧 CLI Commands
Once the environment is set up (via `setup.sh`), use these tools:
- `fvm flutter`: Flutter SDK (use `fvm` prefix)
- `mason`: For feature generation (bricks at `bricks/`)
- `melos`: For multi-package workspace management

## 🎯 Architecture
- **State Management**: flutter_bloc (MVI Pattern)
- **DI**: GetIt + Injectable
- **Persistence**: Isar / SharedPreferences
- **API**: Retrofit / Dio

---
**Note**: This file is the primary system prompt override. Always refer back to this when state is lost.
