passport  = require "passport"
local     = require "passport-local"
request   = require "request"
express   = require 'express'
router    = express.Router()

ensureAuthenticated = (req, res, next) ->
  if req.isAuthenticated()
    return next()
  else
    res.send 401

LocalStrategy  = local.Strategy

passport.use new LocalStrategy (username, password, done) ->
  request.post {
    url: "#{process.env.API_URL}/public/login"
    json:
      username: username
      passwordHash: new Buffer(password).toString('base64')
  }, (error, response, body) ->
    if not error && response.statusCode is 200
      return done null, response.body
    else
      return done null, false

router.post '/sign-in', passport.authenticate('local'), (req, res, info) ->
  if req.user.id
    req.session.org_id = req.user.id
    req.session.api_key = req.user.apikey
    res.json
      id:       req.user.id
      org:      req.user
  else
    res.status 401
    .end()
  return

module.exports = router
