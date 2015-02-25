express = require("express")
path = require("path")
favicon = require("serve-favicon")
logger = require("morgan")
routes = require("./routes/index")
helpers = require("./middleware/view-helpers")
app = express()

# view engine setup
app.set "views", path.join(__dirname, "views")
app.set "view engine", "jade"
#app.use favicon()
app.use express.static(path.join(__dirname, "build"))
app.use helpers("Mikko Kivelä")
app.use "/", routes

#/ catch 404 and forwarding to error handler
app.use (req, res, next) ->
  err = new Error("Not Found")
  err.status = 404
  next err
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
  res.render "error",
    message: err.message
    error: {}

  return

module.exports = app
