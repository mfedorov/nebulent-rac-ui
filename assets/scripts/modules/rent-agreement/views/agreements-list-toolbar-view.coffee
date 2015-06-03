define ['./templates/list-toolbar-template'], (template)->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.AgreementsListToolbarView extends Marionette.ItemView
      className:  "item-view rent-agreemens-list-toolbar clearfix"
      template: template

      events:
        "click #rental-search": "onSearch"

      initialize: (options)->
        @collection = options.collection

      onSearch: ->
        @collection.queryParams.search = @$("#rental-query").val()
        @collection.getPage 1

  App.CarRentAgreement.AgreementsListToolbarView
