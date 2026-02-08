#!/bin/bash
set -e

PACKAGE_NAME=$1

if [ -z "$PACKAGE_NAME" ]; then
  echo "Usage: genFeature.sh <package_name>"
  exit 1
fi

# 1. Generate Translations for the new package only
melos exec --scope="$PACKAGE_NAME" --file-exists="slang.yaml" -- fvm dart run slang

# 2. Build the new package (if it uses build_runner)
melos exec --scope="$PACKAGE_NAME" --depends-on="build_runner" -- fvm flutter pub run build_runner build --delete-conflicting-outputs

# 3. Build Root App (needed for router, injection, etc.)
fvm flutter pub run build_runner build --delete-conflicting-outputs

# 4. Generate Root Assets
fluttergen -c pubspec.yaml

# 5. Formatting & License Headers
melos run dartfmt
melos run add-header-ignore-flags
melos run add-license-header
melos run check-license-header

# 6. Final Analysis
melos run analyze

# 7. Stage all changes
git add .
