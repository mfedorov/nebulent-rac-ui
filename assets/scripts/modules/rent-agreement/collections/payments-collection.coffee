define [
  './../models/payment-model'
],  (PaymentModel)->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.PaymentsCollection extends Backbone.Collection
      model: PaymentModel

  App.CarRentAgreement.PaymentsCollection
