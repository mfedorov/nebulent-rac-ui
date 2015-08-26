define [
  './../models/phone-model'
],  (PhoneModel)->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.PhonesCollection extends Backbone.Collection
      model: PhoneModel

      init:->
        @add new PhoneModel() unless @length


  App.CarRentAgreement.PhonesCollection
