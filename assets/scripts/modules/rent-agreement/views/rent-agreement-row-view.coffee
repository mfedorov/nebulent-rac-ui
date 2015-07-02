define ['./templates/rent-agreement-row-template'], (template)->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.RentAgreementRowView extends Marionette.ItemView
      className:      "item-view rent-agreement-row"
      tagName:        "tr"
      template:       template
      actionsEnabled: true

      events:
        "click .extend-row":    "onExtendClick"
        "click .close-row":     "onCloseClick"
        "click .notes-row":     "onNotesClick"
        "click":                "onClick"
        "click .view-tracking": "onViewTracking"

      templateHelpers: ->
        modelIndex:     @index
        actionsEnabled: @actionsEnabled
        gpsTrackings:   @model.get 'gpsTrackings'

      initialize: (options)->
        @index = options.index
        @actionsEnabled = options.actionsEnabled if "actionsEnabled" in _.keys(options)
        @channel = Backbone.Radio.channel 'rent-agreements'
        @listenTo @model, "change", @onModelChanged, @

      onModelChanged:->
        @render()
        @onShow()

      onShow:->
        @$el.addClass('deleted') if @model.get('status') is "CLOSED"
        if moment().format(App.DataHelper.dateFormats.us) is moment(@model.get('dueDate')).format(App.DataHelper.dateFormats.us)
          @$el.addClass("due-today")

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

      onViewTracking:(e)->
        e.preventDefault()
        channel = Backbone.Radio.channel "rent-agreements"
        channel.command "show:rental:movements", @model.get('gpsTrackings')

  App.CarRentAgreement.RentAgreementRowView
