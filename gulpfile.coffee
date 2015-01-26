Q             = require 'q'
child_process = require 'child_process'
gulp          = require 'gulp'
gutil         = require 'gulp-util'
sass          = require 'gulp-sass'
coffee        = require 'gulp-coffee'
jade          = require 'gulp-jade'
livereload    = require 'gulp-livereload'
changed       = require 'gulp-changed'
ripple        = require 'ripple-emulator'
open          = require 'open'
http          = require 'http'
path          = require 'path'
ecstatic      = require 'ecstatic'
notify        = require 'gulp-notify'
concat        = require 'gulp-concat'
clean         = require 'gulp-clean'
cache         = require 'gulp-cache'
ejs           = require 'gulp-ejs'
shell         = require 'gulp-shell'
protractor    = require 'gulp-protractor'
plumber       = require 'gulp-plumber'
runSequence   = require 'run-sequence'
templateCache = require 'gulp-angular-templatecache'
sourcemaps    = require 'gulp-sourcemaps'
rollbar       = require 'gulp-rollbar'
gulpIf        = require 'gulp-if'

APP_ROOT = require("execSync").exec("pwd").stdout.trim() + "/"

# Used in "development" environment as a IP for the server.
# You can specify it by using LOCAL_IP env variable in your cli commands.
LOCAL_IP = process.env.LOCAL_IP || require('execSync').exec("(ifconfig wlan 2>/dev/null || ifconfig en0) | grep inet | grep -v inet6 | awk '{print $2}' | sed 's/addr://g'").stdout.trim()
LOCAL_IP = "127.0.0.1" unless parseInt(LOCAL_IP) > 0


ENV_GLOBALS =
  defaults:
    BUNDLE_VERSION: "1.1.0"

    ANDROID_CROSSWALK_MODE: "0"
    ANGULAR_APP_NAME: "ionicstarter"
    BUILD_DIR: "www"
    CORDOVA_PLATFORM: null
    OPEN_IN_BROWSER: true
    UPLOAD_SOURCEMAPS_TO_ROLLBAR: false

    ROLLBAR_SOURCEMAPS_URL_PREFIX: "https://ionicstarter.com"
    ROLLBAR_CLIENT_ACCESS_TOKEN: null # "aaa"
    ROLLBAR_SERVER_ACCESS_TOKEN: null # "bbb"

    # If defined, we'll deploy the app to testfairy after compiling the release.
    # TESTFAIRY_API_KEY: "123"
    # TESTFAIRY_TESTER_GROUPS: "IonicStarterTesters"

  development:
    ENV: "development"

    BUNDLE_ID: "com.jtomaszewski.ionicstarter.development"
    BUNDLE_NAME: "IonicStarterDev"

    # Automatically connect to weinre on application's startup
    # (this way you can debug your application on your PC even if it's running from mobile ;) )
    WEINRE_ADDRESS: "#{LOCAL_IP}:31173"

  production:
    ENV: "production"

    BUNDLE_ID: "com.jtomaszewski.ionicstarter.production"
    BUNDLE_NAME: "IonicStarter"

    # If those 2 variables are defined, the app will be deployed to the remote server after compiling the release.
    ANDROID_DEPLOY_APPBIN_PATH: "deploy@ionicstarter.com:/u/apps/ionicstarter/shared/public/uploads/ionicstarter-production.apk"
    ANDROID_DEPLOY_APPBIN_URL: "http://ionicstarter.com/uploads/ionicstarter-production.apk"

    # If those 2 variables are defined, the app will be deployed to the remote server after compiling the release.
    IOS_DEPLOY_APPBIN_PATH: "deploy@ionicstarter.com:/u/apps/ionicstarter/shared/public/uploads/ionicstarter-production.ipa"
    IOS_DEPLOY_APPBIN_URL: "http://ionicstarter.com/uploads/ionicstarter-production.ipa"

    # Required for the release to be signed with correct certificate.
    IOS_PROVISIONING_PROFILE: "keys/ios/ionicstarterstaging.mobileprovision"

    # CORDOVA_GOOGLE_ANALYTICS_ID: "UA-123123-2"
    # GOOGLE_ANALYTICS_ID: "UA-123123-1"
    # GOOGLE_ANALYTICS_HOST: "ionicstarter.com"

    # If defined, we'll deploy the app to testflight after compiling the release.
    # TESTFLIGHT_API_TOKEN: "123"
    # TESTFLIGHT_TEAM_TOKEN: "456"
    # TESTFLIGHT_DISTRIBUTION_LISTS: "IonicStarterTesters"

GLOBALS = require('extend') true, {}, ENV_GLOBALS.defaults, (ENV_GLOBALS[gutil.env.env || "development"] || {})
GLOBALS.DEPLOY_TIME = Date.now()
GLOBALS.CODE_VERSION = require('execSync').exec("git rev-parse HEAD").stdout.trim()

for k, v of GLOBALS
  # You can replace any of GLOBALS by defining ENV variable in your command line,
  # f.e. `BUNDLE_ID="com.different.bundleid" gulp`
  GLOBALS[k] = process.env[k] if process.env[k]? && GLOBALS[k]?

  # You can also do this in this way:
  # `gulp --BUNDLE_ID="com.different.bundleid"`
  GLOBALS[k] = gulp.env[k] if gulp.env[k]? && GLOBALS[k]?

for k, v of GLOBALS
  # Also, if a GLOBALS[k] is a function, then let's call it and get its' value.
  GLOBALS[k] = GLOBALS[k]() if typeof GLOBALS[k] == "function"

# In summary, GLOBALS are build in this way:
# 1) Take the defaults (GLOBALS.development)
# 2) Merge with current GLOBALS[env] (f.e. GLOBALS.staging)
# 3) Replace existing GLOBALS with existing and matched ENV variables.

# PUBLIC_GLOBALS_KEYS defines which globals
# will be actually passed into the frontend's application
# (rest of globals are visible only in gulp and shell scripts)
PUBLIC_GLOBALS_KEYS = [
  "BUNDLE_NAME"
  "BUNDLE_VERSION"
  "CODE_VERSION"
  "CORDOVA_GOOGLE_ANALYTICS_ID"
  "DEPLOY_TIME"
  "ENV"
  "GOOGLE_ANALYTICS_HOST"
  "GOOGLE_ANALYTICS_ID"
  "ROLLBAR_CLIENT_ACCESS_TOKEN"
  "ROLLBAR_SOURCEMAPS_URL_PREFIX"
  "WEINRE_ADDRESS"
]


paths =
  assets: ['assets/**', '!assets/**/*.ejs']
  assets_ejs: ['assets/**/*.ejs']
  watched_assets: ['assets/fonts/**', 'assets/images/**', 'assets/js/**', '!assets/*.ejs']
  styles: ['app/css/**/*.scss']
  scripts:
    vendor: [
      "assets/components/ionic/release/js/ionic.js"
      "assets/components/angular/angular.js"
      "assets/components/angular-animate/angular-animate.js"
      "assets/components/angular-sanitize/angular-sanitize.js"
      "assets/components/angular-ui-router/release/angular-ui-router.js"
      "assets/components/ionic/release/js/ionic-angular.js"

      # Here add any vendor files that should be included in vendor.js
      # (f.e. bower components)

      # Google Analytics support (for both in-browser and Cordova app)
      "assets/components/angulartics/src/angulartics.js"
      "assets/components/angulartics/src/angulartics-ga.js"
      "assets/components/angulartics/src/angulartics-ga-cordova.js"
    ]
    bootstrap: [
      'app/js/bootstrap.coffee'
    ]
    app: [
      'app/js/app_config.coffee' # define application's angular module; add some native/global js variables
      'app/js/*/**/*.coffee'  # include all angular submodules (like controllers, directives, services)
      'app/js/routes.coffee'  # app.config - routes
      'app/js/app_run.coffee' # app.config; app.run
    ]
    tests: [
      'test/**/*.coffee'
    ]
  templates: ['app/**/*.jade']

destinations =
  assets: "#{GLOBALS.BUILD_DIR}"
  styles: "#{GLOBALS.BUILD_DIR}/css"
  scripts: "#{GLOBALS.BUILD_DIR}/js"
  templates: "#{GLOBALS.BUILD_DIR}"
  livereload: [
    "#{GLOBALS.BUILD_DIR}/assets/**"
    "#{GLOBALS.BUILD_DIR}/css/**"
    "#{GLOBALS.BUILD_DIR}/fonts/**"
    "#{GLOBALS.BUILD_DIR}/img/**"
    "#{GLOBALS.BUILD_DIR}/js/**"
    "#{GLOBALS.BUILD_DIR}/templates/**"
    "#{GLOBALS.BUILD_DIR}/*.html"
  ]

options =
  httpPort: 4400
  riddlePort: 4400


gulp.task 'clean', ->
  gulp.src(GLOBALS.BUILD_DIR, read: false)
    .pipe(clean(force: true))


gulp.task 'bower:install', shell.task('bower install')


gulp.task 'assets:ejs', ->
  gulp.src(paths.assets_ejs)
    .pipe((plumber (error) ->
      gutil.log gutil.colors.red(error.message)
      @emit('end')
    ))
    .pipe(ejs(GLOBALS, ext: ''))
    .pipe(gulp.dest(destinations.assets))

gulp.task 'assets:others', ->
  gulp.src(paths.assets)
    .pipe(changed(destinations.assets))
    .pipe(gulp.dest(destinations.assets))

gulp.task 'assets', ['assets:ejs', 'assets:others']


gulp.task 'styles', ->
  gulp.src(paths.styles)
    .pipe(changed(destinations.styles, extension: '.css'))
    .pipe((plumber (error) ->
      gutil.log gutil.colors.red(error.message)
      @emit('end')
    ))

    .pipe(sourcemaps.init())
      .pipe(sass())
    .pipe(sourcemaps.write())

    .on('error', notify.onError((error) -> error.message))
    .pipe(gulp.dest(destinations.styles))


uploadSourcemapsToRollbar = ->
  isEnabled = !!(GLOBALS.UPLOAD_SOURCEMAPS_TO_ROLLBAR && GLOBALS.ROLLBAR_SERVER_ACCESS_TOKEN)
  gulpIf(isEnabled, rollbar({
    accessToken: (GLOBALS.ROLLBAR_SERVER_ACCESS_TOKEN ? "none")
    version: GLOBALS.CODE_VERSION
    sourceMappingURLPrefix: GLOBALS.ROLLBAR_SOURCEMAPS_URL_PREFIX + "/js"
  }))

gulp.task 'scripts:vendor', ->
  gulp.src(paths.scripts.vendor)

    .pipe(sourcemaps.init())
      .pipe(concat('vendor.js'))
      .pipe(uploadSourcemapsToRollbar())
    .pipe(sourcemaps.write('./'))

    .pipe(gulp.dest(destinations.scripts))


# Define scripts:app, scripts:bootstrap tasks
['app', 'bootstrap'].forEach (scriptsName) ->
  gulp.task "scripts:#{scriptsName}", ->
    gulp.src(paths.scripts[scriptsName])
      .pipe((plumber (error) ->
        gutil.log gutil.colors.red(error.message)
        @emit('end')
      ))

      .pipe(sourcemaps.init())
        .pipe(coffee())
        .pipe(concat("#{scriptsName}.js"))
        .pipe(uploadSourcemapsToRollbar())
      .pipe(sourcemaps.write('./'))

      .pipe(gulp.dest(destinations.scripts))


gulp.task 'scripts', ['scripts:vendor', 'scripts:app', 'scripts:bootstrap']


gulp.task 'templates', ->
  template_globals = {}
  for key in PUBLIC_GLOBALS_KEYS
    template_globals[key] = GLOBALS[key] if GLOBALS[key]?

  gulp.src(paths.templates)
    .pipe((plumber (error) ->
      gutil.log gutil.colors.red(error.message)
      @emit('end')
    ))
    .pipe(jade({
      locals:
        GLOBALS: template_globals
      pretty: true
    }))
    .on('error', notify.onError((error) -> error.message))
    .pipe(gulp.dest(destinations.templates))

    .pipe(templateCache("app_templates.js", {
      module: GLOBALS.ANGULAR_APP_NAME
      base: (file) ->
        file.path
          .replace(path.resolve("./"), "")
          .replace("/www/", "")
    }))
    .pipe(gulp.dest(destinations.scripts))

phantomChild = null
phantomDefer = null

# standalone test server which runs in the background.
# doesnt work atm - instead, run `webdriver-manager start`
gulp.task 'test:e2e:server', (cb) ->
  return cb() if phantomDefer
  phantomDefer = Q.defer()

  phantomChild = child_process.spawn('phantomjs', ['--webdriver=4444'], {
  })
  phantomChild.stdout.on 'data', (data) ->
    gutil.log gutil.colors.yellow data.toString()
    if data.toString().match 'running on port '
      phantomDefer.resolve()

  phantomChild.once 'close', ->
    gutil.log "phantomChild closed"
    phantomChild.kill() if phantomChild
    phantomDefer.reject()

  phantomChild.on 'exit', (code) ->
    gutil.log "phantomChild exitted"
    phantomChild.kill() if phantomChild

  phantomDefer.promise

# You can run it like this:
# `gulp test:e2e` - runs all e2e tests
# `gulp test:e2e --debug --specs test/map_test.coffee` - runs only one test, in debug mode
gulp.task 'test:e2e', ->
  args = ['--baseUrl', "http://localhost:#{options.httpPort}"]
  args.push 'debug' if gulp.env.debug

  protractorTests = paths.scripts.tests
  protractorTests = gulp.env.specs.split(',') if gulp.env.specs

  gulp.src(protractorTests)
    .pipe(protractor.protractor({
      configFile: "test/e2e/protractor.config.js",
      args: args
    }))
    .on('error', (notify.onError((error) -> error.message)))

# Runs unit tests using karma.
# You can run it simply using `gulp test:unit`.
# You can also pass some karma arguments like this: `gulp test:unit --browsers Chrome`.
gulp.task 'test:unit', ->
  args = ['start', 'test/unit/karma.conf.coffee']
  for name in ['browsers', 'reporters']
    args.push "--#{name}", "#{gulp.env[name]}" if gulp.env.hasOwnProperty(name)

  child_process.spawn "node_modules/.bin/karma", args, stdio: 'inherit'


gulp.task 'watch', ->
  if process.env.GULP_WATCH_ASSETS # this makes some bug with descriptors on mac, so let's enable it only when specified ENV is defined
    gulp.watch(paths.assets, ['assets'])
  else
    gulp.watch(paths.watched_assets, ['assets'])
  gulp.watch(paths.assets_ejs, ['assets:ejs'])
  gulp.watch(paths.scripts.app, ['scripts:app'])
  gulp.watch(paths.scripts.bootstrap, ['scripts:bootstrap'])
  gulp.watch(paths.scripts.vendor, ['scripts:vendor'])
  gulp.watch(paths.styles, ['styles'])
  gulp.watch(paths.templates, ['templates'])

gulp.task 'livereload', ->
  livereloadServer = livereload()
  gulp.watch(destinations.livereload).on 'change', (file) ->
    livereloadServer.changed(file.path)


gulp.task 'emulator', ->
  ripple.emulate.start(options)
  gutil.log gutil.colors.blue "Ripple-Emulator listening on #{options.ripplePort}"
  if +GLOBALS.OPEN_IN_BROWSER
    url = "http://localhost:#{options.ripplePort}/?enableripple=cordova-3.0.0-HVGA"
    open(url)
    gutil.log gutil.colors.blue "Opening #{url} in the browser..."


gulp.task 'server', ->
  http.createServer(ecstatic(root: GLOBALS.BUILD_DIR)).listen(options.httpPort)
  gutil.log gutil.colors.blue "HTTP server listening on #{options.httpPort}"
  if +GLOBALS.OPEN_IN_BROWSER
    url = "http://localhost:#{options.httpPort}/"
    open(url)
    gutil.log gutil.colors.blue "Opening #{url} in the browser..."


gulp.task "weinre", ->
  [weinreHost, weinrePort] = GLOBALS.WEINRE_ADDRESS.split(":")

  args = ["--httpPort=#{weinrePort}", "--boundHost=#{weinreHost}"]
  child = child_process.spawn "node_modules/.bin/weinre", args,
    stdio: "inherit"
  # .on "exit", (code) ->
  #   child.kill() if child
  #   cb(code)

  if +GLOBALS.OPEN_IN_BROWSER
    open("http://#{weinreHost}:#{weinrePort}/client/#anonymous")
    gutil.log gutil.colors.blue "Opening weinre debugger in the browser..."



# Clean all cordova platforms, so they will need to be generated again.
gulp.task "cordova:clear", shell.task('rm -rf plugins/* platforms/*')

# Create cordova platform.
["ios", "android"].forEach (platform) ->
  gulp.task "cordova:platform-add:#{platform}", ['build'], shell.task("env \
      ANDROID_CROSSWALK_MODE=\"#{GLOBALS.ANDROID_CROSSWALK_MODE}\" \
      BUNDLE_ID=\"#{GLOBALS.BUNDLE_ID}\" \
      node_modules/.bin/cordova platform add #{platform}", ignoreErrors: true)

  # Build and emulate.
  gulp.task "cordova:emulate:#{platform}", ["cordova:platform-add:#{platform}", "build-debug"], shell.task("env \
      ANDROID_CROSSWALK_MODE=\"#{GLOBALS.ANDROID_CROSSWALK_MODE}\" \
      BUNDLE_NAME=\"#{GLOBALS.BUNDLE_NAME}\" \
      BUNDLE_VERSION=\"#{GLOBALS.BUNDLE_VERSION}\" \
      node_modules/.bin/cordova emulate #{platform}")

  # Build and run on connected device.
  gulp.task "cordova:run:#{platform}", ["cordova:platform-add:#{platform}", "build-debug"], shell.task("env \
      ANDROID_CROSSWALK_MODE=\"#{GLOBALS.ANDROID_CROSSWALK_MODE}\" \
      BUNDLE_NAME=\"#{GLOBALS.BUNDLE_NAME}\" \
      BUNDLE_VERSION=\"#{GLOBALS.BUNDLE_VERSION}\" \
      node_modules/.bin/cordova run #{platform} --device")

  # Same as cordova:run, but use release version, not debug.
  gulp.task "cordova:run-release:#{platform}", ["cordova:platform-add:#{platform}", "build"], shell.task("env \
      ANDROID_CROSSWALK_MODE=\"#{GLOBALS.ANDROID_CROSSWALK_MODE}\" \
      BUNDLE_NAME=\"#{GLOBALS.BUNDLE_NAME}\" \
      BUNDLE_VERSION=\"#{GLOBALS.BUNDLE_VERSION}\" \
      node_modules/.bin/cordova run #{platform} --device --release")

  # Build a release.
  gulp.task "cordova:build-release:#{platform}", ["cordova:platform-add:#{platform}", "build"], shell.task("env \
      ANDROID_CROSSWALK_MODE=\"#{GLOBALS.ANDROID_CROSSWALK_MODE}\" \
      BUNDLE_NAME=\"#{GLOBALS.BUNDLE_NAME}\" \
      BUNDLE_VERSION=\"#{GLOBALS.BUNDLE_VERSION}\" \
      IOS_PROVISIONING_PROFILE=\"#{GLOBALS.IOS_PROVISIONING_PROFILE}\" \
      node_modules/.bin/cordova build #{platform} --release" + ((" --device" if platform == "ios") || ""))


# Sign the release.
gulp.task "cordova:sign-release:android", []

gulp.task "cordova:sign-release:ios", shell.task("xcrun -sdk iphoneos PackageApplication \
  -v platforms/ios/build/device/#{GLOBALS.BUNDLE_NAME}.app \
  -o #{APP_ROOT}platforms/ios/#{GLOBALS.BUNDLE_NAME}.ipa \
  --embed #{GLOBALS.IOS_PROVISIONING_PROFILE}")


# Deploy the release's binary to webserver.
open_qrcode_cmd = (url) ->
  "curl -s --include \
  --request GET 'https://pierre2106j-qrcode.p.mashape.com/api?type=text&text=#{encodeURIComponent(url)}&ecl=L%20%7C%20M%7C%20Q%20%7C%20H&pixel=8&forecolor=000000&backcolor=ffffff' \
  --header \"X-Mashape-Authorization: xWzeUXHELgVCXp9L4iK3epFzvsTECUai\" | tail -n 1 | xargs open"

deploy_release_cmd = (from, to, to_url) ->
  "scp \
    #{from} #{to} \
    && echo \"App has been deployed to #{to_url} .\"\
    " + (if +GLOBALS.OPEN_IN_BROWSER then " && #{open_qrcode_cmd(to_url)}" else "")


# Android deployment
androidDeployReleaseTasks = []
androidReleaseFile = "platforms/android/ant-build/CordovaApp-release.apk"

if GLOBALS.TESTFAIRY_API_KEY
  gulp.task "deploy:testfairy:android", shell.task("""
    env \
    TESTFAIRY_API_KEY='#{GLOBALS.TESTFAIRY_API_KEY}' \
    TESTER_GROUPS='#{GLOBALS.TESTFAIRY_TESTER_GROUPS}' \
    utils/testfairy-upload.sh #{androidReleaseFile}
  """)
  androidDeployReleaseTasks.push "deploy:testfairy:android"

if GLOBALS.ANDROID_DEPLOY_APPBIN_PATH
  cmd = deploy_release_cmd androidReleaseFile, GLOBALS.ANDROID_DEPLOY_APPBIN_PATH, GLOBALS.ANDROID_DEPLOY_APPBIN_URL
  gulp.task "open-deploy:server:android", shell.task(open_qrcode_cmd(GLOBALS.ANDROID_DEPLOY_APPBIN_URL))
  gulp.task "deploy:server:android", shell.task(cmd)
  androidDeployReleaseTasks.push "deploy:server:android"

gulp.task "deploy:release:android", androidDeployReleaseTasks


# IOS deployment
iosDeployReleaseTasks = []
iosReleaseFile = "platforms/ios/#{GLOBALS.BUNDLE_NAME}.ipa"

if GLOBALS.TESTFLIGHT_API_TOKEN
  gulp.task "deploy:testflight:ios", shell.task("curl http://testflightapp.com/api/builds.json \
    -F file=@#{iosReleaseFile} \
    -F api_token='#{GLOBALS.TESTFLIGHT_API_TOKEN}' \
    -F team_token='#{GLOBALS.TESTFLIGHT_TEAM_TOKEN}' \
    -F notes='This build was uploaded via the upload API' \
    -F notify=True \
    -F distribution_lists='#{GLOBALS.TESTFLIGHT_DISTRIBUTION_LISTS}' \
  ")
  iosDeployReleaseTasks.push "deploy:testflight:ios"

if GLOBALS.IOS_DEPLOY_APPBIN_PATH
  cmd = deploy_release_cmd iosReleaseFile, GLOBALS.IOS_DEPLOY_APPBIN_PATH, GLOBALS.IOS_DEPLOY_APPBIN_URL
  gulp.task "deploy:server:ios", shell.task(cmd)
  iosDeployReleaseTasks.push "deploy:server:ios"

gulp.task "deploy:release:ios", iosDeployReleaseTasks


["ios", "android"].forEach (platform) ->
  # Build the release and deploys it to the HTTP server.
  gulp.task "release:#{platform}", (cb) ->
    runSequence "cordova:build-release:#{platform}", "cordova:sign-release:#{platform}", "deploy:release:#{platform}", cb


# Run set-debug as the first task, to enable debug version.
# Example: `gulp set-debug cordova:run:android`
gulp.task "set-debug", ->
  unless options.debug
    options.debug = true
    GLOBALS.BUNDLE_ID += ".debug"
    GLOBALS.BUNDLE_NAME += "Dbg"


gulp.task "build-debug", ["set-debug", "build"]


# Run this as a first task, to enable uploading sourcemaps to rollbar.
# By default it's being run in the "release" task.
gulp.task "deploy:rollbar-sourcemaps:enable", ->
  GLOBALS.UPLOAD_SOURCEMAPS_TO_ROLLBAR = true
gulp.task "deploy:rollbar-sourcemaps", ["deploy:rollbar-sourcemaps:enable", "scripts"]


gulp.task "build", (cb) ->
  runSequence ["clean", "bower:install"],
    [
      "assets"
      "styles"
      "scripts"
      "templates"
    ], cb


gulp.task "default", (cb) ->
  runSequence "build", ["watch", "server", "weinre", "livereload"], cb


["cordova:platform-add", "cordova:emulate", "cordova:run", "cordova:run-release", "cordova:build-release", "deploy:release"].forEach (task) ->
  if platform = GLOBALS.CORDOVA_PLATFORM
    gulp.task task, ["#{task}:#{platform}"]
  else
    gulp.task task, ->
      runSequence "#{task}:android", "#{task}:ios"


gulp.task "release", ->
  runSequence "deploy:rollbar-sourcemaps", "release:android", "release:ios"
