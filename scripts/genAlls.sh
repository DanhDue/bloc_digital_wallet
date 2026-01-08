#!/bin/bash
set -e

fvm dart run build_runner build -d
fluttergen -c pubspec.yaml
get generate locales assets/locales
melos dartfmt
melos add-header-ignore-flags
melos add-license-header
melos check-license-header
git add .
