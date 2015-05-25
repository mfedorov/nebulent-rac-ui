define [
  './../collections/vehicles-collection'
],  (VehicleCollection)->

  App.module "Vehicles", (Module, App, Backbone, Marionette, $, _) ->

    class Module.OrganizationModel extends Backbone.Model
      url: -> "api/#{Module.model?.get('config')?.get('orgId')}"

      defaults:
        vehicles:   new VehicleCollection()

      parse: (response, options) ->
        @get 'vehicles'
        .set response.vehicles

        response.vehicles  = @get 'vehicles'
        response

  App.Vehicles.OrganizationModel
