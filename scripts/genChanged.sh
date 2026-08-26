#!/bin/bash
set -e

# Usage: ./scripts/genChanged.sh [ref]
# Example: ./scripts/genChanged.sh main
# Defaults to diffing against "develop" when no ref is given.
#
# Regenerates code only for packages that changed relative to <ref> (plus
# their transitive dependents, via --include-dependents), using
# `melos exec --diff=<ref>`. This makes local iteration fast when you only
# touched one or two packages.
#
# LOCAL-ONLY CONVENIENCE SCRIPT — DO NOT wire this into CI or the
# pre-commit hook. A git diff proves *source* changed; it cannot prove that
# generated output is currently in sync with source. If an earlier commit
# (even one already on develop) changed source without regenerating output,
# no later diff against any ref will ever catch that gap — picking a
# different ref does not close it. `melos genAlls` (unconditional,
# regenerates everything) remains the source of truth used by the
# pre-commit hook and CI. Use this script only as a fast local sanity
# check before running the real thing.

if [ $# -gt 1 ]; then
  echo "Usage: ./scripts/genChanged.sh [ref]"
  echo "Example: ./scripts/genChanged.sh main"
  exit 1
fi

REF=${1:-develop}

echo "🔄 Generating packages changed vs. '$REF' (including dependents)"

# 1. Generate translations (if slang.yaml exists) for changed packages
echo "📝 Step 1/3: Generating translations..."
melos exec --diff="$REF" --include-dependents --file-exists="slang.yaml" -- fvm dart run slang || true

# 2. Run build_runner (freezed, retrofit, etc.) for changed packages
echo "🏗️  Step 2/3: Running build_runner..."
melos exec --diff="$REF" --include-dependents -- fvm flutter pub run build_runner build --delete-conflicting-outputs

# 3. Format changed packages
echo "✨ Step 3/3: Formatting..."
melos exec --diff="$REF" --include-dependents -- dart format lib -l 99

echo "✅ Done generating packages changed vs. '$REF'"
