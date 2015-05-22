define [],  ->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.RentAgreement extends Backbone.Model
      defaults:
        customer: ""
        vehicle: ""
        dailyRate: 50
        days: 2
      recalc: ->
        @set 'subtotal', @get('days')*@get('dailyRate')

  App.CarRentAgreement.RentAgreement
