#!/bin/bash
set -e

# 0. Generate Translations
melos exec --file-exists="slang.yaml" -- fvm dart run slang

# 1. Build UI Kit (Assets)
melos exec --scope="ui_kit" -- fvm flutter pub run build_runner build --delete-conflicting-outputs

# 2. Build other packages (only those with build_runner, excluding ui_kit)
melos exec --depends-on="build_runner" --ignore="ui_kit" -- fvm flutter pub run build_runner build --delete-conflicting-outputs

# 3. Build Root App
fvm dart run build_runner build -d
fluttergen -c pubspec.yaml
melos run dartfmt
melos run add-header-ignore-flags
melos run add-license-header
melos run check-license-header
git add .
