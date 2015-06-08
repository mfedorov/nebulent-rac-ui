define [
  './widget-item'
  './templates/vehicles-need-oil-change'
], (WidgetItem, template)->

  App.module "Dashboard", (Module, App, Backbone, Marionette, $, _) ->

    class Module.VehiclesNeedOilChangeWidgetItem extends WidgetItem
      template: template

  App.Dashboard.VehiclesNeedOilChangeWidgetItem
