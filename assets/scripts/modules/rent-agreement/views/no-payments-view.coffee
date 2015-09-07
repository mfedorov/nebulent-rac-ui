define [
  './templates/no-payments-template'
], (template) ->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.NoPaymentsView extends Marionette.ItemView
      className:  "item-view no-payments-view"
      template:   template
      tagName:    "tr"

  App.CarRentAgreement.NoPaymentsView
