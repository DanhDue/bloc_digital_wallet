#!/bin/bash

# Setup script for Flutter development container
# Optimized for AI Agents working on bloc_digital_wallet
# Aligned with scripts/install_dev_tools.sh

set -e

echo "🚀 Setting up Flutter Development Environment for AI Agents..."

# Ensure FVM, Pub Cache, and rbenv are in PATH (Critical for portability)
export PATH="$HOME/.rbenv/bin:$HOME/.rbenv/shims:$HOME/.pub-cache/bin:$HOME/fvm/bin:$HOME/fvm/default/bin:$PATH"
export FLUTTER_ROOT="$HOME/fvm/default"
export PUB_CACHE="$HOME/.pub-cache"

# Initialize rbenv if present
if command -v rbenv &> /dev/null; then
    eval "$(rbenv init - bash)"
fi


# Detect Project Root (defaults to /workspace if not found)
if [ -f "pubspec.yaml" ]; then
    WORKSPACE_DIR="$PWD"
elif [ -f "../pubspec.yaml" ]; then
    WORKSPACE_DIR="$(cd .. && pwd)"
else
    WORKSPACE_DIR="/workspace"
fi

echo "📂 Project root: $WORKSPACE_DIR"
cd "$WORKSPACE_DIR"


# ============================================
# 0. Handle Secret Environment Variables
# ============================================
if [ ! -z "$SECURE_FILES" ]; then
    echo "🔑 SECURE_FILES detected. Provisioning secrets..."
    # Use the script directly or inline logic for speed
    echo "$SECURE_FILES" | base64 -d | tar -xz || echo "⚠️  Failed to decode SECURE_FILES"
fi

# Verification of secureFiles
if [ -d "secureFiles" ]; then
    echo "✅ secureFiles directory exists."
    ls -R secureFiles
else
    echo "❌ secureFiles directory MISSING. Secrets may not be configured correctly."
fi

# Color codes for output
GREEN='\033[0;32m'
GREEN_BOLD='\033[1;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color
RESET_FORMATING='\033[0m'

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_header() {
    echo -e "\n${GREEN_BOLD}▶ $1${RESET_FORMATING}"
}

# ============================================
# 1. Update system and install base tools
# ============================================
print_header "Installing system dependencies..."
sudo apt-get update
sudo apt-get install -y \
    curl \
    wget \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    openjdk-17-jdk \
    build-essential \
    libssl-dev \
    libffi-dev \
    libyaml-dev \
    libreadline-dev \
    zlib1g-dev \
    libgmp-dev \
    libncurses5-dev \
    jq \
    nano
print_success "System dependencies installed"

# ============================================
# 2. Configure Git (aligned with install_dev_tools.sh)
# ============================================
print_header "Configuring Git..."
git config --global --add safe.directory "$WORKSPACE_DIR"
git config --global --replace-all core.pager "less -F -X"
git config --global core.editor "nano"
print_success "Git configured"

# ============================================
# 3. Set up environment variables
# ============================================
print_header "Setting up environment variables..."

# Create profile configuration
cat >> ~/.bashrc << 'EOF'

# ============================================
# Environment Variables (from install_dev_tools.sh)
# ============================================

# Go settings
export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

# Ruby/Gem settings
export GEM_HOME=$HOME/.gem
export PATH=$GEM_HOME/bin:$PATH
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Flutter Settings (using FVM)
export FVM_HOME=$HOME/fvm
export PATH=$HOME/fvm/default/bin:$PATH
export PATH="$PATH":"$HOME/.pub-cache/bin"
export FLUTTER_ROOT=$HOME/fvm/default
export PATH=$FLUTTER_ROOT/bin:$PATH

# Android SDK
export ANDROID_HOME=/opt/android-sdk
export ANDROID_SDK_ROOT=/opt/android-sdk
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/platform-tools

# Pub cache
export PUB_CACHE=$HOME/.pub-cache

EOF

# Source the configuration
source ~/.bashrc
print_success "Environment variables configured"

# ============================================
# 4. Install Go tools (from install_dev_tools.sh)
# ============================================
print_header "Installing Go tools..."
if command -v go &> /dev/null; then
    print_status "Installing addlicense..."
    go install github.com/google/addlicense@latest
    print_success "addlicense installed"
else
    print_warning "Go not found, skipping addlicense"
fi

# ============================================
# 5. Install rbenv and Ruby (from install_dev_tools.sh)
# ============================================
print_header "Setting up Ruby environment..."
if [ ! -d "$HOME/.rbenv" ]; then
    print_status "Installing rbenv..."
    curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash
    
    # Add rbenv to bash
    cat >> ~/.bashrc << 'EOF'
# rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init - bash)"
EOF
    
    source ~/.bashrc
    eval "$(rbenv init - bash)"
    print_success "rbenv installed"
else
    print_status "rbenv already installed"
fi

# Install Ruby 3.4.x
print_status "Installing Ruby 3.4.4..."
if command -v rbenv &> /dev/null; then
    rbenv install 3.4.4 -s || print_warning "Ruby 3.4.4 installation skipped"
    rbenv global 3.4.4
    ruby -v
    print_success "Ruby configured"
fi

# ============================================
# 6. Install FVM (Flutter Version Manager)
# ============================================
print_header "Installing FVM..."
if [ ! -d "$HOME/fvm" ]; then
    print_status "Installing FVM..."
    
    # Install FVM via official script (if somehow missing)
    curl -fsSL https://fvm.app/install.sh | bash
    
    # Set up FVM directory
    mkdir -p $HOME/fvm
    
    # Install Flutter via FVM (using stable channel)
    fvm install stable
    fvm global stable
    
    print_success "FVM and Flutter installed"
else
    print_status "FVM already installed"
fi

# Verify Flutter installation
print_status "Verifying Flutter installation..."
fvm flutter --version || print_warning "Flutter verification had issues"

# ============================================
# 7. Install Dart global packages (from install_dev_tools.sh)
# ============================================
print_header "Installing Dart global packages..."

# Install Melos
print_status "Installing Melos..."
fvm flutter pub global activate melos || fvm flutter pub global activate melos
print_success "Melos installed"

# Install FlutterGen
print_status "Installing FlutterGen..."
fvm flutter pub global activate flutter_gen
print_success "FlutterGen installed"

# Install Mason
print_status "Installing Mason..."
fvm flutter pub global activate mason_cli
print_success "Mason installed"

# Install flutterfire_cli (from install_dev_tools.sh)
print_status "Installing flutterfire_cli..."
fvm flutter pub global activate flutterfire_cli
print_success "flutterfire_cli installed"

# ============================================
# 8. Install Ruby gems (from install_dev_tools.sh)
# ============================================
print_header "Installing Ruby gems..."

if command -v gem &> /dev/null; then
    # Install bundler
    print_status "Installing bundler..."
    gem install bundler
    print_success "bundler installed"
    
    # Install cocoapods (for iOS)
    print_status "Installing cocoapods..."
    gem install cocoapods
    print_success "cocoapods installed"
else
    print_warning "gem command not found, skipping Ruby gems"
fi

# ============================================
# 9. Get project dependencies
# ============================================
print_header "Installing project dependencies..."

cd "$WORKSPACE_DIR"

# Flutter pub get
print_status "Running flutter pub get..."
fvm flutter pub get
print_success "Flutter dependencies installed"

# Get Mason bricks
print_status "Getting Mason bricks..."
mason get
print_success "Mason bricks installed"

# ============================================
# 10. Run code generation
# ============================================
print_header "Running code generation..."
fvm flutter pub run build_runner build --delete-conflicting-outputs || print_warning "Code generation may have warnings"
print_success "Code generation complete"

# ============================================
# 11. Install additional tools for AI Agents
# ============================================
print_header "Installing additional AI Agent tools..."

# Install yq for YAML parsing
if ! command -v yq &> /dev/null; then
    print_status "Installing yq..."
    sudo wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
    sudo chmod +x /usr/local/bin/yq
    print_success "yq installed"
fi

# ============================================
# 12. Set up helpful aliases for AI Agents
# ============================================
print_header "Setting up helpful aliases..."
cat >> ~/.bashrc << 'EOF'

# ============================================
# AI Agent Helpful Aliases
# ============================================

# Secrets verification
alias verify-secrets='ls -R $WORKSPACE_DIR/secureFiles'

export WORKSPACE_DIR="$WORKSPACE_DIR"

# Flutter commands (using FVM)
alias flutter='fvm flutter'
alias dart='fvm dart'
alias pub-get='fvm flutter pub get'
alias pub-upgrade='fvm flutter pub upgrade'
alias build-gen='fvm flutter pub run build_runner build --delete-conflicting-outputs'
alias build-watch='fvm flutter pub run build_runner watch --delete-conflicting-outputs'
alias format='fvm flutter format .'
alias analyze='fvm flutter analyze'
alias test='fvm flutter test'
alias clean='fvm flutter clean && fvm flutter pub get'
alias doctor='fvm flutter doctor -v'

# Mason aliases
alias mason-get='mason get'
alias mason-list='mason list'
alias mason-feature='mason make mvi_feature'

# Melos aliases
alias melos-bs='melos bootstrap'
alias melos-clean='melos clean'
alias melos-test='melos test'
alias melos-format='melos dartfmt'

# Quick navigation
alias goto-features='cd $WORKSPACE_DIR/lib/features'
alias goto-core='cd $WORKSPACE_DIR/lib/core'
alias goto-docs='cd $WORKSPACE_DIR'
alias goto-scripts='cd $WORKSPACE_DIR/scripts'

# Project info
alias project-info='cat $WORKSPACE_DIR/AI_AGENT_README.md'
alias show-workflows='cat $WORKSPACE_DIR/AI_AGENT_WORKFLOWS.md'
alias show-context='cat $WORKSPACE_DIR/AI_AGENT_CONTEXT.md'
alias show-checklist='cat $WORKSPACE_DIR/AI_AGENT_CHECKLIST.md'

# Quick commands
alias quick-fix='fvm flutter format . && fvm flutter analyze'
alias full-clean='fvm flutter clean && rm -rf .dart_tool && rm -rf build && fvm flutter pub get'
alias gen-all='fvm flutter pub run build_runner build --delete-conflicting-outputs && fvm flutter pub get'

EOF
print_success "Aliases configured"

# ============================================
# 13. Create AI Agent helper scripts
# ============================================
print_header "Setting up AI Agent helper scripts..."
mkdir -p ~/.ai-agent-helpers

# Create quick feature creation script
cat > ~/.ai-agent-helpers/create-feature.sh << 'EOF'
#!/bin/bash
if [ -z "$1" ]; then
    echo "Usage: create-feature <feature_name>"
    exit 1
fi
echo "🚀 Creating feature: $1"
cd /workspace
mason make mvi_feature --feature_name "$1"
echo "⚙️  Running code generation..."
fvm flutter pub run build_runner build --delete-conflicting-outputs
echo "✨ Formatting code..."
fvm flutter format .
echo "✅ Feature '$1' created successfully!"
echo ""
echo "📁 Location: /workspace/lib/features/$1"
echo "📖 Next: Update domain entities and implement data sources"
EOF
chmod +x ~/.ai-agent-helpers/create-feature.sh

# Create quick fix script
cat > ~/.ai-agent-helpers/quick-fix.sh << 'EOF'
#!/bin/bash
echo "🔧 Running quick fixes..."
cd /workspace
echo "✨ Formatting..."
fvm flutter format .
echo "🔍 Analyzing..."
fvm flutter analyze
echo "✅ Quick fixes complete!"
EOF
chmod +x ~/.ai-agent-helpers/quick-fix.sh

# Create project info script
cat > ~/.ai-agent-helpers/show-info.sh << 'EOF'
#!/bin/bash
echo "========================================"
echo "  bloc_digital_wallet - Project Info"
echo "========================================"
echo ""
echo "📚 Documentation for AI Agents:"
echo "  - AI_AGENT_README.md      (Start here!)"
echo "  - AI_AGENT_CONTEXT.md     (Architecture & patterns)"
echo "  - AI_AGENT_WORKFLOWS.md   (Step-by-step workflows)"
echo "  - AI_AGENT_CHECKLIST.md   (Quick reference)"
echo ""
echo "🏗️  Architecture: Clean Architecture + MVI"
echo "📱 Framework: Flutter (via FVM)"
echo "🎯 State Management: flutter_bloc"
echo "🔧 Tools: FVM, Mason, Melos, build_runner"
echo ""
echo "📦 Installed Tools:"
fvm flutter --version 2>/dev/null | head -1 || echo "  Flutter: checking..."
dart --version 2>&1 | head -1 || echo "  Dart: checking..."
mason --version 2>/dev/null || echo "  Mason: checking..."
melos --version 2>/dev/null || echo "  Melos: checking..."
ruby -v 2>/dev/null | head -1 || echo "  Ruby: not available"
go version 2>/dev/null || echo "  Go: not available"
echo ""
echo "🔧 Quick Commands:"
echo "  create-feature <name>  - Create new feature with Mason"
echo "  build-gen             - Run build_runner code generation"
echo "  format                - Format all Dart code"
echo "  analyze               - Analyze code for issues"
echo "  quick-fix             - Format + Analyze"
echo "  doctor                - Run flutter doctor"
echo ""
echo "🎯 Aliases available:"
echo "  flutter, dart, pub-get, pub-upgrade, build-gen,"
echo "  format, analyze, test, clean, doctor,"
echo "  mason-get, mason-list, mason-feature,"
echo "  melos-bs, melos-clean, melos-test,"
echo "  goto-features, goto-core, goto-docs"
echo ""
echo "📖 Read documentation:"
echo "  project-info    - This info"
echo "  show-workflows  - Available workflows"
echo "  show-context    - Architecture context"
echo "  show-checklist  - Quick checklist"
echo ""
EOF
chmod +x ~/.ai-agent-helpers/show-info.sh

# Create full setup verification script
cat > ~/.ai-agent-helpers/verify-setup.sh << 'EOF'
#!/bin/bash
echo "🔍 Verifying Development Environment..."
echo ""

check_command() {
    if command -v $1 &> /dev/null; then
        echo "✅ $1: $(command -v $1)"
        if [ ! -z "$2" ]; then
            $2
        fi
    else
        echo "❌ $1: NOT FOUND"
    fi
}

echo "📦 Core Tools:"
check_command "git" "git --version"
check_command "fvm" "fvm --version"
check_command "flutter" "fvm flutter --version | head -1"
check_command "dart" "dart --version | head -1"
check_command "go" "go version"
check_command "ruby" "ruby -v"
echo ""

echo "🔧 Dart Global Tools:"
check_command "mason"
check_command "melos"
check_command "flutter_gen"
check_command "flutterfire"
echo ""

echo "💎 Ruby Gems:"
check_command "bundle"
check_command "pod"
echo ""

echo "📝 Additional Tools:"
check_command "jq"
check_command "yq"
check_command "addlicense"
echo ""

echo "📁 Project Status:"
if [ -f "$WORKSPACE_DIR/pubspec.yaml" ]; then
    echo "✅ Project found: $WORKSPACE_DIR"
    cd "$WORKSPACE_DIR"
    echo "📦 Dependencies status:"
    if [ -d ".dart_tool" ]; then
        echo "   ✅ .dart_tool exists"
    else
        echo "   ⚠️  .dart_tool missing (run: pub-get)"
    fi
    if [ -d "build" ]; then
        echo "   ✅ build directory exists"
    fi
    if [ -f "pubspec.lock" ]; then
        echo "   ✅ pubspec.lock exists"
    fi
else
    echo "❌ Project not found at $WORKSPACE_DIR"
fi
echo ""

echo "🎯 Ready to code!"
EOF
chmod +x ~/.ai-agent-helpers/verify-setup.sh

# Add helpers to PATH
echo 'export PATH="$PATH:$HOME/.ai-agent-helpers"' >> ~/.bashrc

print_success "Helper scripts installed"

# ============================================
# 14. Display project structure for AI Agents
# ============================================
print_header "Generating project structure reference..."
cat > ~/.ai-agent-helpers/project-structure.txt << 'EOF'
bloc_digital_wallet/
├── .devcontainer/              # Dev container configuration
├── android/                    # Android native code
├── ios/                        # iOS native code
├── lib/
│   ├── core/                   # Shared code
│   │   ├── architecture/       # MVI base classes
│   │   │   ├── mvi_base.dart
│   │   │   ├── mvi_bloc.dart
│   │   │   └── architecture.dart
│   │   ├── errors/            # Failures & exceptions
│   │   ├── network/           # API clients (Dio)
│   │   ├── storage/           # Local storage
│   │   └── utils/             # Helpers
│   ├── features/              # Feature modules
│   │   └── {feature}/
│   │       ├── data/
│   │       │   ├── datasources/
│   │       │   ├── models/
│   │       │   └── repositories/
│   │       ├── domain/
│   │       │   ├── entities/
│   │       │   ├── repositories/
│   │       │   └── usecases/
│   │       └── presentation/
│   │           ├── mvi/
│   │           ├── pages/
│   │           └── widgets/
│   ├── di/                    # Dependency injection
│   ├── generated/             # Generated code
│   └── main.dart
├── test/                      # Tests
├── scripts/                   # Build & utility scripts
├── bricks/                    # Mason templates
│   └── mvi_feature/
├── docs/                      # Documentation
│
├── AI_AGENT_README.md         # AI Agent entry point
├── AI_AGENT_CONTEXT.md        # Complete context
├── AI_AGENT_WORKFLOWS.md      # Workflows
├── AI_AGENT_CHECKLIST.md      # Quick reference
├── ARCHITECTURE.md            # Architecture details
├── IMPLEMENTATION_GUIDE.md    # Tutorial
└── QUICK_REFERENCE.md         # Cheat sheet

Key Files:
- pubspec.yaml                 # Dependencies
- mason.yaml                   # Mason configuration
- melos.yaml                   # Workspace configuration
- analysis_options.yaml        # Linter rules
EOF

print_success "Project structure documented"

# ============================================
# 15. Create workspace info for AI Agents
# ============================================
print_header "Creating AI Agent workspace metadata..."
cat > ~/.ai-agent-info.json << EOF
{
  "project": "bloc_digital_wallet",
  "architecture": "Clean Architecture + MVI",
  "framework": "Flutter",
  "flutter_manager": "FVM",
  "state_management": "flutter_bloc",
  "code_generation": ["mason", "build_runner", "freezed", "injectable"],
  "package_manager": "melos",
  "tools": {
    "fvm": true,
    "mason": true,
    "melos": true,
    "flutter_gen": true,
    "flutterfire_cli": true,
    "addlicense": true,
    "ruby": true,
    "cocoapods": true
  },
  "documentation": {
    "entry_point": "AI_AGENT_README.md",
    "context": "AI_AGENT_CONTEXT.md",
    "workflows": "AI_AGENT_WORKFLOWS.md",
    "checklist": "AI_AGENT_CHECKLIST.md",
    "architecture": "ARCHITECTURE.md",
    "tutorial": "IMPLEMENTATION_GUIDE.md",
    "quick_ref": "QUICK_REFERENCE.md"
  },
  "quick_commands": {
    "create_feature": "mason make mvi_feature --feature_name <name>",
    "code_gen": "fvm flutter pub run build_runner build --delete-conflicting-outputs",
    "format": "fvm flutter format .",
    "analyze": "fvm flutter analyze",
    "test": "fvm flutter test",
    "pub_get": "fvm flutter pub get",
    "clean": "fvm flutter clean && fvm flutter pub get"
  },
  "helper_scripts": {
    "create-feature.sh": "Create new feature with Mason",
    "quick-fix.sh": "Format and analyze code",
    "show-info.sh": "Display project information",
    "verify-setup.sh": "Verify environment setup"
  },
  "setup_complete": true,
  "setup_date": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "aligned_with": "scripts/install_dev_tools.sh"
}
EOF

print_success "AI Agent workspace metadata created"

# ============================================
# 16. Run Flutter doctor
# ============================================
print_header "Running Flutter doctor..."
fvm flutter doctor -v || print_warning "Flutter doctor found issues (may be expected in container)"

# ============================================
# 17. Verify installations
# ============================================
print_header "Verifying installations..."
echo ""
echo "Flutter:"
fvm flutter --version
echo ""
echo "Dart:"
dart --version
echo ""
echo "Mason:"
mason --version
echo ""
echo "Melos:"
melos --version || echo "Melos verification skipped"
echo ""
echo "Ruby:"
ruby -v
echo ""
echo "Go:"
go version
echo ""

# ============================================
# 18. Final setup and welcome message
# ============================================

# Source bashrc to apply all changes
source ~/.bashrc 2>/dev/null || true
if command -v rbenv &> /dev/null; then
    eval "$(rbenv init - bash)"
fi

echo ""
echo "========================================"
echo -e "${GREEN_BOLD}  ✅ Setup Complete!${RESET_FORMATING}"
echo "========================================"
echo ""
echo "🎉 Environment is ready for AI Agents!"
echo ""
echo "📚 Quick Start for AI Agents:"
echo "  1. Read: cat AI_AGENT_README.md"
echo "  2. Context: cat AI_AGENT_CONTEXT.md"
echo "  3. Verify: verify-setup.sh"
echo "  4. Info: show-info.sh"
echo ""
echo "🔧 Essential Commands:"
echo "  create-feature <name>  - Create new feature"
echo "  quick-fix              - Format + Analyze"
echo "  build-gen              - Run code generation"
echo "  doctor                 - Check Flutter setup"
echo "  verify-setup.sh        - Verify all tools"
echo ""
echo "📖 Documentation:"
echo "  AI_AGENT_README.md      - Start here (navigation)"
echo "  AI_AGENT_CONTEXT.md     - Architecture & patterns"
echo "  AI_AGENT_WORKFLOWS.md   - Step-by-step workflows"
echo "  AI_AGENT_CHECKLIST.md   - Quick reference"
echo ""
echo "🛠️  Tools Installed:"
echo "  ✅ FVM + Flutter"
echo "  ✅ Dart global packages (Mason, Melos, FlutterGen, etc.)"
echo "  ✅ Ruby + gems (bundler, cocoapods)"
echo "  ✅ Go + addlicense"
echo "  ✅ AI Agent helper scripts"
echo ""
echo "📁 Helper Scripts Location:"
echo "  ~/.ai-agent-helpers/"
echo ""
echo "🚀 Ready to code!"
echo ""
echo -e "\033[7;32m                                       \033[0m"
echo -e "\033[7;32m Dev Environment Ready for AI Agents!  \033[0m"
echo -e "\033[7;32m                                       \033[0m"
echo ""

print_success "Setup script completed successfully!"
