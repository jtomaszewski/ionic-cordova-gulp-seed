app = angular.module(GLOBALS.ANGULAR_APP_NAME)

for k, v of GLOBALS
  app.constant k, v

# Make GLOBALS visible in every scope.
app.run ($rootScope) ->
  $rootScope.GLOBALS = GLOBALS
