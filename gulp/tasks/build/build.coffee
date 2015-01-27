gulp = require 'gulp'
runSequence = require 'run-sequence'

{GLOBALS, PUBLIC_GLOBALS} = require "../../globals"
{PATHS, DESTINATIONS} = require "../../paths"


# Run set-debug as the first task, to enable debug version.
# Example: `gulp set-debug cordova:run:android`
gulp.task "set-debug", ->
  if GLOBALS.BUNDLE_ID.indexOf(".debug") == -1
    GLOBALS.BUNDLE_ID += ".debug"
    GLOBALS.BUNDLE_NAME += "Dbg"


gulp.task "build-debug", ["set-debug", "build"]


gulp.task "build", (cb) ->
  runSequence ["clean", "bower:install"],
    [
      "assets"
      "styles"
      "scripts"
      "templates"
    ], cb
