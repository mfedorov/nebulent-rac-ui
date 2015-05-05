define ['./../models/vehicles-need-inspections'], (model)->

  App.module "Dashboard", (Module, App, Backbone, Marionette, $, _) ->

    class Module.VehiclesNeedInspectionCollection extends Backbone.Collection
      model: model

  App.Dashboard.VehiclesNeedInspectionCollection
