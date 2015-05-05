define [
  './widget'
  './deposits-due-widget-item'
], (WidgetView, DepositsDueWidgetItem)->

  App.module "Dashboard", (Module, App, Backbone, Marionette, $, _) ->

    class Module.DepositsDueWidget extends  WidgetView
      childView:    DepositsDueWidgetItem
      title:        'Deposits due'
      dataTableId:  'deposits_due'
      headerItems:  ['#', 'Name', 'Driver License', 'Deposit taken', 'Date']
      icon:         'fa-money'

  App.Dashboard.DepositsDueWidget
