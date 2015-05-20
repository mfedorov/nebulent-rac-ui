request   = require "request"
express   = require 'express'
httpProxy = require 'http-proxy'
router    = express.Router()
proxy     = httpProxy.createProxyServer()


proxy.on 'proxyReq', (proxyReq, req, res, options)->
  proxyReq.setHeader('host', process.env.HOST)
#  proxyReq.setHeader('rac-apikey', 'ZP524DwHgBLxB9BcCQsVidWJp0r6uXCZ')
  proxyReq.end JSON.stringify req.body


router.all '/:orgId*', (req, res, next) ->
  proxy.web req, res, { target: "#{process.env.API_URL}/rac/orgs/"}

module.exports = router

