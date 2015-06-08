define [
  './widget-item'
  './templates/rental-dues'
], (WidgetItem, template)->

  App.module "Dashboard", (Module, App, Backbone, Marionette, $, _) ->

    class Module.RentalDuesWidgetItem extends WidgetItem
      template: template
      events:
        "click .view-tracking": "onViewTracking"

      onViewTracking:(e)->
        e.preventDefault()
        channel = Backbone.Radio.channel "dashboard"
        channel.command "view:rental:movements", @model.get('gpsTrackings')

  App.Dashboard.RentalDuesWidgetItem
