define ->

  class AppController extends Marionette.Controller

    index: ->
      channel = Backbone.Radio.channel 'app'
      channel.trigger 'show:index'
