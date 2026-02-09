#!/bin/bash
set -e

# Usage: ./scripts/genFeature.sh <package_name>
# Example: ./scripts/genFeature.sh wallet

PACKAGE_NAME=${1:-}

if [ -z "$PACKAGE_NAME" ]; then
  echo "Usage: ./scripts/genFeature.sh <package_name>"
  echo "Example: ./scripts/genFeature.sh wallet"
  exit 1
fi

echo "🔄 Generating for package: $PACKAGE_NAME"

# 1. Generate translations (if slang.yaml exists)
echo "📝 Step 1/3: Generating translations..."
melos exec --scope="$PACKAGE_NAME" --file-exists="slang.yaml" -- fvm dart run slang || true

# 2. Run build_runner (freezed, retrofit, etc.)
echo "🏗️  Step 2/3: Running build_runner..."
melos exec --scope="$PACKAGE_NAME" -- fvm flutter pub run build_runner build --delete-conflicting-outputs

# 3. Format
echo "✨ Step 3/3: Formatting..."
melos exec --scope="$PACKAGE_NAME" -- dart format lib -l 99

echo "✅ Done generating for package: $PACKAGE_NAME"
