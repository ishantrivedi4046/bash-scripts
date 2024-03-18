#!/usr/bin/bash

set -euo pipefail

# Colors
YELLOW="\e[1;33m"
GREEN="\e[1;32m"
RED="\e[1;31m"
BLUE="\e[1;34m"
MAGENTA="\e[1;35m"
WHITE="\e[1;97m"

# Script Path
SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

# Removing previous Bundle
rm -rf android/app/build/outputs/bundle

echo -e "${YELLOW}STEP 1 : ${GREEN}Creating .aab distributions"

# Got Env variables
echo -e "${YELLOW}Checking if .env exits or not"
if [[ -e ".env" ]]; then
echo -e "${GREEN}FOUND with content:"
  ENV_VAR=$(<.env)  
  echo -e "${WHITE}${ENV_VAR}" 
else
    echo -e "${RED}.env NOT FOUND"
    exit 1;
fi

###########################################################################################
echo -e "${YELLOW}Creating .abb files "
cd android/ && ./gradlew --stop && ./gradlew clean && ./gradlew bundleRelease

echo -e "${YELLOW}STEP 2 : ${GREEN}Creating .apks distributions"
cd -
echo -e "${YELLOW}ENTER bundletool.jar path (ex. /home/user/Downloads/softwares/bundletool-all-1.15.2.jar)"
read BUNDLETOOL_PATH

echo -e "${MAGENTA}Creating Staging .apks"
java -jar "$BUNDLETOOL_PATH" build-apks --bundle=android/app/build/outputs/bundle/stagingRelease/app-staging-release.aab --output=android/app/build/outputs/bundle/stagingRelease/app-staging-release.apks --mode=universal --ks=android/app/rove.keystore --ks-pass=pass:bNdicP288IV6KOU --ks-key-alias=rove-key-alias --key-pass=pass:bNdicP288IV6KOU

echo -e "${MAGENTA}Creating Local .apks"
java -jar "$BUNDLETOOL_PATH" build-apks --bundle=android/app/build/outputs/bundle/developRelease/app-develop-release.aab --output=android/app/build/outputs/bundle/developRelease/app-develop-release.apks --mode=universal --ks=android/app/rove.keystore --ks-pass=pass:bNdicP288IV6KOU --ks-key-alias=rove-key-alias --key-pass=pass:bNdicP288IV6KOU

echo -e "${MAGENTA}Creating Develop .apks"
java -jar "$BUNDLETOOL_PATH" build-apks --bundle=android/app/build/outputs/bundle/localRelease/app-local-release.aab --output=android/app/build/outputs/bundle/localRelease/app-local-release.apks --mode=universal --ks=android/app/rove.keystore --ks-pass=pass:bNdicP288IV6KOU --ks-key-alias=rove-key-alias --key-pass=pass:bNdicP288IV6KOU

echo -e "${MAGENTA}Creating Production .apks"
java -jar "$BUNDLETOOL_PATH" build-apks --bundle=android/app/build/outputs/bundle/productionRelease/app-production-release.aab --output=android/app/build/outputs/bundle/productionRelease/app-production-release.apks --mode=universal --ks=android/app/rove.keystore --ks-pass=pass:bNdicP288IV6KOU --ks-key-alias=rove-key-alias --key-pass=pass:bNdicP288IV6KOU

#############################################################################################

echo -e "${YELLOW}STEP 3 : ${GREEN}Create .apk distributions"
echo -e "${BLUE}Creating Staging .apk"
unzip -p android/app/build/outputs/bundle/stagingRelease/app-staging-release.apks universal.apk > android/app/build/outputs/bundle/stagingRelease/app-staging-release.apk

echo -e "${BLUE}Creating Local .apk"
unzip -p android/app/build/outputs/bundle/localRelease/app-local-release.apks universal.apk > android/app/build/outputs/bundle/localRelease/app-local-release.apk

echo -e "${BLUE}Creating Develop .apk"
unzip -p android/app/build/outputs/bundle/developRelease/app-develop-release.apks universal.apk > android/app/build/outputs/bundle/developRelease/app-develop-release.apk

echo -e "${BLUE}Creating Production .apk"
unzip -p android/app/build/outputs/bundle/productionRelease/app-production-release.apks universal.apk > android/app/build/outputs/bundle/productionRelease/app-production-release.apk
