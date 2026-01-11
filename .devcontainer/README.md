# DevContainer Setup Guide for AI Agents

**Complete guide for using this project with Development Containers**

---

## 🎯 Overview

This project includes a complete Development Container (devcontainer) configuration optimized for **AI Agents** (like Google Jules AI, GitHub Copilot Workspace, Cursor AI, etc.) to work efficiently on the Flutter project.

---

## 📦 What's Included

### 1. **Pre-configured Environment**
- ✅ Flutter (via FVM - Flutter Version Manager)
- ✅ Dart SDK
- ✅ Android SDK
- ✅ Java 17 + Gradle
- ✅ Ruby 3.3 + Gems (bundler, cocoapods)
- ✅ Go + addlicense
- ✅ Node.js LTS
- ✅ Git + GitHub CLI

### 2. **Dart Global Packages**
- ✅ Mason CLI (code generation)
- ✅ Melos (workspace management)
- ✅ FlutterGen (asset generation)
- ✅ Flutterfire CLI (Firebase)
- ✅ GetX CLI
- ✅ build_runner

### 3. **AI Agent Tools**
- ✅ jq (JSON processor)
- ✅ yq (YAML processor)
- ✅ Helper scripts
- ✅ Quick commands via aliases
- ✅ Project documentation pre-loaded

### 4. **VSCode Extensions**
- ✅ Dart & Flutter
- ✅ Error Lens
- ✅ GitLens
- ✅ YAML support
- ✅ BLoC extension
- ✅ Code spell checker

---

## 🚀 Quick Start

### For Google Jules AI or Other AI Agents

**Option 1: Using GitHub Codespaces**

```bash
# 1. Open this repository in GitHub
# 2. Click "Code" → "Codespaces" → "Create codespace on main"
# 3. Wait for container to build (~5-10 minutes first time)
# 4. Container is ready when you see the welcome message
```

**Option 2: Using VS Code Dev Containers**

```bash
# 1. Install "Dev Containers" extension in VS Code
# 2. Open command palette (Cmd/Ctrl + Shift + P)
# 3. Select "Dev Containers: Reopen in Container"
# 4. Wait for setup to complete
```

**Option 3: Using Docker CLI**

```bash
# Build and run the container
docker compose -f .devcontainer/docker-compose.yml up -d

# Connect to the container
docker exec -it bloc_digital_wallet bash

# Verify setup
verify-setup.sh
```

---

## 📋 Post-Setup Verification

### Step 1: Verify Installation

```bash
# Run verification script
verify-setup.sh
```

**Expected Output:**
```
🔍 Verifying Development Environment...

📦 Core Tools:
✅ git: /usr/bin/git
✅ fvm: /home/vscode/.pub-cache/bin/fvm
✅ flutter: Flutter 3.x.x
✅ dart: Dart SDK version: 3.x.x
✅ go: go version go1.x.x
✅ ruby: ruby 3.3.0

🔧 Dart Global Tools:
✅ mason
✅ melos
✅ flutter_gen
✅ flutterfire

💎 Ruby Gems:
✅ bundle
✅ pod

📁 Project Status:
✅ Project found: /workspace
✅ .dart_tool exists
✅ pubspec.lock exists

🎯 Ready to code!
```

### Step 2: Read Project Information

```bash
# Display project info
show-info.sh

# Or read documentation directly
cat AI_AGENT_README.md
```

### Step 3: Test Flutter Doctor

```bash
flutter doctor -v
```

---

## 🛠️ Available Commands

### Quick Commands (Aliases)

```bash
# Flutter commands
flutter              # Runs fvm flutter
dart                 # Runs fvm dart
pub-get              # Get dependencies
pub-upgrade          # Upgrade dependencies
build-gen            # Run build_runner
format               # Format code
analyze              # Analyze code
test                 # Run tests
clean                # Clean and get dependencies
doctor               # Flutter doctor

# Mason commands
mason-get            # Get Mason bricks
mason-list           # List available bricks
mason-feature        # Create MVI feature

# Melos commands
melos-bs             # Bootstrap workspace
melos-clean          # Clean workspace
melos-test           # Run all tests
melos-format         # Format all code

# Navigation
goto-features        # cd to lib/features
goto-core            # cd to lib/core
goto-docs            # cd to workspace root
goto-scripts         # cd to scripts/

# Documentation
project-info         # Show project info
show-workflows       # Show AI Agent workflows
show-context         # Show architecture context
show-checklist       # Show quick checklist

# Quick fixes
quick-fix            # Format + analyze
full-clean           # Deep clean
gen-all              # Full code generation
```

### Helper Scripts

Located in `~/.ai-agent-helpers/`:

```bash
# Create new feature
create-feature.sh <feature_name>
# Example: create-feature.sh transaction

# Run quick fixes
quick-fix.sh

# Show project information
show-info.sh

# Verify setup
verify-setup.sh
```

---

## 📚 AI Agent Workflow

### For First-Time Setup

```bash
# 1. Verify environment
verify-setup.sh

# 2. Read project documentation
cat AI_AGENT_README.md

# 3. Understand architecture
cat AI_AGENT_CONTEXT.md

# 4. Ready to work!
show-info.sh
```

### For Creating a New Feature

```bash
# Using helper script (recommended)
create-feature.sh wallet_history

# Or manually
mason make mvi_feature --feature_name wallet_history
build-gen
format
analyze
```

### For Daily Development

```bash
# Start of day
cd /workspace
pub-get
doctor

# During development
# ... make changes ...
format              # Format code
analyze             # Check for issues
build-gen           # Generate code (if needed)
test                # Run tests

# Before committing
quick-fix           # Format + analyze
```

---

## 🏗️ Container Architecture

### File Structure

```
.devcontainer/
├── devcontainer.json    # Container configuration
├── setup.sh             # Setup script (aligned with install_dev_tools.sh)
└── README.md            # This file
```

### Environment Variables

```bash
# Go
GOPATH=$HOME/go

# Ruby
GEM_HOME=$HOME/.gem
LC_ALL=en_US.UTF-8
LANG=en_US.UTF-8

# Flutter (via FVM)
FVM_HOME=$HOME/fvm
FLUTTER_ROOT=$HOME/fvm/default
PUB_CACHE=$HOME/.pub-cache

# Android
ANDROID_HOME=/opt/android-sdk
ANDROID_SDK_ROOT=/opt/android-sdk
```

### Mounted Volumes

```
- Workspace: /workspace (bind mount)
- Pub cache: ~/.pub-cache (named volume)
- FVM: ~/fvm (named volume)
```

### Forwarded Ports

```
- 8080:  Development server
- 9000:  Debug port
- 5000:  Additional service
- 42000: Flutter DevTools
```

---

## 🔧 Customization

### Adding More Tools

Edit `.devcontainer/setup.sh`:

```bash
# Add your custom tools here
print_header "Installing custom tools..."
sudo apt-get install -y your-tool
```

### Adding VSCode Extensions

Edit `.devcontainer/devcontainer.json`:

```json
"customizations": {
  "vscode": {
    "extensions": [
      "your.extension-id"
    ]
  }
}
```

### Modifying Environment

Edit `.devcontainer/devcontainer.json`:

```json
"containerEnv": {
  "YOUR_VAR": "your_value"
}
```

---

## 🐛 Troubleshooting

### Issue: Flutter not found

```bash
# Check FVM installation
fvm --version

# Reinstall if needed
dart pub global activate fvm
fvm install stable
fvm global stable
```

### Issue: Pub get fails

```bash
# Clear cache and retry
full-clean
```

### Issue: Build runner fails

```bash
# Clean and regenerate
flutter clean
rm -rf .dart_tool
pub-get
build-gen
```

### Issue: Mason not found

```bash
# Reinstall Mason
dart pub global activate mason_cli
mason get
```

### Issue: Permission denied

```bash
# Fix permissions
sudo chown -R vscode:vscode /workspace
sudo chown -R vscode:vscode ~/.pub-cache
```

---

## 📊 Performance Optimization

### Cache Directories

The following directories are cached for faster rebuilds:

- `~/.pub-cache` (Dart packages)
- `~/fvm` (Flutter SDKs)
- `.dart_tool` (build artifacts)

### Rebuild Container

```bash
# Force rebuild (if setup changed)
# In VS Code:
# 1. Cmd/Ctrl + Shift + P
# 2. "Dev Containers: Rebuild Container"
```

---

## 🎓 For AI Agents: Best Practices

### 1. **Always Verify First**
```bash
verify-setup.sh
```

### 2. **Read Documentation**
```bash
cat AI_AGENT_README.md        # Navigation
cat AI_AGENT_CONTEXT.md       # Architecture
cat AI_AGENT_WORKFLOWS.md     # Workflows
cat AI_AGENT_CHECKLIST.md     # Checklist
```

### 3. **Use Helper Scripts**
```bash
create-feature.sh <name>      # Not: mason make...
quick-fix.sh                  # Not: flutter format && flutter analyze
show-info.sh                  # For project info
```

### 4. **Follow Workflows**
- For creating features: See `AI_AGENT_WORKFLOWS.md` → Workflow 1
- For fixing bugs: See `AI_AGENT_WORKFLOWS.md` → Workflow 3
- For adding APIs: See `AI_AGENT_WORKFLOWS.md` → Workflow 2

### 5. **Verify Before Reporting**
```bash
format         # Format code
analyze        # Check for errors
test           # Run tests (if applicable)
```

---

## 🔗 Related Documentation

### For AI Agents
- **[AI_AGENT_README.md](../AI_AGENT_README.md)** - Start here!
- **[AI_AGENT_CONTEXT.md](../AI_AGENT_CONTEXT.md)** - Architecture context
- **[AI_AGENT_WORKFLOWS.md](../AI_AGENT_WORKFLOWS.md)** - Step-by-step workflows
- **[AI_AGENT_CHECKLIST.md](../AI_AGENT_CHECKLIST.md)** - Quick reference

### For Humans
- **[README.md](../README.md)** - Project overview
- **[ARCHITECTURE.md](../ARCHITECTURE.md)** - Architecture details
- **[IMPLEMENTATION_GUIDE.md](../IMPLEMENTATION_GUIDE.md)** - Tutorial
- **[QUICK_REFERENCE.md](../QUICK_REFERENCE.md)** - Cheat sheet

---

## 📝 Alignment with Local Setup

This devcontainer is aligned with `scripts/install_dev_tools.sh`:

✅ **Same tools**: FVM, Ruby, Go, Melos, Mason, etc.  
✅ **Same environment variables**: FLUTTER_ROOT, GEM_HOME, etc.  
✅ **Same global packages**: Melos, FlutterGen, etc.  
✅ **Same configuration**: Git settings, aliases, etc.

**Difference**: Container uses FVM for Flutter, local may use direct install.

---

## 🎯 Success Metrics

AI Agents should be able to:

- ✅ **Environment ready in <10 minutes** (first build)
- ✅ **Environment ready in <2 minutes** (subsequent builds)
- ✅ **Create feature in <30 minutes**
- ✅ **Fix bugs in <10 minutes**
- ✅ **Generate code without manual intervention**
- ✅ **Access all documentation offline**

---

## 📮 Support

### For Container Issues
1. Check setup output: `cat ~/.ai-agent-info.json`
2. Verify tools: `verify-setup.sh`
3. Check logs: `docker logs <container-id>`

### For Project Issues
1. Read AI Agent documentation
2. Check workflows
3. Use helper scripts

---

## 🎉 Ready to Code!

Your development environment is now fully configured and optimized for AI Agents.

**Next Steps:**
1. ✅ Verify setup: `verify-setup.sh`
2. ✅ Read docs: `cat AI_AGENT_README.md`
3. ✅ Start coding: `create-feature.sh my_feature`

**Happy coding! 🚀**

---

**Last Updated**: 2026-01-11  
**Maintained By**: DanhDue ExOICTIF  
**Aligned With**: `scripts/install_dev_tools.sh`
