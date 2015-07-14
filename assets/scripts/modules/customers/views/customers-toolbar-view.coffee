define ['./templates/customers-toolbar-template'], (template)->

  App.module "Customers", (Module, App, Backbone, Marionette, $, _) ->

    class Module.CustomersToolbarView extends Marionette.ItemView
      className:  "item-view customers-list-toolbar clearfix"
      template: template

      ui:
        searchQuery: "#customers-query"
        resetSearch: '.reset-search'

      events:
        "click    #customers-search":  "onSearch"
        'click    #list-refresh'    :  "onListRefresh"
        'keydown  @ui.searchQuery'  :  "onQueryKeydown"
        'change   @ui.searchQuery'  :  "onQueryChange"
        'click    @ui.resetSearch'  :  "onResetSearch"


      initialize: (options)->
        @collection = options.collection

      onSearch: ->
        @update()
        @collection.queryParams.search = @$("#customers-query").val()
        @collection.getPage 1

      onListRefresh: ->
        channel = Backbone.Radio.channel "customers"
        channel.command "customers:list:refresh"

      onQueryKeydown: (e)->
        @onSearch() if e.which is 13
        @onResetSearch() if e.which is 27

      onQueryChange: ->
        @onSearch()

      update:->
        if @ui.searchQuery.val().length
          @ui.resetSearch.removeClass 'hidden'
        else
          @ui.resetSearch.addClass 'hidden'

      onResetSearch: ->
        @ui.searchQuery.val ''
        @ui.resetSearch.addClass 'hidden'
        @onSearch()

  App.Customers.CustomersToolbarView
