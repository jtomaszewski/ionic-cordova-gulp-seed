app = angular.module("ionicstarter")


# Turn off $log.debug on production
app.config ($logProvider, $compileProvider) ->
  if GLOBALS.ENV == "production"
    $logProvider.debugEnabled(false)
    $compileProvider.debugInfoEnabled(false)


app.config ($httpProvider) ->
  # Combine multiple $http requests into one $applyAsync (boosts performance)
  $httpProvider.useApplyAsync(true)

  # Add support for PATCH requests
  $httpProvider.defaults.headers.patch ||= {}
  $httpProvider.defaults.headers.patch['Content-Type'] = 'application/json'

  # Send API version code in header (might be useful in future)
  $httpProvider.defaults.headers.common["X-Api-Version"] = "1.0"

  $httpProvider.interceptors.push ($injector, $q, $log, $location) ->
    responseError: (response) ->
      $log.debug "httperror: ", response.status unless GLOBALS.ENV == "test"

      # Sign out current user if we receive a 401 status.
      if response.status == 401
        $injector.invoke (Auth) ->
          Auth.setAuthToken(null)

      $q.reject(response)


ionic.Platform.ready ->
  app.config (googleAnalyticsCordovaProvider) ->
    if GLOBALS.CORDOVA_GOOGLE_ANALYTICS_ID
      googleAnalyticsCordovaProvider.debug = GLOBALS.ENV != 'production'
      googleAnalyticsCordovaProvider.trackingId = GLOBALS.CORDOVA_GOOGLE_ANALYTICS_ID


# Turn off animations on Android and iOS 6 devices.
# More info: http://ionicframework.com/docs/nightly/api/provider/%24ionicConfigProvider/
app.config ($ionicConfigProvider) ->
  unless ionic.Platform.grade == "a"
    $ionicConfigProvider.views.transition("none")
    $ionicConfigProvider.views.maxCache(2)


ionic.Platform.ready ->
  # Now, finally, let's run the app
  # (this is the reason why we don't include ng-app in the index.jade)
  angular.bootstrap document, ['ionicstarter']


# Useful for debugging, like `$a("$rootScope")`
app.run ($window, $injector) ->
  $window.$a = $injector.get


app.run ($rootScope, Auth, $window, $timeout) ->
  console.log 'Ionic app has just started (app.run)!' unless GLOBALS.ENV == "test"

  # Make GLOBALS visible in every scope.
  $rootScope.GLOBALS = GLOBALS

  $timeout ->
    # Finally, let's show the app, by hiding the splashscreen
    navigator.splashscreen?.hide()
