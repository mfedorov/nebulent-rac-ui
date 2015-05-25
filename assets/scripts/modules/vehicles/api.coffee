define [
  './layout-view'
  './model'
  './module'
], (LayoutView) ->

  App.module "Vehicles", (Module, App, Backbone, Marionette, $, _) ->

    API =

      getView: ->
        model = new Module.Model
        Module.model = model

        new LayoutView model: model

    Module.on 'start', ->
      channel = Backbone.Radio.channel 'vehicles'
      channel.reply 'view', API.getView
      return

    return

  return
