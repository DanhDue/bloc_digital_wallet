#!/usr/bin/env bash
# Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
CONFIGURE_SCRIPT="$REPO_ROOT/scripts/configure_mode.sh"

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

echo "=== Running configure_mode.sh Test Suite ==="

# Check script exists and is executable
if [[ ! -x "$CONFIGURE_SCRIPT" ]]; then
  echo "Error: $CONFIGURE_SCRIPT does not exist or is not executable." >&2
  exit 1
fi

# ------------------------------------------------------------------------------
# Test 1: Scenario 2.3 - Prune abort on dirty working tree without --force
# ------------------------------------------------------------------------------
echo "Test 1: Prune abort on dirty working tree..."
TEMP_FIXTURE="$(mktemp -d)"
trap 'rm -rf "$TEMP_FIXTURE"' EXIT

# Create a mock git repo with dirty working tree
(
  cd "$TEMP_FIXTURE"
  git init -q
  mkdir -p features/scanner
  echo "mock" > features/scanner/mock.dart
  git add .
  git commit -qm "init"
  echo "dirty modification" > dirty.txt
)

OUTPUT=""
EXIT_CODE=0
OUTPUT=$(bash "$CONFIGURE_SCRIPT" lean --prune --root-dir="$TEMP_FIXTURE" --skip-verify 2>&1) || EXIT_CODE=$?
assert_equals "1" "$EXIT_CODE" "Prune with dirty tree returns exit code 1"
assert_contains "$OUTPUT" "Working tree has uncommitted changes. Use --force to override." "Abort message matches requirement"
if [[ -d "$TEMP_FIXTURE/features/scanner" ]]; then
  assert_equals "true" "true" "features/scanner is preserved on abort"
else
  assert_equals "true" "false" "features/scanner should be preserved on abort"
fi

# ------------------------------------------------------------------------------
# Test 2: Scenario 2.4 - Prune clean removal with clean repo
# ------------------------------------------------------------------------------
echo "Test 2: Prune clean removal..."
(
  cd "$TEMP_FIXTURE"
  git clean -fdq
  git reset --hard -q
  mkdir -p lib
  cat << 'EOF' > pubspec.yaml
name: fixture_app
workspace:
  - features/scanner
  - features/settings
dependencies:
  # pubspec:scanner-dependency:begin
  scanner:
    path: features/scanner
  # pubspec:scanner-dependency:end
  settings:
    path: features/settings
EOF
  git add .
  git commit -qm "clean state"
)

EXIT_CODE=0
OUTPUT=$(bash "$CONFIGURE_SCRIPT" lean --prune --root-dir="$TEMP_FIXTURE" --skip-verify 2>&1) || EXIT_CODE=$?
assert_equals "0" "$EXIT_CODE" "Prune on clean tree succeeds with exit code 0"

if [[ ! -d "$TEMP_FIXTURE/features/scanner" ]]; then
  assert_equals "true" "true" "features/scanner was deleted"
else
  assert_equals "true" "false" "features/scanner should have been deleted"
fi

PUBSPEC_CONTENT=$(cat "$TEMP_FIXTURE/pubspec.yaml")
if [[ "$PUBSPEC_CONTENT" != *"features/scanner"* ]]; then
  assert_equals "true" "true" "pubspec.yaml has features/scanner removed"
else
  assert_equals "true" "false" "pubspec.yaml should not contain features/scanner"
fi

# ------------------------------------------------------------------------------
# Test 3: Scenario 2.1 & 2.5 - Lean Mode Markers and Idempotency
# ------------------------------------------------------------------------------
echo "Test 3: Marker toggling and idempotency on real codebase..."
# Capture git diff of relevant tracked files before testing
BEFORE_DIFF=$(git -C "$REPO_ROOT" diff lib/ packages/ pubspec.yaml test/ integration_test/)

# Switch to lean mode
bash "$CONFIGURE_SCRIPT" lean --root-dir="$REPO_ROOT" --skip-verify
LEAN_CONFIG=$(cat "$REPO_ROOT/lib/shell/shell_config.dart")
assert_contains "$LEAN_CONFIG" "static const int tabCount = 2;" "Lean mode tabCount is 2"
assert_contains "$LEAN_CONFIG" "static const bool hasScannerTab = false;" "Lean mode hasScannerTab is false"

ROUTER_CONTENT=$(cat "$REPO_ROOT/lib/app_router.dart")
assert_contains "$ROUTER_CONTENT" "// ..._scannerRouter.routes," "Scanner routes commented out in lean mode"

# Idempotency check: run lean again
bash "$CONFIGURE_SCRIPT" lean --root-dir="$REPO_ROOT" --skip-verify
LEAN_CONFIG_REPEAT=$(cat "$REPO_ROOT/lib/shell/shell_config.dart")
assert_equals "$LEAN_CONFIG" "$LEAN_CONFIG_REPEAT" "Repeating lean mode is idempotent"

# ------------------------------------------------------------------------------
# Test 4: Scenario 2.2 - Round-Trip Transition (Enterprise -> Lean -> Enterprise)
# ------------------------------------------------------------------------------
echo "Test 4: Round-trip transition back to enterprise..."
bash "$CONFIGURE_SCRIPT" enterprise --root-dir="$REPO_ROOT" --skip-verify

ENTERPRISE_CONFIG=$(cat "$REPO_ROOT/lib/shell/shell_config.dart")
assert_contains "$ENTERPRISE_CONFIG" "static const int tabCount = 3;" "Enterprise mode tabCount is 3"
assert_contains "$ENTERPRISE_CONFIG" "static const bool hasScannerTab = true;" "Enterprise mode hasScannerTab is true"

ROUTER_ENTERPRISE=$(cat "$REPO_ROOT/lib/app_router.dart")
assert_contains "$ROUTER_ENTERPRISE" "..._scannerRouter.routes," "Scanner route is active in enterprise mode"

# Check git diff compared to before
AFTER_DIFF=$(git -C "$REPO_ROOT" diff lib/ packages/ pubspec.yaml test/ integration_test/)
assert_equals "$BEFORE_DIFF" "$AFTER_DIFF" "Round-trip leaves zero net changes on repository"

# ------------------------------------------------------------------------------
# Summary
# ------------------------------------------------------------------------------
echo ""
echo "=== Test Results: $PASSED_COUNT Passed, $FAILED_COUNT Failed ==="

if [[ "$FAILED_COUNT" -gt 0 ]]; then
  exit 1
fi
exit 0
