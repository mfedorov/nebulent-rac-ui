define [
  './payment-template'
], (template) ->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.PaymentView extends Marionette.ItemView
      className: "item-view deposit-payment-view"
      template: template

      behavior:
        Validation: {}

      bindings:
        '[name="deposit_amout"]':
          observe:"amount"
          setOptions:
            validate: true
#        '[name="deposit_invoice_id"]':  observe:"invoiceID"
#        '[name="deposit_account_id"]': "accountID"
        '[name="deposit_reference"]':   observe: "reference"
        '[name="deposit_payment_type"]':
          observe: "paymentType"
          selectOptions:
            collection: [{name:"ACCPAYPAYMENT"}, {name:"ACCRECPAYMENT"}]
            labelPath: 'name'
            valuePath: 'name'

      onShow:->
        @stickit()



  App.CarRentAgreement.PaymentView
