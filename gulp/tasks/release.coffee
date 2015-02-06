gulp = require('gulp-help')(require('gulp'))
runSequence = require 'run-sequence'

{GLOBALS, PUBLIC_GLOBALS, PATHS, DESTINATIONS} = require "../config"


GLOBALS.AVAILABLE_PLATFORMS.forEach (platform) ->
  # Build the release and deploys it to the HTTP server.
  if gulp.tasks["deploy:release:#{platform}"]
    gulp.task "release:#{platform}", "Release the #{platform} app", (cb) ->
      runSequence "cordova:build-release:#{platform}", "cordova:sign-release:#{platform}", "deploy:release:#{platform}", cb


releaseTasks = ["deploy:rollbar-sourcemaps", "release:android", "release:ios"]
  .filter (taskName) -> !!gulp.tasks[taskName]

if releaseTasks.length > 0
  gulp.task "release", "Release the app - deploy it to both Android & iOS", ->
    runSequence.apply(runSequence, releaseTasks)

