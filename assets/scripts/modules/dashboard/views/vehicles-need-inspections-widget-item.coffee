define [
  './widget-item'
  './templates/vehicles-need-inspections'
], (WidgetItem, template)->

  App.module "Dashboard", (Module, App, Backbone, Marionette, $, _) ->

    class Module.VehiclesNeedInspectionWidgetItem extends WidgetItem
      template: template

  App.Dashboard.VehiclesNeedInspectionWidgetItem
