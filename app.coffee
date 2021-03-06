express = require("express")
path = require("path")
favicon = require("serve-favicon")
logger = require("morgan")
routes = require("./routes/index")
helpers = require("./middleware/view-helpers")
serveStatic = require("serve-static")
compression = require('compression')
app = express()

# view engine setup
app.set "views", path.join(__dirname, "views")
app.set "view engine", "jade"
#app.use favicon()
app.use compression()
app.use serveStatic(path.join(__dirname, "build"), index: false)
app.use serveStatic(path.join(__dirname, "public"), index: false)
app.use helpers("Mikko Kivelä")
app.use "/", routes

#/ catch 404 and forwarding to error handler
app.use (req, res, next) ->
  res.status(404)
  res.render("errors/404")
  return


#/ error handlers

# development error handler
# will print stacktrace
if app.get("env") is "development"
  app.use (err, req, res, next) ->
    res.status err.status or 500
    res.render "error",
      message: err.message
      error: err

    return


# production error handler
# no stacktraces leaked to user
app.use (err, req, res, next) ->
  res.status err.status or 500
  res.render("errors/500")
  return

module.exports = app
