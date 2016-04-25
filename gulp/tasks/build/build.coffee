gulp = require('gulp-help')(require('gulp'))
runSequence = require 'run-sequence'

{GLOBALS, PUBLIC_GLOBALS, PATHS, DESTINATIONS} = require "../../config"


# Run 'set-as-debug' as the first task, to enable debug version.
# Example: `gulp set-as-debug cordova:run:android`
gulp.task "set-as-debug", false, ->
  unless gulp.env.appstore || gulp.env.release
    GLOBALS.SET_AS_DEBUG ?= true

gulp.task "set-debug", false, ->
  unless gulp.env.appstore || gulp.env.release
    if !!+GLOBALS.SET_AS_DEBUG
      GLOBALS.DEBUG = true

  if GLOBALS.DEBUG
    if GLOBALS.BUNDLE_ID.indexOf(".debug") == -1
      console.log ">> set-debug gulp task >> Adding .debug to the GLOBALS.BUNDLE_ID"
      GLOBALS.BUNDLE_ID += ".debug"
      GLOBALS.BUNDLE_NAME += "Dbg"


gulp.task "build-debug", false, ["set-as-debug", "set-debug", "build"]


gulp.task "build", "Compile all the contents of ./#{GLOBALS.BUILD_DIR}/", (cb) ->
  runSequence ["clean", "bower:install"],
    [
      "assets"
      "styles"
      "scripts"
      "templates"
      "views"
    ], cb


gulp.task "build-release", false, (cb) ->
  runSequence "build", "build:minify", cb
