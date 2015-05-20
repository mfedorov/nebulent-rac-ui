define [],  ->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.RentAgreement extends Backbone.Model
      defaults:
        customer: ""
        vehicle: ""

  App.CarRentAgreement.RentAgreement
