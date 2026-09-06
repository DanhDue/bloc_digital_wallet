#!/bin/bash
set -e

# 0. Generate Translations
melos exec --file-exists="slang.yaml" -- fvm dart run slang
fvm dart run slang

# 1. Build UI Kit (Assets)
melos exec --scope="ui_kit" -- fvm flutter pub run build_runner build --delete-conflicting-outputs

# 2. Build other packages (only those with build_runner, excluding ui_kit)
melos exec --concurrency=1 --depends-on="build_runner" --ignore="ui_kit" -- fvm flutter pub run build_runner build --delete-conflicting-outputs

# 3. Build Root App
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
