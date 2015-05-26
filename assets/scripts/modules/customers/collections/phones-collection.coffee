define [
  './../models/address-model'
],  (AddressModel)->

  App.module "Customers", (Module, App, Backbone, Marionette, $, _) ->

    class Module.PhonesCollection extends Backbone.Collection
      model: AddressModel

      init:->
        @add new AddressModel() unless @length


  App.Customers.PhonesCollection
