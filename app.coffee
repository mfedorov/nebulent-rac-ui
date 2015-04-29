express       = require "express"
session       = require "express-session"
body_parser   = require "body-parser"
cookie_parser = require "cookie-parser"
passport      = require "passport"

app = express()

app.set "title", "RAC Client"
app.set "view engine", "jade"
app.use express.static "public"
app.use cookie_parser()
app.use body_parser.json()
app.use body_parser.urlencoded extended: true
app.use session
  secret:             process.env.SECRET_KEY
  resave:             true
  saveUninitialized:  true
app.use passport.initialize()
app.use passport.session()

app.use '/', require "./routes/index"

env = process.env.NODE_ENV || "development"

server = app.listen 3000, ->

  host = server.address().address
  port = server.address().port

  console.log "listening at http://#{host}:#{port}"
