define [
  './templates/vehicle-item-template'
], (template)->

  App.module "GpsTrackings", (Module, App, Backbone, Marionette, $, _)->

    class Module.VehicleItemView extends Marionette.ItemView
      template: template
      tagName: "tr"
      className: "gradeX odd"
      attributes:
        "role": "row"

      events:
        "change input" :  "onInputChange"

      initialize: ->
        @listenTo @model, "selected",   => @selected()
        @listenTo @model, "deselected", => @selected()

      onInputChange: (e)->
        return @model.select() if $(e.currentTarget).is(":checked")
        @model.deselect()

      selected:->
        @$('input').prop 'checked', @model.selected

  App.GpsTrackings.VehicleItemView
