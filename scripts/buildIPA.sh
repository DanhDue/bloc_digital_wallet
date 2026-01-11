#!/bin/bash
set -e

. ./scripts/buildConfigs/.env.info

versionName="$BUILD_FLAVOR""VersionName"
versionCode="$BUILD_FLAVOR""VersionCode"

echo -e "\033[0;32mEnvironment Settings: \t
BUILD_FLAVOR: $BUILD_FLAVOR; \t
DISTRIBUTE_FIREBASE: $DISTRIBUTE_FIREBASE; TICKET_NUMBER: $TICKET_NUMBER; \t
versionName: ${!versionName}; versionCode: ${!versionCode} \n
\033[0m"
echo -e "\033[0;32mfvm flutter pub get\033[0m"
fvm flutter pub get
echo -e "\033[0;32mfvm dart run build_runner clean\033[0m"
fvm dart run build_runner clean
echo -e "\033[0;32mmelos genAlls\033[0m"
melos genAlls


echo -e "\033[0;32mcd ios\033[0m"
cd ios
echo -e "\033[0;32mpod install\033[0m"
pod install
cd ..

# Build IPA with flavor and dart-define-from-file
# export method included in the ExportOptions.plist file.
echo -e "\033[0;32mfvm flutter build ipa --flavor $BUILD_FLAVOR --export-options-plist=scripts/buildConfigs/$BUILD_FLAVOR/ExportOptions.plist \t
--build-name=${!versionName} --build-number=${!versionCode} --dart-define-from-file=secureFiles/$BUILD_FLAVOR/environment-configs.json \t
--target lib/main.dart \t
--$BUILD_TYPE\033[0m"

fvm flutter build ipa --flavor $BUILD_FLAVOR \
--export-options-plist=scripts/buildConfigs/$BUILD_FLAVOR/ExportOptions.plist \
--build-name=${!versionName} \
--build-number=${!versionCode} \
--dart-define-from-file=secureFiles/$BUILD_FLAVOR/environment-configs.json \
--target lib/main.dart \
--$BUILD_TYPE

if $DISTRIBUTE_FIREBASE
then
    echo "Need to deploy the app to the Firebase App Distribution."
    cd ios
    bundle update --bundler
    fastlane uploadToFirebase
    # fastlane notifyCW
else
    echo "DEPLOYMENT: $DISTRIBUTE_FIREBASE"
fi
