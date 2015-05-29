define [
  './payment-model'
  './customer-model'
],  (PaymentModel, CustomerModel)->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.DepositModel extends Backbone.Model
      url:->
        debugger
        "api/#{Module.model.get('config').get('orgId')}/customers/#{@get('customer').get('contactID')}/deposits"
      idAttribute: "itemID"
      defaults:
        description:    "RENTAL DEPOSIT"
        code:           "DEPOSIT"
        salesDetails:   null
        purchaseDetails:null
        customer:       null
        location:       null
        payment:        null
        credit:         null
        notes:          []
        properties:     []
        incidentIds:    []
        orgId:          null
        takenOn:        moment().unix()*1000
        status:         "ACTIVE"

      initialize:->
        @set "customer", new CustomerModel(), silent: true
        @set "payment", new PaymentModel(), silent: true
        super

      parse: (response, options)->
        @set 'payment', new PaymentModel(response.payment)
        @set 'customer', new CustomerModel(response.customer)

        response.payment  = @get 'payment'
        response.customer = @get 'customer'
        response


  App.CarRentAgreement.DepositModel
