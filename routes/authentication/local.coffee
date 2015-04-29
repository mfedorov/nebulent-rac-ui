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
      passwordHash: password
  }, (error, response, body) ->
    console.log response.body,body
    if not error && response.statusCode is 200
      return done null, response.body
    else
      return done null, false

router.post '/sign-up', (req, res, next) ->
  request.post {
    url: "#{process.env.API_URL}/users"
    json:
      username: req.body.username
      password: req.body.password
  }, (error, response, body) ->
    if not error && response.statusCode is 200
      res.json username: response.body.username
    else
      res.json username: ""
    return

router.post '/sign-in', passport.authenticate('local'), (req, res, info) ->
  if req.user.id and req.user.username
    res.json
      id:       req.user.id
      username: req.user.username
  else
    res.status 401
    .end()
  return

router.put '/sign-out', ensureAuthenticated, (req, res, next) ->
  request.post {
    url: "#{process.env.API_URL}/users/logout"
    headers:
      "X-AUTH-TOKEN": req.user.authToken
  }, (error, response, body) ->
    if not error && response.statusCode is 200
      req.logout()
      res.json {}
    else
      if req.user
        res.json
          id:       req.user.id
          username: req.user.username
      else
        res.json {}
    return

module.exports = router
