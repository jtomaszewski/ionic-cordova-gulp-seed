gulp = require 'gulp'
livereload = require 'gulp-livereload'

{GLOBALS, PUBLIC_GLOBALS} = require "../../globals"
{PATHS, DESTINATIONS} = require "../../paths"

gulp.task 'livereload', ->
  livereloadServer = livereload()
  gulp.watch(DESTINATIONS.livereload).on 'change', (file) ->
    livereloadServer.changed(file.path)
