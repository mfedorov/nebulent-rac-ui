define [],  ->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.PaymentModel extends Backbone.Model
      defaults:
        amount:       "200"
        invoiceID:    ""
        accountID:    ""
        reference:    ""
        currencyRate: ""
#        paymentType:  ""
#        status:       ""

      validation:
        amount:
          required: true


  App.CarRentAgreement.PaymentModel
