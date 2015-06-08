define [
  './widget-item'
  './rental-dues'
], (WidgetItem, template)->

  App.module "Dashboard", (Module, App, Backbone, Marionette, $, _) ->

    class Module.RentalDuesWidgetItem extends WidgetItem
      template: template
      events:
        "click .view-tracking": "onViewTracking"
      templateHelpers:->
        tracking: @getGpsTracking()

      getGpsTracking:->
        @model.get('gpsTrackings').last()

      onViewTracking:(e)->
        e.preventDefault()
        channel = Backbone.Radio.channel "dashboard"
        channel.command "view:tracking", @getGpsTracking()

  App.Dashboard.RentalDuesWidgetItem
