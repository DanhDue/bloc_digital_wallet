#!/usr/bin/env bash
# Bootstrap a freshly created git worktree so it can actually build/run
# this project. Run from the REPO ROOT (the main checkout, not the new
# worktree), after using-git-worktrees has created the worktree.
#
# This project uses Swift Package Manager, not CocoaPods, so there is no
# `pod install` step -- SPM resolves automatically on the first iOS build.
#
# Usage: bootstrap_worktree.sh <worktree_path>
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <worktree_path>" >&2
  exit 1
fi

WORKTREE_PATH="$1"
REPO_ROOT="$(git rev-parse --show-toplevel)"

if [ ! -d "$WORKTREE_PATH" ]; then
  echo "Worktree path does not exist: $WORKTREE_PATH" >&2
  exit 1
fi

if [ ! -d "$REPO_ROOT/secureFiles" ]; then
  echo "secureFiles/ not found at $REPO_ROOT/secureFiles -- run the check_secure_files skill first" >&2
  exit 1
fi

echo "Copying secureFiles/ into worktree (untracked, so 'git worktree add' does not bring it along)..."
cp -R "$REPO_ROOT/secureFiles" "$WORKTREE_PATH/secureFiles"

echo "Placing platform config via copy_secure_configurations..."
(cd "$WORKTREE_PATH" && sh .agent/skills/copy_secure_configurations/resources/scripts/copy_secure_files.sh)

echo "Running melos bootstrap (fast: ~/.pub-cache is global and already warm)..."
(cd "$WORKTREE_PATH" && melos bootstrap)

echo "Worktree bootstrap complete at $WORKTREE_PATH"
echo "Note: no 'pod install' needed (Swift Package Manager, not CocoaPods)."
echo "The first iOS build here will resolve SPM packages automatically (one-time cost)."
