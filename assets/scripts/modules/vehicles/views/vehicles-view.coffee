define [
  './vehicles-template'
], (template)->

  App.module "Vehicles", (Module, App, Backbone, Marionette, $, _) ->

    class Module.VehiclesView extends Marionette.CompositeView
      class: 'composite-view vehicles'
      template: template

  App.Vehicles.VehiclesView
