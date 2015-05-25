define [
  './layout-view'
  './model'
  './module'
], (LayoutView) ->

  App.module "Customers", (Module, App, Backbone, Marionette, $, _) ->

    API =

      getView: ->
        model = new Module.Model
        Module.model = model
        new LayoutView model: model


    Module.on 'start', ->
      channel = Backbone.Radio.channel 'customers'
      channel.reply 'customers-view', API.getView
      return

    return

  return
