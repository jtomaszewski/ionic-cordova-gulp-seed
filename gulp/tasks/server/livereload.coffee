gulp = require 'gulp'
livereload = require 'gulp-livereload'

{GLOBALS, PUBLIC_GLOBALS, PATHS, DESTINATIONS} = require "../../config"

gulp.task 'livereload', ->
  livereloadServer = livereload()
  gulp.watch(DESTINATIONS.livereload).on 'change', (file) ->
    livereloadServer.changed(file.path)
