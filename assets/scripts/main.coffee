require [
  'app'
  'layout-view'
  'router'
  'controller'
  './helpers/data_helper'
  'app-config'
], (
  App,
  AppLayoutView,
  AppRouter,
  AppController,
  DataHelper,
  AppConfig
) ->
  window.App = new App()
  window.App.DataHelper = DataHelper
  window.App.on 'start', ->
    new AppLayoutView().render()
    window.App.Router = new AppRouter controller: new AppController()
    Backbone.history.start()

  $.ajaxSetup
    statusCode:
      401: ->
        channel = Backbone.Radio.channel 'user'
        channel.trigger "unauthorized"
      404: (response, status, error) ->

  require [
    "modules/authentication/api"
    "modules/dashboard/api"
    "modules/top-menu/api"
    "modules/rent-agreement/api"
    "modules/sidebar-menu/api"
    "modules/customers/api"
    "modules/vehicles/api"
    "modules/gps-trackings/api"
  ], ->
    window.App.start()
    return
