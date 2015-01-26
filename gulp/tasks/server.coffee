gulp = require 'gulp'
gutil = require 'gulp-util'
http = require 'http'
open = require 'open'
ecstatic = require 'ecstatic'

{GLOBALS, PUBLIC_GLOBALS} = require "../globals.coffee"
{PATHS, DESTINATIONS} = require "../paths.coffee"

gulp.task 'server', ->
  http.createServer(ecstatic(root: GLOBALS.BUILD_DIR)).listen(GLOBALS.HTTP_SERVER_PORT)
  gutil.log gutil.colors.blue "HTTP server listening on #{GLOBALS.HTTP_SERVER_PORT}"

  if +GLOBALS.OPEN_IN_BROWSER
    url = "http://localhost:#{GLOBALS.HTTP_SERVER_PORT}/"
    open(url)
    gutil.log gutil.colors.blue "Opening #{url} in the browser..."
