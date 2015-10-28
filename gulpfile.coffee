gulp        = require "gulp"
jade        = require "gulp-jade"
sass        = require "gulp-sass"
sourcemaps  = require "gulp-sourcemaps"
coffee      = require "gulp-coffee"
concat      = require "gulp-concat"
nodemon     = require "gulp-nodemon"
wrap        = require "gulp-wrap-amd"
notify      = require "gulp-notify"
del         = require "del"
amdOptimize = require "amd-optimize"
es          = require "event-stream"
dotenv      = require "dotenv"
_           = require "underscore"
pjson       = require "./package"
dotenv.load()

env = process.env.NODE_ENV || "development"

default_dependencies = ["stylesheets", "fonts", "images", "scripts"]
if env is "development"
  default_dependencies.push "watch"

paths =
  stylesheets:  "assets/stylesheets/**/*"
  images:       "assets/img/**/*.*"
  vendor_js:    ["assets/scripts/vendor/**/*", "#{pjson.browser.requirejs}.js"]
  vendor_swf:   "assets/vendor/**/*.swf"
  coffee:       "assets/scripts/**/*.coffee"
  jade:         "assets/scripts/**/*.jade"

gulp.task 'stylesheets', ->
  gulp.src "assets/stylesheets/index.scss"
    .pipe sass includePaths: ['./node_modules/bootstrap-sass/assets/stylesheets']
      .on "error", notify.onError (error) ->
        "Error: #{error.message}"
    .pipe gulp.dest './public/stylesheets/'

gulp.task 'fonts',  ->
  gulp.src './node_modules/bootstrap-sass/assets/fonts/**/*'
    .pipe gulp.dest 'public/fonts/'

gulp.task "images", ["cleanImages"], ->
  gulp.src paths.images
    .pipe gulp.dest "public/img/"

gulp.task "cleanImages", (cb) ->
  del ['public/img'], cb

gulp.task "scripts", ["cleanScripts"], ->

  templates = gulp.src paths.jade
    .pipe jade client: true
    .pipe wrap deps: ['runtime'], params: ['jade']
    .pipe gulp.dest "public/scripts/"

  app = gulp.src paths.coffee
    .pipe coffee()
    .pipe gulp.dest "public/scripts/"

  vendor = gulp.src paths.vendor_js
    .pipe gulp.dest "public/scripts/vendor/"

  vendor_swf = gulp.src paths.vendor_swf
    .pipe gulp.dest "public/scripts/"

  amdOptimize_options =
    findNestedDependencies: true
    wrapShim: true
    paths:
      "runtime":                  "./public/scripts/vendor/runtime"
      "backbone.radio.shim":      "./public/scripts/vendor/backbone.radio.shim"
      "bootstrap-growl":          "./public/scripts/vendor/jquery.bootstrap-growl"
      "backbone.select":           "./public/scripts/vendor/backbone.select"
      "handlebars":               "./public/scripts/vendor/handlebars"
      "toastr":                   "./public/scripts/vendor/toastr"
      "jquery-cookie":            "./public/scripts/vendor/jquery-cookie"
      "metronic":                 "./public/scripts/vendor/metronic/metronic"
      "layout":                   "./public/scripts/vendor/metronic/layout"
      "quick-sidebar":            "./public/scripts/vendor/metronic/quick-sidebar"
      "demo":                     "./public/scripts/vendor/metronic/demo"
      "backstretch":              "./public/scripts/vendor/jquery.backstretch"
      "datatables":               "./public/scripts/vendor/jquery.dataTables"
      "datatables-bootstrap":     "./public/scripts/vendor/metronic/dataTables.bootstrap"
      "amcharts":                 "./public/scripts/vendor/amcharts/amcharts"
      "pieChart":                 "./public/scripts/vendor/amcharts/pie"
      "select2":                  "./public/scripts/vendor/select2.full"
      "moment":                   "./public/scripts/vendor/moment"
      "bootstrap-datetimepicker": "./public/scripts/vendor/metronic/bootstrap-datetimepicker"
      "iCheck":                   "./public/scripts/vendor/icheck.min"
      "backbone.paginator":       "./public/scripts/vendor/backbone.paginator"
      "bootbox":                  "./public/scripts/vendor/metronic/bootbox.min"
    shim:
      "jquery-ui":
        deps: ['jquery']
      bootstrap:
        deps: ['jquery', 'jquery-ui']
      "bootstrap-growl":
        deps: ['bootstrap']
      "backbone.picky":
        deps: ['backbone']
       "datatables-bootstrap":
        deps: ['jquery','datatables']

  _.extend amdOptimize_options.paths, pjson.browser

  es.merge vendor, app, templates, vendor_swf
    .pipe amdOptimize "main", amdOptimize_options
    .pipe concat "index.js"
    .pipe gulp.dest "public/scripts/"

gulp.task "cleanScripts", (cb) ->
  del 'public/scripts', cb

gulp.task "watch", ->
  gulp.watch paths.stylesheets, ["stylesheets"]
  gulp.watch paths.images, ["images"]
  gulp.watch paths.coffee, ["scripts"]
  gulp.watch paths.jade, ["scripts"]
  return

gulp.task "cleanPublic", ->
  gulp.src 'public', read: false
    .pipe clean force: true

gulp.task "default", default_dependencies, ->
  if env is 'development'
    ignore = ['./assets/', './public/']

    nodemon
      script: "app.coffee"
      ignore: ignore
      # nodeArgs: ['--nodejs', '--debug']
      # node inspector is running on http://127.0.0.1:8080/debug?port=5858

  return
