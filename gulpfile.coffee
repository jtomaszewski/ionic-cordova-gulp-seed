gulp = require 'gulp'
runSequence = require 'run-sequence'

{GLOBALS, PUBLIC_GLOBALS} = require "./gulp/globals.coffee"
{PATHS, DESTINATIONS} = require "./gulp/paths.coffee"


require "./gulp/tasks/clean.coffee"
require "./gulp/tasks/bower-install.coffee"

require "./gulp/tasks/assets.coffee"
require "./gulp/tasks/styles.coffee"
require "./gulp/tasks/scripts.coffee"
require "./gulp/tasks/templates.coffee"

require "./gulp/tasks/test-e2e.coffee"
require "./gulp/tasks/test-unit.coffee"

require "./gulp/tasks/watch.coffee"
require "./gulp/tasks/livereload.coffee"
require "./gulp/tasks/server.coffee"
require "./gulp/tasks/weinre.coffee"
require "./gulp/tasks/build.coffee"

require "./gulp/tasks/cordova.coffee"

require "./gulp/tasks/deploy.coffee"
require "./gulp/tasks/release.coffee"


gulp.task "default", (cb) ->
  runSequence "build", ["watch", "server", "weinre", "livereload"], cb
