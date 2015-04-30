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
        #saving data in cookies
        $.cookie("org", JSON.stringify(
          apikey: data.org.apikey
          id:     data.org.id
        ));
        channel = Backbone.Radio.channel 'app'
        appConfig.set "orgData", data
        channel.trigger "show:dashboard", data

    Module.on 'start', ->
      channel = Backbone.Radio.channel 'authentication'
      channel.reply 'view', API.getView
      channel.on 'auth:success', (data)-> API.success(data)
      return

    return

  return
