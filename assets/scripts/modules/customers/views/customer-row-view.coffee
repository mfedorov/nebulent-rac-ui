define [
  './customer-row-template'
], (template)->

  App.module "Customers", (Module, App, Backbone, Marionette, $, _) ->

    class Module.CustomerRowView extends Marionette.ItemView
      className: "item-view customer-row"
      tagName:   "tr"
      template:   template

      initialize: (options)->
        console.log "c row view"
        @index = options.index

      templateHelpers: ->
        modelIndex: @index

  App.Customers.CustomerRowView
