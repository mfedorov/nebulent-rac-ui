define [
  './../models/deposit-model'
],  (DepositModel)->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.DepositCollection extends Backbone.Collection
      url:->
        "api/#{Module.model?.get('config').get('orgId')}/deposits?api_key=#{Module.model?.get('config').get('apiKey')}"

      model: DepositModel

  App.CarRentAgreement.DepositCollection
