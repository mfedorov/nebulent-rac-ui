# Making sure app process is running from root directory
# even if it was launched somewhere else
process.chdir __dirname

express       = require "express"
session       = require "express-session"
body_parser   = require "body-parser"
cookie_parser = require "cookie-parser"
passport      = require "passport"
FileStore     = require("session-file-store")(session)
favicon       = require 'serve-favicon'
dotenv        = require "dotenv"
path          = require 'path'
staticDir     = 'public';

dotenv.load()
app = express()

app.set "title", "RAC Client"
app.set "view engine", "jade"
app.use express.static "public"
app.use favicon(__dirname + '/public/img/favicon.ico')
app.use cookie_parser()
app.use body_parser.json()
app.use body_parser.urlencoded extended: true
app.use session
   store:              new FileStore(ttl: 5184000)
   secret:             process.env.SECRET_KEY
   resave:             true
   saveUninitialized:  true
app.use passport.initialize()
app.use passport.session()

app.use '/', require "./routes/index"

env = process.env.NODE_ENV || "development"
console.log(express.static);
app.use(express.static(path.join(__dirname, staticDir)));


server = app.listen 3000, ->

  host = server.address().address
  port = server.address().port

  console.log "listening at http://#{host}:#{port}"
