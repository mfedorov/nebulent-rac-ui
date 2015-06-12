define ['./templates/customers-toolbar-template'], (template)->

  App.module "Customers", (Module, App, Backbone, Marionette, $, _) ->

    class Module.CustomersToolbarView extends Marionette.ItemView
      className:  "item-view customers-list-toolbar clearfix"
      template: template

      events:
        "click #customers-search":  "onSearch"
        'click #list-refresh':      "onListRefresh"

      initialize: (options)->
        @collection = options.collection

      onSearch: ->
        @collection.queryParams.search = @$("#customers-query").val()
        @collection.getPage 1

      onListRefresh: ->
        channel = Backbone.Radio.channel "customers"
        channel.command "customers:list:refresh"

  App.Customers.CustomersToolbarView
