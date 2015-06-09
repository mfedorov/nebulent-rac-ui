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

    rentAgreement: (rentalId)->
      channel = Backbone.Radio.channel 'app'
      channel.trigger 'show:rent-agreements', rentalId
      channel.trigger 'set:sidebar:active', 'rent-agreement'

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
      channel.trigger 'set:sidebar:active', 'customer'

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
      channel.trigger 'set:sidebar:active', 'vehicle'

    gpsTrackings: ->
      channel = Backbone.Radio.channel 'app'
      channel.trigger 'show:gps-trackings'
      channel.trigger 'set:sidebar:active', 'gps-trackings'
