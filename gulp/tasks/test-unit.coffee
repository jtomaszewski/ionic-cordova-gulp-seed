gulp = require 'gulp'
childProcess = require 'child_process'

{GLOBALS, PUBLIC_GLOBALS} = require "../globals.coffee"
{PATHS, DESTINATIONS} = require "../paths.coffee"

# Runs unit tests using karma.
# You can run it simply using `gulp test:unit`.
# You can also pass some karma arguments like this: `gulp test:unit --browsers Chrome`.
gulp.task 'test:unit', ->
  args = ['start', 'test/unit/karma.conf.coffee']
  for name in ['browsers', 'reporters']
    args.push "--#{name}", "#{gulp.env[name]}" if gulp.env.hasOwnProperty(name)

  childProcess.spawn "node_modules/.bin/karma", args, stdio: 'inherit'
