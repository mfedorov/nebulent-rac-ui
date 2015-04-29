require [
  'app'
  'layout-view'
  'router'
  'controller'
], (
  App,
  AppLayoutView,
  AppRouter,
  AppController
) ->

  window.App = new App()
  window.App.on 'start', ->
    new AppLayoutView().render()
    new AppRouter controller: new AppController()
    Backbone.history.start()

  $.ajaxSetup
    statusCode:
      401: ->
        channel = Backbone.Radio.channel 'user'
        channel.trigger "unauthorized"
      404: (response, status, error) ->

  require [
#    "modules/alerts/api"
    "modules/authentication/api"
#    "modules/command-line/api"
#    "modules/configurations/api"
#    "modules/tabbed/api"
#    "modules/tools/api"
#    "modules/tools/search/api"
#    "modules/tools/search/input/api"
#    "modules/tools/search/results/api"
#    "modules/tools/visualizer/api"
#    "modules/tools/editor/params/api"
#    "modules/user/module"
#    "modules/user/configurations/api"
#    "modules/user/tools/api"
#    "modules/user/favorites/api"
  ], ->
    window.App.start()
    return
