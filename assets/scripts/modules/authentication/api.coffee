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

      success: (provider) ->
        channel = Backbone.Radio.channel 'global'
        user = channel.requset 'user'
        user.fetch()

      failure: (provider) ->
        console.error "Failed to login with #{provider}"

    Module.on 'start', ->
      channel = Backbone.Radio.channel 'authentication'
      channel.reply 'view', API.getView
      return

    return

  return
