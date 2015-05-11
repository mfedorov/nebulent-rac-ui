express         = require 'express'
authentication  = require './authentication'
api             = require './api'

router          = express.Router()

router.get '/', (req, res) ->
  res.render 'layout', title: req.app.get "title"

router.get '/login', (req, res) ->
  res.render 'authentication', title: req.app.get "title"

router.use '/authentication', authentication

router.use '', api

module.exports = router
