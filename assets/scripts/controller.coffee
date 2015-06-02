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


    rentAgreement: (id)->

      console.log id
      channel = Backbone.Radio.channel 'app'
      channel.trigger 'show:rent-agreements', id
      channel.trigger 'set:sidebar:active', 'rent-agreement'

    rentAgreements: ->
      channel = Backbone.Radio.channel 'app'
      channel.trigger 'show:rent-agreements', "list"
      channel.trigger 'set:sidebar:active', 'rent-agreements'

    listCustomers: ->
      channel = Backbone.Radio.channel 'app'
      channel.trigger 'show:customers', 'list'
      channel.trigger 'set:sidebar:active', 'customers'

    customer: (cust_id)->
      channel = Backbone.Radio.channel 'app'
      channel.trigger 'show:customers', cust_id
      channel.trigger 'set:sidebar:active', 'customer'

    vehicles: ->
      channel = Backbone.Radio.channel 'app'
      channel.trigger 'show:vehicles', 'list'
      channel.trigger 'set:sidebar:active', 'vehicles'

    vehicle: (id)->
      channel = Backbone.Radio.channel 'app'
      channel.trigger 'show:vehicles', 'id'
      channel.trigger 'set:sidebar:active', 'vehicle'
