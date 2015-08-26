define [
  './../models/customer-model'
  './customer-collection'
],  (CustomerModel, CustomerCollection)->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.AdditionalDriversCollection extends CustomerCollection

  App.CarRentAgreement.AdditionalDriversCollection
