{GLOBALS} = require "./globals.coffee"

PATHS =
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
    ]
    app_run: [
      'app/js/app_run.coffee' # app.config; app.run
    ]
    tests:
      e2e: [
        'test/e2e/*_test.coffee'
      ]
  templates: ['app/**/*.jade']

DESTINATIONS =
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
    "#{GLOBALS.BUILD_DIR}/*.html"
  ]

module.exports = {PATHS, DESTINATIONS}
