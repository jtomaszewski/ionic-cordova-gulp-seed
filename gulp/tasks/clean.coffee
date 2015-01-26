gulp = require 'gulp'
clean = require 'gulp-clean'

{GLOBALS, PUBLIC_GLOBALS} = require "../globals.coffee"
{PATHS, DESTINATIONS} = require "../paths.coffee"

gulp.task 'clean', ->
  gulp.src(GLOBALS.BUILD_DIR, read: false)
    .pipe(clean(force: true))
