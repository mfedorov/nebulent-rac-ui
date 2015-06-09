define [
  './../collections/customer-collection'
  './../collections/vehicle-collection'
  './../collections/deposits-collection'
  './../collections/location-collection'
],  (CustomerCollection, VehicleCollection, DepositCollection, LocationCollection)->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.OrganizationModel extends Backbone.Model
      url: -> "api/#{Module.model?.get('config').get('orgId')}"

      defaults:
          vehicles:   new VehicleCollection()
          customers:  new CustomerCollection()
          deposits:   new DepositCollection()
          locations:  new LocationCollection()

      parse: (response, options) ->
        @get 'vehicles'
        .set response.vehicles
        @get 'locations'
        .set response.locations

        response.vehicles  = @get 'vehicles'
        response.locations  = @get 'locations'
        response

  App.CarRentAgreement.OrganizationModel
