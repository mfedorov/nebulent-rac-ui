define [
  './templates/line-item-template'
], (template)->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.LineItemView extends Marionette.CompositeView
      className:          "item-view line-item-view"
      template:           template

      bindings:
        'input[name=description]':  observe: "description"
        'input[name=lineAmount]':   observe: "lineAmount"

      events:
        'click .remove-phone': 'onRemoveClick'

      onShow: ->
        @stickit()

      onRemoveClick: ->
        channel = Backbone.Radio.channel 'rent-agreements'
        channel.command 'line:item:remove', @model

  App.CarRentAgreement.LineItemView
