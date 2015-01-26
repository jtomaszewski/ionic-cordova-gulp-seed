gulp = require 'gulp'
runSequence = require 'run-sequence'

{GLOBALS, PUBLIC_GLOBALS} = require "../globals.coffee"
{PATHS, DESTINATIONS} = require "../paths.coffee"


GLOBALS.AVAILABLE_PLATFORMS.forEach (platform) ->
  # Build the release and deploys it to the HTTP server.
  gulp.task "release:#{platform}", (cb) ->
    runSequence "cordova:build-release:#{platform}", "cordova:sign-release:#{platform}", "deploy:release:#{platform}", cb


gulp.task "release", ->
  runSequence "deploy:rollbar-sourcemaps", "release:android", "release:ios"
