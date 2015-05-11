define [], ->

  App.module "Dashboard", (Module, App, Backbone, Marionette, $, _) ->

    class Module.VehiclesNeedInspection extends Backbone.Model
      idAttribute: 'itemID'

  App.Dashboard.VehiclesNeedInspection
