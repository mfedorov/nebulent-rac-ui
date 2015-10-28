define ['./templates/list-toolbar-template', './rental-actions-view'], (template, RentalActionsView)->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.AgreementsListToolbarView extends Marionette.LayoutView
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

      regions:
        actionsRegion: '[data-region=actions-region]'

      collectionEvents:
        'select:one': 'onRentalSelected'

      templateHelpers: ->
        actionsEnabled: true

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

      onRentalSelected: ->
        @actionsRegion.show new RentalActionsView(model: @collection.selected or @collection.first())

  App.CarRentAgreement.AgreementsListToolbarView
