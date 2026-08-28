#!/bin/bash
# Regression check for the iOS build variants (see ios/scripts/setup_ios_flavors.py).
#
# Builds dev -> stg -> prd -> dev WITHOUT `flutter clean` in between and asserts the
# app identity baked into each build/ios/iphoneos/Runner.app. The dev-twice bookend
# proves there is no stale-config carry-over when switching flavors.
#
# Run from the repo root:  bash ios/scripts/verify_flavors.sh
set -u

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$ROOT" || exit 2
APP="build/ios/iphoneos/Runner.app"
PB=/usr/libexec/PlistBuddy
BASE_ID="com.example.blocDigitalWallet"
fail=0

check () { # flavor  expect_name  expect_suffix
  local f=$1 want_name=$2 want_id="$BASE_ID$3"
  echo "==================== build $f ===================="
  flutter build ios --flavor "$f" \
    --dart-define-from-file="secureFiles/$f/environment-configs.json" \
    --no-codesign --debug 2>&1 | grep -E "Building com\.example|Xcode build done|Built |[Ee]rror" | sed 's/^/  /'

  local name bid gs
  name=$($PB -c 'Print :CFBundleDisplayName' "$APP/Info.plist" 2>/dev/null)
  bid=$($PB -c 'Print :CFBundleIdentifier' "$APP/Info.plist" 2>/dev/null)
  gs=$($PB -c 'Print :BUNDLE_ID' "$APP/GoogleService-Info.plist" 2>/dev/null || echo "<missing>")

  [ "$name" = "$want_name" ] && s1=OK || { s1=FAIL; fail=1; }
  [ "$bid" = "$want_id" ]    && s2=OK || { s2=FAIL; fail=1; }
  [ "$gs" = "$want_id" ]     && s3=OK || { s3=FAIL; fail=1; }
  printf "  %-4s CFBundleDisplayName=%-11s [%s]  CFBundleIdentifier=%-34s [%s]  GoogleService=%-34s [%s]\n" \
    "$f" "$name" "$s1" "$bid" "$s2" "$gs" "$s3"
}

check dev "Zeno(dev)" ".dev"
check stg "Zeno(stg)" ".stg"
check prd "Zeno"      ""
check dev "Zeno(dev)" ".dev"

echo "======================================================"
[ $fail -eq 0 ] && echo "ALL FLAVORS OK" || echo "SOME CHECKS FAILED"
exit $fail
