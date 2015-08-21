define [
  './templates/deposit-rentals-template'
  './rent-agreement-row-view'
  './rent-agreements-view'
],  (template, RentAgreementRowView, RentAgreementsView) ->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.DepositRentalsView extends RentAgreementsView
      className:          "layout-view deposit-rent-agreements"
      template:           template
      headerItems:        ['#', 'First Name', 'Last Name', 'License #', 'Vehicle Color', 'Vehicle Year', 'Vehicle Make', 'Vehicle Model', 'Vehicle Plate #', 'Days', 'Due Date', 'Total', 'Amount Due', 'Status']
      dataTableId:        "deposit-rent-agreements"

      childViewOptions: (model, index) ->
        index:          index
        actionsEnabled: false

  App.CarRentAgreement.DepositRentalsView
