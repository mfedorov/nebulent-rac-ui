define [
  './templates/deposits-list-template'
  './deposits-view'
],  (template, TableView) ->

  App.module "Deposits", (Module, App, Backbone, Marionette, $, _) ->

    class Module.DepositsListView extends Marionette.LayoutView
      className:  "layout-view deposit-list"
      template:   template

      behaviors:
        PageableTable: {}

      regions:
        tableRegion:        "#table"

      events:
        'click #list-refresh':      "onListRefresh"

      templateHelpers: ->
        currentPage: @collection.state.currentPage
        nextStatus:  if @collection.length < @collection.state.pageSize then "disabled" else
        prevStatus:  if @collection.state.currentPage is 1 then "disabled" else ""

      onShow:->
        @tableRegion.show new TableView(collection: @collection)

      onListRefresh: ->
        channel = Backbone.Radio.channel "deposits"
        channel.command "deposits:list:refresh"

  App.Deposits.DepositsListView
