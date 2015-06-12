define ['./templates/rent-agreement-row-template'], (template)->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.RentAgreementRowView extends Marionette.ItemView
      className:  "item-view rent-agreement-row"
      tagName:    "tr"
      template: template

      events:
        "click .extend-row":  "onExtendClick"
        "click .close-row":   "onCloseClick"
        "click .notes-row":   "onNotesClick"
        "click":              "onClick"

      templateHelpers: ->
        modelIndex: @index

      initialize: (options)->
        @index = options.index
        @channel = Backbone.Radio.channel 'rent-agreements'
        @listenTo @model, "change", @onModelChanged, @

      onModelChanged:->
        @render()
        @onShow()

      onShow:->
        @$el.addClass('deleted') if @model.get('status') is "CLOSED"

      onClick: (e)->
        return true if $(e.target).prop('tagName') in ["I", "A"]

      onExtendClick: (e)->
        e.preventDefault()
        @channel.command "rent:agreement:extend", @model

      onCloseClick: (e)->
        e.preventDefault()
        @channel.command "rent:agreement:close", @model

      onNotesClick: (e)->
        e.preventDefault()
        @channel.command "rent:agreement:show:notes", @model

  App.CarRentAgreement.RentAgreementRowView
