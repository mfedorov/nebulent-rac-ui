define [
  './../models/additional-driver-model'
  './customer-collection'
],  (AdditionalDriver, CustomerCollection)->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.AdditionalDriversCollection extends CustomerCollection
      model: AdditionalDriver

  App.CarRentAgreement.AdditionalDriversCollection
