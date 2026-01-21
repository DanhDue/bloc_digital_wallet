# 🤖 AI Agent Entry Point - bloc_digital_wallet

Welcome! This file provides the essential context for building and developing this project.

## 🏗️ Build Environment (CRITICAL)
This project is optimized for **Dev Containers**. To mirror the developer's local environment, you **MUST** use the provided configuration.

1.  **Environment**: Use `.devcontainer/devcontainer.json`.
2.  **Initialization**: Run the setup script to install CLI tools (FVM, Mason, Melos, Ruby, etc.):
    ```bash
    bash .devcontainer/setup.sh
    ```
3.  **Permissions**: Global git safe directory is configured in the Dockerfile to prevent ownership errors in cloud agents.

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
