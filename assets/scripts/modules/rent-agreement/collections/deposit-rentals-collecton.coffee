define [
  './../models/rent-agreement'
],  (RentAgreement)->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.DepositRentalsCollection extends Backbone.PageableCollection
      model: RentAgreement

      setUrl: (depositId)->
        @url = "api/deposits/#{depositId}/rentals"

  App.CarRentAgreement.DepositRentalsCollection
