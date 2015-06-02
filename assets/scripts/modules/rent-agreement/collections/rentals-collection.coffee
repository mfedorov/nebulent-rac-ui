define [
  './../models/rent-agreement'
],  (RentAgreement)->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.RentalsCollection extends Backbone.Collection
      url:-> "api/#{Module.model?.get('config').get('orgId')}/rentals?asc=false"
      model: RentAgreement

  App.CarRentAgreement.RentalsCollection
