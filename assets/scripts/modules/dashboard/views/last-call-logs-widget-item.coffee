define [
  './widget-item'
  './templates/last-call-logs'
], (WidgetItem, template)->

  App.module "Dashboard", (Module, App, Backbone, Marionette, $, _) ->

    class Module.LastCallLogsWidgetItem extends WidgetItem
      template: template

  App.Dashboard.LastCallLogsWidgetItem
