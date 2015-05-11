define ->

  class AppController extends Marionette.Controller

    index: ->
      debugger
      channel = Backbone.Radio.channel 'app'
      $orgData = $.cookie("org")

      unless $orgData?.length
        if window.location.pathname is '/login'
          channel.trigger 'show:index'
        else
          window.location.href = window.location.origin + "/login"
      else
        data = $.parseJSON $orgData
        channel.trigger 'loggedin', org: data


    newAgreement: ->
      channel = Backbone.Radio.channel 'app'
      channel.trigger 'rent-agreement'