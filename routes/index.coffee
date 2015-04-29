express         = require 'express'
authentication  = require './authentication'

router = express.Router()

router.get '/', (req, res) ->
  res.render 'layout', title: req.app.get "title"

router.use '/authentication', authentication

module.exports = router
