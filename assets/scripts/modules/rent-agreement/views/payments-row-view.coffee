define [
  './templates/payments-row-template'
], (template)->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.PaymentsRowView extends Marionette.ItemView
      className: "collection-view item-view"
      tagName:   'tr'
      template:  template

  App.CarRentAgreement.PaymentsRowView
