gulp = require 'gulp'
gutil = require 'gulp-util'
execSync = require 'execSync'


ENV_GLOBALS =
  defaults:
    BUNDLE_VERSION: "1.0.0"

    # Change to "1" if you want to use Crosswalk on Android.
    #
    # NOTE See hooks/after_platform_add/020_migrate_android_to_crosswalk.sh ,
    #      to configure it first.
    # NOTE You need to recreate platforms/android/ project whenever you change it
    #      (by running `run `gulp cordova:clear`).
    ANDROID_CROSSWALK_MODE: "0"

    AVAILABLE_PLATFORMS: ["ios", "android"]

    # The name of your angular app you're going to use in `angular.module("")`
    ANGULAR_APP_NAME: "ionicstarter"

    # Base path to this project's directory. Generated automatically.
    APP_ROOT: execSync.exec("pwd").stdout.trim() + "/"

    # By default, we compile all html/css/js files into www/ directory.
    BUILD_DIR: "www"

    # Marks the current code version. Used in uploading sourcemaps to Rollbar.
    # By default: sha-code of the recent git commit.
    CODE_VERSION: execSync.exec("git rev-parse HEAD").stdout.trim()

    CORDOVA_PLATFORM: null

    # Current timestamp, used to get rid of unwanted http 304 requests.
    DEPLOY_TIME: Date.now()

    # Used in server/weinre tasks as an actual IP for the server.
    HTTP_SERVER_IP: ->
      # Try to detect IP address in user's network.
      # If not, fallback to 127.0.0.1 .
      localIp = execSync.exec("(ifconfig wlan 2>/dev/null || ifconfig en0) | grep inet | grep -v inet6 | awk '{print $2}' | sed 's/addr://g'").stdout.trim()
      localIp = "127.0.0.1" unless parseInt(localIp) > 0
      localIp

    # By default, application runs on :4400 port.
    HTTP_SERVER_PORT: 4400

    # If true, we'll open the app in the browser after running the server.
    OPEN_IN_BROWSER: true

    # Report errors to Rollbar (rollbar.com)
    ROLLBAR_CLIENT_ACCESS_TOKEN: null # "aaa"
    ROLLBAR_SERVER_ACCESS_TOKEN: null # "bbb"

    # If you want to upload sourcemaps to Rollbar, just set a random URL prefix
    # (we'll modify payloads on iOS/Android so the URL to js scripts will be always the same)
    ROLLBAR_SOURCEMAPS_URL_PREFIX: "https://ionicstarter.com"

    # Important: leave it as false, even if you want to have the sourcemaps uploaded.
    # gulp.task("deploy:rollbar-sourcemaps") automatically sets it as true - only when it's needed.
    # (you want to upload them only on release tasks, don't you?)
    UPLOAD_SOURCEMAPS_TO_ROLLBAR: false

    # If defined, we'll deploy the app to testfairy after compiling the release.
    # TESTFAIRY_API_KEY: "123"
    # TESTFAIRY_TESTER_GROUPS: "IonicStarterTesters"

  development:
    ENV: "development"

    BUNDLE_ID: "com.jtomaszewski.ionicstarter.development"
    BUNDLE_NAME: "IonicStarterDev"

    # Automatically connect to weinre on application's startup
    # (this way you can debug your application on your PC even if it's running from mobile ;) )
    WEINRE_ADDRESS: ->
      "#{GLOBALS.HTTP_SERVER_IP}:31173"

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


GLOBALS = require('extend') true, {}, ENV_GLOBALS.defaults, (ENV_GLOBALS[gutil.env.env || "development"] || {})

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

PUBLIC_GLOBALS = {}
for key in PUBLIC_GLOBALS_KEYS
  PUBLIC_GLOBALS[key] = GLOBALS[key] if GLOBALS[key]?


module.exports = {GLOBALS, PUBLIC_GLOBALS}
