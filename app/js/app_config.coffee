# ==> Initialize angular's app.
app = angular.module("ionicstarter", [
  "ionic"
  "angulartics.google.analytics"
  "angulartics.google.analytics.cordova"
])

GLOBALS.APP_ROOT = location.href.replace(location.hash, "").replace("index.html", "")

for k, v of GLOBALS
  app.constant k, v


if window.Rollbar?
  app.factory '$exceptionHandler', ($log) ->
    (e, cause) ->
      $log.error e.message
      Rollbar.error(e)

  Rollbar.configure
    payload:
      deploy_time: GLOBALS.DEPLOY_TIME
      deploy_date: moment(GLOBALS.DEPLOY_TIME).format()
      bundle_name: GLOBALS.BUNDLE_NAME
      bundle_version: GLOBALS.BUNDLE_VERSION

    transform: (payload) ->
      if frames = payload.data?.body?.trace?.frames
        for frame in frames
          frame.filename = frame.filename.replace(GLOBALS.APP_ROOT, "#{GLOBALS.ROLLBAR_SOURCEMAPS_URL_PREFIX}/")


# To debug, go to http://localhost:31173/client/#anonymous
if GLOBALS.WEINRE_ADDRESS && (ionic.Platform.isAndroid() || ionic.Platform.isIOS())
  addElement document, "script", id: "weinre-js", src: "http://#{GLOBALS.WEINRE_ADDRESS}/target/target-script-min.js#anonymous"
