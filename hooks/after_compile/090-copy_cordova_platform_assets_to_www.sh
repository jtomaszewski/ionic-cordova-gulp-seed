#!/bin/sh

if test ! -d "hooks"; then
  echo "HOOK >> You must run it in main directory of cordova project."
  exit 1
fi

if [[ $CORDOVA_PLATFORMS == *"android"* ]]; then
  ASSETS_FOLDER="platforms/android/assets/www"
  cp -r $ASSETS_FOLDER/cordova* $ASSETS_FOLDER/plugins* www/
fi

if [[ $CORDOVA_PLATFORMS == *"ios"* ]]; then
  ASSETS_FOLDER="platforms/ios/www"
  cp -r $ASSETS_FOLDER/cordova* $ASSETS_FOLDER/plugins* www/
fi

