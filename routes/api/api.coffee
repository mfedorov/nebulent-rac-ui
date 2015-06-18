request   = require "request"
express   = require 'express'
httpProxy = require 'http-proxy'
router    = express.Router()
proxy     = httpProxy.createProxyServer()

ensureAuthenticated = (req, res, next) ->
  if req.isAuthenticated()
    next()
  else
    res.sendStatus 401

proxy.on 'proxyReq', (proxyReq, req, res, options)->
  proxyReq.setHeader('host', process.env.HOST)
  proxyReq.setHeader('rac-apikey', req.session.api_key)
  proxyReq.end JSON.stringify req.body

proxy.on 'error', (e)-> console.log e

router.all '*', ensureAuthenticated, (req, res, next) ->
  proxy.web req, res, { target: "#{process.env.API_URL}/rac/orgs/#{req.session.org_id}/"}


module.exports = router

