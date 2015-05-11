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

        #sending data back to main layout view
#        channel = Backbone.Radio.channel 'app'
#        channel.trigger "loggedin", data

        window.location.href = window.location.origin

    Module.on 'start', ->
      channel = Backbone.Radio.channel 'authentication'
      channel.reply 'view', API.getView
      channel.on 'auth:success', (data)-> API.success(data)
      return

    return

  return
