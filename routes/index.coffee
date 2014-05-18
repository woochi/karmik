express = require("express")
router = express.Router()

router.get "/", (req, res) ->
  res.render "index"

router.get "/work", (req, res) ->
  res.render "work"

router.get "/hire", (req, res) ->
  res.render "hire"

router.post "/hire", (req, res) ->
  res.redirect "/hire"

module.exports = router
