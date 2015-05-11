define [], ->

  App.module "Dashboard", (Module, App, Backbone, Marionette, $, _) ->

    class Module.VehiclesNeedOilChange extends Backbone.Model
      idAttribute: 'itemID'

  App.Dashboard.VehiclesNeedOilChange
