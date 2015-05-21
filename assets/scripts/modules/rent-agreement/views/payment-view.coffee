define [
  './payment-template'
], (template) ->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.PaymentView extends Marionette.ItemView
      className: "item-view deposit-payment-view"
      template: template

      bindings:
        '[name="deposit_amount"]': "amount"
        '[name="deposit_invoice_id"]': "invoiceID"
#        '[name="deposit_account_id"]': "accountID"
        '[name="deposit_reference"]': "reference"
        '[name="deposit_payment_type"]': "paymentType"

      onShow:->
        @stickit()



  App.CarRentAgreement.PaymentView
