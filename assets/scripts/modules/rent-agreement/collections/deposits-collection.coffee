define [
  './../models/deposit-model'
],  (DepositModel)->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.DepositCollection extends Backbone.Collection
      url:-> "api/deposits/active"
      model: DepositModel

      toArray: ->
        return [] unless @length
        result = _.filter @models, (deposit)-> deposit.get('status') is "ACTIVE"
        result = _.map result, (deposit)->
          id: deposit.get('itemID'), text: deposit.get('customer').get('lastName') + ", (" + deposit.get('itemID') + ")"
        result.unshift id: 0, text:""
        result

  App.CarRentAgreement.DepositCollection
