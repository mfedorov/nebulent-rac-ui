define ['./collections/rentals-collection', './module'], (RentalsCollection)->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.Model extends Backbone.Model
      defaults:
        rentals: new RentalsCollection()

  App.CarRentAgreement.Model
