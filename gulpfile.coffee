gulp = require 'gulp'
runSequence = require 'run-sequence'

{GLOBALS, PUBLIC_GLOBALS} = require "./gulp/globals"
{PATHS, DESTINATIONS} = require "./gulp/paths"


require "./gulp/tasks/clean"
require "./gulp/tasks/bower-install"

require "./gulp/tasks/assets"
require "./gulp/tasks/styles"
require "./gulp/tasks/scripts"
require "./gulp/tasks/templates"

require "./gulp/tasks/test-e2e"
require "./gulp/tasks/test-unit"

require "./gulp/tasks/watch"
require "./gulp/tasks/livereload"
require "./gulp/tasks/server"
require "./gulp/tasks/weinre"
require "./gulp/tasks/build"

require "./gulp/tasks/cordova"

require "./gulp/tasks/deploy"
require "./gulp/tasks/release"


gulp.task "default", (cb) ->
  runSequence "build", ["watch", "server", "weinre", "livereload"], cb
