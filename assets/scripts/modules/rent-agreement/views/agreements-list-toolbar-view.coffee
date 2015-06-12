define ['./templates/list-toolbar-template'], (template)->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.AgreementsListToolbarView extends Marionette.ItemView
      className:  "item-view rent-agreemens-list-toolbar clearfix"
      template: template

      events:
        "click #rental-search":   "onSearch"
        'click #list-refresh':    "onListRefresh"

      initialize: (options)->
        @collection = options.collection

      onSearch: ->
        @collection.queryParams.search = @$("#rental-query").val()
        @collection.getPage 1

      onListRefresh: ->
        channel = Backbone.Radio.channel "rent-agreements"
        channel.command "rentals:list:refresh"

  App.CarRentAgreement.AgreementsListToolbarView
