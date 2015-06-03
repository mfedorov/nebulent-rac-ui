define [
  './templates/rent-agreements-list-template'
  './rent-agreements-view'
  './agreements-pagination-view'
  './agreements-list-toolbar-view'
],  (template, TableView, PaginationView, ToolbarView) ->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.RentAgreementsListView extends Marionette.LayoutView
      className:  "layout-view agreements-list"
      template:   template

      regions:
        toolbarRegion:      "#toolbar"
        tableRegion:        "#table"
        paginationRegion:   "#pagination"

      initialize: (options)->
        @collection = options.collection
        window.agreements = @collection

      onShow:->
        @toolbarRegion.show new ToolbarView(collection: @collection)
        @tableRegion.show new TableView(collection: @collection)
        @paginationRegion.show new PaginationView(collection: @collection)

  App.CarRentAgreement.RentAgreementsListView
