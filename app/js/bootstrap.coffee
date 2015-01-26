# ==> App-wide global useful functions
# Generate a DOM element and append it to container.
# Usage example:
# ```coffee
# addElement document, "script", id: "facebook-jssdk", src: "facebook-js-sdk.js"
# ```
@addElement = (container, tagName, attrs = {}) ->
  return container.getElementById(attrs.id) if attrs.id && container.getElementById(attrs.id)

  fjs = container.getElementsByTagName(tagName)[0]
  tag = container.createElement(tagName)
  for k, v of attrs
    tag[k] = v
  fjs.parentNode.insertBefore tag, fjs
  tag


# Debug helper
@log = -> console.log arguments


# ==> Add setObject and getObject methods to Storage prototype (used f.e. by localStorage).
Storage::setObject = (key, value) ->
  @setItem(key, JSON.stringify(value))

Storage::getObject = (key) ->
  return unless value = @getItem(key)
  JSON.parse(value)


# ==> Some app-wide useful globals.
window.GLOBALS  ?= {}
ionic.Platform.ready ->
  console.log 'ionic.Platform is ready!' unless GLOBALS.ENV == "test"
