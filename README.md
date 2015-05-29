# Features
[![Gitter](https://badges.gitter.im/Join Chat.svg)](https://gitter.im/jtomaszewski/ionic-cordova-gulp-seed?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

* Application can be run in a local http server, or emulated/released to Android/iOS
* A lot of useful gulp tasks, like:
  * `gulp` - watch for changes + browser-sync (http server with livereload) + weinre debugger
  * `gulp cordova:emulate:ios` - run application in iOS emulator
  * `gulp cordova:run:android` - run application on Android's devise
  * Run `gulp help` or see `gulp/tasks.coffee` for more information about all tasks
* Useful hooks and tweaks, which allow you to deploy your cordova app out-of-the-box
* SASS + CoffeeScript + Jade combo
* Support for multiple environments, like *development, staging, production* (configuration available in `gulpfile.coffee`)
* Tests configured and working: unit (karma + mocha) and end to end (protractor)
* Rollbar support (configured, working in angular functions and support for uploading the sourcemaps to Rollbar server)

# Requirements

* NodeJS
* Cordova 4.2+
* Android or iOS SDK installed and [configured](http://docs.phonegap.com/en/4.0.0/guide_platforms_index.md.html#Platform%20Guides) (required only if you want to deploy the app to native mobile platforms - you can run `gulp` server without that)


# How to install

```
git clone jtomaszewski/ionicstarter-mobile
cd ionicstarter-mobile
git submodule update --init --recursive

# install dependencies
npm install
npm install -g gulp
bower install
brew install imagemagick # or `apt-get install imagemagick`, if you're on linux

gulp # build www/ directory and run http server on 4440 port
```

If you get "too many files" error, try: `ulimit -n 10000`. You may want to add this line to your .bashrc / .zshrc / config.fish.


## What does the `gulp build` do?

More or less:

* All .scss, .coffee, .jade files from `app/` will be compiled and copied to `www/`
* All `.ejs` files from `assets/` will be compiled to `www/`.
* All other files from `assets/` will be copied to `www/`.

For detailed description, see `gulpfile.coffee`.

P.S. `www/` is like `dist/` directory for Cordova. That's why it's not included in this repository, as it's fully generated with `gulp`.


## Testing

Requirements: installed PhantomJS and configured [selenium standalone webdriver](https://github.com/angular/protractor/blob/master/docs/getting-started.md#setup-and-config).

#### Unit tests (karma & PhantomJS/Chrome)

```
gulp test:unit # using PhantomJS
gulp test:unit --browsers Chrome # or using Google Chrome
```

#### e2e tests (protractor & selenium)

```
gulp # your www/ directory should be built and served at :4400 port
node_modules/.bin/webdriver-manager start & # run selenium server in the background

gulp test:e2e # finally, run e2e tests
```


# How to run on mobile?

I recommend [tmux](http://tmux.sourceforge.net/) for handling multiple terminal tabs/windows ;)

1. Copy `.envrc.android-sample` or `.envrc.ios-sample` to `.envrc` and configure it.

  * Ofcourse, if you're a Mac user and you can compile both Android and iOS on the same machine, you can include all the variables from both of these files in only one `.envrc` .

  * Also, make sure you have all the keys and certificates needed stored in `keys/android/` and `keys/ios/`:

    * `keys/android/ionicstarter.keystore`
    * `keys/ios/ionicstarter_staging.mobileprovision`
    * `keys/ios/ionicstarter_production.mobileprovision`

2. Ensure, you have [configured ios/android platform with Cordova](http://cordova.apache.org/docs/en/edge/guide_cli_index.md.html), f.e. by running `gulp cordova:platform-add:[ios|android]`.

3. Run `gulp cordova:emulate:[ios|android]` or `gulp cordova:run:[ios|android]`.

# Releasing to appstores

First, generate the certificate keys:

#### Android

1. [Generate .keystore file](http://developer.android.com/tools/publishing/app-signing.html):
`keytool -genkey -v -keystore keys/android/$ANDROID_KEYSTORE_NAME.keystore -alias $ANDROID_ALIAS_NAME -keyalg RSA -keysize 2048 -validity 10000`

#### iPhone

1. Create a certificate and a provisioning profile, as it's described [here](http://docs.build.phonegap.com/en_US/3.3.0/signing_signing-ios.md.html#iOS%20Signing).

2. Download the provisioning profile and copy it into `keys/ios/`, so it will match the `IOS_PROVISIONING_PROFILE` file set up in the `gulpfile.coffee`.

Then, generate the application and deploy it to the webserver with:

```
gulp release:[ios|android] --env=[staging|production]
```
