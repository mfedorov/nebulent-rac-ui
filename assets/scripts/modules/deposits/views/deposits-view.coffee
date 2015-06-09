define [
  './templates/deposits-template'
  './deposit-row-view'
],  (template, DepositRowView) ->

  App.module "Deposits", (Module, App, Backbone, Marionette, $, _) ->

    class Module.DepositsView extends Marionette.CompositeView
      className:          "layout-view deposits"
      template:           template
      childView:          DepositRowView
      childViewContainer: ".row-container"
      headerItems:        ['#', 'Customer', 'Amount', 'Date', 'Actions']
      dataTableId:        "deposits"

      childViewOptions: (model, index) ->
        index: index

      templateHelpers: ->
        header:       @headerItems
        dataTableId:  @dataTableId
        count:        @collection.length

  App.Deposits.DepositsView
