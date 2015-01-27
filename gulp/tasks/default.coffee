gulp = require 'gulp'
runSequence = require 'run-sequence'

gulp.task "default", (cb) ->
  runSequence "build", ["watch", "serve", "weinre", "livereload"], cb
