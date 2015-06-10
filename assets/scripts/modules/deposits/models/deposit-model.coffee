define [
  './payment-model'
  './customer-model'
],  (PaymentModel, CustomerModel)->

  App.module "Deposits", (Module, App, Backbone, Marionette, $, _) ->

    class Module.DepositModel extends Backbone.Model
      idAttribute: "itemID"

      defaults: ->
        description:    "RENTAL DEPOSIT"
        code:           "DEPOSIT"
        salesDetails:   null
        purchaseDetails:null
        customer:       new CustomerModel()
        location:       null
        payment:        new PaymentModel()
        credit:         null
        notes:          []
        properties:     []
        incidentIds:    []
        orgId:          null
        takenOn:        moment().unix()*1000
        status:         "ACTIVE"

      validation:
        customer:
          required: true
        payment:
          depositPaymentAmount: 1
        code:
          required: true

      parse: (response, options)->
        @set 'customer', new CustomerModel() unless @get('customer')?.constructor.name is "CustomerModel"
        @set 'payment', new PaymentModel() unless @get('payment')?.constructor.name is "PaymentModel"

        @get('payment').set response.payment
        @get('customer').set response.customer

        response.payment  = @get 'payment'
        response.customer = @get 'customer'
        response


  App.Deposits.DepositModel
