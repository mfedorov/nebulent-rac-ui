define ['./../models/vehicle-model'], (model)->

  App.module "Dashboard", (Module, App, Backbone, Marionette, $, _) ->

    class Module.VehicleCollection extends Backbone.Collection
      model: model

  App.Dashboard.VehicleCollection
