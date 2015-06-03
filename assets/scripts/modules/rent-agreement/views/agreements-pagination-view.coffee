define [
  './templates/agreements-pagination-template'
],  (template, TableView) ->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.AgreementsPagination extends Marionette.ItemView
      className:  "item-view agreements-pagination right"
      template:   template

      events:
        "click .next":    "onNextClick"
        "click .prev":    "onPrevClick"
        "change input":   "onInputChange"

      templateHelpers: ->
        currentPage: @collection.state.currentPage
        nextStatus: unless @hasNextPage() then "disabled" else ""
        prevStatus: unless @hasPrevPage() is 1 then "disabled" else ""

      initialize:(options)->
        @collection = options.collection
        @listenTo @collection, "sync", @update

      hasNextPage:->
        if @collection.length < @collection.state.pageSize then false else true

      hasPrevPage:->
        if @collection.state.currentPage is 1 then false else true

      updateButton:(selector, disabled) ->
        @$(selector).removeClass('disabled')
        @$(selector).addClass('disabled') if disabled

      update:->
        @$('.pagination-panel-input').val @collection.state.currentPage
        @updateButton ".next", !@hasNextPage()
        @updateButton ".prev", !@hasPrevPage()

      onNextClick: (e)->
        e.preventDefault()
        @collection.getNextPage()

      onPrevClick: (e)->
        e.preventDefault()
        @collection.getPreviousPage()

      onInputChange: (e)->
        unless /^[\d]+$/.test $(e.currentTarget).val()
          return toastr.error "Page Number is not a number"
        @collection.getPage parseInt($(e.currentTarget).val())

  App.CarRentAgreement.AgreementsPagination
