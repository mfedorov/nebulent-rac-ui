require [
  'app'
  'layout-view'
  'router'
  'controller'
  './helpers/data_helper'
], (
  App,
  AppLayoutView,
  AppRouter,
  AppController,
  DataHelper,
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
        console.log "Unauthorized"
        toastr.error "Unauthorized"
        window.location.href = window.location.origin + "/login"
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
    "modules/deposits/api"
    "modules/notes/api"
  ], ->
    window.App.start()
    return
