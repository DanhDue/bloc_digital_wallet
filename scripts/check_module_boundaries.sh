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
# "_impl.dart"), bypassing <pkg>'s public barrel file. This always fails —
# no whitelist — since no deep-import violations exist today (see the
# barrel-export audit in the source spec). Applies to any target package,
# not just feature packages.
#
# Scan roots: packages/{authentication,onboard,wallet,transaction,trends,
# scanner,settings}/lib/**/*.dart. `platform` and the infra packages (core,
# network, ui_kit, framework, native_security) are exempt from the
# feature-to-feature check (Check 1) — see the epic design doc's CI Gate
# section for why (platform/infra legitimately depend on features or are
# relied on by them). The former `home` package's tab-shell imports of
# wallet/transaction/scanner/trends/settings were relocated to the Host's
# own lib/shell/ (Task 15); `home` no longer exists, so it was never a scan
# root here and needs no exemption of its own.
#
# Usage: ./scripts/check_module_boundaries.sh [packages_dir] [whitelist_file]
#   packages_dir   defaults to <repo_root>/packages
#   whitelist_file defaults to <repo_root>/scripts/module_boundary_whitelist.txt

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

PACKAGES_DIR="${1:-$REPO_ROOT/packages}"
WHITELIST_FILE="${2:-$SCRIPT_DIR/module_boundary_whitelist.txt}"

FEATURE_PACKAGES=(authentication onboard wallet transaction trends scanner settings)

# import 'package:<target>/<rest>'  ->  $1=target  $2=rest-of-path
# (accepts single or double quotes; both are valid Dart import syntax)
IMPORT_REGEX="^import[[:space:]]+[\"']package:([A-Za-z0-9_]+)/([^\"']*)[\"']"

VIOLATIONS=0

# is_feature_package <name> — true if <name> is one of the 7 scanned feature packages.
is_feature_package() {
  local name="$1"
  local candidate
  for candidate in "${FEATURE_PACKAGES[@]}"; do
    [ "$candidate" = "$name" ] && return 0
  done
  return 1
}

# is_whitelisted <entry> — true if "<source>→<target>" is a line in the whitelist file.
is_whitelisted() {
  local entry="$1"
  [ -f "$WHITELIST_FILE" ] || return 1
  grep -Fxq "$entry" "$WHITELIST_FILE"
}

echo "Checking module boundaries..."
echo "  packages dir: $PACKAGES_DIR"
echo "  whitelist:    $WHITELIST_FILE"
echo ""

for feature in "${FEATURE_PACKAGES[@]}"; do
  lib_dir="$PACKAGES_DIR/$feature/lib"
  [ -d "$lib_dir" ] || continue

  while IFS= read -r -d '' file; do
    line_no=0
    while IFS= read -r line || [ -n "$line" ]; do
      line_no=$((line_no + 1))

      [[ "$line" =~ $IMPORT_REGEX ]] || continue
      target="${BASH_REMATCH[1]}"
      rest="${BASH_REMATCH[2]}"

      # Self-import (rare, but not a boundary violation of either kind).
      [ "$target" = "$feature" ] && continue

      if [[ "$rest" == data/* || "$rest" == *_impl.dart ]]; then
        # Check 2: deep-import into another package's internals. Never whitelisted.
        echo "BLOCKED [deep-import] $file:$line_no imports internal 'package:$target/$rest' from outside '$target'"
        VIOLATIONS=$((VIOLATIONS + 1))
      elif is_feature_package "$target"; then
        # Check 1: cross-feature-package import.
        entry="${feature}→${target}"
        if is_whitelisted "$entry"; then
          echo "WARN [whitelisted] $file:$line_no  $entry"
        else
          echo "BLOCKED [cross-feature] $file:$line_no  $entry is not in $WHITELIST_FILE"
          VIOLATIONS=$((VIOLATIONS + 1))
        fi
      fi
      # Else: import of an infra/platform package (or a non-deep import of a
      # feature package that isn't one of the 7 — shouldn't happen) — allowed.
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
