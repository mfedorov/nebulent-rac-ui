define [
  './layout-view'
  './model'
  './module'
], (LayoutView) ->

  App.module "Dashboard", (Module, App, Backbone, Marionette, $, _) ->

    API =

      getView: ->
        dashboard = new Module.Model
        Module.dashboard = dashboard

        new LayoutView model: dashboard


    Module.on 'start', ->
      channel = Backbone.Radio.channel 'dashboard'
      channel.reply 'view', API.getView
      return

    return

  return
