define [
  './layout-view'
  './model'
  './module'
], (LayoutView) ->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    API =

      getView: ->
        model = new Module.Model
        Module.config = model

        new LayoutView model: model


    Module.on 'start', ->
      channel = Backbone.Radio.channel 'rent-agreement'
      channel.reply 'view', API.getView
      return

    return

  return
