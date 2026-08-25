#!/usr/bin/env bash
# Validates bootstrap_worktree.sh's argument/precondition checks without
# actually running melos/copy_secure_configurations (those are exercised
# for real in Task 4's end-to-end dry run).
#
# Run: bash .agent/skills/epic-implementation/resources/scripts/test_bootstrap_worktree_validation.sh
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT="$SCRIPT_DIR/bootstrap_worktree.sh"
FAILURES=0

check() {
  local description="$1"
  local expected_substring="$2"
  shift 2
  local output
  output="$("$@" 2>&1)"
  local status=$?
  if [ "$status" -eq 0 ]; then
    echo "FAIL: $description -- expected non-zero exit, got 0"
    FAILURES=$((FAILURES + 1))
    return
  fi
  if ! grep -q "$expected_substring" <<<"$output"; then
    echo "FAIL: $description -- expected output to contain '$expected_substring', got: $output"
    FAILURES=$((FAILURES + 1))
    return
  fi
  echo "PASS: $description"
}

check "no arguments" "Usage:" "$SCRIPT"
check "nonexistent worktree path" "does not exist" "$SCRIPT" "/tmp/definitely-does-not-exist-xyz-$$"

if [ "$FAILURES" -ne 0 ]; then
  echo "$FAILURES check(s) failed"
  exit 1
fi
echo "All checks passed"
