define ->

  class AppController extends Marionette.Controller

    index: ->
      channel = Backbone.Radio.channel 'app'
      if appConfig.get("org").length == 0
        channel.trigger 'show:index'
      else
        channel.trigger 'show:dashboard'
