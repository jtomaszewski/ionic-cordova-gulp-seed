# It will equal to the root path of the directory where index.html is located.
# f.e. "file:///android_assets/www/" or "http://localhost/"
GLOBALS.APP_ROOT = (location.origin + location.pathname).replace("index.html", "")
