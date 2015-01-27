gulp = require 'gulp'
livereload = require 'gulp-livereload'

{GLOBALS, PUBLIC_GLOBALS, PATHS, DESTINATIONS} = require "../../config"

gulp.task 'livereload', ->
  livereload.listen({
    basePath: GLOBALS.BUILD_DIR
  })

  gulp.watch(DESTINATIONS.livereload).on 'change', (file) ->
    livereload.changed(file.path)
