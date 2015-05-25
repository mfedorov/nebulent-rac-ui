define [
  './vehicle-template'
], (template)->

  App.module "Vehicles", (Module, App, Backbone, Marionette, $, _) ->

    class Module.VehicleView extends Marionette.ItemView
      class: 'item-view vehicle'
      template: template

  App.Vehicles.VehicleView
