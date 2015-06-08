define [
  './templates/vehicles-need-oil-change'
], (template)->

  App.module "Dashboard", (Module, App, Backbone, Marionette, $, _) ->

    class Module.WidgetItem extends Marionette.ItemView
      className:  "widget-item-view dashboard"
      tagName:    "tr"
      template:   template

      initialize: (options)->
        @model.set 'modelIndex', options.index

  App.Dashboard.WidgetItem
