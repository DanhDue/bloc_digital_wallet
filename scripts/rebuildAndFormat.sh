#!/bin/bash
set -e

# Usage: ./scripts/genRoot.sh
# Regenerates root app: build_runner + format

echo "🏗️  Step 1/2: Running build_runner on root app..."
fvm flutter pub run build_runner build --delete-conflicting-outputs

echo "✨ Step 2/2: Formatting root app..."
fvm dart format lib/ -l 99

echo "✅ Done generating root app!"
