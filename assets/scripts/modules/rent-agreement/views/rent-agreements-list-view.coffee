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

      behaviors:
        PageableTable: {}

      regions:
        toolbarRegion:      "#toolbar"
        tableRegion:        "#table"

      templateHelpers: ->
        currentPage: @collection.state.currentPage
        nextStatus:  if @collection.length < @collection.state.pageSize then "disabled" else
        prevStatus:  if @collection.state.currentPage is 1 then "disabled" else ""

      onShow:->
        @toolbarRegion.show new ToolbarView(collection: @collection)
        @tableRegion.show new TableView(collection: @collection)

  App.CarRentAgreement.RentAgreementsListView
