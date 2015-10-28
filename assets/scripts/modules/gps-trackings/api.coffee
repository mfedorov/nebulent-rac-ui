define [
  './layout-view'
  './views/one-car-view'
  './model'
  './module'
], (LayoutView, OneCarView) ->

  App.module "GpsTrackings", (Module, App, Backbone, Marionette, $, _) ->

    API =

      getView: ->
        menu = new Module.Model
        Module.dashboard = menu

        new LayoutView model: menu

      getOneCarView: (model)->
        new OneCarView model: model

    Module.on 'start', ->
      channel = Backbone.Radio.channel 'gps-trackings'
      channel.reply 'view', API.getView
      channel.reply 'one:car:view', API.getOneCarView
      return

    return

  return
