#!/usr/bin/env bash
# Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
RENAME_SCRIPT="$REPO_ROOT/scripts/rename_project.sh"

PASSED_COUNT=0
FAILED_COUNT=0

assert_equals() {
  local expected="$1"
  local actual="$2"
  local test_name="$3"

  if [[ "$expected" == "$actual" ]]; then
    echo "  [PASS] $test_name"
    PASSED_COUNT=$((PASSED_COUNT + 1))
  else
    echo "  [FAIL] $test_name: expected '$expected', got '$actual'"
    FAILED_COUNT=$((FAILED_COUNT + 1))
  fi
}

assert_contains() {
  local haystack="$1"
  local needle="$2"
  local test_name="$3"

  if [[ "$haystack" == *"$needle"* ]]; then
    echo "  [PASS] $test_name"
    PASSED_COUNT=$((PASSED_COUNT + 1))
  else
    echo "  [FAIL] $test_name: substring '$needle' not found"
    FAILED_COUNT=$((FAILED_COUNT + 1))
  fi
}

echo "=== Running rename_project.sh Test Suite ==="

# ------------------------------------------------------------------------------
# Test 1: Scenario 3.3 - Reject invalid mode argument
# ------------------------------------------------------------------------------
echo "Test 1: Reject invalid mode..."
OUTPUT=""
EXIT_CODE=0
OUTPUT=$(bash "$RENAME_SCRIPT" "DemoApp" demo_app com.demo.app --mode invalid_mode 2>&1) || EXIT_CODE=$?
assert_equals "1" "$EXIT_CODE" "Invalid mode returns exit code 1"
assert_contains "$OUTPUT" "Error: Unsupported mode 'invalid_mode'. Choose 'enterprise' or 'lean'." "Error message matches requirement"

# ------------------------------------------------------------------------------
# Test 2: Scenario 3.2 - Default to enterprise mode when --mode omitted (Dry Run)
# ------------------------------------------------------------------------------
echo "Test 2: Default to enterprise mode..."
OUTPUT=$(bash "$RENAME_SCRIPT" "DemoApp" demo_app com.demo.app --dry-run 2>&1)
assert_contains "$OUTPUT" "mode: enterprise" "Defaults to enterprise mode"
assert_contains "$OUTPUT" "DemoApp" "App name captured"
assert_contains "$OUTPUT" "demo_app" "Package name captured"
assert_contains "$OUTPUT" "com.demo.app" "Bundle id captured"

# ------------------------------------------------------------------------------
# Test 3: Scenario 3.1 - Parse --mode lean (Dry Run)
# ------------------------------------------------------------------------------
echo "Test 3: Parse --mode lean..."
OUTPUT=$(bash "$RENAME_SCRIPT" "LeanApp" lean_app com.lean.app --mode lean --dry-run 2>&1)
assert_contains "$OUTPUT" "mode: lean" "Parses mode lean"
assert_contains "$OUTPUT" "LeanApp" "App name captured"
assert_contains "$OUTPUT" "lean_app" "Package name captured"
assert_contains "$OUTPUT" "com.lean.app" "Bundle id captured"

# ------------------------------------------------------------------------------
# Test 4: Scenario 3.4 - Execution with mode delegation on a fixture
# ------------------------------------------------------------------------------
echo "Test 4: Mode delegation verification on hook..."
TEMP_FIXTURE="$(mktemp -d)"
trap 'rm -rf "$TEMP_FIXTURE"' EXIT

# Verify brick.yaml contains mode variable
BRICK_YAML=$(cat "$REPO_ROOT/bricks/pac_rename_project/brick.yaml")
assert_contains "$BRICK_YAML" "mode:" "brick.yaml declares mode variable"

# Verify post_gen.dart handles mode
POST_GEN_DART=$(cat "$REPO_ROOT/bricks/pac_rename_project/hooks/post_gen.dart")
assert_contains "$POST_GEN_DART" "configure_mode.sh" "post_gen.dart invokes configure_mode.sh"

# ------------------------------------------------------------------------------
# Summary
# ------------------------------------------------------------------------------
echo ""
echo "=== Test Results: $PASSED_COUNT Passed, $FAILED_COUNT Failed ==="

if [[ "$FAILED_COUNT" -gt 0 ]]; then
  exit 1
fi
exit 0
