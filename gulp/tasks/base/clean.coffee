gulp = require 'gulp'
clean = require 'gulp-clean'

{GLOBALS, PUBLIC_GLOBALS, PATHS, DESTINATIONS} = require "../../config"

gulp.task 'clean', ->
  gulp.src(GLOBALS.BUILD_DIR, read: false)
    .pipe(clean(force: true))
