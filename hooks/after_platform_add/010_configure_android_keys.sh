#!/bin/sh

# More information: http://stackoverflow.com/questions/30106468/specify-signing-config-for-gradle-and-cordova-5

# Exit, if there's no android here.
[[ $CORDOVA_PLATFORMS == *"android"* ]] || exit 0

if test ! -f "keys/android/$ANDROID_KEYSTORE_NAME.keystore"; then
  echo "HOOK-configure_android_keys >> Android key's file \"keys/android/$ANDROID_KEYSTORE_NAME.keystore\" doesn't exist!"
  exit 1
fi

if test ! -n "$ANDROID_KEYSTORE_PASSWORD"; then
  echo "HOOK-configure_android_keys >> Enter key.store.password:\t"
  read ANDROID_KEYSTORE_PASSWORD
fi

if test ! -n "$ANDROID_ALIAS_PASSWORD"; then
  echo "HOOK-configure_android_keys >> Enter key.alias.password:\t"
  read ANDROID_ALIAS_PASSWORD
fi

echo "storeFile=../../keys/android/$ANDROID_KEYSTORE_NAME.keystore" > platforms/android/release-signing.properties
echo "storeType=jks"                                                >> platforms/android/release-signing.properties
echo "keyAlias=$ANDROID_ALIAS_NAME"                                 >> platforms/android/release-signing.properties
echo ""                                                             >> platforms/android/release-signing.properties
echo "# If you want, put also key passwords here"                   >> platforms/android/release-signing.properties
echo "storePassword=$ANDROID_KEYSTORE_PASSWORD"                     >> platforms/android/release-signing.properties
echo "keyPassword=$ANDROID_ALIAS_PASSWORD"                          >> platforms/android/release-signing.properties
