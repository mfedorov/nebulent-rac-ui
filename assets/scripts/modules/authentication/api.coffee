define [
  './layout-view'
  './model'
  './module'
], (LayoutView) ->

  App.module "Authentication", (Module, App, Backbone, Marionette, $, _) ->

    API =

      getView: ->
        user = Module.getOption "user"
        new LayoutView model: user

      success: (data) ->
        window.location.href = window.location.origin

    Module.on 'start', ->
      channel = Backbone.Radio.channel 'authentication'
      channel.reply 'view', API.getView
      channel.on 'auth:success', (data)-> API.success(data)
      return

    return

  return
