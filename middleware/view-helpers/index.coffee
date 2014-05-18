url = require("url")
jade = require("jade")
path = require("path")

isCurrent = (req, href) ->
  req.url is url.resolve(req.url, href)

isMobile = (req) ->
  false

currentPage = (req) ->
  pathname = url.parse(req.url).pathname
  return "index-page" if pathname is "/"
  pathname.slice(1).split("/").join("-") + "-page"

navItem = (req, text, href, options = {}) ->
  classNames = []
  classNames.push "current" if isCurrent(req, href)
  classNames.push options["class"] if options["class"]
  locals =
    text: text or "N/A"
    href: href or "#"
    title: options.title or "Go to #{text.toLowerCase()} page"
    className: classNames.join " "
  template = jade.renderFile(path.join(__dirname, "templates", "nav_item.jade"),
    locals)
  template

helpers = (appName) ->

  (req, res, next) ->
    res.locals.appName = appName
    res.locals.title = appName
    res.locals.isCurrent = (href) -> isCurrent(req, href)
    res.locals.isMobile = -> isMobile(req)
    res.locals.currentPage = -> currentPage(req)
    res.locals.navItem = (text, href, options) ->
      navItem(req, text, href, options)
    next()

module.exports = helpers
