gulp = require('gulp-help')(require('gulp'))
gutil = require 'gulp-util'
browserSync = require 'browser-sync'

{GLOBALS, PUBLIC_GLOBALS, PATHS, DESTINATIONS} = require "../../config"

gulp.task 'serve', "Run browser-sync server with livereload in ./#{GLOBALS.BUILD_DIR}/ directory", ->
  browserSync({
    server:
      baseDir: GLOBALS.BUILD_DIR
    port: GLOBALS.HTTP_SERVER_PORT
    open: !!+GLOBALS.OPEN_IN_BROWSER
    files: DESTINATIONS.livereload
  })
