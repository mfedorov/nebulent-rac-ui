define ['./vehicle-row-template'], (template)->

  App.module "Vehicles", (Module, App, Backbone, Marionette, $, _) ->

    class Module.VehicleRowView extends Marionette.ItemView
      className:  "item-view vehicle-row"
      tagName:    "tr"
      template: template

      initialize: (options)->
        @index = options.index

      templateHelpers: ->
        modelIndex: @index

  App.Vehicles.VehicleRowView
