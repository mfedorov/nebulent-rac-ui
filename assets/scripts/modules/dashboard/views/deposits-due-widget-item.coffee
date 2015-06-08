define [
  './widget-item'
  './templates/deposits-due'
], (WidgetItem, template)->

  App.module "Dashboard", (Module, App, Backbone, Marionette, $, _) ->

    class Module.DepositsDueWidgetItem extends WidgetItem
      template: template

  App.Dashboard.DepositsDueWidgetItem
