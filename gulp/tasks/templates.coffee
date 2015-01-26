gulp = require 'gulp'
gutil = require 'gulp-util'
plumber = require 'gulp-plumber'
notify = require 'gulp-notify'
jade = require 'gulp-jade'
templateCache = require 'gulp-angular-templatecache'
path = require 'path'

{GLOBALS, PUBLIC_GLOBALS} = require "../globals"
{PATHS, DESTINATIONS} = require "../paths"

gulp.task 'templates', ->
  gulp.src(PATHS.templates)
    .pipe((plumber (error) ->
      gutil.log gutil.colors.red(error.message)
      @emit('end')
    ))
    .pipe(jade({
      locals:
        GLOBALS: PUBLIC_GLOBALS
      pretty: true
    }))
    .on('error', notify.onError((error) -> error.message))
    .pipe(gulp.dest(DESTINATIONS.templates))

    .pipe(templateCache("app_templates.js", {
      module: GLOBALS.ANGULAR_APP_NAME
      base: (file) ->
        file.path
          .replace(path.resolve("./"), "")
          .replace("/www/", "")
    }))
    .pipe(gulp.dest(DESTINATIONS.scripts))
