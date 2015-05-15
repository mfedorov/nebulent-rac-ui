define [
  './../models/address-model'
],  (AddressModel)->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.AddressCollection extends Backbone.Collection
      model: AddressModel

      init:->
        @add new AddressModel() unless @length

  App.CarRentAgreement.AddressCollection
