window.liveReloadTools =
  checkServerConnection: (origin) ->
    console.debug "Calling liveReloadTools.checkServerConnection for #{origin}"
    new Promise (resolve, reject) ->
      request = new XMLHttpRequest()
      request.addEventListener "load", (event) ->
        if event.loaded
          resolve(event)
        else
          reject(event)
      request.addEventListener "error", reject
      request.addEventListener "abort", reject
      request.open('GET', "#{origin}/config.xml?_t=#{Math.random()}")
      request.send()

  redirectToServer: (origin) ->
    console.debug "Calling liveReloadTools.redirectToServer for #{origin}"
    return if GLOBALS.APP_ROOT == "#{origin}/"

    liveReloadTools.checkServerConnection(origin)
    .then ->
      console.debug "BrowserSync server has been found! (#{origin})"
      window.location.href = "#{origin}/index.html?referer=#{encodeURIComponent(GLOBALS.APP_ROOT)}"
    .catch ->

referer = URI(window.location.href).query(true)?.referer || ''

# document.addEventListener "DOMContentLoaded", ->
#   if window.location.href.indexOf("?referer=") != -1
#     console.debug "'?referer=' query parameter found. Altering all .cordova-script script tags ..."
#     referer = URI(window.location.href).query(true).referer

if window.location.protocol == "file:" || referer.indexOf("file:") == 0
  console.debug "'file://' protocol found in location.href . Adding cordova.js script to <HEAD> ..."
  scriptElement = document.createElement("script")
  scriptElement.id = "cordova-js"
  scriptElement.src = "cordova.js"
  document.querySelector("head").appendChild(scriptElement)

GLOBALS.HTTP_SERVER_ORIGIN = "http://#{GLOBALS.HTTP_SERVER_IP}:#{GLOBALS.HTTP_SERVER_PORT}" if GLOBALS.HTTP_SERVER_IP && GLOBALS.HTTP_SERVER_PORT
liveReloadTools.redirectToServer(GLOBALS.HTTP_SERVER_ORIGIN) if GLOBALS.HTTP_SERVER_ORIGIN
