define [
  './widget-item'
  './gps-tracking-template'
], (WidgetItem, template)->

  App.module "Dashboard", (Module, App, Backbone, Marionette, $, _) ->

    class Module.GpsTrackingWidgetItem extends WidgetItem
      template: template

      events:
        "click .view-tracking": "onViewTracking"

      onViewTracking:(e)->
        e.preventDefault()
        channel = Backbone.Radio.channel "dashboard"
        channel.command "view:tracking", @model

  App.Dashboard.GpsTrackingWidgetItem
