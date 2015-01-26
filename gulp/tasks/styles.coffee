gulp = require 'gulp'
gutil = require 'gulp-util'
plumber = require 'gulp-plumber'
changed = require 'gulp-changed'
notify = require 'gulp-notify'
sass = require 'gulp-sass'
sourcemaps = require 'gulp-sourcemaps'

{GLOBALS, PUBLIC_GLOBALS} = require "../globals.coffee"
{PATHS, DESTINATIONS} = require "../paths.coffee"

gulp.task 'styles', ->
  gulp.src(PATHS.styles)
    .pipe(changed(DESTINATIONS.styles, extension: '.css'))
    .pipe((plumber (error) ->
      gutil.log gutil.colors.red(error.message)
      @emit('end')
    ))

    .pipe(sourcemaps.init())
      .pipe(sass())
    .pipe(sourcemaps.write())

    .on('error', notify.onError((error) -> error.message))
    .pipe(gulp.dest(DESTINATIONS.styles))
