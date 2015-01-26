# mocha.setup
#   bail: false
#   ignoreLeaks: true

window.GLOBALS =
  ENV: 'test'

beforeEach module('ionicstarter')

afterEach ->
  inject ($httpBackend) ->
    $httpBackend.verifyNoOutstandingRequest()
    $httpBackend.verifyNoOutstandingExpectation()

  sessionStorage.clear()
  localStorage.clear()

