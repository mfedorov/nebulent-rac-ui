define [
  './templates/rent-agreement-row-template'
  './rent-agreement-row-view'
], (template, RentAgreementRowView)->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.RentAgreementRowView extends RentAgreementRowView
      actionsInlineEnabled: false

      onExtendClick: (e)->
        e.preventDefault()
        @channel.command "widget:rent:agreement:extend", @model

      onCloseClick: (e)->
        e.preventDefault()
        @channel.command "widget:rent:agreement:close", @model

      onNotesClick: (e)->
        e.preventDefault()
        @channel.command "widget:rent:agreement:show:notes", @model

  App.CarRentAgreement.RentAgreementRowView
