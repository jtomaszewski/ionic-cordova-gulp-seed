gulp = require 'gulp'
gutil = require 'gulp-util'
plumber = require 'gulp-plumber'
changed = require 'gulp-changed'
ejs = require 'gulp-ejs'

{GLOBALS, PUBLIC_GLOBALS, PATHS, DESTINATIONS} = require "../../config"

gulp.task 'assets:ejs', ->
  gulp.src(PATHS.assets_ejs)
    .pipe((plumber (error) ->
      gutil.log gutil.colors.red(error.message)
      @emit('end')
    ))
    .pipe(ejs(GLOBALS, ext: ''))
    .pipe(gulp.dest(DESTINATIONS.assets))

gulp.task 'assets:others', ->
  gulp.src(PATHS.assets)
    .pipe(changed(DESTINATIONS.assets))
    .pipe(gulp.dest(DESTINATIONS.assets))

gulp.task 'assets', ['assets:ejs', 'assets:others']
