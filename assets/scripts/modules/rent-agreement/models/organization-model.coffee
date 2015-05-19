define [
  './../collections/customer-collection'
  './../collections/vehicle-collection'
  './../collections/deposits-collection'
],  (CustomerCollection, VehicleCollection, DepositCollection)->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.OrganizationModel extends Backbone.Model
      url: -> "api/#{@get('config').get('orgId')}?api_key=#{@get('config').get('apiKey')}"

      defaults:
          vehicles:   new VehicleCollection()
          customers:  new CustomerCollection()
          deposits:   new DepositCollection()

      parse: (response, options) ->
        @get 'vehicles'
        .set response.vehicles

        response.vehicles  = @get 'vehicles'
        response

  App.CarRentAgreement.OrganizationModel
