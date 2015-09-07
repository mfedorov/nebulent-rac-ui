define [
  './templates/payments-list-template'
  './payments-row-view'
  './no-payments-view'
], (template, PaymentsRowView, NoPaymentsView)->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.PaymentListView extends Marionette.CompositeView
      className:          "collection-view payment-list-view"
      template:           template
      childView:          PaymentsRowView
      childViewContainer: "tbody"
      emptyView:          NoPaymentsView
      tableColumnNames:   ['Created', 'Amount', 'Reference', 'Type', 'Status']

      templateHelpers: ->
        columnNames: @tableColumnNames

  App.CarRentAgreement.PaymentListView
