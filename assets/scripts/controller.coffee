define ->

  class AppController extends Marionette.Controller

    index: ->
      channel = Backbone.Radio.channel 'app'
      $orgData = $.cookie("org")

      unless $orgData?.length
        channel.trigger 'show:index'
      else
        data = $.parseJSON $orgData
        channel.trigger 'loggedin', org: data
