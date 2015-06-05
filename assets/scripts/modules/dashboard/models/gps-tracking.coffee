define [
  './address-model'
  './vehicle-model'
], (AddressModel, VehicleModel)->

  App.module "Dashboard", (Module, App, Backbone, Marionette, $, _) ->

    class Module.GpsTracking extends Backbone.Model

      defaults: ->
        address:                    new AddressModel()
        vehicle:                    new VehicleModel()
        distanceFromRentalLocation: null
        externalSerialNumber:       null
        heading:                    null
        orgId:                      null
        rentalId:                   null
        nullspeed:                  null
        trackedOn:                  null

      parse: (response, options) ->
        @set @defaults()

        @get 'address'
        .set response.address
        @get 'vehicle'
        .set response.vehicle

        response.address             = @get 'address'
        response.vehicle             = @get 'vehicle'

        response

  App.Dashboard.GpsTracking
