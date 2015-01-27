module.exports = (config) ->
  config.set
    basePath: '../../'
    frameworks: ['mocha', 'chai', 'chai-as-promised', 'sinon-chai', 'chai-things']

    # list of files / patterns to load in the browser
    files: [
      "www/js/vendor.js"
      "assets/components/angular-mocks/angular-mocks.js"

      "test/unit/tests-config.coffee"

      # "www/js/app.js"
      # This is a concatenated list of all scripts from gulpfile.coffee
      # (we need to keep it up to date with it).
      'app/js/config/**/*.coffee'
      'app/js/*/**/*.coffee'
      'app/js/routes.coffee'
      "www/js/app_templates.js"

      "test/unit/helpers/**/*.coffee"
      "test/unit/**/*.coffee"
    ]

    exclude: [
      "test/unit/karma.conf.coffee"
    ]

    # use dots reporter, as travis terminal does not support escaping sequences
    # possible values: 'dots', 'progress'
    # CLI --reporters progress
    # reporters: ['progress']

    autoWatch: true

    # f.e. Chrome, PhantomJS
    browsers: ['PhantomJS']

    reporters: ['osx', 'progress']

    preprocessors:
      '**/*.coffee': ['coffee']

    coffeePreprocessor:
      options:
        bare: true
        sourceMap: true

      # transformPath: (path) ->
      #   path.replace(/\.coffee$/, '.js')
