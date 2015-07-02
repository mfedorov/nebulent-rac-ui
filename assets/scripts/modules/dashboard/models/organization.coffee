define [
  './../collections/vehicle-collection'
], (VehicleCollection) ->

  App.module "Dashboard", (Module, App, Backbone, Marionette, $, _) ->

    class Module.OrganizationModel extends Backbone.Model
      url: -> "api"

      defaults:
        vehicles:   new VehicleCollection()

      parse: (response, options) ->
        @get 'vehicles'
        .set response.vehicles

        response.vehicles  = @get 'vehicles'
        response


  App.Dashboard.OrganizationModel
