define [
  './templates/deposit-rentals-template'
  './rent-agreement-row-view'
  './rent-agreements-view'
],  (template, RentAgreementRowView, RentAgreementsView) ->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.DepositRentalsView extends RentAgreementsView
      className:          "layout-view deposit-rent-agreements"
      template:           template
      headerItems:        ['#', 'Invoice #', 'Customer', 'Vehicle', 'Days', 'Due Date', 'Total', 'Status']
      dataTableId:        "deposit-rent-agreements"

      childViewOptions: (model, index) ->
        index:          index
        actionsEnabled: false

  App.CarRentAgreement.DepositRentalsView
