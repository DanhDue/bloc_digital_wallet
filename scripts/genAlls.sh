#!/bin/bash
set -e

fvm dart run build_runner build -d
fluttergen -c pubspec.yaml
melos run dartfmt
melos run add-header-ignore-flags
melos run add-license-header
melos run check-license-header
git add .
