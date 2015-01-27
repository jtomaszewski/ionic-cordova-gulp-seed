gulp = require 'gulp'
shell = require 'gulp-shell'

gulp.task 'bower:install', shell.task('bower install')
