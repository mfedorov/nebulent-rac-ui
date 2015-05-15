define [
  './../models/vehicle-model'
],  (VehicleModel)->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.VehicleCollection extends Backbone.Collection
      model: VehicleModel

  App.CarRentAgreement.VehicleCollection
