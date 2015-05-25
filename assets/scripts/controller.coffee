define ->

  class AppController extends Marionette.Controller

    index: ->
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

    listCustomers: ->
      channel = Backbone.Radio.channel 'app'
      channel.trigger 'customers', 'list'
      channel.trigger 'set:sidebar:active', 'customers'

    customer: (cust_id)->
      channel = Backbone.Radio.channel 'app'
      channel.trigger 'customers', cust_id
      channel.trigger 'set:sidebar:active', 'customer'

    vehicles: ->
      channel = Backbone.Radio.channel 'app'
      channel.trigger 'show:vehicles', 'list'

    vehicle: (id)->
      channel = Backbone.Radio.channel 'app'
      channel.trigger 'show:vehicles', 'id'
