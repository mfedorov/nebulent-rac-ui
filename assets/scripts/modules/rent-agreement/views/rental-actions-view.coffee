define ['./templates/rental-actions'], (template)->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.RentalActionsView extends Marionette.ItemView
      className: 'rental-actions'
      template:  template
      disabled: false

      events:
        'click .extend-row':         'onExtendClick'
        'click .close-row':          'onCloseClick'
        'click .notes-row':          'onNotesClick'
        'click input[type=radio]':   'onRadioButtonClick'
        'click .view-tracking':      'onViewTracking'

      initialize: ->
        @disabled = true unless @model
        @channel  = Backbone.Radio.channel 'rent-agreements'

      templateHelpers: ->
        disabled:     @disabled
        gpsTrackings: @model.get('gpsTrackings') or []

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

  App.CarRentAgreement.RentalActionsView
