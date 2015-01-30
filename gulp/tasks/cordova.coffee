gulp = require 'gulp'
shell = require 'gulp-shell'

{GLOBALS, PUBLIC_GLOBALS, SHELL_GLOBALS, PATHS, DESTINATIONS} = require "../config"


# Adds all SHELL_GLOBALS as ENV variables.
# Returns string like `env BUNDLE_ID="com.jtomaszewski.ionicstarter.development" BUNDLE_NAME="IonicStarterDev" `
generateEnvCommand = ->
  cmd = "env "
  for k, v of SHELL_GLOBALS
    cmd += "#{k}=\"#{v}\" "
  cmd


# Clean all cordova platforms, so they will need to be generated again.
gulp.task "cordova:clear", shell.task('rm -rf plugins/* platforms/*')


# Create cordova platform.
GLOBALS.AVAILABLE_PLATFORMS.forEach (platform) ->
  gulp.task "cordova:platform-add:#{platform}",
    ['build'],
    shell.task(generateEnvCommand() + "node_modules/.bin/cordova platform add #{platform}", ignoreErrors: true)

  # Build and emulate.
  gulp.task "cordova:emulate:#{platform}",
    ["cordova:platform-add:#{platform}", "build-debug"],
    shell.task(generateEnvCommand() + "node_modules/.bin/cordova emulate #{platform}")

  # Build and run on connected device.
  gulp.task "cordova:run:#{platform}",
    ["cordova:platform-add:#{platform}", "build-debug"],
    shell.task(generateEnvCommand() + "node_modules/.bin/cordova run #{platform} --device")

  # Same as cordova:run, but use release version, not debug.
  gulp.task "cordova:run-release:#{platform}",
    ["cordova:platform-add:#{platform}", "build"],
    shell.task(generateEnvCommand() + "node_modules/.bin/cordova run #{platform} --device --release")

  # Build a release.
  gulp.task "cordova:build-release:#{platform}",
    ["cordova:platform-add:#{platform}", "build"],
    shell.task(generateEnvCommand() + "node_modules/.bin/cordova build #{platform} --release" + ((" --device" if platform == "ios") || ""))

  # Sign the release.
  if platform == "ios"
    gulp.task "cordova:sign-release:ios", shell.task("xcrun -sdk iphoneos PackageApplication \
      -v platforms/ios/build/device/#{GLOBALS.BUNDLE_NAME}.app \
      -o #{GLOBALS.APP_ROOT}platforms/ios/#{GLOBALS.BUNDLE_NAME}.ipa \
      --embed #{GLOBALS.IOS_PROVISIONING_PROFILE}")
  else
    gulp.task "cordova:sign-release:#{platform}", []

