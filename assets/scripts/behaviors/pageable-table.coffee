define ['backbone.validation', './initialize'], ->

  class PageableTable extends Marionette.Behavior

    events:
      "click .next":                           "onNextClick"
      "click .prev":                           "onPrevClick"
      "change input.pagination-panel-input":   "onInputChange"

    collectionEvents:
      sync: "updatePagination"

    hasNextPage:->
      if @view.collection.length < @view.collection.state.pageSize then false else true

    hasPrevPage:->
      if @view.collection.state.currentPage is 1 then false else true

    updateButton:(selector, disabled) ->
      @$(selector).removeClass('disabled')
      @$(selector).addClass('disabled') if disabled

    updatePagination: ->
      @$('.pagination-panel-input').val @view.collection.state.currentPage
      @updateButton ".next", !@hasNextPage()
      @updateButton ".prev", !@hasPrevPage()

    onNextClick: (e)->
      e.preventDefault()
      @view.collection.getNextPage()

    onPrevClick: (e)->
      e.preventDefault()
      @view.collection.getPreviousPage()

    onInputChange: (e)->
      unless /^[\d]+$/.test $(e.currentTarget).val()
        return toastr.error "Page Number is not a number"
      @view.collection.getPage parseInt($(e.currentTarget).val())

  window.Behaviors.PageableTable = PageableTable
