gulp = require 'gulp'
gutil = require 'gulp-util'
plumber = require 'gulp-plumber'
coffee = require 'gulp-coffee'
concat = require 'gulp-concat'
sourcemaps = require 'gulp-sourcemaps'
rollbar = require 'gulp-rollbar'
gulpIf = require 'gulp-if'

{GLOBALS, PUBLIC_GLOBALS} = require "../../globals"
{PATHS, DESTINATIONS} = require "../../paths"


uploadSourcemapsToRollbar = ->
  isEnabled = !!(GLOBALS.UPLOAD_SOURCEMAPS_TO_ROLLBAR && GLOBALS.ROLLBAR_SERVER_ACCESS_TOKEN)
  gulpIf(isEnabled, rollbar({
    accessToken: (GLOBALS.ROLLBAR_SERVER_ACCESS_TOKEN ? "none")
    version: GLOBALS.CODE_VERSION
    sourceMappingURLPrefix: GLOBALS.ROLLBAR_SOURCEMAPS_URL_PREFIX + "/js"
  }))


gulp.task 'scripts:vendor', ->
  gulp.src(PATHS.scripts.vendor)

    .pipe(sourcemaps.init())
      .pipe(concat('vendor.js'))
      .pipe(uploadSourcemapsToRollbar())
    .pipe(sourcemaps.write('./'))

    .pipe(gulp.dest(DESTINATIONS.scripts))


# Define scripts:app, scripts:app_run, scripts:bootstrap tasks
['app', 'app_run', 'bootstrap'].forEach (scriptsName) ->
  gulp.task "scripts:#{scriptsName}", ->
    gulp.src(PATHS.scripts[scriptsName])
      .pipe((plumber (error) ->
        gutil.log gutil.colors.red(error.message)
        @emit('end')
      ))

      .pipe(sourcemaps.init())
        .pipe(coffee())
        .pipe(concat("#{scriptsName}.js"))
        .pipe(uploadSourcemapsToRollbar())
      .pipe(sourcemaps.write('./'))

      .pipe(gulp.dest(DESTINATIONS.scripts))


gulp.task 'scripts', ['scripts:vendor', 'scripts:app', 'scripts:app_run', 'scripts:bootstrap']


# Run this as a first task, to enable uploading sourcemaps to rollbar.
# By default it's being run in the "release" task.
gulp.task "deploy:rollbar-sourcemaps:enable", ->
  GLOBALS.UPLOAD_SOURCEMAPS_TO_ROLLBAR = true

gulp.task "deploy:rollbar-sourcemaps", ["deploy:rollbar-sourcemaps:enable", "scripts"]
