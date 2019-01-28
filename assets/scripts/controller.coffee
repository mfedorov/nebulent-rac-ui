define ->

  class AppController extends Marionette.Controller

    index: ->
      channel = Backbone.Radio.channel 'app'
      apiKey = localStorage.getItem 'apiKey'
      regExp = new RegExp('^/login', 'i')
      if regExp.test(window.location.pathname)
        channel.trigger 'show:index'
      else
        return window.location.href = window.location.origin + "/login" if !apiKey
        channel.trigger 'show:dashboard'

    rentAgreement: (rentalId)->
      channel = Backbone.Radio.channel 'app'
      channel.trigger 'show:rent-agreements', rentalId
      channel.trigger 'set:sidebar:active', 'rent-agreements'

    listRentAgreements: ->
      channel = Backbone.Radio.channel 'app'
      channel.trigger 'show:rent-agreements', "list"
      channel.trigger 'set:sidebar:active', 'rent-agreements'

    listCustomers: ->
      channel = Backbone.Radio.channel 'app'
      channel.trigger 'show:customers', 'list'
      channel.trigger 'set:sidebar:active', 'customers'

    customer: (customerId)->
      channel = Backbone.Radio.channel 'app'
      channel.trigger 'show:customers', customerId
      channel.trigger 'set:sidebar:active', 'customers'

    listDeposits: ->
      channel = Backbone.Radio.channel 'app'
      channel.trigger 'show:deposits', 'list'
      channel.trigger 'set:sidebar:active', 'deposits'

    deposit: (depositId)->
      channel = Backbone.Radio.channel 'app'
      channel.trigger 'show:deposits', depositId
      channel.trigger 'set:sidebar:active', 'deposits'

    listVehicles: ->
      channel = Backbone.Radio.channel 'app'
      channel.trigger 'show:vehicles', 'list'
      channel.trigger 'set:sidebar:active', 'vehicles'

    vehicle: (vehicleId)->
      channel = Backbone.Radio.channel 'app'
      channel.trigger 'show:vehicles', vehicleId
      channel.trigger 'set:sidebar:active', 'vehicles'

    gpsTrackings: ->
      channel = Backbone.Radio.channel 'app'
      channel.trigger 'show:gps-trackings'
      channel.trigger 'set:sidebar:active', 'gps-trackings'
