#!/bin/bash
# Shared ignore patterns for addlicense commands
# If you add here another --ignore flag, it will be applied to all addlicense commands

# Base ignore patterns (one pattern per line for readability)
IGNORE_PATTERNS=(
  ".dart_tool/**"
  "build/**"
  "builds/**"
  "android/**"
  "ios/**"
  ".agent/**"
  "docs/**"
  ".*/**"
  "**/.*/**"
  "**/*.yml"
  "**/*.yaml"
  "**/*.xml"
  "**/*.g.dart"
  "**/*.gen.dart"
  "**/*.freezed.dart"
  "**/*.tailor.dart"
  "**/*.mocks.dart"
  "**/generated/**"
  "**/*.sh"
  "**/*.html"
  "**/*.js"
  "**/*.ts"
  "**/*.g.h"
  "**/*.g.m"
  "**/*.rb"
  "**/*.txt"
  "**/*.cmake"
  "**/Runner/AppDelegate.swift"
  "**/Runner/MainFlutterWindow.swift"
  "**/Runner/Runner-Bridging-Header.h"
  "**/Runner/AppDelegate.h"
  "**/Runner/AppDelegate.m"
  "**/Runner/main.m"
  "**/MainActivity.kt"
  "**/MainActivity.java"
  "**/FlutterMultiDexApplication.java"
  "**/GeneratedPluginRegistrant.swift"
  "**/Pods/**"
  "**/*.gradle"
  "**/*.gradle.kts"
)

# Build the ignore pattern string
ADDLICENSE_IGNORE_PATTERNS=""
for pattern in "${IGNORE_PATTERNS[@]}"; do
  ADDLICENSE_IGNORE_PATTERNS="$ADDLICENSE_IGNORE_PATTERNS --ignore \"$pattern\""
done

# Additional patterns for test exclusion
IGNORE_PATTERNS_TEST=(
  "test/**"
)

ADDLICENSE_IGNORE_PATTERNS_WITH_TEST="$ADDLICENSE_IGNORE_PATTERNS"
for pattern in "${IGNORE_PATTERNS_TEST[@]}"; do
  ADDLICENSE_IGNORE_PATTERNS_WITH_TEST="$ADDLICENSE_IGNORE_PATTERNS_WITH_TEST --ignore \"$pattern\""
done

# Additional patterns for repository and controller files
IGNORE_PATTERNS_REPOS=(
  "**/*_controller.dart"
  "**/*_repository_impl.dart"
  "**/*_repository.dart"
)

ADDLICENSE_IGNORE_PATTERNS_WITH_REPOS="$ADDLICENSE_IGNORE_PATTERNS"
for pattern in "${IGNORE_PATTERNS_REPOS[@]}"; do
  ADDLICENSE_IGNORE_PATTERNS_WITH_REPOS="$ADDLICENSE_IGNORE_PATTERNS_WITH_REPOS --ignore \"$pattern\""
done

