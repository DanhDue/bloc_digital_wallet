#!/bin/bash
set -e

. ./scripts/buildConfigs/.env.info

versionName="$BUILD_FLAVOR""VersionName"
versionCode="$BUILD_FLAVOR""VersionCode"

echo -e "\033[0;32mEnvironment Settings: \t
BUILD_FLAVOR: $BUILD_FLAVOR; BUILD_TYPE: $BUILD_TYPE \t
DISTRIBUTE_FIREBASE: $DISTRIBUTE_FIREBASE; TICKET_NUMBER: $TICKET_NUMBER; \t
versionName: ${!versionName}; versionCode: ${!versionCode} \n
\033[0m"
echo -e "\033[0;32mfvm flutter pub get\033[0m"
fvm flutter pub get
echo -e "\033[0;32mfvm dart run build_runner clean\033[0m"
fvm dart run build_runner clean
echo -e "\033[0;32mmelos genAlls\033[0m"
melos genAlls

echo -e "\033[0;32mfvm flutter build appbundle --flavor $BUILD_FLAVOR \t
--build-name=${!versionName} --build-number=${!versionCode} \t
--dart-define-from-file=secureFiles/$BUILD_FLAVOR/environment-configs.json \t
--dart-define=FLAVOR=$BUILD_FLAVOR --target lib/main.dart --$BUILD_TYPE\033[0m"

fvm flutter build appbundle --flavor $BUILD_FLAVOR \
--build-name=${!versionName} --build-number=${!versionCode} \
--dart-define-from-file=secureFiles/$BUILD_FLAVOR/environment-configs.json \
--dart-define=FLAVOR=$BUILD_FLAVOR --target lib/main.dart --$BUILD_TYPE

if $DISTRIBUTE_FIREBASE
then
    echo "Need to deploy the app to the Firebase App Distribution."
    # cd android
    # fastlane uploadToFirebase
    
else
    echo "DEPLOYMENT: $DISTRIBUTE_FIREBASE"
fi