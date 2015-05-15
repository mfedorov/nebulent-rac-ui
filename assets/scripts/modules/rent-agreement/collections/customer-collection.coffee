define [
  './../models/customer-model'
],  (CustomerModel)->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.CustomerCollection extends Backbone.Collection
      url:->
        "api/#{Module.model?.get('config').get('orgId')}/customers?asc=true&api_key=#{Module.model?.get('config').get('apiKey')}"

      model: CustomerModel

  App.CarRentAgreement.CustomerCollection
