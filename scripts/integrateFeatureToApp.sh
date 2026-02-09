#!/bin/bash
set -e

PACKAGE_NAME=$1

if [ -z "$PACKAGE_NAME" ]; then
  echo "Usage: genFeature.sh <package_name>"
  exit 1
fi

# 1. Generate package code (translations, build_runner, format)
./scripts/genFeature.sh "$PACKAGE_NAME"

# 2. Build Root App (needed for router, injection, etc.)
fvm flutter pub run build_runner build --delete-conflicting-outputs

# 3. Generate Root Assets
fluttergen -c pubspec.yaml

# 4. Formatting & License Headers
melos run dartfmt
melos run add-header-ignore-flags
melos run add-license-header
melos run check-license-header

# 5. Final Analysis
melos run analyze

# 6. Stage all changes
git add .
