define [
  './../models/phone-model'
],  (PhoneModel)->

  App.module "Customers", (Module, App, Backbone, Marionette, $, _) ->

    class Module.PhonesCollection extends Backbone.Collection
      model: PhoneModel

      init:->
        @add new PhoneModel() unless @length


  App.Customers.PhonesCollection
