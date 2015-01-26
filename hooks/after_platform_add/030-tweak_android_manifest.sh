#!/bin/sh

# Fix bug when application can't be run - add required permissions
# (see "Migrating with Crosswalk 5" section in crosswalk-project documentation
#  NOTE: it was required for Crosswalk 7 for me also)

# Exit, if there's no android here.
test ! -d "platforms/android" && exit

ANDROID_MANIFEST_PATH="platforms/android/AndroidManifest.xml"

function insert_line {
  LINE=$1

  if ! fgrep --silent "$LINE" $ANDROID_MANIFEST_PATH; then
    awk "/<\/manifest>/{print \"$LINE\"}1" $ANDROID_MANIFEST_PATH > tmp && mv tmp $ANDROID_MANIFEST_PATH
    echo "HOOK >> Line inserted to AndroidManifest.xml:"
    echo "HOOK >> $LINE"
  fi
}

# When installing some plugins, we have permissions like "CAMERA", that make the app non visible on the Android's Play market for some devices (tablets).
# By adding <uses-feature> tags with android:required="false", we allow the app to be visible on the market even for devices without a camera or gps (because we don't need it so much).
# See: http://developer.android.com/guide/topics/manifest/uses-feature-element.html#features-reference

insert_line "    <uses-feature android:name='android.hardware.camera' android:required='false' />"
insert_line "    <uses-feature android:name='android.hardware.camera.autofocus' android:required='false' />"
insert_line "    <uses-feature android:name='android.hardware.camera.flash' android:required='false' />"
insert_line "    <uses-feature android:name='android.hardware.location' android:required='false' />"
insert_line "    <uses-feature android:name='android.hardware.location.network' android:required='false' />"
insert_line "    <uses-feature android:name='android.hardware.location.gps' android:required='false' />"

echo "HOOK >> AndroidManifest.xml should now have tweaked permissions.."
