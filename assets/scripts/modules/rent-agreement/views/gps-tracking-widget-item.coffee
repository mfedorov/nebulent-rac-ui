define [
  './widget-item'
  './templates/gps-tracking-template'
], (WidgetItem, template)->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.GpsTrackingWidgetItem extends WidgetItem
      template: template

      events:
        "click .view-tracking": "onViewTracking"

      templateHelpers:->
        index: @index

      initialize: (options)->
        @index     = options.index
        @initiator = options.initiator

      onViewTracking:(e)->
        e.preventDefault()
        return @initiator.$el.trigger('show:tracking', @model) if @initiator
        channel = Backbone.Radio.channel "rent-agreements"
        channel.command "show:rental:tracking", @model

  App.CarRentAgreement.GpsTrackingWidgetItem
