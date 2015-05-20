define [
  './../collections/customer-collection'
  './../collections/vehicle-collection'
  './../collections/deposits-collection'
],  (CustomerCollection, VehicleCollection, DepositCollection)->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.OrganizationModel extends Backbone.Model
      url: -> "api/#{Module.model?.get('config').get('orgId')}"

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
