define [
  './templates/line-items-template'
  './line-item-view'
  './../models/line-item-model'
], (template, LineItemView, LineItemModel)->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.LineItemsView extends Marionette.CompositeView
      className:          "collection-view line-items-view"
      template:           template
      childView:          LineItemView
      childViewContainer: ".line-items-container"

      events:
        'click .add-line-item': 'onAddLineItem'

      initialize: ->
        channel = Backbone.Radio.channel 'rent-agreements'
        channel.comply 'line:item:remove', @onRemoveLineItem, @

      onAddLineItem: (e)->
        @collection.push new LineItemModel()

      onRemoveLineItem: (model)->
        @collection.remove model

  App.CarRentAgreement.LineItemsView
