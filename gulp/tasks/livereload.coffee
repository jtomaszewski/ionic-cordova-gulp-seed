gulp = require 'gulp'
livereload = require 'gulp-livereload'

{GLOBALS, PUBLIC_GLOBALS} = require "../globals.coffee"
{PATHS, DESTINATIONS} = require "../paths.coffee"

gulp.task 'livereload', ->
  livereloadServer = livereload()
  gulp.watch(DESTINATIONS.livereload).on 'change', (file) ->
    livereloadServer.changed(file.path)
