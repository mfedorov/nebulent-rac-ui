express   = require 'express'
router    = express.Router()

ensureAuthenticated = (req, res, next) ->
  if req.isAuthenticated()
    next()
  else
    res.sendStatus 401

router.all '/api', ensureAuthenticated, (req, res) ->
  res.json
    id:       req.user.id
    username: req.user.username

api = require './api'
router.use '/api', api

module.exports = router
