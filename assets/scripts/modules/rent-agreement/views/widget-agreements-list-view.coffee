define [
  './templates/rent-agreements-list-template'
  './widget-agreements-view'
  './widget-list-toolbar-view'
],  (template, TableView, ToolbarView) ->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.WidgetRentalsListView extends Marionette.LayoutView
      className:  "layout-view widget-agreements-list"
      template:   template
      options:
        enablePagination: false

      regions:
        toolbarRegion: "#toolbar"
        tableRegion:   "#table"

      templateHelpers: ->
        currentPage:      @collection.state.currentPage
        nextStatus:       if @collection.length < @collection.state.pageSize then "disabled" else
        prevStatus:       if @collection.state.currentPage is 1 then "disabled" else ""
        enablePagination: @options.enablePagination

      onShow:->
        @toolbarRegion.show new ToolbarView(collection: @collection)
        @tableRegion.show   new TableView(collection: @collection)
        @collection.selected?.deselect()
        @collection.first().select()

  App.CarRentAgreement.WidgetRentalsListView
