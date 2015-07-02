define [], ->

  App.module "Dashboard", (Module, App, Backbone, Marionette, $, _) ->

    class Module.VehicleModel extends Backbone.Model
      idAttribute: 'itemID'

  App.Dashboard.VehicleModel
