#!/bin/bash
set -e

# scripts/check_module_boundaries.sh
#
# CI Gate: hard-blocks any NEW cross-feature-package import or internal
# deep-import while letting the known, pre-existing violations listed in
# scripts/module_boundary_whitelist.txt through (with a logged warning).
#
# Check 1 — cross-feature import: a file inside one feature package's lib/
# directly imports another feature package
# (import 'package:<other-feature>/...'). Only "<source>→<target>" pairs
# listed in the whitelist are allowed through; anything else fails the build.
#
# Check 2 — deep-import: a file outside package <pkg> imports one of <pkg>'s
# internals (import 'package:<pkg>/data/...' or any path ending in
# "_impl.dart"), bypassing <pkg>'s public barrel file. This always fails.
#
# Scan roots: features/*/lib/**/*.dart.
#
# Usage: ./scripts/check_module_boundaries.sh [features_dir] [whitelist_file]
#   features_dir   defaults to <repo_root>/features
#   whitelist_file defaults to <repo_root>/scripts/module_boundary_whitelist.txt

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

FEATURES_DIR="${1:-$REPO_ROOT/features}"
WHITELIST_FILE="${2:-$SCRIPT_DIR/module_boundary_whitelist.txt}"

FEATURE_PACKAGES=()
if [ -d "$FEATURES_DIR" ]; then
  for dir in "$FEATURES_DIR"/*; do
    if [ -d "$dir" ] && [ -f "$dir/pubspec.yaml" ]; then
      FEATURE_PACKAGES+=("$(basename "$dir")")
    fi
  done
fi

IMPORT_REGEX="^import[[:space:]]+[\"']package:([A-Za-z0-9_]+)/([^\"']*)[\"']"
VIOLATIONS=0

is_feature_package() {
  local name="$1"
  local candidate
  for candidate in "${FEATURE_PACKAGES[@]}"; do
    [ "$candidate" = "$name" ] && return 0
  done
  return 1
}

is_whitelisted() {
  local entry="$1"
  [ -f "$WHITELIST_FILE" ] || return 1
  grep -Fxq "$entry" "$WHITELIST_FILE"
}

echo "Checking module boundaries..."
echo "  features dir: $FEATURES_DIR"
echo "  features detected: ${FEATURE_PACKAGES[*]}"
echo "  whitelist:    $WHITELIST_FILE"
echo ""

for feature in "${FEATURE_PACKAGES[@]}"; do
  lib_dir="$FEATURES_DIR/$feature/lib"
  [ -d "$lib_dir" ] || continue

  while IFS= read -r -d '' file; do
    line_no=0
    while IFS= read -r line || [ -n "$line" ]; do
      line_no=$((line_no + 1))

      [[ "$line" =~ $IMPORT_REGEX ]] || continue
      target="${BASH_REMATCH[1]}"
      rest="${BASH_REMATCH[2]}"

      [ "$target" = "$feature" ] && continue

      if [[ "$rest" == data/* || "$rest" == *_impl.dart ]]; then
        echo "BLOCKED [deep-import] $file:$line_no imports internal 'package:$target/$rest' from outside '$target'"
        VIOLATIONS=$((VIOLATIONS + 1))
      elif is_feature_package "$target"; then
        entry="${feature}→${target}"
        if is_whitelisted "$entry"; then
          echo "WARN [whitelisted] $file:$line_no  $entry"
        else
          echo "BLOCKED [cross-feature] $file:$line_no  $entry is not in $WHITELIST_FILE"
          VIOLATIONS=$((VIOLATIONS + 1))
        fi
      fi
    done < "$file"
  done < <(find "$lib_dir" -type f -name "*.dart" -print0)
done

echo ""
if [ "$VIOLATIONS" -gt 0 ]; then
  echo "Module boundary check FAILED: $VIOLATIONS violation(s) found."
  exit 1
fi

echo "Module boundary check passed."
exit 0
