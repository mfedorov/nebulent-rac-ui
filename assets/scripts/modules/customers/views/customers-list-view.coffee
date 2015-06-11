define [
  './templates/customer-list-template'
  './customers-view'
  './customers-toolbar-view'
],  (template, TableView, ToolbarView) ->

  App.module "Customers", (Module, App, Backbone, Marionette, $, _) ->

    class Module.CustomerListView extends Marionette.LayoutView
      className:  "layout-view customer-list"
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

  App.Customers.CustomerListView
