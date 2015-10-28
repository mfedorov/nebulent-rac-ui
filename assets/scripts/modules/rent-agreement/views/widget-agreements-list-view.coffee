define [
  './templates/rent-agreements-list-template'
  './widget-agreements-view'
  './agreements-pagination-view'
  './list-toolbar-view'
],  (template, TableView, PaginationView, ToolbarView) ->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.WidgetRentalsListView extends Marionette.LayoutView
      className:  "layout-view widget-agreements-list"
      template:   template

  App.CarRentAgreement.WidgetRentalsListView
