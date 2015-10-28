define [
  './templates/vehicle-list-template'
  './vehicle-item-view'
], (template, VehicleItemView)->

  App.module "GpsTrackings", (Module, App, Backbone, Marionette, $, _)->

    class Module.VehicleListView extends Marionette.CompositeView
      className:          "composite-view vehicle-list"
      template:           template
      childView:          VehicleItemView
      childViewContainer: "tbody"

      events:
        "change .group-checkable": "onGroupCheck"

      onGroupCheck:(e)->
        return @collection.selectAll() if $(e.currentTarget).is(":checked")
        @collection.deselectAll()

  App.GpsTrackings.VehicleListView
