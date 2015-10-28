define ['./templates/rent-agreement-row-template'], (template)->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.RentAgreementRowView extends Marionette.ItemView
      className:            'item-view rent-agreement-row'
      tagName:              'tr'
      template:             template
      actionsInlineEnabled: false

      events:
        'click .extend-row':         'onExtendClick'
        'click .close-row':          'onCloseClick'
        'click .notes-row':          'onNotesClick'
        'click input[type=radio]':   'onRadioButtonClick'
        'click':                     'onClick'
        'click .view-tracking':      'onViewTracking'

      modelEvents:
        'change':   'onModelChanged'
        'selected': 'onSelect'

      templateHelpers: ->
        modelIndex:           @index
        actionsEnabled:       @actionsEnabled
        actionsInlineEnabled: @actionsInlineEnabled
        gpsTrackings:         @model.get 'gpsTrackings'
        selected:             @model.selected

      initialize: (options)->
        @index    = options.index
        @channel  = Backbone.Radio.channel 'rent-agreements'

      onModelChanged:->
        @render()
        @onShow()

      onShow:->
        @$el.addClass('deleted') if @model.get('status') is 'CLOSED'
        if moment().format(App.DataHelper.dateFormats.us) is moment(@model.get('dueDate')).format(App.DataHelper.dateFormats.us)
          @$el.addClass 'due-today'
        else if (moment().unix()*1000 > @model.get('dueDate')) and (@model.get('status') isnt 'CLOSED')
          @$el.addClass('past-due-date')

      onClick: (e)->
        return true if $(e.target).prop('tagName') in ['I', 'A', 'INPUT']
        App.Router.navigate "#rent-agreement/#{@model.get('invoiceID')}", trigger: true

      onSelect: (e) ->
        @$('input[type=radio]').prop 'checked', true unless @$('input[type=radio]').prop 'checked'

      onRadioButtonClick: (e) ->
        @model.select()

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
