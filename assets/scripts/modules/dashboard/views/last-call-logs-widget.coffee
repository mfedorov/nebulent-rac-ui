define [
  './widget'
  './last-call-logs-widget-item'
], (WidgetView, LastCallLogsWidgetItem)->

  App.module "Dashboard", (Module, App, Backbone, Marionette, $, _) ->

    class Module.LastCallLogsWidget extends WidgetView
      childView:    LastCallLogsWidgetItem
      title:        'Last 24 hours of call logs'
      dataTableId:  'last_call_logs'
      headerItems:  ['#', 'Call date/time', 'From', 'To', 'Duration', 'Status']
      icon:         'fa-phone-square'

  App.Dashboard.LastCallLogsWidget
