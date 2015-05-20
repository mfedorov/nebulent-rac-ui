request   = require "request"
express   = require 'express'
httpProxy = require 'http-proxy'
router    = express.Router()
proxy     = httpProxy.createProxyServer()

router.all '/:orgId*', (req, res, next) ->
  proxy.web req, res, { target: "#{process.env.API_URL}/rac/orgs/"}

module.exports = router

