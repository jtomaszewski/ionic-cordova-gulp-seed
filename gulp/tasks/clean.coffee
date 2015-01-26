gulp = require 'gulp'
clean = require 'gulp-clean'

{GLOBALS, PUBLIC_GLOBALS} = require "../globals"
{PATHS, DESTINATIONS} = require "../paths"

gulp.task 'clean', ->
  gulp.src(GLOBALS.BUILD_DIR, read: false)
    .pipe(clean(force: true))
