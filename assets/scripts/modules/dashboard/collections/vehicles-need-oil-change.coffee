define ['./../models/vehicles-need-oil-change'], (model)->

  App.module "Dashboard", (Module, App, Backbone, Marionette, $, _) ->

    class Module.VehiclesNeedOilChangeCollection extends Backbone.Collection
      model: model

  App.Dashboard.VehiclesNeedOilChangeCollection
