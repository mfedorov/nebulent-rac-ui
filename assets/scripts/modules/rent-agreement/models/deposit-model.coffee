define [
  './payment-model'
],  (PaymentModel)->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.DepositModel extends Backbone.Model
      url:->
        debugger
        "api/#{Module.model.get('config').get('orgId')}/customers/#{@get('customer').contactID}/deposits"
      idAttribute: "itemID"
      defaults:
        description:    "RENTAL DEPOSIT"
        code:           "DEPOSIT"
        salesDetails:   null
        purchaseDetails:null
        customer:       null
        location:       null
        payment:        new PaymentModel()
        credit:         null
        notes:          []
        properties:     []
        incidentIds:    []
        orgId:          null
        returnedOn:     null
        takenOn:        moment().unix()*1000
        status:         "ACTIVE"

      parse: (response, options)->
        @set('payment', new PaymentModel()) unless @get('payment')
        @get 'payment'
        .set response.payment

        response.payment = @get 'payment'
        response

  App.CarRentAgreement.DepositModel
