passport  = require "passport"
express   = require 'express'
router    = express.Router()

passport.serializeUser (user, done) ->
  done null, user

passport.deserializeUser (user, done) ->
  done null, user

ensureAuthenticated = (req, res, next) ->
  if req.isAuthenticated()
    next()
  else
    res.sendStatus 401

router.get '/', ensureAuthenticated, (req, res) ->
  res.json
    id:       req.user.id
    username: req.user.username

local = require './local'
router.use '', local

module.exports = router
