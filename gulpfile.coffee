gulp = require 'gulp'
runSequence = require 'run-sequence'

{GLOBALS, PUBLIC_GLOBALS} = require "./gulp/globals"
{PATHS, DESTINATIONS} = require "./gulp/paths"


require "./gulp/tasks/base/clean"
require "./gulp/tasks/base/bower-install"

require "./gulp/tasks/build/assets"
require "./gulp/tasks/build/styles"
require "./gulp/tasks/build/scripts"
require "./gulp/tasks/build/templates"
require "./gulp/tasks/build/build"

require "./gulp/tasks/test/e2e"
require "./gulp/tasks/test/unit"

require "./gulp/tasks/server/watch"
require "./gulp/tasks/server/livereload"
require "./gulp/tasks/server/serve"
require "./gulp/tasks/server/weinre"

require "./gulp/tasks/cordova"

require "./gulp/tasks/deploy"
require "./gulp/tasks/release"


gulp.task "default", (cb) ->
  runSequence "build", ["watch", "serve", "weinre", "livereload"], cb
