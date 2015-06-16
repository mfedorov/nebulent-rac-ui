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

      onShow:->
        if moment().format(App.DataHelper.dateFormats.us) is moment(@model.get('dueDate')).format(App.DataHelper.dateFormats.us)
          @$el.addClass("due-today")

  App.Dashboard.RentalDuesWidgetItem
