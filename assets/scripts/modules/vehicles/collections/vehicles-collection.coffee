define [
  './../models/vehicle-model'
], (VehicleModel)->

  App.module "Vehicles", (Module, App, Backbone, Marionette, $, _) ->

    class Module.VehicleCollection extends Backbone.Collection
      model: VehicleModel

  App.Vehicles.VehicleCollection
