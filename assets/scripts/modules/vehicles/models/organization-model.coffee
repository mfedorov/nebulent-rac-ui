define [
  './../collections/vehicles-collection'
  './../collections/location-collection'
],  (VehicleCollection, LocationCollection)->

  App.module "Vehicles", (Module, App, Backbone, Marionette, $, _) ->

    class Module.OrganizationModel extends Backbone.Model
      url: -> App.ApiUrl()

      defaults:
        vehicles:   new VehicleCollection()
        locations:  new LocationCollection()

      parse: (response, options) ->
        @get 'vehicles'
        .set response.vehicles
        @get 'locations'
        .set response.locations

        response.vehicles  = @get 'vehicles'
        response.locations  = @get 'locations'
        response

  App.Vehicles.OrganizationModel
