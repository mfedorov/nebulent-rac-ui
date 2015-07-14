define ['./templates/list-toolbar-template'], (template)->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.AgreementsListToolbarView extends Marionette.ItemView
      className:  "item-view rent-agreemens-list-toolbar clearfix"
      template: template

      ui:
        searchQuery: '#rental-query'
        resetSearch: '.reset-search'

      events:
        "click    #rental-search"   :  "onSearch"
        'click    #list-refresh'    :  "onListRefresh"
        'keydown  @ui.searchQuery'  :  "onQueryKeydown"
        'change   @ui.searchQuery'  :  "onQueryChange"
        'click    @ui.resetSearch'  :  "onResetSearch"

      initialize: (options)->
        @collection = options.collection

      onSearch: ->
        @update()
        @collection.queryParams.search = @ui.searchQuery.val()
        @collection.getPage 1

      onListRefresh: ->
        channel = Backbone.Radio.channel "rent-agreements"
        channel.command "rentals:list:refresh"

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

  App.CarRentAgreement.AgreementsListToolbarView
