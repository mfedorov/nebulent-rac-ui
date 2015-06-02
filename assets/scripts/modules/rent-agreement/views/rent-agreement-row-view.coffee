define ['./rent-agreement-row-template'], (template)->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.RentAgreementRowView extends Marionette.ItemView
      className:  "item-view rent-agreement-row"
      tagName:    "tr"
      template: template

      events:
        "click .extend-row":  "onExtendClick"
        "click .close-row":   "onCloseClick"
        "click":              "onClick"

      initialize: (options)->
        @index = options.index
        @channel = Backbone.Radio.channel 'rent-agreements'
        @listenTo @model, "change", @render, @

      templateHelpers: ->
        modelIndex: @index

      onClick: (e)->
        return true if $(e.target).prop('tagName') in ["I", "A"]
#        App.Router.navigate "#rent-agreement/#{@model.get('invoiceID')}", trigger: true

      onExtendClick: (e)->
        e.preventDefault()
        @channel.command "rent:agreement:extend", @model

      onCloseClick: (e)->
        e.preventDefault()
        @channel.command "rent:agreement:close", @model

  App.CarRentAgreement.RentAgreementRowView
