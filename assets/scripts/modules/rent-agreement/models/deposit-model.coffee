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

      toJSON: (options)->
        if @attributes.customer?.get('contactID')?
          attributes = _.clone @attributes
          attributes.customer = contactID: @attributes.customer.get('contactID')
        attributes

      parse: (response, options)->
        @set 'customer', new CustomerModel() unless @get('customer')?.constructor.name is "CustomerModel"
        @set 'payment', new PaymentModel() unless @get('payment')?.constructor.name is "PaymentModel"

        @get('payment').set response.payment
        @get('customer').set response.customer

        response.payment  = @get 'payment'
        response.customer = @get 'customer'
        response


  App.CarRentAgreement.DepositModel
