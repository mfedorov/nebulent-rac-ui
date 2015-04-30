define ->

  class AppController extends Marionette.Controller

    index: ->
      channel = Backbone.Radio.channel 'app'
      orgData = $.cookie "org"

      if !orgData
        channel.trigger 'show:index'
      else
        console.log $.parseJSON(orgData)
        appConfig.set "orgData", orgData
        channel.trigger 'show:index'
        debugger
